# Red Hat Consulting

## Prerequisites
Install python openshift RPM from EPEL repository:
```
rhel7: yum install python2-openshift
rhel8: dnf install python3-openshift

Note: rhel7 requires rhel-7-server-extras-rpms repo to be enabled
```

Install community.kubernetes ansible module:
```
ansible-galaxy install -r collections/requirements.yaml -p /usr/share/ansible/collections
```

Ensure that the system you are installing from meets the following requirements:
```
At least 500MB of free space in $HOME
At least 1GB of free space in /tmp
Idle timeout of 45 minutes or higher (or run commands inside a screen session)
Network connectivity to the vCenter
```

## Deploy an OpenShift Cluster

Provide cluster specific variables:
```
ansible-vault create clusters/<name-of-cluster>.yaml

To edit an existing file:
ansible-vault edit clusters/<name-of-cluster>.yaml

```

Run cluster installation playbook:
```
ansible-playbook --ask-vault-pass -e cluster_name=<name-of-cluster> deploy-cluster.yaml
```

## Run post installation tasks

Link appropriate python binary in ~openshift/bin/
```
ln -s /bin/pytheon3 ~/openshift/bin/python3
```

Comment/uncomment roles as needed and run playbook:
```
ansible-playbook --ask-vault-pass -e cluster_name=<name-of-cluster> post-install.yaml

If kubeconfig not in <install-dir>/auth/kubeconfig:
ansible-playbook --ask-vault-pass -e cluster_name=<name-of-cluster> -e kubeconfig=<path-to-kubeconfig-file> post-install.yaml
```

Once argo is installed, create a folder named for the new cluster and copy contents of gitops-cluster-config/drk8s/ to it:
```
cd gitops-cluster-config
mkdir <name-of-cluster>
cd <name-of-cluster>
cp -r ../drk8s/ ./
for OUTPUT in $(grep -r -l drk8s *)
  do
    sed -i 's/drk8s/<name-of-cluster>/g' $OUTPUT
  done
```
