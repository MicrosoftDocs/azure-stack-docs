---
title: 1910 Azure Stack Hub known issues 
description: Learn about known issues in Azure Stack Hub 1910.
author: sethmanheim

ms.topic: article
ms.date: 11/16/2020
ms.author: sethm
ms.reviewer: sranthar
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub user, I want to know about known issues in the latest release so that I can plan my update and be aware of any issues.
# Keyword: Notdone: keyword noun phrase

---
# Azure Stack Hub known issues

This article lists known issues in Azure Stack Hub releases. The list is updated as new issues are identified.

> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](../azure-stack-servicing-policy.md#keep-your-system-under-support).

## Update

For known Azure Stack Hub update issues, see [Troubleshooting Updates in Azure Stack Hub](../azure-stack-troubleshooting.md#troubleshoot-azure-stack-hub-updates).

## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

### Duplicate Subscription button in Lock blade

- Applicable: This issue applies to all supported releases.
- Cause: In the administrator portal, the **Lock** blade for user subscriptions has two buttons that say **Subscription**.
- Occurrence: Common

### Subscription permissions

- Applicable: This issue applies to all supported releases.
- Cause: You cannot view permissions to your subscription using the Azure Stack Hub portals.
- Remediation: Use [PowerShell to verify permissions](/powershell/module/azurerm.resources/get-azurermroleassignment).
- Occurrence: Common

### Storage account settings

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the storage account **Configuration** blade shows an option to change **security transfer type**. The feature is currently not supported in Azure Stack Hub.
- Occurrence: Common

### Upload blob with OAuth error

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the **OAuth(preview)** option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

### Upload blob option unsupported

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob in the upload blade, there is an option to select **AAD** or **Key Authentication**, however **AAD** is not supported in Azure Stack Hub.
- Occurrence: Common

### Alert for network interface disconnected

- Applicable: This issue applies to 1908 and above.
- Cause: When a cable is disconnected from a network adapter, an alert does not show in the administrator portal. This issue is caused because this fault is disabled by default in Windows Server 2019.
- Occurrence: Common

### Incorrect tooltip when creating VM

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you select a managed disk, with disk type Premium SSD, the drop-down list shows **OS Disk**. The tooltip next to that option says **Certain OS Disk sizes may be available for free with Azure Free Account**; however, this is not valid for Azure Stack Hub. In addition, the list includes **Free account eligible** which is also not valid for Azure Stack Hub.
- Occurrence: Common

### Delete a storage container

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when a user attempts to delete a storage container, the operation fails when the user does not toggle **Override Azure Policy and RBAC Role settings**.
- Remediation: Ensure that the box is checked for **Override Azure Policy and RBAC Role settings**.
- Occurrence: Common

### Refresh button on virtual machines fails

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you navigate to **Virtual Machines** and try to refresh using the button at the top, the states fail to update accurately.
- Remediation: The status is automatically updated every 5 minutes regardless of whether the refresh button has been clicked or not. Wait 5 minutes and check the status.
- Occurrence: Common

### Storage account options

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the name of storage accounts is shown as **Storage account - blob, file, table, queue**; however, **file** is not supported in Azure Stack Hub.
- Occurrence: Common

### Storage account configuration

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you create a storage account and view its **Configuration**, you cannot save configuration changes, as it results in an AJAX error.
- Occurrence: Common

### Capacity monitoring in SQL resource provider keeps loading

- Applicable: This issue applies to the Azure Stack Hub 1910 update or later, with SQL resource provider version 1.1.33.0 or earlier installed.
- Cause: The current version of the SQL resource provider is not compatible with some of the latest portal changes in the 1910 update.
- Remediation: Follow the resource provider update process to apply the SQL resource provider hotfix 1.1.47.0 after Azure Stack Hub is upgraded to the 1910 update ([SQL RP version 1.1.47.0](https://aka.ms/azurestacksqlrp11470)). For the MySQL resource provider, it is also recommended that you apply the MySQL resource provider hotfix 1.1.47.0 after Azure Stack Hub is upgraded to 1910 update ([MySQL RP version 1.1.47.0](https://aka.ms/azurestackmysqlrp11470)).
- Occurrence: Common

### Access Control (IAM)

- Applicable: This issue applies to all supported releases.
- Cause: The IAM extension is out of date. The Ibiza portal that shipped with Azure Stack Hub introduces a new behavior that causes the RBAC extension to fail if the user is opening the **Access Control (IAM)** blade for a subscription that is not selected in the global subscription selector (**Directory + Subscription** in the user portal). The blade displays **Loading** in a loop, and the user cannot add new roles to the subscription. The **Add** blade also displays **Loading** in a loop.
- Remediation: Ensure that the subscription is checked in the **Directory + Subscription** menu. The menu can be accessed from the top of the portal, near the **Notifications** button, or via the shortcut on the **All resources** blade that displays **Don't see a subscription? Open Directory + Subscription settings**. The subscription must be selected in this menu.

### SQL resource provider

- Applicable: This issue applies to stamps that are running 1908 or earlier.
- Cause: When deploying the SQL resource provider (RP) version 1.1.47.0, the portal shows no assets other than those associated with the SQL RP.
- Remediation: Delete the RP, upgrade the stamp, and re-deploy the SQL RP.

### Activity log blade

- Applicable: This issue applies to stamps that are running 1907 or later. <!-- Note: Applies to 2002 as well -->
- Cause: When accessing the activity log, the portal only shows the first page of entries. **Load more results** will not load addition entries.
- Remediation: Adjust the time range in the filter to review entries that fall after the first page.

## Networking

### Load balancer

- Applicable: This issue applies to all supported releases.
- Cause: When adding availability set VMs to the backend pool of a load balancer, an error message is displayed on the portal stating **Failed to save load balancer backend pool**. This is a cosmetic issue on the portal; the functionality is still in place and VMs are successfully added to the backend pool internally.
- Occurrence: Common

### Network Security Groups

- Applicable: This issue applies to all supported releases. 
- Cause: An explicit **DenyAllOutbound** rule cannot be created in an NSG as this will prevent all internal communication to infrastructure needed for the VM deployment to complete.
- Occurrence: Common

### Service endpoints

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network** blade shows an option to use **Service Endpoints**. This feature is currently not supported in Azure Stack Hub.
- Occurrence: Common

### Cannot delete an NSG if NICs not attached to running VM

- Applicable: This issue applies to all supported releases.
- Cause: When disassociating an NSG and a NIC that is not attached to a running VM, the update (PUT) operation for that object fails at the network controller layer. The NSG will be updated at the network resource provider layer, but not on the network controller, so the NSG moves to a failed state.
- Remediation: Attach the NICs associated to the NSG that needs to be removed with running VMs, and disassociate the NSG or remove all the NICs that were associated with the NSG.
- Occurrence: Common

### Network interface

#### Adding/removing network interface

- Applicable: This issue applies to all supported releases.
- Cause: A new network interface cannot be added to a VM that is in a **running** state.
- Remediation: Stop the virtual machine before adding or removing a network interface.
- Occurrence: Common

#### Primary network interface

- Applicable: This issue applies to all supported releases.
- Cause: The primary NIC of a VM cannot be changed. Deleting or detaching the primary NIC results in issues when starting up the VM.
- Occurrence: Common

### Virtual Network Gateway

#### Next Hop Type

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you create a route table, **Virtual Network gateway** appears as one of the next hop type options; however, this is not supported in Azure Stack Hub.
- Occurrence: Common

#### Alerts

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network Gateway** blade shows an option to use **Alerts**. This feature is currently not supported in Azure Stack Hub.
- Occurrence: Common

#### Active-Active

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, while creating, and in the resource menu of **Virtual Network Gateway**, you will see an option to enable **Active-Active** configuration. This feature is currently not supported in Azure Stack Hub.
- Occurrence: Common

#### VPN troubleshooter

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Connections** blade displays a feature called **VPN Troubleshooter**. This feature is currently not supported in Azure Stack Hub.
- Occurrence: Common

#### VPN troubleshooter

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **VPN Troubleshoot** feature and **Metrics** in a VPN gateway resource appears, however this is not supported in Azure Stack Hub.
- Occurrence: Common

#### Documentation

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack Hub. Use the following links for the Azure Stack Hub documentation:

  - [Gateway SKUs](../../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack Hub](../../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](../azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

## Compute

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new Windows virtual machine (VM), the following error might be displayed: **Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'**. The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### Consumed compute quota

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new virtual machine, you may receive an error such as **This subscription is at capacity for Total Regional vCPUs on this location. This subscription is using all 50 Total Regional vCPUs available.**. This indicates that the quota for total cores available to you has been reached.
- Remediation: Ask your operator for an add-on plan with additional quota. Editing the current plan's quota will not work or reflect increased quota.
- Occurrence: Rare

### Privileged Endpoint

- Applicable: This issue applies to 1910 and earlier releases.
- Cause: Unable to connect to the Privileged Endpoint (ERC VMs) from a computer running a non-English version of Windows.
- Remediation: This is a known issue that has been fixed in releases later than 1910. As a workaround you can run the **New-PSSession** and **Enter-PSSession** PowerShell cmdlets using the **en-US** culture; for examples, set the culture using this script: https://resources.oreilly.com/examples/9780596528492/blob/master/Use-Culture.ps1.
- Occurrence: Rare

### Virtual machine scale set

#### Create failures during patch and update on 4-node Azure Stack Hub environments

- Applicable: This issue applies to all supported releases.
- Cause: Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack Hub environment.
- Remediation: You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack Hub deployment.
