---
title: Troubleshoot Azure Managed Lustre cluster performance issues
description: Learn how to troubleshoot common cluster performance issues in Azure Managed Lustre
author: barbisch
ms.author: akashdubey
ms.service: azure-managed-lustre
ms.topic: troubleshooting-general
ms.date: 02/20/2026

---

# Troubleshoot Azure Managed Lustre deployment issues

In this article, you learn how to troubleshoot common issues that you might encounter when deploying an Azure Managed Lustre file system.

## Prerequisites

- Access to your AMLFS resource in the Azure portal
- Administrative privileges on Lustre client virtual machines (VMs)
- Familiarity with Azure networking and security concepts

## Best Practices

To maintain optimal performance and security, keep Lustre clients updated. To benefit from the latest bug fixes and optimizations, use the latest Lustre client software from packages.microsoft.com. Refer to the AMLFS documentation for update instructions. If using integrated images (for example, HPC Images), update your VMs to the latest image for the most recent Lustre client.

## Symptom 1: Lower throughput, bandwidth, or higher latency than expected

If your AMLFS deployment isn't achieving expected throughput or bandwidth, or you notice increased latency, review the configuration areas:

| Potential Issue | Recommended Action |
|-----------------|--------------------|
| Availability zone placement | To minimize latency, ensure Lustre clients (your compute nodes) and AMLFS are in the same Azure region and Availability Zone. |
| Accelerated networking | Enable accelerated networking on all Lustre client VMs to maximize bandwidth. See [Client prerequisites](connect-clients.md#client-prerequisites) for instructions. |
| File striping configuration | Optimize file striping for workloads that access large files. Wider striping improves throughput for single files, but could be detrimental for smaller files. Refer to AMLFS documentation for guidance. |
| File system size | Compare the provisioned throughput (shown on the AMLFS Overview tab) with current usage (Monitoring tab). If you reached the limit, consider a larger file system with greater provisioned throughput. |
| Azure firewall configuration | Configure Azure Firewall to avoid routing Lustre client and AMLFS traffic through the firewall. Only filter traffic entering or leaving the subnet, not within the subnet. See AMLFS documentation for details. |

Important references:
- [Optimize Azure Managed Lustre Performance](optimize-performance)
- [Optimize file and directory layouts](optimize-file-layouts)
- [Use Azure Firewall with Azure Managed Lustre](configure-firewall)

## Symptom 2: Workload pauses or stuck mounting the file system

Workloads may pause or mounts may become stuck due to several orchestrator or networking issues. Use the checklist to troubleshoot.

| Potential Issue | Recommended Action |
|-----------------|--------------------|
| Client evictions | Always unmount the file system (without the use of -f or -l) before stopping, deallocating, or rebooting Lustre client VMs. Failure to do so can cause eviction events, resulting other mounted clients to experience pauses for up to 15 minutes due to its caching abilities combined with its coherent protocol. You can monitor for Lustre client evictions on the Monitoring tab in the Azure portal. |
| Spot VMs, VMSS, and orchestrator practices | Follow proper procedures for unmounting Lustre before deallocating instances. Use scheduled events to automate unmounting and prevent client evictions. See **Important references** after this table. |
| Network Security Group (NSG) or Firewall misconfiguration | Review recent changes to NSGs or Firewall rules. Ensure all required ports and endpoints are open. Rule changes may only take effect after a VM reboot or other TCP reconnection event. |
| Maintenance window | If experiencing temporary pauses, check the configured maintenance window in the Azure portal. AMLFS may be undergoing scheduled maintenance. Refer to AMLFS documentation for maintenance details, notification setup, and how to modify your maintenance window if needed. |

Important References:
- [Connecting Clients to the File System](connect-clients)
    - [Best Practices for unmounting with Spot VMs, VMSS, and other orchestrators](https://techcommunity.microsoft.com/blog/azurehighperformancecomputingblog/how-to-unmount-azure-managed-lustre-filesystem-using-azure-scheduled-events/3917814)
- [Network Security Group configuration](configure-network-security-group)
- [Use Azure Firewall with Azure Managed Lustre](configure-firewall)
- [Maintenance Window documentation](/create-file-system-portal.md#maintenance-window)
