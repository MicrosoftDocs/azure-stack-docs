---
title: Troubleshooting overview for Azure Kubernetes Service on Azure Stack HCI 
description: An overview for troubleshooting issues encountered when using Azure Kubernetes Service on Azure Stack HCI. 
author: v-susbo
ms.topic: troubleshooting
ms.date: 12/13/2021
ms.author: v-susbo
ms.reviewer: 
---

# Troubleshooting overview

This overview provides guidance on how to find solutions for issues you encounter when using AKS on Azure Stack HCI. Known issues and errors topics are organized by functional area, and you can use the links provided in this topic to find the solutions and workarounds to resolve them. 

For some troubleshooting operations, you may need to use a secure SSH connection to access Windows or Linux worker nodes, which allows you to securely access the nodes for maintenance, log collection, and troubleshooting. For more information, see [create an SSH connection](ssh-connection.md).  

## View logs to troubleshoot an issue

Logs are an important method to collect and review data from many sources that can provide insights into your environment for troubleshooting purposes. AKS on Azure Stack HCI includes some [PowerShell cmdlets to collect and view logs](./view-logs.md), and you can also [collect and review kubelet logs](get-kubelet-logs.md).

## Find solutions for known issues and errors

AKS on Azure Stack HCI troubleshooting topics are organized by functional area. Use the links below to find solutions to issues and errors: 

- [Installation ](known-issues-installation.md)  
- [Upgrade ](known-issues-upgrade.md)
- [Windows Admin Center ](known-issues-windows-admin-center.md)
- [Azure Arc enabled Kubernetes](known-issues-arc.md)
- [Uninstall](known-issues-uninstall.md) 
- [Kubernetes workload clusters ](known-issues-workload-clusters.md) 
- [Networking](known-issues-networking.md)
- [Security and identity](known-issues-security.md) 
- [Storage](known-issues-storage.md)
- [General](known-issues.md) 

> [!NOTE]
> If none of the workarounds found in the links above apply to you, [open a support issue](./help-support.md).

For issues that are specific to Azure Stack HCI, use the following links:

- [Cluster validation reporting in Azure Stack HCI](/azure-stack/hci/manage/validate-qos): Troubleshoot cluster validation reporting for network and storage QoS (quality of service) settings across servers in an Azure Stack HCI cluster.
- [Credential Security Support Provider](/azure-stack/hci/manage/troubleshoot-credssp): Some Azure Stack HCI operations use Windows Remote Management (WinRM), which doesn't allow credential delegation by default. To allow delegation, the computer needs to have CredSSP enabled temporarily.

## Next steps

- To monitor the health, performance, and resources of control plane nodes and workloads, use the AKS on Azure Stack HCI [on-premises monitoring](monitor-logging.md) solution.
- To monitor Azure Arc-enabled Kubernetes clusters, see [Azure Monitor Container Insights](/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters?toc=%2fazure%2fazure-arc%2fkubernetes%2ftoc.json)
