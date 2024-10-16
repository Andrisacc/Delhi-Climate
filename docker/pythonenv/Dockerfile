# Use a Python 3.9 Alpine image as the base for the builder stage
FROM python:3.9-alpine as builder

# Update the package list and install build dependencies for psycopg2
RUN apk update && apk add musl-dev libpq-dev gcc g++

# Create a virtual environment to isolate our Python dependencies
RUN python -m venv /opt/venv

# Set the virtual environment's bin directory in the PATH to use its packages as default
ENV PATH="/opt/venv/bin:$PATH"

# Install psycopg2 and matplotlib inside the virtual environment
RUN pip install psycopg2 matplotlib

# Start a new build stage from a smaller Python 3.9 Alpine base image
FROM python:3.9-alpine

# Update package list and install runtime dependencies
RUN apk update && apk add libpq-dev g++

# Copy the virtual environment from the builder stage to the current stage
COPY --from=builder /opt/venv /opt/venv

# Ensure that the virtual environment is activated by setting its bin directory in the PATH
ENV PATH="/opt/venv/bin:$PATH"