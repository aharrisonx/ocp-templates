# Bootstrap Notes

## Notes

* Add topology labels to nodes
* Create NAD for Cluster Network Interface - Seperate subnet (NAD) for ODF internal traffic

```shell
# Set env variables
export gitops_repo=git@github.com/cvs-health-enterprise-code/cpc-lab.git
export cluster_name=hub1
export cluster_base_domain=$(oc get ingress.config.openshift.io cluster --template={{.spec.domain}} | sed -e "s/^apps.//")
export platform_base_domain=${cluster_base_domain#*.}
export gitops_starting_csv=openshift-gitops-operator.v1.19.1

# Storage
# Label nodes using expected odf label cluster.ocs.openshift.io/openshift-storage
oc label node hub-node-01.ocp.jobu.net cluster.ocs.openshift.io/openshift-storage=""
oc label node hub-node-02.ocp.jobu.net cluster.ocs.openshift.io/openshift-storage=""
oc label node hub-node-03.ocp.jobu.net cluster.ocs.openshift.io/openshift-storage=""
# Deploy the LSO
oc apply -k  components/local-storage-operator/ --dry-run=server
watch oc get og,sub,csv,sc,pvc,po -n openshift-local-storage
# Apply LSO config
oc apply -k  components/local-storage-configuration/ --dry-run=server
# Watch for PVs and SC
oc get pv -w
# PV count should match total disk count
oc get pv | wc -l
# Apply default sc label
# oc patch storageclass odf-osd -p '{"metadata":{"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# Apply odf-operator
oc apply -k  components/odf-operator/ --dry-run=client
# Watch for csv,po
oc get csv,po -o wide -n openshift-storage
# Check for CRDs
oc get crd | grep ocs.openshift.io
# Deploy storage-cluster
oc apply -k  components/odf-configuration/ --dry-run=server
# Watch for resources
watch oc get sc,pvc,po -n openshift-storage
# Check CEPH status
oc exec -n openshift-storage -it rook-ceph-tools-5d8b68f74b-h2j66 -- sh
ceph -s
ceph osd tree
# Test Storage Cluster
# Create test ns
oc create-project rhps-testing
# Create test pvc for 
oc ocs-storagecluster-ceph-rbd
# C
ocs-storagecluster-cephfs
ocs-storagecluster-ceph-rgw 

# Argo
oc apply -f .bootstrap/namespace.yaml
oc apply -f .bootstrap/operator-group.yaml
oc apply -f .bootstrap/subscription.yaml
oc apply -f .bootstrap/cluster-rolebinding.yaml
oc get csv,po -o wide -n openshift-gitops-operator
oc get po,svc,route -o wide -n openshift-gitops
sleep 60
envsubst < .bootstrap/argocd.yaml | oc apply -f -
sleep 30
envsubst < .bootstrap/root-application.yaml | oc apply -f -


# Clean Up
oc delete -f .bootstrap/cluster-rolebinding.yaml
oc delete -f .bootstrap/subscription.yaml
oc delete -f .bootstrap/operator-group.yaml
oc delete -f .bootstrap/namespace.yaml

oc delete -k  components/odf-operator/
```

## Enable CEPH Tools from Marketplace Install

```shell
oc patch storageclusters.ocs.openshift.io ocs-storagecluster -n openshift-storage --type json --patch '[{ "op": "replace", "path": "/spec/enableCephTools", "value": true }]'
```

## ODF Clean-up (New)

* <https://access.redhat.com/articles/6525111>

```shell
oc annotate storagecluster -n openshift-storage ocs-storagecluster uninstall.ocs.openshift.io/cleanup-policy=delete --overwrite
oc annotate storagecluster -n openshift-storage ocs-storagecluster uninstall.ocs.openshift.io/mode=forced --overwrite
oc delete -n openshift-storage storagecluster --all --wait=true
#for i in $(oc get node -l cluster.ocs.openshift.io/openshift-storage= -o name); do oc debug ${i} -- chroot /host ls -l /var/lib/rook; done
for i in $(oc get node -l cluster.ocs.openshift.io/openshift-storage= -o name); do oc debug ${i} -- chroot /host rm -rf /var/lib/rook; done
oc debug node/hub-node-01.ocp.jobu.net 
chroot /host
dmsetup ls
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-0lskgs-block-dmcrypt 
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-3rwncg-block-dmcrypt
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-6n9vpb-block-dmcrypt
dmsetup ls
lsblk
sgdisk -Z /dev/nvme1n1
sgdisk -Z /dev/nvme0n1
sgdisk -Z /dev/nvme2n1
exit
oc debug node/hub-node-02.ocp.jobu.net 
chroot /host
dmsetup ls
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-1vdlh9-block-dmcrypt
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-4k6p8k-block-dmcrypt
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-87l8q4-block-dmcrypt 
dmsetup ls
lsblk
sgdisk -Z /dev/nvme1n1
sgdisk -Z /dev/nvme0n1
sgdisk -Z /dev/nvme2n1
exit
oc debug node/hub-node-03.ocp.jobu.net 
chroot /host
dmsetup ls
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-2bthwg-block-dmcrypt 
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-58n5wt-block-dmcrypt 
cryptsetup luksClose --debug --verbose ocs-deviceset-odf-osd-0-data-77hpm4-block-dmcrypt
lsblk
sgdisk -Z /dev/nvme1n1
sgdisk -Z /dev/nvme0n1
sgdisk -Z /dev/nvme2n1
exit
oc delete cm ocs-client-operator-config -n openshift-storage
oc project default
oc delete project openshift-storage --wait=true --timeout=5m
oc delete crd backingstores.noobaa.io bucketclasses.noobaa.io cephblockpools.ceph.rook.io cephclusters.ceph.rook.io cephfilesystems.ceph.rook.io cephnfses.ceph.rook.io cephobjectstores.ceph.rook.io cephobjectstoreusers.ceph.rook.io noobaas.noobaa.io ocsinitializations.ocs.openshift.io storageclusters.ocs.openshift.io cephclients.ceph.rook.io cephobjectrealms.ceph.rook.io cephobjectzonegroups.ceph.rook.io cephobjectzones.ceph.rook.io cephrbdmirrors.ceph.rook.io storagesystems.odf.openshift.io cephblockpoolradosnamespaces.ceph.rook.io cephbucketnotifications.ceph.rook.io cephbuckettopics.ceph.rook.io cephcosidrivers.ceph.rook.io cephfilesystemmirrors.ceph.rook.io cephfilesystemsubvolumegroups.ceph.rook.io csiaddonsnodes.csiaddons.openshift.io networkfences.csiaddons.openshift.io reclaimspacecronjobs.csiaddons.openshift.io reclaimspacejobs.csiaddons.openshift.io storageclassrequests.ocs.openshift.io storageconsumers.ocs.openshift.io storageprofiles.ocs.openshift.io volumereplicationclasses.replication.storage.openshift.io volumereplications.replication.storage.openshift.io --wait=true --timeout=5m
# Disk Cleanup
```

## ODF Clean-up (Old)

```shell
# Annotate Storage Cluster
oc annotate storagecluster -n openshift-storage ocs-storagecluster uninstall.ocs.openshift.io/cleanup-policy=delete --overwrite
oc annotate storagecluster -n openshift-storage ocs-storagecluster uninstall.ocs.openshift.io/mode=forced --overwrite
# Remove storage clsuter
oc delete -k  components/odf-configuration/ --dry-run=server
# Remove operator
# oc delete -k  components/odf-operator/ --dry-run=server
oc delete -f components/odf-operator/subscription.yaml --dry-run=server
oc delete -f components/odf-operator/operator-group.yaml --dry-run=server
# oc delete -f components/odf-operator/namespace.yaml --dry-run=server
oc delete csv --all -n openshift-storage --dry-run=server
oc delete deploy --all -n openshift-storage --dry-run=server
oc delete ds --all -n openshift-storage --dry-run=server
oc delete svc --all -n openshift-storage --dry-run=server
oc delete po --all -n openshift-storage --dry-run=server
oc delete jobs --all -n openshift-storage --dry-run=server
oc delete cm --all -n openshift-storage --dry-run=server
oc delete crd $(oc get crd | grep ocs.openshift.io | awk '{ print $1 }')
oc delete crd $(oc get crd | grep rook | awk '{ print $1 }')
oc delete crd $(oc get crd | grep ceph | awk '{ print $1 }')
oc delete crd $(oc get crd | grep noobaa | awk '{ print $1 }')
oc delete crd $(oc get crd | grep bucket | awk '{ print $1 }')
oc delete crd $(oc get crd | grep csiaddons.openshift | awk '{ print $1 }')
oc delete crd backingstores.noobaa.io bucketclasses.noobaa.io cephblockpools.ceph.rook.io cephclusters.ceph.rook.io cephfilesystems.ceph.rook.io cephnfses.ceph.rook.io cephobjectstores.ceph.rook.io cephobjectstoreusers.ceph.rook.io noobaas.noobaa.io ocsinitializations.ocs.openshift.io storageclusters.ocs.openshift.io cephclients.ceph.rook.io cephobjectrealms.ceph.rook.io cephobjectzonegroups.ceph.rook.io cephobjectzones.ceph.rook.io cephrbdmirrors.ceph.rook.io storagesystems.odf.openshift.io cephblockpoolradosnamespaces.ceph.rook.io cephbucketnotifications.ceph.rook.io cephbuckettopics.ceph.rook.io cephcosidrivers.ceph.rook.io cephfilesystemmirrors.ceph.rook.io cephfilesystemsubvolumegroups.ceph.rook.io csiaddonsnodes.csiaddons.openshift.io networkfences.csiaddons.openshift.io reclaimspacecronjobs.csiaddons.openshift.io reclaimspacejobs.csiaddons.openshift.io storageclassrequests.ocs.openshift.io storageconsumers.ocs.openshift.io storageprofiles.ocs.openshift.io volumereplicationclasses.replication.storage.openshift.io volumereplications.replication.storage.openshift.io --wait=true --timeout=5m
oc delete namespace openshift-storage --timeout=5m
# Plug-in Cleanup
# ConsolePlugin odf-console
# ConsolePlugin odf-client-console
# Disk cleanup
#for i in $(oc get node -l cluster.ocs.openshift.io/openshift-storage= -o name); do oc debug ${i} -- chroot /host ls -l /var/lib/rook; done
for i in $(oc get node -l cluster.ocs.openshift.io/openshift-storage= -o name); do oc debug ${i} -- chroot /host rm -rf /var/lib/rook; done
oc delete -k  components/local-storage-configuration/ --dry-run=server
oc project default
oc debug node/hub-node-01.ocp.jobu.net
chroot /host
lsblk
sgdisk -Z /dev/nvme1n1
sgdisk -Z /dev/nvme0n1
sgdisk -Z /dev/nvme2n1
exit
exit
oc debug node/hub-node-02.ocp.jobu.net
chroot /host
lsblk
sgdisk -Z /dev/nvme1n1
sgdisk -Z /dev/nvme0n1
sgdisk -Z /dev/nvme2n1
exit
exit
oc debug node/hub-node-03.ocp.jobu.net
chroot /host
lsblk
sgdisk -Z /dev/nvme1n1
sgdisk -Z /dev/nvme0n1
sgdisk -Z /dev/nvme2n1
exit
exit
```

## etcd Health Check

```shell
oc get pods -n openshift-etcd -o wide
oc rsh -n openshift-etcd etcd-hub-node-01.ocp.jobu.net
 etcdctl member list -w table
 etcdctl endpoint health --cluster
 etcdctl endpoint status -w table

oc debug node/hub-node-01.ocp.jobu.net
 chroot /host bash
 podman run --privileged --volume /var/lib/etcd:/test quay.io/peterducai/openshift-etcd-suite:latest fio
```

```shell
oc adm drain hub-node-01.ocp.jobu.net --ignore-daemonsets --delete-emptydir-data --force --disable-eviction=true
```

## Node Removal/Clean-up

* <https://docs.redhat.com/en/documentation/openshift_container_platform/4.20/html/nodes/working-with-nodes#replacing-control-plane-node>

```shell
etcdctl member remove f5a815e7c6072484

oc patch etcd/cluster --type=merge -p '{"spec": {"unsupportedConfigOverrides": {"useUnsupportedUnsafeNonHANonProductionUnstableEtcd": true}}}'

oc get secrets -n openshift-etcd | grep hub-node-01.ocp.jobu.net

oc delete secret -n openshift-etcd etcd-peer-hub-node-01.ocp.jobu.net 
oc delete secret -n openshift-etcd etcd-serving-hub-node-01.ocp.jobu.net
oc delete secret -n openshift-etcd etcd-serving-metrics-hub-node-01.ocp.jobu.net

oc get -n openshift-machine-api bmh hub-node-01.ocp.jobu.net -o yaml > bmh_affected.yaml

oc delete node hub-node-01.ocp.jobu.net
```
