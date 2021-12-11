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

This article provides an overview of the issues you may encounter when using AKS on Azure Stack HCI. The troubleshooting and known issues are organized by functional area, and you can use the links below to find solutions and workarounds to help you resolve known issues. 

You can also [open a support issue](./help-support.md) if none of the workarounds found in the topics below apply to you.

|  Functional area  |   Description  |
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

- [Connect to nodes with SSH](ssh-connection.md)