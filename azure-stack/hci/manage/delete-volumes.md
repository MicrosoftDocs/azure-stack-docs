---
title: Delete volumes in Azure Stack HCI
description: How to delete volumes in Azure Stack HCI using Windows Admin Center and PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.prod: windows-server
ms.date: 03/17/2020
---

# Deleting volumes in Azure Stack HCI

> Applies to: Windows Server 2019

This topic provides instructions for deleting volumes on a [Storage Spaces Direct](/windows-server/storage/storage-spaces/storage-spaces-direct-overview) cluster by using Windows Admin Center.

Watch a quick video on how to delete a volume using Windows Admin Center.

> [!VIDEO https://www.youtube-nocookie.com/embed/DbjF8r2F6Jo]

## Use Windows Admin Center to delete a volume

1. In Windows Admin Center, connect to a Storage Spaces Direct cluster, and then select **Volumes** from the **Tools** pane.
2. On the **Volumes** page, select the **Inventory** tab, and then select the volume that you want to delete.
3. At the top of the volumes detail page, select **Delete**.
4. In the confirmations dialog, select the check box to confirm that you want to delete the volume, and select **Delete**.

## Delete volumes using PowerShell

Use the **Remove-VirtualDisk** cmdlet to delete volumes in Storage Spaces Direct. This cmdlet is used to delete the **VirtualDisk** object, and return the space it used to the storage pool that exposes the **VirtualDisk** object.

First, launch PowerShell on your management PC and run the **Get-VirtualDisk** cmdlet with the **CimSession** parameter, which is the name of a Storage Spaces Direct cluster or server node, for example *clustername.microsoft.com*:

```PowerShell
Get-VirtualDisk -CimSession clustername.microsoft.com
```

This will return a list of possible values for the **-FriendlyName** parameter, which correspond to volume names on your cluster.

### Example

To delete a mirrored volume called *Volume1,* run the following command in PowerShell:

```PowerShell
Remove-VirtualDisk -FriendlyName "Volume1"
```

You will be asked to confirm that you want to perform the action and erase all the data that the volume contains. Choose Y or N.

   > [!WARNING]
   > This is not a recoverable action. This example permanently deletes a **VirtualDisk** Volume object.

## Next steps

For step-by-step instructions on other essential storage management tasks, see also:

- [Planning volumes in Storage Spaces Direct](../concepts/plan-volumes.md)
- [Creating volumes in Storage Spaces Direct](create-volumes.md)
- [Extending volumes in Storage Spaces Direct](extend-volumes.md)