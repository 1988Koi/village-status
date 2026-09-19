terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "~> 3.0"
        }
    }
}

provider "docker" {}

resource "docker_image" "village_app" {
    name = "village-app:latest"
}

resource "docker_container" "village_app" {
    name  = "village-app"
    image = docker_image.village_app.image_id

    ports {
        internal = 5000
        external = 8080
    }
}