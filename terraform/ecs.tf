resource "aws_ecs_cluster" "this" {
  name = "Ashok-strapi-cluster"
}

resource "aws_ecs_task_definition" "strapi" {
  family                   = "strapi-task"
  execution_role_arn       = "arn:aws:iam::533266978173:role/ECS-execution-role"
  task_role_arn            = "arn:aws:iam::533266978173:role/ECS-task-role"
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
