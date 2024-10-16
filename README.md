# Delhi Climate Data Analysis Pipeline

## Overview
This project deploys a data pipeline using Terraform, Docker, PostgreSQL, SQL, and Python to analyze Delhi climate data. The pipeline processes data from the provided CSV file, loads it into a PostgreSQL database, and runs a SQL query to retrieve humidity statistics. Visualizations are created using data visualization tools for clear insights.

## Objective
The primary goals of this project are:
- To evaluate understanding of infrastructure provisioning using Terraform.
- To demonstrate proficiency with Docker, PostgreSQL, SQL, and Python scripting.
- To create effective and maintainable data visualization.

## Scenario
This test involves analyzing climate data for Delhi, India. The dataset is sourced from [Kaggle - Daily Climate Time Series Data](https://www.kaggle.com/datasets/sumanthvrao/daily-climate-time-series-data), licensed under "Public domain."

## Tasks and Implementation

### 1. Dockerfile
The Dockerfile loads `DailyDelhiClimateTrain.csv` into a PostgreSQL database during image build time. Key steps include:
- Creating a PostgreSQL container.
- Configuring the database and user.
- Loading the CSV file into the database.

### 2. Terraform Script
The Terraform script provisions and configures the following components:
- **PostgreSQL Container:** A Docker container for the PostgreSQL database, which stores the climate data.
- **Python Container:** A Docker container running a Python script that connects to PostgreSQL and executes SQL queries.

**Terraform Setup:**
- Ensure Docker is installed and running on your machine.
- Run `terraform init` to initialize the environment.
- Use `terraform apply` to create the infrastructure.

### 3. Python Script
The Python script connects to the PostgreSQL database and performs the following actions:
- Queries the database to find minimum and maximum humidity values for each year.
- Handles potential errors during the database connection and query execution.

### 4. Data Visualization
Using a tool like DBeaver, pgAdmin, or Matplotlib in Python:
- Visualize the results of the SQL query (min and max humidity per year).
- Start with the SQL code used in the Python script but prepare for minor modifications if requested.
