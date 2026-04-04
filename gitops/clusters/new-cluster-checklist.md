# New Cluster Checklist

## High Level Steps

* Copy template
* Update cluster specific elements

## Cluster Specific Updates

* Node Fence Config
* External Secrets Config

### Node Fence Config

Path: clusters/[CLUSTER NAME]/overlays/node-fence-config

fence-agent-remediation-template.yaml

```yaml
spec:
  template:
    spec:
      agent: fence_redfish
      nodeparameters:
        '--ip':       
           hub-node-01.ocp.jobu.net: 10.0.50.24
           hub-node-02.ocp.jobu.net: 10.0.50.25
           hub-node-03.ocp.jobu.net: 10.0.50.2
```

### External Secrets Config

Path: clusters/[CLUSTER NAME]/overlays/external-secrets-configuration

kustomization.yaml:

```yaml
patches:
  - target:
      kind: ClusterSecretStore
      name: external-secrets-vault-ss
    patch: |
      - op: replace
        path: /spec/provider/vault/auth/jwt/path
        value: clusterjwt/dal_hub1
```
