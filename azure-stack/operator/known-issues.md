---
title: Azure Stack Hub known issues 
description: Learn about known issues in Azure Stack Hub releases.
author: sethmanheim
ms.topic: article
ms.date: 11/27/2024
ms.author: sethm
ms.reviewer: rtiberiu
ms.lastreviewed: 11/30/2023

# Intent: As an Azure Stack Hub user, I want to know about known issues in the latest release so that I can plan my update and be aware of any issues.
# Keyword: Notdone: keyword noun phrase

---


# Azure Stack Hub known issues

This article lists known issues in Azure Stack Hub releases. The list is updated as new issues are identified.

To access known issues for a different version, use the version selector dropdown above the table of contents on the left.

::: moniker range=">=azs-2406"
> [!IMPORTANT]  
> Review this article before applying the update.
::: moniker-end
::: moniker range="<azs-2406"
> [!IMPORTANT]  
> If your Azure Stack Hub instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](azure-stack-servicing-policy.md#keep-your-system-under-support).
::: moniker-end

<!---------------------------------------------------------->
<!------------------- SUPPORTED VERSIONS ------------------->
<!---------------------------------------------------------->

::: moniker range="azs-2501"
<!-- ## Update -->

<!-- ## Networking -->

## Compute

### Azure Kubernetes Service on Azure Stack Hub

- Applicable: This issue applies to release 2311 and later.
- Cause: Azure Kubernetes Service on Azure Stack Hub, currently in preview, is being discontinued and won't be released to general availability. If you try to register a new subscription to the **Microsoft.Containerservice** resource provider, the registration stays in the **Registering** state. If you try to create a new managed Kubernetes cluster or access existing managed Kubernetes clusters, you might see the raining cloud error screen.
- Remediation: Microsoft is aware of the problem and is working on a fix.
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

::: moniker range="azs-2408"
<!-- ## Update -->

## Networking

### Outbound ICMP to internet is blocked by default for tenant VM

- Applicable: This issue applies to release 2311 and later.
- Cause: The issue is caused by a change in the default ICMP behavior introduced with Windows Server 2022 that diverges from previous behavior, as well as Azure behavior.
- Remediation: You can add an inbound NSG rule to allow outbound ICMP packets to the internet. Microsoft is aware of the issue. 
- Occurrence: Common.

## Compute

### Azure Kubernetes Service on Azure Stack Hub

- Applicable: This issue applies to release 2311 and later.
- Cause: Azure Kubernetes Service on Azure Stack Hub, currently in preview, is being discontinued and won't be released to general availability. If you try to register a new subscription to the **Microsoft.Containerservice** resource provider, the registration stays in the **Registering** state. If you try to create a new managed Kubernetes cluster or access existing managed Kubernetes clusters, you might see the raining cloud error screen.
- Remediation: Microsoft is aware of the problem and is working on a fix.
- Occurrence: Common.

### A-series VMs deprecated

- Applicable: This issue applies to release 2406 and later.
- Cause: The A-series VMs are deprecated in Azure, so they shouldn't be used in Azure Stack Hub.
- Remediation: Although Azure Stack Hub isn't removing the A-series SKU, other undefined behavior might occur if you continue using it (such as with the load balancer, VMSS, etc.). Therefore, you should use a different VM SKU when you're ready. There is no cost difference in using different VM SKUs on Azure Stack Hub.
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

::: moniker range="azs-2406"

<!-- ## Update -->

## Compute

### Azure Kubernetes Service on Azure Stack Hub

- Applicable: This issue applies to release 2311 and later.
- Cause: Azure Kubernetes Service on Azure Stack Hub, currently in preview, is being discontinued and won't be released to general availability. If you try to register a new subscription to the **Microsoft.Containerservice** resource provider, the registration stays in the **Registering** state. If you try to create a new managed Kubernetes cluster or access existing managed Kubernetes clusters, you might see the raining cloud error screen.
- Remediation: Microsoft is aware of the problem and is working on a fix.
- Occurrence: Common.

### Standard Load Balancer portal error

- Applicable: This issue applies to release 2406 and later.
- Cause: The Standard Load Balancer portal blades for **Logs** and **Diagnostic settings** both show errors displaying the content.
- Remediation: The Standard Load Balancer in Azure Stack Hub does not support any diagnostic features.
- Occurrence: Common.

### A-series VMs deprecated

- Applicable: This issue applies to release 2406 and later.
- Cause: The A-series VMs are deprecated in Azure, so they shouldn't be used in Azure Stack Hub.
- Remediation: Although Azure Stack Hub isn't removing the A-series SKU, other undefined behavior might occur if you continue using it (such as with the load balancer, VMSS, etc.). Therefore, you should use a different VM SKU when you're ready. There is no cost difference in using different VM SKUs on Azure Stack Hub.
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

<!------------------------------------------------------------>
<!------------------- UNSUPPORTED VERSIONS ------------------->
<!------------------------------------------------------------>
::: moniker range="azs-2406"
## 2406 archived known issues
::: moniker-end
::: moniker range="azs-2311"
## 2311 archived known issues
::: moniker-end
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

::: moniker range="<azs-2406"
You can access older versions of Azure Stack Hub known issues in the table of contents on the left side, under the [Resources > Release notes archive](./relnotearchive/known-issues.md). Select the desired archived version from the version selector dropdown in the upper left. These archived articles are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack Hub support, see [Azure Stack Hub servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.
::: moniker-end
