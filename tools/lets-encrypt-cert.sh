# Define the Environment:
export EMAIL="andharri@redhat.com"
export CLUSTERNAME=$(grep name: deploy/auth/* | grep cluster | awk '{ print $3 }')
export BASEDOMAIN=$(grep -o sandbox.* deploy/auth/* | awk -F: '{ print $2 }')
export API_DNS=api.${CLUSTERNAME}.${BASEDOMAIN}
export INGRESS_DNS="*.apps.${CLUSTERNAME}.${BASEDOMAIN}"


# Mint a new cert for the cluster:
podman run -it --rm \
-v "$HOME/.aws:/root/.aws:ro,z" \
-v "$PWD/certs:/etc/letsencrypt:z" \
docker.io/certbot/dns-route53 certonly \
--dns-route53 \
-d "$API_DNS" \
-d "$INGRESS_DNS" \
--agree-tos \
--email "$EMAIL" \
--no-eff-email
