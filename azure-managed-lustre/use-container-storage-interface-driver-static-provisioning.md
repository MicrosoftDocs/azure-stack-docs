---
title: Use static provisioning with the Azure Managed Lustre CSI Driver
description: Learn how to use static provisioning with the Azure Lustre CSI Driver for Kubernetes to mount an existing Azure Managed Lustre file system in AKS.
ms.topic: how-to
ms.date: 10/23/2026
author: pauljewellmsft
ms.author: akashdubey
ms.reviewer: brianl
ms.custom: sfi-image-nochange

# Intent: As an IT pro, I want to use static provisioning with the Azure Lustre CSI Driver to mount an existing Azure Managed Lustre file system in AKS.
# Keyword: 

---

# Use static provisioning with the Azure Managed Lustre CSI driver

Use static provisioning to mount an existing Azure Managed Lustre file system in AKS. Create a `StorageClass` with its MGS IP address and a `PersistentVolumeClaim` for the workload.

## Prerequisites for static provisioning

- An existing Azure Managed Lustre file system. For information about creating a file system, see [Create an Azure Managed Lustre file system by using the Azure portal](create-file-system-portal.md).
- The MGS IP address from your Azure Managed Lustre file system.
- An Azure account with an active subscription. [Create an account for free](https://azure.microsoft.com/pricing/purchase-options/azure-account?cid=msft_learn).
- A terminal environment with the Azure CLI tools installed. See [Get started with the Azure CLI](/cli/azure/get-started-with-azure-cli).
- [kubectl](https://kubernetes.io/docs/reference/kubectl), the Kubernetes management tool, installed in your terminal environment.
- An AKS cluster that meets the [v0.6.0 compatibility requirements](use-csi-driver-kubernetes.md#supported-kubernetes-and-aks-versions), including supported node operating systems, architectures, and the `kubernetes.azure.com/os-sku-effective` label.
- The tools, network access, and node scheduling requirements in [CSI driver prerequisites](use-csi-driver-kubernetes.md#prerequisites).
- **Network connectivity** between your AKS cluster and Azure Managed Lustre virtual network. See [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md) for configuration options.

## Create an Azure Managed Lustre file system cluster for static provisioning

If you didn't already create your Azure Managed Lustre file system cluster, create the cluster now. For instructions, see [Create an Azure Managed Lustre file system by using the Azure portal](create-file-system-portal.md). Static provisioning requires an existing Azure Managed Lustre file system.

## Install the driver for static provisioning

Complete the shared [cluster preparation](use-container-storage-interface-driver-install.md#prepare-the-cluster) and [driver installation](use-container-storage-interface-driver-install.md#install-the-driver) steps once for either provisioning method. If the driver is already installed, follow [Upgrade the CSI driver](use-container-storage-interface-driver-upgrade.md#upgrade-the-csi-driver) instead of installing a second copy.

Complete the [driver readiness checks](use-container-storage-interface-driver-install.md#verify-the-installation) before creating claims or mounting volumes. Create the example PVCs and pods in the same workload namespace, selected by your current kubectl context.

## Create and configure a persistent volume for static provisioning

To create a persistent volume for an existing Azure Managed Lustre file system:

1. Copy the following configuration files from the **/docs/examples/** folder in the [v0.6.0 azurelustre-csi-driver source](https://github.com/kubernetes-sigs/azurelustre-csi-driver/tree/v0.6.0/docs/examples).

   - **storageclass_existing_lustre.yaml**
   - **pvc_storageclass.yaml**

   If you don't want to clone the entire repository, you can download each file individually. Open each of the following links, copy the file's contents, and then paste the contents into a local file with the same file name.

   - [storageclass_existing_lustre.yaml](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/examples/storageclass_existing_lustre.yaml)
   - [pvc_storageclass.yaml](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/examples/pvc_storageclass.yaml)

1. In the Azure portal, open your Azure Managed Lustre file system and select **Client connection**. Copy the MGS IP address. In **storageclass_existing_lustre.yaml**, replace the entire `${EXISTING_LUSTRE_IP_ADDRESS}` placeholder with that address.

1. To create the storage class and the persistent volume claim, run the following `kubectl` command:

   ```bash
   kubectl create -f storageclass_existing_lustre.yaml
   kubectl create -f pvc_storageclass.yaml
   ```

## Create a pod for static provisioning

Create a pod that uses the PVC to mount the Azure Managed Lustre file system. This example is for Linux amd64 nodes with the driver installed; use an ARM-compatible image on supported ARM nodes.

Create a file called `pod_echo_date.yaml` and copy in the following YAML:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: lustre-echo-date
spec:
  containers:
  - image: mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine
    name: lustre-echo-date
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
      claimName: pvc-lustre
```

Apply the pod to your AKS cluster:

```bash
kubectl apply -f pod_echo_date.yaml
```

## Verify static provisioning

Wait for the example pod to become ready, and then check its mount:

```bash
kubectl wait --for=condition=Ready pod/lustre-echo-date --timeout=10m &&
kubectl exec -it lustre-echo-date -- df -h
```

You should see the Azure Managed Lustre file system mounted at `/mnt/lustre`.

Confirm that new timestamps continue to appear in the mounted file.

```bash
kubectl exec lustre-echo-date -- tail -f /mnt/lustre/outfile
```

Press Ctrl+C after you confirm that new timestamps appear.

## Clean up static resources

When you finish the example, find its PV name in the `VOLUME` column:

```bash
kubectl get pvc pvc-lustre -o wide
```

Replace `<pv-name>` with that name, and then delete the example pod, PVC, PV, and StorageClass:

```bash
kubectl delete pod lustre-echo-date
kubectl delete pvc pvc-lustre
kubectl delete pv <pv-name>
kubectl delete storageclass sc.azurelustre.csi.azure.com
```

> [!IMPORTANT]
> This step only deletes the Kubernetes resources. The Azure Managed Lustre file system itself continues to exist and can be reused.

## Troubleshooting

To troubleshoot issues with the Azure Lustre CSI Driver, see the [v0.6.0 CSI driver troubleshooting guide](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/v0.6.0/docs/csi-debug.md) in the GitHub repository.

For common driver installation, node scheduling, and upgrade issues, see [CSI driver troubleshooting](use-csi-driver-kubernetes.md#troubleshooting).

Common issues for static provisioning include:

- **Network connectivity problems** between AKS and Azure Managed Lustre - verify virtual network peering or subnet configuration.
- **Incorrect configuration** - double-check the MGS IP address in your storage class configuration.
- **Pod scheduling issues** - verify that the node's effective OS SKU is `Ubuntu2204`, `Ubuntu2404`, `AzureLinux3`, or `Ubuntu2004` for a Confidential VM node pool. Check node architecture and taints too.
- **Network setup permission issues** - verify that the AKS control-plane identity has appropriate permissions on the AKS subnet. Static provisioning doesn't require the controller to create an Azure Managed Lustre file system.

For additional troubleshooting resources, see:
- [Troubleshoot Azure Managed Lustre CSI driver extension errors](/troubleshoot/azure/azure-kubernetes/extensions/troubleshoot-azurelustre-csi-extension-errors)
- [Azure Managed Lustre troubleshooting](troubleshoot-deployment.md)
- [Azure Lustre CSI Driver GitHub repository](https://github.com/kubernetes-sigs/azurelustre-csi-driver)

## Related content

- [Azure Lustre CSI driver overview](use-csi-driver-kubernetes.md)
- [Install the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-install.md)
- [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md).
- [Use dynamic provisioning with the Azure Lustre CSI driver](use-container-storage-interface-driver-dynamic-provisioning.md)
- [Upgrade or uninstall the Azure Managed Lustre CSI driver](use-container-storage-interface-driver-upgrade.md)
- [Validate CSI driver image security](use-container-storage-interface-driver-image-security.md).
