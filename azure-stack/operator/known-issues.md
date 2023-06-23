---
title: Azure Stack Hub known issues 
description: Learn about known issues in Azure Stack Hub releases.
author: sethmanheim
ms.topic: article
ms.date: 05/19/2023
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub user, I want to know about known issues in the latest release so that I can plan my update and be aware of any issues.
# Keyword: Notdone: keyword noun phrase

---


# Azure Stack Hub known issues

This article lists known issues in Azure Stack Hub releases. The list is updated as new issues are identified.

To access known issues for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2108"
> [!IMPORTANT]  
> Review this article before applying the update.
::: moniker-end
::: moniker range="<azs-2108"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support). 
::: moniker-end

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->

::: moniker range="azs-2301"
<!-- ## Update -->

<!-- ## Networking -->

<!-- ## Compute -->

<!-- ## Alerts -->

## Portal

### Incorrect reporting of node CPU cores in the admin portal

- Applicable: This issue applies to release 2301.
- Cause: The number of cores reported in the Azure Stack Hub admin portal in the cluster **Nodes Capacity** window is incorrect. This is cosmetic and an issue with a change in 2301 with respect to how the Fabric Resource Provider gets this information. This impacts both new deployments and existing stamps updating to 2301, but doesn't affect operation of the stamp or any workload deployments.
- Remediation: Microsoft is aware of the problem and is working on a fix.
- Occurrence: Minor portal issue that occurs consistently.

<!-- ## Datacenter integration -->

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

<!-- ## App Service -->

<!-- ## Usage -->

<!-- ### Identity -->

<!-- ### Marketplace -->

<!-- ## Event Hubs -->

::: moniker-end

::: moniker range="azs-2206"
<!-- ## Update -->

<!-- ## Networking -->

<!-- ## Compute -->

## Alerts

### Geographical region not provided

- Applicable: This issue applies to release 2206.
- Cause: The alert **Geographical region not provided** is displayed, and asks you to make a choice for Schrems II compliance.
- Remediation: You can run the following PowerShell cmdlet to set geographical preference: 

   ```powershell
   Set-DataResidencyLocation -Europe:$true or $false 
   ```

   The residency location for the data will be updated and all data will be stored and processed in the EU. Close this alert manually, or ignore it after the geographical region preference appears in the admin portal (as described in [EU Schrems II initiative for Azure Stack Hub](azure-stack-security-foundations.md#eu-schrems-ii-initiative-for-azure-stack-hub)). The alert remains active for up to one week, even after the choice is made.
- Occurrence: Common

### Encryption recovery keys retrieval warning

- Applicable: This issue applies to release 2206 and later.
- Cause: An **Encryption recovery keys retrieval** warning is displayed, and asks you to retrieve and securely store the encryption recovery keys outside of Azure Stack Hub. The warning occurs to ensure that you have retrieved the recovery keys. If you have previously retrieved the recovery keys and are getting this alert after the 2206 update (or beyond), please make sure to collect the recovery keys again. Recovery keys may be required in the case where host nodes display the BitLocker recovery key screen after unplanned reboots; for example, power outages.
- Remediation: Retrieve the encryption keys and store them in a secure location outside of Azure Stack Hub. From the PEP, run the following command, and save the recovery keys that are returned:

   ```powershell
   ## Retrieves recovery keys for all volumes that are encrypted with BitLocker
   Get-AzsRecoveryKeys -raw
   ```

   For more information, see [Retrieving BitLocker recovery keys](azure-stack-security-bitlocker.md#retrieving-bitlocker-recovery-keys). Note that the alert will automatically close within 24 hours after running **Get-AzsRecoveryKeys** and storing those recovery keys in a secure location outside of Azure Stack Hub.
- Occurrence: Common

## Portal

### Possibility of portal errors during update

- Applicable: This issue applies to release 2206.
- Cause: The update blade and/or the portal dashboard can become unusable and show an error during the update itself.
- Remediation: If the portal is unavailable for more than 1 hour, you can use the PEP to check the status of the update. For more information, see [Monitor updates in Azure Stack Hub using the privileged endpoint](/azure-stack/operator/azure-stack-monitor-update).

### Public IP and Load Balancer blades display a banner that recommends upgrading from Basic to Standard SKU

- Applicable: This issue applies to release 2108 and newer.
- Cause: The Azure portal recommends the upgrade from Basic to Standard SKU; however, this functionality is not supported in Azure Stack Hub.
- Remediation: Don't attempt the upgrade, as it will fail.
- Occurrence: Common

### Menu items not displayed when clicking on disk instance on VM overview blade

- Applicable: This issue applies to releases 2102 and newer.
- Cause: Menu items are not displayed when clicking on disk instance on the Virtual Machines overview blade.
- Remediation: Refresh the page and the menu should reappear. Alternatively, you can navigate to the specific disk instance via the **Disks** area in the portal.
- Occurrence: Minor portal issue that occurs consistently.

## Datacenter integration

### Graph configuration fails

- Applicable: This issue applies to release 2206.
- Cause: The configuration of Graph fails with an invalid credential error.
- Remediation: If credentials are correct, you must supply them as username only, rather than domainname\username.
- Occurrence: Common

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

### Public IP and Load Balancer blades display a banner that recommends upgrading from Basic to Standard SKU

- Applicable: This issue applies to release 2108 and newer.
- Cause: The Azure portal recommends the upgrade from Basic to Standard SKU; however, this functionality is not supported in Azure Stack Hub.
- Remediation: Don't attempt the upgrade, as it will fail.
- Occurrence: Common

### Menu items not displayed when clicking on disk instance on VM overview blade

- Applicable: This issue applies to releases 2102 and newer.
- Cause: Menu items are not displayed when clicking on disk instance on the Virtual Machines overview blade.
- Remediation: Refresh the page and the menu should reappear. Alternatively, you can navigate to the specific disk instance via the **Disks** area in the portal.
- Occurrence: Minor portal issue that occurs consistently.

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

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="azs-2102"
## 2102 archived known issues
::: moniker-end
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

::: moniker range="<azs-2108"
You can access older versions of Azure Stack Hub known issues in the table of contents on the left side, under the [Resources > Release notes archive](./relnotearchive/known-issues.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
