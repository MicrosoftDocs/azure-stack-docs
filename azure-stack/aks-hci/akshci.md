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
| [get-akshciconfig](get-akshciconfig.md) | List the current configuration settings for the Azure Kubernetes Service host. |
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
| [new-akshcicluster](new-akshcicluster.md) | Create a new managed Kubernetes cluster. |
| [new-akshcinetworksetting](new-akshcinetworksetting.md) | Create an object for a new virtual network. |
| [remove-akshcicluster](remove-akshcicluster.md) | Delete a managed Kubernetes cluster. |
| [restart-akshci](restart-akshci.md) | Restart Azure Kubernetes Service on Azure Stack HCI and remove all deployed Kubernetes clusters. |
| [set-akshciclusternodecount](set-akshciclusternodecount.md) | Scale the number of control plane nodes or worker nodes in a cluster. |
| [set-akshciconfig](Sset-akshciconfig.md) | Set or update the configurations settings for the Azure Kubernetes Service host. |
| [uninstall-akshci](uninstall-akshci.md) | Remove Azure Kubernetes Service on Azure Stack HCI. |
| [uninstall-akshciadauth](uninstall-akshciadauth.md) | Remove Active Directory authentication. |
| [update-akshci](update-akshci.md) | Update the Azure Kubernetes Service host to the latest Kubernetes version. |
| [update-akshcicluster](update-akshcicluster.md) | Update a managed Kubernetes cluster to a newer Kubernetes or OS version. |

