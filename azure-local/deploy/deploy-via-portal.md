---
title: Deploy an Azure Local instance using the Azure portal
description: Learn how to deploy an Azure Local instance from the Azure portal
author: alkohli
ms.topic: how-to
ms.date: 06/24/2025
ms.author: alkohli
ms.service: azure-local
#CustomerIntent: As an IT Pro, I want to deploy an Azure Local instance of 1-16 machines via the Azure portal so that I can host VM and container-based workloads on it.
---

# Deploy Azure Local using the Azure portal

This article helps you deploy an Azure Local instance using the Azure portal.

## Prerequisites

- Completion of [Register your machines with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md).
<!-- Cristian to confirm * For three-node systems, the network adapters that carry the in-cluster storage traffic must be connected to a network switch. Deploying three-node systems with storage network adapters that are directly connected to each machine without a switch isn't supported in this preview.-->

::: moniker range="<=azloc-24113"

- To deply Azure Local 2411.3 and earlier, use the alternative version of the [Azure portal](https://aka.ms/dfc-2411deploycluster). Use this version only for deployment, don't use it for any other purpose.

::: moniker-end

## Start the wizard and fill out the basics

1. Go to the Azure portal. Search for and select **Azure Local**. On the **Azure Arc|Azure Local**, go to the **Get started** tab. On the **Deploy Azure Local** tile, select **Create instance**.

   :::image type="content" source="./media/deploy-via-portal/get-started-1.png" alt-text="Screenshot of the Get started tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/get-started-1.png":::

1. Select the **Subscription** and **Resource group** in which to store this system's resources.

   All resources in the Azure subscription are billed together.

1. Enter the **Instance name** to use for this Azure Local instance.

1. Select the **Region** to store this system's Azure resources. For a list of supported Azure regions, [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements).

   We don't transfer a lot of data so it's OK if the region isn't close. Select  **+ Add machines**.

1. Select the machine or machines that make up this Azure Local instance.

   > [!IMPORTANT]
   > Machines must not be joined to Active Directory before deployment.

   :::image type="content" source="./media/deploy-via-portal/basics-tab-1.png" alt-text="Screenshot of the Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-1.png":::

1. On the **Add machines** page:
    1. The operating system for your Azure Local machines is automatically selected as Azure Stack HCI.
    1. Select one or more machines that make up this Azure Local instance. These machines could show as **Ready** or as **Missing Arc extensions**.
    1. Select **Add**. The machines show up on the **Basics** tab.

   :::image type="content" source="./media/deploy-via-portal/basics-tab-2.png" alt-text="Screenshot of Add machines through the Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-2.png":::

1. Select **Install extensions**. This action installs Arc extensions on the selected machines. This operation takes several minutes. Refresh the page to view the status of the extension installation.

   :::image type="content" source="./media/deploy-via-portal/basics-tab-3.png" alt-text="Screenshot of the Install extensions on the Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-3.png":::
    
    After the extensions are installed successfully, the status of the machine updates to **Ready**.

1. **Validate selected machines**. Wait for the green validation check to indicate the validation is successful. The validation process checks that each machine is running the same exact version of the OS, has the correct Azure extensions, and has matching (symmetrical) network adapters.

   :::image type="content" source="./media/deploy-via-portal/basics-tab-5.png" alt-text="Screenshot of successful validation on the Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-5.png":::

    If the validation fails with wrong extension version, go to **Install extensions** to install the appropriate version of extension.

    After the extensions are installed successfully, **Add machines** by selecting from the same list of machines and then **Validate selected machines**.

1. **Select an existing Key Vault** or select **Create a new Key Vault**. Create an empty key vault to securely store secrets for this system, such as cryptographic keys, local admin credentials, and BitLocker recovery keys.

1. On the **Create a new key vault** page, provide information for the specified parameters and select **Create**:

   :::image type="content" source="./media/deploy-via-portal/basics-tab-6.png" alt-text="Screenshot of Create a new key vault on Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-6.png":::

    1. Accept the suggested name or provide a name for the key vault you create.
    1. Accept the default number of Days to retain deleted vaults or specify a value between 7 and 90 days. You can’t change the retention period later. The key vault creation takes several minutes.
    1. If you don’t have permissions to the resource group, you see a message that you have insufficient permissions for the key vault. Select **Grant key vault permissions**.

   :::image type="content" source="./media/deploy-via-portal/basics-tab-7.png" alt-text="Screenshot of key vault parameters specified on the Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-7.png":::

    The key vault adds cost in addition to the Azure Local subscription. For details, see [Key vault pricing](https://azure.microsoft.com/pricing/details/key-vault). View security implications when sharing an existing key vault.

1. Select **Next: Configuration**.


## Specify the deployment settings

On the **Configuration** tab, choose whether to create a new configuration for this system or to load deployment settings from a template–either way you are able to review the settings before you deploy:

1. Choose the source of the deployment settings:
   * **New configuration** - Specify all of the settings to deploy this system.
   * **Template spec** - Load the settings to deploy this system from a template spec stored in your Azure subscription.
   * **Quickstart template** - This setting isn't available in this release.

    :::image type="content" source="./media/deploy-via-portal/configuration-tab-1.png" alt-text="Screenshot of the Configuration tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/configuration-tab-1.png":::
1. Select **Next: Networking**.

## Specify network settings

1. For multi-node systems, select whether the cluster is cabled to use a network switch for the storage network traffic:
    * **No switch for storage** - For systems with storage network adapters that connect all the machines directly without going through a switch.
    * **Network switch for storage traffic** - For systems with storage network adapters connected to a network switch. This also applies to systems that use converged network adapters that carry all traffic types including storage.
2. Choose traffic types to group together on a set of network adapters–and which types to keep physically isolated on their own adapters.

    There are three types of traffic we're configuring:
    * **Management** traffic between this system, your management PC, and Azure; also Storage Replica traffic.
    * **Compute** traffic to or from VMs and containers on this system.
    * **Storage** (SMB) traffic between machines in a multi-node system.

    If you selected **No switch** for storage, the following networking patterns are available:

    - Group management and compute traffic
    - Custom configuration

    :::image type="content" source="./media/deploy-via-portal/networking-tab-1.png" alt-text="Screenshot of the No switch option selected on the Configuration tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-1.png":::

    If you selected a **Network switch** for storage, more patterns are available based on how you intend to group the traffic:

    - **Group all traffic** - If you're using network switches for storage traffic you can group all traffic types together on a set of network adapters.
    - **Group management and compute traffic** - This groups management and compute traffic together on one set of adapters while keeping storage traffic isolated on dedicated high-speed adapters. You create two network intents:
        - Management and compute intent.
        - Storage intent.
    - **Group compute and storage traffic** - If you're using network switches for storage traffic, you can group compute and storage traffic together on your high-speed adapters while keeping management traffic isolated on another set of adapters. You create two network intents:
        - Management intent.
        - Compute and storage intent.

    - **Custom configuration** - Finally you can do a custom configuration that lets you group traffic differently, such as carrying each traffic type on its own set of adapters. You also create corresponding custom intents.
    <!--Check w/ Cristian This is commonly used for private multi-access edge compute (MEC) systems.-->

    :::image type="content" source="./media/deploy-via-portal/networking-tab-2.png" alt-text="Screenshot of the networking patterns available for Network switch option select on the Configuration tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-2.png":::

   > [!TIP]
   > If you're deploying a single machine that you plan to add machines to later, select the network traffic groupings you want for the eventual cluster. Then when you add machines they automatically get the appropriate settings.

1. For each network intent (group of traffic types), select at least one unused network adapter (but probably at least two matching adapters for redundancy).

1. Here's an example where we created one Compute and management intent and one storage intent.

    - For *Compute_Management* intent, provide an intent name.
        - In this case, we added two network adapters.
    - For *Storage* intent, provide an intent name.
	    - In this case, we added network adapters, ethernet 3, and ethernet 4.
        - Accept the default VLAN ID, or enter the value that you set on the network switches used for each storage network.

    > [!NOTE]
    > Make sure to use high-speed adapters for the intent that includes storage traffic.

1. For the storage intent, enter the **VLAN ID** set on the network switches used for each storage network.

     > [!IMPORTANT]
     > Portal deployment doesn't allow you to specify your own IPs for the storage intent. However, you can use ARM template deployment if you require to specify the IPs for storage and you can't use the default values from Network ATC. For more information check this page: [Custom IPs for storage intent](../plan/cloud-deployment-network-considerations.md#custom-ips-for-storage)

    :::image type="content" source="./media/deploy-via-portal/networking-tab-3.png" alt-text="Screenshot of the Networking tab with network intents in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-3.png":::

1. To customize network settings for an intent, select **Customize network settings** and provide the following information:

    :::image type="content" source="./media/deploy-via-portal/networking-tab-5.png" alt-text="Screenshot of the Customized network settings on the Networking tab with IP address allocation to systems and services in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-5.png":::

    - **Storage traffic priority** - Specify the Priority Flow Control where Data Center Bridging (DCB) is used.
    - **System traffic priority** - Choose from 5, 6 or 7.
    - **Storage traffic bandwidth reservation** - Define the bandwidth allocation in % for the storage traffic.
    - **Adapter properties** such as **Jumbo frame size** (in bytes), you can select from 1514, 4088, or 9014. For RDMA protocol, choose from iWARP, RoCE, RoCEv2, or you can disable the RDMA protocol.

    > [!NOTE]
    > These settings are only applicable when you create an Azure Local instance using the *medium* hardware class.

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
1. Select an existing Storage account or create a new Storage account to store the cloud witness file.

    When selecting an existing account, the dropdown list filters to display only the storage accounts contained in the specified resource group for deployment. You can use the same storage account with multiple clusters; each witness uses less than a kilobyte of storage.

    :::image type="content" source="./media/deploy-via-portal/management-tab-2.png" alt-text="Screenshot of the Management tab with storage account for cluster witness for deployment via Azure portal." lightbox="./media/deploy-via-portal/management-tab-2.png":::

1. Enter the Active Directory **Domain** where you're deploying this system. This must be the same fully qualified domain name (FQDN) used when the Active Directory Domain Services (AD DS) domain was prepared for deployment.

1. Enter the **OU** created for this deployment. The OU can't be at the top level of the domain.
   For example: `OU=Local001,DC=contoso,DC=com`.

1. Enter the **Deployment account** credentials.

    This domain user account was created when the domain was prepared for deployment.
1. Enter the **Local administrator** credentials for the machines.

    The credentials must be identical on all machines in the system.  If the current password doesn't meet the complexity requirements (12+ characters long, a lowercase and uppercase character, a numeral, and a special character), you must change it on all machines before proceeding.

    :::image type="content" source="./media/deploy-via-portal/management-tab-1.png" alt-text="Screenshot of the Management tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/management-tab-1.png":::

1. Select **Next: Security**.

## Set the security level

1. Select the security level for your system's infrastructure:
    * **Recommended security settings** - Sets the highest security settings.
    * **Customized security settings** - Lets you turn off security settings.

    :::image type="content" source="./media/deploy-via-portal/security-tab-1.png" alt-text="Screenshot of the Security tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/security-tab-1.png":::

2. Select **Next: Advanced**.

## Optionally change advanced settings and apply tags

1. Choose whether to create volumes for workloads now, saving time creating volumes, and storage paths for VM images. You can create more volumes later.
    * **Create workload volumes and required infrastructure volumes (Recommended)** - Creates one thinly provisioned volume and storage path per machine for workloads to use. This is in addition to the required one infrastructure volume per cluster.
    * **Create required infrastructure volumes only** - Creates only the required one infrastructure volume per cluster. You need to create workload volumes and storage paths later.
    * **Use existing data drives** (single machines only) - Preserves existing data drives that contain a Storage Spaces pool and volumes.

        To use this option, you must be using a single machine and have already created a Storage Spaces pool on the data drives. You also might need to later create an infrastructure volume and a workload volume and storage path if you don't already have them.

    :::image type="content" source="./media/deploy-via-portal/advanced-tab-1.png" alt-text="Screenshot of the Advanced tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/advanced-tab-1.png":::
    
    > [!IMPORTANT]
    > Don't delete the infrastructure volumes created during deployment.
    
    Here's a summary of the volumes that are created based on the number of machines in your system. To change the resiliency setting of the workload volumes, delete them and recreate them, being careful not to delete the infrastructure volumes.
    
    
    |# machines  |Volume resiliency  |# Infrastructure volumes  |# Workload volumes  |
    |---------|---------|---------|----------|
    |Single machine    |Two-way mirror         | 1        |  1        |
    |Two machines     | Two-way mirror       | 1        |  2        |
    |Three machines +     | Three-way mirror        |1        |1 per machine         |

1. Select **Next: Tags**.
1. Optionally add a tag to the Azure Local resource in Azure.

    Tags are name/value pairs you can use to categorize resources. You can then view consolidated billing for all resources with a given tag.
1. Select **Next: Validation**. Select **Start validation**. 

    :::image type="content" source="./media/deploy-via-portal/validation-tab-1.png" alt-text="Screenshot of the Start validation selected in Validation tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/validation-tab-1.png":::


1. The validation takes about 15 minutes to deploy one to two machines and longer for bigger deployments. Monitor the validation progress.

    :::image type="content" source="./media/deploy-via-portal/validation-tab-2.png" alt-text="Screenshot of the validation in progress in Validation tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/validation-tab-2.png":::

## Validate and deploy the system

1. After the validation is complete, review the validation results. 

    :::image type="content" source="./media/deploy-via-portal/validation-tab-3.png" alt-text="Screenshot of the successfully completed validation in Validation tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/validation-tab-3.png":::

    If the validation has errors, resolve any actionable issues, and then select **Next: Review + create**.

    Don't select **Try again** while validation tasks are running as doing so can provide inaccurate results in this release.

1. Review the settings that are used for deployment and then select **Create** to deploy the system.

    <!--:::image type="content" source="./media/deploy-via-portal/review-create-tab-1.png" alt-text="Screenshot of the Review + Create tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/review-create-tab-1.png":::-->

The **Deployments** page then appears, which you can use to monitor the deployment progress.

<!-- check with Cristian and Thomas -If the progress doesn't appear, wait for a few minutes and then select **Refresh**. This page may show up as blank for an extended period of time owing to an issue in this release, but the deployment is still running if no errors show up.-->

Once the deployment starts, the first step in the deployment: **Begin cloud deployment** can take 45-60 minutes to complete. The total deployment time for a single machine is around 1.5-2 hours while a two-node system takes about 2.5 hours to deploy.

## Verify a successful deployment

To confirm that the system and all of its Azure resources were successfully deployed
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
    
    \* One storage account is created for the cloud witness and one for key vault audit logs. These accounts are locally redundant storage (LRS) account with a lock placed on them.

## Resume deployment

If your deployment fails, you can resume the deployment. In your Azure Local instance, go to **Deployments** and in the right-pane, select **Resume deployment**.

:::image type="content" source="./media/deploy-via-portal/rerun-deployment.png" alt-text="Screenshot of how to rerun a failed deployment via Azure portal." lightbox="./media/deploy-via-portal/rerun-deployment.png":::

<!--1. In the Azure portal, go the resource group you used for the deployment and then navigate to **Deployments**.
1. In the right-pane, from the top command bar, select **Redeploy**. This action reruns the deployment.

    :::image type="content" source="./media/deploy-via-portal/redeploy-failed-deployment.png" alt-text="Screenshot of how to rerun a failed deployment via Azure portal." lightbox="./media/deploy-via-portal/redeploy-failed-deployment.png":::-->

## Post deployment tasks

After the deployment is complete, you might need to perform some more tasks to secure your system and ensure it's ready for workloads.

### Enable Health monitoring

To monitor storage pool consumption, use the steps in [Enable health alerts](../manage/health-alerts-via-azure-monitor-alerts.md) to receive alerts in Azure portal. An alert is created when the storage pool reaches 70%.

### Enable RDP

For security reasons, Remote Desktop Protocol (RDP) is disabled and the local administrator renamed after the deployment completes on Azure Local instances. For more information on the renamed administrator, go to [Local builtin user accounts](../concepts/security-features.md#local-built-in-user-accounts).

You might need to connect to the system via RDP to deploy workloads. Follow these steps to connect to your system via the Remote PowerShell and then enable RDP:

1. Run PowerShell as administrator on your management PC.
1. Connect to your Azure Local instance via a remote PowerShell session.

    ```powershell
    $ip="<IP address of the Azure Local machine>"
    Enter-PSSession -ComputerName $ip -Credential get-Credential
    ```

1. Enable RDP.

    ```powershell
    Enable-ASRemoteDesktop
    ```

    > [!NOTE]
    > As per the security best practices, keep the RDP access disabled when not needed.

1. Disable RDP.

    ```powershell
    Disable-ASRemoteDesktop
    ```

## Next steps

- If you didn't create workload volumes during deployment, create workload volumes and storage paths for each volume. For details, see [Create volumes on Azure Local and Windows Server clusters](/windows-server/storage/storage-spaces/create-volumes) and [Create storage path for Azure Local](../manage/create-storage-path.md).
- [Get support for Azure Local deployment issues](../manage/get-support-for-deployment-issues.md).
