---
title: Delete volumes on Azure Stack HCI and Windows Server clusters
description: How to delete volumes on Azure Stack HCI and Windows Server clusters by using Windows Admin Center or PowerShell.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 03/09/2021
---

# Delete volumes on Azure Stack HCI and Windows Server clusters

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2019

This article explains how to delete volumes by using either Windows Admin Center or PowerShell.

## Delete volumes with Windows Admin Center

1. In Windows Admin Center, connect to a cluster, and then select **Volumes** from the **Tools** pane on the left.
2. On the **Volumes** page, select the **Inventory** tab, and then select the volume that you want to delete.
3. At the top of the volumes detail page, select **Delete**.
4. In the confirmations dialog, select the check box to confirm that you want to delete the volume, and select **Delete**.

   :::image type="content" source="media/delete-volumes/delete-volume.png" alt-text="Select the volume that you want to delete, select delete, and then confirm that you want to erase all the data on the volume." lightbox="media/delete-volumes/delete-volume.png":::

## Delete volumes with PowerShell

Use the **Remove-VirtualDisk** cmdlet to delete the **VirtualDisk** object and return the space it used to the storage pool that exposes the **VirtualDisk** object.

First, launch PowerShell on your management PC and run the **Get-VirtualDisk** cmdlet with the **CimSession** parameter, which is the name of a cluster or server node, for example *clustername.contoso.com*:

```PowerShell
Get-VirtualDisk -CimSession clustername.contoso.com
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

- [Plan volumes](../concepts/plan-volumes.md)
- [Create volumes](create-volumes.md)
- [Expand volumes](extend-volumes.md)