#########################
# VPC
#########################
resource "aws_vpc" "test_codepipeline" {
  cidr_block = "10.0.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "test_codepipeline"
  }
}

#########################
# Subnet
#########################
resource "aws_subnet" "public-subnet-1a" {
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-1a"
  vpc_id                  = aws_vpc.test_codepipeline.id
  map_public_ip_on_launch = true
  tags = {
    Name = "test_codepipeline_public_1a"
  }
}

resource "aws_subnet" "public-subnet-1c" {
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-1c"
  vpc_id                  = aws_vpc.test_codepipeline.id
  map_public_ip_on_launch = true
  tags = {
    Name = "test_codepipeline_public_1c"
  }
}

#########################
# Route Table
#########################
resource "aws_default_route_table" "public" {
  tags = {
    Name = "public-rt"
  }
  default_route_table_id = aws_vpc.test_codepipeline.default_route_table_id
}

resource "aws_route" "public" {
  route_table_id         = aws_default_route_table.public.id
  gateway_id             = aws_internet_gateway.test_codepipeline.id
  destination_cidr_block = "0.0.0.0/0"
}

#########################
# IGW
#########################
resource "aws_internet_gateway" "test_codepipeline" {
  vpc_id = aws_vpc.test_codepipeline.id

  tags = {
    Name = "test_codepipeline"
  }
}
