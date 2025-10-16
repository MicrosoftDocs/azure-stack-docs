---
title: Deploy rack aware cluster using the Azure portal (Preview)
description: Learn how to deploy a rack aware cluster via the Azure portal with step-by-step guidance, including configuration, networking, and validation processes. (Preview)
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 10/15/2025
ms.topic: how-to
---

# Deploy rack aware cluster via the Azure portal (Preview)

This document describes the steps to deploy Azure Local rack aware clusters using the Azure portal.

## Prerequisites

Make sure to complete the steps in [Prepare for rack aware cluster deployment](./rack-aware-cluster-deploy-prep.md).

## Deploy rack aware cluster

To deploy a rack aware cluster, follow the steps to [Deploy an Azure Local instance via the Azure portal](./deploy-via-portal.md). In general, the steps are similar to deploying a standard single cluster. The differences are highlighted in the following sections.

## Start the wizard and fill out the basics

1. Go to the Azure portal. Search for and select **Azure Local**. On the **Azure Arc > Azure Local** page, go to the **Get started** tab. On the **Deploy Azure Local** tile, select **Create instance**.

   :::image type="content" source="./media/deploy-via-portal/get-started-1.png" alt-text="Screenshot of the Get started tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/get-started-1.png":::

1. Select the **Subscription** and **Resource group** in which to store this system's resources.

   All resources in the Azure subscription are billed together.

1. Enter the **Instance name** to use for this Azure Local instance.

1. In this step, select **Rack aware cluster** for the **Cluster options**.

1. Select the **Region** to store this system's Azure resources. For a list of supported Azure regions, [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements).

   We don't transfer a lot of data so it's OK if the region isn't close.

1. Select  **+ Add machines**. Select the machine or machines that make up this Azure Local instance.

   > [!IMPORTANT]
   > Machines must not be joined to Active Directory before deployment.

1. On **+ Add machines** page:
    1. The operating system for your Azure Local machines is automatically selected as Azure Stack HCI.
    1. Select an even number of machines for the cluster. These machines could show as **Ready** or as **Missing Arc extensions**.
    1. Select **Add**. The machines show up on the **Basics** tab.
    1. Once you add the machines, Arc extensions automatically install on the selected machines. This operation takes several minutes. Refresh the page to view the status of the extension installation.

    After the extensions are installed successfully, the status of the machine updates to **Ready**.

1. **Validate selected machines**. Wait for the green validation check to indicate the validation is successful. The validation process checks that each machine is running the same exact version of the OS, has the correct Azure extensions, and has matching (symmetrical) network adapters.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-basics.png" alt-text="Screenshot of successful validation on the Basics tab in deployment via Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-basics.png":::

1. **Select an existing Key Vault** or select **Create a new Key Vault**. Create an empty key vault to securely store secrets for this system, such as cryptographic keys, local admin credentials, and BitLocker recovery keys.

1. On the **Create a new key vault** page, provide information for the specified parameters and select **Create**:

   :::image type="content" source="./media/deploy-via-portal/basics-tab-6.png" alt-text="Screenshot of Create a new key vault on Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-6.png":::

    1. Accept the suggested name or provide a name for the key vault you create.
    1. Accept the default number of Days to retain deleted vaults or specify a value between 7 and 90 days. You can’t change the retention period later. The key vault creation takes several minutes.
    1. If you don’t have permissions to the resource group, you see a message that you have insufficient permissions for the key vault. Select **Grant key vault permissions**.

   :::image type="content" source="./media/rack-aware-cluster-deploy-portal/basics-tab-7.png" alt-text="Screenshot of key vault parameters specified on the Basics tab in deployment via Azure portal." lightbox="./media/rack-aware-cluster-deploy-portal/basics-tab-7.png":::

    The key vault adds cost in addition to the Azure Local subscription. For details, see [Key vault pricing](https://azure.microsoft.com/pricing/details/key-vault). View security implications when sharing an existing key vault.


1. Select **Next: Configuration**.

## Specify the deployment settings

On the **Configuration** tab, choose whether to create a new configuration for this system or to load deployment settings from a template–either way you are able to review the settings before you deploy:

1. Choose the source of the deployment settings:
   * **New configuration** - Specify all of the settings to deploy this system. In this example, we choose this option.
   * **Template spec** - Load the settings to deploy this system from a template spec stored in your Azure subscription.
   * **Quickstart template** - This setting isn't available in this release.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-deployment-settings.png" alt-text="Screenshot of deployment settings in the Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-deployment-settings.png":::

1. Select **Next: Networking**.

## Specify network settings

1. Choose the only storage connectivity available option for a rack aware cluster as **Network switch for storage traffic**.
1. Choose the only networking pattern available for rack aware cluster as **Group management and compute traffic**. This groups management and compute traffic together on one set of adapters while keeping storage traffic isolated on dedicated high-speed adapters. You create two network intents:
    - Management and compute intent.
    - Storage intent.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-network-settings.png" alt-text="Screenshot of network settings in the Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-network-settings.png":::


1. Choose the IP allocation as **Manual** or **Automatic**. Use **Automatic** if you use a DHCP server for IP assignments in your network.

1. If you picked static IP, provide the following values:
    1. Using the **Starting IP** and **Ending IP** (and related) fields, allocate a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.

        These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid.
    1. Provide the Subnet mask, Default gateway, and one or more DNS servers.
    1. Validate subnet.

    :::image type="content" source="./media/deploy-via-portal/networking-tab-4.png" alt-text="Screenshot of the Networking tab with IP address allocation to systems and services in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-4.png":::

1. Select **Next: Management**.


## Specify management settings

1. Optionally edit the suggested **Custom location name** that helps users identify this system when creating resources such as VMs on it.
1. For rack aware cluster, cluster witness is required. Select an existing Storage account or create a new Storage account to store the cloud witness file. Choose **Cloud witness** and provide a name for the cloud witness.



    When selecting an existing account, the dropdown list filters to display only the storage accounts contained in the specified resource group for deployment. You can use the same storage account with multiple clusters; each witness uses less than a kilobyte of storage.

    :::image type="content" source="./media/deploy-via-portal/management-tab-2.png" alt-text="Screenshot of the Management tab with storage account for cluster witness for deployment via Azure portal." lightbox="./media/deploy-via-portal/management-tab-2.png":::

1. Enter the Active Directory **Domain** where you're deploying this system. This must be the same fully qualified domain name (FQDN) used when the Active Directory Domain Services (AD DS) domain was prepared for deployment.

1. Enter the **OU** created for this deployment. The OU can't be at the top level of the domain.
   For example: `OU=Local001,DC=contoso,DC=com`.

1. Enter the **Deployment account** credentials.

    This domain user account was created when the domain was prepared for deployment.
1. Enter the **Local administrator** credentials for the machines.

    The credentials must be identical on all machines in the system.  If the current password doesn't meet the complexity requirements (14+ characters long, a lowercase and uppercase character, a numeral, and a special character), you must change it on all machines before proceeding.

     :::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-management-settings.png" alt-text="Screenshot of management settings in the Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-management-settings.png":::

1. Select **Next: Security**.

## Set the security level

1. Select the security level for your system's infrastructure:
    * **Recommended security settings** - Sets the highest security settings.
    * **Customized security settings** - Lets you turn off security settings.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-security-settings.png" alt-text="Screenshot of security settings in the Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-security-settings.png":::

1. Select **Next: Advanced**.

## Optionally change advanced settings and apply tags


1. Select the only option available for rack aware cluster, which is for creating workload volumes and required infrastructure volumes (also known as Express mode). This option creates one thinly provisioned volume and storage path per machine for workloads to use. This is in addition to the required one infrastructure volume per cluster.

    > [!IMPORTANT]
    > Don't delete the infrastructure volumes created during deployment.

    Here's a summary of the volumes that are created based on the number of machines in your system. To change the resiliency setting of the workload volumes, delete them and recreate them, being careful not to delete the infrastructure volumes.
    
    
    |# machines  |Volume resiliency  |# Infrastructure volumes  |# Workload volumes  |
    |---------|---------|---------|----------|
    |Single machine    |Two-way mirror         | 1        |  1        |
    |Two machines     | Two-way mirror       | 1        |  2        |
    |Three machines +     | Three-way mirror        |1        |1 per machine         |

1. Specify the **Local availability zone** configurations. Ensure servers in the same zone are physically in the same rack, which isn't validated in the deployment process in this release. It's critical to configure this correctly, otherwise, one rack failure could bring the whole cluster down.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-advanced-settings.png" alt-text="Screenshot of local availability zone settings in the Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-advanced-settings.png":::

1. Select **Next: Tags**.
1. Optionally add a tag to the Azure Local resource in Azure.
    Tags are name/value pairs you can use to categorize resources. You can then view consolidated billing for all resources with a given tag.
1. Select **Next: Validation**.
1. Select **Start validation**. The validation takes about 15 minutes to deploy one to two machines and longer for bigger deployments. Monitor the validation progress.

## Validate and deploy the system


1. After the validation is complete, review the validation results.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-validation.png" alt-text="Screenshot of validation progress in the Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-validation.png":::

    If the validation has errors, resolve any actionable issues.

    <!-- verify w/ Barbara Don't select **Try again** while validation tasks are running as doing so can provide inaccurate results in this release.-->

1. Select **Next: Review + create**. 
1. Review the settings that are used for deployment and then select **Create** to deploy the system.

    :::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-review-create.png" alt-text="Screenshot of review and create settings in the Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-review-create.png":::

    The **Deployments** page appears, which you can use to monitor the deployment progress.

    <!-->:::image type="content" source="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-deployments.png" alt-text="Screenshot of deployment progress in the Azure portal." lightbox="media/rack-aware-cluster-deploy-portal/rack-aware-cluster-deployments.png":::-->

    You can monitor the deployment status just like the standard cluster.

## Verify a successful deployment

To confirm that the system and all of its Azure resources were successfully deployed:
1. In the Azure portal, navigate to the resource group into which you deployed the system.
2. On the **Overview** > **Resources**, you should see the following:

    |Number of resources  | Resource type  |
    |---------|---------|
    | 1 per machine | Machine - Azure Arc |
    | 1            | Azure Local     |
    | 1            | Arc Resource Bridge |
    | 1            | Key vault           |
    | 1            | Custom location     |
    | 2*           | Storage account     |
    | 1 per workload volume | Azure Local storage path - Azure Arc |
    
    \* One storage account is created for the cloud witness and one for key vault audit logs. These accounts are locally redundant storage (LRS) accounts with a lock placed on them.

## Next steps

- After the deployment is complete, follow the steps in [Post-deployment tasks](../index.yml).
- [Get support for Azure Local deployment issues](../manage/get-support-for-deployment-issues.md).

