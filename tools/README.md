# Tools

## A collection of tools to make using OpenShift 4.x easier

## Watch
There's no clear equivalent of the unix `watch` command in Windows. Copy this BASH script into your $PATH/bin directory and it will provide the ability to do things like `watch oc get nodes` to get a continuosly updated feed of the `oc get nodes` command.
```
oc label namespace default network.openshift.io/policy-group=ingress
```

