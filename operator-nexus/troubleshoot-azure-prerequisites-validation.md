---
title: Troubleshoot Azure prerequisites validation for Azure Operator Nexus clusters
description: Learn how to diagnose and resolve Azure prerequisites validation failures for cluster deployment and upgrades.
author: gregoberfield
ms.author: goberfield
ms.service: azure-operator-nexus
ms.topic: troubleshooting
ms.date: 11/09/2026
ms.custom: troubleshooting
ai-usage: ai-assisted
---

# Troubleshoot Azure prerequisites validation for Azure Operator Nexus clusters

This article helps you diagnose and resolve Azure prerequisites validation failures that can block cluster deployment or runtime upgrades.

## Overview

Azure Operator Nexus validates that user-provided Azure resources are accessible before proceeding with cluster deployment or runtime upgrades. This validation ensures the cluster can successfully use:

- **Log Analytics Workspace**: For software extension installation and metrics collection
- **Storage Account**: For storing run command output
- **Key Vault**: For credential rotation and secret storage

If validation fails, the deployment or upgrade action doesn't proceed until you resolve the issue.

> [!IMPORTANT]
> Azure prerequisites validation is available starting with API version **2025-02-01**. For clusters using earlier API versions, resources are validated when first accessed during deployment, which can cause failures later in the deployment process.

## Check validation status

### Using the Azure portal

1. Navigate to your Operator Nexus Cluster resource in the Azure portal.
2. Select **Resource JSON** or **Export template** to view the cluster properties.
3. Look for the `conditions` array and find the `AzurePrerequisitesReady` condition.
4. A `status` of `True` indicates all resources are validated. A `status` of `False` indicates a validation failure.

### Using Azure CLI

```azurecli
az networkcloud cluster show \
  --name <cluster-name> \
  --resource-group <resource-group> \
  --query "conditions[?contains(type, 'AzurePrerequisitesReady')]"
```

Example output for a successful validation:

```json
[
  {
    "type": "AzurePrerequisitesReady",
    "status": "True",
    "lastTransitionTime": "2026-01-15T10:30:00Z",
    "reason": "ValidationPassed",
    "message": "{\"schemaVersion\":\"v1\",\"lastValidated\":\"2026-01-15T10:30:00Z\",...}"
  }
]
```

Example output for a failed validation:

```json
[
  {
    "type": "AzurePrerequisitesReady",
    "status": "False",
    "lastTransitionTime": "2026-01-15T10:30:00Z",
    "reason": "ValidationFailed",
    "message": "{\"schemaVersion\":\"v1\",\"errors\":[{\"code\":\"KeyVaultAccessDenied\",\"message\":\"...\",\"remediation\":\"...\"}]}"
  }
]
```

### Check individual resource conditions

For more detailed information, check the individual resource conditions:

```azurecli
# Log Analytics Workspace validation
az networkcloud cluster show \
  --name <cluster-name> \
  --resource-group <resource-group> \
  --query "conditions[?contains(type, 'AzureLogAnalyticsReady')]"

# Storage Account validation
az networkcloud cluster show \
  --name <cluster-name> \
  --resource-group <resource-group> \
  --query "conditions[?contains(type, 'AzureCommandOutputReady')]"

# Key Vault validation
az networkcloud cluster show \
  --name <cluster-name> \
  --resource-group <resource-group> \
  --query "conditions[?contains(type, 'AzureSecretArchiveReady')]"
```

## Log Analytics Workspace validation errors

The following table lists error codes for Log Analytics Workspace validation failures:

| Error code                                       | Description                                                          | Remediation                                                                                                                                          |
|--------------------------------------------------|----------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| `LogAnalyticsWorkspaceIdMissing`                 | The workspace ID wasn't provided in `analyticsOutputSettings`.       | Set `analyticsOutputSettings.analyticsWorkspaceId` to the full ARM resource ID of your Log Analytics Workspace.                                      |
| `LogAnalyticsWorkspaceIdInvalid`                 | The workspace ID isn't a valid ARM resource ID.                      | Verify the format: `/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.OperationalInsights/workspaces/{name}`                              |
| `LogAnalyticsWorkspaceNotFound`                  | The specified workspace doesn't exist.                               | Verify the workspace exists in your subscription and the resource ID is correct.                                                                     |
| `LogAnalyticsWorkspaceAccessDenied`              | The managed identity lacks permissions on the workspace.             | Assign the `Log Analytics Contributor` role to the managed identity on the workspace.                                                                |
| `LogAnalyticsWorkspaceIdentityMissing`           | No identity is configured for workspace access.                      | Set `analyticsOutputSettings.identityType` and `identityResourceId` (for user-assigned managed identity).                                            |
| `LogAnalyticsWorkspaceIdentityTypeInvalid`       | The identity type specified isn't recognized.                        | Use `SystemAssignedIdentity` or `UserAssignedIdentity` for the identity type.                                                                        |
| `LogAnalyticsWorkspaceIdentityResourceIdMissing` | User-assigned identity was specified but the resource ID is missing. | Provide the `identityResourceId` when using `UserAssignedIdentity`.                                                                                  |
| `LogAnalyticsWorkspaceIdentityResourceIdInvalid` | The user-assigned identity resource ID is malformed.                 | Verify the identity resource ID format: `/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{name}` |
| `LogAnalyticsWorkspaceCredentialsFetchFailed`    | Failed to retrieve workspace credentials.                            | Ensure the workspace exists and the managed identity has `Log Analytics Contributor` permissions.                                                    |
| `LogAnalyticsWorkspaceRequestTimeout`            | The request to Azure timed out.                                      | Retry the operation. If the timeout persists, check network connectivity or Azure service health.                                                    |
| `LogAnalyticsWorkspaceRequestThrottled`          | The request was throttled by Azure.                                  | Wait a few minutes and retry. Consider reducing request frequency.                                                                                   |
| `LogAnalyticsWorkspaceServiceUnavailable`        | The Log Analytics service is temporarily unavailable.                | Wait and retry. Check [Azure Status](https://status.azure.com/) for service health.                                                                  |

### Resolve Log Analytics Workspace permissions

To assign the required role:

```azurecli
# Get the managed identity principal ID
PRINCIPAL_ID=$(az networkcloud cluster show \
  --name <cluster-name> \
  --resource-group <resource-group> \
  --query "identity.principalId" -o tsv)

# Assign Log Analytics Contributor role
az role assignment create \
  --assignee $PRINCIPAL_ID \
  --role "Log Analytics Contributor" \
  --scope "/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.OperationalInsights/workspaces/{workspace-name}"
```

## Storage Account validation errors

The following table lists error codes for Storage Account (blob container) validation failures:

| Error code                               | Description                                                          | Remediation                                                                                                  |
|------------------------------------------|----------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------|
| `BlobContainerUrlMissing`                | The container URL wasn't provided in `commandOutputSettings`.        | Set `commandOutputSettings.containerUrl` to your blob container URL.                                         |
| `BlobContainerUrlInvalid`                | The container URL format is incorrect.                               | Use format: `https://{account}.blob.core.windows.net/{container}`                                            |
| `BlobContainerNotFound`                  | The specified container doesn't exist.                               | Create the blob container in your storage account before deploying the cluster.                              |
| `BlobContainerAccessDenied`              | The managed identity lacks permissions on the container.             | Assign the `Storage Blob Data Contributor` role to the managed identity on the storage account or container. |
| `BlobContainerIdentityMissing`           | No identity is configured for storage access.                        | Set `commandOutputSettings.identityType` and `identityResourceId` (for user-assigned managed identity).      |
| `BlobContainerIdentityTypeInvalid`       | The identity type specified isn't recognized.                        | Use `SystemAssignedIdentity` or `UserAssignedIdentity` for the identity type.                                |
| `BlobContainerIdentityResourceIdMissing` | User-assigned identity was specified but the resource ID is missing. | Provide the `identityResourceId` when using `UserAssignedIdentity`.                                          |
| `BlobContainerIdentityResourceIdInvalid` | The user-assigned identity resource ID is malformed.                 | Verify the identity resource ID format.                                                                      |
| `BlobContainerUploadFailed`              | Failed to upload a validation blob to the container.                 | Check permissions, firewall rules, and that the container exists.                                            |
| `BlobContainerCommitFailed`              | Failed to commit the validation blob.                                | Check permissions and storage account configuration.                                                         |
| `BlobContainerRequestTimeout`            | The request to Azure Storage timed out.                              | Retry the operation. Check network connectivity.                                                             |
| `BlobContainerRequestThrottled`          | The request was throttled by Azure Storage.                          | Wait and retry.                                                                                              |
| `BlobContainerServiceUnavailable`        | Azure Storage is temporarily unavailable.                            | Wait and retry. Check Azure service health.                                                                  |

### Resolve Storage Account permissions

To assign the required role:

```azurecli
# Get the managed identity principal ID
PRINCIPAL_ID=$(az networkcloud cluster show \
  --name <cluster-name> \
  --resource-group <resource-group> \
  --query "identity.principalId" -o tsv)

# Assign Storage Blob Data Contributor role
az role assignment create \
  --assignee $PRINCIPAL_ID \
  --role "Storage Blob Data Contributor" \
  --scope "/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Storage/storageAccounts/{account-name}"
```

### Configure Storage Account firewall

If your storage account has firewall rules enabled:

1. In the Azure portal, navigate to your storage account.
2. Select **Networking** under **Security + networking**.
3. Under **Exceptions**, select **Allow Azure services on the trusted services list to access this storage account**.
4. If users need to access run command output directly, add their IP addresses to the firewall allowlist.

## Key Vault validation errors

The following table lists error codes for Key Vault validation failures:

| Error code                          | Description                                                          | Remediation                                                                                               |
|-------------------------------------|----------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| `KeyVaultUriMissing`                | The vault URI wasn't provided in `secretArchiveSettings`.            | Set `secretArchiveSettings.vaultUri` to your Key Vault URI.                                               |
| `KeyVaultUriInvalid`                | The vault URI format is incorrect.                                   | Use format: `https://{vault-name}.vault.azure.net/`                                                       |
| `KeyVaultNotFound`                  | The specified Key Vault doesn't exist.                               | Verify the Key Vault exists and the URI is correct.                                                       |
| `KeyVaultAccessDenied`              | The managed identity lacks permissions on the vault.                 | Assign `Operator Nexus Key Vault Writer Service Role (Preview)` to the managed identity on the Key Vault. |
| `KeyVaultIdentityMissing`           | No identity is configured for Key Vault access.                      | Set `secretArchiveSettings.identityType` and `identityResourceId` (for user-assigned managed identity).   |
| `KeyVaultIdentityTypeInvalid`       | The identity type specified isn't recognized.                        | Use `SystemAssignedIdentity` or `UserAssignedIdentity` for the identity type.                             |
| `KeyVaultIdentityResourceIdMissing` | User-assigned identity was specified but the resource ID is missing. | Provide the `identityResourceId` when using `UserAssignedIdentity`.                                       |
| `KeyVaultIdentityResourceIdInvalid` | The user-assigned identity resource ID is malformed.                 | Verify the identity resource ID format.                                                                   |
| `KeyVaultSecretCreateFailed`        | Failed to write a test secret to the vault.                          | Check Key Vault access policies or RBAC permissions. Ensure Azure RBAC is enabled on the vault.           |
| `KeyVaultSecretReadFailed`          | Failed to read the test secret from the vault.                       | Verify the identity has read permissions on secrets.                                                      |
| `KeyVaultSecretDeleteFailed`        | Failed to delete the test secret (cleanup step).                     | This error is typically transient. Retry the operation.                                                   |
| `KeyVaultRequestTimeout`            | The request to Key Vault timed out.                                  | Retry the operation. Check network connectivity.                                                          |
| `KeyVaultRequestThrottled`          | The request was throttled by Key Vault.                              | Wait and retry.                                                                                           |
| `KeyVaultServiceUnavailable`        | Key Vault is temporarily unavailable.                                | Wait and retry. Check Azure service health.                                                               |

### Resolve Key Vault permissions

Key Vault requires specific permissions for secret management. Assign the required role:

```azurecli
# Get the managed identity principal ID
PRINCIPAL_ID=$(az networkcloud cluster show \
  --name <cluster-name> \
  --resource-group <resource-group> \
  --query "identity.principalId" -o tsv)

# Assign the Operator Nexus Key Vault Writer Service Role
az role assignment create \
  --assignee $PRINCIPAL_ID \
  --role "Operator Nexus Key Vault Writer Service Role (Preview)" \
  --scope "/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.KeyVault/vaults/{vault-name}"
```

> [!IMPORTANT]
> Your Key Vault must have **Azure RBAC** enabled for permission model. Access policies aren't supported for Operator Nexus integration.

### Configure Key Vault firewall

If your Key Vault has firewall rules enabled:

1. In the Azure portal, navigate to your Key Vault.
2. Select **Networking** under **Settings**.
3. Under **Exceptions**, select **Allow trusted Microsoft services to bypass this firewall**.
4. If users need direct Key Vault access, add their IP addresses to the firewall allowlist.

## Common scenarios

### Scenario: Validation fails immediately after cluster creation

**Symptoms**: The `AzurePrerequisitesReady` condition shows `False` with access denied errors immediately after creating the cluster.

**Cause**: Role assignments can take several minutes to propagate after being created.

**Solution**:

1. Verify the role assignments are correct using the Azure portal or CLI.
2. Wait 5-10 minutes for propagation.
3. Validation automatically retries on the next reconciliation cycle.

### Scenario: Validation was working but now fails

**Symptoms**: A cluster that was previously healthy now shows validation failures.

**Cause**: Possible causes include:

- Role assignments were removed or modified
- Resource was deleted or moved
- Managed identity was deleted or reconfigured
- Firewall rules were changed

**Solution**:

1. Check the specific error code in the condition message.
2. Verify the resource still exists and is accessible.
3. Confirm role assignments are still in place.
4. Review any recent changes to network or firewall configuration.

### Scenario: Log Analytics workspace warning while the cluster is running

**Symptoms**: Your cluster reports a Log Analytics workspace (LAW) warning, including after a cluster management upgrade, while `detailedStatus` is `Running`. `Running` doesn't establish that workspace access is healthy or that the warning is stale. Warning clearance, resource operation completion, and telemetry ingestion are separate outcomes.

**Investigate before making changes**:

1. Ensure you have read access to the cluster, configured workspace, and managed identity, and permission to query workspace data. Your query access is separate from the cluster identity's access.
1. In the Azure portal, confirm the cluster's subscription, resource group, and name. Record the full warning, provisioning state, detailed status, and UTC observation time. Retain the resource JSON, including workspace and identity settings. Alternatively, retrieve the full response with this read-only command:

   ```azurecli
   az networkcloud cluster show --subscription "<subscription-id>" --resource-group "<cluster-resource-group>" --name "<cluster-name>" --output json
   ```

1. Review the cluster's **Activity log** for the relevant upgrade and updates. Confirm the subscription, resource scope, and time range. Retain operation and correlation IDs. Missing entries don't prove that processing stopped.
1. Check the [Log Analytics workspace validation errors](#log-analytics-workspace-validation-errors). Use `analyticsOutputSettings` to identify the workspace and selected identity; don't assume the system-assigned identity is used when a user-assigned identity is selected. Follow the [managed identity configuration guidance](howto-cluster-managed-identity-user-provided-resources.md) for permissions. Returned validation conditions depend on the API version and configuration; a missing condition doesn't prove success.
1. Check `provisioningState` separately from the warning and `detailedStatus`. `Accepted` doesn't establish completion or, by itself, prove that processing is stuck. If you retained an `Azure-AsyncOperation` or `Location` URL from the original response, follow [Track asynchronous operations](howto-track-async-operations-cli.md) using that actual URL. Don't construct one from an example or repeat an update to obtain it.

Resolve any identified workspace or access failure before considering a tag change. A tag change doesn't grant permissions or repair an unavailable workspace.

**Optional portal tag-change attempt**:

A cluster tag change through the Azure portal is a recovery attempt for this warning, not a proven universal revalidation trigger. Warning clearance after a tag change doesn't establish causation, operation completion, or restored ingestion.

> [!IMPORTANT]
> This changes the cluster resource; it isn't a risk-free status refresh. An update can remain pending or conflict with another operation. Attempt a tag change only if the cluster is `Running`, no workspace or access failure remains unresolved, and no update is pending. If completion is uncertain, contact support rather than submitting another change.

1. Obtain authorization to update the cluster and approval under your organization's change process. Read access isn't sufficient; don't assume Tag Contributor alone permits portal tagging. See [Required access for tags](/azure/azure-resource-manager/management/tag-resources#required-access).
1. With the resource owner and any automation owners, review existing tags, [tag limits](/azure/azure-resource-manager/management/tag-resources#limitations), policies, and locks. Choose an unused, policy-permitted tag name and a nonsensitive value that doesn't drive automation. Tag names are case-insensitive. Don't overwrite keys, remove tags to make room, include credentials or personal information, or bypass policy or locks.
1. On the cluster resource's **Overview** page, select **Add tags**, or **change** for existing tags, as described in [Apply tags with the Azure portal](/azure/azure-resource-manager/management/tag-resources-portal). Confirm you're editing the cluster itself, not its resource group or cluster manager.
1. Refresh and review the current tags, retain every existing name-value pair, and add only the agreed tag. If another writer changes tags during the attempt, stop and reconcile before saving. Select **Save**.
1. If saving fails, capture the error. For a conflict, don't retry the write or toggle tags; check the existing operation and provisioning state. After a successful save, reload the resource and verify that the new tag is present and all existing tags remain unchanged. A successful save doesn't establish cluster update completion.

Don't substitute a one-tag `az networkcloud cluster update --tags` command: it replaces all existing tags. The generic `az tag update --operation Merge` operation isn't established as an equivalent trigger. Don't repeatedly toggle tags to force a result.

**Verify all three outcomes**:

1. **Warning clearance:** Refresh the resource or repeat the read-only cluster command. Record the UTC time and full warning text. A saved tag doesn't prove that the warning cleared.
1. **Resource operation completion:** Check the provisioning state and available operation status. `Running` or an absent warning doesn't mean `Succeeded`. If an update remains pending or completion is uncertain, contact support instead of submitting another change.
1. **Telemetry ingestion:** In the intended workspace, use existing queries or workbooks to check recent telemetry for the affected cluster and expected data source. Older records or another cluster's data don't demonstrate current ingestion. Check collection and destination settings; see [Azure Operator Nexus observability](concepts-observability.md).

There isn't a guaranteed warning-clearance delay or update completion time for this attempt. If any outcome remains unresolved, follow [Get additional help](#get-additional-help), even if the other outcomes look healthy. Don't patch conditions, delete secrets, reinstall healthy extensions, or restart the cluster manager as routine fixes for this warning.

### Scenario: Deployment times out waiting for validation

**Symptoms**: The deployment action fails with a message indicating Azure prerequisites validation didn't complete within the timeout period.

**Cause**: Validation has a 10-minute timeout. If issues can't be resolved within this window, the deployment fails.

**Solution**:

1. Check the `AzurePrerequisitesReady` condition for specific errors.
2. Resolve the underlying issue (permissions, firewall, resource existence).
3. Restart the deployment action after fixing the issue.

### Scenario: User-assigned managed identity not working

**Symptoms**: Validation fails with identity-related errors when using a user-assigned managed identity.

**Cause**: The user-assigned identity might not be correctly associated with the cluster or might lack permissions.

**Solution**:

1. Verify the identity is assigned to the cluster resource.
2. Confirm the `identityResourceId` in cluster settings matches the identity's ARM resource ID.
3. Assign the required roles to the user-assigned identity (not the system-assigned identity).

## Retry validation

> [!IMPORTANT]
> Before submitting a retry, confirm that no update is pending. For a running cluster with a LAW warning, follow the [LAW warning scenario](#scenario-log-analytics-workspace-warning-while-the-cluster-is-running) instead. Don't treat a tag change as an immediate or guaranteed validation retry.

After correcting the resource configuration or role assignments, validation automatically retries on the next cluster reconciliation (typically within 2 minutes).

To force an immediate validation retry:

1. Add or update an annotation on the cluster to trigger reconciliation.
2. Wait for the `AzurePrerequisitesReady` condition to update.

For deployment or upgrade actions that failed due to validation:

1. Fix the underlying resource or permission issue.
2. If the action is still in progress, it automatically retries after validation passes.
3. If the action was marked as failed, restart the deployment or upgrade action.

## Get additional help

If validation continues to fail after following the remediation steps:

1. **Verify identity principal ID**: Confirm the managed identity's principal ID matches what's assigned on the resources.

   ```azurecli
   # For system-assigned identity
   az networkcloud cluster show \
     --name <cluster-name> \
     --resource-group <resource-group> \
     --query "identity.principalId"
   
   # For user-assigned identity
   az identity show \
     --name <identity-name> \
     --resource-group <identity-resource-group> \
     --query "principalId"
   ```

2. **Check role assignments**:

   ```azurecli
   az role assignment list \
     --assignee <principal-id> \
     --all \
     --output table
   ```

3. **Review Azure activity logs** for the target resources to see if requests are being received and why they might be failing.

4. **Contact support**: If issues persist, open a support request with Microsoft including:
   - Cluster resource ID
   - Validation error codes and messages
   - Managed identity principal ID
   - Resource IDs for the failing resources

   For a LAW warning, also include UTC observation times, exact warning and error messages (including conflicts), relevant operation or correlation IDs, before-and-after warning and operation status, and cluster-specific ingestion checks. Describe any tag change. Share diagnostics through the support request, not a public issue; don't include workspace keys, tokens, passwords, or other credentials.

## Related content

- [Cluster Managed Identity and User Provided Resources](howto-cluster-managed-identity-user-provided-resources.md)
- [Cluster deployment overview](concepts-cluster-deployment-overview.md)
- [Cluster runtime upgrade overview](concepts-cluster-upgrade-overview.md)
- [Configure cluster deployment](howto-configure-cluster.md)
