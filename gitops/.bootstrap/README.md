## Bootstrapping

This contains an Ansible playbook to initialize a newly-installed cluster.  It contains the minimum necessary to bootstrap an ArgoCD instance:

* Installation of `ImageContentSourcePolicies` and `CatalogSources` for a disconnected cluster
* Installation of the Red Hat `openshift-gitops` operator, including installation of the default ArgoCD instance
* Installation of a root infrastructure "App of apps"

The openshift_common and openshift_gitops roles are modifications of the excellent work done by Ales Nosek and contributors at https://github.com/noseka1/ansible-base.  These roles are offered under their original Apache 2.0 license (see LICENSE).

### Installation

1. Install ansible-core and the kubernetes.core module (and corresponding Python Kubernetes module).

2. Log into the cluster as kubeadmin in the local command-line environment.

3. Run `ansible-playbook connection-test.yaml` to verify all prerequisites are satisfied.

4. Modify variables in `playbook.yaml`.

5. Copy an SSH repository key to `files/` or configure the variable `gitops_ssh_key_file` to point to the location of your private key. (DO NOT COMMIT THIS FILE TO GIT!)

6. Run the playbook: `ansible-playbook playbook.yaml`