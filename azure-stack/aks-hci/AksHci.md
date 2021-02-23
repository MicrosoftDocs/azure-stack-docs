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
| [get-akshcicluster](get-akshcicluster.md) | List deployed clusters including the Azure Kubernetes Service host. |
| [get-akshciclusterupgrades](get-akshciclusterupgrades.md) | Get the available upgrades for an Azure Kubernetes Service cluster. |
| [get-akshciconfig](Gget-akshciconfig.md) | List the current configuration settings for the Azure Kubernetes Service host. |
| [get-akshcicredential](get-akshcicredential.md) | Access your cluster using kubectl. |
| [get-akshcieventlog](get-akshcieventlog.md) | Gets all the event logs from the AKS HCI PowerShell module. |
| [get-akshcikubernetesversion](get-akshcikubernetesversion.md) | List available version for creating managed Kubernetes cluster. |
| [get-akshcilogs](get-akshcilogs.md) | Create a zipped folder with logs from all your pods. |
| [get-akshciupdates](get-akshciupdates.md) | List available updates for Azure Kubernetes Service on Azure Stack HCI. |
| [get-akshciversion](get-akshciversion.md) | Get the current version of Azure Kubernetes Service on Azure Stack HCI. |
| [get-akshcivmsize](get-akshcivmsize.md) | List supported VM sizes. |
| [initialize-akshcinode](initialize-akshcinode.md) | Run checks on every physical node to see if all requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI. |
| [install-akshci](install-akshci.md) | Install the Azure Kubernetes Service on Azure Stack HCI agents/services and host. |
| [install-akshciadauth](install-akshciadauth.md) | Install Active Directory authentication. |
| [install-akshciarconboarding](install-akshciarconboarding.md) | Download and install kubectl, the Kubernetes command-line tool. |
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

