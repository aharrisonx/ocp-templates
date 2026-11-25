# Define the Environment
export EMAIL="andharri@redhat.com"
export CLUSTERNAME=$(grep name: deploy/auth/* | grep cluster | awk '{ print $3 }')
export BASEDOMAIN=$(grep -o sandbox.* deploy/auth/* | awk -F: '{ print $2 }')
export API_DNS=api.${CLUSTERNAME}.${BASEDOMAIN}
export INGRESS_DNS="*.apps.${CLUSTERNAME}.${BASEDOMAIN}"

# Apply the new cert
# Create Ingress Certificate Secret
oc create secret tls router-certs \
  --cert=./certs/live/${API_DNS}/fullchain.pem \
  --key=./certs/live/${API_DNS}/privkey.pem \
  -n openshift-ingress

# Patch Ingress Controllers
oc patch ingresscontroller.operator default \
  --type=merge -p \
  '{"spec":{"defaultCertificate": {"name": "router-certs"}}}' \
  -n openshift-ingress-operator

# Create API Certificate Secret  
oc create secret tls api-certs \
  --cert=./certs/live/${API_DNS}/fullchain.pem \
  --key=./certs/live/${API_DNS}/privkey.pem \
  -n openshift-config

# Patch API Server  
oc patch apiserver cluster \
  --type=merge -p \
  '{"spec":{"servingCerts": {"namedCertificates": [{"names": ["'"${API_DNS}"'"], "servingCertificate": {"name": "api-certs"}}]}}}'
