provider "aws" {
  region = "ca-central-1"  # Change to your desired AWS region
}

# Create an ECS cluster
resource "aws_ecs_cluster" "Ashok" {
  name = "Ashok-cluster"
}
