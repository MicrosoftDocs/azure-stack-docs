---
title: AksHci PowerShell module for AKS hybrid
description: Learn how to use the AksHci module commands to manage AKS hybrid 
author: sethmanheim
ms.topic: reference
ms.date: 08/25/2023
ms.author: sethm 
ms.lastreviewed: 01/26/2023

---

# AKS hybrid deployment options PowerShell reference

Commands to interact with AKS hybrid.

## AKS hybrid cmdlets

|    Cmdlet    |    Description        |
| ------- | ---------- |
| [Add-AksHciGmsaCredentialSpec](./add-akshcigmsacredentialspec.md) | Adds a credentials spec for gMSA deployments on a cluster. |
| [Add-AksHciNode](./add-akshcinode.md) | Adds a new physical node to a deployment. |
| [Disable-AksHciArcConnection](./disable-akshciarcconnection.md) | Disables the Arc connection on an AKS hybrid cluster.|
| [Disable-AksHciPreview](disable-akshcipreview.md) | Reverts AKS hybrid from a preview channel back to the stable channel. |
| [Get-AksHciAutoScalerProfile](./get-akshciautoscalerprofile.md) | Retrieves a list of available autoscaler configuration profiles in the system or a specific autoscaler configuration profile and its settings. |
| [Enable-AksHciArcConnection](./enable-akshciarcconnection.md) |  Enables the Arc connection for an AKS hybrid cluster. |
| [Enable-AksHciPreview](enable-akshcipreview.md) | Updates AKS hybrid to a preview channel. |
| [Get-AksHciBillingStatus](./get-akshcibillingstatus.md) | Gets billing status for the AKS hybrid deployment. |
| [Get-AksHciCluster](./get-akshcicluster.md) | Lists deployed clusters including the Azure Kubernetes Service host. |
| [Get-AksHciClusterNetwork](./get-akshciclusternetwork.md) | Retrieves virtual network settings by name, cluster name, or a list of all virtual network settings in the system. |
| [Get-AksHciClusterUpdates](./get-akshciclusterupdates.md) | Gets the available upgrades for an Azure Kubernetes Service cluster. |
| [Get-AksHciConfig](./get-akshciconfig.md) | Lists the current configuration settings for the Azure Kubernetes Service host. |
| [Get-AksHciCredential](./get-akshcicredential.md) | Accesses your cluster using kubectl. |
| [Get-AksHciEventLog](./get-akshcieventlog.md) | Gets all the event logs from the AKS hybrid PowerShell module. |
| [Get-AksHciKubernetesVersion](./get-akshcikubernetesversion.md) | Lists available version for creating managed Kubernetes cluster. |
| [Get-AksHciLogs](./get-akshcilogs.md) | Creates a zipped folder with logs from all your pods. |
| [Get-AksHciNodePool](./get-akshcinodepool.md) | Lists the node pools in a Kubernetes cluster. |
| [Get-AksHciProxySetting](./get-akshciproxysetting.md) | Retrieves a list or an individual proxy settings object. |
| [Get-AksHciRegistration](./get-akshciregistration.md) | Gets registration information for the AKS hybrid deployment. |
| [Get-AksHciRelease](./get-akshcirelease.md) | Downloads the install and upgrade bits to a local share. |
| [Get-AksHciStorageContainer](./get-akshcistoragecontainer.md) | Gets information about the specified storage container. |
| [Get-AksHciUpdates](./get-akshciupdates.md) | Lists available updates for AKS hybrid. |
| [Get-AksHciVersion](./get-akshciversion.md) | Gets the current version of AKS hybrid. |
| [Get-AksHciVmSize](./get-akshcivmsize.md) | Lists supported VM sizes. |
| [Initialize-AksHciNode](./initialize-akshcinode.md) | Runs checks on every physical node to see if all requirements are satisfied to install AKS hybrid. |
| [Install-AksHci](./install-akshci.md) | Installs the Azure Kubernetes Service on AKS hybrid agents/services and host. |
| [Install-AksHciAdAuth](./install-akshciadauth.md) | Installs Active Directory authentication. |
| [Install-AksHciCsiNfs](./install-akshcicsinfs.md) | Installs the CSI NFS plug-in to a cluster. |
| [Install-AksHciCsiSmb](./install-akshcicsismb.md) | Installs the CSI SMB plug-in to a cluster. |
| [Install-AksHciGmsaWebhook](./install-akshcigmsawebhook.md) | Installs gMSA webhook add-on to the cluster.  |
| [Install-AksHciMonitoring](./install-akshcimonitoring.md) | Installs Prometheus for monitoring in the AKS hybrid deployment. |
| [New-AksHciAutoScalerProfile](./new-akshciautoscalerprofile.md) | Creates a new autoscaler configuration profile for the node pool autoscaler. | 
| [New-AksHciCluster](./new-akshcicluster.md) | Creates a new managed Kubernetes cluster. |
| [New-AksHciClusterNetwork](./new-akshciclusternetwork.md) | Creates an object for a new virtual network. |
| [New-AksHciLoadBalancerSetting](./new-akshciloadbalancersetting.md) | Creates a load balancer object for the workload clusters. |
| [New-AksHciNetworkSetting](./new-akshcinetworksetting.md) | Creates an object for a new virtual network. |
| [New-AksHciNodePool](./new-akshcinodepool.md) | Creates a new node pool to an existing cluster. |
| [New-AksHciProxySetting](./new-akshciproxysetting.md) | Creates an object defining proxy server settings to pass into `Set-AksHciConfig`. |
| [New-AksHciSSHConfiguration](./new-akshcisshconfiguration.md) | Creates an object for a new SSH configuration. |
| [New-AksHciStorageContainer](./new-akshcistoragecontainer.md) | Creates a new storage container.  |
| [Remove-AksHciAutoScalerProfile](./remove-akshciautoscalerprofile.md) | Removes an unused autoscaler configuration profile from the system.  |
| [Remove-AksHciCluster](./remove-akshcicluster.md) | Deletes a managed Kubernetes cluster. |
| [Remove-AksHciGmsaCredentialSpec](./remove-akshcigmsacredentialspec.md) | Deletes a credentials spec for gMSA deployments on a cluster. |
| [Remove-AksHciClusterNetwork](./remove-akshciclusternetwork.md) | Removes a cluster network object. |
| [Remove-AksHciCluster](./remove-akshcicluster.md) | Deletes a managed Kubernetes cluster. |
| [Remove-AksHciGmsaCredentialSpec](./remove-akshcigmsacredentialspec.md) | Deletes a credentials spec for gMSA deployments on a cluster. |
| [Remove-AksHciNode](./remove-akshcinode.md) | Removes a physical node from your deployment. |
| [Remove-AksHciNodePool](./remove-akshcinodepool.md) | Deletes a node pool from a cluster. |
| [Repair-AksHciCerts](./repair-akshcicerts.md) | Troubleshoots and fixes errors related to expired certificates for the AKS hybrid host. |
| [Repair-AksHciClusterCerts](./repair-akshciclustercerts.md) | Troubleshoots and fixes errors related to expired certificated for Kubernetes built-in components. |
| [Restart-AksHci](./restart-akshci.md) | Restarts Azure Kubernetes Service on AKS hybrid and removes all deployed Kubernetes clusters. |
| [Set-AksHciAutoScalerProfile](./set-akshciautoscalerprofile.md) | Configures individual settings of an autoscaler configuration profile.  |
| [Set-AksHciCluster](./set-akshcicluster.md) | Scales the number of control plane nodes or worker nodes in a cluster. |
| [Set-AksHciConfig](./set-akshciconfig.md) | Sets or update the configurations settings for the Azure Kubernetes Service host. |
| [Set-AksHciNodePool](./set-akshcinodepool.md) | Scales a node pool within a Kubernetes cluster. |
| [Set-AksHciRegistration](./set-akshciregistration.md) | Registers AKS hybrid with Azure. |
| [Sync-AksHciBilling](./sync-akshcibilling.md) | Manually triggers a billing records sync. |
| [Test-UpdateAksHci](./test-updateakshci.md) | Checks whether any target clusters are outside the AKS hybrid support window. |
| [Uninstall-AksHci](./uninstall-akshci.md) | Removes AKS hybrid. |
| [Uninstall-AksHciAdAuth](./uninstall-akshciadauth.md) | Removes Active Directory authentication. |
| [Uninstall-AksHciCsiNfs](./uninstall-akshcicsinfs.md) | Uninstalls CSI NFS Plugin in a cluster. |
| [Uninstall-AksHciCsiSmb](./uninstall-akshcicsismb.md) | Uninstalls the CSI SMB plug-in in a cluster. |
| [Uninstall-AksHciGmsaWebhook](./uninstall-akshcigmsawebhook.md) | Uninstalls the gMSA webhook add-on to the cluster. |
| [Uninstall-AksHciMonitoring](./uninstall-akshcimonitoring.md) | Removes Prometheus for monitoring from the AKS hybrid deployment. |
| [Update-AksHci](./update-akshci.md) | Updates the Azure Kubernetes Service host to the latest Kubernetes version. |
| [Update-AksHciCluster](./update-akshcicluster.md) | Updates a managed Kubernetes cluster to a newer Kubernetes or OS version. |

## Next steps

[AKS hybrid overview](../../index.yml)
