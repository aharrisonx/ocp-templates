#!/bin/bash

NAMESPACE="rhel9-vms"
BASE_NAME="rhel9-vm"
TEMPLATE_NAME="rhel9-server-small"
TEMPLATE_NAMESPACE="openshift"

for i in $(seq 1 50); do
  VM_NAME="${BASE_NAME}-${i}"
  echo "Creating VM: ${VM_NAME}"
  
  oc process -n "${TEMPLATE_NAMESPACE}" "${TEMPLATE_NAME}" -p NAME="${VM_NAME}" | oc apply -n "${NAMESPACE}" -f -
done
