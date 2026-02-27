#########################
# ECS Cluster
#########################
resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-cluster"
}

#########################
# ECS Task Definition
#########################
resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  execution_role_arn = "arn:aws:iam::811738710312:role/ecs_fargate_taskRole"

  container_definitions = jsonencode([{
    name      = "app"
    image     = "811738710312.dkr.ecr.${var.aws_region}.amazonaws.com/ahmad-strapi-bluegreen:latest"
    cpu       = 512
    memory    = 1024
    essential = true

    portMappings = [{
      containerPort = 1337
      protocol      = "tcp"
    }]

    environment = [
      { name = "DB_HOST",             value = var.db_host },
      { name = "DB_USERNAME",         value = var.db_username },
      { name = "DB_PASSWORD",         value = var.db_password },
      { name = "DATABASE_CLIENT",     value = var.database_client },
      { name = "DATABASE_PORT",       value = tostring(var.database_port) },
      { name = "DATABASE_NAME",       value = var.database_name },
      { name = "APP_KEYS",            value = var.app_keys },
      { name = "API_TOKEN_SALT",      value = var.api_token_salt },
      { name = "ADMIN_JWT_SECRET",    value = var.admin_jwt_secret },
      { name = "TRANSFER_TOKEN_SALT", value = var.transfer_token_salt },
      { name = "ENCRYPTION_KEY",      value = var.encryption_key },
      { name = "JWT_SECRET",          value = var.jwt_secret }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = var.log_group_name
        "awslogs-region"        = var.aws_region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

#########################
# ECS Service (CodeDeploy safe)
#########################
resource "aws_ecs_service" "this" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.this.id
  desired_count   = 2
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    subnets          = var.private_subnets
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.blue_tg_arn
    container_name   = "app"
    container_port   = 1337
  }

  lifecycle {
    ignore_changes = [
      task_definition
    ]
  }

  depends_on = [
    var.blue_tg_arn
  ]
}

resource "aws_iam_role_policy_attachment" "ecs_logs_attach" {
  role       = "ecs_fargate_taskrole"
  policy_arn = aws_iam_policy.ecs_logs_policy.arn
}