---
title: Azure Stack Hub known issues 
description: Learn about known issues in Azure Stack Hub releases.
author: sethmanheim

ms.topic: article
ms.date: 10/15/2021
ms.author: sethm
ms.reviewer: unknown
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub user, I want to know about known issues in the latest release so that I can plan my update and be aware of any issues.
# Keyword: Notdone: keyword noun phrase

---


# Azure Stack Hub known issues

This article lists known issues in Azure Stack Hub releases. The list is updated as new issues are identified.

To access known issues for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2008"
> [!IMPORTANT]  
> Review this section before applying the update.
::: moniker-end
::: moniker range="<azs-2008"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support). 
::: moniker-end

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->

::: moniker range="azs-2108"
## Update

### Update to 2108 will not proceed if there are AKS clusters created and the private preview of AKS service is installed

- Applicable: This issue applies to Azure Kubernetes Service (AKS) private preview customers who plan to upgrade to 2108.
- Remediation: The operator must delete all AKS clusters and uninstall the private preview of the AKS service.
- Occurrence: Any stamp that has the AKS private preview installed will experience this message.

For known Azure Stack Hub update issues, see [Troubleshooting Updates in Azure Stack Hub](azure-stack-troubleshooting.md#troubleshoot-azure-stack-hub-updates).

<!-- ## Networking -->

## Compute

### Cannot create a Virtual Machine Scale Set with a data disk attached

- Applicable: This issue applies to release 2108.
- Cause: Missing properties for the object type data disk.
- Remediation: Add data disks after deployment.
- Occurrence: Common

## Portal

### Container Registries

- Applicable: This issue applies to the public preview release of Azure Container Registry on Azure Stack Hub.
- Cause: An issue is preventing metrics from displaying when viewing a container registry in the Azure portal. The metrics are also not available in Shoebox.
- Remediation: No remediation available, will be addressed in an upcoming hotfix.
- Occurrence: Common

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

<!-- ## App Service -->

<!-- ## Usage -->

<!-- ### Identity -->

<!-- ### Marketplace -->

## Event Hubs

[!INCLUDE [event hubs secret rotation related issues](../includes/event-hubs-secret-rotation-related-known-issues.md)]

::: moniker-end

::: moniker range="azs-2102"
## Update

For known Azure Stack Hub update issues, see [Troubleshooting Updates in Azure Stack Hub](azure-stack-troubleshooting.md#troubleshoot-azure-stack-hub-updates).

### Update to 2102 fails during pre-update checks for AKS/ACR

- Applicable: This issue applies to Azure Kubernetes Service (AKS) and Azure Container Registry (ACR) private preview customers who plan to upgrade to 2102 or apply any hotfixes.
- Remediation: Uninstall AKS and ACR prior to updating to 2102, or prior to applying any hotfixes after updating to 2102. Restart the update after uninstalling these services.
- Occurrence: Any stamp that has ACR or AKS installed will experience this failure.

## Portal

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscription types **Metering** and **Consumption** have been disabled and should not be used. If you have resources in them, an alert is generated until those resources are removed.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

## Networking

### Virtual network gateway

#### Documentation links are Azure-specific

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack Hub. Use the following links for the Azure Stack Hub documentation:

  - [Gateway SKUs](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack Hub](../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

### Load balancer

#### IPv6 button visible on "Add frontend IP address"

- Applicable: This issue applies to release 2008 and later.
- Cause: IPv6 button is visible on the **Add frontend IP address** option on a load balancer. These buttons are disabled and cannot be selected.
- Occurrence: Common

#### Backend and frontend ports when floating IP is enabled

- Applicable: This issue applies to all supported releases.
- Cause: Both the frontend port and backend port need to be the same in the load balancing rule when floating IP is enabled. This behavior is by design.
- Occurrence: Common

<!-- ## Compute -->

## Health and alerts

### No alerts in Syslog pipeline

- Applicable: This issue applies to release 2102.
- Cause: The alert module for customers depending on Syslog for alerts has been disabled in this release. For this release, the health and monitoring pipeline was modified to reduce the number of dependencies and services requirements. As a result, the new services will not emit alerts to the Syslog pipeline.
- Remediation: None.
- Occurrence: Common

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

<!-- ## App Service -->

## Usage

### Wrong status on infrastructure backup

- Applicable: This issue applies to release 2102.
- Cause: The infrastructure backup job can display the wrong status (failed or successful) while the status itself is refreshed. This does not impact the consistency of the backup data, but can cause confusion if an actual failure occurred.
- Remediation: The issue will be fixed in the next hotfix for 2102.

<!-- ### Identity -->

<!-- ### Marketplace -->
::: moniker-end

::: moniker range="azs-2008"
## Update

For known Azure Stack Hub update issues, see [Troubleshooting Updates in Azure Stack Hub](azure-stack-troubleshooting.md#troubleshoot-azure-stack-hub-updates).

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

## Networking

### Network Security Groups

#### VM deployment fails due to DenyAllOutbound rule

- Applicable: This issue applies to all supported releases.
- Cause: An explicit **DenyAllOutbound** rule to the internet cannot be created in an NSG during VM creation as this will prevent the communication required for the VM deployment to complete. It will also deny the two essential IPs that are required in order to deploy VMs: DHCP IP:169.254.169.254 and DNS IP: 168.63.129.16.

- Remediation: Allow outbound traffic to the internet during VM creation, and modify the NSG to block the required traffic after VM creation is complete.
- Occurrence: Common

### Virtual Network Gateway

#### Documentation links are Azure-specific

- Applicable: This issue applies to all supported releases.
- Cause: The documentation links in the overview page of Virtual Network gateway link to Azure-specific documentation instead of Azure Stack Hub. Use the following links for the Azure Stack Hub documentation:

  - [Gateway SKUs](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-skus)
  - [Highly Available Connections](../user/azure-stack-vpn-gateway-about-vpn-gateways.md#gateway-availability)
  - [Configure BGP on Azure Stack Hub](../user/azure-stack-vpn-gateway-settings.md#gateway-requirements)
  - [ExpressRoute circuits](azure-stack-connect-expressroute.md)
  - [Specify custom IPsec/IKE policies](../user/azure-stack-vpn-gateway-settings.md#ipsecike-parameters)

### Load Balancer

#### Load Balancer directing traffic to one backend VM in specific scenarios

- Applicable: This issue applies to all supported releases. 
- Cause: When enabling **Session Affinity** on a load balancer, the 2 tuple hash utilizes the PA IP (Physical Address IP) instead of the private IPs assigned to the VMs. In scenarios where traffic directed to the load balancer arrives through a VPN, or if all the client VMs (source IPs) reside on the same node and Session Affinity is enabled, all traffic is directed to one backend VM.
- Occurrence: Common

#### IPv6 button visible on "Add frontend IP address" 

- Applicable: This issue applies to the 2008 release.
- Cause: The IPv6 button is visible and enabled when creating the frontend IP configuration of a public load balancer. This is a cosmetic issue on the portal. IPv6 is not supported on Azure Stack Hub.
- Occurrence: Common

#### Backend port and frontend port need to be the same when floating IP is enabled

- Applicable: This issue applies to all releases. 
- Cause: Both the frontend port and backend port need to be the same in the load balancing rule when floating IP is enabled. This behavior is by design.
- Occurrence: Common

## Compute

### Stop or start VM

#### Stop-Deallocate VM results in MTU configuration removal

- Applicable: This issue applies to all supported releases.
- Cause: Performing **Stop-Deallocate** on a VM results in MTU configuration on the VM to be removed. This behavior is inconsistent with Azure.
- Occurrence: Common



<!-- ## Storage -->
<!-- ## SQL and MySQL-->
<!-- ## App Service -->
<!-- ## Usage -->
<!-- ### Identity -->
<!-- ### Marketplace -->
::: moniker-end

::: moniker range=">=azs-2008"
## Archive

To access archived known issues for an older version, use the version selector dropdown above the table of contents on the left, and select the version you want to see.

## Next steps

- [Review update activity checklist](release-notes-checklist.md)
- [Review list of security updates](release-notes-security-updates.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="azs-2005"
## 2005 archived known issues
::: moniker-end
::: moniker range="azs-2002"
## 2002 archived known issues
::: moniker-end
::: moniker range="azs-1910"
## 1910 archived known issues
::: moniker-end
::: moniker range="azs-1908"
## 1908 archived known issues
::: moniker-end
::: moniker range="azs-1907"
## 1907 archived known issues
::: moniker-end
::: moniker range="azs-1906"
## 1906 archived known issues
::: moniker-end
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

::: moniker range="<azs-2008"
You can access older versions of Azure Stack Hub known issues in the table of contents on the left side, under the [Resources > Release notes archive](./relnotearchive/known-issues.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
