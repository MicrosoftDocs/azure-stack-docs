---
title: Release notes for Azure Kubernetes Service (AKS) engine on Azure Stack Hub
description: Learn the steps you need to take with the update to AKS engine on Azure Stack Hub.
author: mattbriggs

ms.topic: article
ms.date: 03/01/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 03/01/2021

# Intent: As an Azure Stack Hub user, I would like to update a Kubernetes cluster using the AKS engine on a custom virtual network so that I can deliver my service in an environment that extends my data center or in a hybrid cloud solution with my cluster in Azure Stack Hub and Azure.
# Keywords: update ASK engine Azure Stack Hub

---

# Release notes for the AKS engine on Azure Stack Hub
::: moniker range=">=azs-2005"
*Applies to version v0.60.1 of the AKS engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. Notice that this isn't intended to document the release information for the AKS engine for global Azure.

## Update planning

The AKS engine upgrade command fully automates the upgrade process of your cluster, it takes care of virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the release note information.

### Upgrade considerations

-   Are you using the correct marketplace items, AKS Base Ubuntu 16.04-LTS or 18.04 Image Distro or AKS Base Windows Server for your version of the AKS engine? You can find the versions in the section "Download new images and AKS engine".
-   Are you using the correct cluster specification (apimodel.json) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the deploy command parameters [Deploy a Kubernetes cluster](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-cluster?view=azs-2008#deploy-a-kubernetes-cluster).
-   Are you using a reliable machine to run the AKS engine and from which you are performing upgrade operations?
-   If you are updating an operational cluster with active workloads, you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there is a need to redirect users to it. A backup cluster is highly recommended.
-   If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.
-   Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a couple more VMs to be created during the process.
-   No system updates or scheduled tasks are planned.
-   Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You will be required to use the AKS engine upgrade command as described in the following article [Upgrade a Kubernetes cluster on Azure Stack Hub](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-upgrade?view=azs-2008).

### Upgrade interruptions

Sometimes unexpected factors interrupt the upgrade of the cluster. An interruption can occur when the AKS engine reports an error or something happens to the AKS engine execution process. Examine the cause of the interruption, address it, and submit again the same upgrade command to continue the upgrade process. The **upgrade** command is idempotent and should resume the upgrade of the cluster once resubmitted the command. Normally, interruptions increase the time to complete the update, but should not affect the completion of it.

### Estimated upgrade time

The estimated time is between 12 to 15 minutes per VM in the cluster. For example, a 20-node cluster may take approximately to five (5) hours to upgrade.

## Download new image and AKS engine

Download the new versions of the AKS base Ubuntu Image and AKS engine.

As explained in the AKS engine for Azure Stack Hub documentation, deploying a Kubernetes cluster requires:

-   The aks-engine binary (required)
-   AKS Base Ubuntu 16.04-LTS Image Distro (required)
-   AKS Base Ubuntu 18.04-LTS Image Distro (optional)
-   AKS Base Windows Server Image Distro (optional)

New versions of these are available with this update:

-   The Azure Stack Hub operator will need to download the new AKS Base Images into the stamp marketplace:
    -   AKS Base Ubuntu 16.04-LTS Image Distro, January 2021 (2021.01.28)
        -   AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q1 (2021.01.28),
        -   AKS Base Windows Image (17763.1697.210129)

            Follow the instructions in the following article [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](https://docs.microsoft.com/azure-stack/operator/azure-stack-aks-engine?view=azs-2008)

-   The Kubernetes cluster administrator (normally a tenant user of Azure Stack Hub) will need to download the new aks-engine version 0.60.1. See instructions in the following article, [Install the AKS engine on Linux in Azure Stack Hub](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux?view=azs-2008) (or equivalent Windows article). You can follow the same process you used to install the cluster for the first time. The update will overwrite the previous binary. For example, if you used the get-akse.sh script, follow the same steps outlined in this section [Install in a connected environment](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux?view=azs-2008#install-in-a-connected-environment). The same process applies if you're installing in on a Windows system, article [Install the AKS engine on Windows in Azure Stack Hub](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-windows?view=azs-2008).

## AKS engine and Azure Stack version mapping

| Azure Stack Hub version                    | AKS engine version         |
|------------------------------------------------|--------------------------------|
| 1910                                           | 0.43.0, 0.43.1                 |
| 2002                                           | 0.48.0, 0.51.0                 |
| 2005                                           | 0.48.0, 0.51.0, 0.55.0, 0.55.4 |
| 2008                                           | 0.55.4, 0.60.1                 |

## Kubernetes version upgrade path in AKS engine v0.60.1

You can find the current version and upgrade version in the following table for Azure Stack Hub. Don't follow the aks-engine get-versions command since the command one also includes the versions supported in global Azure. The following version and upgrade table applies to the AKS engine cluster in Azure Stack Hub.

| Current version                                       | Upgrade available |
|-----------------------------------------------------------|-----------------------|
| 1.15.12                                                   | 1.16.14, 1.16.15      |
| 1.16.14                                                   | 1.16.15, 1.17.17      |
| 1.17.11                                                   | 1.17.17, 1.18.15      |
| 1.17.17                                                   | 1.18.15               |

In the API Model json file, please specify the release and version values under the orchestratorProfile section, for example, if you are planning to deploy Kubernetes 1.17.17, the following two values must be set, (see example [kubernetes-azurestack.json](https://aka.ms/aksengine-json-example-raw)):

```json  
    -   "orchestratorRelease": "1.17",
    -   "orchestratorVersion": "1.17.17"
```

## AKS engine and corresponding image mapping

|      AKS engine     |      AKS base image     |      Kubernetes versions     |      API model samples     |
|-|-|-|-|
|     v0.43.1    |     AKS Base Ubuntu 16.04-LTS Image Distro, October 2019   (2019.10.24)    |     1.15.5, 1.15.4, 1.14.8, 1.14.7    |  |
|     v0.48.0    |     AKS Base Ubuntu 16.04-LTS Image Distro, March 2020   (2020.03.19)    |     1.15.10, 1.14.7    |  |
|     v0.51.0    |     AKS Base Ubuntu 16.04-LTS Image Distro, May 2020 (2020.05.13),   AKS Base Windows Image (17763.1217.200513)    |     1.15.12, 1.16.8, 1.16.9    |     [Linux](https://github.com/Azure/aks-engine/blob/v0.51.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.51.0/examples/azure-stack/kubernetes-windows.json)    |
|     v0.55.0    |     AKS Base Ubuntu 16.04-LTS Image Distro, August 2020   (2020.08.24), AKS Base Windows Image (17763.1397.200820)    |     1.15.12, 1.16.14, 1.17.11    |     [Linux](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-windows.json)    |
|     v0.55.4    |     AKS Base Ubuntu 16.04-LTS Image Distro, September 2020   (2020.09.14), AKS Base Windows Image (17763.1397.200820)    |     1.15.12, 1.16.14, 1.17.11    |     [Linux](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-windows.json)    |
|     V0.60.1    |     AKS Base Ubuntu 16.04-LTS Image Distro, January 2021 (2021.01.28),   <br>AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q1 (2021.01.28), <br>AKS   Base Windows Image (17763.1697.210129)    |     1.16.14, 1.16.15, 1.17.17, 1.18.15    |     [Linux](), [Windows]()    |

## What's new

If you are interested in participating in a private preview, you can [request preview access](https://forms.office.com/r/yqxXyiDcGG).

New features inclue:
-   General Availability of Ubuntu 18.04
-   Certificate Rotation Public Preview [\#4214](https://github.com/Azure/aks-engine/pull/4214)
-   T4 Nvidia GPU Private Preview [\#4259](https://github.com/Azure/aks-engine/pull/4259)
-   Azure Active Directory integration private preview
-   CSI Driver for Azure Blobs Private Preview [\#712](https://github.com/kubernetes-sigs/azuredisk-csi-driver/pull/712)
-   CSI Driver Azure Disks Public Preview [\#712](https://github.com/kubernetes-sigs/azuredisk-csi-driver/pull/712)
-   CSI Driver NFS Public Preview [\#712](https://github.com/kubernetes-sigs/azuredisk-csi-driver/pull/712)
-   Support for Kubernetes 1. 17.17 [\#4188](https://github.com/Azure/aks-engine/issues/4188) and 1.18.15 [\#4187](https://github.com/Azure/aks-engine/issues/4187)

## Known issues

-   Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. We recommend deploying one service at the time.
-   Running aks-engine get-versions will produce information applicable to Azure and Azure Stack Hub, however, there is not an explicit way to discern what corresponds to Azure Stack Hub. Do not use this command to figure out what versions are available to upgrade. Use the upgrade reference table described above.
-   Since the aks-engine tool is a share source code repository across Azure and Azure Stack Hub. Examining the many release notes and Pull Requests will lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond the listed above, ignore them and use the version table above as the official guide for this update.

> [!NOTE]  
> Windows Container and Azure CNI support is available in public preview.

## Reference

This is the complete set of release notes for Azure and Azure Stack Hub combined:

-   https://github.com/Azure/aks-engine/releases/tag/v0.56.0
-   https://github.com/Azure/aks-engine/releases/tag/v0.56.1
-   https://github.com/Azure/aks-engine/releases/tag/v0.60.0
-   https://github.com/Azure/aks-engine/releases/tag/v0.60.1
::: moniker-end
::: moniker range=">=azs-2005"
*Applies to version v0.55.4 of the AKS engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. Notice that this isn't intended to document the release information for the AKS engine for global Azure.

## Update planning

The AKS engine upgrade command fully automates the upgrade process of your cluster, it takes care of virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the release note information.

### Upgrade considerations

-   Are you using the correct marketplace item, AKS Base Ubuntu 16.04-LTS Image Distro for your version of the AKS engine? You can find the versions in the section "Download new image and AKS engine".

-   Are you using the correct cluster specification (`apimodel.json`) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the `deploy` command parameters [Deploy a Kubernetes cluster](./azure-stack-kubernetes-aks-engine-deploy-cluster.md#deploy-a-kubernetes-cluster).

-   Are you using a reliable machine to run the AKS engine and from which you are performing upgrade operations?

-   If you are updating an operational cluster with active workloads you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there is a need to redirect users to it. A backup cluster is highly recommended.

-   If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.

-   Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a couple more VMs to be created during the process.

-   No system updates or scheduled tasks are planned.

-   Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You will be required to use the AKS engine `upgrade` command as described in the following article [Upgrade a Kubernetes cluster on Azure Stack Hub](./azure-stack-kubernetes-aks-engine-upgrade.md).

### Upgrade interruptions

Sometimes unexpected factors interrupt the upgrade of the cluster. An interruption can occur when the AKS engine reports an error or something happens to the AKS engine execution process. Examine the cause of the interruption, address it, and submit again the same upgrade command to continue the upgrade process. The **upgrade** command is idempotent and should resume the upgrade of the cluster once resubmitted the command. Normally, interruptions increase the time to complete the update, but should not affect the completion of it.

### Estimated upgrade time

The estimated time is between 12 to 15 minutes per VM in the cluster. For example, a 20-node cluster may take approximately to five (5) hours to upgrade.

## Download new image and AKS engine

Download the new versions of the AKS base Ubuntu Image and AKS engine.

As explained in the AKS engine for Azure Stack Hub documentation, deploying a Kubernetes cluster requires two main components:

-   The aks-engine binary

-   AKS Base Ubuntu 16.04-LTS Image Distro

New versions of these are available with this update:

-   The Azure Stack Hub operator will need to download a new AKS base Ubuntu Image into the stamp marketplace:

    -   Name: AKS Base Ubuntu 16.04-LTS Image Distro, September 2020 (2020.09.14)

    -   Version: 2020.09.14

    -   Follow the instructions in the following article [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md)

-   The Kubernetes cluster administrator will need to download the new aks-engine version 0.51.0. See instructions in the following article, [Install the AKS engine on Linux in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-linux.md). You can follow the same process you use to install the cluster for the first time. The update will overwrite the previous binary. For example, if you used the get-akse.sh script, follow the same steps outlined in this section [Install in a connected environment](./azure-stack-kubernetes-aks-engine-deploy-linux.md#install-in-a-connected-environment). The same process applies if you're installing in on a Windows system, article [Install the AKS engine on Windows in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-windows.md).


## AKS engine and Azure Stack version mapping

| Azure Stack Hub version | AKS engine version |
| ----------------------------- | ------------------------ |
| 1910 | 0.43.0, 0.43.1 |
| 2002 | 0.48.0, 0.51.0 |
| 2005 | 0.48.0, 0.51.0, 0.55.0, 0.55.4 |

## Kubernetes version upgrade path in AKS engine v0.55.4

You can find the current version and upgrade version in the following table for Azure Stack Hub. Don't follow the aks-engine get-versions command since the command one also includes the versions supported in global Azure. The following version and upgrade table applies to the AKS engine cluster in Azure Stack Hub.

| Current version | Upgrade available |
| ------------------------- | ----------------------- |
| 1.15.10 | 1.15.12 |
| 1.15.12, 1.16.8, 1.16.9 | 1.16.14 |
| 1.16.8, 1.16.9, 1.16.14 | 1.17.11 |

In the API Model json file, please specify the release and version values under the `orchestratorProfile` section, for example, if you are planning to deploy Kubernetes 1.16.14, the following two values must be set, (see example [kubernetes-azurestack.json](https://aka.ms/aksengine-json-example-raw)):

```json  
    -   "orchestratorRelease": "1.16",
    -   "orchestratorVersion": "1.16.14"
```

## AKS engine and corresponding image mapping

| AKS Engine | AKS Base Image | Kubernetes versions | Notes |
|---|---|---|---|
| v0.43.1 | AKS Base Ubuntu 16.04-LTS Image Distro, October 2019 (2019.10.24) | 1.15.5, 1.15.4, 1.14.8, 1.14.7 |  |
| v0.48.0 | AKS Base Ubuntu 16.04-LTS Image Distro, March 2020 (2020.03.19) | 1.15.10, 1.14.7 |  |
| v0.51.0 | AKS Base Ubuntu 16.04-LTS Image Distro, May 2020 (2020.05.13), AKS Base Windows Image (17763.1217.200513) | 1.15.12, 1.16.8, 1.16.9 | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/v0.51.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.51.0/examples/azure-stack/kubernetes-windows.json)) |
| v0.55.0 | AKS Base Ubuntu 16.04-LTS Image Distro, August 2020 (2020.08.24), AKS Base Windows Image (17763.1397.200820) | 1.15.12, 1.16.14, 1.17.11 | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-windows.json)) |
| v0.55.4 | AKS Base Ubuntu 16.04-LTS Image Distro, September 2020 (2020.09.14), AKS Base Windows Image (17763.1397.200820) | 1.15.12, 1.16.14, 1.17.11 | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-windows.json) |

## What's new

- Update Azure Stack's Linux VHD to 2020.09.14 #[3828](https://github.com/Azure/aks-engine/pull/3828)
- Adds support for K8s v1.17.11 on Azure Stack [#3702](https://github.com/Azure/aks-engine/pull/3702)
- Adds support for K8s v1.16.14 on Azure Stack [#3704](https://github.com/Azure/aks-engine/pull/3704)
- Linux VHD update to 2020.09.14 [#3750](https://github.com/Azure/aks-engine/pull/3750)
- Windows VHD update to August [#3730](https://github.com/Azure/aks-engine/pull/3730)
- Upgrades Kubernetes metrics-server to v0.3.7 [#3669](https://github.com/Azure/aks-engine/pull/3669)
- Upgrades docker version to fix log rotation issue [#3693](https://github.com/Azure/aks-engine/pull/3693)
- Upgrades CoreDNS to v1.7.0 [#3608](https://github.com/Azure/aks-engine/pull/3608)
- Use moby 19.03.x packages [#3549](https://github.com/Azure/aks-engine/pull/3549)
- Fixes to azure-cni update strategy [#3571](https://github.com/Azure/aks-engine/pull/3571)

## Known issues

-   Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. Deploying one service at the time if possible.
-   Running aks-engine get-versions will produce information applicable to Azure and Azure Stack Hub, however, there is not explicit way to discern what corresponds to Azure Stack Hub. Do not use this command to figure out what versions are available to upgrade. Use the upgrade reference table described above.
-   Since aks-engine tool is a share source code repository across Azure and Azure Stack Hub. Examining the many release notes and Pull Requests will lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond the listed above, ignore them and use the version table above as the official guide for this update.

> [!NOTE]  
> Windows Container and Azure CNI support is available in the public preview. If you would like to join the preview, you can request access: [https://aka.ms/ash-k8s-win-azurecni](https://aka.ms/ash-k8s-win-azurecni)

## Reference

This is the complete set of release notes for Azure and Azure Stack Hub combined:

- https://github.com/Azure/aks-engine/releases/tag/v0.51.1
- https://github.com/Azure/aks-engine/releases/tag/v0.52.1
- https://github.com/Azure/aks-engine/releases/tag/v0.53.1
- https://github.com/Azure/aks-engine/releases/tag/v0.54.1
- https://github.com/Azure/aks-engine/releases/tag/v0.55.0
- https://github.com/Azure/aks-engine/releases/tag/v0.55.4

::: moniker-end
::: moniker range="<=azs-1910"
*Applies to version 0.48.0 or earlier of the AKS engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. Notice that this isn't intended to document the release information for the AKS engine for global Azure.

## Update planning

The AKS engine upgrade command fully automates the upgrade process of your cluster, it takes care of virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the information in this article.

### Upgrade considerations

-   Are you using the correct marketplace item, AKS Base Ubuntu 16.04-LTS Image Distro for your version of the AKS engine? You can find the versions in the section [Download the new AKS base Ubuntu Image and AKS engine versions](#download-new-image-and-aks-engine).

-   Are you using the correct cluster specification (apimodel.json) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the "deploy" command parameters [Deploy a Kubernetes cluster](./azure-stack-kubernetes-aks-engine-deploy-cluster.md#deploy-a-kubernetes-cluster).

-   Are you using a reliable machine to run the AKS engine and from which you are performing upgrade operations?

-   If you are updating an operational cluster with active workloads you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there is a need to redirect users to it.

-   If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.

-   Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a couple more VMs to be created during the process.

-   No system updates or scheduled tasks are planned.

-   Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You will be required to use the AKS engine "upgrade" command as described in the following article [Upgrade a Kubernetes cluster on Azure Stack Hub](./azure-stack-kubernetes-aks-engine-upgrade.md).

### Upgrade interruptions

Sometimes unexpected factors interrupt the upgrade of the cluster. An interruption can occur when the AKS engine reports an error or something happens to the AKS engine execution process. Examine the cause of the interruption, address it, and submit again the same upgrade command to continue the upgrade process. The **upgrade** command is idempotent and should resume the upgrade of the cluster once resubmitted the command. Normally, interruptions increase the time to complete the update, but should not affect the completion of it.

### Estimated upgrade time

The estimated time is between 12 to 15 minutes per VM in the cluster. For example, a 20-node cluster may take approximately to five (5) hours to upgrade.

## Download new image and AKS engine

Download the new versions of the AKS base Ubuntu Image and AKS engine.

As explained in the AKS engine for Azure Stack Hub documentation, deploying a Kubernetes cluster requires two main components: 
- The aks-engine binary
- AKS Base Ubuntu 16.04-LTS Image Distro

New versions of these are available with this update:

-   The Azure Stack Hub operator will need to download a new AKS base Ubuntu Image:

    -   Name: `AKS Base Ubuntu 16.04-LTS Image Distro, March 2020`
    -   Version: `2020.03.19`
    -   Follow the instructions in the following article [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md)

-   The Kubernetes cluster administrator will need to download the new aks-engine version 0.48.0. See instructions in this the following article, [Install the AKS engine on Linux in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-linux.md). You can follow the same process you use to install the cluster for the first time. The update will overwrite the previous binary. For example, if you used the `get-akse.sh` script, follow the same steps outlined in the article [Install in a connected environment](./azure-stack-kubernetes-aks-engine-deploy-linux.md#install-in-a-connected-environment). The same process applies if you're installing in on a Windows system, article [Install the AKS engine on Windows in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-windows.md).

## Kubernetes version upgrade path

You can find the current version and upgrade version in the following table for Azure Stack Hub. Don't follow the aks-engine `get-versions` command since the command one also includes the versions supported in global Azure. The following version and upgrade table applies to the AKS engine cluster in Azure Stack Hub.

| **Current version** | **Upgrade available** |
| --------------------| ----------------------|
| 1.14.7 | 1.15.10 |
| 1.14.8 | 1.15.10 |
| 1.15.4 | 1.15.10 |
| 1.15.5 | 1.15.10 |

## What's new 

-   Support for Kubernetes version 1.15.10 ([\#2834](https://github.com/Azure/aks-engine/issues/2834)). When deploying a new cluster make sure to specify in your api model json file (a.k.s. cluster definition file) the release version number as well as the minor version number. You can find an example: [kubernetes-azurestack.json](https://aka.ms/aksengine-json-example-raw):

    - `"orchestratorRelease": "1.15`,

    - `"orchestratorVersion": "1.15.10"`

    > [!NOTE]  
    > If the Kubernetes version is not explicitly provided in the API model json file, version `1.15` will be used ([\#2932](https://github.com/Azure/aks-engine/issues/2932)) and the orchestratorVersion will default to` 1.15.11`, which will result in an error during deployment of the cluster.

-   With aks-engine v0.43.1, the default frequency settings for the cloud provider to perform its control loop and other tasks do not work well with Azure Stack Hub Resource Manager threshold limits for incoming requests. This update changes defaults for Azure Stack Hub to reduce the retry load to Azure Stack Hub Resource Manager ([\#2861](https://github.com/Azure/aks-engine/issues/2861)).

-   New verification step in aks-engine will result in either execution stopping or displaying warnings if api model json file contains properties not supported by Azure Stack Hub ([\#2717](https://github.com/Azure/aks-engine/issues/2717)).

-   With a new verification check-in, the aks-engine will validate availability of the version of the AKS base image needed for the version of aks-engine executing ([\#2342](https://github.com/Azure/aks-engine/issues/2342)). This will occur after parsing the api model file and before calling the Azure Stack Hub Resource Manager.

-   New aks-engine option "--control-plane-only" in the "upgrade" command allows the user to upgrade operations to target only the master Virtual Machines ([\#2635](https://github.com/Azure/aks-engine/issues/2635)).

-   Updates to Linux Kernel version 4.15.0-1071-azure for Ubuntu 16.04-LTS. See "[Package: linux-image-4.15.0-1071-azure (4.15.0-1071.76) \[security\]](https://packages.ubuntu.com/xenial/linux-image-4.15.0-1071-azure)" for details.

-   New hyperkube updates to support Kubernetes versions 1.14.8 and 1.15.10.

-   Update kubectl to match the version of Kubernetes for the cluster.. This component is available in the Kubernetes cluster master nodes, you can run it by SSH into a master.

-   Updates for the Azure Container Monitor add-on with latest [February 2020 release](https://github.com/microsoft/Docker-Provider/blob/ci_feature_prod/README.md) ([\#2850](https://github.com/Azure/aks-engine/issues/2850)).

-   Upgrade of `coredns` to version v1.6.6 ([\#2555](https://github.com/Azure/aks-engine/issues/2555)).

-   Upgrade `etcd` to version 3.3.18 ([\#2462](https://github.com/Azure/aks-engine/issues/2462)).

-   Upgrade `moby` to version 3.0.11 ([\#2887](https://github.com/Azure/aks-engine/issues/2887)).

-   With this release AKS Engine cuts dependency from `k8s.gcr.io` to now use the official `Kubernetes MCR registry @ mcr.microsoft.com` when building its images ([\#2722](https://github.com/Azure/aks-engine/issues/2722)).

## Known issues

-  Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. Deploying one service at the time if possible.

-  Running aks-engine get-versions will produce information applicable to Azure and Azure Stack Hub, however, there is not explicit way to discern what corresponds to Azure Stack Hub. Do not use this command to figure out what versions area available to upgrade. Use the upgrade reference table described above.

-  Since aks-engine tool is a share source code repository across Azure and Azure Stack Hub. Examining the many release notes and Pull Requests will lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond the listed above, please ignore them and use the version table above as the official guide for this update.

## Reference

Following is a list of some of the bugs fixed as well as the complete set of release notes from 0.44.0 to 0.48.0, notice that the latter list will include Azure and Azure Stack Hub items

### Bug fixes

-   `userAssignedIdentityId` in windows `azure.json` missing quotes ([\#2327](https://github.com/Azure/aks-engine/issues/2327))

-   Addons `update config` is upgrade-only ([\#2282](https://github.com/Azure/aks-engine/issues/2282))

-   Bumping timeout for getting management IP on windows nodes ([\#2284](https://github.com/Azure/aks-engine/issues/2284))

-   Add 1.0.28 Azure CNI zip file into windows VHD ([\#2268](https://github.com/Azure/aks-engine/issues/2268))

-   Correct defaults order for setting IPAddressCount ([\#2358](https://github.com/Azure/aks-engine/issues/2358))

-   Update to use single omsagent yaml for all k8s versions to avoid any manual errors and easy maintainability ([\#2692](https://github.com/Azure/aks-engine/issues/2692))

### Release notes

This is the complete set of release notes for Azure and Azure Stack Hub combined

-   https://github.com/Azure/aks-engine/releases/tag/v0.44.0
-   https://github.com/Azure/aks-engine/releases/tag/v0.44.1
-   https://github.com/Azure/aks-engine/releases/tag/v0.44.2
-   https://github.com/Azure/aks-engine/releases/tag/v0.45.0
-   https://github.com/Azure/aks-engine/releases/tag/v0.46.0
-   https://github.com/Azure/aks-engine/releases/tag/v0.46.1
-   https://github.com/Azure/aks-engine/releases/tag/v0.46.2
-   https://github.com/Azure/aks-engine/releases/tag/v0.46.3
-   https://github.com/Azure/aks-engine/releases/tag/v0.47.0
-   https://github.com/Azure/aks-engine/releases/tag/v0.48.0
::: moniker-end
## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)
