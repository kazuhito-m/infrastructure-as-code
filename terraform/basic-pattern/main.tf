variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "region" {
    default = "ap-northeast-1"
}
 
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
