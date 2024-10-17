# First stage: 'builder' stage to install Python dependencies in an isolated virtual environment
# Use Python 3.9 Alpine as a lightweight base image for building dependencies
FROM python:3.9-alpine as builder

# Update package list and install essential build dependencies for psycopg2
# - musl-dev: Basic development libraries for Alpine
# - libpq-dev: PostgreSQL library needed for psycopg2 to connect to PostgreSQL
# - gcc and g++: Compilers required to build psycopg2
RUN apk update && apk add musl-dev libpq-dev gcc g++

# Create a virtual environment in /opt/venv to isolate our Python packages
RUN python -m venv /opt/venv

# Set the virtual environment’s bin directory in the PATH so packages inside it can be used directly
ENV PATH="/opt/venv/bin:$PATH"

# Install the required Python packages (psycopg2 and matplotlib) in the virtual environment
# - psycopg2: PostgreSQL adapter for Python
# - matplotlib: Library for data visualization
RUN pip install psycopg2 matplotlib

# Second stage: Final stage for a smaller runtime image
# Use a fresh Python 3.9 Alpine image to keep the final image lightweight
FROM python:3.9-alpine

# Update package list and install only the essential runtime dependencies for psycopg2
RUN apk update && apk add libpq-dev g++

# Copy the virtual environment with installed packages from the builder stage
COPY --from=builder /opt/venv /opt/venv

# Set the virtual environment’s bin directory in the PATH for easy access to packages
ENV PATH="/opt/venv/bin:$PATH"

# The first stage (builder) installs the required Python dependencies (psycopg2 and matplotlib) along with build dependencies like compilers and development libraries. 
# By isolating these in a virtual environment, we avoid cluttering the final image with unnecessary tools.
# The second stage (runtime) is based on a fresh, smaller Alpine image. 
# Here, only the essential runtime dependencies (like libpq-dev for PostgreSQL connectivity) are included, making the final image significantly smaller. 
# The virtual environment with the needed packages is copied over, minimizing size and enhancing security by excluding build tools.