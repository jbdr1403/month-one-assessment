// cSpell:ignore techcorp
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.23.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# --------------------
# VPC
# --------------------
resource "aws_vpc" "techcorp_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "techcorp-vpc"
  }
}

# --------------------
# PUBLIC SUBNETS
# --------------------
resource "aws_subnet" "techcorp_public_subnet_1" {
  vpc_id                  = aws_vpc.techcorp_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = var.azs[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "techcorp-public-subnet-1"
  }
}

resource "aws_subnet" "techcorp_public_subnet_2" {
  vpc_id                  = aws_vpc.techcorp_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = var.azs[1]
  map_public_ip_on_launch = true

  tags = {
    Name = "techcorp-public-subnet-2"
  }
}

# --------------------
# PRIVATE SUBNETS
# --------------------
resource "aws_subnet" "techcorp_private_subnet_1" {
  vpc_id            = aws_vpc.techcorp_vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = var.azs[0]

  tags = {
    Name = "techcorp-private-subnet-1"
  }
}

resource "aws_subnet" "techcorp_private_subnet_2" {
  vpc_id            = aws_vpc.techcorp_vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = var.azs[1]

  tags = {
    Name = "techcorp-private-subnet-2"
  }
}

# --------------------
# INTERNET GATEWAY
# --------------------
resource "aws_internet_gateway" "techcorp_igw" {
  vpc_id = aws_vpc.techcorp_vpc.id

  tags = {
    Name = "techcorp-igw"
  }
}

# --------------------
# ELASTIC IPs FOR NAT GATEWAYS
# --------------------
resource "aws_eip" "nat_eip_1" {
  domain = "vpc"

  tags = {
    Name = "techcorp-nat-eip-1"
  }
}

resource "aws_eip" "nat_eip_2" {
  domain = "vpc"

  tags = {
    Name = "techcorp-nat-eip-2"
  }
}

# --------------------
# NAT GATEWAYS
# --------------------
resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.techcorp_public_subnet_1.id
  depends_on    = [aws_internet_gateway.techcorp_igw]

  tags = {
    Name = "techcorp-nat-gw-1"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_eip_2.id
  subnet_id     = aws_subnet.techcorp_public_subnet_2.id
  depends_on    = [aws_internet_gateway.techcorp_igw]

  tags = {
    Name = "techcorp-nat-gw-2"
  }
}

# --------------------
# PUBLIC ROUTE TABLE
# --------------------
resource "aws_route_table" "techcorp_public_rt" {
  vpc_id = aws_vpc.techcorp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.techcorp_igw.id
  }

  tags = {
    Name = "techcorp-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc_1" {
  subnet_id      = aws_subnet.techcorp_public_subnet_1.id
  route_table_id = aws_route_table.techcorp_public_rt.id
}

resource "aws_route_table_association" "public_rt_assoc_2" {
  subnet_id      = aws_subnet.techcorp_public_subnet_2.id
  route_table_id = aws_route_table.techcorp_public_rt.id
}

# --------------------
# PRIVATE ROUTE TABLE 1
# --------------------
resource "aws_route_table" "techcorp_private_rt_1" {
  vpc_id = aws_vpc.techcorp_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_1.id
  }

  tags = {
    Name = "techcorp-private-rt-1"
  }
}

resource "aws_route_table_association" "private_rt_assoc_1" {
  subnet_id      = aws_subnet.techcorp_private_subnet_1.id
  route_table_id = aws_route_table.techcorp_private_rt_1.id
}

# --------------------
# PRIVATE ROUTE TABLE 2
# --------------------
resource "aws_route_table" "techcorp_private_rt_2" {
  vpc_id = aws_vpc.techcorp_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw_2.id
  }

  tags = {
    Name = "techcorp-private-rt-2"
  }
}

resource "aws_route_table_association" "private_rt_assoc_2" {
  subnet_id      = aws_subnet.techcorp_private_subnet_2.id
  route_table_id = aws_route_table.techcorp_private_rt_2.id
}

# --------------------
# NETWORK ACLs (explicit, allow-all)
# --------------------

# Public NACL for public subnets
resource "aws_network_acl" "public_nacl" {
  vpc_id = aws_vpc.techcorp_vpc.id

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "techcorp-public-nacl"
  }
}

resource "aws_network_acl_association" "public_nacl_assoc_1" {
  subnet_id      = aws_subnet.techcorp_public_subnet_1.id
  network_acl_id = aws_network_acl.public_nacl.id
}

resource "aws_network_acl_association" "public_nacl_assoc_2" {
  subnet_id      = aws_subnet.techcorp_public_subnet_2.id
  network_acl_id = aws_network_acl.public_nacl.id
}

# Private NACL for private subnets
resource "aws_network_acl" "private_nacl" {
  vpc_id = aws_vpc.techcorp_vpc.id

  ingress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = "-1"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "techcorp-private-nacl"
  }
}

resource "aws_network_acl_association" "private_nacl_assoc_1" {
  subnet_id      = aws_subnet.techcorp_private_subnet_1.id
  network_acl_id = aws_network_acl.private_nacl.id
}

resource "aws_network_acl_association" "private_nacl_assoc_2" {
  subnet_id      = aws_subnet.techcorp_private_subnet_2.id
  network_acl_id = aws_network_acl.private_nacl.id
}

# -------------------------------
# SECURITY GROUPS
# -------------------------------

# 1. Bastion Security Group
resource "aws_security_group" "bastion_sg" {
  name        = "techcorp-bastion-sg"
  description = "Allow SSH only from my IP"
  vpc_id      = aws_vpc.techcorp_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "techcorp-bastion-sg"
  }
}

# 2. Web Security Group
resource "aws_security_group" "web_sg" {
  name        = "techcorp-web-sg"
  description = "Allow web traffic and SSH from bastion"
  vpc_id      = aws_vpc.techcorp_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "techcorp-web-sg"
  }
}

# 3. Database Security Group
resource "aws_security_group" "db_sg" {
  name        = "techcorp-db-sg"
  description = "Allow DB access only from web servers"
  vpc_id      = aws_vpc.techcorp_vpc.id

  # NOTE: Assignment says MySQL 3306; your user_data runs Postgres, usually 5432.
  # If your DB is Postgres, change 3306 -> 5432 to match.
  ingress {
    description     = "DB access from web servers"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "techcorp-db-sg"
  }
}

# -------------------------------
# AMI
# -------------------------------
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Official Amazon Linux AMIs
}

# -------------------------------
# INSTANCES
# -------------------------------

# Bastion Host
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.bastion_instance_type
  subnet_id              = aws_subnet.techcorp_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  key_name               = var.key_pair_name

  tags = {
    Name = "techcorp-bastion"
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion.id

  tags = {
    Name = "techcorp-bastion-eip"
  }
}

# Web Servers
resource "aws_instance" "web_server_1" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.web_instance_type
  subnet_id              = aws_subnet.techcorp_private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_pair_name
  user_data              = file("user_data/web_server_setup.sh")

  tags = {
    Name = "techcorp-web-server-1"
  }
}

resource "aws_instance" "web_server_2" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.web_instance_type
  subnet_id              = aws_subnet.techcorp_private_subnet_2.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  key_name               = var.key_pair_name
  user_data              = file("user_data/web_server_setup.sh")

  tags = {
    Name = "techcorp-web-server-2"
  }
}

# DB Server
resource "aws_instance" "db_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.db_instance_type
  subnet_id              = aws_subnet.techcorp_private_subnet_1.id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name               = var.key_pair_name
  user_data              = file("user_data/db_server_setup.sh")

  tags = {
    Name = "techcorp-db-server"
  }
}

# -------------------------------
# LOAD BALANCER + TARGET GROUP
# -------------------------------
resource "aws_lb_target_group" "techcorp_tg" {
  name        = "techcorp-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.techcorp_vpc.id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "techcorp-tg"
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_1" {
  target_group_arn = aws_lb_target_group.techcorp_tg.arn
  target_id        = aws_instance.web_server_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "tg_attachment_2" {
  target_group_arn = aws_lb_target_group.techcorp_tg.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}

resource "aws_security_group" "alb_sg" {
  name        = "techcorp-alb-sg"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = aws_vpc.techcorp_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "techcorp-alb-sg"
  }
}

resource "aws_lb" "techcorp_alb" {
  name               = "techcorp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets = [
    aws_subnet.techcorp_public_subnet_1.id,
    aws_subnet.techcorp_public_subnet_2.id
  ]

  tags = {
    Name = "techcorp-alb"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.techcorp_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.techcorp_tg.arn
  }
}
