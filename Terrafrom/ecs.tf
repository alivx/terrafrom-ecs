resource "aws_ecs_cluster" "aws-ecs-cluster" {
  name = join("-", ["ecs-cluster", var.company])
}

resource "aws_ecs_task_definition" "aws-ecs-task-wp" {
  family                   = "cyloid-wp-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  memory                   = 1024
  cpu                      = 512
  container_definitions    = <<EOF
      [
          {
              "name": "ecr-cycloid",
              "image": "ecr-cycloid:latest",
              "cpu": 10,
              "memory": 300,
              "essential": true,
              "portMappings": [
                  {
                      "hostPort": 80,
                      "containerPort": 80,
                      "protocol": "tcp"
                  }
              ],
              "networkMode": "awsvpc",

              "links": [],
              "command": [],
              "entryPoint": [],
              "environment": [
                  {
                      "name": "WORDPRESS_DB_HOST",
                      "value": "${aws_db_instance.db_instance.address}"
                  },
                  {
                      "name": "WORDPRESS_DB_USER",
                      "value": "${var.db_user}"
                  },
                  {
                      "name": "WORDPRESS_DB_PASSWORD",
                      "value": "${var.db_password}"
                  },
                  {
                      "name": "WORDPRESS_DB_NAME",
                      "value": "${var.db_name}"
                  }
              ]
          }
      ]
        EOF
}


resource "aws_ecs_service" "aws-ecs-service" {
  name            = join("-", ["ecs-service", var.company])
  cluster         = aws_ecs_cluster.aws-ecs-cluster.arn
  task_definition = aws_ecs_task_definition.aws-ecs-task-wp.arn
  desired_count   = 2
  network_configuration {
    subnets = [aws_subnet.public-subnet.id]
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

