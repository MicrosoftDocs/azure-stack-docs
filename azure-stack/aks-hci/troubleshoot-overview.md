---
title: Troubleshooting overview for Azure Kubernetes Service on Azure Stack HCI 
description: An overview for troubleshooting issues when using Azure Kubernetes Service on Azure Stack HCI. 
author: EkeleAsonye
ms.topic: troubleshooting
ms.date: 12/03/2021
ms.author: v-susbo
ms.reviewer: 
---

# Troubleshooting overview

This overview provides guidance on how to find solutions for issues you encounter when using AKS on Azure Stack HCI. Known issues and errors topics are organized by functional area, and you can use the links in the table below to find solutions and workarounds to help you resolve them. 

For some troubleshooting operations, you may need to use a secure SSH connection to access Windows or Linux worker nodes, which allows you to securely access the nodes for maintenance, log collection, as well as troubleshooting. For more information, see [create an SSH connection](ssh-connection.md).  

## View logs to troubleshoot an issue

Logs are an important method to collect and review data from many sources that can provide insights into your environment for troubleshooting purposes. AKS on Azure Stack HCI includes some [PowerShell cmdlets that you can use to view logs](./view-logs.md), and you can also [collect and review kubelet logs](get-kubelet-logs.md).

## Find solutions for known issues and errors

> [!NOTE]
> If none of the workarounds found in the table above apply to you, [open a support issue](./help-support.md).

|  Where are you encountering your issue?  |   Description  |
| --------------   |  ----------------  |
| [Cluster validation reporting in Azure Stack HCI](/azure-stack/hci/manage/validate-qos) | Troubleshoot cluster validation reporting for network and storage QoS (quality of service) settings across servers in an Azure Stack HCI cluster. |
| [Credential Security Support Provider](/azure-stack/hci/manage/troubleshoot-credssp) |  Some Azure Stack HCI operations use Windows Remote Management (WinRM), which doesn't allow credential delegation by default. To allow delegation, the computer needs to have CredSSP enabled temporarily. |
| [Installation issues and errors](known-issues-installation.md)  | Find solutions for installation issues. |
| [Upgrade issues](known-issues-upgrade.md)  | Find workarounds for issues encountered when upgrading. |
| [Windows Admin Center issues and errors](known-issues-windows-admin-center.md) | Troubleshoot issues and errors found when using WAC. |
| [Azure Arc enabled Kubernetes](known-issues-arc.md) | Resolve errors when enabling or disabling Azure Arc on your AKS workload clusters |
| Uninstall issues | Find solutions to issues and errors found when uninstalling. |
| [Kubernetes workload clusters issues](known-issues-workload-clusters.md) | Troubleshoot and resolve Kubernetes workload cluster-related issues |
| [Networking](known-issues-networking.md) | Troubleshoot and resolve networking issues and errors. |
| [Security and identity](known-issues-security.md) | Find solutions for security and identity issues. |
| [Storage](known-issues-storage.md) | Find solutions for security and identity issues. |
| [General](known-issues.md)   |  Find solutions to common known issues. |


## Next steps

- To monitor the health, performance, and resources of control plane nodes and workloads, use the AKS on Azure Stack HCI [on-premises monitoring](monitor-logging.md) solution.
- To monitor Azure Arc-enabled Kubernetes clusters, see [Azure Monitor Container Insights](/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters?toc=%2fazure%2fazure-arc%2fkubernetes%2ftoc.json)
