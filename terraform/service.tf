resource "aws_ecs_service" "example" {
  name            = "Ashok-service"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-06c0ebdba39ce82c3"]  # Replace with your subnet ID(s)
    security_groups  = ["sg-0f9b1780ba01aca42"]      # Replace with your security group ID
    assign_public_ip = true
  }
}
