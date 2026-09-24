terraform {
    required_providers {
        docker = {
            source = "kreuzwerker/docker"
            version = "~> 3.0"
        }
    }
}

provider "docker" {}

resource "docker_network" "village_net" {
    name = "village_app"
}

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

    networks_advanced {
        name = docker_network.village_net.name
    }
}

resource "docker_image" "postgres" {
    name = "postgres:16"
}

resource "docker_container" "postgres" {
    name = "village-db"
    image = docker_image.postgres.image_id

    env = [
        "POSTGRES_PASSWORD=password"
    ]
}

resource "docker_image" "prometheus" {
    name = "prom/prometheus:latest"
}

resource "docker_container" "prometheus" {
    name = "village_prom"
    image = docker_image.prometheus.image_id

    ports {
        internal = 9090
        external = 9090
    }

    volumes {
        host_path      = "/c/Users/Neveroddoreven/Desktop/DevOps/prometheus.yml"
        container_path = "/etc/prometheus/prometheus.yml"
    }

    volumes {
        host_path      = "/c/Users/Neveroddoreven/Desktop/DevOps/alert.rules.yml"
        container_path = "/etc/prometheus/alert.rules.yml"
    }
    
    networks_advanced {
        name = docker_network.village_net.name
    }
}

variable "discord_webhook_url" {
    type      = string
    sensitive = true
}

resource "docker_image" "alertmanager" {
    name = "prom/alertmanager:latest"
}

resource "docker_container" "alertmanager" {
    name  = "alertmanager"
    image = docker_image.alertmanager.image_id

    ports {
        internal = 9093
        external = 9093
    }

    volumes {
        host_path      = "/c/Users/Neveroddoreven/Desktop/DevOps/alertmanager.yml"
        container_path = "/etc/alertmanager/alertmanager.yml"
    }

    networks_advanced {
        name = docker_network.village_net.name
    }
}

resource "docker_image" "alertmanager_discord" {
    name = "benjojo/alertmanager-discord:latest"
}

resource "docker_container" "alertmanager_discord" {
    name  = "alertmanager-discord"
    image = docker_image.alertmanager_discord.image_id

    env = [
        "DISCORD_WEBHOOK=${var.discord_webhook_url}"
    ]
    
    networks_advanced {
        name = docker_network.village_net.name
    }
}