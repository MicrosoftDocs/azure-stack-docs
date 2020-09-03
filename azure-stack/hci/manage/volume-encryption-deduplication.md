---
title: Enable volume encryption, deduplication, and compression in Azure Stack HCI
description: This topic covers how to use volume encryption, deduplication, and compression in Azure Stack HCI using Windows Admin Center.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 09/03/2020
---

# Enable volume encryption, deduplication, and compression in Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019

This topic covers how to enable encryption with BitLocker on volumes in Azure Stack HCI using Windows Admin Center. It also covers how to enable deduplication and compression on volumes. To learn how to create volumes, see [Create volumes](create-volumes.md).

## Turn on BitLocker to protect volumes
To turn on BitLocker in Windows Admin Center:

1. Connect to a Storage Spaces Direct cluster, and then on the **Tools** pane, select **Volumes**.
1. On the **Volumes** page, select the **Inventory** tab, and then under **Optional features**, switch on the **Encryption (BitLocker)** toggle.

    :::image type="content" source="media/volume-encryption-deduplication/bitlocker-toggle-switch.png" alt-text="The toggle switch to enable BitLocker":::

1. On the **Encryption (BitLocker)** pop-up, select **Start**, and then on the **Turn on Encryption** page, provide your credentials to complete the workflow.

>[!NOTE]
   > If the **Install BitLocker feature first** pop-up displays, follow its instructions to install the feature on each server in the cluster, and then restart your servers.

## Turn on deduplication and compression
Deduplication and compression are managed per volume. Deduplication and compression use a post-processing model, which means that you won't see savings until it runs. When it does, it will work over all files, even files that were there from before.

To turn on deduplication and compression on a volume in Windows Admin Center:

1. Connect to a Storage Spaces Direct cluster, and then on the **Tools** pane, select **Volumes**.
1. On the **Volumes** page, select the **Inventory** tab.
1. In the list of volumes, select the name of the volume that you want to manage.
1. On the volume details page, switch on the **Deduplication and compression** toggle.
1. On the **Enable deduplication** pane, select the deduplication mode.

    Instead of complicated settings, Windows Admin Center lets you choose between ready-made profiles for different workloads. If you're not sure, use the default setting.

1. Select **Enable deduplication**.

Watch a quick video on how to turn on deduplication and compression. The video doesn't show encryption.

> [!VIDEO https://www.youtube-nocookie.com/embed/PRibTacyKko]

Enabling volume encryption has a small impact on volume performance—typically under 10%, but the impact varies depending on your hardware and workloads. Data deduplication and compression also has an impact on performance—for details, see [Determine which workloads are candidates for Data Deduplication](/windows-server/storage/data-deduplication/install-enable#enable-dedup-candidate-workloads).

<!---Add info on greyed out ReFS option? --->

You're done! Repeat as needed to protect the data in your volumes.

## Next steps
For related topics and other storage management tasks, see also:

- [Storage Spaces Direct overview](/windows-server/storage/storage-spaces/storage-spaces-direct-overview)
- [Plan volumes](../concepts/plan-volumes.md)
- [Extend volumes](extend-volumes.md)
- [Delete volumes](delete-volumes.md)