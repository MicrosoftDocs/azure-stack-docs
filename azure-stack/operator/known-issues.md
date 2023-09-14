---
title: Azure Stack Hub known issues 
description: Learn about known issues in Azure Stack Hub releases.
author: sethmanheim
ms.topic: article
ms.date: 09/14/2023
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 09/09/2020

# Intent: As an Azure Stack Hub user, I want to know about known issues in the latest release so that I can plan my update and be aware of any issues.
# Keyword: Notdone: keyword noun phrase

---


# Azure Stack Hub known issues

This article lists known issues in Azure Stack Hub releases. The list is updated as new issues are identified.

To access known issues for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2206"
> [!IMPORTANT]  
> Review this article before applying the update.
::: moniker-end
::: moniker range="<azs-2206"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support). 
::: moniker-end

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->

::: moniker range="azs-2306"
<!-- ## Update -->

<!-- ## Networking -->

<!-- ## Compute -->

<!-- ## Alerts -->

<!-- ## Portal -->

<!-- ## Datacenter integration -->

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

<!-- ## App Service -->

<!-- ## Usage -->

<!-- ### Identity -->

<!-- ### Marketplace -->

<!-- ## Event Hubs -->

::: moniker-end

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

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="azs-2108"
## 2108 archived known issues
::: moniker-end
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

::: moniker range="<azs-2206"
You can access older versions of Azure Stack Hub known issues in the table of contents on the left side, under the [Resources > Release notes archive](./relnotearchive/known-issues.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
