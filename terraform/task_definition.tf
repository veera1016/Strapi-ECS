resource "aws_ecs_task_definition" "Ashok-task" {
  family                   = "Ashok-task"
  execution_role_arn       = aws_iam_role.example_task_execution_role.arn
  task_role_arn            = aws_iam_role.example_task_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  container_definitions = jsonencode([{
    name      = "strapi-container"
    image     = "veera1016/strapi:1.0.0"  # Replace with your Docker image URL
    essential = true
    portMappings = [{
      containerPort = 1337
      hostPort      = 1337
    }]
  }])

  memory = "512"
  cpu    = "256"
}

resource "aws_iam_role" "Ashok_task_execution_role" {
  name = "Ashok-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "example_task_execution_policy" {
  role       = aws_iam_role.example_task_execution_role.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "Ashok_task_role" {
  name = "Ashok-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}
