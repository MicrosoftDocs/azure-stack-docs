---
title: "How to Configure Network TAP Rules with User Assigned Managed Identity (UAMI) in Azure Operator Nexus"
description: Learn the process for configuring Network TAP Rules with User Assigned Managed Identity (UAMI) in Azure Operator Nexus.
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 09/26/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

# How to Configure Network TAP Rules with User Assigned Managed Identity (UAMI) in Azure Operator Nexus

## Overview 

Network TAP Rules can be configured inline or file-based (using a rules file URL). When configured with UAMI, the TAP rule uses identity-based access to dependent Azure services (such as the storage account hosting the rules file). When a UAMI is associated with a Network TAP Rule, the rule uses Azure Managed Identity authentication to access required Azure services (for example, Storage Accounts), aligning TAP workflows with Trusted Microsoft Services. 

Once a Network TAP Rule is configured with UAMI: 
- Authentication transitions permanently to identity based access. 
- IP based allow lists and first party application identities are no longer used. 
- Existing traffic behavior remains unchanged, provided the configuration content doesn't change. 
- If a UAMI isn't patched to the Network TAP rule resource, the rule continues to use first party app–based access.
- Reverting a Network TAP Rule from UAMI back to first party application access isn't supported. 

## Prerequisites 

- A Network Fabric is provisioned and unlocked. 
- You're using the GA API version 2025-07-15 and Nexus Network Fabric (NNF) release 10.1 or later. 
- A User Assigned Managed Identity (UAMI) exists. 
- The storage account that hosts the rules file has Trusted Microsoft Services enabled, and the UAMI has the required RBAC permissions (for example, Storage Blob Data Reader). 
- Azure CLI has the managednetworkfabric extension V9.0.0  available. 

## Configure a Network TAP Rule with UAMI 

### 1. Create or patch a file-based Network TAP Rule with UAMI  
 
 ```AzCLI
az networkfabric taprule create \ 
  --resource-group myResourceGroup \ 
  --resource-name myTapRuleWithMSI \ 
  --polling-interval-in-seconds 30 \ 
  --configuration-type "File" \ 
  --tap-rules-url "https://mystorage.blob.core.windows.net/config/taprule.json" \ 
  --location eastus \ 
  --user-assigned "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/identityRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/tapRuleIdentity" \ 
  --identity-selector '{"identityType":"UserAssignedIdentity","userAssignedIdentityResourceId":"/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/identityRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/tapRuleIdentity"}'
```

Output  

```
{ 
  "administrativeState": "Disabled", 
  "configurationState": "Succeeded", 
  "configurationType": "File", 
  "id": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkTapRules/myTapRuleWithMSI", 
  "identity": { 
    "type": "UserAssigned", 
    "userAssignedIdentities": { 
      "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/identityRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/tapRuleIdentity": { 
        "clientId": "e4382d3c-40c7-4836-9811-ad0f929a1c83", 
        "principalId": "92f5f45c-bf76-428d-a396-d74d01eab20d" 
      } } }, 

  "identitySelector": { 

    "identityType": "UserAssignedIdentity", 
    "userAssignedIdentityResourceId": "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/identityRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/tapRuleIdentity" }, 
  "location": "eastus", 
  "name": "myTapRuleWithMSI", 
  "pollingIntervalInSeconds": 30, 
  "provisioningState": "Succeeded", 
  "resourceGroup": "myResourceGroup", 
  "tapRulesUrl": "https://mystorage.blob.core.windows.net/config/taprule.json", 
  "type": "microsoft.managednetworkfabric/networktaprules"} 
```


### 2. Apply the change (resync) 

```AzCLI
az networkfabric taprule resync \ 
  --resource-group "example-rg" \ 
  --resource-name "example-networktaprule" 
```

### 3. Verify the configuration 

```AzCLI
az networkfabric taprule show \ 
  --resource-group "example-rg" \ 
  --resource-name "example-networktaprule" \
```

## Troubleshooting 

If following issues occur, use provided mitigation steps: 

### 1. Identity Doesn't Exist in ARM - Referencing a nonexistent User-Assigned Managed Identity 

Command:
```AzCLI
az networkfabric taprule create \
  --resource-group myResourceGroup \
  --resource-name myTapRuleWithMSI \
  --polling-interval-in-seconds 30 \
  --configuration-type "File" \
  --tap-rules-url "https://mystorage.blob.core.windows.net/config/taprule.json" \
  --location eastus \
  --user-assigned "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/identityRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/nonExistentIdentity" \
  --identity-selector '{"identityType":"UserAssignedIdentity","userAssignedIdentityResourceId":"/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/identityRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/nonExistentIdentity"}'
```

Error Output:
```
{
  "error": {
    "code": "FailedIdentityOperation",
    "message": "Identity operation for resource '/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myResourceGroup/providers/Microsoft.ManagedNetworkFabric/networktaprules/myTapRule' failed with error 'Failed to perform resource identity operation. Status: 'BadRequest'. Response: '{\"error\":{\"code\":\"BadRequest\",\"message\":\"Resource '/subscriptions/.../nonExistentIdentity' was not found.\"}}''."
  }
}
```

Remedy:
1. Verify the UAMI resource ID is correct
2. Ensure the UAMI exists in the specified subscription and resource group
3. Check that you read access to the UAMI resource


### 2. Identity Mismatch in Selector - UAMI in identitySelector differs from identity.userAssignedIdentities

Command:
```AzCLI
az networkfabric taprule create \
  --resource-group myResourceGroup \
  --resource-name myTapRuleWithMSI \
  --polling-interval-in-seconds 30 \
  --configuration-type "File" \
  --tap-rules-url "https://mystorage.blob.core.windows.net/config/taprule.json" \
  --location eastus \
  --user-assigned "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/identityRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/existentIdentity1" \
  --identity-selector '{"identityType":"UserAssignedIdentity","userAssignedIdentityResourceId":"/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/identityRG/providers/Microsoft.ManagedIdentity/userAssignedIdentities/existentIdentity2"}'
  ```

Error Output:
```
{
  "error": {
    "code": "ResourceCreationValidateFailed",
    "message": "UAMI mentioned under identitySelector should be part of UAMIs under identity."
  }
}
```

Remedy:
1. Ensure identitySelector.userAssignedIdentityResourceId matches a key in identity.userAssignedIdentities
2. Verify the resource ID format and casing are exactly correct


### 3. Missing RBAC Permissions- UAMI lacks required permissions on storage account

Error Output:
```
{
  "error": {
    "code": "BadRequest",
    "message": "Blob Storage URL https://mystorage.blob.core.windows.net/config/taprule.json processing failed for networktaprules due to error : Service request failed. Status: 403 (This request is not authorized to perform this operation using this permission.) ErrorCode: AuthorizationPermissionMismatch"
  }
}
```
Logs:
```
Headers:
Transfer-Encoding: chunked
Server: Windows-Azure-Blob/1.0 Microsoft-HTTPAPI/2.0
x-ms-request-id: 69f50b64-c01e-0035-0d93-52a9bd000000
x-ms-error-code: AuthorizationPermissionMismatch
```

Remedy:
1. Grant "Storage Blob Data Reader" role to the UAMI on the storage account
2.  Verify role assignment propagation (can take up to 5 minutes)
3.  Ensure the storage account allows trusted Microsoft services

Required RBAC Assignment:
```AzCLI
az role assignment create \
  --assignee "<UAMI-principal-id>" \
  --role "Storage Blob Data Reader" \
  --scope "/subscriptions/.../resourceGroups/<rg>/providers/Microsoft.Storage/storageAccounts/mystorage"
```


### 4. Blob Not Found - Referenced blob doesn't exist or incorrect URL

Error Output:
```
{
  "error": {
    "code": "BadRequest",
    "message": "Blob Storage URL https://mystorage.blob.core.windows.net/config/nonexistent.json processing failed for networktaprules due to error : Blob not found."
  }
}
```

Common Causes:
- Typo in blob name or path
- Case sensitivity issues
- Blob was deleted after URL was configured
- Container doesn't exist

Remedy:
1. Verify blob exists using Azure Storage Explorer or CLI
2. Check blob name case sensitivity
3. Ensure container exists and is accessible
4. Validate the complete URL format


### 5. Storage Account Network Restrictions - Storage account has network restrictions but trusted services not enabled

Error Output:
```
{
  "error": {
    "code": "BadRequest",
    "message": "Blob Storage URL processing failed due to network access restrictions."
  }
}
```
Remedy:
1. Enable "Allow trusted Microsoft services" in storage account networking settings
2. Alternative: Add NNF-RP service endpoints to allowed networks (not recommended)

Storage Account Configuration:
```AzCLI
az storage account update \
  --name "mystorage" \
  --resource-group "storageRG" \
  --bypass "AzureServices"
```


### 6. Insufficient User Permissions on Managed Identity - User creating NetworkTapRule lacks "Managed Identity Operator" role on UAMI

Error Output:
```
{
  "error": {
    "code": "LinkedAuthorizationFailed",
    "message": "The client 'user@domain.com' with object id '84ecf60c-f987-4b80-bdb2-c045055da868' has permission to perform action 'Microsoft.ManagedNetworkFabric/networkTapRules/write' on scope '/subscriptions/.../networkTapRules/myTapRule'; however, it does not have permission to perform action(s) 'Microsoft.ManagedIdentity/userAssignedIdentities/assign/action' on the linked scope(s) '/subscriptions/.../userAssignedIdentities/tapRuleIdentity'."
  }
}
```

Remedy:
1. Grant "Managed Identity Operator" role to the user on the UAMI
2. Use a service principal with appropriate permissions

Role Assignment:
```AzCLI
az role assignment create \
  --assignee "user@domain.com" \
  --role "Managed Identity Operator" \
  --scope "/subscriptions/.../userAssignedIdentities/tapRuleIdentity"
```
