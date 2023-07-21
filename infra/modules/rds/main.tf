resource "aws_db_subnet_group" "this" {

  name       = "${var.env_code}-${var.db_identifier}-subnet-group"
  subnet_ids = var.subnet_ids
}


resource "aws_db_instance" "this" {
  db_name                = var.db_name
  allocated_storage      = var.db_allocated_storage
  engine                 = var.db_engine_type
  engine_version         = var.db_engine_version
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.pass
  storage_type           = var.db_storage_type
  identifier             = var.db_identifier
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
  port                   = var.db_port
  vpc_security_group_ids = [aws_security_group.db_sg.id]
}


resource "aws_security_group" "db_sg" {
  name        = "allow_db_connection"
  description = "Allow inbound trafic for db"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name = "allow_${var.db_engine_type}"
  }
}


