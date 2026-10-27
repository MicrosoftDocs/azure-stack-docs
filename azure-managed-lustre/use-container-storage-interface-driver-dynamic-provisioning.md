---
title: Use dynamic provisioning with the Azure Managed Lustre CSI Driver
description: Learn how to use dynamic provisioning with the Azure Lustre CSI Driver for Kubernetes to automatically create Azure Managed Lustre file systems on demand.
ms.topic: how-to
ms.date: 10/23/2026
author: pauljewellmsft
ms.author: akashdubey
ms.reviewer: brianl
ms.custom: sfi-image-nochange

# Intent: As an IT pro, I want to use dynamic provisioning with the Azure Lustre CSI Driver to automatically create Azure Managed Lustre file systems on demand.
# Keyword: 

---

# Use dynamic provisioning with the Azure Managed Lustre CSI driver

By using dynamic provisioning, the Azure Lustre CSI Driver automatically creates Azure Managed Lustre file systems when you create persistent volume claims. This feature became available in CSI driver version 0.3.0.

> [!NOTE]
> Dynamic provisioning is available starting with Azure Lustre CSI Driver version 0.3.0. For more information, see the [v0.3.0 release notes](https://github.com/kubernetes-sigs/azurelustre-csi-driver/releases/tag/v0.3.0).

## Prerequisites for dynamic provisioning

- An AKS cluster that meets the [v0.6.0 compatibility requirements](use-csi-driver-kubernetes.md#supported-kubernetes-and-aks-versions), including supported node operating systems, architectures, and the `kubernetes.azure.com/os-sku-effective` label.
- The tools, network access, and node scheduling requirements in [CSI driver prerequisites](use-csi-driver-kubernetes.md#prerequisites).

### Permissions

> [!IMPORTANT]
> Before dynamically creating file systems, grant permissions to the identity used by the CSI controller. By default, this identity is the kubelet identity. Helm installations can alternatively use Microsoft Entra Workload Identity.

The controller identity requires permissions to read and join the existing subnet, validate Azure Managed Lustre subnet requirements, and read, create, update, and delete file systems. See the [v0.6.0 permission requirements](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/driver-parameters.md#permissions-for-kubelet-identity).

For workload identity, complete steps 1 through 4 of the [v0.6.0 workload identity setup](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/workload-identity.md#setup), which cover OIDC, identity permissions, and federation for the controller ServiceAccount. Then use the [Helm install command](use-container-storage-interface-driver-install.md#install-with-helm) with `--set IsWorkloadIdentityEnabled=Enabled` and `--set IdentityClientId=<managed-identity-client-id>`.

### Network requirements

- An existing virtual network and subnet for the Azure Managed Lustre cluster
- Sufficient IP addresses available in the subnet for the cluster
- Proper network security group rules to allow Lustre traffic

For network architecture planning, see [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md).

## Install the driver for dynamic provisioning

Complete the shared [cluster preparation](use-container-storage-interface-driver-install.md#prepare-the-cluster) and [driver installation](use-container-storage-interface-driver-install.md#install-the-driver) steps once for either provisioning method. If the driver is already installed, follow [Upgrade the CSI driver](use-container-storage-interface-driver-upgrade.md#upgrade-the-csi-driver) instead of installing a second copy.

Complete the [driver readiness checks](use-container-storage-interface-driver-install.md#verify-the-installation) before creating claims or mounting volumes. Create the example PVCs and pods in the same workload namespace, selected by your current kubectl context.

## Create a Storage Class for dynamic provisioning

Create a file named `storageclass_dynprov_lustre.yaml` by using the following configuration, based on the [v0.6.0 StorageClass example](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/examples/storageclass_dynprov_lustre.yaml). Set `location` to the region where you want to create the file system, and choose a SKU available in that region. If the selected SKU and region support availability zones, set `zone` to an available zone. Otherwise, remove the `zone` parameter.

Replace the resource group, virtual network, and subnet values with your selected resources. Omit optional parameters to use the default values shown in the comments. The `resource-group-name` parameter identifies where to create the file system, and the `vnet-resource-group` parameter identifies where the virtual network exists.

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: dynprov.azurelustre.csi.azure.com
provisioner: azurelustre.csi.azure.com
parameters:
  sku-name: "AMLFS-Durable-Premium-125"  # Choose appropriate SKU
  zone: "1"  # Remove if your SKU/region has no availability zones
  maintenance-day-of-week: "Sunday"
  maintenance-time-of-day-utc: "22:00"
  location: "eastus"  # Optional: defaults to AKS cluster location
  resource-group-name: "my-resource-group"  # Optional: defaults to AKS infrastructure RG
  vnet-resource-group: "my-vnet-resource-group"  # Optional: defaults to AKS VNet resource group
  vnet-name: "my-vnet"  # Optional: defaults to AKS cluster VNET
  subnet-name: "my-subnet"  # Optional: defaults to AKS cluster subnet
reclaimPolicy: Delete  # Change to "Retain" to keep clusters after PVC deletion
volumeBindingMode: Immediate
mountOptions:
  - noatime
  - flock
---
# Optional: Limit this StorageClass to one PVC in the current namespace
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pvc-lustre-dynprov-quota
spec:
  hard:
    dynprov.azurelustre.csi.azure.com.storageclass.storage.k8s.io/persistentvolumeclaims: "1"
```

This example also creates a quota that limits claims using the StorageClass to one PVC in the current namespace. Apply the example:

```bash
kubectl apply -f storageclass_dynprov_lustre.yaml
```

## Create a Persistent Volume Claim for dynamic provisioning

Create a file named `pvc_storageclass_dynprov.yaml` using the following configuration, based on the [v0.6.0 PVC example](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/examples/pvc_storageclass_dynprov.yaml). Adjust the requested capacity for your workload and the selected SKU's [capacity increments](create-file-system-portal.md#throughput-configurations).

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-lustre-dynprov
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: dynprov.azurelustre.csi.azure.com
  resources:
    requests:
      storage: 48Ti
```

Apply the PVC to your AKS cluster:

```bash
kubectl apply -f pvc_storageclass_dynprov.yaml
```

## Monitor file system creation

The driver might take 10 minutes or more to create the Azure Managed Lustre file system. Watch the PVC status:

```bash
kubectl get pvc pvc-lustre-dynprov --watch
```

When `STATUS` shows `Bound`, press Ctrl+C and continue.

To inspect provisioning events, run `kubectl describe pvc pvc-lustre-dynprov`.

## Create a pod for dynamic provisioning

Create a file called `pod_echo_date_dynprov.yaml` and copy in the following YAML. This example targets Linux amd64 nodes with the driver installed. For supported ARM64 nodes, use an ARM64-compatible image and set `kubernetes.io/arch` to `arm64` in `nodeSelector`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: lustre-echo-date-dynprov
spec:
  nodeSelector:
    kubernetes.io/os: linux
    kubernetes.io/arch: amd64
  containers:
  - image: mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
    name: lustre-echo-date-dynprov
    command:
      - "/bin/sh"
      - "-c"
      - "while true; do echo $(date) >> /mnt/lustre/outfile; sleep 1; done"
    volumeMounts:
    - name: lustre-storage
      mountPath: /mnt/lustre
  volumes:
  - name: lustre-storage
    persistentVolumeClaim:
      claimName: pvc-lustre-dynprov
```

Apply the pod to your AKS cluster:

```bash
kubectl apply -f pod_echo_date_dynprov.yaml
```

## Verify dynamic provisioning

Wait for the example pod to become ready, and then check its mount:

```bash
kubectl wait --for=condition=Ready pod/lustre-echo-date-dynprov --timeout=10m &&
kubectl exec -it lustre-echo-date-dynprov -- df -h
```

You should see the Azure Managed Lustre file system mounted at `/mnt/lustre`.

Confirm that the pod is writing to the file system by reading its output file. New timestamps should continue to appear:

```bash
kubectl exec lustre-echo-date-dynprov -- tail -f /mnt/lustre/outfile
```

Press Ctrl+C after you confirm that new timestamps appear.

## Clean up dynamic resources

With the example's `reclaimPolicy: Delete`, deleting the PVC also deletes the PV and Azure Managed Lustre file system, including its data. When you finish the example, delete its Kubernetes resources:

```bash
kubectl delete pod lustre-echo-date-dynprov
kubectl delete pvc pvc-lustre-dynprov
kubectl delete storageclass dynprov.azurelustre.csi.azure.com
kubectl delete resourcequota pvc-lustre-dynprov-quota --ignore-not-found
```

If you chose `Retain`, the PV and file system remain for manual cleanup when no longer needed.

## Troubleshooting

To troubleshoot issues with the Azure Lustre CSI Driver, see the [v0.6.0 CSI driver troubleshooting guide](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/csi-debug.md) in the GitHub repository.

For common driver installation, node scheduling, and upgrade issues, see [CSI driver troubleshooting](use-csi-driver-kubernetes.md#troubleshooting).

Common issues for dynamic provisioning include:

- **Authentication or authorization errors** - verify the configured controller identity's permissions for creating Azure Managed Lustre clusters. For workload identity, also check OIDC, federation, and the controller ServiceAccount configuration.
- **SKU and zone validation errors** - check the available region, zone, and throughput options in the [file system configuration](create-file-system-portal.md#basics-tab), then update `location`, `sku-name`, and `zone` in your StorageClass. For a SKU and region without availability zones, remove `zone`.
- **Network IP address availability** - confirm sufficient IP addresses are available in the target subnet.
- **Quota limitations** - check both Kubernetes resource quotas and Azure subscription quotas for Azure Managed Lustre clusters.
- **Network connectivity problems** between AKS and Azure Managed Lustre - verify virtual network peering or subnet configuration.

For additional troubleshooting resources, see:
- [Troubleshoot Azure Managed Lustre CSI driver extension errors](/troubleshoot/azure/azure-kubernetes/extensions/troubleshoot-azurelustre-csi-extension-errors)
- [Azure Managed Lustre troubleshooting](troubleshoot-deployment.md)
- [Azure Lustre CSI Driver GitHub repository](https://github.com/kubernetes-sigs/azurelustre-csi-driver)

## Related content

- [Azure Lustre CSI driver overview](use-csi-driver-kubernetes.md)
- [Install the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-install.md)
- [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md).
- [Use static provisioning with the Azure Lustre CSI driver](use-container-storage-interface-driver-static-provisioning.md).
- [Upgrade or uninstall the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-upgrade.md)
- [Validate CSI driver image security](use-container-storage-interface-driver-image-security.md).
