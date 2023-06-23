---
title: Use offline download in AKS on Azure Stack HCI
description: Learn how to use offline download in AKS on Azure Stack HCI
ms.topic: reference
ms.date: 04/11/2023
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 04/11/2023
ms.reviewer: jeguan

---
# Use offline download in AKS on Azure Stack HCI and Windows Server

If you have unreliable internet connectivity at your deployment location or you need to scan files and images for security and compliance before deploying, you can use offline downloading to install or update from a local path. There are two ways that you can use this feature: *onsite* or *offsite*. Onsite means that you download the AKS on HCI images at the same location in which you deploy. Offsite means that you download the AKS on HCI images to a different location (where you may have better internet connectivity), use a tool of your choice to transfer the images to your deployment site, and then install or update locally.

In both onsite and offsite scenarios, the latest change ensures that all the zip/cab files of different versions are extracted during the install/update process. This process takes less space than before, which required files to be extracted prior to install/upgrade and stored on the cluster storage.

## Before you begin

The following prerequisites are required:

- The latest release of the AKS-HCI PowerShell module.
- Open PowerShell as an administrator.
- Make sure you have satisfied all the [system requirements](.\system-requirements.md) prerequisites.

## Use offline download to install onsite

### Step 1: Prepare your machine(s) for deployment

Run the following command to check every physical node to see if all the requirements to install AKS on HCI are satisfied.

```powershell
Initialize-AksHciNode
```

### Step 2: Configure the deployment to use offline download and download the images

In the configuration step, use [Set-AksHciConfig](./reference/ps/set-akshciconfig.md) to enable offline downloading with the `-offlineDownload` parameter. Then, specify the local path with the `-stagingShare` parameter. This is where the images are downloaded.

```powershell
Set-AksHciConfig -offlineDownload $true -mode full -stagingShare c:\akshciimages -imageDir c:\clusterstorage\volume1\Images -workingDir c:\ClusterStorage\Volume1\ImageStore -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16" 
```

> [!NOTE]
> This command is an example. You must replace the parameter arguments with those that fit your deployment. You must also set your `vnet` settings. See step 2 [in this quickstart](kubernetes-walkthrough-powershell.md#step-2-create-a-virtual-network). This example downloads in full mode. For more download modes, see the descriptions for the `-mode` parameter in [Set-AksHciConfig](reference/ps/set-akshciconfig.md).

### Step 3: Ensure that offline download is enabled and the local path is correct

You can make sure that offline download is enabled and that the local path is correct by running the following command:

```powershell
Get-AksHciConfig | ConvertTo-Json
```

The output shows that `offlineDownload` is set to `true`, and the `stagingShare` value is the local path.

### Step 4: Log into Azure and configure the registration settings

Run the following command with your Azure subscription information:

```powershell
Set-AksHciRegistration -subscriptionId "<subscriptionId>" -resourceGroupName "<resourceGroupName>"
```

### Step 5: Start the new deployment

Run the following command to start the deployment:

```powershell
Install-AksHci
```

## Use offline download to upgrade onsite

### Step 1: Get available AKS on HCI host updates

Check if there is an available update by running the following command:

```powershell
Get-AksHciUpdates
```

### Step 2: Turn on offline download

If you do not already have offline downloading turned on, run the following command with the local path to which you want the images to be downloaded. You can check if offline downloading is set to `true` with the correct local path by running `Get-AksHciConfig | ConvertToJson` and checking the values. If it is set to `true` and the local path is correct, skip to step 3.

```powershell
Enable-AksHciOfflineDownload -stagingShare <your path>
```

### Step 3: Download the upgrade images

Run the following command to download the images. This example downloads in full mode. For more download modes, see the descriptions of the `-mode` parameter in [Get-AksHCiRelease](reference/ps/get-akshcirelease.md).

```powershell
Get-AksHciRelease -mode full
```

### Step 4: Start the AKS on HCI host update

Run the following command to start the update:

```powershell
Update-AksHci
```

## Use offline download to install offsite

With the offsite functionality, you download the images to a different location of your choice. This could be a location where you have a more reliable and secure connection.

### Step 1: Set the offsite configurations

Run the following command at your offsite location with the version of AKS on HCI that you need:

```powershell
Set-AksHciOffsiteConfig -version <String> -stagingShare <String>
```

### Step 2: Download the images

Run the following command to download the images. This example downloads in full mode. For more download modes, see the descriptions of the `-mode` parameter in [Get-AksHCiRelease](reference/ps/get-akshcirelease.md).

```powershell
Get-AksHciRelease -mode full 
```

### Step 3: Transfer the images onsite to where you will deploy

In this step, use your tool of choice to transfer the images so that they are available in a local directory onsite where AKS on HCI are deployed.

### Step 4: Configure the deployment onsite

Set your configuration, make sure to use the `-offlineDownload` flag, and set your path to where AKS on HCI looks for the images during install:

```powershell
Set-AksHciConfig -offlineDownload $true -offsiteTransferCompleted $true -stagingShare c:\akshciimages -imageDir c:\clusterstorage\volume1\Images -workingDir c:\ClusterStorage\Volume1\ImageStore -cloudConfigLocation c:\clusterstorage\volume1\Config -vnet $vnet -cloudservicecidr "172.16.10.10/16" 
```

> [!NOTE]
> This command is an example. Replace the parameter arguments to ones that fit your deployment. You must also set your `vnet` settings. See step 2 [in this quickstart](kubernetes-walkthrough-powershell.md#step-2-create-a-virtual-network).

### Step 5: Ensure that offline download is on and the local path is correct

You can make sure that offline download is enabled, and that the local path is correct by running the following command:

```powershell
Get-AksHciConfig | ConvertTo-Json
```

The output shows that `offlineDownload` is set to `true`, and the `stagingShare` value is the local path.

### Step 6: Log into Azure and configure the registration settings

Run the following command with your Azure subscription information:

```powershell
Set-AksHciRegistration -subscriptionId "<subscriptionId>" -resourceGroupName "<resourceGroupName>"
```

### Step 7: Start the new deployment

Run the following command to start the deployment:

```powershell
Install-AksHci
```

## Use offline download to upgrade offsite

With the offsite functionality, you download the images to a different location of your choice. This could be a location where you have a more reliable and secure connection.

### Step 1: Set the offsite configuration

Run the following command at your offsite location with the version of AKS on HCI that you need:

```powershell
Set-AksHciOffsiteConfig -version <String> -stagingShare <String>
```

### Step 2: Download the images

Run the following command with the upgrade version that you need to download the images. This example downloads in full mode. For more download modes, see the descriptions of the `-mode` parameter in [Get-AksHCiRelease](reference/ps/get-akshcirelease.md).

```powershell
Get-AksHciRelease -mode full 
```

### Step 3: Transfer the images onsite to where you will deploy

In this step, use your tool of choice to transfer the images so that they are available in a local directory onsite where AKS on HCI is deployed.

### Step 4: Enable offline download

If you do not already have offline downloading enabled, run the following command to enable offline downloading, and provide the correct path to where the images are located:

```powershell
Enable-AksHciOfflineDownload -stagingShare <your path> -offsiteTransferCompleted $true 
```

### Step 5: Start the update

Run the following command below to start the update:

```powershell
Update-AksHci
```

## Next steps

[Azure Kubernetes Service on Azure Stack HCI](overview.md)
