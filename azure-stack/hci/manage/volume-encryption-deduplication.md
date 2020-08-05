---
title: Enable volume encryption, deduplication, and compression in Azure Stack HCI
description: This topic covers how to use volume encryption, deduplication, and compression in Azure Stack HCI using Windows Admin Center.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 08/5/2020
---

# Enable volume encryption, deduplication, and compression in Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic covers how to enable volume encryption with BitLocker, and how to enable deduplication and compression on volumes in Azure Stack HCI using Windows Admin Center. To learn how to create volumes, see [Create volumes](create-volumes.md).

## Turn on BitLocker to protect volumes
<!---Update all steps as needed. See validate topic for example--->
To turn on BitLocker to protect a volume using Windows Admin Center:

1. In Windows Admin Center, connect to a Storage Spaces Direct cluster, and then select **Volumes** from the **Tools** pane.
2. On the **Volumes** page, select the **Inventory** tab, and then select **Create volume**.
3. In the **Create volume** pane, enter a name for the volume, and leave **Resiliency** as **Three-way mirror**.
4. In **Size on HDD**, specify the size of the volume. For example, 5 TB (terabytes).
5. Select **Create**.

## Turn on deduplication and compression
Deduplication and compression is managed per volume. Deduplication and compression uses a post-processing model, which means that you won't see savings until it runs. When it does, it'll work over all files, even those that were there from before.

To tune on deduplication and compression on a volume in Windows Admin Center:

1. In Windows Admin Center, connect to a Storage Spaces Direct cluster, and then select **Volumes** from the **Tools** pane.
2. On the **Volumes** page, select the **Inventory** tab.
3. In the list of volumes, select the name of the volume that want to manage.
4. On the volume details page, click the switch labeled **Deduplication and compression**.
5. In the **Enable deduplication** pane, select the deduplication mode.

    Instead of complicated settings, Windows Admin Center lets you choose between ready-made profiles for different workloads. If you're not sure, use the default setting.

6. Select **Enable**.

Watch a quick video on how to turn on deduplication and compression.

> [!VIDEO https://www.youtube-nocookie.com/embed/PRibTacyKko]


<!---PS format example
```PowerShell
New-Volume -FriendlyName "Volume1" -FileSystem CSVFS_ReFS -StoragePoolFriendlyName S2D* -Size 1TB
```
--->

<!---Example figure path format
![Storage Tiers PowerShell Screenshot](media/creating-volumes/storage-tiers-screenshot.png)
--->

You're done! Repeat as needed to protect the data in your volumes.

## Next steps
For related topics and other storage management tasks, see also:

- [Storage Spaces Direct overview](/windows-server/storage/storage-spaces/storage-spaces-direct-overview)
- [Plan volumes](../concepts/plan-volumes.md)
- [Extend volumes](extend-volumes.md)
- [Delete volumes](delete-volumes.md)