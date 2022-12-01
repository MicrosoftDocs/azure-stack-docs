---
title: "Control access to AKS clusters with Azure RBAC in AKS hybrid (Preview)"
description: "Use Azure RBAC with Azure Active Directory (Azure AD) to control access to AKS clusters in AKS hybrid."
ms.topic: how-to
author: sethmanheim
ms.author: sethm
ms.reviewer: sumit.lahiri
ms.date: 12/01/2022
ms.last.reviewed: 11/30/2022

# Intent: As an IT Pro, I want to use Azure RBAC to authenticate connections to my AKS clusters over the Internet or on a private network.
# Keyword: Kubernetes role-based access control AKS Azure RBAC AD
---

# Control AKS cluster access using Azure RBAC with Azure AD in AKS hybrid (Preview)

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to set up Azure RBAC on an AKS cluster with Azure Arc enabled so you can use Azure Active Directory (Azure AD) and role assignments for authorization in AKS hybrid. Before you begin, you'll need to create an Azure Kubernetes Service (AKS) cluster with Azure Arc enabled. Steps for creating the cluster are covered in [Prerequisites](#prerequisites).

For more information about using Azure RBAC with Azure Arc-enabled Kubernetes clusters, see [Azure RBAC on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-azure-rbac).

> [!IMPORTANT]
> These preview features are available on a self-service, opt-in basis. Previews are provided "as is" and "as available," and they're excluded from the service-level agreements and limited warranty. Azure Arc-enabled Kubernetes previews are partially covered by customer support on a best-effort basis.<!--REVIEW! Source: azure-rbac.md, loosely adapted for AKS hybrid.-->

## Prerequisites

Before you deploy an AKS cluster with Azure Arc enabled, you must complete the following prerequisites.

#### Prepare your network

Configure the following network, proxy, and/or firewall settings:

- Configure the endpoints that must be accessible to connect a cluster to Azure Arc. For a list, see [Meet network requirements](/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements).  

- Allow the (https://graph.microsoft.com)[https://graph.microsoft.com] endpoint in your proxy or firewall.

  For information about configuring a proxy server, see [Proxy server settings](/azure/aks/hybrid/set-proxy-settings).

#### Create the server app and client app

Register your server app and secret and your client app and secret by performing the following steps:

> [!NOTE]
> These steps direct you to key tasks in [Use Azure RBAC for Azure Arc-enabled Kubernetes clusters](/azure/azure-arc/kubernetes/azure-rbac) that are required to prepare for the Azure RBAC setup in AKS hybrid.  

To do these steps, you must have the built-in [Application Administrator role](/azure/active-directory/roles/permissions-reference) in Azure AD. For instructions, see [Assign Azure AD roles to users](/azure/active-directory/roles/manage-roles-portal).

1. [Create a server application and shared secret](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI#create-a-server-application).

1. [Create a role assignment for the server application](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI#create-a-role-assignment-for-the-server-application).

1. [Create a client application](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI#create-a-client-application). You'll refer to the client application when you use `kubectl` to connect within your network.

#### Grant permissions for users on the cluster

Assign roles to grant permissions to users of service principal names (SPNs) on the cluster. Use the `az role assignment` command.

To assign roles on an AKS cluster, you must have **Owner** permission on the subscription, resource group, or cluster.

The following example uses [az role assignment](/cli/azure/role/assignment?view=azure-cli-latest&preserve-view=true) to assign the `Azure Arc Kubernetes Cluster Admin` role to the resource group that will contain the cluster. You can set the scope of the resource group before you create the cluster.

```azurecli
az role assignment create --role "Azure Arc Kubernetes Cluster Admin" --assignee xyz@contoso.com --scope /subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.Kubernetes/connectedClusters/<resource name, aka name of AKS cluster>
```

To get the scope ID for the cluster or resource group, run the following commands, and use `"id":property`:

```azurecli
az connectedk8s show -g <name of resource group>  
az connectedk8s show -n <name of cluster> -g <name of resource group>
```

For other examples, see [az role assignment](/cli/azure/role/assignment?view=azure-cli-latest&preserve-view=true).

For information about pre-built Azure RBAC roles for Arc-enabled Kubernetes clusters, see [Create role assignments for users to access a cluster](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI#create-role-assignments-for-users-to-access-the-cluster). For a list of all available built-in roles, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).

## Step 1: Create an SPN and assign permissions

Use an Azure service principal to configure an automation account with the permissions needed to create a target cluster with Azure RBAC enabled. 

Creating a target cluster only requires limited privileges on the subscription. We recommend using the **Kubernetes Cluster - Azure Arc Onboarding** role. You can also use the **Owner** or **Contributor** role. For more information, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).

Use the [`az ad sp create-for-rbac`](/cli/azure/ad/sp?view=azure-cli-latest&preserve-view=true&preserve-view=true) command in Azure CLI to create the SPN and configure it with the needed permissions.

The example command below assigns the **Kubernetes Cluster - Azure Arc Onboarding** to the subscription. For more information, see the [`az ad sp`](/cli/azure/ad/sp?view=azure-cli-latest) command reference.

```azurecli
az ad sp create-for-rbac --role "Kubernetes Cluster - Azure Arc Onboarding" --scopes /subscriptions/<OID of the SPN> 
```

In the command output, **Creating 'Kubernetes Cluster - Azure Arc Onboarding' role assignment** appears under the **/subscriptions/my-SPN-OID** scope.

> [!IMPORTANT]
> The command output for `az ad sp` includes credentials that you must protect. Do not include these credentials in your code or check the credentials into your source control. For more information, see [Create an Azure service principal](/cli/azure/create-an-azure-service-principal-azure-cli).

For more information about creating an SPN and assigning it a role, see [Create an Azure service principal](/cli/azure/create-an-azure-service-principal-azure-cli).

## Step 2: Create the credential object  

To create a credential object to use with the SPN, open a PowerShell window, and run the following command:

```powershell
$Credential = Get-Credential
```

This command prompts for a password.

To automate creation of the credential object, without requiring manual password entry, see [Get-Credential, Example 4](/powershell/module/microsoft.powershell.security/get-credential?view=powershell-7.3&preserve-view=true#example-4). The script includes a plaintext credential, which might violate security standards in some enterprises.

## Step 3: Create Azure RBAC-enabled AKS target cluster using an SPN

To create an AKS target cluster with Azure RBAC enabled using an SPN:

1. If you haven't already created an SPN to use with the target cluster, [create the SPN](/cli/azure/create-an-azure-service-principal-azure-cli) now.

1. Open a PowerShell window on the Azure HCI node or Windows server where you'll deploy the cluster, and run the following command:

   ```powershell
   New-AksHciCluster -name “<cluster name>"  -enableAzureRBAC -resourceGroup "<name of resource group>" -subscriptionID "<subscription id>" -tenantId "<tenant id>" -credential $Credential -location "eastus" -appId $SERVER_APP_ID -appSecret $SERVER_APP_SECRET -aadClientId $CLIENT_APP_ID -nodePoolName <name of node pool> 
   ```

### Step 3, Option B: Create Azure RBAC-enabled AKS target cluster interactively

If you prefer to create your Azure RBAC-enabled target cluster interactively, follow these steps:

1. Open a PowerShell window on the Azure HCI node or Windows server where you'll deploy the cluster.

1. Sign in to Azure by running the following command. using the `connect-azaccount -deviceauth` command. 

   ```powershell
   connect-azaccount -deviceauth
   ```

   The command prompts for authentication via the device code flow.

1. Set the subscription context to the subscription where the target cluster will be created:

   ```powershell
   az account set --subscription "subscriptionName"
   ```

1. Create the AKS target cluster, with Azure RBAC enabled:

   ```powershell
   New-AksHciCluster -name "<cluster name>"  -enableAzureRBAC -resourceGroup "<name of resource group>"  -location "eastus" -appId $SERVER_APP_ID -appSecret $SERVER_APP_SECRET -aadClientId $CLIENT_APP_ID -nodePoolName <name of node pool> 
   ```

## Step 4: Connect to AKS cluster via Azure RBAC

The Azure RBAC setup on the AKS cluster is now complete. To test your Azure RBAC setup, connect to the AKS cluster. Azure RBAC will authenticate the connections. 

The procedures in this section [use the `connectedk8s` proxy method to connect to an AKS cluster](#connect-to-aks-cluster-over-internet-using-connectedk8s-proxy-method) and [connect to an AKS cluster over a private network](#connect-to-aks-cluster-over-a-private-network).

### Connect to AKS cluster over Internet using `connectedk8s` proxy method

Use the `connectedk8s` proxy method to send an authentication/authorization request from anywhere on the Internet. When you use this method, you're limited to 200 groups.

To connect to an AKS cluster using the `connectedk8s` proxy method, do the following steps:

1. Open an Azure CLI window, and use`az login` to connect to Azure. For more information, see [Sign in with Azure CLI](/cli/azure/authenticate-azure-cli).

1. Set the subscription for your Azure account to the subscription you used to create the AKS cluster if needed:<!--VERIFY. Just guessing.-->

   ```azurecli
   az account set -subscription "<mySubscription>" 
   ```

1. Confirm that you're connected to Azure:

   ```azurecli
   az account show
   ```

1. Start the proxy process:

   ```azurecli
   az connectedk8s proxy -n <cluster name> -g <resource group name>
   ```

1. Make sure authentication is working correctly by sending requests to the cluster. Leaving open the terminal that you connected from, open another tab, and send the requests to the cluster. You should get responses based on your Azure RBAC configuration.

1. Press **Ctrl+C** to close the `connectedk8s` proxy connection.

### Connect to AKS cluster over a private network

When you connect to an AKS cluster over a private network, there's no limit the on number of groups you can use.

To connect to an AKS cluster over a private network, do the following steps:

1. Open a PowerShell window **WHERE? WHAT CREDENTIALS?**.

1. Download the **kubeconfig** file by running the following command:

   ```powershell
   Get-AksHciCredential -Name <cluster name> -aadauth
   ```

1. Start sending requests to AKS API server by running the `kubectl` `api-server` command. **ADD A COMMAND EXAMPLE?**

   You'll get a warning message. You can ignore it.
