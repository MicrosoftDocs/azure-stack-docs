---
title: Release notes for disconnected operations for Azure Local
description: Read about the known issues and fixed issues for disconnected operations for Azure Local.
author: haraldfianbakken
ms.topic: conceptual
ms.date: 06/27/2025
ms.author: hafianba
ms.reviewer: hafianba
---

# Known issues for disconnected operations for Azure Local
## Unsupported scenarios
The following list is scenarios that have partial functionality and might work, but is unsupported in the current release
- Arc-Enabled servers (Remote/non Azure Local VMs)
- Arc-Enabled K8s (Remote/non AKS clusters)

If you are testing out these scenarios, please note that these systems must trust your custom CA and you need to pass -custom-ca-cert when Arc-enabling them

::: moniker range="=azloc-2506"

<!--[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]-->

This article lists critical known issues and their workarounds in disconnected operations for Azure Local.

These release notes update continuously, and we add critical issues that require a workaround as we find them. Before you deploy disconnected operations with Azure Local, review the information here.

## Known issues for 2506
### Azure Local deployment - Azure Keyvault (permission issues)
RBAC permissions on a newly created Azure Keyvault takes 20 minutes to propagate. If you navigate through the local portal, creating the Azure Keyvault and trying to finalize the cloud deployment - you might hit permission issues when validating the cluster before deployment. 

- ***Resolution***: Wait 20 minutes after creating Azure Keyvault to finalize the cluster deployment. 

### Azure Local VMs (Arc VMs)

#### Add/Edits tags shows ARG error
When hitting add or editing a tag on an Arc VM - you hit an Azure Resource graph error. 

Mitigation: Use Azure CLI to add/edit tags for the resource

#### Start/Restart/delete button disabled after stopping VM
After hitting stop on a VM, the mentioned actions becomes disabled.

Mitigation: Refresh browser and the page to resolve.
#### Viewing Network interface (NIC) on Arc VM fails - cannot read properties of undefined 
Network interface view in portal is not supported in this release

#### After updating VM size - portal still show unsaved change notification
If notification in top right says save operation completed, ignore the unsaved message and continue navigating away. The VM size should be updated.

#### Deleting VM - failing to delete associated resources (Network interface)

When deleting a VM from the portal - you get 'Delete associated resource failed' with the message 'failed to delete the associated resource 'name' of type 'Network interface'. 

Mitigation: Use CLI to clean up and delete the associated NIC after the delete operation - by using : 
```azurecli
az stack-hci-vm network nic delete
```` 
### AKS on Azure Local
#### Only able to use existing public key when creating AKS cluster
Currently this is the only supported option. 

Mitigation: Create ssh key using commandline tool and paste the public key in UX

```powershell
ssh-keygen -t rsa 
(cat ~\.ssh\id_rsa.pub)|set-clipboard
```

#### Updating and scaling node pool from portal is disabled
Currently not supported through portal.

Mitigation: use azure cli to update/scale nodepool

```azurecli
az aksarc nodepool update
az aksarc nodepool scale
```

#### Kubernetes cluster does not show under Azure Local (Kubernetes clusters)
The list of clusters is empty when navigating to Azure Local and clicking Kubernetes clusters.

Mitigation: Navigate to 'Kubernetes - Azure Arc' on the left menu or using the search bar. Your clusters will appear in this list.
#### Save Kubernetes service notification stuck on saving even after k8s version updated
The top right notification shows 'Save Kubernetes service' running and never completes. 

Migitation: Ignore the notification being stuck. Verify that the state is still upgrading or have completed by navigating to the cluster/refreshing the cluster view page.

#### Activity log shows authentication issue
Known issue. Ignore the portal warning for this release.

#### Using Microsoft Entra authentication with Kubernetes RBAC fails
You hit an error when trying to create a Kubernetes cluster with Entra authentication. Only local accounts with Kubernetes RBAC is supported in this preview and Entra option will be removed from portal options in future release.

#### Arc exensions is not supported
When navigating to extensions on an AKS cluster - add button is disabled and there are no extensions. In this release extensions is not supported.
#### AKS resource still show on portal after deletion 
After successfully deleting cluster from portal, resource still persists and is present. 

Mitigation: Use cli to delete cluster and clean up
```azurecli
az aksarc delete
```

## Issues after restarting node or the control plane VM

If you experience issues with the local portal, missing resources, or failed deployments after you restart a node or the control plane VM, the system might not be fully ready.

The system can take an hour after a reboot to become fully ready. If you use the local portal or Azure CLI and experience failures, check the appliance health using the **OperationsModule** to make sure all services are fully converged.

### Azure CLI

The `az cloud show` and `az cloud register` commands treat case sensitivity differently, which can cause issues.

Use only lowercase letters for cloud names in `az cloud` subcommands, such as `register`, `show`, or `set`.

<!--### Deployment

### Azure Local VMs

### AKS on Azure Local-->

### Azure Resource Manager

#### Template specs

Template specs aren't supported in the preview release. Deployments that use ARM templates with template specs fail.

::: moniker-end

::: moniker range="<=azloc-2506"

This feature is available only in Azure Local 2506.

::: moniker-end
