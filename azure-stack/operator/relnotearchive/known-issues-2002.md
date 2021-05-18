---
title: Azure Stack Hub 2002 known issues 
description: Learn about known issues in Azure Stack Hub 2002.
author: sethmanheim

ms.topic: article
ms.date: 02/04/2021
ms.author: sethm
ms.reviewer: sranthar
ms.lastreviewed: 09/09/2020
ROBOTS: NOINDEX

---
# Azure Stack Hub 2002 known issues

This article lists known issues in Azure Stack Hub releases. The list is updated as new issues are identified.

> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](../azure-stack-servicing-policy.md#keep-your-system-under-support).

## Update

After applying the 2002 update, an alert for an "Invalid Time Source" may incorrectly appear in the Administrator portal. This false-positive alert can be ignored and will be fixed in an upcoming release. 

For known Azure Stack Hub update issues, see [Troubleshooting Updates in Azure Stack Hub](../azure-stack-troubleshooting.md#troubleshoot-azure-stack-hub-updates).

### Update failed to install package Microsoft.AzureStack.Compute.Installer to CA VM

- Applicable: This issue applies to all supported releases.
- Cause: During update, a process takes a lock on the new content that needs to be copied to CA VM. When the update fails, the lock is released.
- Remediation: Resume the update.
- Occurrence: Rare

## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are **Metering** subscription, and **Consumption** subscription.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

### Subscription permissions

- Applicable: This issue applies to all supported releases.
- Cause: You cannot view permissions to your subscription using the Azure Stack Hub portals.
- Remediation: Use [PowerShell to verify permissions](/powershell/module/azurerm.resources/get-azurermroleassignment).
- Occurrence: Common

### Storage account options

- Applicable: This issue applies to all supported releases.
- Cause: In the user portal, the name of storage accounts is shown as **Storage account - blob, file, table, queue**; however, **file** is not supported in Azure Stack Hub.
- Occurrence: Common

### Create Managed Disk snapshot

- Applicable: This issue applies to release 2002.
- Cause: In the user portal, when creating a Managed Disk snapshot, the **Account type** box is empty. When you select the **Create** button with an empty account type, the snapshot creation fails.
- Remediation: Select an account type from the **Account type** dropdown list, then create the snapshot.
- Occurrence: Common

### Alert for network interface disconnected

- Applicable: This issue applies to 1908 and later.
- Cause: When a cable is disconnected from a network adapter, an alert does not show in the administrator portal. This issue is caused because this fault is disabled by default in Windows Server 2019.
- Occurrence: Common

## Networking

### DenyAllOutbound rule cannot be created

- Applicable: This issue applies to all supported releases.
- Cause: An explicit **DenyAllOutbound** rule to the internet cannot be created in an NSG during VM creation as this will prevent the communication required for the VM deployment to complete.
- Remediation: Allow outbound traffic to the internet during VM creation, and modify the NSG to block the required traffic after VM creation is complete.
- Occurrence: Common

### ICMP protocol not supported for NSG rules

- Applicable: This issue applies to all supported releases. 
- Cause: When creating an inbound or an outbound network security rule, the **Protocol** option shows an **ICMP** option. This is currently not supported on Azure Stack Hub. This issue is fixed and will not appear in the next Azure Stack Hub release.
- Occurrence: Common

### Cannot delete an NSG if NICs not attached to running VM

- Applicable: This issue applies to all supported releases.
- Cause: When disassociating an NSG and a NIC that is not attached to a running VM, the update (PUT) operation for that object fails at the network controller layer. The NSG will be updated at the network resource provider layer, but not on the network controller, so the NSG moves to a failed state.
- Remediation: Attach the NICs associated to the NSG that needs to be removed with running VMs, and disassociate the NSG or remove all the NICs that were associated with the NSG.
- Occurrence: Common

### Load Balancer directing traffic to one backend VM in specific scenarios 

- Applicable: This issue applies to all supported releases. 
- Cause: When enabling **Session Affinity** on a load balancer, the 2 tuple hash utilizes the PA IP (Physical Address IP) instead of the private IPs assigned to the VMs. In scenarios where traffic directed to the load balancer arrives through a VPN, or if all the client VMs (source IPs) reside on the same node and Session Affinity is enabled, all traffic is directed to one backend VM.
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

### Public IP

- Applicable: This issue applies to all supported releases.
- Cause: The **IdleTimeoutInMinutes** value for a public IP that is associated to a load balancer cannot be changed. The operation puts the public IP into a failed state.
- Remediation: To bring the public IP back into a successful state, change the **IdleTimeoutInMinutes** value on the load balancer rule that references the public IP back to the original value (the default value is 4 minutes).
- Occurrence: Common

### Virtual Network Gateway

#### Documentation

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack Hub. Use the following links for the Azure Stack Hub documentation:

  - [Gateway SKUs](../../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack Hub](../../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](../azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

## Compute

### Cannot create a virtual machine scale set with Standard_DS2_v2 VM size on portal

- Applicable: This issue applies to the 2002 release.
- Cause: There is a portal bug that prevents virtual machine scale set creation with the Standard_DS2_v2 VM size. Creating one will error out with: "{"code":"DeploymentFailed","message":"At least one resource deployment operation failed. Please list deployment operations for details. Please see https://aka.ms/arm-debug for usage details.","details":[{"code":"BadRequest","message":"{\r\n \"error\": {\r\n \"code\": \"NetworkProfileValidationError\",\r\n \"message\": \"Virtual Machine size Standard_DS2_v2 is not in the allowed list of VM sizes for accelerated networking to be enabled on the VM at index 0 for virtual machine scale set /subscriptions/x/resourceGroups/RGVMSS/providers/Microsoft.Compute/virtualMachineScaleSets/vmss. Allowed sizes: .\"\r\n }\r\n}"}]}"
- Remediation: Create a virtual machine scale set with PowerShell or a Resource Manager template.

### VM overview blade does not show correct computer name

- Applicable: This issue applies to all releases.
- Cause: When viewing details of a VM in the overview blade, the computer name shows as **(not available)**. This is by design for VMs created from specialized disks/disk snapshots, and appears for Marketplace images as well.
- Remediation: View the **Properties** blade under **Settings**.

### NVv4 VM size on portal

- Applicable: This issue applies to release 2002 and later.
- Cause: When going through the VM creation experience, you will see the VM size: NV4as_v4. Customers who have the hardware required for the AMD MI25-based Azure Stack Hub GPU preview are able to have a successful VM deployment. All other customers will have a failed VM deployment with this VM size.
- Remediation: By design in preparation for the Azure Stack Hub GPU preview.

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new virtual machine (VM), the following error might be displayed: **Failed to start virtual machine 'vm-name'. Error: Failed to update serial output settings for VM 'vm-name'**. The error occurs if you enable boot diagnostics on a VM, but delete your boot diagnostics storage account.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### VM boot diagnostics

- Applicable: This issue applies to all supported releases.
- Cause: When trying to start a stop-deallocated virtual machine,the following error might be displayed: **VM diagnostics Storage account 'diagnosticstorageaccount' not found. Ensure storage account is not deleted**. The error occurs if you attempt to start a VM with boot diagnostics enabled, but the referenced boot diagnostics storage account is deleted.
- Remediation: Recreate the storage account with the same name you used previously.
- Occurrence: Common

### Consumed compute quota

- Applicable: This issue applies to all supported releases.
- Cause: When creating a new virtual machine, you may receive an error such as **This subscription is at capacity for Total Regional vCPUs on this location. This subscription is using all 50 Total Regional vCPUs available.**. This indicates that the quota for total cores available to you has been reached.
- Remediation: Ask your operator for an add-on plan with additional quota. Editing the current plan's quota will not work or reflect increased quota.
- Occurrence: Rare

### Virtual machine scale set

#### Create failures during patch and update on 4-node Azure Stack Hub environments

- Applicable: This issue applies to all supported releases.
- Cause: Creating VMs in an availability set of 3 fault domains and creating a virtual machine scale set instance fails with a **FabricVmPlacementErrorUnsupportedFaultDomainSize** error during the update process on a 4-node Azure Stack Hub environment.
- Remediation: You can create single VMs in an availability set with 2 fault domains successfully. However, scale set instance creation is still not available during the update process on a 4-node Azure Stack Hub deployment.

### SQL VM

#### Storage account creating failure when configuring Auto Backup

- Applicable: This issue applies to 2002.
- Cause: When configuring the automated backup of SQL VMs with a new storage account, it fails with the error **Deployment template validation failed. The template parameter for 'SqlAutobackupStorageAccountKind' is not found.**
- Remediation: Apply the latest 2002 hotfix.

#### Auto backup cannot be configured with TLS 1.2 enabled

- Applicable: This issue applies to new installations of 2002 and later, or any previous release with TLS 1.2 enabled.
- Cause: When configuring the automated backup of SQL VMs with an existing storage account, it fails with the error **SQL Server IaaS Agent: The underlying connection was closed: An unexpected error occurred on a send.**
- Occurrence: Common

## Storage

### Retention period revert to 0

- Applicable: This issue applies to release 2002 and 2005.
- Cause: If you previously specified a time period other than 0 in retention period setting, it would be reverted back to 0 (the default value of this setting) during 2002 and 2005 update. And the 0 days setting would take effect immediately after update finished, which causes all the existing deleted storage accounts and any upcoming newly deleted storage account being immediately out of retention and marked for periodic garbage collection (which runs hourly). 
- Remediation: Manually specify the retention period to a proper period. However, any storage account already been garbage collected before the new retention period is specified is not recoverable.  

## Resource providers

### SQL/MySQL

- Applicable: This issue applies to release 2002. 
- Cause: If the stamp contains SQL resource provider (RP) version 1.1.33.0 or earlier, upon update of the stamp, the blades for SQL/MySQL will not load.
- Remediation: Update the RP to version 1.1.47.0

### App Service

- Applicable: This issue applies to release 2002.
- Cause: If the stamp contains App Service resource provider (RP) version 1.7 and older, upon update of the stamp, the blades for App Service do not load.
- Remediation: Update the RP to version [2020 Q2](../azure-stack-app-service-update.md).

## PowerShell

[!Include[Known issue for install - one](../../includes/known-issue-az-install-1.md)]

[!Include[Known issue for install - two](../../includes/known-issue-az-install-2.md)]
