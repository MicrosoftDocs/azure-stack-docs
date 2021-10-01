---
title: Resolve known issues and errors when enabling and disabling Azure Arc on Azure Kubernetes Service on Azure Stack HCI workload clusters
description: Find solutions to known issues and errors when enabling and disabling Azure Arc on AKS on Azure Stack HCI workload clusters
author: abha
ms.topic: troubleshooting
ms.date: 09/30/2021
ms.author: v-susbo
ms.reviewer: 
---

# Known issues and errors when enabling or disabling Azure Arc on your AKS workload clusters

This article describes errors and their workarounds you may encounter while connecting or disconnecting your AKS on Azure Stack HCI workload clusters to Azure Arc using the PowerShell cmdlets [Enable-AksHciArcConnection](./reference/ps/enable-akshciarcconnection.md) and [Disable-AksHciArcConnection](./reference/ps/disable-akshciarcconnection.md). For issues that are not been covered in this article, see [troubleshooting Arc enabled Kubernetes](/azure/azure-arc/kubernetes/troubleshooting).

You can also [open a support issue](/azure-stack/aks-hci/help-support) if none of the workarounds listed below apply to you.

## Error: _addons.msft.microsoft "demo-arc-onboarding" already exists_

This error usually means that you have already connected your AKS on Azure Stack HCI cluster to Arc enabled Kubernetes. To confirm, go to the [Azure portal](https://portal.azure.com) and check under the subscription and resource group you provided in [Set-AksHciRegistration](./reference/ps/set-akshciregistration.md) (if you've used default values) or `Enable-AksHciArcConnection` (if you haven't used default values). You can also confirm if your AKS on Azure Stack HCI cluster is connected to Azure by running the [az connectedk8s show ](/cli/azure/connectedk8s?view=azure-cli-latest#az_connectedk8s_show) Azure CLI command. If you do not see your workload cluster, run `Disable-AksHciArcConnection` and try again.

## Error: _Connection to Azure failed. Please run 'Set-AksHciRegistration' and try again_

This error means that your login context to Azure has expired. Use [Set-AksHciRegistration](./reference/ps/set-akshciregistration.md) to log in to Azure before running the [Enable-AksHciArcConnection](./reference/ps/enable-akshciarcconnection.md) command again. When rerunning `Set-AksHciRegistration`, make sure you use the same subscription and resource group details you used when you first registered the AKS host to Azure for billing. Note that if you rerun the command with a different subscription or resource group, it will not be picked up. Once the subscription and resource group are set in `Set-AksHciRegistration`, it cannot be changed without uninstalling AKS on Azure Stack HCI.


## Error: _System.Management.Automation.RemoteException Starting onboarding process Cluster "azure-arc-onboarding" set..._

The following error usually occurs when you use Windows Admin Center to create a workload cluster and connect it to Arc enabled Kubernetes. 

_System.Management.Automation.RemoteException Starting onboarding process Cluster "azure-arc-onboarding" set. User "azure-arc-onboarding" set. Context "azure-arc-onboarding" created. Switched to context "azure-arc-onboarding". Azure login az login: error: argument --password/-p: expected one argument usage: az login [-h] [--verbose] [--debug] [--only-show-errors] [--output {json,jsonc,yaml,yamlc,table,tsv,none}] [--query JMESPATH] [--username USERNAME] [--password PASSWORD] [--service-principal] [--tenant TENANT] [--allow-no-subscriptions] [-i] [--use-device-code] [--use-cert-sn-issuer] : Job Failed Condition]_

To resolve this issue, use the options below:

- Option 1: Delete the workload cluster and try again using Windows Admin Center. 
- Option 2: In PowerShell, check if the cluster has been created successfully by running the [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) command, and then use [Enable-AksHciArcConnection](./reference/ps/enable-akshciarcconnection.md) to connect your cluster to Arc.

## Error: _Timed out waiting for the condition_

This error usually points to one of the following issues:

- In a virtualized environment where you're creating clusters on an Azure VM, or if you are deploying AKS on Azure Stack HCI on multiple levels of virtualization. 
- Due to a slow internet

If one of the above scenarios applies to you, run [Disable-AksHciArcConnection](./reference/ps/disable-akshciarcconnection.md) and try connecting again. If the above scenario doesn't apply to you,  [open a support issue](/azure-stack/aks-hci/help-support) on AKS on Azure Stack HCI.


## Error: _Azure subscription is not properly configured_

You may encounter this issue if you have not configured your Azure subscription with the Arc enabled Kubernetes' resource providers. We currently check for Microsoft.Kubernetes and Microsoft.KubernetesConfiguration. For more information on enabling these resource providers, see [enabling resource providers for Arc enabled Kubernetes](/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#1-register-providers-for-azure-arc-enabled-kubernetes).


## Error: _A workload cluster with the name 'my-aks-cluster' was not found_

This error means that you have not created the workload cluster, or you have incorrectly spelled it. Run [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) to confirm you have the correct name or that the cluster you want to connect to Arc exists.

## Error: _'My-Cluster' is not a valid cluster name. Names must be lower-case and match the regex pattern: '^[a-z0-9][a-z0-9-]*[a-z0-9]$'_

This error indicates that the workload cluster does not follow Kubernetes naming convention. As the error suggests, make sure the cluster name is lower-case and matches the regular expression pattern: '^[a-z0-9][a-z0-9-]*[a-z0-9]$'.

## Error: _Cluster addons arc uninstall Error: namespaces "azure-arc" not found_

This error usually means that you have already uninstalled Arc agents from your workload cluster, or you have manually deleted the `azure-arc` namespace using a `kubectl` command. Go to the Azure portal to confirm that you do not have any leaked resources. For example, verify that you do not see a `connectedCluster` resource in the subscription and resource group.

## Error: _Secrets "sh.helm.release.v1.azure-arc.v1" not found_

This error usually indicates that your Kubernetes API server could not be reached. Try running the [Disable-AksHciArcConnection](./reference/ps/disable-akshciarcconnection.md) command again, and then go to the Azure portal to confirm that your `connectedCluster` resource has actually been deleted. You can also run `kubectl get ns -a` and confirm that the namespace, `azure-arc`, does not exist on your cluster.

## Error: _autorest/azure: Service returned an error. Status=404 Code="ResourceNotFound" Message="The Resource 'Microsoft.Kubernetes/connectedClusters/my-workload-cluster' under resource group 'AKS-HCI2' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix"]_

This error means that Azure could not find the `connectedCluster` ARM resource associated with your cluster. You may encounter this issue if: 

- You supplied an incorrect resource group or subscription while running the `Disable-AksHciArcConnection`. 
- You manually deleted the resource on the Azure portal.
- ARM cannot find your Azure resource.

In this case, as indicated in the error, see [resolve resource not found errors](/azure/azure-resource-manager/templates/error-not-found).

## Enable-AksHciArcConnection fails if Connect-AzAccount is used to log in to Azure

When you use [Connect-AzAccount](/powershell/module/az.accounts/connect-azaccount?view=azps-6.4.0) to log in, you might end up setting a different subscription as your default context than the one that you gave as an input to [Set-AksHciRegistration](./reference/ps/set-akshciregistration.md). When you then run [Enable-AksHciArcConnection](./reference/ps/enable-akshciarcconnection.md), the command expects the subscription used in `Set-AksHciRegistration`, but gets the default subscription set using the `Connect-AzAccount`, and therefore, might throw an error. To prevent this, you can follow one of the following options:

- Option 1: Run `Set-AksHciRegistration` to log in to Azure with the same parameters (subscription and resource group) you used when you first ran it to connect your AKS host to Azure for billing. You can then use `Enable-AksHciArcConnection -Name <ClusterName>` with default values, and your cluster will be connected to Arc under the AKS host billing subscription and resource group. 

- Option 2: Run `Enable-AksHciArcRegistration` with all parameters - subscription, resource group, location, tenant and secret to connect your cluster to Azure Arc under a different subscription and resource group than the AKS host. You should also run `Enable-AksHciArcRegistration` if you do not have enough permissions to connect your cluster to Azure Arc using your Azure Account (for example, if you are not a subscription owner).