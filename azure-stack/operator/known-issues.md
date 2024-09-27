---
title: Azure Stack Hub known issues 
description: Learn about known issues in Azure Stack Hub releases.
author: sethmanheim
ms.topic: article
ms.date: 09/03/2024
ms.author: sethm
ms.reviewer: rtiberiu
ms.lastreviewed: 11/30/2023

# Intent: As an Azure Stack Hub user, I want to know about known issues in the latest release so that I can plan my update and be aware of any issues.
# Keyword: Notdone: keyword noun phrase

---


# Azure Stack Hub known issues

This article lists known issues in Azure Stack Hub releases. The list is updated as new issues are identified.

To access known issues for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2306"
> [!IMPORTANT]  
> Review this article before applying the update.
::: moniker-end
::: moniker range="<azs-2306"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support). 
::: moniker-end

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->

::: moniker range="azs-2406"
<!-- ## Update -->

<!-- ## Networking -->

## Compute

### Azure Kubernetes Service on Azure Stack Hub

- Applicable: This issue applies to release 2311 and later.
- Cause: Azure Kubernetes Service on Azure Stack Hub, currently in preview, is being discontinued and will not be released to general availability. If you try to register a new subscription to the **Microsoft.Containerservice** resource provider, the registration stays in the **Registering** state. If you try to create a new managed Kubernetes cluster or access existing managed Kubernetes clusters, you might see the raining cloud error screen.
- Remediation: Microsoft is aware of the problem and is working on a fix.
- Occurrence: Common.

### Standard Load Balancer portal error

- Applicable: This issue applies to release 2406 and later.
- Cause: The Standard Load Balancer portal blades for **Logs** and **Diagnostic settings** both show errors displaying the content.
- Remediation: The Standard Load Balancer in Azure Stack Hub does not support any diagnostic features.
- Occurrence: Common.

<!-- ## Alerts -->

<!-- ## Portal -->

<!-- ## Datacenter integration -->

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

<!-- ## App Service -->

<!-- ## Resource providers -->

<!-- ## Usage -->

<!-- ### Identity -->

<!-- ### Marketplace -->

<!-- ## Event Hubs -->

::: moniker-end

::: moniker range="azs-2311"
<!-- ## Update -->

<!-- ## Networking -->

## Compute

### Azure Kubernetes Service on Azure Stack Hub

- Applicable: This issue applies to release 2311 and later.
- Cause: Azure Kubernetes Service on Azure Stack Hub, currently in preview, is being discontinued and will not be released to general availability. If you try to register a new subscription to the **Microsoft.Containerservice** resource provider, the registration stays in the **Registering** state. If you try to create a new managed Kubernetes cluster or access existing managed Kubernetes clusters, you might see the raining cloud error screen.
- Remediation: Microsoft is aware of the problem and is working on a fix.
- Occurrence: Common.

### Shutdown using Start-AzsCryptoWipe does not work

- Applicable: This issue applies to release 2311.
- Cause: In some cases when you run the `Start-AzsCryptoWipe` [command to shut down Azure Stack Hub](/azure-stack/operator/azure-stack-hub-decommission#shut-down-azure-stack-hub), one of the physical machines is not powered off.
- Remediation: If you see that any physical machine is not powered down, you must turn off that machine through the Baseboard Management Controller (BMC).
- Occurrence: Common.

## Storage

### False storage volume utilization alert in Test-AzureStack report

- Applicable: This issue applies to release 2311 and later.
- Cause: The new OS build with 2311 introduces a new system alert for thin provisioning: an alert is raised when the storage pool usage exceeds 70%. Fixed-size volumes are used in the Azure Stack Hub deployment, so the 70% threshold is always exceeded. You can find this warning in the Test-AzureStack reports.
- Remediation: You can ignore the alert in the Test-AzureStack report. Microsoft is aware of the issue and is working on a fix.
- Occurrence: Common.

<!-- ## Alerts -->

## Portal

- Applicable: This issue applies to release 2311.
- Cause: In the Azure Stack Hub user portal, under the **Virtual Networks** section, there are three new options for virtual networks: **DNS Servers**, **Flow Timeout**, and **BGP community string**. You can successfully modify the DNS configuration using the **DNS Servers** option. However, attempts to use the **Flow Timeout** and **BGP community string** options result in a failure within the portal notifications. No changes are made to the underlying services; the errors are only in the portal.
- Remediation: Microsoft is aware of the problem and is working on a fix.
- Occurrence: Common.

### False deployment error in portal for API app deployment

- Applicable: This issue applies to release 2311 and later.
- Cause: Some users might see an error message with error code **templateLinkAndJson** when deploying an API application from the marketplace, even though the deployment was successful.
- Remediation: Check your API app after deployment to ensure deployment was successful. Microsoft is aware of the problem and is working on a fix.
- Occurrence: Common.

<!-- ## Datacenter integration -->

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

<!-- ## App Service -->

## Resource providers

### Incorrect rotation status after secret rotation of resource provider certificates

- Applicable: This issue applies to all Azure Stack Hub add-on resource providers.
- Cause: After secret rotation, the rotation state shows as "in progress" even though the rotation completed successfully, the provisioning state shows "successful," and the expiration date is updated.
- Remediation: None. No impact to your system or workloads.
- Occurrence: All supported versions of Azure Stack Hub.

<!-- ## Usage -->

<!-- ### Identity -->

<!-- ### Marketplace -->

<!-- ## Event Hubs -->

::: moniker-end

::: moniker range="azs-2306"
<!-- ## Update -->

<!-- ## Networking -->

<!-- ## Compute -->

<!-- ## Alerts -->

<!-- ## Portal -->

<!-- ## Datacenter integration -->

<!-- ## Storage -->

<!-- ## SQL and MySQL-->

## App Service

### Incorrect rotation status after secret rotation of resource provider certificates

- Applicable: This issue applies to all Azure Stack Hub add-on resource providers.
- Cause: After secret rotation, the rotation state shows as "in progress" even though the rotation completed successfully, the provisioning state shows "successful," and the expiration date is updated.
- Remediation: None. No impact to your system or workloads.
- Occurrence: All supported versions of Azure Stack Hub.

<!-- ## Usage -->

<!-- ### Identity -->

<!-- ### Marketplace -->

<!-- ## Event Hubs -->

::: moniker-end

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="azs-2301"
## 2301 archived known issues
::: moniker-end
::: moniker range="azs-2206"
## 2206 archived known issues
::: moniker-end
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

::: moniker range="<azs-2306"
You can access older versions of Azure Stack Hub known issues in the table of contents on the left side, under the [Resources > Release notes archive](./relnotearchive/known-issues.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
