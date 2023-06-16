# Red Hat Advanced Cluster Management Demo

## YAML manifests to:

- [Deploy RHACM to hub cluster](https://github.com/aharrisonx/ocp-templates/tree/main/acm/hub)
- [Stand up Multicluster Observability](https://github.com/aharrisonx/ocp-templates/tree/main/acm/mcobs)
- [Create 2 spoke clusters](https://github.com/aharrisonx/ocp-templates/tree/main/acm/spoke)
- [Import 1 spoke cluster](https://github.com/aharrisonx/ocp-templates/tree/main/acm/spoke)
- [Apply 4 policies](https://github.com/aharrisonx/ocp-templates/tree/main/acm/policies)
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
ocp-templates/acm:$ oc create -f hub/
ocp-templates/acm:$ oc create -f mcobs/
ocp-templates/acm:$ oc create -f policies/
ocp-templates/acm:$ oc create -f day2/
ocp-templates/acm:$ oc create -f apps/
ocp-templates/acm:$ oc create -f spoke/cluster2
ocp-templates/acm:$ oc create -f spoke/cluster3
ocp-templates/acm:$ oc create -f spoke/import1
```
