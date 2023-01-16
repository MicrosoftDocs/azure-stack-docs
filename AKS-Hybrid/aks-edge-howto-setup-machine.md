---
title: Steps to prepare your machine for AKS Edge Essentials
description: Learn how to prepare your machines for AKS clusters. 
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 12/05/2022
ms.custom: template-how-to
---

# Prepare your machines for AKS Edge Essentials

This article describes how to set up an Azure Kubernetes Service (AKS) Edge node machine.

## Prerequisites

- Hardware requirements:

  | Specs | Local cluster | Arc-connected cluster and GitOps|
  | ---------- | --------- |--------- |
  | Host OS | Windows 10/11 IoT Enterprise/Enterprise/Pro and Windows Server 2019, 2022||
  | Total physical memory | 4 GB with at least 2 GB free | 8 GB with at least 4 GB free  |
  | CPU | 2 vCPUs, clock speed at least 1.8 GHz |4 vCPUs, clock speed at least 1.8 GHz|
  | Disk space | At least 14 GB free |At least 14 GB free |

    To better understand the concept of vCPUs, [read this article](https://social.technet.microsoft.com/wiki/contents/articles/1234.hyper-v-concepts-vcpu-virtual-processor-q-a.aspx).
- OS requirements: Install Windows 10/11 IoT Enterprise/Enterprise/Pro on your machine and activate Windows. We recommend using the latest [client version 22H2 (OS build 19045)](/windows/release-health/release-information) or [Server 2022 (OS build 20348)](/windows/release-health/windows-server-release-info). You can [download a version of Windows 10 here](https://www.microsoft.com/software-download/windows10) or [Windows 11 here](https://www.microsoft.com/software-download/windows11).
- Enable Hyper-V on your machine. You can check if Hyper-V is enabled using this command:

    ```powershell
     Get-WindowsOptionalFeature -Online -FeatureName *hyper*
    ```

    You can enable Hyper-V on [Windows 10](/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v) and on [Windows Server](/windows-server/virtualization/hyper-v/get-started/get-started-with-hyper-v-on-windows) as described.
- If your machine has power standby settings turned on, you'll have to turn it off using these commands:

    ```bash
    powercfg /x -standby-timeout-ac 0
    powercfg /x -standby-timeout-dc 0
    powercfg /hibernate off
    ```

    Some device firmware may require that **Connected Standby** be disabled to avoid sleep cycling while operating your Kubernetes cluster. If your machine’s firmware requires this, you can disable connected standby by following the documentation provided by your device OEM. Or, use the following command to change your registry:

    ```bash
    reg add HKLM\System\CurrentControlSet\Control\Power /v PlatformAoAcOverride /t REG_DWORD /d 0
    ```

    A reboot is required for this registry key change to take effect. You can validate that all sleep states are now unavailable, as is required by Kubernetes, by running the following command:

    ```bash
    powercfg /a
    ```

## Download the installer

You can deploy an AKS Edge Essentials cluster on either a single machine or on multiple machines. In a multi-machine deployment, one of the machines is the primary machine with a Kubernetes control node, and the other machines are secondary machines that are either control nodes or worker nodes. You must install AKS on both the primary and secondary machines as follows. Once AKS is installed, when you create your Kubernetes cluster, you identify one machine as the primary and the rest as secondary machines.

1. On your machine, download the **AksEdge-k3s.msi** or **AksEdge-k8s.msi** file, depending on which Kubernetes distribution you want to use. Also, if you're creating a Windows worker node, you'll need the Windows node files.

    | File | Link |
    | ---- | ---- |
    | K8s installer | [aka.ms/aks-edge/k8s-msi](https://aka.ms/aks-edge/k8s-msi)  |
    | K3s installer | [aka.ms/aks-edge/k3s-msi](https://aka.ms/aks-edge/k3s-msi) |
    | Windows node files | [aka.ms/aks-edge/windows-node-zip](https://aka.ms/aks-edge/windows-node-zip) |

1. In addition to the MSI, Microsoft provides a few samples and tools which you can download from the [AKS Edge GitHub repo](https://github.com/Azure/AKS-Edge). Navigate to the **Code** tab and click the **Download Zip** button to download the repository as a **.zip** file. Extract the GitHub **.zip** file to a working folder.

1. Before you install, make sure you uninstall any private preview installations and reboot your system before proceeding.

In this release, both K8s and K3s are supported. We've provided two separate MSI installers for each Kubernetes distribution. Do not install both K8s and K3s at the same time. If you want to install a different Kubernetes distribution, uninstall the existing one first and reboot.

Before you install the MSI, you can review the [feature support](aks-edge-deployment-options.md#feature-support-matrix) to understand the different options available.  

## Set up your machine as a Linux node

1. Open PowerShell as an admin, and navigate to the folder directory with the installer files.

2. In the following command, replace `kXs-x.xx.x` with the Kubernetes distribution/version you have downloaded and run:

    ```powershell
    msiexec.exe /i AksEdge-kXs-x.xx.x.msi
    ```

    Optionally, you can specify the install directory and the vhdx directory (directory where the vhdx files for the virtual machines are stored) using `INSTALLDIR` and `VHDXDIR`. By default, these will be in `C:\Program Files\AksEdge`.

    ```powershell
    msiexec.exe /i AksEdge-kXs-x.xx.x.msi INSTALLDIR=C:\Programs\AksEdge VHDXDIR=C:\vhdx
    ```

Alternatively, you can double-click the **AksEdge-k8s-x.xx.x.msi** or **AksEdge-k3s-x.xx.x.msi** file to install the latest version.

## Set up your machine as a Linux and Windows node

In order to configure your MSI installer to include Windows nodes, make sure you have the MSI installer with Kubernetes distribution of choice and the provided **AksEdgeWindows-v1** files in the same folder.

1. Open PowerShell as an admin, and navigate to the folder directory with the installer and **AksEdgeWindows-v1** files.

2. In the following command, replace `kXs-x.xx.x` with the Kubernetes distribution/version you have downloaded and run:

    ```powershell
    msiexec.exe /i AksEdge-kXs-x.xx.x.msi ADDLOCAL=CoreFeature,WindowsNodeFeature
    ```

    (or)

    ```powershell
    msiexec.exe /i AksEdge-kXs-x.xx.x.msi ADDLOCAL=CoreFeature,WindowsNodeFeature INSTALLDIR=C:\Programs\AksEdge VHDXDIR=C:\vhdx
    ```

3. Now you're ready to do mixed deployment.

## Load AKS Edge modules

You can load AKS Edge modules by running the **AksEdgePrompt** file from the **tools** folder in the downloaded [GitHub repo](https://github.com/Azure/AKS-Edge/blob/main/tools/AksEdgePrompt.cmd). This PowerShell script checks for prerequisites such as Hyper-V, system CPU and memory resources, and the AKS Edge Essentials program, and loads the corresponding PowerShell modules. It's recommended that you use the **AksEdgePrompt** tool.

![Screenshot showing all pods running.](./media/aks-edge/aksedge-prompt.png)

Alternatively, you can access the AKSEdge PowerShell modules from an elevated PowerShell instance as shown:

```powershell
Import-Module AksEdge
```

Open another elevated PowerShell window and continue with the next step.

## Check the AKS Edge modules

Once installation is complete, make sure it was successful by running the following command:

```powershell
Get-Command -Module AKSEdge | Format-Table Name, Version
```

![Screenshot of installed PowerShell modules.](media/aks-edge/aks-edge-modules-installed.png)

See the [AKS Edge Essentials PowerShell cmdlets reference](./reference/aks-edge-ps/index.md) for a full list of supported commands.

## Next steps

- Create a [simple deployment](aks-edge-howto-single-node-deployment.md)
- Create a [full deployment](aks-edge-howto-multi-node-deployment.md)
