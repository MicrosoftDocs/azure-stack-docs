---
title: Use dynamic provisioning with the Azure Managed Lustre CSI Driver
description: Learn how to use dynamic provisioning with the Azure Lustre CSI Driver for Kubernetes to automatically create Azure Managed Lustre file systems on demand.
ms.topic: how-to
ms.date: 10/16/2026
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

### Permissions

> [!IMPORTANT]
> Before using this CSI driver to dynamically create Azure Managed Lustre clusters, the kubelet identity must have the correct permissions granted to it.

The kubelet identity requires the following permissions:
- Read and write access to the resource group where clusters are created
- Network permissions to create and manage subnets if needed
- Azure Managed Lustre service permissions

For detailed permission requirements, see the [Driver Parameters documentation](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/driver-parameters.md#Permissions%20For%20Kubelet%20Identity).

### Network requirements

- An existing virtual network and subnet for the Azure Managed Lustre cluster
- Sufficient IP addresses available in the subnet for the cluster
- Proper network security group rules to allow Lustre traffic

For network architecture planning, see [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md).

## Create an AKS cluster for dynamic provisioning

If you didn't already create your AKS cluster, create a cluster deployment. See [Deploy an Azure Kubernetes Service (AKS) cluster by using the Azure portal](/azure/aks/learn/quick-kubernetes-deploy-portal).

## Create a virtual network peering for dynamic provisioning

> [!NOTE]
> Skip this network peering step if you installed AKS in a subnet on the Azure Managed Lustre virtual network.

The AKS virtual network is created in a separate resource group from the AKS cluster's resource group. You can find the name of this resource group by going to your AKS cluster in the Azure portal, going to **Properties**, and finding the **Infrastructure** resource group. This resource group contains the virtual network that needs to be paired with the Azure Managed Lustre virtual network. It matches the pattern **MC\_\<aks-rg-name\>\_\<aks-cluster-name\>\_\<region\>**.

To peer the AKS virtual network with your Azure Managed Lustre virtual network, consult [Virtual network peering](/azure/virtual-network/virtual-network-peering-overview).

> [!TIP]
> Due to the naming of the MC_ resource groups and virtual networks, names of networks can be similar or the same across multiple AKS deployments. When you're setting up peering, be careful to choose the AKS networks that you intend to choose.

## Connect to the AKS cluster for dynamic provisioning

1. Open a terminal session with access to the Azure CLI tools and sign in to your Azure account.

   ```azurecli
   az login
   ```

1. Sign in to [the Azure portal](https://portal.azure.com).

1. Find your AKS cluster. On the **Overview** pane, select the **Connect** button, and then copy the command for **Download cluster credentials**.

1. In your terminal session, paste the command to download the credentials. The command is similar to:

   ```azurecli
   az aks get-credentials --subscription <AKS_subscription_id> --resource_group <AKS_resource_group_name> --name <name_of_AKS>
   ```

1. Install kubectl if it's not present in your environment.

   ```azurecli
   az aks install-cli
   ```

1. Verify that the current context is the AKS cluster where you just installed the credentials and that you can connect to it.

   ```bash
   kubectl config current-context
   kubectl get deployments --all-namespaces=true
   ```

## Install the driver for dynamic provisioning

To install the Azure Lustre CSI Driver for Kubernetes, run the following command:

```bash
curl -skSL https://raw.githubusercontent.com/kubernetes-sigs/azurelustre-csi-driver/main/deploy/install-driver.sh | bash
```

To get sample commands for a local installation, see [Install the Azure Lustre CSI driver on a Kubernetes cluster](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/install-csi-driver.md).

## Create a Storage Class for dynamic provisioning

Create a file called `storageclass_dynprov_lustre.yaml` and copy in the following YAML. Edit the parameters as needed for your environment:

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: azurelustre-dynprov
provisioner: azurelustre.csi.azure.com
parameters:
  sku-name: "AMLFS-Durable-Premium-125"  # Choose appropriate SKU
  zone: "1"  # Specify zone if required for your SKU/location
  maintenance-day-of-week: "Sunday"
  maintenance-time-of-day-utc: "22:00"
  location: "eastus"  # Optional: defaults to AKS cluster location
  resource-group: "my-resource-group"  # Optional: defaults to AKS cluster RG
  vnet-name: "my-vnet"  # Optional: defaults to AKS cluster VNET
  subnet-name: "my-subnet"  # Optional: defaults to AKS cluster subnet
reclaimPolicy: Delete  # Change to "Retain" to keep clusters after PVC deletion
volumeBindingMode: Immediate
---
# Optional: Resource quota to limit number of clusters
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pvc-lustre-dynprov-quota
spec:
  hard:
    azurelustre-dynprov.storageclass.storage.k8s.io/persistentvolumeclaims: "1"
```

Apply the Storage Class to your AKS cluster:

```bash
kubectl apply -f storageclass_dynprov_lustre.yaml
```

## Create a Persistent Volume Claim for dynamic provisioning

Create a file called `pvc_storageclass_dynprov.yaml` and copy in the following YAML:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-lustre-dynprov
spec:
  accessModes:
    - ReadWriteMany
  storageClassName: azurelustre-dynprov
  resources:
    requests:
      storage: 48Ti  # Minimum size for AMLFS-Durable-Premium-125
```

Apply the PVC to your AKS cluster:

```bash
kubectl apply -f pvc_storageclass_dynprov.yaml
```

## Monitor cluster creation

Creating the Azure Managed Lustre cluster can take 10 minutes or more. You can monitor the progress:

```bash
kubectl describe pvc pvc-lustre-dynprov
```

While creating, the status is `Pending` with a message like:
`Waiting for a volume to be created either by the external provisioner 'azurelustre.csi.azure.com'...`

When the cluster is ready, the status changes to `Bound` with a success message.

## Create a pod for dynamic provisioning

Create a file called `pod_echo_date_dynprov.yaml` with the following YAML:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: lustre-echo-date-dynprov
spec:
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

After the pod is running, verify that the dynamically created Azure Managed Lustre file system is mounted correctly:

```bash
kubectl exec -it lustre-echo-date-dynprov -- df -h
```

You should see the Azure Managed Lustre file system mounted at `/mnt/lustre`.

## Clean up dynamic resources

To delete the dynamically created resources:

```bash
kubectl delete pvc pvc-lustre-dynprov
```

If the storage class has `reclaimPolicy: Delete`, this policy also deletes the Azure Managed Lustre cluster. If the policy is set to `Retain`, you must delete the cluster manually when it's no longer needed.

## Troubleshooting

For troubleshooting issues with the Azure Lustre CSI Driver, see the [CSI driver troubleshooting guide](https://github.com/kubernetes-sigs/azurelustre-csi-driver/blob/main/docs/csi-debug.md) in the GitHub repository.

Common issues for dynamic provisioning include:

- **Authentication or authorization errors** - verify kubelet identity permissions for creating Azure Managed Lustre clusters.
- **SKU and zone validation errors** - ensure the specified SKU is supported in your region and the zone configuration is correct.
- **Network IP address availability** - confirm sufficient IP addresses are available in the target subnet.
- **Quota limitations** - check both Kubernetes resource quotas and Azure subscription quotas for Azure Managed Lustre clusters.
- **Network connectivity problems** between AKS and Azure Managed Lustre - verify virtual network peering or subnet configuration.

For additional troubleshooting resources, see:
- [Azure Managed Lustre troubleshooting](troubleshoot-deployment.md)
- [Azure Lustre CSI Driver GitHub repository](https://github.com/kubernetes-sigs/azurelustre-csi-driver)

## Related content

- [Azure Lustre CSI driver overview](use-csi-driver-kubernetes.md)
- [Plan network architecture for AKS with Azure Managed Lustre](use-container-storage-interface-driver-network-planning.md).
- [Use static provisioning with the Azure Lustre CSI driver](use-container-storage-interface-driver-static-provisioning.md).
- [Validate CSI driver image security](use-container-storage-interface-driver-image-security.md).
