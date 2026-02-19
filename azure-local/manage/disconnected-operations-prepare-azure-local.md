---
title: Prepare Azure Local for disconnected deployments (Preview)
description: Prepare your Azure Local environment for disconnected deployments (preview). Learn how to set up nodes, configure networking, and ensure deployment readiness.
ms.topic: how-to
author: haraldfianbakken
ms.author: hafianba
ms.date: 01/05/2026
ms.reviewer: robess
ai-usage: ai-assisted
---

# Prepare Azure Local for disconnected deployments (preview)

::: moniker range=">=azloc-2601"

This article explains how to deploy an Azure Local node for disconnected operations. Prepare your environment to ensure a successful setup of your Azure Local instance. Complete this deployment before setting up your Azure Local instance.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Prepare Azure Local machines  

Prepare your Azure Local machines for disconnected operations by completing these steps to ensure proper setup and configuration. This process includes downloading the necessary ISO, configuring networking, and setting up certificates and environment variables.

1. Download the Azure Local ISO that matches your disconnected control plane version (for example, 2601).  

1. Install the OS and configure the node networking for each Azure Local machine you plan to use to form an instance. For more information, see [Install the Azure Stack HCI operating system](../deploy/deployment-install-os.md).

1. On physical hardware, install firmware and drivers as instructed by your OEM.
1. Rename network adapters.

    Use the same adapter name on each node for the physical network. Rename adapters to meaningful names if the default names aren't clear. Skip this step if the adapter names already match.

    Here's an example:

     ```powershell
      Rename-NetAdapter -Name "Mellanox #1" -NewName "ethernet"
      Rename-NetAdapter -Name "Mellanox #2" -NewName "ethernet 2" 
      # Other examples for naming e.g."storage port 0" 
     ```

1. Set up the virtual switches according to your planned network:

   - [Network considerations for cloud deployments of Azure Local](../plan/cloud-deployment-network-considerations.md).

   - If your network plan groups all traffic (management, compute, and storage), create a virtual switch called `ConvergedSwitch(ManagementComputeStorage)` on each node.  

    Here's an example:

    ```powershell
    # Example
    $networkIntentName = 'ManagementComputeStorage'
    New-VMSwitch -Name "ConvergedSwitch($networkIntentName)" -NetAdapterName "ethernet","ethernet 2" -EnableEmbeddedTeaming $true -AllowManagementOS $true

    # Rename the VMNetworkAdapter for management. During creation, Hyper-V uses the vSwitch name for the virtual network adapter.
    Rename-VmNetworkAdapter -ManagementOS -Name "ConvergedSwitch($networkIntentName)" -NewName "vManagement($networkIntentName)"

    # Rename the NetAdapter. During creation, Hyper-V adds the string "vEthernet" to the beginning of the name.
    Rename-NetAdapter -Name "vEthernet (ConvergedSwitch($networkIntentName))" -NewName "vManagement($networkIntentName)"
    ```

   - If you use VLANs, make sure you set the network adapter VLAN.

     ```powershell
     Set-NetAdapter -Name "ethernet 1" -VlanID 10
     ```

1. [Rename each node](/powershell/module/microsoft.powershell.management/rename-computer?view=powershell-7.4&preserve-view=true) according to your environment's naming conventions. For example, azlocal-n1, azlocal-n2, and azlocal-n3.  

1. **Management cluster only:** Check that you have sufficient disk space for disconnected operations deployment.

    Make sure you have at least 600 GB of free space on the drive you plan to use for deployment. If your drive has less space, use a data disk on each node and initialize it so each node has the same available data disks for deployment.

    Here's how to initialize a disk on the nodes and format it for a D partition:

    ```powershell
    $availableDrives = Get-PhysicalDisk | Where-Object { $_.MediaType -eq "SSD" -or $_.MediaType -eq "NVMe" } | where -Property CanPool -Match "True" | Sort-Object Size -Descending
    $driveGroup = $availableDrives | Group-Object Size | select -First 1
    $biggestDataDrives = $availableDrives | select -First $($driveGroup.Count)
    $firstDataDrive= ($biggestDataDrives | Sort-Object DeviceId | select -First 1).DeviceId
    Initialize-Disk -Number $firstDataDrive
    New-partition -disknumber $firstDataDrive -usemaximumsize | format-volume -filesystem NTFS -newfilesystemlabel Data
    Get-partition -disknumber $firstDataDrive -PartitionNumber 2 | Set-Partition -NewDriveLetter D
    ```

1. On each node, copy the root certificate public key. For more information, see [PKI for disconnected operations](disconnected-operations-pki.md). Modify the paths according to the location and method you use to export your public key for creating certificates.  

    ```powershell
    $applianceConfigBasePath = "C:\AzureLocalDisconnectedOperations\"
    $applianceRootCertFile = "C:\AzureLocalDisconnectedOperations\applianceRoot.cer"
    
    New-Item -ItemType Directory $applianceConfigBasePath
    Copy-Item \\fileserver\share\azurelocalcerts\publicroot.cer $applianceRootCertFile
    ```

1. Copy to the **APPData/AzureLocal** folder and name it **azureLocalRootCert**. Use this information during the Arc appliance deployment.  

    ```powershell
    New-Item -ItemType Directory "$($env:APPDATA)\AzureLocal" -force

    Copy-Item $applianceRootCertFile "$($env:APPDATA)\AzureLocal\AzureLocalRootCert.cer"
    ```

1. On each node, import the public key into the local store:

    ```powershell
    Import-Certificate -FilePath $applianceRootCertFile -CertStoreLocation Cert:\LocalMachine\Root -Confirm:$false
    ```

    > [!NOTE]
    > If you use a different root for the management certificate, repeat the process and import the key on each node.

1. Set the environment variable to support disconnected operations.

    ```powershell
    [Environment]::SetEnvironmentVariable("DISCONNECTED_OPS_SUPPORT", $true, [System.EnvironmentVariableTarget]::Machine)
    ```

1. [Setup Azure CLI on each node](../manage/disconnected-operations-cli.md). Ensure it works on each node before you deploy an Azure Local instance. Otherwise, the deployment fails.

1. Find the first machine from the list of node names and specify it as the `seednode` you want to use in the cluster.

    ```powershell
    $seednode = @('azlocal-1', 'azlocal-2','azlocal-3')|Sort|select –first 1
    $seednode
    ```

    ::: moniker-end

::: moniker range="<=azloc-2512"

This feature is available only in Azure Local 2601

::: moniker-end
