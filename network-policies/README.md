# Network Policies

## Examples of Network Policies for OpenShift 4.x easier

## Important info about openshift-ingress on VMware/OpenStack
If you are using HostNetwork for your ingress controllers, you must add a label to the default namespace in order for the `allow-from-openshift-ingress.yaml` policy to work properly
```
oc label namespace default network.openshift.io/policy-group=ingress
```

