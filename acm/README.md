# Red Hat Advanced Cluster Management Demo
This repo currently uses AWS as the infrastructure platform.  In order to be able to deploy all of the clusters and have them all exist during the demo, you must request an ElasticIP Quota Increase. The Default is 5, and you'll need to request 25 using the [AWS Service Quotas Console](https://aws.amazon.com/getting-started/hands-on/request-service-quota-increase/). This does not incur any additional costs in AWS, however the ec2 instances you spin up to use them will.
## YAML manifests to:

- [Deploy RHACM to hub cluster](https://github.com/aharrisonx/ocp-templates/tree/main/acm/hub)
- [Stand up Multicluster Observability](https://github.com/aharrisonx/ocp-templates/tree/main/acm/mcobs)
- [Create 2 spoke clusters](https://github.com/aharrisonx/ocp-templates/tree/main/acm/spoke)
- [Import 1 spoke cluster](https://github.com/aharrisonx/ocp-templates/tree/main/acm/spoke)
- [Apply multiple policies](https://github.com/aharrisonx/ocp-templates/tree/main/acm/policies)
- [Deploy 1 app](https://github.com/aharrisonx/ocp-templates/tree/main/acm/apps)
- [Deploy Day 2 configs](https://github.com/aharrisonx/ocp-templates/tree/main/acm/day2)

## How to use this repo

- Clone the repo into your local system using SSH or HTTPS
```
git clone https://github.com/aharrisonx/ocp-templates.git
cd ocp-templates/acm
```
- Modify the following files with appropriate credentials
    - ocp-templates/acm/hub/05_aws_creds.yaml
    - ocp-templates/acm/mcobs/01_mcobs_pull_secret.yaml
    - ocp-templates/acm/mcobs/03_thanos_object_storage_secret.yaml
    - ocp-templates/acm/spoke/cluster2/01_demo-cluster-2-aws-creds.yaml
    - ocp-templates/acm/spoke/cluster2/02_demo-cluster-2-install-config.yaml
    - ocp-templates/acm/spoke/cluster2/03_demo-cluster-2-ssh-private-key.yaml
    - ocp-templates/acm/spoke/cluster2/04_demo-cluster-2-pull-secret.yaml
    - ocp-templates/acm/spoke/cluster3/01_demo-cluster-3-aws-creds.yaml
    - ocp-templates/acm/spoke/cluster3/02_demo-cluster-3-install-config.yaml
    - ocp-templates/acm/spoke/cluster3/03_demo-cluster-3-ssh-private-key.yaml
    - ocp-templates/acm/spoke/cluster3/04_demo-cluster-3-pull-secret.yaml
    - ocp-templates/acm/spoke/import1/clusterimport.yaml
```
ocp-templates/acm:$ oc create -f hub/  (Installs the ACM Operator and required multicluster-engine components)
ocp-templates/acm:$ oc create -f mcobs/  (Stands up Multicluster Observability)
ocp-templates/acm:$ oc create -f policies/
ocp-templates/acm:$ oc create -f day2/
ocp-templates/acm:$ oc create -f apps/
ocp-templates/acm:$ oc create -f spoke/cluster2
ocp-templates/acm:$ oc create -f spoke/cluster3
ocp-templates/acm:$ oc create -f spoke/import1
```
