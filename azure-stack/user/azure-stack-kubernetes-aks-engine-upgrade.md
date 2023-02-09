---
title: Upgrade a Kubernetes cluster on Azure Stack Hub 
description: Learn how to upgrade a Kubernetes cluster on Azure Stack Hub. 
author: sethmanheim

ms.topic: article
ms.date: 3/4/2021
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 3/4/2021

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Upgrade a Kubernetes cluster on Azure Stack Hub

The AKS engine allows you to upgrade the cluster that was originally deployed using the tool. You can maintain the clusters using the AKS engine. Your maintenance tasks are similar to any IaaS system. You should be aware of the availability of new updates and use the AKS engine to apply them.
## Upgrade a cluster

The upgrade command updates the Kubernetes version and the base OS image. Every time that you run the upgrade command, for every node of the cluster, the AKS engine creates a new VM using the AKS Base Image associated to the version of **aks-engine** used. 

For AKS Enginer versions 0.73.0 and below, you can use the `aks-engine upgrade` command to maintain the currency of every master and agent node in your cluster. 

For AKS Enginer versions 0.75.3 and above, you can use the `aks-engine-azurestack upgrade` command to maintain the currency of every master and agent node in your cluster. 

Microsoft doesn't manage your cluster. But Microsoft provides the tool and VM image you can use to manage your cluster. 

For a deployed cluster upgrades cover:

-   Kubernetes
-   Azure Stack Hub Kubernetes provider
-   Base OS

When upgrading a production cluster, consider:

-   Are you using the correct cluster specification (`apimodel.json`) and resource group for the target cluster?
-   Are you using a reliable machine for the client machine to run the AKS engine and from which you are performing upgrade operations?
-   Make sure that you have a backup cluster and that it is operational.
-   If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.
-   Make sure that your subscription has enough space for the entire process. The process allocates new VMs during the process.
-   No system updates or scheduled tasks are planned.
-   Set up a staged upgrade on a cluster that is configured exactly as the production cluster and test the upgrade there before doing so in your production cluster

## Steps to upgrade to a newer Kubernetes version

> [!NOTE]  
> The AKS base image will also be upgrade if you are using a newer version of the aks-engine and the image is available in the marketplace.

The following instructions use the minimum steps to perform the upgrade. If you would like more detail, see the article [Upgrading Kubernetes Clusters](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).

1. You need to first determine the versions you can target for the upgrade. This version depends on the version you currently have and then use that version value to perform the upgrade. The Kubernetes versions supported by your AKS Engine can be listed by running the following command:
    
    ```bash
    aks-engine get-versions --azure-env AzureStackCloud
    ```
    
    For a complete mapping of AKS engine, AKS Base Image and Kubernetes versions see [Supported AKS Engine Versions](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping).

2. Collect the information you will need to run the `upgrade` command. The upgrade uses the following parameters:

    | Parameter | Example | Description |
    | --- | --- | --- |
    | azure-env | AzureStackCloud | To indicate to AKS engine that your target platform is Azure Stack Hub use `AzureStackCloud`. |
    | location | local | The region name for your Azure Stack Hub. For the ASDK, the region is set to `local`. |
    | resource-group | kube-rg | Enter the name of a new resource group or select an existing resource group. The resource name needs to be alphanumeric and lowercase. |
    | subscription-id | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter your Subscription ID. For more information, see [Subscribe to an offer](./azure-stack-subscribe-services.md#subscribe-to-an-offer) |
    | api-model | ./kubernetes-azurestack.json | Path to the cluster configuration file, or API model. |
    | client-id | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter the service principal GUID. The Client ID identified as the Application ID when your Azure Stack Hub administrator created the service principal. |
    | client-secret | xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx | Enter the service principal secret. This is the client secret you set up when creating your service. |
    | identity-system | adfs | Optional. Specify your identity management solution if you are using Active Directory Federated Services (AD FS). |

3. With your values in place, run the following command:

> [!Note]
> For AKSe version 0.75.3 and above, the command to upgrade AKS engine is `aks-engine-azurestack upgrade` 

    ```bash  
    aks-engine upgrade \
    --azure-env AzureStackCloud \
    --location <for an ASDK is local> \
    --resource-group kube-rg \
    --subscription-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --api-model kube-rg/apimodel.json \
    --upgrade-version 1.18.15 \
    --client-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --client-secret xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
    --identity-system adfs # required if using AD FS
    ```

4.  If for any reason the upgrade operation encounters a failure, you can rerun the upgrade command after addressing the issue. The AKS engine will resume the operation where it failed the previous time.

## Steps to only upgrade the OS image

1. Review [the supported-kubernetes-versions table](kubernetes-aks-engine-release-notes.md#aks-engine-and-azure-stack-version-mapping) and determine if you have the version of aks-engine and AKS base Image that you plan for your upgrade. To view the version of aks-engine run: `aks-engine version`.
2. Upgrade your AKS engine accordingly, in the machine where you have installed aks-engine run: `./get-akse.sh --version vx.xx.x` replacing **x.xx.x** with your targeted version.
3. Ask your Azure Stack Hub operator to add the version of the AKS Base Image you need in the Azure Stack Hub Marketplace that you plan to use.
4. Run the `aks-engine upgrade` command using the same version of Kubernetes that you are already using, but add the `--force`. You can see an example in [Forcing an upgrade](#forcing-an-upgrade).


## Steps to update cluster to OS version Ubuntu 18.04

With AKS engine version 0.60.1 and above you can upgrade your cluster VMs from Ubuntu 16.04 to 18.04. Follow these steps:

1. Locate and edit the `api-model.json` file that was generated during deployment. This should be the same file used for any upgrade or scale operation with `aks-engine`.
2. Locate the sections for `masterProfile` and `agentPoolProfiles`, within those sections change the value of `distro` to `aks-ubuntu-18.04`.
2. Save the `api-model.json` file and use the `api-model.json` file in your` aks-engin upgrade` command as you would in the [Steps to upgrade to a newer Kubernetes version](#steps-to-upgrade-to-a-newer-kubernetes-version)

## Steps to upgrade cluster if you're using storage volumes with AKS Engine v0.70.0 and later
The [Cloud Provider for Azure](https://github.com/kubernetes-sigs/cloud-provider-azure) project (also known as `cloud-controller-manager`, out-of-tree cloud provider or external cloud provider) implements the [Kubernetes cloud provider interface](https://github.com/kubernetes/cloud-provider) for Azure clouds. The out-of-tree implementation is the replacement for the deprecated [in-tree implementation](https://github.com/kubernetes/kubernetes/tree/master/staging/src/k8s.io/legacy-cloud-providers/azure).

On Azure Stack Hub, starting from Kubernetes v1.21, AKS Engine-based clusters will exclusively use `cloud-controller-manager`. Hence, to deploy a Kubernetes v1.21+ cluster, it's required to set `orchestratorProfile.kubernetesConfig.useCloudControllerManager` to `true` in the API Model ([example](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-azurestack.json)). AKS Engine's upgrade process will automatically update the `useCloudControllerManager` flag.


> [!NOTE]  
> **Upgrade considerations:** the process of upgrading a Kubernetes cluster from v1.20 (or lower version) to v1.21 (or greater version) will cause downtime to workloads relying on the `kubernetes.io/azure-disk` in-tree volume provisioner. Before upgrading to Kubernetes v1.21+, it's **highly recommended** to perform a full backup of the application data and validate in a **pre-production environment** that the cluster storage resources (PV and PVC) can be migrated to the a new volume provisioner. Learn how to migrate to the Azure Disk CSI driver [here](#migrate-persistent-storage-to-the-azure-disk-csi-driver).


### Volume provisioners

The [in-tree volume provisioner](https://kubernetes.io/blog/2019/12/09/kubernetes-1-17-feature-csi-migration-beta/) is only compatible with the in-tree cloud provider. Therefore, a v1.21+ cluster has to include a Container Storage Interface (CSI) Driver if user workloads rely on persistent storage. A few solutions available on Azure Stack Hub are listed [here](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#volume-provisioner-container-storage-interface-drivers-preview).

AKS Engine will **not** enable any CSI driver by default on Azure Stack Hub. For workloads that require a CSI driver, it's possible to either explicitly enable the `azuredisk-csi-driver` [addon](https://github.com/Azure/aks-engine/blob/master/docs/topics/clusterdefinitions.md#addons) (Linux-only clusters) or use `Helm` to [install the `azuredisk-csi-driver` chart](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#1-install-azure-disk-csi-driver-manually) (Linux and/or Windows clusters).

### Migrate persistent storage to the Azure Disk CSI driver

The process of upgrading an AKS Engine-based cluster from v1.20 (or lower version) to v1.21 (or greater version) will cause downtime to workloads relying on the `kubernetes.io/azure-disk` in-tree volume provisioner as this provisioner is not part of the [Cloud Provider for Azure](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#cloud-provider-for-azure).

If the data persisted in the underlying Azure disks should be preserved, then the following extra steps are required once the cluster upgrade process is completed:

1. [Install the Azure Disk CSI driver](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#1-install-azure-disk-csi-driver-manually)
1. [Remove the deprecated in-tree storage classes](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#2-replace-storage-classes)
1. [Recreate the persistent volumes and claims](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md#3-recreate-persistent-volumes)

#### 1. Install Azure Disk CSI driver manually

The following script uses `Helm` to install the Azure Disk CSI Driver:

```bash
DRIVER_VERSION=v1.10.0
helm repo add azuredisk-csi-driver https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts
helm install azuredisk-csi-driver azuredisk-csi-driver/azuredisk-csi-driver \
  --namespace kube-system \
  --set cloud=AzureStackCloud \
  --set controller.runOnMaster=true \
  --version ${DRIVER_VERSION}
```

#### 2. Replace storage classes

The `kube-addon-manager` will automatically create the Azure Disk CSI driver storage classes (`disk.csi.azure.com`) once the in-tree storage classes (`kubernetes.io/azure-disk`) are manually deleted:

```bash
IN_TREE_SC="default managed-premium managed-standard"

# Delete deprecated "kubernetes.io/azure-disk" storage classes
kubectl delete storageclasses ${IN_TREE_SC}

# Wait for addon manager to create the "disk.csi.azure.com" storage class resources
kubectl get --watch storageclasses
```

#### 3. Recreate persistent volumes

Once the Azure Disk CSI Driver is installed and the storage classes replaced, the next step is to recreate the persistent volumes (PV) and persistent volumes claims (PVC) using the Azure Disk CSI driver (or alternative CSI solution).

This is a multi-step process that can be different depending on how these resources were initially deployed. The high level steps are:

* Delete the deployment or statefulset that references the PV + PVC pairs to migrate (backup resource definition if necessary).
* Ensure the PVs' `persistentVolumeReclaimPolicy` property is set to value `Retain` ([example](/azure/aks/csi-storage-drivers#migrate-in-tree-persistent-volumes)).
* Delete the PV + PVC pairs to migrate (backup resource definitions if necessary).
* To migrate, update the PVs' resource definition by removing the `azureDisk` object and adding a `csi` object with reference to the original AzureDisk ([example](https://github.com/kubernetes-sigs/azuredisk-csi-driver/blob/master/docs/driver-parameters.md#static-provisioning-bring-your-own-azure-disk)).
* Recreate, in the following order, the PV resource/s, PVC resource/s (if necessary), and finally the deployment or statefulset.

The following migration [script](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/migratepv.sh) is provided as a template.

After running the migration script, if the pod is stuck with error "Unable to attach or mount volumes", make sure [Azure Disk CSI Driver was installed](#1-install-azure-disk-csi-driver-manually) and [storage classes were recreated](#2-replace-storage-classes).


## Forcing an upgrade

There may be conditions where you may want to force an upgrade of your cluster. For example, on day one you deploy a cluster in a disconnected environment using the latest Kubernetes version. The following day Ubuntu releases a patch to a vulnerability for which Microsoft generates a new **AKS Base Image**. You can apply the new image by forcing an upgrade using the same Kubernetes version you already deployed.

> [!Note]
> For AKSe version 0.75.3 and above, the command to upgrade AKS engine is `aks-engine-azurestack upgrade` 

```bash  
aks-engine upgrade \
--azure-env AzureStackCloud   
--location <for an ASDK is local> \
--resource-group kube-rg \
--subscription-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
--api-model kube-rg/apimodel.json \
--upgrade-version 1.18.15 \
--client-id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
--client-secret xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx \
--force
```

For instructions, see [Force upgrade](https://github.com/Azure/aks-engine/blob/master/docs/topics/upgrade.md#force-upgrade).

## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)
- [Scale a Kubernetes cluster on Azure Stack Hub](azure-stack-kubernetes-aks-engine-scale.md)
