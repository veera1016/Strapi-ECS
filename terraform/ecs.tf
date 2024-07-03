# ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = "Ashok-strapi-cluster"
}

# ECS Execution Role (Checking if it exists)
data "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"
  # Use `ignore_errors` to continue if the role does not exist
  ignore_errors = true
}

# ECS Task Role (Checking if it exists)
data "aws_iam_role" "ecs_task_role" {
  name = "ecs_task_role"
  ignore_errors = true
}

# ECS Execution Role (Creating if it doesn't exist)
resource "aws_iam_role" "ecs_execution_role" {
  count = data.aws_iam_role.ecs_execution_role.arn == "" ? 1 : 0
  name  = "ecs_execution_role"
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

# Attach Execution Policy
resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  count      = data.aws_iam_role.ecs_execution_role.arn == "" ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = coalesce(aws_iam_role.ecs_execution_role[0].name, data.aws_iam_role.ecs_execution_role.name)
}

# ECS Task Role (Creating if it doesn't exist)
resource "aws_iam_role" "ecs_task_role" {
  count = data.aws_iam_role.ecs_task_role.arn == "" ? 1 : 0
  name  = "ecs_task_role"
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

# ECS Task Definition
resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  execution_role_arn       = coalesce(aws_iam_role.ecs_execution_role[0].arn, data.aws_iam_role.ecs_execution_role.arn)
  task_role_arn            = coalesce(aws_iam_role.ecs_task_role[0].arn, data.aws_iam_role.ecs_task_role.arn)
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

# ECS Service
resource "aws_ecs_service" "strapi" {
  name            = "Ashok-strapi-service"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.strapi.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = [aws_subnet.this.id]
    security_groups  = [aws_security_group.ecs.id]
    assign_public_ip = true
  }
}
