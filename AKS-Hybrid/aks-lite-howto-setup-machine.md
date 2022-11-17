---
title: Steps to prepare your machine for AKS
description: Learn how to prepare your machines for AKS clusters. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Prepare your machines for AKS

In this article, you'll learn to set up an Azure Kubernetes Service (AKS) Edge node machine.

## Prerequisites

- Hardware requirements:

  > [!IMPORTANT]
  > The minimum set up required to run the latest version of AKS is a single machine with the following specs:

  | Specs | Requirement |
  | ---------- | --------- |
  | Memory | 4 GB at least 2 GB free (cluster-only), 8 GB (Arc and GitOps) |
  | CPU | Two logical processors, clock speed at least 1.8 GHz |
  | Disk space | At least 14 GB free |
  | Host OS | Windows 10/11 IoT Enterprise/Enterprise/Pro/Server |

- OS requirements: Install Windows 10/11 IoT Enterprise/Enterprise/Pro/Server on your machine and activate Windows. We recommend using the latest [version 21H2 (OS build 19044)](/windows/release-health/release-information). You can [download a version of Windows 10 here](https://www.microsoft.com/software-download/windows10) or [Windows 11 here](https://www.microsoft.com/software-download/windows11).

## Download the installer

You can deploy AKS for the light edge on either a single machine or on multiple machines. In a multi-machine deployment, one of the machines is the primary machine with a Kubernetes control node, and the other machines are secondary machines with the worker nodes. You must install AKS on both the primary and secondary machines as follows. Once AKS is installed, when you create your Kubernetes cluster, you identify one machine as the primary and the rest as secondary machines.

1. On your machine, navigate to the [GitHub releases page](https://github.com/Azure/AKS-IoT-preview/releases) to download the **AksIot-k3s(.msi)** or **AksIot-k8s(.msi)**, depending on which Kubernetes distribution you want to use.

   ![Screenshot showing AKS on Windows GitHub releases.](media/aks-lite/aks-lite-release-assets.png)

2. In the upper left-hand corner of the releases page, navigate to the **Code** tab and click on the green **Code** button to download the repository as a **.zip** file.
  
3. Extract the GitHub **.zip** file and move the MSI and all the other files to the extracted folder. This folder will be your working directory.

4. Before you install, make sure you remove any existing AKS-IoT clusters and uninstall any previous versions of AKS-IoT. If you have uninstalled a previous version of AKS-IoT, reboot your system before proceeding.

   ![Screenshot showing install/uninstall options.](media/aks-lite/aks-lite-uninstall.png)

  > [!NOTE]
  > In this release, both k8s and k3s are supported. We have provided two separate MSI installers for each Kubernetes distribution. Do not install both k8s and k3s at the same time. If you want to install a different Kubernetes distribution, uninstall the existing one first (i.e. if you have k3s installed, uninstall before installing k8s, and vice-versa).

## Set up your machine as a Linux node

1. Double-click the **AksIot-k8s.msi** or **AksIot-k3s.msi** file to install the latest version.

2. Once installation is complete, make sure your install was successful by running the following command:

    ```powershell
    Get-Command -Module AksEdge
    ```

    You should see the following output with version showing v0.4.222:

    ![Screenshot of installed PowerShell modules.](media/aks-lite/aks-lite-modules-installed.png)

    See the [AKS-IoT PowerShell cmdlets reference](./reference/aks-lite-ps/index.md) for a full list of supported commands.

## Set up your machine as a Linux and Windows node

In order to configure your MSI installer to include Windows nodes, make sure you have the MSI installer with Kubernetes distribution of choice and the provided **AksIotWindows-v1** files in the same folder.

1. Open PowerShell as an admin, and navigate to the folder directory with the installer and files.

2. In the following command, replace `kXs` with the Kubernetes distribution you have installed and run:

    ```powershell
    msiexec.exe /i AksIot-kXs.msi ADDLOCAL=CoreFeature,WindowsNodeFeature
    ```

3. Now you are ready to do mixed deployment.

## Next steps

- Create a [simple deployment](./aks-lite-howto-single-node-deployment.md)
- Create a [full deployment](./aks-lite-howto-multi-node-deployment.md)
