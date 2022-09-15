packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "wp" {
  image  = "wordpress:php8.1-fpm"
  commit = true
}

build {
  name = "ecr-cycloid"
  sources = [
    "source.docker.wp"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Docker Container",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = ["echo This provisioner runs last"]
  }
  post-processors {
    post-processor "docker-tag" {
      repository = join("/", ["${var.account_id}.dkr.ecr.us-east-1.amazonaws.com", var.company])
      tags       = ["latest", "ALi"]
    }
    post-processor "docker-push" {
      ecr_login      = true
      aws_access_key = var.aws_access_key
      aws_secret_key = var.aws_secret_key
      login_server   = var.ecr_login_server
    }
  }
}
