FROM ghost:3-alpine

# Configure Ghost to connect to the MySQL database
ENV database__client=mysql \
    database__connection__host=mysql \
    database__connection__user=root \
    database__connection__password="New1234@yes" \
    database__connection__database=ghost \
    # Use the LoadBalancer URL or set this through Kubernetes environments
    url="http://aa32ae9dbc82a413dab124a0599a4a5c-1264531846.ca-central-1.elb.amazonaws.com"

EXPOSE 2368
