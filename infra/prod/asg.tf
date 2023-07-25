data "template_file" "this" {
  template = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y apache2
sudo apt install -y php libapache2-mod-php php-mysql
sudo apt install -y  php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip
sudo systemctl start apache2.service
sudo systemctl enable apache2.service
sudo -i 
cat <<EOT>/etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
      # The ServerName directive sets the request scheme, hostname and port that
      # the server uses to identify itself. This is used when creating
      # redirection URLs. In the context of virtual hosts, the ServerName
      # specifies what hostname must appear in the request's Host: header to
      # match this virtual host. For the default virtual host (this file) this
      # value is not decisive as it is used as a last resort host regardless.
      # However, you must set it for any further virtual host explicitly.
      #ServerName www.example.com

      ServerAdmin admin@localhost
      DocumentRoot /var/www/wordpress

      # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
      # error, crit, alert, emerg.
      # It is also possible to configure the loglevel for particular
      # modules, e.g.
      #LogLevel info ssl:warn

      ErrorLog $APACHE_LOG_DIR/error.log
      CustomLog $APACHE_LOG_DIR/access.log combined

      # For most configuration files from conf-available/, which are
      # enabled or disabled at a global level, it is possible to
      # include a line for only one particular virtual host. For example the
      # following line enables the CGI configuration for this host only
      # after it has been globally disabled with "a2disconf".
      #Include conf-available/serve-cgi-bin.conf
<Directory /var/www/wordpress/>
      AllowOverride All
</Directory>
</VirtualHost>
EOT
cd /var/www
wget -c http://wordpress.org/latest.tar.gz
tar -xzvf latest.tar.gz 

sed -i 's/database_name_here/${module.rds.db_name}/g' wordpress/wp-config-sample.php
sed -i 's/username_here/${module.rds.db_username}/g' wordpress/wp-config-sample.php
sed -i 's/localhost/${module.rds.db_host}/g' wordpress/wp-config-sample.php
sed -i 's/password_here/${module.rds.db_pass}/g' wordpress/wp-config-sample.php

mv wordpress/wp-config-sample.php wordpress/wp-config.php
sudo apt install nfs-common -y
mkdir /uploads
mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.this.dns_name}:/ /uploads
chown www-data:www-data /uploads
rm -rf /var/www/wordpress/wp-content/uploads
ln -s /uploads /var/www/wordpress/wp-content/uploads
systemctl restart apache2.service
EOF
}

resource "aws_launch_template" "this" {
  name = "${var.env_code}-wordpress-lt"
  iam_instance_profile {

  }
  image_id               = "ami-0989fb15ce71ba39e"
  instance_type          = "t3.micro"
  key_name               = data.aws_key_pair.example.key_name
  user_data              = base64encode(data.template_file.this.rendered)
  vpc_security_group_ids = [aws_security_group.asg_sg.id]
}
resource "aws_autoscaling_group" "this" {
  name                = "${local.def_tag}-wordpress-cluster"
  min_size            = 1
  max_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = local.front_private_subnets_id
  target_group_arns   = [aws_lb_target_group.this.arn]
  launch_template {
    id      = aws_launch_template.this.id
    version = "$Latest"
  }
}

resource "aws_security_group" "asg_sg" {
  name        = "allow_HTTP_${local.def_tag}"
  description = "Allow HTTP connection for application load balancer"
  vpc_id      = local.vpc_id
  ingress {
    description = "HTTP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_autoscaling_policy" "avg_cpu_target" {
  name                   = "${local.def_tag}-avg-cpu-greater-than"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.id
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }

}
