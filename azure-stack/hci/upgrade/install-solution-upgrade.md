---
title: Install solution upgrade on your Azure Stack HCI cluster
description: Learn about how to install upgrade on your Azure Stack HCI cluster.
author: alkohli
ms.topic: how-to
ms.date: 08/13/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---


# Install solution upgrade on your Azure Stack HCI cluster

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to install solution upgrade on your Azure Stack HCI solution after the Operating System (OS) was upgraded from version 22H2 to version 23H2.

Throughout this article, we refer to Azure Stack HCI, version 23H2 as the new version and Azure Stack HCI, version 22H2 as the old version.

## Prerequisites

Before you install the solution upgrade, make sure that you:

- Validate the cluster using the Environment Checker as per the instructions  in [Assess solution upgrade readiness](./validate-solution-upgrade-readiness.md#run-the-validation).
- Verify that latest `AzureEdgeLifecycleManager` extension on each cluster node is installed as per the instructions in [Check the Azure Arc extension](./validate-solution-upgrade-readiness.md#remediation-9-check-the-azure-arc-lifecycle-extension).
- Have an Active Directory user credential that's a member of the local Administrator group. Work with your Active Directory administrator to obtain this credential.
- Have IPv4 network range with six, contiguous IP addresses available for new Azure Arc services. Work with your network administrator to ensure that the IP addresses aren't in use and meet the outbound connectivity requirement.
- Have Azure subscription permissions for [Azure Stack HCI Administrator and Reader](../manage/assign-vm-rbac-roles.md#about-builtin-rbac-roles).  

## Install the solution upgrade via Azure portal

### Basics tab

On the **Basics** tab, specify the following information:

1. Specify whether you want to create a new key vault to store the credentials, or if you want to select an existing key vault. Only vaults in the same resource group are shown.

   > [!NOTE]
   > We recommend that you select a new key vault as sharing an existing key vauilt may have security implications.

1. Specify the deployment account credential. This credential is from your Active Directory for a principal that is a member of the local Administrator group on each cluster node.

   > [!NOTE]
   > The user can't be Administrator and can't use format `domain\username`.

1. Specify the custom location name used for Azure Arc services.

1. Specify network IP address information. A total of six IP addresses is required, defined by an IP address range. IP addresses in the range must:

   - Not be in use.
   - Meet outbound connectivity requirements.
   - Communicate to the host IP addresses.

   :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-basics-tab.png" alt-text="Screenshot of Upgrade Azure Stack HCI basics tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-basics-tab.png":::

### Validation tab

On the **Validation** tab, the operation automatically creates Azure resources like the cluster and the service principal, and also configures permissions and the audit login.

1. Select **Start validation** to begin the operation. To learn more about validation, see [Validate solution upgrade readiness of your Azure Stack HCI cluster](./validate-solution-upgrade-readiness.md).

   :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-validation-tab.png" alt-text="Screenshot of Upgrade Azure Stack HCI validation tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-validation-tab.png":::

### Review + Create tab

Review the summary for the solution upgrade and then select **Review + Create**.

:::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-review-and-create-tab.png" alt-text="Screenshot of Upgrade Azure Stack HCI review and create tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-review-and-create-tab.png":::

## Monitor upgrade progress

To monitor upgrade progress, select **Settings** > **Deployments**.

:::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-upgrade-progress.png" alt-text="Screenshot of Upgrade Azure Stack HCI upgrade progress." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-upgrade-progress.png":::

> [!NOTE]
> If the upgrade fails, restart the upgrade operation to try again.
