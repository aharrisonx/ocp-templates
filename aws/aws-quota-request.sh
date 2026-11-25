# Set current quota for # of Elastic IPs to 15
aws service-quotas request-service-quota-increase \
  --service-code ec2 \
  --quota-code L-0263D0A3 \
  --desired-value 15 \
  --region us-east-2 \
  --output text

# Set current quota for Total # of CPUs across all On-Demand Instances to 3072
aws service-quotas request-service-quota-increase \
  --service-code ec2 \
  --quota-code L-1216C47A \
  --desired-value 3072 \
  --region us-east-2 \
  --output text

# Set current quota for # of VPCs per Region to 15
aws service-quotas request-service-quota-increase \
  --service-code vpc \
  --quota-code L-F678F1CE \
  --desired-value 15 \
  --region us-east-2 \
  --output text
  
# Set current quota for # of NAT Gateways per Region to 15
aws service-quotas request-service-quota-increase \
  --service-code vpc \
  --quota-code L-FE5A380F \
  --desired-value 15 \
  --region us-east-2 \
  --output text
