---
title: Install solution upgrade on your Azure Stack HCI cluster
description: Learn about how to install upgrade on your Azure Stack HCI cluster.
author: alkohli
ms.topic: how-to
ms.date: 07/31/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---


# Install solution upgrade on your Azure Stack HCI cluster

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to install solution upgrade on your Azure Stack HCI solution after the Operating System (OS) was upgraded from version 22H2 to version 23H2.

The upgrade from Azure Stack HCI 22H2 to version 23H2 occurs in the following steps:

1. Upgrade the operating system.
1. Prepare for the solution upgrade.
1. Apply the solution upgrade.

This article only covers the last step, which is to install the solution upgrade.

## Prerequisites

Before you install the solution upgrade, make sure that you:

- Install the latest `AzureEdgeLifecycleManager` extension on each cluster node.
- Validate the cluster using the Environment Checker.
- Have an Active Directory user credential that's a member of the local Administrator group.
- Have IPv4 network range with six, contiguous IP addresses available for new Azure Arc services.
- Have Azure subscription permissions for [Azure Stack HCI Administrator and Reader](../manage/assign-vm-rbac-roles.md#about-builtin-rbac-roles).  

### Confirm the latest Azure Arc LCM extension is installed

1. Review the extension status using the Azure Arc resource view.

    :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-azureedgelcm-extension.png" alt-text="Screenshot of Azure Arc extensions list view." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-azureedgelcm-extension.png":::

   If an update is available, select the the **AzureEdgeLifecycleManager** extension and then select **Update**.

1. If the **AzureEdgeLifecycleManager** extension is not listed, install it manually using the following steps on each node:

   ```powershell
   $ResourceGroup = "YourRG"
   $Region= "eastus" #replace with your region
   $tenantid =”mytenantid’
   $subscriptionid =”MysubscriptionID”
   Login-AzAccount –UseDeviceAuthentication –tenantid  $tenantid –subscriptionid $subscriptionId
   Install-module az.connectedmachine
   New-AzConnectedMachineExtension -Name "AzureEdgeLifecycleManager"  -ResourceGroupName $ResourceGroup -MachineName $env:COMPUTERNAME -Location $Region -Publisher "Microsoft.AzureStack.Orchestration" -ExtensionType "LcmController"  -NoWait
   ```

## Install the solution upgrade via Azure portal

On the **Basics** tab, specify the following information:

1. Specify whether you want to create a new key vault to store the credentials, or if you want to select an existing key vault. Only vaults in the same resource group are shown.

1. Specify the deployment account credential. This credential is from your Active Directory for a principal that is a member of the local Administrator group on each cluster node.

   > [!NOTE]
   > The user can't be Administrator and can't use format `domain\username`.

1. Specify the custom location name used for Azure Arc services.

1. Specify network IP address information. A total of six IP addresses is required, defined by an IP address range. IP addresses in the range must:

   - Not be in use.
   - Meet outbound connectivity requirements.
   - Communicate to the host IP addresses.

   :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-basics-tab.png" alt-text="Screenshot of Upgrade Azure Stack HCI basics tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-basics-tab.png":::

## Validation

On the **Validation** tab, the operation will automatically create Azure resources like the cluster and the service principal, and also configure permissions and the audit login.

1. Select **Start validation** to begin the operation. To learn more about validation, see [Validation article]().

   :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-validation-tab.png" alt-text="Screenshot of Upgrade Azure Stack HCI validation tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-validation-tab.png":::

## Review + Create

Review the summary for the solution upgrade and then select **Review + Create**.

:::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-review-and-create-tab.png" alt-text="Screenshot of Upgrade Azure Stack HCI review and create tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-review-and-create-tab.png":::

## Monitor upgrade progress

To monitor upgrade progress, select **Settings** > **Deployments**.

> [!NOTE]
> If the upgrade fails, restart the upgrade operation to try again.

:::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-upgrade-progress.png" alt-text="Screenshot of Upgrade Azure Stack HCI upgrade progress." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-upgrade-progress.png":::
