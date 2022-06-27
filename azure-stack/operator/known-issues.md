---
title: Azure Stack Hub known issues 
description: Learn about known issues in Azure Stack Hub releases.
author: sethmanheim

ms.topic: article
ms.date: 06/22/2022
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub user, I want to know about known issues in the latest release so that I can plan my update and be aware of any issues.
# Keyword: Notdone: keyword noun phrase

---


# Azure Stack Hub known issues

This article lists known issues in Azure Stack Hub releases. The list is updated as new issues are identified.

To access known issues for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2102"
> [!IMPORTANT]  
> Review this article before applying the update.
::: moniker-end
::: moniker range="<azs-2102"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support). 
::: moniker-end

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->

::: moniker range="azs-2206"
<!-- ## Update -->

<!-- ## Networking -->

<!-- ## Compute -->

## Alerts

### Region not provided

- Applicable: This issue applies to release 2206.
- Cause: The alert **Geographical region not provided** is displayed, and asks you to make a choice for Schrems II compliance.
- Remediation: You can run the following PowerShell cmdlet to set geographical preference: `Set-DataResidencyLocation -Europe:$true or $false`. The residency location for the data will be updated and all data will be stored and processed in the EU. Close this alert manually, or ignore it after the geographical region preference appears in the admin portal (as described in [EU Schrems II initiative for Azure Stack Hub](azure-stack-security-foundations.md#eu-schrems-ii-initiative-for-azure-stack-hub)). The alert remains active for up to one week, even after the choice is made.
- Occurrence: Common

<!-- ## Portal -->

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

<!-- ## App Service -->

<!-- ## Usage -->

<!-- ### Identity -->

<!-- ### Marketplace -->

<!-- ## Event Hubs -->

::: moniker-end

::: moniker range="azs-2108"
## Update

### Update to 2108 will not proceed if there are AKS clusters or ACR registries created and the private previews of AKS and ACR services are installed

- Applicable: This issue applies to Azure Kubernetes Service (AKS) and Azure Container Registry (ACR) private preview customers who plan to upgrade to 2108.
- Remediation: The operator must delete all AKS clusters and ACR Registries and uninstall the private preview of the AKS and ACR services.
- Occurrence: Any stamp that has the AKS and ACR private previews installed will experience this message.

For known Azure Stack Hub update issues, see [Troubleshooting Updates in Azure Stack Hub](azure-stack-troubleshooting.md#troubleshoot-azure-stack-hub-updates).

## Networking

### Load Balancer

#### Load Balancer rules

- Applicable: This issue applies to all supported releases.
- Cause: Updating/changing the load distribution property (session persistence) has no effect and some virtual machines might not participate in the traffic load distribution. For example, if you have 4 backend virtual machines and only 2 clients connecting to the load balancer, and the load distribution is set to client IP, the client sessions will always use the same backend virtual machines. Changing the load distribution property to "none" to distribute the client connections across all the backend virtual machines will have no effect.
- Remediation: Recreating the load balancing rule will ensure the selected settings are correctly configured to all backend VMs.
- Occurrence: Common

<!-- ## Compute -->

### Cannot create a Virtual Machine Scale Set with a data disk attached

- Applicable: This issue applies to release 2108.
- Cause: Missing properties for the object type data disk.
- Remediation: Add data disks after deployment.
- Occurrence: Common

### Create disk snapshot can fail

- Applicable: This issue applies to release 2108.
- Cause: Missing properties for snapshot operation.
- Remediation: Apply hotfix 1.2108.2.73.
- Occurrence: Common

## Portal

### Container registries

#### Metrics unavailable for container registries in the user portal

- Applicable: This issue applies to the public preview release of Azure Container Registry on Azure Stack Hub.
- Cause: An issue is preventing metrics from displaying when viewing a container registry in the Azure portal. The metrics are also not available in Shoebox.
- Remediation: No remediation available, will be addressed in an upcoming hotfix.
- Occurrence: Common

#### Container Registry operator experience prompting to install although installation already complete

- Applicable: This issue applies to the public preview release of Azure Container Registry on Azure Stack Hub.
- Cause: Seven days following the installation of Container Registry, the operator experience in the admin portal may prompt the operator to install Container Registry again. The service is operating normally but the operator experience is not available. Tenants are able to create and manage container registries.
- Remediation: No remediation available, will be addressed in an upcoming hotfix.
- Occurrence: Common

### Administrative subscriptions

- Applicable: This issue applies to all supported releases.
- Cause: The two administrative subscriptions that were introduced with version 1804 should not be used. The subscription types are Metering, and Consumption.
- Remediation: If you have resources running on these two subscriptions, recreate them in user subscriptions.
- Occurrence: Common

### Create DNS blade results in portal crashing

- Applicable: This issue applies to all supported releases with hotfix version 1.2108.2.81.
- Cause: Two specific flows sometimes end with the user portal crashing:
  - **Create a resource > Networking > DNS zone**
  - **Create a resource > Networking > Connection**
- Remediation: The following workflow can ensure there are no crashes:
  - **All services > DNS zone > + Add** or **All services > Connections > + Add**
- Occurrence: Common

### Portal shows "Unidentified User" instead of user email

- Applicable: This issue applies to all systems with hotfix version 1.2108.2.81 that are using an Azure AD account without an email address in the account profile.
- Remediation: Sign in to the Azure portal, and add an email address to the Azure AD account that is experiencing this issue.
- Occurrence: Common

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

<!-- ## App Service -->

<!-- ## Usage -->

<!-- ### Identity -->

<!-- ### Marketplace -->

<!-- ## Event Hubs -->

[!INCLUDE [event hubs secret rotation related issues](../includes/event-hubs-secret-rotation-related-known-issues.md)]

## Azure Kubernetes Service (AKS)

[!INCLUDE [Applications deployed to AKS clusters fail to access persistent volumes](../includes/known-issue-aks-1.md)]

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

#### Load Balancer rules

- Applicable: This issue applies to all supported releases.
- Cause: Updating/changing the load distribution property (session persistence) has no effect and some virtual machines might not participate in the traffic load distribution. For example, if you have 4 backend virtual machines and only 2 clients connecting to the load balancer, and the load distribution is set to client IP, the client sessions will always use the same backend virtual machines. Changing the load distribution property to "none" to distribute the client connections across all the backend virtual machines will have no effect.
- Remediation: Recreating the load balancing rule will ensure the selected settings are correctly configured to all backend VMs.
- Occurrence: Common

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

[!INCLUDE [resource providers fail in test-azurestack](../includes/known-issue-alerts-aks-acs.md)]

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

::: moniker range=">=azs-2102"
## Archive

To access archived known issues for an older version, use the version selector dropdown above the table of contents on the left, and select the version you want to see.

## Next steps

- [Review update activity checklist](release-notes-checklist.md)
- [Review list of security updates](release-notes-security-updates.md)
::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="azs-2008"
## 2008 archived known issues
::: moniker-end
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

::: moniker range="<azs-2102"
You can access older versions of Azure Stack Hub known issues in the table of contents on the left side, under the [Resources > Release notes archive](./relnotearchive/known-issues.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
