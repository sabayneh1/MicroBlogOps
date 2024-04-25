
# Use the base image from Commento's registry
FROM registry.gitlab.com/commento/commento

# Set environment variables for the Commento configuration
ENV COMMENTO_POSTGRES="postgres://commento:UG9zdEdyaWyljQ1NzY5MDIy@postgres-commento:5432/commento?sslmode=disable"
ENV COMMENTO_BIND_ADDRESS="0.0.0.0"  
ENV COMMENTO_PORT="8080"

# Expose the port the Commento service listens on
EXPOSE 8080

