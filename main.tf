# Terraform configuration to manage Docker-based resources
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"  # Specifies the Docker provider source
      version = "3.0.2"               # Locks the Docker provider version
    }
  }
}

# Configure the local provider (used for managing local files)
provider "local" {
}

# Configure the Docker provider
provider "docker" {
}

# Define a Docker network resource with duplication check and attachable options
resource "docker_network" "dbnet" {
  name            = "db-net"
  check_duplicate = true
  attachable      = true
}

# Build and manage a Docker image for a custom PostgreSQL server
resource "docker_image" "postgres" {
  name = "postgres-custom:latest"
  build {
    context = "docker/postgres"         # Context directory for Docker build
    tag     = ["postgres-custom:latest"]
  }
}

# Build and manage a Docker image for a custom Python environment
resource "docker_image" "python" {
  name = "pythonenv-custom:latest"
  build {
    context = "docker/pythonenv"        # Context directory for Docker build
    tag     = ["pythonenv-custom:latest"]
  }
}

# Deploy a Docker container using the custom PostgreSQL image
resource "docker_container" "postgres" {
  image    = docker_image.postgres.image_id
  name     = "postgres-custom"
  hostname = "postgresdb"               # Set hostname within the container
  networks_advanced {
    name = docker_network.dbnet.id      # Connect to the defined Docker network
  }
}

# Create a local file resource for output purposes
resource "local_file" "copy_file" {
  filename = "${path.cwd}/out/.nocontent"  # Path and filename of the local file
  content  = ""                            # File content (empty)
}

# Deploy a Docker container to run a Python script in the custom environment
resource "docker_container" "python_script" {
  image    = docker_image.python.image_id
  name     = "python-script"
  attach   = true                         # Attach to container stdout
  must_run = false                        # Do not start the container automatically
  command  = ["python3", "/app/humidity_chart.py"]  # Command to run the Python script
  mounts {                                 # Mount local directory to container
    target = "/out"
    source = "${path.cwd}/out"
    type   = "bind"
  }
  mounts {                                 # Mount application directory to container
    target = "/app"
    source = "${path.cwd}/app"
    type   = "bind"
  }
  networks_advanced {
    name = docker_network.dbnet.id        # Connect to the defined Docker network
  }
}
