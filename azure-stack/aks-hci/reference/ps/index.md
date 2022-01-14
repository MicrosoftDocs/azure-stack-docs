---
title: AksHci PowerShell module for AKS on Azure Stack HCI
description: Learn how to use the AksHci module commands to manage AKS on Azure Stack HCI 
author: mattbriggs
ms.topic: reference
ms.date: 05/25/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan
---

# AksHci PowerShell Reference

Commands to interact with Azure Kubernetes Service on Azure Stack HCI.

## AksHci cmdlets

|    Cmdlet    |    Description        |
| ------- | ---------- |
| [Add-AksHciGmsaCredentialSpec](./add-akshcigmsacredentialspec.md) | Adds a credentials spec for gMSA deployments on a cluster. |
| [Add-AksHciNode](./add-akshcinode.md) | Add a new physical node to a deployment. |
| [Disable-AksHciArcConnection](./disable-akshciarcconnection.md) | Disables the Arc connection on an AKS on Azure Stack HCI cluster.|
| [Disable-AksHciPreview](disable-akshcipreview.md) | Reverts AKS on Azure Stack HCI from a preview channel back to the stable channel. |
| [Enable-AksHciArcConnection](./enable-akshciarcconnection.md) |  Enables the Arc connection for an AKS on Azure Stack HCI cluster. |
| [Enable-AksHciPreview](enable-akshcipreview.md) | Updates AKS on Azure Stack HCI to a preview channel. |
| [Get-AksHciBillingStatus](./get-akshcibillingstatus.md) | Get billing status for the Azure Kubernetes Service on Azure Stack HCI deployment. |
| [Get-AksHciCluster](./get-akshcicluster.md) | List deployed clusters including the Azure Kubernetes Service host. |
| [Get-AksHciClusterNetwork](./get-akshciclusternetwork.md) | Retrieve virtual network settings by name, cluster name, or a list of all virtual network settings in the system. |
| [Get-AksHciClusterUpdates](./get-akshciclusterupdates.md) | Get the available upgrades for an Azure Kubernetes Service cluster. |
| [Get-AksHciConfig](./get-akshciconfig.md) | List the current configuration settings for the Azure Kubernetes Service host. |
| [Get-AksHciCredential](./get-akshcicredential.md) | Access your cluster using kubectl. |
| [Get-AksHciEventLog](./get-akshcieventlog.md) | Gets all the event logs from the AKS HCI PowerShell module. |
| [Get-AksHciKubernetesVersion](./get-akshcikubernetesversion.md) | List available version for creating managed Kubernetes cluster. |
| [Get-AksHciLogs](./get-akshcilogs.md) | Create a zipped folder with logs from all your pods. |
| [Get-AksHciNodePool](./get-akshcinodepool.md) | List the node pools in a Kubernetes cluster. |
| [Get-AksHciProxySetting](./get-akshciproxysetting.md) | Retrieve a list or an individual proxy settings object. |
| [Get-AksHciRegistration](./get-akshciregistration.md) | Get registration information for the Azure Kubernetes Service on Azure Stack HCI deployment. |
| [Get-AksHciContainerStorage](./get-akshcistoragecontainer.md) | Get the information of the specified storage container. |
| [Get-AksHciUpdates](./get-akshciupdates.md) | List available updates for Azure Kubernetes Service on Azure Stack HCI. |
| [Get-AksHciVersion](./get-akshciversion.md) | Get the current version of Azure Kubernetes Service on Azure Stack HCI. |
| [Get-AksHciVmSize](./get-akshcivmsize.md) | List supported VM sizes. |
| [Initialize-AksHciNode](./initialize-akshcinode.md) | Run checks on every physical node to see if all requirements are satisfied to install Azure Kubernetes Service on Azure Stack HCI. |
| [Install-AksHci](./install-akshci.md) | Install the Azure Kubernetes Service on Azure Stack HCI agents/services and host. |
| [Install-AksHciAdAuth](./install-akshciadauth.md) | Install Active Directory authentication. |
| [Install-AksHciCsiNfs](./install-akshcicsinfs.md) | Installs the CSI NFS plug-in to a cluster. |
| [Install-AksHciCsiSmb](./install-akshcicsismb.md) | Installs the CSI SMB plug-in to a cluster. |
| [Install-AksHciGmsaWebhook](./install-akshcigmsawebhook.md) | Installs gMSA webhook add-on to the cluster.  |
| [Install-AksHciMonitoring](./install-akshcimonitoring.md) | Installs Prometheus for monitoring in the Azure Kubernetes Service on Azure Stack HCI deployment. |
| [New-AksHciCluster](./new-akshcicluster.md) | Create a new managed Kubernetes cluster. |
| [New-AksHciClusterNetwork](./new-akshciclusternetwork.md) | Create an object for a new virtual network. |
| [New-AksHciLoadBalancerSetting](./new-akshciloadbalancersetting.md) | Create a load balancer object for the workload clusters. |
| [New-AksHciNetworkSetting](./new-akshcinetworksetting.md) | Create an object for a new virtual network. |
| [New-AksHciNodePool](./new-akshcinodepool.md) | Create a new node pool to an existing cluster. |
| [New-AksHciProxySetting](./new-akshciproxysetting.md) | Create an object defining proxy server settings to pass into `Set-AksHciConfig`. |
| [New-AksHciStorageContainer](./new-akshcistoragecontainer.md) | Creates a new storage container.  |
| [Remove-AksHciCluster](./remove-akshcicluster.md) | Delete a managed Kubernetes cluster. |
| [Remove-AksHciGmsaCredentialSpec](./remove-akshcigmsacredentialspec.md) | Deletes a credentials spec for gMSA deployments on a cluster. |
| [Remove-AksHciClusterNetwork](./remove-akshciclusternetwork.md) | Remove a cluster network object. |
| [Remove-AksHciCluster](./remove-akshcicluster.md) | Delete a managed Kubernetes cluster. |
| [Remove-AksHciGmsaCredentialSpec](./remove-akshcigmsacredentialspec.md) | Deletes a credentials spec for gMSA deployments on a cluster. |
| [Remove-AksHciNode](./remove-akshcinode.md) | Remove a physical node from your deployment. |
| [Repair-AksHciClusterCerts](./repair-akshciclustercerts.md) | Troubleshoots and fixes errors related to expired certificated for Kubernetes built-in components. |
| [Remove-AksHciNodePool](./remove-akshcinodepool.md) | Delete a node pool from a cluster. |
| [Repair-AksHciCerts](./repair-akshcicerts.md) | Troubleshoots and fixes errors related to expired certificates for the AKS on Azure Stack HCI host. |
| [Restart-AksHci](./restart-akshci.md) | Restart Azure Kubernetes Service on Azure Stack HCI and remove all deployed Kubernetes clusters. |
| [Set-AksHciCluster](./set-akshcicluster.md) | Scale the number of control plane nodes or worker nodes in a cluster. |
| [Set-AksHciConfig](./set-akshciconfig.md) | Set or update the configurations settings for the Azure Kubernetes Service host. |
| [Set-AksHciNodePool](./set-akshcinodepool.md) | Scale a node pool within a Kubernetes cluster. |
| [Set-AksHciRegistration](./set-akshciregistration.md) | Register Azure Kubernetes Service on Azure Stack HCI with Azure. |
| [Sync-AksHciBilling](./sync-akshcibilling.md) | Manually trigger a billing records sync. |
| [Uninstall-AksHci](./uninstall-akshci.md) | Remove Azure Kubernetes Service on Azure Stack HCI. |
| [Uninstall-AksHciAdAuth](./uninstall-akshciadauth.md) | Remove Active Directory authentication. |
| [Uninstall-AksHciCsiNfs](./uninstall-akshcicsinfs.md) | Uninstalls CSI NFS Plugin in a cluster. |
| [Uninstall-AksHciCsiSmb](./uninstall-akshcicsismb.md) | Uninstalls the CSI SMB plug-in in a cluster. |
| [Uninstall-AksHciGmsaWebhook](./uninstall-akshcigmsawebhook.md) | Uninstalls the gMSA webhook add-on to the cluster. |
| [Uninstall-AksHciMonitoring](./uninstall-akshcimonitoring.md) | Removes Prometheus for monitoring from the Azure Kubernetes Service on Azure Stack HCI deployment. |
| [Update-AksHci](./update-akshci.md) | Update the Azure Kubernetes Service host to the latest Kubernetes version. |
| [Update-AksHciCluster](./update-akshcicluster.md) | Update a managed Kubernetes cluster to a newer Kubernetes or OS version. |

## Next steps

For more information, about the [AKS on the Azure Stack HCI](../../index.yml).