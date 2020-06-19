---
title: Release notes for the Azure Kubernetes Service (AKS) engine on Azure Stack Hub
description: Learn the steps you need to take with the update to AKS engine on Azure Stack Hub.
author: mattbriggs

ms.topic: article
ms.date: 06/19/2020
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 06/19/2020

# Intent: As an Azure Stack Hub user, I would like to update a Kubernetes cluster using the AKS engine on a custom virtual network so that I can deliver my service in an environment that extends my data center or in a hybrid cloud solution with my cluster in Azure Stack Hub and Azure.
# Keywords: update ASK engine Azure Stack Hub

---

# Release notes for the AKS engine on Azure Stack Hub
::: moniker range=">=azs-2002"
*Applies to version 0.51.0 of the ASK engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. Notice that this isn't intended to document the release information for the AKS engine for global Azure.

## Update planning

The AKS engine upgrade command fully automates the upgrade process of your cluster, it takes care of virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the information in this article.

### Upgrade considerations

-   Are you using the correct marketplace item, AKS Base Ubuntu 16.04-LTS Image Distro for your version of the AKS engine? You can find the versions in the section "Download new image and AKS engine".

-   Are you using the correct cluster specification (`apimodel.json`) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the `deploy` command parameters [Deploy a Kubernetes cluster](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-cluster#deploy-a-kubernetes-cluster).

-   Are you using a reliable machine to run the AKS engine and from which you are performing upgrade operations?

-   If you are updating an operational cluster with active workloads you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there is a need to redirect users to it. A backup cluster is highly recommended.

-   If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.

-   Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a couple more VMs to be created during the process.

-   No system updates or scheduled tasks are planned.

-   Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You will be required to use the AKS engine `upgrade` command as described in the following article [Upgrade a Kubernetes cluster on Azure Stack Hub](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-upgrade).

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

    -   Name: AKS Base Ubuntu 16.04-LTS Image Distro, May 2020 (2020.05.13)

    -   Version: 2020.05.13

    -   Follow the instructions in the following article [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](https://docs.microsoft.com/azure-stack/operator/azure-stack-aks-engine)

-   The Kubernetes cluster administrator will need to download the new aks-engine version 0.51.0. See instructions in the following article, [Install the AKS engine on Linux in Azure Stack Hub](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux). You can follow the same process you use to install the cluster for the first time. The update will overwrite the previous binary. For example, if you used the get-akse.sh script, follow the same steps outlined in this section [Install in a connected environment](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-linux#install-in-a-connected-environment). The same process applies if you're installing in on a Windows system, article [Install the AKS engine on Windows in Azure Stack Hub](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-deploy-windows).

## AKS engine and Azure Stack version mapping

| Azure Stack Hub version | AKS engine version |
| ----------------------------- | ------------------------ |
| 1910 | 0.43.0 |
| 2002 | 0.43.1, 0.51.0 |

## Kubernetes version upgrade path in AKS engine 0.51.0

You can find the current version and upgrade version in the following table for Azure Stack Hub. Don't follow the aks-engine get-versions command since the command one also includes the versions supported in global Azure. The following version and upgrade table applies to the AKS engine cluster in Azure Stack Hub.

| Current version | Upgrade available |
| ------------------------- | ----------------------- |
| 1.14.7, 1.14.8 | 1.15.12 |
| 1.15.4, 1.15.5, 1.15.10 | 1.15.12, 1.16.9 |
| 1.15.12 | 1.16.9 |
| 1.16.8 | 1.16.9, 1.17.5 |
| 1.16.9 | 1.17.5 |
| 1.17.4 | 1.17.5 |

In the API Model json file, please specify the release and version values under the `orchestratorProfile` section, for example, if you are planning to deploy Kubernetes 1.16.9, the following two values must be set, (see example [kubernetes-azurestack.json](https://raw.githubusercontent.com/Azure/aks-engine/master/examples/azure-stack/kubernetes-azurestack.json)):

```json  
    -   "orchestratorRelease": "1.16",
    -   "orchestratorVersion": "1.16.9"
```

## What's new

-   Add support for Kubernetes 1.15.12 ([#3212](https://github.com/Azure/aks-engine/issues/3212))
-   Add support for Kubernetes 1.16.8 & 1.16.9 ([#3157](https://github.com/Azure/aks-engine/issues/3157) and [#3087](https://github.com/Azure/aks-engine/issues/3087))
-   Add support for Kubernetes 1.17.5 ([#3088](https://github.com/Azure/aks-engine/issues/3088))
-   Kubernetes Dashboard addon v2.0.0 ([#3140](https://github.com/Azure/aks-engine/issues/3140))
-   Improve operation reliability by removing superfluous** wait for no held apt locks** After apt operations have already completed ([#3049](https://github.com/Azure/aks-engine/issues/3049))
-   Improve operation reliability by completing script run even after getting an error when connecting to the K8s API server ([#3022](https://github.com/Azure/aks-engine/issues/3022))
-   Improve operation reliability by checking for DNS configuration status before connecting ([#3002](https://github.com/Azure/aks-engine/issues/3002))
-   Fix issue provisioning windows nodes with kubenet ([#3300](https://github.com/Azure/aks-engine/issues/3300))
-   Fix to start of systemd and etcd to ensure idempotent process ([#3126](https://github.com/Azure/aks-engine/issues/3126))
-   Remove support for Kubernetes 1.13 and 1.14 ([#3310](https://github.com/Azure/aks-engine/issues/3310) and [#3059](https://github.com/Azure/aks-engine/issues/3059))
-   Ensure pod-security-policy is the first addon loaded ([#3313](https://github.com/Azure/aks-engine/issues/3313))
-   Update azure CNI version to v1.1.0 ([#3075](https://github.com/Azure/aks-engine/issues/3075)) (preview)
-   Add features and fixes to support Windows containers in Azure Stack Hub (preview):
    -   Fix to Windows version collection ([#2954](https://github.com/Azure/aks-engine/issues/2954))
    -   Update Azure Stack Windows binaries component name ([#3231](https://github.com/Azure/aks-engine/issues/3231))
    -   Update Windows image validate on Azure Stack Hub ([#3260](https://github.com/Azure/aks-engine/issues/3260))
    -   Update Windows VHDs to include May patches ([#3263](https://github.com/Azure/aks-engine/issues/3263))
    -   Update Windows VHDs with 4B patches ([#3115](https://github.com/Azure/aks-engine/issues/3115))
    -   update Windows VHD to include April patches ([#3101](https://github.com/Azure/aks-engine/issues/3101))

## Known issues

-   Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. Deploying one service at the time if possible.
-   Running aks-engine get-versions will produce information applicable to Azure and Azure Stack Hub, however, there is not explicit way to discern what corresponds to Azure Stack Hub. Do not use this command to figure out what versions area available to upgrade. Use the upgrade reference table described above.
-   Since aks-engine tool is a share source code repository across Azure and Azure Stack Hub. Examining the many release notes and Pull Requests will lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond the listed above, ignore them and use the version table above as the official guide for this update.

## Reference

This is the complete set of release notes for Azure and Azure Stack Hub combined:

-   https://github.com/Azure/aks-engine/releases/tag/v0.49.0
-   https://github.com/Azure/aks-engine/releases/tag/v0.50.0
-   https://github.com/Azure/aks-engine/releases/tag/v0.51.0
::: moniker-end
::: moniker range="<=azs-1910"

::: moniker-end
## Next steps

- Read about the [The AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)
