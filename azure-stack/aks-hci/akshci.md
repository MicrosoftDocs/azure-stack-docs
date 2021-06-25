---
title: AksHci PowerShell module
description: Learn how to use the AksHci module commands to manage AKS on Azure Stack HCI 
author: jessicaguan
ms.topic: reference
ms.date: 05/25/2021
ms.author: jeguan
---

# AksHci 

Commands to interact with Azure Kubernetes Service on Azure Stack HCI.

## AksHci cmdlets

|    Command    |    Description        |
| ------- | ---------- |
| [add-akshcigmsacredentialspec](add-akshcigmsacredentialspec.md) | Adds a credentials spec for gMSA deployments on a cluster. |
| [add-akshcinode](./add-akshcinode.md) | Add a new physical node to a deployment. |
| [disable-akshciarcconnection](disable-akshciarcconnection.md) | Disables the Arc connection on an AKS on Azure Stack HCI cluster.|
| [enable-akshciarcconnection](enable-akshciarcconnection.md) |  Enables the Arc connection for an AKS on Azure Stack HCI cluster. |
| [get-akshcibillingstatus](get-akshcibillingstatus.md) | Get billing status for the Azure Kubernetes Service on Azure Stack HCI deployment. |
| [get-akshcicluster](get-akshcicluster.md) | List deployed clusters including the Azure Kubernetes Service host. |
| [get-akshciclusternetwork](get-akshciclusternetwork.md) | Retrieve virtual network settings by name, cluster name, or a list of all virtual network settings in the system. |
| [get-akshciclusterupdates](get-akshciclusterupdates.md) | Get the available upgrades for an Azure Kubernetes Service cluster. |
| [get-akshciconfig](get-akshciconfig.md) | List the current configuration settings for the Azure Kubernetes Service host. |
| [get-akshcicredential](get-akshcicredential.md) | Access your cluster using kubectl. |
| [get-akshcieventlog](get-akshcieventlog.md) | Gets all the event logs from the AKS HCI PowerShell module. |
| [get-akshcikubernetesversion](get-akshcikubernetesversion.md) | List available version for creating managed Kubernetes cluster. |
| [get-akshcilogs](get-akshcilogs.md) | Create a zipped folder with logs from all your pods. |
| [get-akshciproxysetting](get-akshciproxysetting.md) | Retrieve a list or an individual proxy settings object. |
| [get-akshciregistration](get-akshciregistration.md) | Get registration information for the Azure Kubernetes Service on Azure Stack HCI deployment. |
| [get-akshcistoragecontainer](get-akshcistoragecontainer.md) | Get the information of the specified storage container. |
| [get-akshciupdates](get-akshciupdates.md) | List available updates for Azure Kubernetes Service on Azure Stack HCI. |
| [get-akshciversion](get-akshciversion.md) | Get the current version of Azure Kubernetes Service on Azure Stack HCI. |
| [get-akshcivmsize](get-akshcivmsize.md) | List supported VM sizes. |
| [initialize-akshcinode](initialize-akshcinode.md) | Run checks on every physical node to see if all requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI. |
| [install-akshci](install-akshci.md) | Install the Azure Kubernetes Service on Azure Stack HCI agents/services and host. |
| [install-akshciadauth](install-akshciadauth.md) | Install Active Directory authentication. |
| [install-akshcicsinfs](install-akshcicsinfs.md) | Installs the CSI NFS plug-in to a cluster. |
| [install-akshcicsismb](install-akshcicsismb.md) | Installs the CSI SMB plug-in to a cluster. |
| [install-akshcigmsawebhook](install-akshcigmsawebhook.md) | Installs gMSA webhook add-on to the cluster.  |
| [install-akshcimonitoring](install-akshcimonitoring.md) | Installs Prometheus for monitoring in the Azure Kubernetes Service on Azure Stack HCI deployment. |
| [new-akshcicluster](new-akshcicluster.md) | Create a new managed Kubernetes cluster. |
| [new-akshciclusternetwork](new-akshciclusternetwork.md) | Create an object for a new virtual network. |
| [new-akshcinetworksetting](./new-akshcinetworksetting.md) | Create an object for a new virtual network. |
| [new-akshciproxysetting](new-akshciproxysetting.md) | Create an object defining proxy server settings to pass into `Set-AksHciConfig`. |
| [new-akshcistoragecontainer](new-akshcistoragecontainer.md) | Creates a new storage container.  |
| [remove-akshcicluster](remove-akshcicluster.md) | Delete a managed Kubernetes cluster. |
| [remove-akshciclusternetwork](remove-akshciclusternetwork.md) | Remove a proxy settings object. |
| [remove-akshcigmsacredentialspec](./remove-akshcigmsacredentialspec.md) | Deletes a credentials spec for gMSA deployments on a cluster. |
| [remove-akshcinode](./remove-akshcinode.md) | Remove a physical node from your deployment. |
| [repair-akshciclustercerts](./repair-akshciclustercerts.md) | Troubleshoots and fixes errors related to expired certificated for Kubernetes built-in components. |
| [restart-akshci](restart-akshci.md) | Restart Azure Kubernetes Service on Azure Stack HCI and remove all deployed Kubernetes clusters. |
| [set-akshcicluster](set-akshcicluster.md) | Scale the number of control plane nodes or worker nodes in a cluster. |
| [set-akshciconfig](set-akshciconfig.md) | Set or update the configurations settings for the Azure Kubernetes Service host. |
| [set-akshciregistration](set-akshciregistration.md) | Register Azure Kubernetes Service on Azure Stack HCI with Azure. |
| [sync-akshcibilling](sync-akshcibilling.md) | Manually trigger a billing records sync. |
| [uninstall-akshci](uninstall-akshci.md) | Remove Azure Kubernetes Service on Azure Stack HCI. |
| [uninstall-akshciadauth](uninstall-akshciadauth.md) | Remove Active Directory authentication. |
| [uninstall-akshcicsinfs](uninstall-akshcicsinfs.md) | Uninstalls CSI NFS Plugin in a cluster. |
| [uninstall-akshcicsismb](uninstall-akshcicsismb.md) | Uninstalls the CSI SMB plug-in in a cluster. |
| [uninstall-akshcigmsawebhook](uninstall-akshcigmsawebhook.md) | Uninstalls the gMSA webhook add-on to the cluster. |
| [uninstall-akshcimonitoring](uninstall-akshcimonitoring.md) | Removes Prometheus for monitoring from the Azure Kubernetes Service on Azure Stack HCI deployment. |
| [update-akshci](update-akshci.md) | Update the Azure Kubernetes Service host to the latest Kubernetes version. |
| [update-akshcicluster](update-akshcicluster.md) | Update a managed Kubernetes cluster to a newer Kubernetes or OS version. |


