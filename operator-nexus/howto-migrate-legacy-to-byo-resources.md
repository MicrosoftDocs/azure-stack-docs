---
title: "Azure Operator Nexus: Migration from Legacy to BYO Resource Model"
description: Guide for migrating from legacy resource model to Bring Your Own (BYO) resources model for clusters and infrastructure components.
author: matternst7258
ms.author: matternst7258
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 10/08/2025
ms.custom: template-concept
---

This article describes the migration from the legacy resource management model to the Bring Your Own (BYO) resources model introduced in Azure Operator Nexus Platform Cluster (NC) version 4.5. This change affects how managed identities and user-provided resources are configured for Cluster Managers, Clusters, Bare Metal Machines (BMM), and Network Fabrics.

## Overview of Changes

Starting with NC version 4.5, Azure Operator Nexus transitioned from a legacy resource management model to a BYO (Bring Your Own) resources model to improve security, provide consistent user experience, and give customers more control over their resources.

### Key Changes Summary

| Component | Legacy Model (Pre NC 4.5) | BYO Model (NC 4.5+) | Impact |
|-----------|---------------------------|---------------------|---------|
| **Cluster Manager** | Managed Identity tab available in portal | Managed Identity tab removed from portal | Configure MI via CLI/API only |
| **Cluster Resources** | Platform-managed resources | User-provided resources with managed identities | Enhanced security and control |
| **Storage Account** | Auto-created by platform | User-provided with UAMI/SAMI | Manual setup required |
| **Log Analytics Workspace** | Platform-managed | User-provided with managed identity | Improved observability control |
| **Key Vault** | Cluster Manager managed | User-provided with managed identity | Enhanced secret management |
| **BMM Resources** | Platform-managed | User-provided with managed identities | Consistent security model |

## Timeline and Version Information

### Pre NC 4.5 (Legacy Model)

- Cluster Manager automatically created and managed resources
- Limited user control over resource configuration
- Managed Identity tab available in Azure Portal for Cluster Manager
- Platform-created storage accounts and key vaults

### NC 4.5+ (BYO Model)

- Users must provide their own resources before cluster creation
- Managed identities (UAMI/SAMI) required for resource access
- Enhanced security through principle of least privilege
- Portal UI changes: Managed Identity tab removed from Cluster Manager

## Portal Changes Detail

### Cluster Manager Portal Changes

**Before NC 4.5:**
- Managed Service Identity tab was available under Cluster Manager resource
- Users could configure managed identities directly through the portal
- Platform automatically created required resources

**After NC 4.5:**
- Managed Service Identity tab has been **removed** from the Cluster Manager resource in Azure Portal
- Managed identity configuration must be done through:
  - Azure CLI commands
  - Azure PowerShell
  - ARM Templates
  - REST API calls

### UI Navigation Changes

| Resource Type      | Legacy Path (Pre NC 4.5)                            | Current Path (NC 4.5+)   | Notes                   |
|--------------------|-----------------------------------------------------|--------------------------|-------------------------|
| Cluster Manager MI | Portal → Cluster Manager → Managed Service Identity | Use CLI/API/PowerShell   | Tab removed             |
| Cluster Resources  | Auto-created                                        | Manual creation required | User-provided resources |
| BMM Resources      | Platform-managed                                    | User-configured with MI  | BYO model applied       |

## Migration Planning

### For Existing Deployments

If you have existing deployments created before NC 4.5, consider the following:

1. **No Immediate Action Required**: Existing clusters continue to function with the legacy model
2. **Future Updates**: New cluster deployments must use the BYO model
3. **Gradual Migration**: Plan migration during maintenance windows

### For New Deployments

All new deployments starting with NC 4.5 must:

1. Create User Assigned Managed Identities (UAMI) or use System Assigned Managed Identities (SAMI)
2. Pre-create required resources:
   - Storage Accounts for command output
   - Key Vaults for secret management
   - Log Analytics Workspaces for monitoring
3. Configure proper RBAC permissions
4. Use CLI/API for managed identity configuration

## Resource Configuration Changes

### SecretArchive Property Changes

**Legacy Model:**
```json
{
  "secretArchive": {
    "keyVaultId": "/subscriptions/.../keyVaults/platform-created-kv"
  }
}
```

**BYO Model:**
```json
{
  "secretArchiveSettings": {
    "vaultUri": "https://user-created-kv.vault.azure.net/",
    "associatedIdentity": {
      "identityType": "UserAssignedIdentity",
      "userAssignedIdentityResourceId": "/subscriptions/.../userAssignedIdentities/myUAMI"
    }
  }
}
```

### LAW Property Changes

**Legacy Model:**
```json
{
  "analyticsWorkspaceId": "/subscriptions/.../workspaces/platform-created-law"
}
```

**BYO Model:**
```json
{
  "analyticsOutputSettings": {
    "analyticsWorkspaceId": "/subscriptions/.../workspaces/user-created-law",
    "identity": {
      "type": "UserAssignedIdentity",
      "userAssignedIdentityResourceId": "/subscriptions/.../userAssignedIdentities/myUAMI"
    }
  }
}
```

### Storage Property Changes

**Legacy Model:**
```json
{
  "storageProfile": {
    "storageAccountId": "/subscriptions/.../storageAccounts/platformcreated"
  }
}
```

**BYO Model:**
```json
{
  "commandOutputSettings": {
    "containerUrl": "https://usercreated.blob.core.windows.net/mycontainer",
    "associatedIdentity": {
      "identityType": "UserAssignedIdentity",
      "userAssignedIdentityResourceId": "/subscriptions/.../userAssignedIdentities/myUAMI"
    }
  }
}
```

## Migration Steps

### Step 1: Assess Current Environment

1. **Inventory existing resources**:
   - Document current Cluster Manager configurations
   - Identify clusters using legacy model
   - Note any custom configurations

2. **Plan resource requirements**:
   - Determine number of UAMIs needed
   - Plan storage account structure
   - Design Key Vault access patterns

### Step 2: Prepare BYO Resources

1. **Create Managed Identities**:
   ```azurecli
   az identity create --name "nexus-cluster-uami" --resource-group "nexus-rg"
   ```

2. **Create Storage Account**:
   ```azurecli
   az storage account create --name "nexuscommandoutput" --resource-group "nexus-rg"
   ```

3. **Create Key Vault**:
   ```azurecli
   az keyvault create --name "nexus-secrets-kv" --resource-group "nexus-rg"
   ```

4. **Create Log Analytics Workspace**:
   ```azurecli
   az monitor log-analytics workspace create --workspace-name "nexus-monitoring-law" --resource-group "nexus-rg"
   ```

### Step 3: Configure RBAC Permissions

Assign appropriate roles to your managed identities:

```azurecli
# Storage Blob Data Contributor for storage access
az role assignment create --assignee <UAMI-principal-id> --role "Storage Blob Data Contributor" --scope <storage-account-resource-id>

# Key Vault Secrets Officer for secret management
az role assignment create --assignee <UAMI-principal-id> --role "Key Vault Secrets Officer" --scope <key-vault-resource-id>

# Monitoring Metrics Publisher for LAW access
az role assignment create --assignee <UAMI-principal-id> --role "Monitoring Metrics Publisher" --scope <law-resource-id>
```

### Step 4: Update Configurations

Use CLI/API to configure managed identities since portal UI is no longer available:

```azurecli
# Create cluster with BYO resources
az networkcloud cluster create \
    --name "my-cluster" \
    --resource-group "nexus-rg" \
    --mi-user-assigned "/subscriptions/.../userAssignedIdentities/nexus-cluster-uami" \
    --command-output-settings identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/.../userAssignedIdentities/nexus-cluster-uami" \
      container-url="https://nexuscommandoutput.blob.core.windows.net/outputs" \
    --analytics-output-settings analytics-workspace-id="/subscriptions/.../workspaces/nexus-monitoring-law" \
      identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/.../userAssignedIdentities/nexus-cluster-uami" \
    --secret-archive-settings vault-uri="https://nexus-secrets-kv.vault.azure.net/" \
      identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/.../userAssignedIdentities/nexus-cluster-uami"
```

## Best Practices

### Security Considerations

1. **Use User Assigned Managed Identities (UAMI)** when possible for better control
2. **Apply principle of least privilege** when assigning RBAC roles
3. **Use separate UAMIs** for different resource types if fine-grained access control is required
4. **Regularly audit** managed identity assignments and permissions

### Operational Excellence

1. **Document your UAMI strategy** and resource naming conventions
2. **Implement Infrastructure as Code (IaC)** for consistent deployments
3. **Monitor resource usage** and costs with the BYO model
4. **Plan for disaster recovery** of user-provided resources

### Cost Management

1. **Consider resource sharing** where appropriate (same UAMI for multiple resources)
2. **Right-size storage accounts** based on actual usage patterns
3. **Implement lifecycle management** for storage accounts
4. **Monitor Key Vault transaction costs** for high-frequency operations

## Troubleshooting Common Issues

### Portal UI Issues

**Problem**: Cannot find Managed Service Identity tab in Cluster Manager
**Solution**: This is expected behavior after NC 4.5. Use CLI/API/PowerShell for managed identity configuration.

**Problem**: Existing clusters show different resource model
**Solution**: Existing clusters continue with legacy model until migrated. New clusters must use BYO model.

### Permission Issues

**Problem**: "Access denied" errors when using UAMI
**Solution**: 
1. Verify RBAC role assignments
2. Check managed identity assignment to cluster
3. Ensure correct resource IDs are used

**Problem**: Storage access failures
**Solution**:
1. Verify container URL format
2. Check Storage Blob Data Contributor role assignment
3. Ensure storage account allows public access if required

## Support and Migration Assistance

### Getting Help

1. **Azure Support**: For platform-specific issues and migration assistance
2. **Documentation**: Refer to updated BYO resources documentation
3. **Community Forums**: Share experiences and best practices

### Migration Timeline Recommendations

- **Immediate**: Update documentation and training materials
- **Short-term (1-3 months)**: Plan and prepare BYO resources for new deployments
- **Medium-term (3-6 months)**: Begin gradual migration of existing deployments
- **Long-term (6+ months)**: Complete migration to BYO model for all environments

## Related Documentation

- [Azure Operator Nexus Cluster Support for Managed Identities and User Provided Resources](./howto-cluster-managed-identity-user-provided-resources.md)
- [How to Configure Cluster Manager](./howto-cluster-manager.md)
- [How to Configure Bring Your Own Storage for Network Fabric](./howto-configure-bring-your-own-storage-network-fabric.md)
- [Create and Provision a Cluster using Azure CLI](./howto-configure-cluster.md)

## Next Steps

1. Review your current environment and identify migration requirements
2. Plan your BYO resource architecture
3. Create and test managed identities and resources in a development environment
4. Implement gradual migration strategy for production environments
5. Update operational procedures and documentation