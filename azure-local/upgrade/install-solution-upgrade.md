---
title: Install solution upgrade on Azure Local
description: Learn how to install the solution upgrade on your Azure Local instance.
author: alkohli
ms.topic: how-to
ms.date: 02/14/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---


# Install solution upgrade on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

This article describes how to install the solution upgrade on your Azure Local instance after the operating system (OS) was upgraded from version 22H2 to version 23H2.

Throughout this article, we refer to OS version 23H2 as the new version and version 22H2 as the old version.

> [!IMPORTANT]
> While the OS upgrade is generally available, the solution upgrade will have a phased rollout. Microsoft engineering will contact Azure Local customers proactively to schedule the solution upgrade of their clusters upgraded to OS 23H2. 

## Prerequisites

Before you install the solution upgrade, make sure that you:

- Validate the system using the Environment Checker as per the instructions  in [Assess solution upgrade readiness](./validate-solution-upgrade-readiness.md#run-the-validation).
- Verify that latest `AzureEdgeLifecycleManager` extension on each machine is installed as per the instructions in [Check the Azure Arc extension](./validate-solution-upgrade-readiness.md#remediation-9-check-the-azure-arc-lifecycle-extension).

    :::image type="content" source="media/install-solution-upgrade/verify-lcmextension-installed.png" alt-text="Screenshot of Extensions page showing AzureEdgeLifeCycleManager extension install on an Azure Local machine." lightbox="./media/install-solution-upgrade/verify-lcmextension-installed.png":::

- Have an Active Directory user credential that's a member of the local Administrator group. Work with your Active Directory administrator to obtain this credential.  
- Have IPv4 network range with six, contiguous IP addresses available for new Azure Arc services. Work with your network administrator to ensure that the IP addresses aren't in use and meet the outbound connectivity requirement.
- Have Azure subscription permissions for [Azure Stack HCI Administrator and Reader](../manage/assign-vm-rbac-roles.md#about-builtin-rbac-roles).  

    :::image type="content" source="media/install-solution-upgrade/verify-subscription-permissions-roles.png" alt-text="Screenshot of subscription with permissions assigned to required roles for upgrade." lightbox="./media/install-solution-upgrade/verify-subscription-permissions-roles.png":::

## Install the solution upgrade via Azure portal

You install the solution upgrade via the Azure portal.

> [!IMPORTANT]
> Microsoft only supports upgrade applied from **Azure Local** resource page. Use of 3rd party tools to install upgrades is not supported.

Follow these steps to install the solution upgrade:

1. Go to your Azure Local resource in Azure portal.
1. In the **Overview** page, you can see a banner indicating that a solution upgrade is available. Select the **Upgrade** link in the banner.

   :::image type="content" source="./media/install-solution-upgrade/upgrade-banner.png" alt-text="Screenshot of Azure Local Overview page with upgrade available banner." lightbox="./media/install-solution-upgrade/upgrade-banner.png":::

### Basics tab

On the **Basics** tab, specify the following information:

1. Select an existing key vault from vaults in the resource group. Sharing an existing key vault can have security implications. If you don't have a key vault, you can create a new one to store the credentials.

   1. Select **Create a new key vault**.
   1. Provide a **Name** for the new key vault. The name should be 3 to 24 characters long and contain only letters, numbers, and hyphens. Two consecutive hyphens are not allowed.

   :::image type="content" source="./media/install-solution-upgrade/create-new-key-vault.png" alt-text="Screenshot of Create key vault page." lightbox="./media/install-solution-upgrade/create-new-key-vault.png":::

1. Specify the deployment account credential. This credential is from your Active Directory for a principal that is a member of the local Administrator group on each machine. 

   > [!NOTE]
   > The user can't be Administrator and can't use format `domain\username`.

1. Accept default name or specify the custom location name used for Azure Arc services.

1. Specify network IP address information. A total of six, contiguous IP addresses is required, defined by an IP address range. IP addresses in the range must:

   - Not be in use.
   - Meet outbound connectivity requirements.
   - Communicate to the host IP addresses.

   :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-basics-tab.png" alt-text="Screenshot of Upgrade Azure Local basics tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-basics-tab.png":::

1. Select **Next: Validation**.

### Validation tab

On the **Validation** tab, the operation automatically creates Azure resources and also configures permissions and the audit login.

1. Select **Start validation** to begin the operation. This operation involves running the Environment Checker to check external connectivity and storage requirements and that the environment is ready for solution upgrade. To learn more about validation, see [Validate solution upgrade readiness of your Azure Local instance](./validate-solution-upgrade-readiness.md).

   :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-validation-tab.png" alt-text="Screenshot of Upgrade Azure Local validation tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-validation-tab.png":::

1. After the validation is complete, select **Next: Review + Create**.

### Review + Create tab

1. On the **Review + Create** tab, review the summary for the solution upgrade.

    :::image type="content" source="./media/install-solution-upgrade/upgrade-22h2-to-23h2-review-and-create-tab.png" alt-text="Screenshot of Upgrade Azure Local review and create tab." lightbox="./media/install-solution-upgrade/upgrade-22h2-to-23h2-review-and-create-tab.png":::

1. Select **Review + Create** to start the upgrade process. You see a notification that the deployment is in progress.

## Monitor upgrade progress

1. Once the upgrade starts, you are automatically taken to **Settings > Deployment**. Refresh the screen periodically and monitor the upgrade progress.

    :::image type="content" source="./media/install-solution-upgrade/upgrade-progress-1.png" alt-text="Screenshot of Upgrade Azure Local upgrade progress." lightbox="./media/install-solution-upgrade/upgrade-progress-1.png":::

1. Wait for the upgrade to complete. The solution upgrade process can take a few hours depending upon the number of machines in the system.

    :::image type="content" source="./media/install-solution-upgrade/upgrade-progress-2.png" alt-text="Screenshot of Upgrade Azure Local showing a completed upgrade." lightbox="./media/install-solution-upgrade/upgrade-progress-2.png":::

> [!NOTE]
> If the upgrade fails, restart the upgrade operation to try again.

## Verify a successful upgrade

Follow these steps to verify that the upgrade was successful:

1. In Azure portal, go to the resource group where you deployed the Azure Local instance.
1. On the **Overview > Resources** page, you should see the following resources:

    
    | Resource type | Number of resources   |
    |---------|---------|
    | Machine - Azure Arc     | 1 per machine         |
    | Azure Local         | 1       |
    | Arc Resource Bridge     | 1, *-arcbridge* suffix by default       |
    | Custom location         | 1, *-cl* suffix by default       |
    | Key Vault               | 1       |

    Here is a screenshot of the resources in the resource group:

    :::image type="content" source="./media/install-solution-upgrade/verify-upgrade-portal.png" alt-text="Screenshot of Upgrade Azure Local resource health." lightbox="./media/install-solution-upgrade/verify-upgrade-portal.png":::

## Post solution upgrade tasks

> [!IMPORTANT]
> As additional services are installed during the solution upgrade, the resource consumption increases after the solution upgrade is complete.

After the solution upgrade is complete, you may need to perform additional tasks to secure your system and ensure it's ready for workloads.

- You may need to connect to the system via Remote Desktop Protocol (RDP) to deploy workloads. For more information, see [Enable RDP](../deploy/deploy-via-portal.md#enable-rdp).
- To prevent the accidental deletion of resources, you can lock resources.
- You need to upgrade the security posture. For more information, see [Update security posture on Azure Local after upgrade](../manage/manage-security-post-upgrade.md).
- You may need to create workloads and storage paths for each volume. For details, see [Create volumes on Azure Local](/windows-server/storage/storage-spaces/create-volumes) and [Create storage path for Azure Local](../manage/create-storage-path.md).

- If you haven't used Cluster-Aware Updating (CAU) for patching your system, you must ensure the permissions are set correctly. For more information, see [Cluster aware updating (CAU)](../plan/configure-custom-settings-active-directory.md#cluster-aware-updating-cau)


## Next steps

If you run into issues during the upgrade process, see [Troubleshoot solution upgrade on Azure Local](./troubleshoot-upgrade-to-azure-stack-hci-23h2.md).
