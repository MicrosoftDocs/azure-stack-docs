---
title: Deploy an Azure Stack HCI system using the Azure portal (preview)
description: Learn how to deploy an Azure Stack HCI system from the Azure portal (preview)
author: JasonGerend
ms.topic: how-to
ms.date: 11/28/2023
ms.author: jgerend
#CustomerIntent: As an IT Pro, I want to deploy an Azure Stack HCI system of 1-16 nodes via the Azure portal so that I can host VM and container-based workloads on it.
---

# Deploy an Azure Stack HCI, version 23H2 system using the Azure portal (preview)

This article helps you deploy an Azure Stack HCI, version 23H2 system for testing using the Azure portal.

To instead deploy Azure Stack HCI, version 22H2, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md).

## Prerequisites

* Completion of [Register your servers with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md).
* For three-node clusters, the network adapters that carry the in-cluster storage traffic must be connected to a network switch. Deploying three-node clusters with storage network adapters that are directly connected to each server without a switch isn't supported in this preview.

## Start the wizard and fill out the basics

<!---1. Open the Azure portal and navigate to the Azure Stack HCI service (searching is an easy way) and then select **Deploy**.--->
1. Open a web browser, navigate to [**Azure portal**](https://portal.azure.com). Search for **Azure Arc**. Select **Azure Arc** and then go to **Infrastructure | Azure Stack HCI**. On the **Get started** tab, select **Deploy cluster (preview)**.
2. Select the **Subscription** and **Resource group** in which to store this system's resources.

   All resources in the Azure subscription are billed together.
3. Enter the **Cluster name** used for this Azure Stack HCI system when Active Directory Domain Services (AD DS) was prepared for this deployment.
4. Select the **Region** to store this system's Azure resources—in this preview you must use either **(US) East US** or **(Europe) West Europe**.

   We don't transfer a lot of data so it's OK if the region isn't close.
5. Select or create an empty **Key vault** to securely store secrets for this system, such as cryptographic keys, local admin credentials, and BitLocker recovery keys.

    Key Vault adds cost in addition to the Azure Stack HCI subscription. For details, see [Key Vault Pricing](https://azure.microsoft.com/pricing/details/key-vault).
6. Select the server or servers that make up this Azure Stack HCI system.

    :::image type="content" source="./media/deploy-via-portal/basics-tab-1.png" alt-text="Screenshot of the Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-1.png":::

7. Select **Validate**, wait for the green validation checkbox to appear, and then select **Next: Configuration**.

    The validation process checks that each server is running the same exact version of the OS, has the correct Azure extensions, and has matching (symmetrical) network adapters.

## Specify the deployment settings

Choose whether to create a new configuration for this system or to load deployment settings from a template–either way you'll be able to review the settings before you deploy:

<!--- **Quickstart template** - Load the settings to deploy your system from a template created by your hardware vendor or Microsoft.--->

1. Choose the source of the deployment settings:
   * **New configuration** - Specify all of the settings to deploy this system.
   * **Template spec** - Load the settings to deploy this system from a template spec stored in your Azure subscription.
   * **Quickstart template** - This setting isn't available in this release.

    :::image type="content" source="./media/deploy-via-portal/configuration-tab-1.png" alt-text="Screenshot of the Configuration tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/configuration-tab-1.png":::
2. Select **Next: Networking**.

## Specify network settings

1. For multi-node clusters, select whether the cluster is cabled to use a network switch for the storage network traffic:
    * **No switch for storage** - For two-node clusters with storage network adapters that connect the two servers directly without going through a switch.
    * **Network switch for storage traffic** - For clusters with storage network adapters connected to a network switch. This also applies to clusters that use converged network adapters that carry all traffic types including storage.
2. Choose traffic types to group together on a set of network adapters–and which types to keep physically isolated on their own adapters.

    There are three types of traffic we're configuring:
    * **Management** traffic between this system, your management PC, and Azure; also Storage Replica traffic
    * **Compute** traffic to or from VMs and containers on this system
    * **Storage** (SMB) traffic between servers in a multi-node cluster

    Select how you intend to group the traffic:
    * **Group all traffic** - If you're using network switches for storage traffic you can group all traffic types together on a set of network adapters.
    * **Group management and compute traffic** - This groups management and compute traffic together on one set of adapters while keeping storage traffic isolated on dedicated high-speed adapters.
    * **Group compute and storage traffic** - If you're using network switches for storage traffic, you can group compute and storage traffic together on your high-speed adapters while keeping management traffic isolated on another set of adapters.

      This is commonly used for private multi-access edge compute (MEC) systems.

    * **Custom configuration** - This lets you group traffic differently, such as carrying each traffic type on its own set of adapters.

   > [!TIP]
   > If you're deploying a single server that you plan to add servers to later, select the network traffic groupings you want for the eventual cluster. Then when you add servers they automatically get the appropriate settings.
3. For each group of traffic types (known as an *intent*), select at least one unused network adapter (but probably at least two matching adapters for redundancy).

    Make sure to use high-speed adapters for the intent that includes storage traffic.
4. For the storage intent, enter the **VLAN ID** set on the network switches used for each storage network.
    :::image type="content" source="./media/deploy-via-portal/networking-tab-1.png" alt-text="Screenshot of the Networking tab with network intents in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-1.png":::

5. Using the **Starting IP** and **Ending IP** (and related) fields, allocate a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the servers.

    These IPs are used by Azure Stack HCI and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid.

    :::image type="content" source="./media/deploy-via-portal/networking-tab-2.png" alt-text="Screenshot of the Networking tab with IP address allocation to systems and services in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-2.png":::

6. Select **Next: Management**.

## Specify management settings

1. Optionally edit the suggested **Custom location name** that helps users identify this system when creating resources such as VMs on it.
2. Create a new **Storage account** to store the cluster witness file.
<!---2. Enter an existing **Storage account** or create a new account to store the cluster witness file.

    You can use the same storage account with multiple clusters; each witness uses less than a kilobyte of storage.
--->
3. Enter the Active Directory **Domain** you're deploying this system into.

    This must be the same fully qualified domain name (FQDN) used when the Active Directory Domain Services (AD DS) domain was prepared for deployment.
4. Enter the **Computer name prefix** used when the domain was prepared for deployment (some use the same name as the OU name).
5. Enter the **OU** created for this deployment.
   For example: ``OU=HCI01,DC=contoso,DC=com``
6. Enter the **Deployment account** credentials.

    This domain user account was created when the domain was prepared for deployment.
7. Enter the **Local administrator** credentials for the servers.

    The credentials must be identical on all servers in the system.  If the current password doesn't meet the complexity requirements (12+ characters long, a lowercase and uppercase character, a numeral, and a special character), you must change it on all servers before proceeding.

    :::image type="content" source="./media/deploy-via-portal/management-tab-1.png" alt-text="Screenshot of the Management tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/management-tab-1.png":::

8. Select **Next: Security**.

## Set the security level

1. Select the security level for your system's infrastructure:
    * **Recommended security settings** - Sets the highest security settings.
    * **Customized security settings** - Lets you turn off security settings.

    :::image type="content" source="./media/deploy-via-portal/security-tab-1.png" alt-text="Screenshot of the Security tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/security-tab-1.png":::

2. Select **Next: Advanced**.

## Optionally change advanced settings and apply tags

1. Choose whether to create volumes for workloads now, saving time creating volumes and storage paths for VM images. You can create more volumes later.
    * **Create workload volumes and required infrastructure volumes (Recommended)** - Creates one thinly provisioned volume and storage path per server for workloads to use. This is in addition to the required one infrastructure volume per server.
    * **Create required infrastructure volumes only** - Creates only the required one infrastructure volume per server. You'll need to later create workload volumes and storage paths.
    * **Use existing data drives** (single servers only) - Preserves existing data drives that contain a Storage Spaces pool and volumes.

        To use this option you must be using a single server and have already created a Storage Spaces pool on the data drives. You also might need to later create an infrastructure volume and a workload volume and storage path if you don't already have them.

    :::image type="content" source="./media/deploy-via-portal/advanced-tab-1.png" alt-text="Screenshot of the Advanced tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/advanced-tab-1.png":::

2. Select **Next: Tags**.
3. Optionally add a tag to the Azure Stack HCI resource in Azure.

    Tags are name/value pairs you can use to categorize resources. You can then view consolidated billing for all resources with a given tag.
4. Select **Next: Validation**.

## Validate and deploy the system

1. Review the validation results, resolve any actionable issues, and then select **Next**.

    Don't select **Try again** while validation tasks are running as doing so can provide inaccurate results in this release.
1. Review the settings that will be used for deployment and then select **Deploy** to deploy the system.

    :::image type="content" source="./media/deploy-via-portal/review-create-tab-1.png" alt-text="Screenshot of the Review + Create tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/review-create-tab-1.png":::

The **Deployments** page then appears, which you can use to monitor the deployment progress.

If the progress doesn't appear, wait for a few minutes and then select **Refresh**. This page may show up as blank for an extended period of time owing to an issue in this release, but the deployment is still running if no errors show up.

Once the deployment starts, the first step in the deployment: **Begin cloud deployment** can take 45-60 minutes to complete. The total deployment time for a single server is around 1.5-2 hours while a two-node cluster takes about 2.5 hours to deploy.

## Verify a successful deployment

To confirm that the system and all of its Azure resources were successfully deployed
1. In the Azure portal, navigate to the resource group into which you deployed the system.
2. On the **Overview** > **Resources**, you should see the following:

|Number of resources  | Resource type  |
|---------|---------|
| 1 per server | Machine - Azure Arc |
| 1            | Azure Stack HCI     |
| 1            | Resource bridge     |
| 1            | Key vault           |
| 1            | Custom location     |
| 2*           | Storage account     |
| 1 per workload volume | Azure Stack HCI storage path - Azure Arc |

\* Extra storage accounts may be created by this preview release. Normally there would be one storage account created for the key vault and one for audit logs, which is a locally redundant storage (LRS) account with a lock placed on it.

## Rerun deployment

To rerun the deployment if there is a failure, follow these steps:

1. In the Azure portal, go the resource group you used for the deployment and then navigate to **Deployments**.
1. In the right-pane, from the top command bar, select **Redeploy**. This action reruns the deployment.

    :::image type="content" source="./media/deploy-via-portal/redeploy-failed-deployment.png" alt-text="Screenshot of how to rerun a failed deployment via Azure portal." lightbox="./media/deploy-via-portal/redeploy-failed-deployment.png":::

## Post deployment tasks

For security reasons, Remote Desktop Protocol (RDP) is disabled and the local administrator renamed after the deployment completes on Azure Stack HCI systems. For more information on the renamed administrator, go to [Local builtin user accounts](../concepts/other-security-features.md#about-local-built-in-user-accounts).

You may need to connect to the system via RDP to deploy workloads. Follow these steps to connect to your cluster via the Remote PowerShell and then enable RDP:

1. Run PowerShell as administrator on your management PC.
1. Connect to your Azure Stack HCI system via a remote PowerShell session.

    ```powershell
    $ip="<IP address of the Azure Stack HCI server>"
    Enter-PSSession -ComputerName $ip -Credential get-Credential
    ```

1. Enable RDP.

    ```powershell
    Enable-ASRemoteDesktop
    ```
    > [!NOTE]
    > As per the security best practices, keep the RDP access disabled when not needed.

1. Disable RDP>

    ```powershell
    Disable-ASRemoteDesktop
    ```

## Next steps

- If you didn't create workload volumes during deployment, create workload volumes and storage paths for each volume. For details, see [Create volumes on Azure Stack HCI and Windows Server clusters](../manage/create-volumes.md) and [Create storage path for Azure Stack HCI (preview)](../manage/create-storage-path.md).
- [Get support for Azure Stack HCI deployment issues (preview)](../manage/get-support-for-deployment-issues.md).
