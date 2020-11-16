---
title: Azure Stack HCI release notes
description: Release notes for Azure Stack HCI, version 20H2.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/17/2020
---

# Release notes for Azure Stack HCI Public Preview

> Applies to: Azure Stack HCI, version 20H2

This article describes the contents of Azure Stack HCI Public Preview update packages.

## November 17, 2020 Preview Update (KB4586852)

This update includes improvements and fixes for the latest release of Azure Stack HCI. 

   > [!IMPORTANT]
   > If you have Azure Stack HCI clusters configured and registered using the Public Preview image, then you must repair your Azure registration after the KB4586852 update is installed in order to use the new features that the update offers. After installing the update, follow these steps for each cluster:
   >
   > 1. Make sure that all servers in the cluster have been updated to KB4586852. If they have not, then the repair will fail and indicate the node(s) that need to be updated.
   >
   > 2. Connect to one of the cluster nodes either locally or using `Enter-PSSession <server-name>`
   >
   > 3. Download the AzStackHCI v0.4.0 registration module from PowerShell Gallery. Run `Install-Module Az.StackHCI` to get the latest module.
   >
   > 4. Run the following command to repair your registration. Use the subscription ID that was used to register the cluster originally. `Get-AzureStackHCI` shows the current ARM Uri, which has the subscription information.
   >
   >   ```PowerShell
   >   Register-AzStackHCI -SubscriptionId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -RepairRegistration
   >   ```
   > 

### Improvements and fixes
This non-security update includes quality improvements. Key changes include: 

- With this update, Azure Stack HCI customers who hold valid Windows Server 2019 Datacenter edition license(s) can use them to conveniently activate virtual machines (VMs) hosted on Azure Stack HCI without having to manage product keys for each individual VM. Specifically, you can use Windows Admin Center or PowerShell to input an unused Windows Server 2019 Datacenter edition activation key directly into the Azure Stack HCI host to enable Automatic VM Activation (AVMA). VMs running Windows Server 2019 or earlier can then inherit activation from the host. The inputted key can be a Multiple Activation Key (MAK) obtained from the volume licensing center, the key printed on the Certificate of Authenticity (COA) sticker applied to an OEM server, or the key from a retail boxed copy of Windows Server 2019 Datacenter edition. In this release, Generic Volume License Keys (GVLK) are not supported.

- Azure Stack HCI now collects required diagnostic data, which is the minimum data required to keep the device secure, up to date, and performing as expected. Required diagnostic data gathers a limited set of data that’s critical for understanding the device and its configuration. This data helps to identify problems that can occur on a specific hardware or software configuration.  

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update 
The November 17, 2020 security update (KB4586852) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1379), download the file information for cumulative update 4586852.

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## November 10, 2020 Security Update (KB4586811)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This update contains miscellaneous security improvements to internal OS functionality. No additional issues were documented for this release.

For more information about the resolved security vulnerabilities, please refer to the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance).

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The November 10, 2020 security update (KB4586811) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1345), download the [file information for cumulative update 4586811](https://download.microsoft.com/download/8/f/2/8f2ce4bb-e113-4abc-b3ff-f0f4c4c71403/4586811.csv).

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## November 10, 2020 Servicing Stack Update (KB4590242)

This update includes quality improvements for the latest release of Azure Stack HCI.

### Improvements and fixes
This update makes quality improvements to the servicing stack, which is the component that installs updates. Servicing stack updates (SSU) makes sure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.

### How to get this update
The November, 2020 servicing stack update (KB4590242) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### Restart information
You don't have to restart your computer after you apply this update.

### Removal information
Servicing stack updates (SSUs) make changes to how updates are installed and cannot be uninstalled from the device.

### File information
For a list of the files that are provided in this update (OS Build 17784.1342), download the [file information for cumulative update 4590242](https://download.microsoft.com/download/b/b/4/bb4fb4f5-c0ba-4e55-bada-d72310857982/4590242.csv).

### References

For information on SSUs, see the following articles:

- [Servicing stack updates](/windows/deployment/update/servicing-stack-updates)
- [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/help/4535697)

Learn about the [terminology](https://support.microsoft.com/help/824684) that Microsoft uses to describe software updates.

## October 20, 2020 Preview Update (KB4580388)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This nonsecurity update includes quality improvements. Key changes include:

- With this update, Azure Stack HCI customers who hold valid Windows Server 2019 Datacenter edition license(s) can use them to conveniently activate virtual machines (VMs) hosted on Azure Stack HCI without having to manage product keys for each VM.

### Known issues in this update

Microsoft is aware of one issue with this update.

#### Symptom
When using Live Migration to move a VM between Windows Server and Azure Stack HCI operating systems, you may see the error: "Blocked a migration operation for virtual machine <vmname> because VM migration between differing Windows editions is not supported (virtual machine ID)."

Alternatively, this may also cause a Cluster Aware Updating (CAU) operation to fail if any of the VMs are expected to perform Live Migration during CAU.

#### Workaround

Use Quick Migration instead of Live Migration. If using CAU, change the default behavior temporarily so that CAU uses Quick Migration.

Example:

```powershell
Get-ClusterResourceType "Virtual Machine" | Set-ClusterParameter MoveTypeThreshold 3001
```

It's recommended that you revert back to the previous `MoveTypeThreshold` value after CAU completes successfully.

For more information, see [Configuring How VMs Are Moved when a Node is Drained](https://techcommunity.microsoft.com/t5/failover-clustering/configuring-how-vms-are-moved-when-a-node-is-drained/ba-p/371848).

### How to get this update
The October 20, 2020 security update (KB4580388) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1321), download the [file information for cumulative update 4580388](https://download.microsoft.com/download/2/f/b/2fb766d3-c4c8-4279-8718-8efbd0b6f211/4580388.csv).

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## October 13, 2020 Security Update (KB4580363)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This update contains miscellaneous security improvements to internal OS functionality. No additional issues were documented for this release.

For more information about the resolved security vulnerabilities, please refer to the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance).

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The October 13, 2020 security update (KB4580363) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1288), download the [file information for cumulative update 4580363](https://download.microsoft.com/download/f/7/8/f78801f0-e7e5-4a3d-a971-f642ccd24ee4/4580363.csv).

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## October 13, 2020 Servicing Stack Update (KB4583287)

This update includes quality improvements for the latest release of Azure Stack HCI.

### Improvements and fixes
This update makes quality improvements to the servicing stack, which is the component that installs updates. Servicing stack updates (SSU) makes sure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.

### How to get this update
The October 13, 2020 servicing stack update (KB4583287) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### Restart information
You don't have to restart your computer after you apply this update.

### Removal information
Servicing stack updates (SSUs) make changes to how updates are installed and cannot be uninstalled from the device.

### File information
For a list of the files that are provided in this update (OS Build 17784.1287), download the [file information for cumulative update 4583287](https://download.microsoft.com/download/b/8/5/b85160fb-85d9-49f9-b9d5-7dbc0158a944/4583287.csv).

### References

For information on SSUs, see the following articles:

- [Servicing stack updates](/windows/deployment/update/servicing-stack-updates)
- [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/help/4535697)

Learn about the [terminology](https://support.microsoft.com/help/824684) that Microsoft uses to describe software updates.

## September 17, 2020 Preview Update (KB4577629)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This nonsecurity update includes quality improvements. Key changes include:
- Addressed an issue where Software Load Balancer (SLB) traffic going through the Multiplexer might be redirected to a different host that can cause an application connection failure.

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The September 17, 2020 security update (KB4577629) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1259), download the [file information for cumulative update 4577629](https://download.microsoft.com/download/9/1/a/91addcbb-2b36-408c-ab88-736de42edb98/4577629.csv)

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## September 8, 2020 Security Update (KB4577470)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This update contains miscellaneous security improvements to internal OS functionality. No additional issues were documented for this release.

For more information about the resolved security vulnerabilities, please refer to the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance).

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The September 8, 2020 security update (KB4577470) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1226), download the [file information for cumulative update 4577470](https://download.microsoft.com/download/3/c/4/3c468525-5867-4cc3-8d34-dba88989adab/4577470.csv).

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.

## September 8, 2020 Servicing Stack Update (KB4577558)

This update includes quality improvements for the latest release of Azure Stack HCI.

### Improvements and fixes
This update makes quality improvements to the servicing stack, which is the component that installs updates. Servicing stack updates (SSU) makes sure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.

### How to get this update
The September 8, 2020 servicing stack update (KB4577558) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### Restart information 
You don't have to restart your computer after you apply this update.

### Removal information
Servicing stack updates (SSUs) make changes to how updates are installed and cannot be uninstalled from the device.

### File information
For a list of the files that are provided in this update (OS Build 17784.1220), download the [file information for cumulative update 4577558](https://download.microsoft.com/download/8/f/6/8f612a9b-cb4e-4832-9397-156760848592/4577558.csv).

### References

For information on SSUs, see the following articles:

- [Servicing stack updates](/windows/deployment/update/servicing-stack-updates)
- [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/help/4535697)

Learn about the [terminology](https://support.microsoft.com/help/824684) that Microsoft uses to describe software updates.

## August 11, 2020 Security Update (KB4574585)

This update includes improvements and fixes for the latest release of Azure Stack HCI.

### Improvements and fixes
This update contains miscellaneous security improvements to internal OS functionality. No additional issues were documented for this release.

For more information about the resolved security vulnerabilities, please refer to the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance).

### Known issues in this update
Microsoft is not currently aware of any issues with this update.

### How to get this update
The August 11, 2020 security update (KB4574585) for [Azure Stack HCI preview](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) is delivered via Windows Update. To install it on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](manage/update-cluster.md).

### File information
For a list of the files that are provided in this update (OS Build 17784.1162), download the [file information for cumulative update 4574585](https://download.microsoft.com/download/7/f/4/7f451def-76c5-4cc0-9929-0c5efeb27d2f/4574585.csv).

   > [!NOTE]
   > Some files erroneously have "Not applicable" in the "File version" column of the CSV file. This might lead to false positives or false negatives when using some third-party scan detection tools to validate the build.