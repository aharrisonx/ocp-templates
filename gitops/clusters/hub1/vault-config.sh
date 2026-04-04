#!/bin/bash
# These commands will create the vault configuration required for this cluster

vault auth enable -path jwt-hub1 jwt
vault write auth/jwt-hub1/config jwks_url=https://api.hub1.ocp.jobu.net:6443/openid/v1/jwks
# Policy "default" needs to be able to reach AD bind password path
vault write auth/jwt-hub1/role/openshift-config role_type=jwt bound_audiences="http://kubernetes.default.svc" user_claim="sub" bound_subject="system:serviceaccount:openshift-config:default" policies="default" ttl=1h