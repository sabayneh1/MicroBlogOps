# Use the base image for MySQL 5.7
FROM mysql:5.7

# Set required environment variables
ENV MYSQL_ROOT_PASSWORD=New1234@yes \
    MYSQL_DATABASE=ghost

# Copy any initialization scripts
COPY ./grant-permissions.sql /docker-entrypoint-initdb.d/

# Set custom MySQL configurations
CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]

# Optional: Add healthcheck (similar to docker-compose)
HEALTHCHECK --interval=10s --timeout=5s --retries=5 --start-period=10s \
  CMD mysqladmin ping -h localhost --silent
