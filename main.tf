# Specify Terraform configuration for managing Docker-based resources
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"  # Specifies the source for the Docker provider plugin
      version = "3.0.2"               # Locks the provider version for consistent behavior
    }
  }
}

# Configure the local provider (used to create and manage local files)
provider "local" {
}

# Configure the Docker provider to allow Terraform to interact with Docker resources
provider "docker" {
}

# Define a Docker network resource
resource "docker_network" "dbnet" {
  name            = "db-net"          # Name of the network
  check_duplicate = true              # Avoid duplicate network creation if it already exists
  attachable      = true              # Allow containers to attach to this network after creation
}

# Define a Docker image resource to build a custom PostgreSQL image
resource "docker_image" "postgres" {
  name = "postgres-custom:latest"     # Name of the custom image
  build {
    context = "docker/postgres"       # Path to the Dockerfile context for building this image
    tag     = ["postgres-custom:latest"]  # Tags to apply to the built image
  }
}

# Define a Docker image resource to build a custom Python environment image
resource "docker_image" "python" {
  name = "pythonenv-custom:latest"    # Name of the custom image
  build {
    context = "docker/pythonenv"      # Path to the Dockerfile context for building this image
    tag     = ["pythonenv-custom:latest"]  # Tags to apply to the built image
  }
}

# Deploy a Docker container for PostgreSQL using the custom-built image
resource "docker_container" "postgres" {
  image    = docker_image.postgres.image_id  # Use the custom PostgreSQL image
  name     = "postgres-custom"               # Name of the container
  hostname = "postgresdb"                    # Set the hostname within the container
  networks_advanced {
    name = docker_network.dbnet.id           # Connect the container to the defined Docker network
  }
}

# Create a local file as an output or placeholder (can be used for debugging or tracking purposes)
resource "local_file" "copy_file" {
  filename = "${path.cwd}/out/.nocontent"  # Path and filename for the local file
  content  = ""                            # Content of the file (left empty)
}

# Deploy a Docker container for running a Python script in the custom Python environment
resource "docker_container" "python_script" {
  image    = docker_image.python.image_id
  name     = "python-script"               # Name of the container
  attach   = true                          # Attach to the container's stdout
  must_run = false                         # Do not automatically start this container
  command  = ["python3", "/app/humidity_chart.py"]  # Command to run a Python script in the container
  
  mounts {                                 # Mount a local directory to the container for output
    target = "/out"
    source = "${path.cwd}/out"
    type   = "bind"
  }
  mounts {                                 # Mount the application directory to the container
    target = "/app"
    source = "${path.cwd}/app"
    type   = "bind"
  }
  networks_advanced {
    name = docker_network.dbnet.id         # Connect the container to the Docker network
  }
}
