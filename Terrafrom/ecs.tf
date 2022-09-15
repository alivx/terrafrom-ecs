resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = join("-", ["ecs-cluster", var.company])
}


resource "aws_ecs_task_definition" "aws-ecs-task-wp" {
  family                   = "ecs-cyloid-wp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = "arn:aws:iam::${var.account_id}:role/ecsTaskExecutionRole"
  memory                   = 1024
  cpu                      = 512
  container_definitions    = <<EOF
        [
          {
            "name": "ecr-cycloid",
            "image": "${var.account_id}.dkr.ecr.us-east-1.amazonaws.com/ecr-cycloid:latest",
            "networkMode": "awsvpc",
            "portMappings": [
              {
                "containerPort": 80,
                "protocol": "tcp"
              }
            ],
            "requiresCompatibilities": [
                "FARGATE"
            ]
          }
        ]
        EOF
}


resource "aws_ecs_service" "aws-ecs-service" {
  name            = join("-", ["ecs-service", var.company])
  cluster         = aws_ecs_cluster.aws-ecs-cluster.arn
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.aws-ecs-task-wp.arn
  desired_count   = 2

  network_configuration {
    subnets          = [aws_subnet.private-subnet.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.wp-tg.arn
    container_name   = "ecr-cycloid"
    container_port   = var.container_port
  }
  depends_on = [
    aws_lb_target_group.wp-tg,
  ]
}

