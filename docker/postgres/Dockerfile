# First stage: 'init' stage for initializing the PostgreSQL database with custom scripts
# Use the postgres:alpine image as the base image for this stage
FROM postgres:alpine AS init

# Copy initialization scripts to the Docker entrypoint directory
# These scripts will run during the PostgreSQL initialization process
COPY initdb/* /docker-entrypoint-initdb.d/

# Modify the entrypoint script to skip execution in this build stage
# This prevents the database from starting in this initial stage
RUN ["sed", "-i", "s/exec \"$@\"/echo \"skipping...\"/", "/usr/local/bin/docker-entrypoint.sh"]

# Set environment variables for PostgreSQL
ENV POSTGRES_USER=postgres
ENV POSTGRES_PASSWORD=postgres
ENV PGDATA=/data

# Run the entrypoint script in the init stage to initialize the database
RUN ["/usr/local/bin/docker-entrypoint.sh", "postgres"]

# Second stage: Final image with the initialized database
# Start from a fresh postgres:alpine image to keep the final image lightweight
FROM postgres:alpine

# Copy the initialized data from the 'init' stage into the new image
COPY --from=init /data $PGDATA

# The first stage (init) sets up the PostgreSQL database, 
# applies any initialization scripts, and stores the resulting data in a specified directory (/data).
# The second stage copies only the initialized data into a fresh image. 
# This avoids copying unnecessary files or intermediary build layers, which would make the image larger and possibly include unneeded files.