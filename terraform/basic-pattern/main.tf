# 予め（手動で作成して）必要なもの
# - ACLで証明書
# - EC2インスタンス用のキーペア

variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
    default = "ap-northeast-1"
}
variable "key_pair_name" {}

provider "aws" {
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region = "${var.region}"
}

resource "aws_vpc" "VpcDevelop" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = "true"
    enable_dns_hostnames = "false"
    tags {
      Name = "vpc-develop"
    }
}

resource "aws_subnet" "SbnApAza" {
  vpc_id     = "${aws_vpc.VpcDevelop.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.11.0/24"
  tags { Name = "sbn-ap-aza" }
}

resource "aws_subnet" "SbnApAzc" {
  vpc_id     = "${aws_vpc.VpcDevelop.id}"
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.12.0/24"
  tags { Name = "sbn-ap-azc" }
}

resource "aws_subnet" "SbnDbAza" {
  vpc_id     = "${aws_vpc.VpcDevelop.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.21.0/24"
  tags { Name = "sbn-db-aza" }
}

resource "aws_subnet" "SbnDbAzc" {
  vpc_id     = "${aws_vpc.VpcDevelop.id}"
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.22.0/24"
  tags { Name = "sbn-db-azc" }
}

resource "aws_subnet" "SbnNatAza" {
  vpc_id     = "${aws_vpc.VpcDevelop.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.81.0/24"
  tags { Name = "sbn-nat-aza" }
}

resource "aws_subnet" "SbnMaintenanceAza" {
  vpc_id     = "${aws_vpc.VpcDevelop.id}"
  availability_zone = "ap-northeast-1a"
  cidr_block = "10.0.91.0/24"
  tags { Name = "sbn-maintenance-aza" }
}

resource "aws_internet_gateway" "IgwRouter01" {
    vpc_id = "${aws_vpc.VpcDevelop.id}"
    tags { Name = "igw-router01" }
}

resource "aws_eip" "EipNat" {
  vpc = true
}

resource "aws_nat_gateway" "NgwPublic01" {
  allocation_id = "${aws_eip.EipNat.id}"
  subnet_id     = "${aws_subnet.SbnNatAza.id}"
  tags { Name = "ngw-public01" }
}

resource "aws_route_table" "RtbPublic01" {
  vpc_id     = "${aws_vpc.VpcDevelop.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IgwRouter01.id}"
  }
  tags { Name = "rtb-public01" }
}
resource "aws_route_table_association" "RtbPublic01Rta01" {
  subnet_id      = "${aws_subnet.SbnApAza.id}"
  route_table_id = "${aws_route_table.RtbPublic01.id}"
}
resource "aws_route_table_association" "RtbPublic01Rta02" {
  subnet_id      = "${aws_subnet.SbnApAzc.id}"
  route_table_id = "${aws_route_table.RtbPublic01.id}"
}
resource "aws_route_table_association" "RtbPublic01Rta03" {
  subnet_id      = "${aws_subnet.SbnMaintenanceAza.id}"
  route_table_id = "${aws_route_table.RtbPublic01.id}"
}

resource "aws_route_table" "RtbNat01" {
  vpc_id     = "${aws_vpc.VpcDevelop.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IgwRouter01.id}"
  }
  tags { Name = "rtb-nat01" }
}
resource "aws_route_table_association" "RtbNat01Rta01" {
  subnet_id      = "${aws_subnet.SbnNatAza.id}"
  route_table_id = "${aws_route_table.RtbNat01.id}"
}

resource "aws_security_group" "ScgAp" {
  name        = "scg-ap"
  description = "Application role security group."
  vpc_id      = "${aws_vpc.VpcDevelop.id}"
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "6"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags { Name = "scg-ap" }
}

resource "aws_security_group" "ScgDb" {
  name        = "scg-db"
  description = "DB role security group."
  vpc_id      = "${aws_vpc.VpcDevelop.id}"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags { Name = "scg-db" }
}

resource "aws_security_group" "ScgAlb" {
  name        = "scg-alb"
  description = "Security Group for Application Load Barancer."
  vpc_id      = "${aws_vpc.VpcDevelop.id}"
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags { Name = "scg-alb" }
}

resource "aws_security_group" "ScgMaintenance" {
  name        = "scg-maintenance"
  description = "Security Group for maintenance."
  vpc_id      = "${aws_vpc.VpcDevelop.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
  tags { Name = "scg-maintenance" }
}

resource "aws_db_subnet_group" "DbSbnGpAza" {
  name       = "db-sbn-gp-aza"
  description = "DB Subnet Group AZ A"
  subnet_ids = ["${aws_subnet.SbnDbAza.id}", "${aws_subnet.SbnDbAzc.id}"]
  tags { Name = "db-sbn-gp-aza" }
}

resource "aws_db_instance" "RdsPeelsDevelop" {
  allocated_storage    = 10
  storage_type         = "gp2" # standard, gp2, io1
  engine               = "postgres"
  engine_version       = "10.1"
  instance_class       = "db.t2.micro"
  multi_az             = true
  publicly_accessible  = false
  identifier           = "rds-peels-develop"
  name                 = "peels_develop"
  username             = "peels_user"
  password             = "eFHni4qTUPLUQM2wepK7yawTFuvVfnmd"
  db_subnet_group_name = "db-sbn-gp-aza"
  parameter_group_name = "default.postgres10"
  vpc_security_group_ids =["${aws_security_group.ScgDb.id}"]
  tags { Name = "rds-peels-staging" }
}

resource "aws_instance" "Ec2Maintenance01Aza" {
  ami           = "ami-c2680fa4"
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-1a"
  subnet_id     = "${aws_subnet.SbnMaintenanceAza.id}"
  vpc_security_group_ids = ["${aws_security_group.ScgMaintenance.id}"]
  associate_public_ip_address = true
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags {
    Name = "ec2-maintenance01-aza"
  }
  key_name = "${var.key_pair_name}"
}

resource "aws_instance" "Ec2Ap01Aza" {
  ami           = "ami-c2680fa4"
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-1a"
  subnet_id     = "${aws_subnet.SbnApAza.id}"
  vpc_security_group_ids = ["${aws_security_group.ScgAp.id}"]
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags {
    Name = "ec2-ap01-aza"
  }
  key_name = "${var.key_pair_name}"
}

resource "aws_instance" "Ec2Ap02Azc" {
  ami           = "ami-c2680fa4"
  instance_type = "t2.micro"
  availability_zone = "ap-northeast-1c"
  subnet_id     = "${aws_subnet.SbnApAzc.id}"
  vpc_security_group_ids = ["${aws_security_group.ScgAp.id}"]
  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags {
    Name = "ec2-ap02-azc"
  }
  key_name = "${var.key_pair_name}"
}
