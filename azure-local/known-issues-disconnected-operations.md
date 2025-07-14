---
title: Release notes for disconnected operations for Azure Local
description: Read about the known issues and fixed issues for disconnected operations for Azure Local.
author: haraldfianbakken
ms.topic: conceptual
ms.date: 07/14/2025
ms.author: hafianba
ms.reviewer: hafianba
---

# Known issues for disconnected operations for Azure Local

<!--[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]-->

This article lists critical known issues and their workarounds in disconnected operations for Azure Local.

These release notes update continuously, and we add critical issues that require a workaround as we find them. Before you deploy disconnected operations with Azure Local, review the information here.

## Known issues for version 2506

### Azure Local deployment with Azure Keyvault

Role-Based Access Control (RBAC) permissions on a newly created Azure Key Vault take up to 20 minutes to propagate. If you create the Azure Key Vault in the local portal and try to finish the cloud deployment, you might encounter permission issues when validating the cluster before deployment.

- **Resolution**: Wait 20 minutes after you create the Azure Key Vault to finish deploying the cluster, or create the key vault ahead of time. Assign the managed identity for each node, the key vault admin, and the user deploying to the cloud explicit roles on the key vault: **Key Vault Secrets Officer** and **Key Vault Data Access Administrator**.

Here's an example script. Modify and use this script to create the key vault ahead of time:

```powershell
param($resourceGroupName = "aldo-disconnected", $keyVaultName = "aldo-kv", $subscriptionName = "Starter Subscription")

$location = "autonomous"

Write-Verbose "Login interactive with user that will do cloud deployment"
# Login to Azure CLI (use the user you will run the portal deployment flow)"
az login 
az account set --subscription $subscriptionName
$accountInfo = (az account show)|convertfrom-json
# Create the Resource Group
$rg = (az group create --name $resourceGroupName --location $location)|Convertfrom-json

# Create a Key Vault
$kv = (az keyvault create --name $keyVaultName --resource-group $resourceGroupName --location $location --enable-rbac-authorization $true)|Convertfrom-json

Write-Verbose "Assigning permissions to $($accountInfo.user.name) on the Key Vault"
# Assign the secrets officer role to the resource group (could use KV explicit).
az role assignment create --assignee $accountInfo.user.name --role "Key Vault Secrets Officer" --scope $kv.Id
az role assignment create --assignee $accountInfo.user.name --role "Key Vault Data Access Administrator" --scope $kv.Id

$machines = (az connectedmachine list -g $resourceGroupName)|ConvertFrom-Json

# For now only supporting minimum 3 machines for ALDO
if($machines.Count -lt 3){
    Write-Error "No machines found in the resource group $resourceGroupName. Please check the resource group and try again. Please use the same resource group as where your Azure Local nodes are"
    return 1
}

Write-Verbose "Assigning permissions to MSIs $($machines.count) on the Key Vault"

$apps =(az ad sp list)|ConvertFrom-Json
$managedIds=$machines.displayname | foreach-object {
    $name = $_
    $apps|Where-Object {$_.ServicePrincipalType -eq 'ManagedIdentity' -and $_.displayname -match $name}
}

# Assign role to each of the managed IDs (Arc-VMs) in the RG 
$managedIds|foreach-object {    
    az role assignment create --role "Key Vault Administrator" --assignee $_.Id --scope $kv.id
}

## 
Write-Verbose "Wait 30 min before running cloud deployment from portal"
```

### Arc-initialization (node) fails with error code 42

Error: When attempting to initialize an Arc-enabled node, you may encounter error code 42.

Cause: Signing in with a service principal name (SPN) causes arc initialization to fail.

Mitigation: Until the underlying issue is fixed, sign in to each Azure Local node by running `az login –use-device-code` instead of using a SPN.

### Azure Local VMs (Arc VMs)

#### Azure Resource Graph add or edit tags error

Error: When adding or editing a tag on an Arc VM, you might see an Azure Resource Graph error.

Mitigation: Use Azure Command-Line Interface (CLI) to add or edit tags for the resource.

#### Start, restart, or delete buttons disabled after stopping VM

Error: After you stop an Arc VM, the start, restart, and delete buttons in the Azure portal are disabled.

Mitigation: Refresh your browser and the page.

#### Unable to view the network interface or read properties on an Arc VM

Viewing the network interface or properties on an Arc VM in the portal isn't supported in this release.

#### Portal showing unsaved change notification after updating VM size

If the notification in the top right shows that the save operation is complete, you can ignore the unsaved message and continue navigating away. The VM size is updated.

#### Error deleting a VM resource

Error: When you delete a VM from the portal, you might see the message ***Delete associated resource failed*** and ***Failed to delete the associated resource 'name' of type 'Network interface***.

Mitigation: After you delete the VM, use the CLI to delete the associated network interface. Run this command:

```azurecli
az stack-hci-vm network nic delete
```

### Azure Kubernetes Service (AKS) on Azure Local

#### Use an existing public key when creating AKS cluster

In this release, you can only use an existing public key when creating an AKS cluster.

Mitigation: To create an SSH key, use the following command-line tool and paste the public key in the UI:

```powershell
ssh-keygen -t rsa 
(cat ~\.ssh\id_rsa.pub)|set-clipboard
```

#### Update or scale a node pool from the portal is disabled

Updating or scaling a node pool from the portal is currently not supported.

Mitigation: Use CLI to update or scale a node pool.

```azurecli
az aksarc nodepool update
az aksarc nodepool scale
```

#### Kubernetes cluster list empty under Azure Local (Kubernetes clusters)

Error: When you navigate to Azure Local and click **Kubernetes clusters**, you might see an empty list of clusters.

Mitigation: Navigate to **Kubernetes** > **Azure Arc** in the left menu or using the search bar. Your clusters should appear in the list.

#### Save Kubernetes service notification stuck

Error: After updating to a newer version of Kubernetes, you might encounter a stuck notification, `Save Kubernetes service`.

Mitigation: Navigate to the cluster view page and refresh it. Verify that the state is still upgrading or has completed. If it's completed, you can ignore the notification.

#### Activity log shows authentication issue

Ignore the portal warning for this release.

#### Microsoft Entra authentication with Kubernetes RBAC fails

Error: When attempting to create a Kubernetes cluster with Entra authentication, you encounter an error.

Mitigation: Only local accounts with Kubernetes RBAC are supported in this preview.

#### Arc extensions

When navigating to extensions on an AKS cluster the add button is disabled and there aren't any extensions listed.

Arc extensions are unsupported in this release.

#### AKS resource shows on portal after deletion

Error: After successfully deleting an AKS cluster from portal the resource continues to show.

Mitigation: Use cli to delete and clean up the cluster. Run this command:

```azurecli
az aksarc delete
```

## Export Host guardian service certificates

This feature isn't supported in this release.

## Restart a node or the control plane VM

After you restart a node or the control plane VM, the system might take up to an hour to become fully ready. If you notice issues with the local portal, missing resources, or failed deployments, check the appliance health using the **OperationsModule** to confirm that all services are fully converged.

### Subscriptions

### Operator create subscription

After you create a new subscription as an operator, the subscription appears in the list as non-clickable and displays ***no access*** for the owner.

Mitigation: Refresh your browser window.

### Operator subscriptions view (timeout)

Error: If you're signed in as an operator, you might see a timeout screen and be unable to view, list, or create subscriptions.

Cause: This issue happens when a subscription owner is deleted or isn't synced from the source identity system to the local control plane. When you try to view subscriptions, the process fails because the owner's identity isn't available.

Mitigation: If the portal doesn't work, use Azure CLI or REST API to create and list subscriptions. To assign a different owner, use the REST API and enter the `subscriptionOwnerId` parameter when you create the subscription.

### Azure CLI

#### Manage clouds

Error: When you use the `az cloud` commands, such as `az cloud register`, `az cloud show`, or `az cloud set`, you might encounter issues if you use uppercase letters in the cloud name.

Mitigation: Only use lowercase letters for cloud names in `az cloud` subcommands, such as `register`, `show`, or `set`.

#### Create subscriptions

Azure CLI doesn't support providing `subscriptionOwnerId` for new subscriptions. This makes the operator the default owner of newly created subscriptions without a way of changing the owner currently.

Mitigation: Use `az rest` to create subscriptions with a different owner if required to automate directly with different owner

### Azure Portal

#### Signout fails

Error: When you select Sign-out, the request doesn't work.

Mitigation: Close your browser, then go to the portal URL.

<!--### Deployment

### Azure Local VMs

### AKS on Azure Local-->

### Azure Resource Manager

#### Template specs

Template specs aren't supported in the preview release. Deployments that use ARM templates with template specs fail.

## Unsupported scenarios

The following scenarios are unsupported in the preview release.

- Arc-Enabled servers (remote or non Azure Local VMs)
- Arc-Enabled Kubernetes clusters (remote or non AKS clusters)

If you test these scenarios, these systems must trust your custom CA and you need to pass `-custom-ca-cert` when Arc-enabling them.

::: moniker range="=azloc-2506"

::: moniker-end

::: moniker range="<=azloc-2506"

This feature is available only in Azure Local 2506.

::: moniker-end
