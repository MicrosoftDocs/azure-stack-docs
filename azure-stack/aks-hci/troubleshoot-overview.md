---
title: Troubleshooting overview for Azure Kubernetes Service on Azure Stack HCI and Windows Server 
description: An overview for troubleshooting issues encountered when using Azure Kubernetes Service on Azure Stack HCI and Windows Server. 
author: sethmanheim
ms.topic: troubleshooting
ms.date: 06/28/2022
ms.author: sethm 
ms.lastreviewed: 04/08/2022
ms.reviewer: abha
# Intent: As an IT Pro, I want to learn how to troubleshoot issues with my AKS on Azure Stack HCI deployment
# Keyword: troubleshooting

---

# Troubleshooting overview

This overview provides guidance on how to find solutions for issues you encounter when using Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server. Known issues and errors topics are organized by functional area. You can use the links provided in this topic to find the solutions and workarounds to resolve them. 

For some troubleshooting operations, you may need to use a secure SSH connection to access Windows or Linux worker nodes, which allows you to securely access the nodes for maintenance, log collection, and troubleshooting. For more information, see [Connect with SSH to Windows or Linux worker nodes for maintenance and troubleshooting](ssh-connection.md).  

## View logs to troubleshoot an issue

Logs are an important method to collect and review data from many sources that can provide insights into your environment for troubleshooting purposes. AKS on Azure Stack HCI and Windows Server includes some [PowerShell cmdlets to collect and view logs](./view-logs.md), and you can also [collect and review kubelet logs](get-kubelet-logs.md).

## Find solutions for known issues and errors

AKS on Azure Stack HCI and Windows Server troubleshooting topics are organized by functional area. Use the links below to find solutions to issues and errors: 

- [Installation ](/azure-stack/aks-hci/known-issues-installation)  
- [Upgrade ](/azure-stack/aks-hci/known-issues-upgrade)
- [Windows Admin Center ](/azure-stack/aks-hci/known-issues-windows-admin-center)
- [Azure Arc enabled Kubernetes](/azure-stack/aks-hci/known-issues-arc)
- [Uninstall](/azure-stack/aks-hci/known-issues-uninstall) 
- [Kubernetes workload clusters ](/azure-stack/aks-hci/known-issues-workload-clusters) 
- [Networking](/azure-stack/aks-hci/known-issues-networking)
- [Security and identity](/azure-stack/aks-hci/known-issues-security) 
- [Storage](/azure-stack/aks-hci/known-issues-storage)
- [General](/azure-stack/aks-hci/known-issues)

> [!NOTE]
> If none of the workarounds found in the links above apply to you, [open a support issue](./help-support.md).

For issues that are specific to Azure Stack HCI, use the following links:

- [Cluster validation reporting in Azure Stack HCI](/azure-stack/hci/manage/validate-qos): Troubleshoot cluster validation reporting for network and storage QoS (quality of service) settings across servers in an Azure Stack HCI and Windows Server cluster.
- [Credential Security Support Provider](/azure-stack/hci/manage/troubleshoot-credssp): Some Azure Stack HCI operations use Windows Remote Management (WinRM), which doesn't allow credential delegation by default. To allow delegation, the computer needs to have CredSSP enabled temporarily.

## Next steps

- To monitor the health, performance, and resources of control plane nodes and workloads, use the AKS on Azure Stack HCI and Windows Server [on-premises monitoring](monitor-logging.md) solution.
- To monitor Azure Arc-enabled Kubernetes clusters, see [Azure Monitor Container Insights](/azure/azure-monitor/containers/container-insights-enable-arc-enabled-clusters?toc=%2fazure%2fazure-arc%2fkubernetes%2ftoc.json)
