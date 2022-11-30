---
title: "Azure RBAC with Azure AD identify for AKS hybrid (Preview)"
services: azure-arc
ms.service: azure-arc
ms.date: 11/18/2022
ms.topic: how-to
description: "Use Azure RBAC with Azure AD identify for AKS hybrid."
---

# Azure RBAC with Azure AD identity for AKS hybrid (Preview)

A conceptual overview is available in [Azure RBAC on Azure Arc-enabled Kubernetes](conceptual-azure-rbac.md).  
 
## Prerequisites

Before deploying an Azure Arc enabled AKS Hybrid cluster, the following prerequisites must be met:

1. The following network, proxy and/or firewall requirements are met:

   - These [end points](quickstart-connect-cluster.md#meet-network-requirements) must be accessible from your network.  
   - Allow the https://graph.microsoft.com endpoint in your proxy or firewall. For more information, see [Proxy server settings](/azure/aks/hybrid/set-proxy-settings).

1. Next, follow the steps below to register server app and secret, client app and secret. This requires the [Application Administrator role](/azure/active-directory/roles/permissions-reference), which is a built-in Azure Active Directory (Azure AD) role. To find out how to assign the Application Administrator role, see [Assign Azure AD roles to users](/azure/active-directory/roles/manage-roles-portal).

   1. [Create a server app and shared secret](azure-rbac.md?tabs=AzureCLI#CLIcreate-a-server-application).

   2. [Create a role assignment for the server app](azure-rbac.md?tabs=AzureCLI#create-a-role-assignment-for-the-server-application).

   3. [Create a client application](azure-rbac.md?tabs=AzureCLI#create-a-client-application). The client app is referenced when connecting using `kubectl` within your network.<!--Work on wording of final sentence.-->

1. Assign permissions to users (User Principlal Names, or UPNs) on service principal names (SPNs) on the cluster by assigning roles using [az role assignment](/cli/azure/role/assignment?view=azure-cli-latest&preserve-view=true to the URL). To assign roles to the AKS hybrid cluster, you must have Owner permission<!--Is this a permission?--> on the subscription, resource group, or cluster (after you create the cluster).

   The following example uses [az role assignment](/cli/azure/role/assignment?view=azure-cli-latest&preserve-view=true to the URL) to assign the role to the resource group that the cluster will belong to.

   ```azurecli
   az role assignment create --role "Azure Arc Kubernetes Cluster Admin" --assignee xyz@contoso.com --scope /subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.Kubernetes/connectedClusters/<resource name aka name of AKS Hybrid Cluster>
   ```

   Considerations:
   - You can set the scope on the resource group before you create the cluster.
   - To get the scope ID for the cluster or resource group, run the following commands, and use `"id":property`<!--What does this mean?-->:

     ```azurecli
     az connectedk8s show -g <name of resource group>  
     az connectedk8s show -n <name of cluster> -g <name of resource group>
     ```

   - For information about pre-built Arc-enabled Kubernetes Azure RBAC roles, see [Create role assignments for users to access a cluster](azure-rbac.md?tabs=AzureCLI#create-role-assignments-for-users-to-access-the-cluster).

   - For a list of available built-in roles, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).  

## Create an SPN and assign permissions

Follow these steps to create an SPN and assign it permissions <!--MEANING?--to create an Azure RBAC-enabled target cluster in AKS hybrid-->:

To set up an automation account to create target clusters that are Azure RBAC-enabled in AKS hybrid, use an Azure service principal.

The command used to do that is: az ad sp create-for-rbac, this command To create a service principal and configure it with the required permission for creating an Azure RBAC-enabled AKS hybrid cluster, use the `az ad sp create-for-rbac` command. For command information, see [az ad sp](/cli/azure/ad/sp?view=azure-cli-latest&preserve-view=true) to the URL).

Creating a target cluster doesn't require high privilege on the subscription. We recommend using the **Kubernetes Cluster - Azure Arc Onboarding** role. You can also use the **Owner** or **Contributor** role. For more information, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).

Example (Azure CLI):

```azurecli
az ad sp create-for-rbac --role "Kubernetes Cluster - Azure Arc Onboarding" --scopes /subscriptions/< OID of the SPN > 
```

For more information about creating an SPN and assigning it a role, see [Create an Azure service principal](/cli/azure/create-an-azure-service-principal-azure-cli).

The output of this command will be "Creating 'Kubernetes Cluster - Azure Arc Onboarding' role assignment" under the **/subscriptions/<OID pf the SPN** scope.

The output includes credentials that you must protect. Be sure not to include these credentials in your code or check the credentials into your source control. For more information, see [Create an Azure service principal](/cli/azure/create-an-azure-service-principal-azure-cli).

## Create the credential object  

Open a PowerShell window, and run the following command:

```powershell
$Credential = Get-Credential
```

The command prompts for a password.

For automation scripts, see [Get-Credential, Example 4](/powershell/module/microsoft.powershell.security/get-credential?view=powershell-7.3&preserve-view=true to the URL#example-4).

## Create Azure RBAC-enabled AKS target cluster using an SPN

Before you can create the AKS target cluster, you must [Create an SPN](/cli/azure/create-an-azure-service-principal-azure-cli).

To creata an Azure RBAC-enabled target cluster in AKS hybrid, open a PowerShell window, and run the following command. The command must be executed on the Azure HCI node or Windows server where target you'll deploy the cluster.

```powershell
New-AksHciCluster -name “<cluster name>"  -enableAzureRBAC -resourceGroup "<name of resource group>" -subscriptionID "<subscription id>" -tenantId "<tenant id>" -credential $Credential -location "eastus" -appId $SERVER_APP_ID -appSecret $SERVER_APP_SECRET -aadClientId $CLIENT_APP_ID -nodePoolName <name of node pool> 
```

## Create Azure RBAC-enabled AKS target cluster interactively

To create your Azure RBAC-enabled target cluster interactively, run this command in a PowerShell session on the Azure HCI node or Windows server where you'll deploy the cluster:

```powershell
New-AksHciCluster -name "<cluster name>"  -enableAzureRBAC -resourceGroup "<name of resource group>"  -location "eastus" -appId $SERVER_APP_ID -appSecret $SERVER_APP_SECRET -aadClientId $CLIENT_APP_ID -nodePoolName <name of node pool> 
```

1. Run this command in PowerShell on the Azure HCI node or Windows server where you'll deploy the cluster.

2. Sign in to Azure via PowerShell using the `connect-azaccount -deviceauth` command. The command prompts for authentication via the device code flow.

3. Set subscription context to the subscription where the target cluster will be created by running this command:

   ```powershell
   az account set --subscription "subscriptionName"
   ```

## Connect to the AKS cluster via Azure RBAC from the Internet via connectedk8s

> [!NOTE]
> Currently, there is a limitation on supporting users limited to less than 200 groups.<!--Clarify the limit. Probably shouldn't be a note.-->

Use the `connectedk8s` proxy method to send an authentication/authorization request from anywhere on the Internet.

1. Open an Azure CLI window, use `az login` to connect to Azure:

   ```azurecli
   az account set -subscription "mySubscription" 
   ```

1. To confirm you're connected to Azure, run `az account show`.

1. Start the proxy process by running the following command:

   ```azurecli
   az connectedk8s proxy -n <cluster name> -g <resource group name>
   ```

1. Leaving the terminal where you connected from open, open another tab, and start sending requests to the cluster. You will get response based on your Azure RBAC configurations.<!--1) A picture might help - or be more specific about where they open the tab. 2) What command do they run to send a request?-->

1. Press **Ctrl+C** to close the `connectedk8s` proxy connection.

## Connect to the AKS hybrid cluster via a private network

There is no limit the on number of groups when you use this method.

1. Download the kubeconfig file by running the following command:

   ```powershell
   Get-AksHciCredential -Name <cluster name> -aadauth
   ```

1. Start sending requests to AKS hybrid by running this `kubectl` command: `api-server`.

   You'll get a warning message. You can ignore it.
