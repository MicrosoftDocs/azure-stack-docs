---
title: Release notes for Azure Kubernetes Service (AKS) engine on Azure Stack Hub
description: Learn the steps you need to take with the update to AKS engine on Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 05/26/2023
ms.author: sethm
ms.reviewer: sumsmith
ms.lastreviewed: 09/23/2022

# Intent: As an Azure Stack Hub user, I would like to update a Kubernetes cluster using AKS engine on a custom virtual network so that I can deliver my service in an environment that extends my data center or in a hybrid cloud solution with my cluster in Azure Stack Hub and Azure.
# Keywords: update ASK engine Azure Stack Hub

---

# Release notes for AKS engine on Azure Stack Hub

::: moniker range=">=azs-2206"
*Applies to version v0.79.0 of the AKS engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. This article isn't intended to document the release information for AKS engine for global Azure.

### Upgrade considerations

- Are you using the correct marketplace items, AKS Base Ubuntu 20.04 Image Distro or AKS Base Windows Server for your version of the AKS engine? You can find the versions in the section [Download new images and AKS engine](#download-new-image-and-aks-engine).
- Are you using the correct cluster specification (**apimodel.json**) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the deploy command parameters [Deploy a Kubernetes cluster](./azure-stack-kubernetes-aks-engine-deploy-cluster.md#deploy-a-kubernetes-cluster).
- Are you using a reliable machine to run the AKS engine and from which you're performing upgrade operations?
- If you're updating an operational cluster with active workloads, you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there's a need to redirect users to it. A backup cluster is highly recommended.
- If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.
- Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a few more VMs to be created during the process.
- No system updates or scheduled tasks are planned.
- Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You must use the `aks-engine upgrade` command as described in [Upgrade a Kubernetes cluster on Azure Stack Hub](./azure-stack-kubernetes-aks-engine-upgrade.md).

### Upgrade interruptions

Sometimes unexpected factors interrupt the upgrade of the cluster. An interruption can occur when AKS engine reports an error or something happens to the AKS engine execution process. Examine the cause of the interruption, address it, and re-submit the same `upgrade` command to continue the upgrade process. The `upgrade` command is idempotent and should resume the upgrade of the cluster once you resubmit the command. Normally, interruptions increase the time to complete the update, but shouldn't affect its completion.

### Estimated upgrade time

The estimated upgrade time is 12 to 15 minutes per VM in the cluster. For example, a 20-node cluster can take about 5 hours to upgrade.

## Instructions to use AKS engine 0.70.0 and above

### Download new image and AKS engine

Download the new versions of the AKS base Ubuntu image and AKS engine.

As explained in the documentation for AKS engine for Azure Stack Hub, deploying a Kubernetes cluster requires:

- The **aks-engine** binary (required).
- AKS Base Ubuntu 16.04-LTS Image Distro (deprecated - no longer use, change in API Model to use 20.04 instead).
- AKS Base Ubuntu 18.04-LTS Image Distro (deprecated - no longer use, change in API Model to use 20.04 instead).
- AKS Base Ubuntu 20.04-LTS Image Distro (required for Linux agents).
- AKS Base Windows Server Image (one of the following images is required for Windows agents):
  - AKS Base Windows Server Image Containerd.
  - AKS Base Windows Server Image Docker.

New versions of these images are available with this update:

- Check the [AKS engine and Azure Stack version mapping](#aks-engine-and-azure-stack-version-mapping) table for the required AKS base images.

    Follow the instructions in [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md).

- The Kubernetes cluster administrator (normally a tenant user of Azure Stack Hub) must download the new **aks-engine**. See the instructions in [Install the AKS engine on Linux in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-linux.md) (or equivalent Windows article). You can follow the same process you used to install the cluster for the first time. The update overwrites the previous binary. For example, if you used the **get-akse.sh** script, follow the same steps outlined in [Install in a connected environment](./azure-stack-kubernetes-aks-engine-deploy-linux.md#install-in-a-connected-environment). The same process applies if you're installing on a Windows system: [Install the AKS engine on Windows in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-windows.md).

### Upgrading Kubernetes clusters created with the Ubuntu 16.04 distro

Starting with AKS Engine v0.63.0, the Ubuntu 16.04 distro is no longer a supported option, as the OS has reached its end-of-life. For AKS Engine v0.67.0 or later versions, the **aks-engine** upgrade automatically overwrites the unsupported `aks-ubuntu-16.04` distro value with with `aks-ubuntu-18.04`. For AKS Engine v0.75.3 or later versions, if you're using Kubernetes v1.24 or above, the **aks-engine-azurestack** upgrade automatically overwrites the unsupported `aks-ubuntu-16.04` distro value with `aks-ubuntu-20.04`.

### Upgrading Kubernetes clusters created with the Ubuntu 18.04 distro

Starting with AKS Engine v0.75.3, the Ubuntu 18.04 distro is no longer a supported option, as the OS has reached its end-of-life. For AKS Engine v0.75.3 or later versions, the **aks-engine-azurestack** upgrade automatically overwrites the unsupported `aks-ubuntu-18.04` distro value with `aks-ubuntu-20.04`.

### Upgrading Kubernetes clusters created with docker container runtime

In Kubernetes v1.24, the **dockershim** component was removed from kubelet. As a result, the docker container runtime is no longer a supported option. See the [Kubernetes v1.24 release notes](https://kubernetes.io/blog/2022/05/03/kubernetes-1-24-release-announcement/#dockershim-removed-from-kubelet) for more information. For AKS Engine v0.75.3 or later versions, the **aks-engine-azurestack** upgrade automatically overwrites the unsupported `docker` `containerRuntime` value with `containerd`.

For AKS Engine release v0.75.3, clusters with Windows nodes on Kubernetes v1.23 can use the Windows base image with the Docker runtime. Clusters with Windows nodes on Kubernetes v1.24 can use the Windows base image with the Containerd runtime.

## AKS engine and Azure Stack version mapping

| Azure Stack Hub version                        | AKS engine version             |
|------------------------------------------------|--------------------------------|
| 1910                                           | 0.43.0, 0.43.1                 |
| 2002                                           | 0.48.0, 0.51.0                 |
| 2005                                           | 0.48.0, 0.51.0, 0.55.0, 0.55.4 |
| 2008                                           | 0.55.4, 0.60.1                 |
| 2102                                           | 0.60.1, 0.63.0, 0.67.0, 0.67.3 |
| 2108                                           | 0.63.0, 0.67.0, 0.67.3, 0.70.0, 0.71.0, 0.73.0, 0.75.3, 0.76.0 |
| 2206                                           | 0.70.0, 0.71.0, 0.73.0, 0.75.3, 0.76.0, 0.77.0 |
| 2301                                           | 0.75.3, 0.76.0, 0.77.0, 0.78.0*, 0.79.0* |
| 2306                                           | 0.78.0*, 0.79.0* |

> [!NOTE]  
> *Supported. See the [AKS Engine Version Support policy](../user/azure-stack-kubernetes-aks-engine-support.md#version-support) for more information.

### AKS engine and corresponding image mapping

You can find the supported Kubernetes versions for AKS Engine on Azure Stack Hub in the following table. Don't use the aks-engine `get-versions` command, which returns versions supported in global Azure as well as in Azure Stack Hub.


|      AKS engine     |      AKS base image     |      Kubernetes versions     |      API model samples     |
|-|-|-|-|
|     v0.43.1    |     AKS Base Ubuntu 16.04-LTS Image Distro, October 2019   (2019.10.24)    |     1.15.5, 1.15.4, 1.14.8, 1.14.7    |  |
|     v0.48.0    |     AKS Base Ubuntu 16.04-LTS Image Distro, March 2020   (2020.03.19)    |     1.15.10, 1.14.7    |  |
|     v0.51.0    |     AKS Base Ubuntu 16.04-LTS Image Distro, May 2020 (2020.05.13),   AKS Base Windows Image (17763.1217.200513)    |     1.15.12, 1.16.8, 1.16.9    |     [Linux](https://github.com/Azure/aks-engine/blob/v0.51.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.51.0/examples/azure-stack/kubernetes-windows.json)    |
|     v0.55.0    |     AKS Base Ubuntu 16.04-LTS Image Distro, August 2020   (2020.08.24), AKS Base Windows Image (17763.1397.200820)    |     1.15.12, 1.16.14, 1.17.11    |     [Linux](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-windows.json)    |
|     v0.55.4    |     AKS Base Ubuntu 16.04-LTS Image Distro, September 2020   (2020.09.14), AKS Base Windows Image (17763.1397.200820)    |     1.15.12, 1.16.14, 1.17.11    |     [Linux](https://raw.githubusercontent.com/Azure/aks-engine/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://raw.githubusercontent.com/Azure/aks-engine/v0.55.0/examples/azure-stack/kubernetes-windows.json)    |
|     V0.60.1    |     AKS Base Ubuntu 16.04-LTS Image Distro, January 2021 (2021.01.28),   <br>AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q1 (2021.01.28), <br>AKS   Base Windows Image (17763.1697.210129)    |     1.16.14, 1.16.15, 1.17.17, 1.18.15    |     [Linux](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-windows.json)    |
| [v0.63.0](https://github.com/Azure/aks-engine/releases/tag/v0.63.0) | [AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q2 (2021.05.24)](https://github.com/Azure/aks-engine/blob/v0.63.0/vhd/release-notes/aks-engine-ubuntu-1804/aks-engine-ubuntu-1804-202007_2021.05.24.txt), [AKS Base Windows Image (17763.1935.210520)](https://github.com/Azure/aks-engine/blob/v0.63.0/vhd/release-notes/aks-windows/2109-datacenter-core-smalldisk-17763.1935.210520.txt) | 1.18.18, 1.19.10, 1.20.6 | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-windows.json)) |
| [v0.67.0](https://github.com/Azure/aks-engine/releases/tag/v0.67.0) | [AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q3 (2021.09.27)](https://github.com/Azure/aks-engine/blob/v0.67.0/vhd/release-notes/aks-engine-ubuntu-1804/aks-engine-ubuntu-1804-202007_2021.09.27.txt), [AKS Base Windows Image (17763.2213.210927)](https://github.com/Azure/aks-engine/blob/v0.67.0/vhd/release-notes/aks-windows/2019-datacenter-core-smalldisk-17763.2213.210927.txt) | 1.19.15, 1.20.11 | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-windows.json)) |
| [v0.67.3](https://github.com/Azure/aks-engine/releases/tag/v0.67.3) | [AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q3 (2021.09.27)](https://github.com/Azure/aks-engine/blob/v0.67.0/vhd/release-notes/aks-engine-ubuntu-1804/aks-engine-ubuntu-1804-202007_2021.09.27.txt), [AKS Base Windows Image (17763.2213.210927)](https://github.com/Azure/aks-engine/blob/v0.67.0/vhd/release-notes/aks-windows/2019-datacenter-core-smalldisk-17763.2213.210927.txt) | 1.19.15, 1.20.11 | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-windows.json)) |
| [v0.70.0](https://github.com/Azure/aks-engine/releases/tag/v0.70.0)   | [AKS Base Ubuntu 18.04-LTS Image Distro, 2022 Q2 (2022.04.07)](https://github.com/Azure/aks-engine/blob/v0.70.0/vhd/release-notes/aks-engine-ubuntu-1804/aks-engine-ubuntu-1804-202112_2022.04.07.txt), [AKS Base Windows Image (17763.2565.220408)](https://github.com/Azure/aks-engine/blob/v0.70.0/vhd/release-notes/aks-windows/2019-datacenter-core-smalldisk-17763.2565.220408.txt)  | 1.21.10*, 1.22.7* | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/v0.71.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.71.0/examples/azure-stack/kubernetes-windows.json)) |
| [v0.71.0](https://github.com/Azure/aks-engine/releases/tag/v0.71.0)   | [AKS Base Ubuntu 18.04-LTS Image Distro, 2022 Q3 (2022.08.12)](https://github.com/Azure/aks-engine/blob/v0.71.0/vhd/release-notes/aks-engine-ubuntu-1804/aks-engine-ubuntu-1804-202112_2022.08.12.txt), [AKS Base Windows Image (17763.3232.220805)](https://github.com/Azure/aks-engine/blob/v0.71.0/vhd/release-notes/aks-windows/2019-datacenter-core-smalldisk-17763.3232.220805.txt)  | 1.22.7*, 1.23.6* | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/v0.73.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/v0.73.0/examples/azure-stack/kubernetes-windows.json)) |
| [v0.73.0](https://github.com/Azure/aks-engine/releases/tag/v0.73.0)   | [AKS Base Ubuntu 18.04-LTS Image Distro, 2022 Q4 (2022.11.02)](https://github.com/Azure/aks-engine/blob/v0.73.0/vhd/release-notes/aks-engine-ubuntu-1804/aks-engine-ubuntu-1804-202112_2022.11.02.txt), [AKS Base Windows Image (17763.3532.221102)](https://github.com/Azure/aks-engine/blob/v0.73.0/vhd/release-notes/aks-windows/2019-datacenter-core-smalldisk-17763.3532.221102.txt)  | 1.22.15*, 1.23.13* | API Model Samples ([Linux](https://github.com/Azure/aks-engine-azurestack/blob/v0.75.3/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine-azurestack/blob/v0.75.3/examples/azure-stack/kubernetes-windows.json)) |
| [v0.75.3](https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.75.3)   | [AKS Base Ubuntu 20.04-LTS Image Distro (2023.032.2)](https://github.com/Azure/aks-engine-azurestack/blob/v0.75.3/vhd/release-notes/aks-engine-ubuntu-2004/aks-engine-azurestack-ubuntu-2004_2023.032.2.txt), [AKS Base Windows Server 2019 Image Docker (17763.3887.20230332)](https://github.com/Azure/aks-engine-azurestack/blob/v0.75.3/vhd/release-notes/aks-windows/2019-datacenter-core-azurestack-smalldisk-17763.3887.20230332.txt), [AKS Base Windows Server 2019 Image Containerd (17763.3887.20230332)](https://github.com/Azure/aks-engine-azurestack/blob/v0.75.3/vhd/release-notes/aks-windows-2019-containerd/2019-datacenter-core-azurestack-ctrd-17763.3887.20230332.txt) | 1.23.15*, 1.24.9** | API Model Samples ([Linux](https://github.com/Azure/aks-engine-azurestack/blob/v0.76.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine-azurestack/blob/v0.76.0/examples/azure-stack/kubernetes-windows.json)) |
| [v0.76.0](https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.76.0)   | [AKS Base Ubuntu 20.04-LTS Image Distro (2023.116.3)](https://github.com/Azure/aks-engine-azurestack/blob/v0.76.0/vhd/release-notes/aks-engine-ubuntu-2004/aks-engine-azurestack-ubuntu-2004_2023.116.3.txt), [AKS Base Windows Server 2019 Image Containerd (17763.4252.20231163)](https://github.com/Azure/aks-engine-azurestack/blob/v0.76.0/vhd/release-notes/aks-windows-2019-containerd/2019-datacenter-core-azurestack-ctrd-17763.4252.20231163.txt) | 1.24.11**, 1.25.7** | API Model Samples ([Linux](https://github.com/Azure/aks-engine-azurestack/blob/v0.77.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine-azurestack/blob/v0.77.0/examples/azure-stack/kubernetes-windows.json)) |
| [v0.77.0](https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.77.0) | [AKS Base Ubuntu 20.04-LTS Image Distro (2023.206.1)](https://github.com/Azure/aks-engine-azurestack/blob/v0.77.0/vhd/release-notes/aks-engine-ubuntu-2004/aks-engine-azurestack-ubuntu-2004_2023.206.1.txt), [AKS Base Windows Server 2019 Image Containerd (17763.4645.20232061)](https://github.com/Azure/aks-engine-azurestack/blob/v0.77.0/vhd/release-notes/aks-windows-2019-containerd/2019-datacenter-core-azurestack-ctrd-17763.4645.20232061.txt) | 1.25.7**, 1.26.6** | API Model Samples ([Linux](https://github.com/Azure/aks-engine-azurestack/blob/e726bc30ece616a5282c1d027048e60d0696f7ad/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine-azurestack/blob/e726bc30ece616a5282c1d027048e60d0696f7ad/examples/azure-stack/kubernetes-windows.json)) |
|  [v0.78.0](https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.78.0)   | [AKS Base Ubuntu 20.04-LTS Image Distro (2023.242.3)](https://github.com/Azure/aks-engine-azurestack/blob/v0.78.0/vhd/release-notes/aks-engine-ubuntu-2004/aks-engine-azurestack-ubuntu-2004_2023.242.3.txt), [AKS Base Windows Server 2019 Image Containerd (17763.4737.20232423)](https://github.com/Azure/aks-engine-azurestack/blob/v0.78.0/vhd/release-notes/aks-windows-2019-containerd/2019-datacenter-core-azurestack-ctrd-17763.4737.20232423.txt) | 1.25.13**, 1.26.8** | API Model Samples ([Linux](https://github.com/Azure/aks-engine-azurestack/blob/3d5c7916e9995045a0868945d1f732aaa4c5b5bc/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine-azurestack/blob/3d5c7916e9995045a0868945d1f732aaa4c5b5bc/examples/azure-stack/kubernetes-windows.json)) |
| [v0.79.0](https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.79.0)   | [AKS Base Ubuntu 20.04-LTS Image Distro (2023.296.1)](https://github.com/Azure/aks-engine-azurestack/blob/master/vhd/release-notes/aks-engine-ubuntu-2004/aks-engine-azurestack-ubuntu-2004_2023.296.1.txt), [AKS Base Windows Server 2019 Image Containerd (17763.4974.20232961)](https://github.com/Azure/aks-engine-azurestack/blob/master/vhd/release-notes/aks-windows-2019-containerd/2019-datacenter-core-azurestack-ctrd-17763.4974.20232961.txt) | 1.26.9**, 1.27.6** | API Model Samples ([Linux](https://github.com/Azure/aks-engine-azurestack/blob/master/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine-azurestack/blob/master/examples/azure-stack/kubernetes-windows.json)) |

> [!NOTE]  
> *Starting from Kubernetes v1.21, only the [Cloud Provider for Azure](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#cloud-provider-for-azure) is supported on Azure Stack Hub.

> [!NOTE]  
> ** Starting from Kubernetes v1.24, only the `containerd` container runtime is supported. See the section [Upgrading Kubernetes clusters created with docker container runtime](#upgrading-kubernetes-clusters-created-with-docker-container-runtime) for more information.

## Update planning

The AKS engine `upgrade` command fully automates the upgrade process of your cluster, and handles virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the release note information.

### What's new with AKSe 0.76.0

- Added support for Kubernetes v1.24.11 and v1.25.7.
- You can find other features at [the v0.76.0 GitHub page](https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.76.0).

### What's new with AKSe 0.75.3 and above

AKS Engine release v0.75.3, and all future AKS Engine releases on Azure Stack Hub, will be from the new [aks-engine-azurestack repo](https://github.com/Azure/aks-engine-azurestack). As such, all `aks-engine` commands should be replaced with `aks-engine-azurestack`. Commands to get the latest AKS Engine release on Azure Stack Hub have also changed. You can see the new commands in [Create Linux client](./azure-stack-kubernetes-aks-engine-deploy-linux.md) and [Create Windows client](./azure-stack-kubernetes-aks-engine-deploy-windows.md). Create an [issue in the new repo](https://github.com/Azure/aks-engine-azurestack/issues/new) if you find any issues.

AKS Engine release v0.75.3 on Azure Stack Hub offers Ubuntu 20.04 LTS as its Linux base image. Starting with this release, Ubuntu 18.04 is no longer supported. See [Upgrading Kubernetes clusters created with the Ubuntu 18.04 Distro](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#upgrading-kubernetes-clusters-created-with-the-ubuntu-18.04-distro) for more information.

Starting from Kubernetes v1.24, only the `containerd` runtime is supported. See [Upgrading Kubernetes clusters created with docker runtime](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#upgrading-kubernetes-clusters-created-with-docker-runtime) for more information. For AKS Engine release v0.75.3, clusters with Windows nodes on Kubernetes v1.23 can use [the Windows base image with Docker runtime](https://github.com/Azure/aks-engine-azurestack/blob/v0.75.3/vhd/release-notes/aks-windows/2019-datacenter-core-azurestack-smalldisk-17763.3887.20230332.txt). Clusters with Windows nodes on Kubernetes v1.24 can use [the Windows base image with Containerd runtime](https://github.com/Azure/aks-engine-azurestack/blob/v0.75.3/vhd/release-notes/aks-windows-2019-containerd/2019-datacenter-core-azurestack-ctrd-17763.3887.20230332.txt).

You can find more features on [the v0.75.3 GitHub page](https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.75.3). 

### Instructions to use AKS engine 0.70.0 and above

Microsoft upgraded the Azure Cloud Provider in version 0.70.0. The Azure Cloud Provider is a core component shared between AKS Azure and AKS engine on Azure Stack Hub.

To use AKS engine 0.70.0 and above:

- **If you're attempting to create a new Kubernetes cluster for the first time**: Use the sample API model provided for the appropriate version in the [AKS engine and corresponding image mapping](#aks-engine-and-corresponding-image-mapping) table.  

- **If you're creating a new cluster, but want to use your existing API model**: Modify your API model by following the [Cloud Provider for Azure](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#cloud-provider-for-azure) instructions. Failure to include the new setting results in a deployment error. 

- **If you're using storage volumes**: Make sure that you're using the **AzureDiskCSI** driver. Version 0.70.0 and above only support CSI drivers, not the legacy in-tree storage provider. To upgrade, follow the instructions in [upgrade while using storage volumes](https://github.com/Azure/aks-engine-azurestack/blob/master/docs/topics/azure-stack.md#cloud-provider-for-azure).

### Known issues

- Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. We recommend deploying one service at a time.
- Since the **aks-engine** tool is a shared source code repository across Azure and Azure Stack Hub, examining the many release notes and pull requests might lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond those previously listed. You can ignore them and use the version table above as the official guide for this update.
- AKS Engine v0.67.0 uses the wrong Windows image when deploying Windows clusters. Use v0.70.0 to resolve this issue.

### Reference

The following list is the complete set of release notes for Azure and Azure Stack Hub combined:

- https://github.com/Azure/aks-engine/releases/tag/v0.64.0
- https://github.com/Azure/aks-engine/releases/tag/v0.65.0
- https://github.com/Azure/aks-engine/releases/tag/v0.65.1
- https://github.com/Azure/aks-engine/releases/tag/v0.66.0
- https://github.com/Azure/aks-engine/releases/tag/v0.66.1
- https://github.com/Azure/aks-engine/releases/tag/v0.67.0
- https://github.com/Azure/aks-engine/releases/tag/v0.70.0
- https://github.com/Azure/aks-engine/releases/tag/v0.71.0
- https://github.com/Azure/aks-engine/releases/tag/v0.73.0
- https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.75.3
- https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.76.0
- https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.77.0
- - https://github.com/Azure/aks-engine-azurestack/releases/tag/v0.78.0

::: moniker-end

::: moniker range="<=azs-2108 >azs-2008"
*Applies to version v0.67.0 of AKS engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. This article isn't intended to document the release information for AKS engine for global Azure.

## Update planning

The AKS engine `upgrade` command fully automates the upgrade process of your cluster. It handles virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the release note information.

### Upgrade considerations

- Are you using the correct marketplace items, AKS Base Ubuntu 16.04-LTS or 18.04 Image Distro or AKS Base Windows Server for your version of AKS engine? You can find the versions in the section "Download new images and AKS engine".
- Are you using the correct cluster specification (**apimodel.json**) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the deploy command parameters [Deploy a Kubernetes cluster](./azure-stack-kubernetes-aks-engine-deploy-cluster.md#deploy-a-kubernetes-cluster).
- Are you using a reliable machine to run AKS engine and from which you're performing upgrade operations?
- If you're updating an operational cluster with active workloads, you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there's a need to redirect users to it. A backup cluster is highly recommended.
- If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.
- Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a few more VMs to be created during the process.
- No system updates or scheduled tasks are planned.
- Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You must use the `aks-engine upgrade` command as described in [Upgrade a Kubernetes cluster on Azure Stack Hub](./azure-stack-kubernetes-aks-engine-upgrade.md).

### Upgrade interruptions

Sometimes unexpected factors interrupt the upgrade of the cluster. An interruption can occur when AKS engine reports an error or something happens to the AKS engine execution process. Examine the cause of the interruption, address it, and re-submit the same `upgrade` command to continue the upgrade process. The `upgrade` command is idempotent and should resume the upgrade of the cluster once you resubmit the command. Normally, interruptions increase the time to complete the update, but shouldn't affect its completion.

### Estimated upgrade time

 The estimated upgrade time is 12 to 15 minutes per VM in the cluster. For example, a 20-node cluster can take about 5 hours to upgrade.

## Download new image and AKS engine

Download the new versions of the AKS base Ubuntu image and AKS engine.

As explained in the documentation for AKS engine for Azure Stack Hub, deploying a Kubernetes cluster requires:

- The **aks-engine** binary (required).
- AKS Base Ubuntu 16.04-LTS Image Distro (deprecated - no longer use, change in API model to use 18.04 instead).
- AKS Base Ubuntu 18.04-LTS Image Distro (required for Linux agents).
- AKS Base Windows Server Image Distro (required for Windows agents).

New versions of these images are available with this update:

- Check the [AKS engine and Azure Stack version mapping](#aks-engine-and-azure-stack-version-mapping) table for the required AKS base images.

  Follow the instructions in [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md).

- The Kubernetes cluster administrator (normally a tenant user of Azure Stack Hub) must download the new **aks-engine**. See the instructions in [Install the AKS engine on Linux in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-linux.md) (or equivalent Windows article). You can follow the same process you used to install the cluster for the first time. The update overwrites the previous binary. For example, if you used the **get-akse.sh** script, follow the same steps outlined in [Install in a connected environment](./azure-stack-kubernetes-aks-engine-deploy-linux.md#install-in-a-connected-environment). The same process applies if you're installing on a Windows system: [Install the AKS engine on Windows in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-windows.md).

## Upgrading Kubernetes clusters created with the Ubuntu 16.04 distro

Starting with AKS Engine v0.67.0, the Ubuntu 16.04 distro is no longer a supported option, as the OS has reached its end-of-life. In order to upgrade a cluster, make sure to set the OS distro to `aks-ubuntu-18.04` in your input API model, the one generated by `aks-engine deploy` and passed as input to `aks-engine upgrade`:

```json  
"masterProfile": {
    "distro": "aks-ubuntu-18.04"
},

"agentPoolProfiles": [{
    "distro": "aks-ubuntu-18.04"
}]
```

## AKS engine and Azure Stack version mapping

| Azure Stack Hub version                        | AKS engine version             |
|------------------------------------------------|--------------------------------|
| 1910                                           | 0.43.0, 0.43.1                 |
| 2002                                           | 0.48.0, 0.51.0                 |
| 2005                                           | 0.48.0, 0.51.0, 0.55.0, 0.55.4 |
| 2008                                           | 0.55.4, 0.60.1                 |
| 2102                                           | 0.60.1, 0.63.0, 0.67.0         |
| 2108                                           | 0.63.0, 0.67.0                 |

## Kubernetes version upgrade path in AKS engine v0.67.0

You can find the current version and upgrade version for Azure Stack Hub in the following table. This table applies to the AKS engine cluster in Azure Stack Hub. Don't use the aks-engine `get-versions` command, which returns versions supported in global Azure as well as in Azure Stack Hub.

| Current version                                       | Upgrade available     |
|-------------------------------------------------------|-----------------------|
| 1.15.12                                               | 1.16.14, 1.16.15      |
| 1.16.14                                               | 1.16.15, 1.17.17      |
| 1.17.11, 1.17.17                                      | 1.18.18               |
| 1.18.15, 1.18.18                                      | 1.19.10               |
| 1.19.10                                               | 1.19.15, 1.20.11      |
| 1.20.6                                                | 1.20.11               |

In the API model JSON file, specify the release and version values under the `orchestratorProfile` section. For example, if you're planning to deploy Kubernetes 1.17.17, the following two values must be set (see the example [kubernetes-azurestack.json](https://aka.ms/aksengine-json-example-raw)):

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
|     v0.55.4    |     AKS Base Ubuntu 16.04-LTS Image Distro, September 2020   (2020.09.14), AKS Base Windows Image (17763.1397.200820)    |     1.15.12, 1.16.14, 1.17.11    |     [Linux](https://raw.githubusercontent.com/Azure/aks-engine/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://raw.githubusercontent.com/Azure/aks-engine/v0.55.0/examples/azure-stack/kubernetes-windows.json)    |
|     V0.60.1    |     AKS Base Ubuntu 16.04-LTS Image Distro, January 2021 (2021.01.28),   <br>AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q1 (2021.01.28), <br>AKS   Base Windows Image (17763.1697.210129)    |     1.16.14, 1.16.15, 1.17.17, 1.18.15    |     [Linux](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-windows.json)    |
| [v0.63.0](https://github.com/Azure/aks-engine/releases/tag/v0.63.0) | [AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q2 (2021.05.24)](https://github.com/Azure/aks-engine/blob/v0.63.0/vhd/release-notes/aks-engine-ubuntu-1804/aks-engine-ubuntu-1804-202007_2021.05.24.txt), [AKS Base Windows Image (17763.1935.210520)](https://github.com/Azure/aks-engine/blob/v0.63.0/vhd/release-notes/aks-windows/2109-datacenter-core-smalldisk-17763.1935.210520.txt) | 1.18.18, 1.19.10, 1.20.6 | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-windows.json)) |
| [v0.67.0](https://github.com/Azure/aks-engine/releases/tag/v0.67.0) | [AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q3 (2021.09.27)](https://github.com/Azure/aks-engine/blob/v0.67.0/vhd/release-notes/aks-engine-ubuntu-1804/aks-engine-ubuntu-1804-202007_2021.09.27.txt), [AKS Base Windows Image (17763.2213.210927)](https://github.com/Azure/aks-engine/blob/v0.67.0/vhd/release-notes/aks-windows/2019-datacenter-core-smalldisk-17763.2213.210927.txt) | 1.19.15, 1.20.11 | API Model Samples ([Linux](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://github.com/Azure/aks-engine/blob/master/examples/azure-stack/kubernetes-windows.json)) |

## What's new

If you're interested in participating in a private preview, you can [request preview access](https://forms.office.com/r/yqxXyiDcGG).

New features include:
- Support for Kubernetes 1.19.15 and 1.20.11

## Known issues

- Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. We recommend deploying one service at a time.
- Since the **aks-engine** tool is a shared source code repository across Azure and Azure Stack Hub, examining the many release notes and pull requests might lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond those previously listed. You can ignore them and use the version table above as the official guide for this update.

## Reference

The following list is the complete set of release notes for Azure and Azure Stack Hub combined:

- https://github.com/Azure/aks-engine/releases/tag/v0.64.0
- https://github.com/Azure/aks-engine/releases/tag/v0.65.0
- https://github.com/Azure/aks-engine/releases/tag/v0.65.1
- https://github.com/Azure/aks-engine/releases/tag/v0.66.0
- https://github.com/Azure/aks-engine/releases/tag/v0.66.1
- https://github.com/Azure/aks-engine/releases/tag/v0.67.0

::: moniker-end

::: moniker range=">=azs-2005 <=azs-2008"
*Applies to version v0.60.1 of AKS engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. This article isn't intended to document the release information for AKS engine for global Azure.

## Update planning

The AKS engine `upgrade` command fully automates the upgrade process of your cluster, and handles virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the release note information.

### Upgrade considerations

- Are you using the correct marketplace items, AKS Base Ubuntu 16.04-LTS or 18.04 Image Distro or AKS Base Windows Server for your version of AKS engine? You can find the versions in the section "Download new images and AKS engine".
- Are you using the correct cluster specification (**apimodel.json**) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the deploy command parameters [Deploy a Kubernetes cluster](./azure-stack-kubernetes-aks-engine-deploy-cluster.md#deploy-a-kubernetes-cluster).
- Are you using a reliable machine to run AKS engine and from which you're performing upgrade operations?
- If you're updating an operational cluster with active workloads, you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there's a need to redirect users to it. A backup cluster is highly recommended.
- If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.
- Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a few more VMs to be created during the process.
- No system updates or scheduled tasks are planned.
- Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You must use the `aks-engine upgrade` command as described in [Upgrade a Kubernetes cluster on Azure Stack Hub](./azure-stack-kubernetes-aks-engine-upgrade.md).

### Upgrade interruptions

Sometimes unexpected factors interrupt the upgrade of the cluster. An interruption can occur when AKS engine reports an error or something happens to the AKS engine execution process. Examine the cause of the interruption, address it, and re-submit the same `upgrade` command to continue the upgrade process. The `upgrade` command is idempotent and should resume the upgrade of the cluster once you resubmit the command. Normally, interruptions increase the time to complete the update, but shouldn't affect its completion.

### Estimated upgrade time

The estimated upgrade time is 12 to 15 minutes per VM in the cluster. For example, a 20-node cluster may take about 5 hours to upgrade.

## Download new image and AKS engine

Download the new versions of the AKS base Ubuntu image and AKS engine.

As explained in the documentation for AKS engine on Azure Stack Hub, deploying a Kubernetes cluster requires:

- The **aks-engine** binary (required).
- AKS Base Ubuntu 16.04-LTS Image Distro (deprecated - no longer use, change in API model to use 18.04 instead).
- AKS Base Ubuntu 18.04-LTS Image Distro (required for Linux agents).
- AKS Base Windows Server Image Distro (required for Windows agents).

New versions of these are available with this update:

- The Azure Stack Hub operator must download the new AKS Base images into the stamp marketplace:
  - AKS Base Ubuntu 16.04-LTS Image Distro, January 2021 (2021.01.28)
  - AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q1 (2021.01.28),
  - AKS Base Windows Image (17763.1697.210129)
    
    Follow the instructions in [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md).

- The Kubernetes cluster administrator (normally a tenant user of Azure Stack Hub) must download the new **aks-engine**. See the instructions in [Install the AKS engine on Linux in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-linux.md) (or equivalent Windows article). You can follow the same process you used to install the cluster for the first time. The update overwrites the previous binary. For example, if you used the **get-akse.sh** script, follow the same steps outlined in [Install in a connected environment](./azure-stack-kubernetes-aks-engine-deploy-linux.md#install-in-a-connected-environment). The same process applies if you're installing on a Windows system: [Install the AKS engine on Windows in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-windows.md).

## AKS engine and Azure Stack version mapping

| Azure Stack Hub version                    | AKS engine version         |
|------------------------------------------------|--------------------------------|
| 1910                                           | 0.43.0, 0.43.1                 |
| 2002                                           | 0.48.0, 0.51.0                 |
| 2005                                           | 0.48.0, 0.51.0, 0.55.0, 0.55.4 |
| 2008                                           | 0.55.4, 0.60.1                 |

## Kubernetes version upgrade path in AKS engine v0.60.1

You can find the current version and upgrade version for Azure Stack Hub in the following table. This table applies to the AKS engine cluster in Azure Stack Hub. Don't use the aks-engine `get-versions` command, which returns versions supported in global Azure as well as in Azure Stack Hub.

| Current version                                       | Upgrade available |
|-----------------------------------------------------------|-----------------------|
| 1.15.12                                                   | 1.16.14, 1.16.15      |
| 1.16.14                                                   | 1.16.15, 1.17.17      |
| 1.17.11                                                   | 1.17.17, 1.18.15      |
| 1.17.17                                                   | 1.18.15               |

In the API model JSON file, specify the release and version values under the `orchestratorProfile` section. For example, if you're planning to deploy Kubernetes 1.17.17, the following two values must be set (see the example [kubernetes-azurestack.json](https://aka.ms/aksengine-json-example-raw)):

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
|     v0.55.4    |     AKS Base Ubuntu 16.04-LTS Image Distro, September 2020   (2020.09.14), AKS Base Windows Image (17763.1397.200820)    |     1.15.12, 1.16.14, 1.17.11    |     [Linux](https://raw.githubusercontent.com/Azure/aks-engine/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://raw.githubusercontent.com/Azure/aks-engine/v0.55.0/examples/azure-stack/kubernetes-windows.json)    |
|     V0.60.1    |     AKS Base Ubuntu 16.04-LTS Image Distro, January 2021 (2021.01.28),   <br>AKS Base Ubuntu 18.04-LTS Image Distro, 2021 Q1 (2021.01.28), <br>AKS   Base Windows Image (17763.1697.210129)    |     1.16.14, 1.16.15, 1.17.17, 1.18.15    |     [Linux](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-azurestack.json), [Windows](https://raw.githubusercontent.com/Azure/aks-engine/patch-release-v0.60.1/examples/azure-stack/kubernetes-windows.json)    |

## What's new

If you're interested in participating in a private preview, you can [request preview access](https://forms.office.com/r/yqxXyiDcGG).

New features include:

- General Availability of Ubuntu 18.04.
- Certificate Rotation Public Preview [\#4214](https://github.com/Azure/aks-engine/pull/4214).
- T4 Nvidia GPU Private Preview [\#4259](https://github.com/Azure/aks-engine/pull/4259).
- Azure Active Directory integration private preview.
- CSI Driver for Azure Blobs Private Preview [\#712](https://github.com/kubernetes-sigs/azuredisk-csi-driver/pull/712).
- CSI Driver Azure Disks Public Preview [\#712](https://github.com/kubernetes-sigs/azuredisk-csi-driver/pull/712).
- CSI Driver NFS Public Preview [\#712](https://github.com/kubernetes-sigs/azuredisk-csi-driver/pull/712).
- Support for Kubernetes 1. 17.17 [\#4188](https://github.com/Azure/aks-engine/issues/4188) and 1.18.15 [\#4187](https://github.com/Azure/aks-engine/issues/4187).

## Known issues

- Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. We recommend deploying one service at a time.
- Since the **aks-engine** tool is a shared source code repository across Azure and Azure Stack Hub, examining the many release notes and pull requests might lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond those previously listed. You can ignore them and use the version table above as the official guide for this update.

## Reference

The following list is the complete set of release notes for Azure and Azure Stack Hub combined:

- https://github.com/Azure/aks-engine/releases/tag/v0.56.0
- https://github.com/Azure/aks-engine/releases/tag/v0.56.1
- https://github.com/Azure/aks-engine/releases/tag/v0.60.0
- https://github.com/Azure/aks-engine/releases/tag/v0.60.1

::: moniker-end

::: moniker range=">=azs-1910 <=azs-2002"
*Applies to version v0.55.4 of AKS engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. This article isn't intended to document the release information for AKS engine for global Azure.

## Update planning

The AKS engine `upgrade` command fully automates the upgrade process of your cluster, and handles virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the release note information.

### Upgrade considerations

- Are you using the correct marketplace item, AKS Base Ubuntu 16.04-LTS Image Distro for your version of AKS engine? You can find the versions in the "Download new image and AKS engine" section.
- Are you using the correct cluster specification (**apimodel.json**) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the deploy command parameters [Deploy a Kubernetes cluster](./azure-stack-kubernetes-aks-engine-deploy-cluster.md#deploy-a-kubernetes-cluster).
- Are you using a reliable machine to run the AKS engine and from which you're performing upgrade operations?
- If you're updating an operational cluster with active workloads, you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there's a need to redirect users to it. A backup cluster is highly recommended.
- If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.
- Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a few more VMs to be created during the process.
- No system updates or scheduled tasks are planned.
- Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You must use the `aks-engine upgrade` command as described in [Upgrade a Kubernetes cluster on Azure Stack Hub](./azure-stack-kubernetes-aks-engine-upgrade.md).

### Upgrade interruptions

Sometimes unexpected factors interrupt the upgrade of the cluster. An interruption can occur when AKS engine reports an error or something happens to the AKS engine execution process. Examine the cause of the interruption, address it, and re-submit the same `upgrade` command to continue the upgrade process. The `upgrade` command is idempotent and should resume the upgrade of the cluster once you resubmit the command. Normally, interruptions increase the time to complete the update, but shouldn't affect its completion.

### Estimated upgrade time

The estimated upgrade time is 12 to 15 minutes per VM in the cluster. For example, a 20-node cluster may take about 5 hours to upgrade.

## Download new image and AKS engine

Download the new versions of the AKS base Ubuntu Image and AKS engine.

As explained in the documentation for AKS engine on Azure Stack Hub, deploying a Kubernetes cluster requires two main components:

- The **aks-engine** binary (required).
- AKS Base Ubuntu 16.04-LTS Image Distro

New versions of these images are available with this update:

- The Azure Stack Hub operator must download a new AKS base Ubuntu image into the stamp marketplace:

- Name: AKS Base Ubuntu 16.04-LTS Image Distro, September 2020 (2020.09.14)
- Version: 2020.09.14

  Follow the instructions in [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md).

- The Kubernetes cluster administrator (normally a tenant user of Azure Stack Hub) must download the new **aks-engine**. See the instructions in [Install the AKS engine on Linux in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-linux.md) (or equivalent Windows article). You can follow the same process you used to install the cluster for the first time. The update overwrites the previous binary. For example, if you used the **get-akse.sh** script, follow the same steps outlined in [Install in a connected environment](./azure-stack-kubernetes-aks-engine-deploy-linux.md#install-in-a-connected-environment). The same process applies if you're installing on a Windows system: [Install the AKS engine on Windows in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-windows.md).

## AKS engine and Azure Stack version mapping

| Azure Stack Hub version | AKS engine version |
| ----------------------------- | ------------------------ |
| 1910 | 0.43.0, 0.43.1 |
| 2002 | 0.48.0, 0.51.0 |
| 2005 | 0.48.0, 0.51.0, 0.55.0, 0.55.4 |

## Kubernetes version upgrade path in AKS engine v0.55.4

You can find the current version and upgrade version for Azure Stack Hub in the following table. This table applies to the AKS engine cluster in Azure Stack Hub. Don't use the aks-engine `get-versions` command, which returns versions supported in global Azure as well as in Azure Stack Hub.

| Current version | Upgrade available |
| ------------------------- | ----------------------- |
| 1.15.10 | 1.15.12 |
| 1.15.12, 1.16.8, 1.16.9 | 1.16.14 |
| 1.16.8, 1.16.9, 1.16.14 | 1.17.11 |

In the API model JSON file, specify the release and version values under the `orchestratorProfile` section. For example, if you're planning to deploy Kubernetes 1.17.17, the following two values must be set (see the example [kubernetes-azurestack.json](https://aka.ms/aksengine-json-example-raw)):

```json  
    -   "orchestratorRelease": "1.16",
    -   "orchestratorVersion": "1.16.14"
```

## AKS engine and corresponding image mapping

| Kubernetes versions | Notes |
|---|---|
| 1.15.5, 1.15.4, 1.14.8, 1.14.7 |  |
| 1.15.10, 1.14.7 |  |
| 1.15.12, 1.16.8, 1.16.9 | API model samples ([Linux](https://github.com/Azure/aks-engine/blob/v0.51.0/examples/azure-stack/kubernetes-azurestack.json), [Windows)](https://github.com/Azure/aks-engine/blob/v0.51.0/examples/azure-stack/kubernetes-windows.json) |
| 1.15.12, 1.16.14, 1.17.11 | API model samples ([Linux](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows)](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-windows.json) |
| 1.15.12, 1.16.14, 1.17.11 | API model samples ([Linux](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-azurestack.json), [Windows)](https://github.com/Azure/aks-engine/blob/v0.55.0/examples/azure-stack/kubernetes-windows.json) |

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

- Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. We recommend deploying one service at a time.
- When you run aks-engine `get-versions`, the output produces information applicable to Azure and Azure Stack Hub; however, there's no explicit way to discern what corresponds to Azure Stack Hub. Don't use this command to determine what versions are available to upgrade. Use the upgrade reference table described in the previous section.
- Since the **aks-engine** tool is a shared source code repository across Azure and Azure Stack Hub, examining the many release notes and pull requests might lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond those previously listed. You can ignore them and use the version table above as the official guide for this update.

## Reference

This is the complete set of release notes for Azure and Azure Stack Hub combined:

- https://github.com/Azure/aks-engine/releases/tag/v0.51.1
- https://github.com/Azure/aks-engine/releases/tag/v0.52.1
- https://github.com/Azure/aks-engine/releases/tag/v0.53.1
- https://github.com/Azure/aks-engine/releases/tag/v0.54.1
- https://github.com/Azure/aks-engine/releases/tag/v0.55.0
- https://github.com/Azure/aks-engine/releases/tag/v0.55.4

::: moniker-end

::: moniker range="<=azs-1908"
*Applies to version 0.48.0 or earlier of AKS engine.*

This article describes the contents of the Azure Kubernetes Service (AKS) engine on Azure Stack Hub update. The update includes improvements and fixes for the latest release of AKS engine targeted to the Azure Stack Hub platform. This article isn't intended to document the release information for AKS engine for global Azure.

## Update planning

The AKS engine `upgrade` command fully automates the upgrade process of your cluster, and handles virtual machines (VMs), networking, storage, Kubernetes, and orchestration tasks. Before applying the update, make sure to review the release note information.

### Upgrade considerations

- Are you using the correct marketplace item, AKS Base Ubuntu 16.04-LTS Image Distro for your version of AKS engine? You can find the versions in the section [Download the new AKS base Ubuntu Image and AKS engine versions](#download-new-image-and-aks-engine).
- Are you using the correct cluster specification (**apimodel.json**) and resource group for the target cluster? When you originally deployed the cluster, this file was generated in your output directory. See the deploy command parameters [Deploy a Kubernetes cluster](./azure-stack-kubernetes-aks-engine-deploy-cluster.md#deploy-a-kubernetes-cluster).
- Are you using a reliable machine to run AKS engine and from which you're performing upgrade operations?
- If you're updating an operational cluster with active workloads, you can apply the upgrade without affecting them, assuming the cluster is under normal load. However, you should have a backup cluster in case there's a need to redirect users to it. A backup cluster is highly recommended.
- If possible, run the command from a VM within the Azure Stack Hub environment to decrease the network hops and potential connectivity failures.
- Make sure that your subscription has enough quota for the entire process. The process allocates new VMs during the process. The resulting number of VMs would be the same as the original, but plan for a few more VMs to be created during the process.
- No system updates or scheduled tasks are planned.
- Set up a staged upgrade on a cluster that's configured with the same values as the production cluster and test the upgrade there before doing so in your production cluster.

### Use the upgrade command

You must use the `aks-engine upgrade` command as described in [Upgrade a Kubernetes cluster on Azure Stack Hub](./azure-stack-kubernetes-aks-engine-upgrade.md).

### Upgrade interruptions

Sometimes unexpected factors interrupt the upgrade of the cluster. An interruption can occur when AKS engine reports an error or something happens to the AKS engine execution process. Examine the cause of the interruption, address it, and re-submit the same `upgrade` command to continue the upgrade process. The `upgrade` command is idempotent and should resume the upgrade of the cluster once you resubmit the command. Normally, interruptions increase the time to complete the update, but shouldn't affect its completion.

### Estimated upgrade time

The estimated upgrade time is 12 to 15 minutes per VM in the cluster. For example, a 20-node cluster may take about 5 hours to upgrade.

## Download new image and AKS engine

Download the new versions of the AKS base Ubuntu Image and AKS engine.

As explained in the documentation for AKS engine on Azure Stack Hub, deploying a Kubernetes cluster requires two main components:

-  The **aks-engine** binary (required).
- AKS Base Ubuntu 16.04-LTS Image Distro.

New versions of these are available with this update:

- The Azure Stack Hub operator must download the new AKS Base images into the stamp marketplace:
  - Name: `AKS Base Ubuntu 16.04-LTS Image Distro, March 2020`
  - Version: `2020.03.19`

    Follow the instructions in [Add the Azure Kubernetes Services (AKS) engine prerequisites to the Azure Stack Hub Marketplace](../operator/azure-stack-aks-engine.md).

- The Kubernetes cluster administrator (normally a tenant user of Azure Stack Hub) must download the new **aks-engine**. See the instructions in [Install the AKS engine on Linux in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-linux.md) (or equivalent Windows article). You can follow the same process you used to install the cluster for the first time. The update overwrites the previous binary. For example, if you used the **get-akse.sh** script, follow the same steps outlined in [Install in a connected environment](./azure-stack-kubernetes-aks-engine-deploy-linux.md#install-in-a-connected-environment). The same process applies if you're installing on a Windows system: [Install the AKS engine on Windows in Azure Stack Hub](./azure-stack-kubernetes-aks-engine-deploy-windows.md).

## Kubernetes version upgrade path

You can find the current version and upgrade version for Azure Stack Hub in the following table. This table applies to the AKS engine cluster in Azure Stack Hub. Don't use the aks-engine `get-versions` command, which returns versions supported in global Azure as well as in Azure Stack Hub.

| **Current version** | **Upgrade available** |
| --------------------| ----------------------|
| 1.14.7 | 1.15.10 |
| 1.14.8 | 1.15.10 |
| 1.15.4 | 1.15.10 |
| 1.15.5 | 1.15.10 |

## What's new 

- Support for Kubernetes version 1.15.10 ([\#2834](https://github.com/Azure/aks-engine/issues/2834)). When you deploy a new cluster, in your API model .json file (also known as the *cluster definition file*), specify both the release version number and the minor version number in the following format. For an example cluster definition file, see [kubernetes-azurestack.json](https://aka.ms/aksengine-json-example-raw).

    - `"orchestratorRelease": "1.15`,

    - `"orchestratorVersion": "1.15.10"`

    > [!NOTE]  
    > If the Kubernetes version is not explicitly provided in the API model .json file, version 1.15 will be used ([\#2932](https://github.com/Azure/aks-engine/issues/2932)) and the orchestratorVersion will default to 1.15.11, which will result in an error during deployment of the cluster.

-   With aks-engine v0.43.1, the default frequency settings for the cloud provider to perform its control loop and other tasks don't work well with Azure Stack Hub Resource Manager threshold limits for incoming requests. This update changes defaults for Azure Stack Hub to reduce the retry load to Azure Stack Hub Resource Manager ([\#2861](https://github.com/Azure/aks-engine/issues/2861)).

-   New verification step in aks-engine will result in either execution stopping or displaying warnings if API model .json file contains properties not supported by Azure Stack Hub ([\#2717](https://github.com/Azure/aks-engine/issues/2717)).

-   With a new verification check-in, the aks-engine will validate availability of the version of the AKS base image needed for the version of aks-engine executing ([\#2342](https://github.com/Azure/aks-engine/issues/2342)). This will occur after parsing the API model .json file and before calling the Azure Stack Hub Resource Manager.

-   New aks-engine option "--control-plane-only" in the `upgrade` command allows the user to upgrade operations to target only the master Virtual Machines ([\#2635](https://github.com/Azure/aks-engine/issues/2635)).

-   Updates to Linux Kernel version 4.15.0-1071-azure for Ubuntu 16.04-LTS. See "[Package: linux-image-4.15.0-1071-azure (4.15.0-1071.76) \[security\]](https://packages.ubuntu.com/xenial/linux-image-4.15.0-1071-azure)" for details.

-   New hyperkube updates to support Kubernetes versions 1.14.8 and 1.15.10.

-   Update kubectl to match the version of Kubernetes for the cluster. This component is available in the Kubernetes cluster control plane nodes, you can run it by SSH into a master.

-   Updates for the Azure Container Monitor add-in with latest [February 2020 release](https://github.com/microsoft/Docker-Provider/blob/ci_feature_prod/README.md) ([\#2850](https://github.com/Azure/aks-engine/issues/2850)).

-   Upgrade of `coredns` to version v1.6.6 ([\#2555](https://github.com/Azure/aks-engine/issues/2555)).

-   Upgrade `etcd` to version 3.3.18 ([\#2462](https://github.com/Azure/aks-engine/issues/2462)).

-   Upgrade `moby` to version 3.0.11 ([\#2887](https://github.com/Azure/aks-engine/issues/2887)).

-   With this release AKS Engine cuts dependency from `k8s.gcr.io` to now use the official `Kubernetes MCR registry @ mcr.microsoft.com` when building its images ([\#2722](https://github.com/Azure/aks-engine/issues/2722)).

## Known issues

- Deploying multiple Kubernetes services in parallel inside a single cluster may lead to an error in the basic load balancer configuration. We recommend deploying one service at a time.
- Running aks-engine `get-versions` produces information applicable to Azure and Azure Stack Hub; however, there's no explicit way to discern what corresponds to Azure Stack Hub. Don't use this command to determine what versions are available to upgrade. Use the upgrade reference table described in the previous section.
- Since the **aks-engine** tool is a shared source code repository across Azure and Azure Stack Hub, examining the many release notes and pull requests might lead you to believe that the tool supports other versions of Kubernetes and OS platform beyond those previously listed. You can ignore them and use the version table above as the official guide for this update.

## Reference

The following is a list of some of the bugs fixed and the complete set of release notes from version 0.44.0 to version 0.48.0. The release notes include both Azure and Azure Stack Hub.

### Bug fixes

- `userAssignedIdentityId` in Windows **azure.json** missing quotes ([\#2327](https://github.com/Azure/aks-engine/issues/2327))

- Add-ins `update config` is upgrade-only ([\#2282](https://github.com/Azure/aks-engine/issues/2282))

- Bumping timeout for getting management IP on Windows nodes ([\#2284](https://github.com/Azure/aks-engine/issues/2284))

- Add 1.0.28 Azure CNI .zip file into Windows VHD ([\#2268](https://github.com/Azure/aks-engine/issues/2268))

- Correct defaults order for setting `IPAddressCount` ([\#2358](https://github.com/Azure/aks-engine/issues/2358))

- Update to use single omsagent yaml for all K8s versions to avoid any manual errors and easy maintainability ([\#2692](https://github.com/Azure/aks-engine/issues/2692))

### Release notes

This is the complete set of release notes for Azure and Azure Stack Hub combined:

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

- Read about [AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-overview.md)
