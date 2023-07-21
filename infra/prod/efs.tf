resource "aws_efs_file_system" "this" {
  creation_token   = "efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  tags = {
    Name = "EFS-${local.def_tag}"
  }
}

resource "aws_efs_mount_target" "this" {
  count           = length(local.front_private_subnets_id)
  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = local.front_private_subnets_id[count.index]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_security_group" "efs" {
  name        = "efs-sg"
  description = "Allos inbound efs traffic from ec2"
  vpc_id      = local.vpc_id

  ingress {

    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    security_groups = [aws_security_group.asg_sg.id]
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
  }
}
