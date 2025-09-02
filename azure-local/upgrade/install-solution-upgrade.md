---
title: Install solution upgrade on Azure Local
description: Learn how to install the solution upgrade on your Azure Local instance.
author: alkohli
ms.topic: how-to
ms.date: 09/02/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
ms.custom: sfi-image-nochange
---


# Install solution upgrade on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

> [!IMPORTANT]
> [!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

This article describes how to install the solution upgrade on your Azure Local instance after upgrading the operating system (OS) from one of the following versions:

- 20349.xxxx (22H2) to 25398.xxxx (23H2)
- 20349.xxxx (22H2) to 26100.xxxx (24H2)
- 25398.xxxx (23H2) to 26100.xxxx (24H2)

Throughout this article, we refer to OS versions 24H2 and 23H2 as the *new* version, and version 22H2 as the *old* version.

> [!IMPORTANT]
> While the OS upgrade is generally available, the solution upgrade is rolled out in phases. Additionally, the solution upgrade isn't available to customers in Azure China.

## Prerequisites

Before you install the solution upgrade, make sure that you:

- Validate the system using the Environment Checker as per the instructions in [Assess solution upgrade readiness](./validate-solution-upgrade-readiness.md#run-the-validation).
- Have failover cluster name between 3 to 15 characters.
- Create an Active Directory Lifecycle Manager (LCM) user account that's a member of the local Administrator group. For instructions, see [Prepare Active Directory for Azure Local deployment](../deploy/deployment-prep-active-directory.md).
- Have IPv4 network range that matches your host IP address subnet with six, contiguous IP addresses available for new Azure Arc services. Work with your network administrator to ensure that the IP addresses aren't in use and meet the outbound connectivity requirement.
- Have Azure subscription permissions for [Azure Stack HCI Administrator and Reader](../manage/assign-vm-rbac-roles.md#about-built-in-rbac-roles).  

    :::image type="content" source="media/install-solution-upgrade/verify-subscription-permissions-roles.png" alt-text="Screenshot of subscription with permissions assigned to required roles for upgrade." lightbox="./media/install-solution-upgrade/verify-subscription-permissions-roles.png":::

## Before you begin

There are a few things to consider before you begin the solution upgrade process:

- Microsoft supports upgrade applied from Azure Local resource page or by using an ARM template. Use of third-party tools to install upgrades isn't supported.
- We recommend you perform the solution upgrade during a maintenance window. After the upgrade, host machine might reboot and the workloads will be live migrated, causing brief disconnections.
- If you have Azure Kubernetes Service (AKS) workloads on Azure Local, wait for the solution upgrade banner to appear on the Azure Local resource page. Then, remove AKS and all AKS hybrid settings before you apply the solution upgrade.
- By installing the solution upgrade, existing Hyper-V VMs won't automatically become Azure Arc VMs.

## Install the solution upgrade via Azure portal

You install the solution upgrade via the Azure portal.

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
    | Azure Arc Resource Bridge     | 1, *-arcbridge* suffix by default       |
    | Custom location         | 1, *-cl* suffix by default       |
    | Key Vault               | 1       |

    Here's a screenshot of the resources in the resource group:

    :::image type="content" source="./media/install-solution-upgrade/verify-upgrade-portal.png" alt-text="Screenshot of Upgrade Azure Local resource health." lightbox="./media/install-solution-upgrade/verify-upgrade-portal.png":::

1. Verify your solution version.

    Here's a screenshot of the **Overview** page of the Azure Local resource, showing the solution version:

    :::image type="content" source="./media/install-solution-upgrade/verify-solution-version.png" alt-text="Screenshot of Azure Local overview page and solution version." lightbox="./media/install-solution-upgrade/verify-solution-version.png":::

    > [!NOTE]
    > After a solution upgrade, you might see a 10.x version, this is expected and supported. For more information, see [Azure Local release information summary](../release-information-23h2.md#azure-local-release-information-summary).

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

If you run into issues during the upgrade process, see [Troubleshoot solution upgrade on Azure Local](./troubleshoot-upgrade-to-23h2.md).
