---
title: AksHci PowerShell module
description: Learn how to use the AksHci module commands to manage AKS on Azure Stack HCI 
author: jessicaguan
ms.topic: reference
ms.date: 2/12/2021
ms.author: jeguan
---

# AksHci 

Commands to interact with Azure Kubernetes Service on Azure Stack HCI.

## AksHci cmdlets

|         |            |
| ------- | ---------- |
| [Get-AksHciCluster](Get-AksHciCluster.md) | List deployed clusters including the Azure Kubernetes Service host. |
| [Get-AksHciClusterUpgrades](Get-AksHciClusterUpgrades.md) | Get the available upgrades for an Azure Kubernetes Service cluster. |
| [Get-AksHciConfig](Get-AksHciConfig.md) | List the current configuration settings for the Azure Kubernetes Service host. |
| [Get-AksHciCredential](Get-AksHciCredential.md) | Access your cluster using kubectl. |
| [Get-AksHciEventLog](Get-AksHciEventLog.md) | Gets all the event logs from the AKS HCI PowerShell module. |
| [Get-AksHciKubernetesVersion](Get-AksHciKubernetesVersion.md) | List available version for creating managed Kubernetes cluster. |
| [Get-AksHciLogs](Get-AksHciLogs.md) | Create a zipped folder with logs from all your pods. |
| [Get-AksHciUpdates](Get-AksHciUpdates.md) | List available updates for Azure Kubernetes Service on Azure Stack HCI. |
| [Get-AksHciVersion](Get-AksHciVersion.md) | Get the current version of Azure Kubernetes Service on Azure Stack HCI. |
| [Get-AksHciVmSize](Get-AksHciVmSize.md) | List supported VM sizes. |
| [Initialize-AksHciNode](Initialize-AksHciNode.md) | Run checks on every physical node to see if all requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI. |
| [Install-AksHci](Install-AksHci.md) | Install the Azure Kubernetes Service on Azure Stack HCI agents/services and host. |
| [Install-AksHciAdAuth](Install-AksHciAdAuth.md) | Install Active Directory authentication. |
| [Install-AksHciArcOnboarding](Install-AksHciArcOnboarding.md) | Download and install kubectl, the Kubernetes command-line tool. |
| [New-AksHciCluster](New-AksHciCluster.md) | Create a new managed Kubernetes cluster. |
| [New-AksHciNetworkSetting](New-AksHciNetworkSetting.md) | Create an object for a new virtual network. |
| [Remove-AksHciCluster](Remove-AksHciCluster.md) | Delete a managed Kubernetes cluster. |
| [Restart-AksHci](Restart-AksHci.md) | Restart Azure Kubernetes Service on Azure Stack HCI and remove all deployed Kubernetes clusters. |
| [Set-AksHciClusterNodeCount](Set-AksHciClusterNodeCount.md) | Scale the number of control plane nodes or worker nodes in a cluster. |
| [Set-AksHciConfig](Set-AksHciConfig.md) | Set or update the configurations settings for the Azure Kubernetes Service host. |
| [Uninstall-AksHci](Uninstall-AksHci.md) | Remove Azure Kubernetes Service on Azure Stack HCI. |
| [Uninstall-AksHciAdAuth](Uninstall-AksHciAdAuth.md) | Remove Active Directory authentication. |
| [Update-AksHci](Update-AksHci.md) | Update the Azure Kubernetes Service host to the latest Kubernetes version. |
| [Update-AksHciCluster](Update-AksHciCluster.md) | Update a managed Kubernetes cluster to a newer Kubernetes or OS version. |

