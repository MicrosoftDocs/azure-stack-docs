---
title: Azure Stack known issues 
description: Learn about known issues in Azure Stack releases.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 11/21/2019
ms.author: sethm
ms.reviewer: prchint
ms.lastreviewed: 11/21/2019
---

# Azure Stack known issues

This article lists known issues in releases of Azure Stack. The list is updated as new issues are identified.

To access known issues for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-1906"
> [!IMPORTANT]  
> Review this section before applying the update.
::: moniker-end
::: moniker range="<azs-1906"
> [!IMPORTANT]  
> If your Azure Stack instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support). 
::: moniker-end

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->

::: moniker range="azs-1910"
## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

### Subscriptions Lock blade

- Applicable: This issue applies to all supported releases.
- Cause: In the administrator portal, the **Lock** blade for user subscriptions has two buttons that say **Subscription**.
- Occurrence: Common

### Subscription permissions

- Applicable: This issue applies to all supported releases.
- Cause: You cannot view permissions to your subscription using the Azure Stack portals.
- Remediation: Use [PowerShell to verify permissions](/powershell/module/azurerm.resources/get-azurermroleassignment).
- Occurrence: Common

### Storage account settings

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the storage account **Configuration** blade shows an option to change **security transfer type**. The feature is currently not supported in Azure Stack.
- Occurrence: Common

### Upload blob with OAuth error

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the **OAuth(preview)** option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

### Upload blob option unsupported

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob in the upload blade, there is an option to select **AAD** or **Key Authentication**, however **AAD** is not supported in Azure Stack.
- Occurrence: Common

### Load balancer backend pool

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when adding a **Load balancer** backend pool, the operation results in an error message of **Failed to save load balancer backend pool**; however, the operation did actually succeed.
- Occurrence: Common

### Incorrect tooltip when creating VM

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you select a managed disk, with disk type Premium SSD, the drop-down list shows **OS Disk**. The tooltip next to that option says **Certain OS Disk sizes may be available for free with Azure Free Account**; however, this is not valid for Azure Stack. In addition, the list includes **Free account eligible** which is also not valid for Azure Stack.
- Occurrence: Common

### VPN troubleshoot and metrics

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **VPN Troubleshoot** feature and **Metrics** in a VPN gateway resource appears, however this is not supported in Azure Stack.
- Occurrence: Common

### Adding extension to VM Scale Set

- Applicable: This issue applies to releases 1907 and greater.
- Cause: In the user portal, once a virtual machine scale set is created, the UI does not permit the user to add an extension.
- Occurrence: Common

### Delete a storage container

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when a user attempts to delete a storage container, the operation fails when the user does not toggle **Override Azure Policy and RBAC Role settings**.
- Remediation: Ensure that the box is checked for **Override Azure Policy and RBAC Role settings**.
- Occurrence: Common

### Refresh button on Virtual Machines fails

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you navigate to Virtual Machines and try to refresh using the button at the top, the states fail to update accurately. 
- Remediation: The status is automatically updated every 5 minutes regardless of whether the refresh button has been clicked or not. Wait 5 minutes and check the status.
- Occurrence: Common

### Virtual Network Gateway 

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you create a Route Table, **Virtual Network gateway** appears as one of the next hop type options; however this is not supported in Azure Stack.
- Occurrence: Common

### Storage account options

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the name of storage accounts is shown as **Storage account - blob, file, table, queue**, however **file** is not supported by Azure Stack.
- Occurrence: Common

### Storage Account Configuration

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you create a storage account and view its **Configuration**, you cannot save configuration changes, as it results in an AJAX error. 
- Occurrence: Common

### Capacity monitoring in SQL resource provider keeps loading

- Applicable: This issue applies to Azure Stack 1910 update or newer versions with SQL resource provider version 1.1.33.0 or previous versions installed.
- Cause: The current versions of the SQL resource provider is not compatible with some of the latest portal changes in the 1910 update.
- Remediation: Follow the resource provider update process to apply the SQL resource provider hotfix 1.1.47.0 after Azure Stack being upgraded to 1910 update ([SQL RP version 1.1.47.0](https://aka.ms/azurestacksqlrp11470)). For MySQL resource provider, it is also recommended to apply the MySQL resource provider hotfix 1.1.47.0 after Azure Stack being upgraded to 1910 update ([MySQL RP version 1.1.47.0](https://aka.ms/azurestackmysqlrp11470)).
- Occurrence: Common

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
- Cause: In the user portal, the **Virtual Network** blade shows an option to use **Service Endpoints**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

### Network interface

#### Adding/Removing network interface

- Applicable: This issue applies to all supported releases.
- Cause: A new network interface cannot be added to a VM that is in a **running** state.
- Remediation: Stop the virtual machine before adding/removing a network interface.
- Occurrence: Common

#### Primary network interface

- Applicable: This issue applies to all supported releases.
- Cause: The primary NIC of a VM cannot be changed. Deleting/detaching the primary NIC results in issues when starting up the VM.
- Occurrence: Common

### Virtual Network Gateway

#### Alerts

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network Gateway** blade shows an option to use **Alerts**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### Active-Active

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, while creating, and in the resource menu of **Virtual Network Gateway**, you will see an option to enable **Active-Active** configuration. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### VPN troubleshooter

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Connections** blade shows a feature called **VPN Troubleshooter**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### Documentation

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack. Use the following links for the Azure Stack documentation:

  - [Gateway SKUs](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack](../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

## Compute

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new Windows virtual machine (VM), the following error may be displayed: **Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'**. The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### Consumed compute quota

- Applicable: This issue applies to all supported releases.
- When creating a new virtual machine, you may receive an error such as **This subscription is at capacity for Total Regional vCPUs on this location. This subscription is using all 50 Total Regional vCPUs available.**. This indicates that the quota for total cores available to you has been reached.
- Remediation: Ask your operator to add an add-on plan with additional quota. Editing the current plan's quota will not work or reflect increased quota.
- Occurrence: Rare

### Virtual machine scale set

#### Create failures during patch and update on 4-node Azure Stack environments

- Applicable: This issue applies to all supported releases.
- Cause: Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack environment.
- Remediation: You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack deployment.

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases.
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled does not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

<!-- ## Storage -->
<!-- ## SQL and MySQL-->
<!-- ## App Service -->
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->
::: moniker-end

::: moniker range="azs-1908"
## 1908 update process

- Applicable: This issue applies to all supported releases.
- Cause: When attempting to install the Azure Stack update, the status for the update might fail and change state to **PreparationFailed**. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing.
- Remediation: Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update now** again (not **Resume**). The URP then cleans up the files from the previous attempt, and restarts the download. If the problem persists, we recommend manually uploading the update package by following the [Install updates section](azure-stack-apply-updates.md#install-updates-and-monitor-progress).
- Occurrence: Common

## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

### Subscriptions Properties blade

- Applicable: This issue applies to all supported releases.
- Cause: In the administrator portal, the **Properties** blade for subscriptions does not load correctly
- Remediation: You can view these subscription properties in the **Essentials** pane of the **Subscriptions Overview** blade.
- Occurrence: Common

### Subscriptions Lock blade

- Applicable: This issue applies to all supported releases.
- Cause: In the administrator portal, the **Lock** blade for user subscriptions has two buttons labeled **subscription**.
- Occurrence: Common

### Subscription permissions

- Applicable: This issue applies to all supported releases.
- Cause: You cannot view permissions to your subscription using the Azure Stack portals.
- Remediation: Use [PowerShell to verify permissions](/powershell/module/azurerm.resources/get-azurermroleassignment).
- Occurrence: Common

### Storage account settings

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the storage account **Configuration** blade shows an option to change **security transfer type**. The feature is currently not supported in Azure Stack.
- Occurrence: Common

### Upload blob

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the **OAuth(preview)** option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

## Networking

### Load Balancer

- Applicable: This issue applies to all supported releases. 
- Cause: When adding Avaiability Set VMs to the backend pool of a Load Balancer, an error message is being displayed on the portal stating **Failed to save load balancer backend pool**. This is a cosmetic issue on the portal, the functionality is still in place and VMs are successfully added to the backend pool interally. 
- Occurrence: Common

### Network Security Groups

- Applicable: This issue applies to all supported releases. 
- Cause: An explicit **DenyAllOutbound** rule cannot be created in an NSG as this will prevent all internal communication to infrastructure needed for the VM deployment to complete.
- Occurrence: Common

### Service endpoints

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network** blade shows an option to use **Service Endpoints**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

### Network interface

#### Adding/Removing Network Interface

- Applicable: This issue applies to all supported releases.
- Cause: A new network interface cannot be added to a VM that is in a **running** state.
- Remediation: Stop the virtual machine before adding/removing a network interface.
- Occurrence: Common

#### Primary Network Interface

- Applicable: This issue applies to all supported releases.
- Cause: A new network interface cannot be added to a VM that is in a **running** state.
- Remediation: Stop the virtual machine before adding/removing a network interface.
- Occurrence: Common

### Virtual Network Gateway

#### Alerts

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network Gateway** blade shows an option to use **Alerts**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### Active-Active

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, while creating, and in the resource menu of **Virtual Network Gateway**, you will see an option to enable **Active-Active** configuration. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### VPN troubleshooter

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Connections** blade shows a feature called **VPN Troubleshooter**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### Documentation

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack. Use the following links for the Azure Stack documentation:

  - [Gateway SKUs](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack](../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

## Compute

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new Windows virtual machine (VM), the following error may be displayed:
**Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'**. The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### Virtual machine scale set

#### Create failures during patch and update on 4-node Azure Stack environments

- Applicable: This issue applies to all supported releases.
- Cause: Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack environment.
- Remediation: You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack.

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases.
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled does not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

### Virtual machine scale set reset password does not work

- Applicable: This issue applies to all supported releases.
- Cause: A new reset password blade appears in the scale set UI, but Azure Stack does not support resetting password on a scale set yet.
- Remediation: None.
- Occurrence: Common

### Rainy cloud on scale set diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: The virtual machine scale set overview page shows an empty chart. Clicking on the empty chart opens a "rainy cloud" blade. This is the chart for scale set diagnostic information, such as CPU percentage, and is not a feature supported in the current Azure Stack build.
- Remediation: None.
- Occurrence: Common

### Virtual machine diagnostic settings blade

- Applicable: This issue applies to all supported releases.    
- Cause: The virtual machine diagnostic settings blade has a **Sink** tab, which asks for an **Application Insight Account**. This is the result of a new blade and is not yet supported in Azure Stack.
- Remediation: None.
- Occurrence: Common

<!-- ## Storage -->
<!-- ## SQL and MySQL-->
<!-- ## App Service -->
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->
::: moniker-end

::: moniker range="azs-1907"
## 1907 update process

- Applicable: This issue applies to all supported releases.
- Cause: When attempting to install the 1907 Azure Stack update, the status for the update might fail and change state to **PreparationFailed**. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing.
- Remediation: Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update now** again (not **Resume**). The URP then cleans up the files from the previous attempt, and restarts the download. If the problem persists, we recommend manually uploading the update package by following the [Import and install updates section](azure-stack-apply-updates.md).
- Occurrence: Common

## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

### Subscriptions Properties blade

- Applicable: This issue applies to all supported releases.
- Cause: In the administrator portal, the **Properties** blade for subscriptions does not load correctly
- Remediation: You can view these subscription properties in the **Essentials** pane of the **Subscriptions Overview** blade.
- Occurrence: Common

### Subscription permissions

- Applicable: This issue applies to all supported releases.
- Cause: You cannot view permissions to your subscription using the Azure Stack portals.
- Remediation: Use [PowerShell to verify permissions](/powershell/module/azurerm.resources/get-azurermroleassignment).
- Occurrence: Common

### Storage account settings

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the storage account **Configuration** blade shows an option to change **security transfer type**. The feature is currently not supported in Azure Stack.
- Occurrence: Common

### Upload blob

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the **OAuth(preview)** option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

## Networking

### Load Balancer

- Applicable: This issue applies to all supported releases. 
- Cause: When adding Avaiability Set VMs to the backend pool of a Load Balancer, an error message is being displayed on the portal stating **Failed to save load balancer backend pool**. This is a cosmetic issue on the portal, the functionality is still in place and VMs are successfully added to the backend pool interally. 
- Occurrence: Common

### Network Security Groups

- Applicable: This issue applies to all supported releases. 
- Cause: An explicit **DenyAllOutbound** rule cannot be created in an NSG as this will prevent all internal communication to infrastructure needed for the VM deployment to complete.
- Occurrence: Common

### Service endpoints

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network** blade shows an option to use **Service Endpoints**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

### Network interface

#### Adding/Removing Network Interface

- Applicable: This issue applies to all supported releases.
- Cause: A new network interface cannot be added to a VM that is in a **running** state.
- Remediation: Stop the virtual machine before adding/removing a network interface.
- Occurrence: Common

#### Primary Network Interface

- Applicable: This issue applies to all supported releases.
- Cause: A new network interface cannot be added to a VM that is in a **running** state.
- Remediation: Stop the virtual machine before adding/removing a network interface.
- Occurrence: Common

### Virtual Network Gateway

#### Alerts

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network Gateway** blade shows an option to use **Alerts**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### Active-Active

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, while creating, and in the resource menu of **Virtual Network Gateway**, you will see an option to enable **Active-Active** configuration. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### VPN troubleshooter

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Connections** blade shows a feature called **VPN Troubleshooter**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

### Network Connection Type

- Applicable: This issue applies to any 1906 or 1907 environment. 
- Cause: In the user portal, the **AddConnection** blade shows an option to use **VNet-to-VNet**. This feature is currently not supported in Azure Stack. 
- Occurrence: Common 

#### Documentation

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack. Use the following links for the Azure Stack documentation:

  - [Gateway SKUs](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack](../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

## Compute

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new Windows virtual machine (VM), the following error may be displayed:
**Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'**. The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### Virtual machine scale set

#### Create failures during patch and update on 4-node Azure Stack environments

- Applicable: This issue applies to all supported releases.
- Cause: Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack environment.
- Remediation: You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack.

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases.
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled does not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

### Virtual machine scale set reset password does not work

- Applicable: This issue applies to the 1906 and 1907 releases.
- Cause: A new reset password blade appears in the scale set UI, but Azure Stack does not support resetting password on a scale set yet.
- Remediation: None.
- Occurrence: Common

### Rainy cloud on scale set diagnostics

- Applicable: This issue applies to the 1906 and 1907 releases.
- Cause: The virtual machine scale set overview page shows an empty chart. Clicking on the empty chart opens a "rainy cloud" blade. This is the chart for scale set diagnostic information, such as CPU percentage, and is not a feature supported in the current Azure Stack build.
- Remediation: None.
- Occurrence: Common

### Virtual machine diagnostic settings blade

- Applicable: This issue applies to the 1906 and 1907 releases.    
- Cause: The virtual machine diagnostic settings blade has a **Sink** tab, which asks for an **Application Insight Account**. This is the result of a new blade and is not yet supported in Azure Stack.
- Remediation: None.
- Occurrence: Common

<!-- ## Storage -->
<!-- ## SQL and MySQL-->
<!-- ## App Service -->
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->
::: moniker-end

::: moniker range="azs-1906"
## 1906 update process

- Applicable: This issue applies to all supported releases.
- Cause: When attempting to install the 1906 Azure Stack update, the status for the update might fail and change state to **PreparationFailed**. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing. 
- Remediation: Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update now** again (not **Resume**). The URP then cleans up the files from the previous attempt, and restarts the download. If the problem persists, we recommend manually uploading the update package by following the [Import and install updates section](azure-stack-apply-updates.md).
- Occurrence: Common

## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

### Subscription resources

- Applicable: This issue applies to all supported releases.
- Cause: Deleting user subscriptions results in orphaned resources.
- Remediation: First delete user resources or the entire resource group, and then delete the user subscriptions.
- Occurrence: Common

### Subscription permissions

- Applicable: This issue applies to all supported releases.
- Cause: You cannot view permissions to your subscription using the Azure Stack portals.
- Remediation: Use [PowerShell to verify permissions](/powershell/module/azurerm.resources/get-azurermroleassignment).
- Occurrence: Common

### Subscriptions Properties blade
- Applicable: This issue applies to all supported releases.
- Cause: In the administrator portal, the **Properties** blade for Subscriptions does not load correctly
- Remediation: You can view these subscriptions properties in the Essentials pane of the Subscriptions Overview blade
- Occurrence: Common

### Storage account settings

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the storage account **Configuration** blade shows an option to change **security transfer type**. The feature is currently not supported in Azure Stack.
- Occurrence: Common

### Upload blob

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, when you try to upload a blob using the **OAuth(preview)** option, the task fails with an error message.
- Remediation: Upload the blob using the SAS option.
- Occurrence: Common

### Update

- Applicable: This issue applies to the 1906 release.
- Cause: In the operator portal, update status for the hotfix shows an incorrect state for the update. Initial state indicates that the update failed to install, even though it is still in progress.
- Remediation: Refresh the portal and the state will update to "in progress."
- Occurrence: Intermittent

## Networking

### Service endpoints

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network** blade shows an option to use **Service Endpoints**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

### Network interface

- Applicable: This issue applies to all supported releases.
- Cause: A new network interface cannot be added to a VM that is in a **running** state.
- Remediation: Stop the virtual machine before adding/removing a network interface.
- Occurrence: Common

### Virtual Network Gateway

#### Alerts

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Virtual Network Gateway** blade shows an option to use **Alerts**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### Active-Active

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, while creating, and in the resource menu of **Virtual Network Gateway**, you will see an option to enable **Active-Active** configuration. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### VPN troubleshooter

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the **Connections** blade shows a feature called **VPN Troubleshooter**. This feature is currently not supported in Azure Stack.
- Occurrence: Common

#### Documentation

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack. Please use the following links for the Azure Stack documentation:

  - [Gateway SKUs](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack](../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

### Load balancer

#### Add backend pool

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, if you attempt to add a **Backend Pool** to a **Load Balancer**, the operation fails with the error message **failed to update Load Balancer...**.
- Remediation: Use PowerShell, CLI or a Resource Manager template to associate the backend pool with a load balancer resource.
- Occurrence: Common

#### Create inbound NAT

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, if you attempt to create an **Inbound NAT Rule** for a **Load Balancer**, the operation fails with the error message **Failed to update Load Balancer...**.
- Remediation: Use PowerShell, CLI or a Resource Manager template to associate the backend pool with a load balancer resource.
- Occurrence: Common

## Compute

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new Windows virtual machine (VM), the following error may be displayed:
**Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'**. The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### Virtual machine scale set


#### Create failures during patch and update on 4-node Azure Stack environments

- Applicable: This issue applies to all supported releases.
- Cause: Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack environment.
- Remediation: You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack.

### Ubuntu SSH access

- Applicable: This issue applies to all supported releases.
- Cause: An Ubuntu 18.04 VM created with SSH authorization enabled does not allow you to use the SSH keys to sign in.
- Remediation: Use VM access for the Linux extension to implement SSH keys after provisioning, or use password-based authentication.
- Occurrence: Common

### Virtual machine scale set reset password does not work

- Applicable: This issue applies to the 1906 release.
- Cause: A new reset password blade appears in the scale set UI, but Azure Stack does not support resetting password on a scale set yet.
- Remediation: None.
- Occurrence: Common

### Rainy cloud on scale set diagnostics

- Applicable: This issue applies to the 1906 release.
- Cause: The virtual machine scale set overview page shows an empty chart. Clicking on the empty chart opens a "rainy cloud" blade. This is the chart for scale set diagnostic information, such as CPU percentage, and is not a feature supported in the current Azure Stack build.
- Remediation: None.
- Occurrence: Common

### Virtual machine diagnostic settings blade

- Applicable: This issue applies to the 1906 release.
- Cause: The virtual machine diagnostic settings blade has a **Sink** tab, which asks for an **Application Insight Account**. This is the result of a new blade and is not yet supported in Azure Stack.
- Remediation: None.
- Occurrence: Common

<!-- ## Storage -->
<!-- ## SQL and MySQL-->
<!-- ## App Service -->
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->
::: moniker-end

::: moniker range=">=azs-1906"
## Archive

To access archived known issues for an older version, use the version selector dropdown above the table of contents on the left, and select the version you want to see.

## Next steps

- [Review update activity checklist](release-notes-checklist.md)
- [Review list of security updates](release-notes-security-updates.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="azs-1905"
## 1905 archived known issues
::: moniker-end
::: moniker range="azs-1904"
## 1904 archived known issues
::: moniker-end
::: moniker range="azs-1903"
## 1903 archived known issues
::: moniker-end
::: moniker range="azs-1902"
## 1902 archived known issues
::: moniker-end
::: moniker range="azs-1901"
## 1901 archived known issues
::: moniker-end
::: moniker range="azs-1811"
## 1811 archived known issues
::: moniker-end
::: moniker range="azs-1809"
## 1809 archived known issues
::: moniker-end
::: moniker range="azs-1808"
## 1808 archived known issues
::: moniker-end
::: moniker range="azs-1807"
## 1807 archived known issues
::: moniker-end
::: moniker range="azs-1805"
## 1805 archived known issues
::: moniker-end
::: moniker range="azs-1804"
## 1804 archived known issues
::: moniker-end
::: moniker range="azs-1803"
## 1803 archived known issues
::: moniker-end
::: moniker range="azs-1802"
## 1802 archived known issues
::: moniker-end

::: moniker range="<azs-1906"
You can access [older versions of Azure Stack known issues on the TechNet Gallery](https://aka.ms/azsarchivedrelnotes). These archived documents are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack support, see [Azure Stack servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
