provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "backend-s3-my-profile-pjt"
    key            = "statefile.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}

## fargate
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family                = "my-task-definition"
  container_definitions = jsonencode([
    {
      name      = "my-container"
      image      = "docker.io/sivagane/my-profile-web-site:latest"
      cpu        = 10
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
}

resource "aws_ecs_service" "ecs_service" {
  name            = "my-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type      = "FARGATE"

  network_configuration {
    security_groups = ["sg-0e306d4c54dd7a765"]
    subnets         = ["subnet-0ca1cb74c88b623ea", "subnet-0ff00305269ac0f85"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "my-container"
    container_port   = 80
  }
}

## alb

resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0e306d4c54dd7a765"]
  subnets            = ["subnet-0ca1cb74c88b623ea", "subnet-0ff00305269ac0f85"]
}
# tg
resource "aws_lb_target_group" "target_group" {
  name        = "my-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = "vpc-09cfa5d8e08904003"
}

#listners 
resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

## iam role

resource "aws_iam_role" "ecs_task_execution_role" {
  name        = "ecs-task-execution-role"
  description = "ECS task execution role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}