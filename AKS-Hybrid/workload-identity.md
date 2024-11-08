---
title: Deploy and configure Workload Identity on an AKS enabled by Azure Arc cluster (preview)
description: Learn how to deploy and configure an AKS Arc cluster with workload identity.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 11/08/2024

---

# Deploy and configure Workload Identity on an AKS enabled by Azure Arc cluster (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

Azure Kubernetes Service (AKS) enabled by Azure Arc is a managed Kubernetes service that lets you quickly deploy and manage Kubernetes clusters. This article describes how to perform the following tasks:

- Create an AKS Arc cluster with workload identity enabled (preview).
- Create a Kubernetes service account and bind it to the Azure Managed Identity.
- Create a federated credential on the managed identity to trust the OIDC issuer.
- Optional: Grant a pod in the cluster access to secrets in an Azure key vault.
- Deploy your application.

> [!IMPORTANT]
> These preview features are available on a self-service, opt-in basis. Previews are provided "as is" and "as available," and they're excluded from the service-level agreements and limited warranty. Azure Kubernetes Service, enabled by Azure Arc previews are partially covered by customer support on a best-effort basis.

> [!NOTE]
> In public preview, AKS on Azure Stack HCI supports enabling workload identity during AKS cluster creation. However, enabling workload identity after cluster creation or disabling it afterward is currently unsupported.

## Prerequisites

Before you deploy a Kubernetes cluster with Azure Arc enabled, you must have the following prerequisites:

- If you don't have an Azure subscription, create an [Azure free account](https://azure.microsoft.com/free/?ref=microsoft.com&utm_source=microsoft.com&utm_medium=docs&utm_campaign=visualstudio) before you begin.
- This article requires version x.x.x or later of the Azure CLI. If using Azure Cloud Shell, the latest version is already installed.
- Arc K8s prerequisites: OIDC issuer.

### Export environment variables

To help simplify the steps to configure the identities required, the following commands define environment variables that are referenced in the examples in this article. Replace the following values with your own:

```azurecli
$AZSubscriptionID = "00000000-0000-0000-0000-000000000000" 
$Location = "westeurope" 
$resource_group_name = "myResourceGroup" 

$aks_cluster_name = "myAKSCluster" 

$SERVICE_ACCOUNT_NAMESPACE = "default" 
$SERVICE_ACCOUNT_NAME = "workload-identity-sa" 

$FedIdCredentialName = "myFedIdentity" 
$MSIName = "myIdentity" 

# Azure Resource Manager ID of the custom location, set up during the Azure Stack HCI cluster deployment 
$customlocation_ID = $(az customlocation show --name "<your-custom-location-name>" --resource-group $resource_group_name --query "id" -o tsv) 

# Azure Resource Manager ID of the logical network on Azure Stack HCI 
$logicnet_Id = $(az stack-hci-vm network lnet show --name "<your-lnet-name>" --resource-group $resource_group_name --query "id" -o tsv)

# Include these variables to access key vault secrets from a pod in the cluster
$KVName = "KV-workload-id" 
$KVSecretName= "KV-secret"
```

### Set the active subscription

First, set your subscription as the current active subscription. Run the [az account set](/cli/azure/account?view=azure-cli-latest#az-account-set) command with your subscription ID:

```azurecli
az login  
az account set -s $AZSubscriptionID
```

### Create a resource group

An [Azure resource group](/azure/azure-resource-manager/management/overview) is a logical group in which Azure resources are deployed and managed. When you create a resource group, you're prompted to specify a location. This location is the storage location of your resource group metadata and where your resources run in Azure if you don't specify another region during resource creation.

To create a resource group, run the [az group create](/cli/azure/group#az-group-create) command:

```azurecli
az group create --name $resource_group_name --location $Location
```

The following example output shows the successful creation of a resource group:

```json
{ 
  "id": "/subscriptions/<guid>/resourceGroups/myResourceGroup", 
  "location": "westeurope", 
  "managedBy": null, 
  "name": "$resource_group_name", 
  "properties": { 
    "provisioningState": "Succeeded" 
  }, 
  "tags": null 
}
```

## Step 1: Create an AKS Arc cluster with workload identity enabled

To create an AKS Arc cluster, run the [az aksarc create](/cli/azure/aksarc?view=azure-cli-latest#az-aksarc-create) command with the `--enable-oidc-issuer --enable-workload-identity` parameter. Ensure you're a member of the Microsoft Entra ID admin group for proxy mode access:

```azurecli
az aksarc create  
-n $aks_cluster_name -g $resource_group_name  
--custom-location $customlocation_ID --vnet-ids $logicnet_Id  
--aad-admin-group-object-ids <entra-admin-group-object-ids> 
--generate-ssh-keys  
--enable-oidc-issuer --enable-workload-identity
```

After a few minutes, the command completes and returns JSON-formatted information about the cluster.

It might take some time for the workload identity extension to be deployed after successfully creating a provisioned cluster. Use the following command to check the workload identity extension status:

```azurecli
az connectedk8s show -n $aks_cluster_name -g $resource_group_name
```

```json
# agentState = "Succeeded" 
"agentPublicKeyCertificate": "", 
  "agentVersion": "1.21.10", 
  "arcAgentProfile": { 
    "agentAutoUpgrade": "Enabled", 
    "agentErrors": [], 
    "agentState": "Succeeded", 
    "desiredAgentVersion": "", 
    "systemComponents": null 

# oidcIssuerProfile "enabled": true and "issuerUrl" present 

"oidcIssuerProfile": { 
    "enabled": true, 
    "issuerUrl": "https://oidcdiscovery-{location}-endpoint-1111111111111111.000.azurefd.net/00000000-0000-0000-0000-000000000000/11111111-1111-1111-1111-111111111111/"}
```

In the Azure portal, you can view the **wiextension** extension under the **Properties** section of your Kubernetes cluster.

> [!IMPORTANT]
> Once workload identity is enabled on AKS Arc clusters, the Kubernetes service account token automatically rotates every 90 days as a security best practice. Previously, by default these tokens were set to be valid for one year. With this token rotation enhancement, the maximum token expiry is reduced to 24 hours.

### Save the OIDC issuer URL to an environment variable

Once AKS cluster is created successfully, you can get the OIDC issuer URL and save it to an environment variable. Run the following command:

```azurecli
$SERVICE_ACCOUNT_ISSUER =$(az connectedk8s show --n $aks_cluster_name --resource-group $resource_group_name --query "oidcIssuerProfile.issuerUrl" --output tsv)
```

## Step 2: Create a Kubernetes service account and bind it to the Azure Managed Identity

First, create a managed identity. Run the [az identity create](/cli/azure/identity#az-identity-create) command:

```azurecli
az identity create --name $MSIName --resource-group $resource_group_name --location $Location --subscription $AZSubscriptionID
```

Next, create variables for the managed identity's client ID:

```azurecli
$MSIId=$(az identity show --resource-group $resource_group_name --name $MSIName --query 'clientId' --output tsv)
$MSIPrincipalId=$(az identity show --resource-group $resource_group_name --name $MSIName --query 'principalId' --output tsv)
```

### Create a Kubernetes service account

Create a Kubernetes service account and annotate it with the client ID of the managed identity created in the previous step:

```azurecli
az connectedk8s proxy -n $aks_cluster_name -g $resource_group_name
```

Open a new window. Copy and paste the following CLI commands:

```azurecli
$yaml = @" apiVersion: v1 kind: ServiceAccount metadata: annotations: azure.workload.identity/client-id: $MSIId name: $SERVICE_ACCOUNT_NAME namespace: $SERVICE_ACCOUNT_NAMESPACE "@ $yaml = $yaml -replace '\$MSIId', $MSIId ` -replace '\$SERVICE_ACCOUNT_NAME', $SERVICE_ACCOUNT_NAME ` -replace '\$SERVICE_ACCOUNT_NAMESPACE', $SERVICE_ACCOUNT_NAMESPACE $yaml | kubectl apply -f -
```

The following output shows successful creation of the workload identity:

```output
serviceaccount/workload-identity-sa created
```

## Step 3: Create a federated credential on the managed identity to trust the OIDC issuer

First, create a federated identity credential. Call the [az identity federated-credential create](/cli/azure/identity/federated-credential#az-identity-federated-credential-create) command
to create the federated identity credential between the managed identity, the service account issuer, and the subject. For more information about federated identity credentials in Microsoft Entra,
see [Overview of federated identity credentials in Microsoft Entra ID](/graph/api/resources/federatedidentitycredentials-overview).

<table>
<tbody>
<tr class="odd">
<td><p><strong>Azure CLI</strong></p>
<p># Create a federated credential</p>
<p>az identity federated-credential create --name $FedIdCredentialName --identity-name $MSIName --resource-group $resource_group_name --issuer $SERVICE_ACCOUNT_ISSUER --subject "system:serviceaccount:${SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}"</p>
<p># Show the federated credential</p>
<p>az identity federated-credential show --name $FedIdCredentialName --resource-group $resource_group_name --identity-name $MSIName</p></td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr class="odd">
<td><p><strong>Note</strong></p>
<p>After adding a federated identity credential, it takes a few seconds to propagate. Token requests made immediately afterward might fail until the cache refreshes. To prevent this issue, consider adding a brief delay after creating the federated identity credential.</p></td>
</tr>
</tbody>
</table>

## Optional: Grant permissions to access Azure Key Vault

The instructions in this step show how to access secrets, keys, or
certificates in an Azure key vault from the pod. The examples in this
section configure access to secrets in the key vault for the workload
identity, but you can perform similar steps to configure access to keys
or certificates.

The following example shows how to use the Azure role-based access
control (Azure RBAC) permission model to grant the pod access to the key
vault. For more information about the Azure RBAC permission model for
Azure Key Vault, see [Grant permission to applications to access an
Azure key vault using Azure
RBAC](/azure/key-vault/general/rbac-guide).

1.  Create a key vault with purge protection and RBAC authorization
    enabled. You can also use an existing key vault if it is configured
    for both purge protection and RBAC authorization:

<table>
<tbody>
<tr class="odd">
<td><p><strong>Azure CLI</strong></p>
<p>az keyvault create --name $KVName --resource-group $resource_group_name --location $Location --enable-purge-protection --enable-rbac-authorization</p>
<p><strong># retrieve the Key Vault ID for role assignment</strong></p>
<p>$KVId=$(az keyvault show --resource-group $resource_group_name --name $KVName --query id --output tsv)</p></td>
</tr>
</tbody>
</table>

2.  Assign yourself the RBAC [Key Vault Secrets
    Officer](/azure/role-based-access-control/built-in-roles/security#key-vault-secrets-officer) role
    so that you can create a secret in the new key vault. New role
    assignments can take up to five minutes to propagate and be updated
    by the authorization server.

<table>
<tbody>
<tr class="odd">
<td><p><strong>Azure CLI</strong></p>
<p>az role assignment create --assignee-object-id $MSIPrincipalId --role "Key Vault Secrets Officer" --scope $KVId --assignee-principal-type ServicePrincipal</p></td>
</tr>
</tbody>
</table>

3.  Create a secret in the key vault:

<table>
<tbody>
<tr class="odd">
<td><p><strong>Azure CLI</strong></p>
<p>az keyvault secret set --vault-name $KVName --name $KVSecretName --value "Hello!"</p></td>
</tr>
</tbody>
</table>

4.  Assign the [Key Vault Secrets
    User](/azure/role-based-access-control/built-in-roles/security#key-vault-secrets-user) role
    to the user-assigned managed identity that you created previously.
    This step gives the managed identity permission to read secrets from
    the key vault:

<table>
<tbody>
<tr class="odd">
<td><p><strong>Azure CLI</strong></p>
<p>az role assignment create --assignee-object-id $MSIPrincipalId --role "Key Vault Secrets User" --scope $KVId --assignee-principal-type ServicePrincipal</p></td>
</tr>
</tbody>
</table>

5.  Create an environment variable for the key vault URL:

<table>
<tbody>
<tr class="odd">
<td><p><strong>Azure CLI</strong></p>
<p>$KVUrl=$(az keyvault show --resource-group $resource_group_name --name $KVName --query properties.vaultUri --output tsv)</p></td>
</tr>
</tbody>
</table>

6.  Deploy a pod that references the service account and key vault URL:

<table>
<tbody>
<tr class="odd">
<td><p><strong>Azure CLI</strong></p>
<p>$yaml = @"</p>
<p>apiVersion: v1</p>
<p>kind: Pod</p>
<p>metadata:</p>
<p>name: sample-quick-start</p>
<p>namespace: $SERVICE_ACCOUNT_NAMESPACE</p>
<p>labels:</p>
<p>azure.workload.identity/use: "true"</p>
<p>spec:</p>
<p>serviceAccountName: $SERVICE_ACCOUNT_NAME</p>
<p>containers:</p>
<p>- image: ghcr.io/azure/azure-workload-identity/msal-go</p>
<p>name: oidc</p>
<p>env:</p>
<p>- name: KEYVAULT_URL</p>
<p>value: $KVUrl</p>
<p>- name: SECRET_NAME</p>
<p>value: $KVSecretName</p>
<p>nodeSelector:</p>
<p>kubernetes.io/os: linux</p>
<p>"@</p>
<p># Replace variables within the YAML content</p>
<p>$yaml = $yaml -replace '\$SERVICE_ACCOUNT_NAMESPACE', $SERVICE_ACCOUNT_NAMESPACE `</p>
<p>-replace '\$SERVICE_ACCOUNT_NAME', $SERVICE_ACCOUNT_NAME `</p>
<p>-replace '\$KVUrl', $KVUrl `</p>
<p>-replace '\$KVSecretName', $KVSecretName</p>
<p># Apply the YAML configuration</p>
<p>$yaml | kubectl --kubeconfig $aks_cluster_name apply -f -</p></td>
</tr>
</tbody>
</table>

## Step 4 Deploy your application

When you deploy your application pods, the manifest should reference the
service account created in the **Create Kubernetes service
account** step. The following manifest shows how to reference the
account, specifically
the *metadata\\namespace* and *spec\\serviceAccountName* properties.
Make sure to specify an image for &lt;image&gt; and a container name
for &lt;containerName&gt;:

<table>
<tbody>
<tr class="odd">
<td><p><strong>Azure CLI</strong></p>
<p>$image = "&lt;image&gt;" # Replace &lt;image&gt; with the actual image name</p>
<p>$containerName = "&lt;containerName&gt;" # Replace &lt;containerName&gt; with the actual container name</p>
<p>$yaml = @"</p>
<p>apiVersion: v1</p>
<p>kind: Pod</p>
<p>metadata:</p>
<p>name: sample-quick-start</p>
<p>namespace: $SERVICE_ACCOUNT_NAMESPACE</p>
<p>labels:</p>
<p>azure.workload.identity/use: "true" # Required. Only pods with this label can use workload identity.</p>
<p>spec:</p>
<p>serviceAccountName: $SERVICE_ACCOUNT_NAME</p>
<p>containers:</p>
<p>- image: $image</p>
<p>name: $containerName</p>
<p>"@</p>
<p># Replace variables within the YAML content</p>
<p>$yaml = $yaml -replace '\$SERVICE_ACCOUNT_NAMESPACE', $SERVICE_ACCOUNT_NAMESPACE `</p>
<p>-replace '\$SERVICE_ACCOUNT_NAME', $SERVICE_ACCOUNT_NAME</p>
<p># Apply the YAML configuration</p>
<p>$yaml | kubectl apply -f -</p></td>
</tr>
</tbody>
</table>

<table>
<tbody>
<tr class="odd">
<td><p><strong>Important</strong></p>
<p>Ensure that the application pods using workload identity include the label azure.workload.identity/use: "true" in the pod spec. Otherwise the pods will fail after they are restarted.</p></td>
</tr>
</tbody>
</table>

## Next steps

In this article, you deployed a Kubernetes cluster and configured it to
use a workload identity in preparation for application workloads to
authenticate with that credential. Now you're ready to deploy your
application and configure it to use the workload identity with the
latest version of the [Azure Identity](/azure/active-directory/develop/reference-v2-libraries) client
library.

- [Deploy and configure an AKS cluster with workload identity - Azure
    Kubernetes Service \| Microsoft
    Learn](/azure/aks/workload-identity-deploy-cluster)

