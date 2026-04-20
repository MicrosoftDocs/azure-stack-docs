---
title: Deploy Azure Local Using the Azure Portal for Disaggregated Deployments
description: Learn how to deploy an Azure Local instance from the Azure portal for disaggregated deployments.
author: alkohli
ms.topic: how-to
ms.date: 03/31/2026
ms.author: alkohli
ms.service: azure-local
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
#CustomerIntent: As an IT Pro, I want to deploy an Azure Local instance of 1-16 machines via the Azure portal so that I can host VM and container-based workloads on it.
---

# Deploy Azure Local using the Azure portal for disaggregated deployments

This article helps you deploy a disaggregated Azure Local instance using the Azure portal.

## Prerequisites

- Completion of [Register your machines with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md).
<!-- Cristian to confirm * For three-node systems, the network adapters that carry the in-cluster storage traffic must be connected to a network switch. Deploying three-node systems with storage network adapters that are directly connected to each machine without a switch isn't supported in this preview.-->

::: moniker range="<=azloc-24113"

- To deploy Azure Local 2411.3 and earlier, use the alternative version of the [Azure portal](https://aka.ms/dfc-2411deploycluster). Use this version only for deployment. Don't use this version for any other purpose.

::: moniker-end

## Start the wizard and fill out the basics

1. Go to the Azure portal. Search for and select **Azure Local**. On the **Azure Arc | Azure Local** page, go to the **Get started** tab. On the **Deploy Azure Local** tile, select **Create instance**.

      :::image type="content" source="./media/deploy-via-portal/get-started-1.png" alt-text="Screenshot of the Get started tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/get-started-1.png":::

1. Select the **Subscription** and **Resource group** in which to store this system's resources.

   All resources in the Azure subscription are billed together.

1. Enter the **Instance name** to use for this Azure Local instance.

1. Select the **Region** to store this system's Azure resources. For a list of supported Azure regions, [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements).

   We don't transfer much data so it's OK if the region isn't close.

1. Select **Cluster options**. Choose the **Standard** or **Rack aware** cluster option for this Azure Local instance. **For disaggregated deployments, you cannot select the Rack aware cluster option.**

    For more information about the Rack aware option, see [Azure Local rack aware clustering overview](../concepts/rack-aware-cluster-overview.md).
   
1. Select **Storage options**. Choose the **Storage Spaces Direct (S2D)** or **Storage Area Network (SAN)** storage option for this Azure Local instance. For disaggregated deployments, select the Storage Area Network option.

1. Select the **Identity provider** for this Azure Local instance.

    For more information about the Local identity with Azure Key Vault option, see [Deploy Azure Local using local identity](../deploy/deployment-local-identity-with-key-vault.md).

1. Select **+ Add machines** and choose the machine or machines that make up this Azure Local instance.

   > [!IMPORTANT]
   > Machines must not be joined to Active Directory before deployment.
   
   ![Screenshot 2026-04-14 151738](media/deploy-via-portal-disaggregated/screenshot-2026-04-14-151738.png)
   
   On the **Add machines** page:
   1. The operating system for your Azure Local machines is automatically selected as Azure Stack HCI.
   1. Select one or more machines that make up this Azure Local instance. These machines could show as **Ready** or as **Not validated**.
   1. Select **Add**. The machines show up on the **Basics** tab.
      
   :::image type="content" source="./media/deploy-via-portal/basics-tab-2.png" alt-text="Screenshot of Add machines through the Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-2.png":::
   
1. **Install extensions**. Arc extensions are automatically installed on the selected machines after they're added. This process may take several minutes. To check the installation status, refresh the page.

   ![Screenshot 2026-04-14 152216](media/deploy-via-portal-disaggregated/screenshot-2026-04-14-152216.png)
   
   
    After the extensions are installed successfully, the status of the machine updates to **Ready**.  
   Note, if extension installations fail, you can select failed machines and retry the installation.
   
1. Select **Validate selected machines**. Wait for the green validation check to indicate the validation is successful. The validation process checks that each machine is running the same exact version of the OS, has the correct Azure extensions, and has matching (symmetrical) network adapters.

   ![Screenshot 2026-04-14 152525](media/deploy-via-portal-disaggregated/screenshot-2026-04-14-152525.png)  
   If the validation fails with wrong extension version, go to **Install extensions** to install the appropriate version of extension.
   
1. **Select an existing Key Vault** or select **Create a new Key Vault**. Create an empty Key Vault to securely store secrets for this system, such as cryptographic keys, local admin credentials, and BitLocker recovery keys.

    > [!IMPORTANT]
    > Azure Local doesn't support deploying a cluster using an existing Azure Key Vault that has Private Endpoints enabled.

1. Create a new Key Vault (optional). You can use an existing Key Vault and skip this step.

      :::image type="content" source="./media/deploy-via-portal/basics-tab-6.png" alt-text="Screenshot of Create a new Key Vault on Basics tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/basics-tab-6.png":::

   	On the **Create a new Key Vault** page, provide information for the specified parameters:
1. Accept the suggested name or provide a name for the Key Vault you create.
    1. Accept the default number of Days to retain deleted vaults or specify a value between 7 and 90 days. You can’t change the retention period later. The Key Vault creation takes several minutes.
    1. If you don’t have permissions to the resource group, you see a message that you have insufficient permissions for the Key Vault. Select **Grant Key Vault permissions**.
	1. Select **Create**.
     

   ![Screenshot 2026-04-14 153006](media/deploy-via-portal-disaggregated/screenshot-2026-04-14-153006.png)  
   The Key Vault adds cost in addition to the Azure Local subscription. For details, see [Key Vault pricing](https://azure.microsoft.com/pricing/details/key-vault). View security implications when sharing an existing Key Vault.
   
1. Select **Next: Configuration**.

## Specify the deployment settings

On the **Configuration** tab, choose whether to create a new configuration for this system or to load deployment settings from a template–either way you're able to review the settings before you deploy:

1. Choose the source of the deployment settings:
   * **New configuration** - Specify all of the settings to deploy this system.
   * **Template spec** - Load the settings to deploy this system from a template spec stored in your Azure subscription.
   * **Quickstart template** - This setting isn't available in this release.

    :::image type="content" source="./media/deploy-via-portal/configuration-tab-1.png" alt-text="Screenshot of the Configuration tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/configuration-tab-1.png":::
1. Select **Next: Networking**.

## Specify network settings

1. Choose the only storage configuration option available for a disaggregated cluster as **SAN based storage**. 

1. Choose traffic types to group together on a set of network adapters–and which types to keep physically isolated on their own adapters.

    There are two types of traffic we configure:
   
   - **Management** traffic between this system, your management PC, and Azure.
   - **Compute** traffic to or from VMs and containers on this system.
      
   The following networking patterns are available:
   
   - Group management and compute traffic
   - Separate management and compute traffic
      
   ![Screenshot 2026-04-14 163448](media/deploy-via-portal-disaggregated/screenshot-2026-04-14-163448.png)
   
   
   
1. For each network intent (group of traffic types), select at least one unused network adapter (but probably at least two matching adapters for redundancy).

1. Here's an example where we created one Compute and management intent.

   - For *Compute_Management* intent, provide an intent name.
      - In this case, we added two network adapters.
1. For each cluster network, specify the cluster network name, network adapter, VLAN ID, and subnet.

   ![Screenshot 2026-04-14 172057](media/deploy-via-portal-disaggregated/screenshot-2026-04-14-172057.png)
   
   
   
1. To customize network settings for an intent, select **Customize network settings** and provide the following information:

   :::image type="content" source="./media/deploy-via-portal/networking-tab-5.png" alt-text="Screenshot of the Customized network settings on the Networking tab with IP address allocation to systems and services in deployment via Azure portal." lightbox="./media/deploy-via-portal/networking-tab-5.png":::
   
   - **Storage traffic priority** - Specify the Priority Flow Control where Data Center Bridging (DCB) is used.
   - **System traffic priority** - Choose from 5, 6 or 7.
   - **Storage traffic bandwidth reservation** - Define the bandwidth allocation in % for the storage traffic.
   - **Adapter properties** such as **Jumbo frame size** (in bytes), you can select from 1514, 4088, or 9014. The RDMA protocol is disabled for cluster networks.
      
1. Choose the IP allocation as **Manual** or **Automatic**. Use **Automatic** if you use a DHCP server for IP assignments in your network.

1. If you picked static IP, provide the following values:
   1. Using the **Starting IP** and **Ending IP** (and related) fields, allocate a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.
   
       These IPs are used by Azure Local to create an infrastructure logical network. The Azure Arc resource bridge, a component of Azure Local VM management, uses this infrastructure logical network.
   1. Provide the Subnet mask, Default gateway, and one or more DNS servers.
   1. Validate subnet.
      
      
      
   ![Screenshot 2026-04-14 172135](media/deploy-via-portal-disaggregated/screenshot-2026-04-14-172135.png)
   
   
   
1. Select **Next: Management**.

## Specify management settings

1. Optionally edit the suggested **Custom location name** that helps users identify this system when creating resources such as VMs on it.
1. To store the cloud witness file, select an existing Storage account or create a new Storage account.

    When selecting an existing account, the dropdown list filters to display only the storage accounts contained in the specified resource group for deployment. You can use the same storage account with multiple clusters; each witness uses less than a kilobyte of storage.

    :::image type="content" source="./media/deploy-via-portal/management-tab-2.png" alt-text="Screenshot of the Management tab with storage account for cluster witness for deployment via Azure portal." lightbox="./media/deploy-via-portal/management-tab-2.png":::

1. Enter the Active Directory **Domain** where you're deploying this system. This must be the same fully qualified domain name (FQDN) used when the Active Directory Domain Services (AD DS) domain was prepared for deployment.

1. Enter the **OU** created for this deployment. The OU can't be at the top level of the domain.
   For example: `OU=Local001,DC=contoso,DC=com`.

1. Enter the **Deployment account** credentials.

    This domain user account was created when the domain was prepared for deployment.
1. Enter the **Local administrator** credentials for the machines.

    The credentials must be identical on all machines in the system.  If the current password doesn't meet the complexity requirements (14+ characters long, a lowercase and uppercase character, a numeral, and a special character), you must change it on all machines before proceeding.

    :::image type="content" source="./media/deploy-via-portal/management-tab-1.png" alt-text="Screenshot of the Management tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/management-tab-1.png":::

1. Select **Next: Security**.

## Set the security level

1. Select the security level for your system's infrastructure:
    * **Recommended security settings** - Sets the highest security settings.
    * **Customized security settings** - Lets you turn off security settings.

    :::image type="content" source="./media/deploy-via-portal/security-tab-1.png" alt-text="Screenshot of the Security tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/security-tab-1.png":::

2. Select **Next: Advanced**.

## Optionally change advanced settings and apply tags

1. Select the only option available for disaggregated deployments, which is for selecting two LUNs that are used for infrastructure and cluster performance history volumes. Workload LUNs will be configured post deployment.   
The infrastructure LUN selection field only shows volumes with a minimum size of 250GB, and the cluster performance history volume requires at least 20GB.  

    
   
   ![Screenshot 2026-04-14 165343](media/deploy-via-portal-disaggregated/screenshot-2026-04-14-165343.png)
   
   > [!IMPORTANT]
   > - Don't delete the infrastructure volumes created during deployment.
   
   
1. Optionally add a tag to the Azure Local resource in Azure.

    Tags are name/value pairs you can use to categorize resources. You can then view consolidated billing for all resources with a given tag.
1. Select **Next: Validation**. Select **Start validation**. 

    :::image type="content" source="./media/deploy-via-portal/validation-tab-1.png" alt-text="Screenshot of the Start validation selected in Validation tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/validation-tab-1.png":::


1. The validation takes about 20 minutes to deploy one to two machines and longer for bigger deployments. Monitor the validation progress.

    :::image type="content" source="./media/deploy-via-portal/validation-tab-2.png" alt-text="Screenshot of the validation in progress in Validation tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/validation-tab-2.png":::

## Validate and deploy the system

1. After the validation is complete, review the validation results.

    :::image type="content" source="./media/deploy-via-portal/validation-tab-3.png" alt-text="Screenshot of the successfully completed validation in Validation tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/validation-tab-3.png":::

    If the validation has errors, resolve any actionable issues, and then select **Next: Review + create**.

    Don't select **Try again** while validation tasks are running as doing so can provide inaccurate results in this release.

1. Review the settings that are used for deployment and then select **Create** to deploy the system.

    <!--:::image type="content" source="./media/deploy-via-portal/review-create-tab-1.png" alt-text="Screenshot of the Review + Create tab in deployment via Azure portal." lightbox="./media/deploy-via-portal/review-create-tab-1.png":::-->

    The **Deployments** page appears, where you can monitor the deployment progress.

### Deployment notes

- **Authentication changes.** During deployment, the system performs several steps, including cluster registration. In earlier versions of software, during this process, Azure Local created and set up a Microsoft Entra ID application (service principal) along with a self-signed certificate to authenticate the cluster in Azure.

    Starting with software version 12.2512, new deployments no longer create an Entra ID application. Instead, the cluster uses system-assigned managed identity for authentication with Azure.
  
    For existing deployments, the Entra ID application is also no longer used for authentication. The cluster automatically switches to system-assigned managed identity for authentication without requiring any manual intervention. Because the app is no longer used, you can delete it from the Entra ID portal.
  
    To delete the app, make sure that the registration context is updated to v4 and there's a corresponding event in the Azure Local event log.
  
    To verify the event, connect to one of the machines on the Azure Local instance and run the following PowerShell command:
  
  ```powershell
  Get-ClusterNode | % { Get-WinEvent -ComputerName $_ -LogName Microsoft-AzureStack-HCI/Admin | ? Id -eq 609 }
  ```
    
## Verify a successful deployment

To confirm that the system and all of its Azure resources were successfully deployed
1. In the Azure portal, navigate to the resource group into which you deployed the system.
2. On the **Overview** > **Resources**, you should see the following:

    |Number of resources  | Resource type  |
    |---------|---------|
    | 1 per machine | Machine - Azure Arc |
    | 1            | Azure Local     |
    | 1            | Arc Resource Bridge |
    | 1            | Infrastructure logical network named as *(clustername-InfraLNET)* |
    | 1            | Key Vault           |
    | 1            | Custom location     |
    | 2*           | Storage account     |
    | 1 per workload volume | Azure Local storage path - Azure Arc |
    
    \* One storage account is created for the cloud witness and one for Key Vault audit logs. These accounts are locally redundant storage (LRS) account with a lock placed on them.

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
