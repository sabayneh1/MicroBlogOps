# Use the base image for PostgreSQL version 12
FROM postgres:12

# Set environment variables for database user, password, and name
ENV POSTGRES_DB=commento \
    POSTGRES_USER=commento \
    # Base64 encoded password for testing purposes
    POSTGRES_PASSWORD=UG9zdEdyaWwyMzQ1NzY5MDIy

# Expose the port the server listens on
EXPOSE 5432

# The default CMD defined in the postgres image will initiate the database with these settings
