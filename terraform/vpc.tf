# Existing VPC
data "aws_vpc" "existing" {
  default = true
}

# Subnet in existing VPC
resource "aws_subnet" "this" {
  vpc_id            = data.aws_vpc.existing.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

# Security Group
resource "aws_security_group" "ecs" {
  vpc_id = data.aws_vpc.existing.id

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
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
}
