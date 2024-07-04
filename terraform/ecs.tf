provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "ecs_execution_role_new_unique" {
  name = "ecs_execution_role_new_unique"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.ecs_execution_role_new_unique.name
}

resource "aws_iam_role" "ecs_task_role_new_unique" {
  name = "ecs_task_role_new_unique"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "ecs" {
  name_prefix = "ecs-security-group"
  vpc_id      = aws_vpc.this.id

  ingress {
    from_port   = 1337
    to_port     = 1337
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

resource "aws_ecs_cluster" "this" {
  name = "Ashok-strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  execution_role_arn       = aws_iam_role.ecs_execution_role_new_unique.arn
  task_role_arn            = aws_iam_role.ecs_task_role_new_unique.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsonencode([{
    name      = "strapi"
    image     = "veera1016/strapi:1.0.0"
    essential = true
    portMappings = [
      {
        containerPort = 1337
        hostPort      = 1337
      }
    ]
  }])
}

resource "aws_eip" "strapi" {
  vpc = true
}

resource "aws_ecs_service" "strapi" {
  name            = "strapi-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.this.id]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
  depends_on = [aws_ecs_task_definition.strapi]
}

resource "aws_route53_zone" "main" {
  name = "contentecho.in"  # Replace with your domain
}

resource "aws_route53_record" "strapi" {
  zone_id = aws_route53_zone.main.id
  name    = "togaruashok1996-ecs"  # Replace with your desired subdomain
  type    = "A"
  ttl     = 300
  records = [aws_eip.strapi.public_ip]
}

output "route53_zone_id" {
  value = aws_route53_zone.main.id
}
