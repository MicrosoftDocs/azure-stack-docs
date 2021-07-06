---
title: Concepts - Updating Azure Kubernetes Services on Azure Stack HCI
description: Learn about updates and upgrades in Azure Kubernetes Service on Azure Stack HCI.
ms.topic: conceptual
ms.date: 03/04/2021
ms.custom: fasttrack-edit
ms.author: mikek
author: mkostersitz
---

# Update concepts for Azure Kubernetes Services on Azure Stack HCI

There are several types of updates, which can happen independently from each other and in certain supported combinations.

- Update the AKS on Azure Stack HCI core system to the latest version.
- Update an AKS on Azure Stack HCI workload cluster to a new Kubernetes version.
- Update the container hosts of AKS workload clusters to a newer version of the operating system.
- Combined update of the operating system and Kubernetes version of AKS workload clusters.

All updates are done in a rolling update flow. When a *new* node with the newer build is brought into the cluster, resources are moved from the *old* node to the *new* node, and the *old* node is decommissioned.

This article talks about updating the AKS on Azure Stack HCI core system to the latest version. For information on updating an AKS workload cluster, visit [how to update Kubernetes version of AKS clusters](./upgrade.md).

You can update to the latest version of Azure Kubernetes Service on Azure Stack HCI by running the [update-akshci](./update-akshci.md) command. The update command only works if you have installed the Oct release or later. It will not work for releases older than the October release. This update command updates the Azure Kubernetes Service host and the on-premise Microsoft operated cloud platform. This command does not update any existing AKS workload clusters. New AKS workload clusters created after updating the AKS host may differ from existing AKS workload clusters in their OS version and Kubernetes version.

We recommend updating AKS workload clusters immediately after updating the AKS host to prevent running unsupported container host OS versions or Kubernetes versions in your AKS workload clusters. If your workload clusters are on an old Kubernetes version, they will still be supported but you will not be able to scale your cluster. 

## Update the AKS on Azure Stack HCI host using PowerShell

> [!Important]
> Updating the AKS on Azure Stack HCI host is the first step in any update flow and must be initiated before running [`Update-AksHciCluster`](./update-akshcicluster.md). The command doesn't need any arguments and always updates the management cluster to the latest version.

### Example flow for updating the AKS on Azure Stack HCI host

#### Update the PowerShell modules
Make sure you always have the latest PowerShell modules installed on your Azure Stack HCI nodes by executing the following command on all physical Azure Stack HCI nodes. 

> [!Important]
> You should close all open PowerShell windows and then open a fresh session to run the update command. If you do not close all PowerShell windows, you may end up with modules that are in-use and can't be updated.

```powershell
Update-Module -Name AksHci -Force 
```

Run the following command to make sure you have the latest PowerShell module.

```powershell
Get-InstalledModule -Name AksHci
```

```output
Version    Name     Repository    Description
-------    ----     ----------    -----------
1.0.2      AksHci   PSGallery     AKS HCI Module
```

#### Get the current AKS on Azure Stack HCI version

```powershell
PS C:\> Get-AksHciVersion                    
```

```output
1.0.0.10517
```

#### Get the available AKS on Azure Stack HCI updates

```powershell
Get-AksHciUpdates
```

The output shows the available versions this AKS on Azure Stack HCI host can be updated to.

```output
Name                           Value
----                           -----
1.0.1.10624                    {Comments, SupportedKubernetesVersions, CanUpgradeTo, Version...}
1.0.0.10517                    {Comments, SupportedKubernetesVersions, CanUpgradeTo, Version}
```

#### Initiate the AKS on Azure Stack HCI update

```powershell
PS C:\> Update-AksHci
```

#### Verify the AKS on Azure Stack HCI host is updated

```powershell
PS C:\> Get-AksHciVersion
```

The output shows the updated version of the AKS on Azure Stack HCI host.

```output
1.0.1.10624 
```

## Update the AKS on Azure Stack HCI host using Windows Admin Center

The AKS on Azure Stack HCI host can also be updated through Windows Admin Center. To update the host, follow the steps below: 

1. Update your Azure Kubernetes Service extension by navigating to **Settings** > **Extensions** > **Installed Extensions** and then click **Update**. The latest available Azure Kubernetes Service extension version is 1.35.0. You do not need to do this step if you have enabled auto-update for your extensions. However, make sure that you have version 1.35.0 of the AKS extension installed before proceeding to the next step.

2. Users who have installed AKS on Azure Stack HCI using the GA release will see an error that says *Incompatible AksHci Module Version* in Windows Admin Center when they update the Windows Admin Center extension to the June release (1.35.0). 
   
   To use the June release, PowerShell version 1.0.2 is required, so users must manually run the following PowerShell command on all the nodes in their Azure Stack HCI cluster to get around this error. 

   ```powershell
   Update-Module -Name AksHci -Repository PSGallery -RequiredVersion 1.0.2 -AcceptLicense –Force 
   ```

3. You can now go back to the Windows Admin Center **Connections** page and connect to your Azure Stack HCI cluster.
4. Select the **Azure Kubernetes Service** tool from the **Tools** list. When the tool loads, you will see with the **Overview** page.
5. Select **Updates** from the page list on the left side of the tool, and then select **Update now** to upgrade your AKS host.

## Next steps
[Update Kubernetes version and container host OS of your AKS workload clusters](./upgrade.md)
