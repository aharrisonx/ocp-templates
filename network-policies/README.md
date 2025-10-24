# Network Policies

## Examples of Network Policies for OpenShift 4.x

## Important information about OpenShift ingress on VMware/OpenStack
If you are using the HostNetwork option for your ingress controllers, add the following label to the `default` namespace so that the `allow-from-openshift-ingress.yaml` policy works properly:

```
oc label namespace default network.openshift.io/policy-group=ingress
```

