# Get current quota for # of Elastic IPs
aws service-quotas list-service-quotas \
  --service-code ec2 \
  --region us-east-2 \
  --quota-code L-0263D0A3 \
  --output text

# Get current quota for Total # of CPUs across all On-Demand Instances
aws service-quotas list-service-quotas \
  --service-code ec2 \
  --quota-code L-1216C47A \
  --region us-east-2 \
  --output text
  
# Get current quota for # of VPCs per Region
aws service-quotas list-service-quotas \
  --service-code vpc \
  --region us-east-2 \
  --quota-code L-F678F1CE \
  --output text
  
# Get current quota for # of NAT Gateways per Region
aws service-quotas list-service-quotas \
  --service-code vpc \
  --region us-east-2 \
  --quota-code L-FE5A380F \
  --output text
