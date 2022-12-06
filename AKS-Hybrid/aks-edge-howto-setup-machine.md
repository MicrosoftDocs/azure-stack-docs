---
title: Steps to prepare your machine for AKS Edge Essentials
description: Learn how to prepare your machines for AKS clusters. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Prepare your machines for AKS Edge Essentials

In this article, you'll learn how to set up an Azure Kubernetes Service (AKS) Edge node machine.

## Prerequisites

- Hardware requirements:

  | Specs | Requirement |
  | ---------- | --------- |
  | Memory | 4 GB at least 2 GB free (cluster-only), 8 GB (Arc and GitOps) |
  | CPU | Two logical processors, clock speed at least 1.8 GHz |
  | Disk space | At least 14 GB free |
  | Host OS | Windows 10/11 IoT Enterprise/Enterprise/Pro and Windows Server 2019, 2022 |

- OS requirements: Install Windows 10/11 IoT Enterprise/Enterprise/Pro on your machine and activate Windows. We recommend using the latest [client version 22H2 (OS build 19045)](/windows/release-health/release-information) or [Server 2022 (OS build 20348)](/windows/release-health/windows-server-release-info). You can [download a version of Windows 10 here](https://www.microsoft.com/software-download/windows10) or [Windows 11 here](https://www.microsoft.com/software-download/windows11). 
- Enable Hyper-V on your machine. You can check if Hyper-V is enabled using this command

    ```powershell
     Get-WindowsOptionalFeature -Online -FeatureName *hyper*
    ```

    You can enable Hyper-V on [Windows 10](/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) and  on [Windows Server](/windows-server/virtualization/hyper-v/get-started/get-started-with-hyper-v-on-windows) as described.
- If your machine has **power standby** settings turned on, you'll have to turn it off using these commands.

    ```bash
    powercfg /x -standby-timeout-ac 0
    powercfg /x -standby-timeout-dc 0
    powercfg /hibernate off
    ```

    Some device firmware may require that `Connected Standby` be disabled to avoid sleep cycling while operating your Kubernetes cluster. If your machine’s firmware requires this, you can disable Connected Standby by following the documentation provided by your device OEM, or use the following command to change your registry:

    ```bash
    reg add HKLM\System\CurrentControlSet\Control\Power /v PlatformAoAcOverride /t REG_DWORD /d 0
    ```

    Note: a reboot is required for this registry key change to take effect.  You can validate that all sleep states are now unavailable, as is required by Kubernetes, by running the following command  

    ```bash
    powercfg /a
    ```

## Download the installer

You can deploy an AKS Edge Essentials cluster on either a single machine or on multiple machines. In a multi-machine deployment, one of the machines is the primary machine with a Kubernetes control node, and the other machines are secondary machines that are either control nodes or worker nodes. You must install AKS on both the primary and secondary machines as follows. Once AKS is installed, when you create your Kubernetes cluster, you identify one machine as the primary and the rest as secondary machines.

1. On your machine, download the **AksEdge-k3s MSI** or **AksEdge-k8s MSI**, depending on which Kubernetes distribution you want to use. Also, if you're creating a Windows worker node, you'll need the Windows node files.

    | File | Link |
    | ---- | ---- |
    | k8s installer | [aka.ms/aks-edge/k8s-msi](https://aka.ms/aks-edge/k8s-msi)  |
    | k3s installer | [aka.ms/aks-edge/k3s-msi](https://aka.ms/aks-edge/k3s-msi) |
    | Windows node files | [aka.ms/aks-edge/windows-node-zip](https://aka.ms/aks-edge/windows-node-zip) |

1. In addition to the MSI, Microsoft provides a few samples and tools, which you can download from the [AKS Edge Utils GitHub repo](https://github.com/Azure/aks-edge-utils).  Navigate to the **Code** tab and click the **Download Zip** button to download the repository as a **.zip** file. Extract the GitHub **.zip** file to a working folder.

1. Before you install, make sure you uninstall any private preview installations and reboot your system before proceeding.

In this release, both K8s and K3s are supported. We've provided two separate MSI installers for each Kubernetes distribution. Do not install both k8s and k3s at the same time. If you want to install a different Kubernetes distribution, uninstall the existing one first and reboot.

## Set up your machine as a Linux node

1. Double-click the **AksEdge-k8s-x.xx.x.msi** or **AksEdge-k3s-x.xx.x.msi** file to install the latest version.

## Set up your machine as a Linux and Windows node

In order to configure your MSI installer to include Windows nodes, make sure you have the MSI installer with Kubernetes distribution of choice and the provided **AksEdgeWindows-v1** files in the same folder.

1. Open PowerShell as an admin, and navigate to the folder directory with the installer and **AksEdgeWindows-v1** files.

2. In the following command, replace `kXs` with the Kubernetes distribution you have installed and run:

    ```powershell
    msiexec.exe /i AksEdge-kXs-x.xx.x.msi ADDLOCAL=CoreFeature,WindowsNodeFeature
    ```

3. Now you're ready to do mixed deployment.

## Load AKS Edge modules

AKS edge modules can be loaded by running the [AksEdgePrompt](https://github.com/Azure/aks-edge-utils/blob/main/tools/AksEdgePrompt.cmd) file from the `tools` folder in the downloaded GitHub repo.

## Check the AKS Edge modules

Once installation is complete, make sure your install was successful by running the following command:

```powershell
Get-Command -Module AksEdge
```

![Screenshot of installed PowerShell modules.](media/aks-edge/aks-edge-modules-installed.png)

You can get the version of the modules using:

```powershell
(Get-Module AksEdge -ListAvailable).Version
```

See the [AKS Edge Essentials PowerShell cmdlets reference](./reference/aks-edge-ps/index.md) for a full list of supported commands.

## Next steps

- Create a [simple deployment](./aks-edge-howto-single-node-deployment.md)
- Create a [full deployment](./aks-edge-howto-multi-node-deployment.md)
