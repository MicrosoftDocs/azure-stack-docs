---
title: "Azure Operator Nexus Cluster Support for managed identities and user provided resources"
description: Azure Operator Nexus Cluster support for managed identities and user provided resources.
author: eak13
ms.author: ekarandjeff
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 6/10/2025
ms.custom: template-how-to
---

# Azure Operator Nexus Cluster support for managed identities and user provided resources

To improve the security of the Operator Nexus platform, managed identities are now supported for Operator Nexus Clusters. Managed identities provide a secure way for applications to access other Azure resources and eliminate the need for users to manage credentials. Additionally, Operator Nexus now has a user provided resource model. In addition to improved security, this shift provides a consistent user experience across the platform.

Managed identities are used with the following user resources provided on Operator Nexus Clusters:

- Storage Accounts used for the output of Bare Metal run-\* commands.
- Key Vaults used for credential rotation.
- Log Analytics Workspaces (LAW) used to capture some metrics.

To learn more about managed identities in Azure, see [Managed identities for Azure resources](/entra/identity/managed-identities-azure-resources/overview). Operator Nexus Clusters support multiple User Assigned Managed Identities (UAMI) or one system assigned managed identity (SAMI). A combination of one or more UAMIs and a SAMI is also supported.

While a user can choose to use either managed identity type, UAMIs are recommended. They allow users to preconfigure resources with the appropriate access to the UAMI in advance of Operator Nexus Cluster creation or updating. The same UAMI can be used for all resources, or if users want fine grained access, they can define UAMIs for each resource.

For information on using the API to update Cluster managed identities, see [Update Cluster Identities](#update-cluster-identities-via-apis).

## Prerequisites

- [Install Azure CLI](https://aka.ms/azcli).
- Install the latest version of the [appropriate Azure CLI extensions](./howto-install-cli-extensions.md).
- Storage Account managed identity support requires the `2024-07-01` or later version of the NetworkCloud API.
- Key Vault and Log Analytics Workspace managed identity support requires the `2025-02-01` or later version of the NetworkCloud API.

## Resource validation

Operator Nexus automatically validates that user-provided resources (Storage Account, Log Analytics Workspace, and Key Vault) are accessible using the configured managed identity. Validation runs at key lifecycle stages to ensure that cluster operations can succeed.

### When validation occurs

Validation is triggered during the following cluster lifecycle events:

- **Cluster deployment** - Gates the "Validate Azure prerequisites" step before deployment proceeds
- **Cluster updates** - When resource settings or managed identities change
- **Cluster runtime upgrades** - Before upgrade proceeds to ensure resources remain accessible
- **Runtime monitoring** - Periodic revalidation when issues are detected

> [!NOTE]
> If Azure prerequisites validation succeeded recently (within the last 12 hours), deployment/upgrade actions can proceed without forcing a re-validation. If the last successful validation is older than 12 hours, the platform triggers a fresh validation before proceeding.

### What is validated

Each user-provided resource undergoes a connectivity and permissions check using the configured managed identity:

| Resource                | Validation test                                        | Success criteria                                                         |
|-------------------------|--------------------------------------------------------|--------------------------------------------------------------------------|
| Log Analytics Workspace | Calls the GetSharedKeys API using the managed identity | Identity has `Log Analytics Contributor` role on the workspace           |
| Storage Account         | Uploads and commits a test blob to the container       | Identity has `Storage Blob Data Contributor` role on the container       |
| Key Vault               | Writes, reads, and deletes a test secret               | Identity has `Operator Nexus Key Vault Writer Service Role` on the vault |

### Viewing validation status

Validation status is visible on the Cluster resource through the `AzurePrerequisitesReady` condition.

#### Azure portal

1. Navigate to your Cluster resource in the Azure portal.
2. Select **JSON View** to see the resource properties.
3. Look for the `conditions` array and find the `AzurePrerequisitesReady` condition.

The condition shows:

- **Status**: `True` (validation passed), `False` (validation failed), or `Unknown` (validation pending)
- **Message**: Human-readable summary including timestamps or error details

#### Azure CLI

Use the following command to check validation status:

```azurecli
az networkcloud cluster show --name "<CLUSTER_NAME>" \
  --resource-group "<CLUSTER_RG>" \
  --subscription "<SUBSCRIPTION>" \
  --query "conditions[?contains(type, 'AzurePrerequisitesReady')]"
```

Example output for successful validation:

```json
[
  {
    "type": "AzurePrerequisitesReady",
    "status": "True",
    "message": "Azure prerequisite validation succeeded at 2026-01-23T10:30:00Z"
  }
]
```

### Validation during deployment and upgrades

During cluster deployment or runtime upgrade, validation runs as the "Validate Azure prerequisites" step. If validation fails:

1. The action's step state shows `Failed` with an error message.
2. The action's `ActionStatus.Error.Message` contains the validation failure details.
3. The deployment or upgrade doesn't proceed until the issue is resolved.

To view the action status, check the `actionStates` property on the cluster or use:

```azurecli
az networkcloud cluster show --name "<CLUSTER_NAME>" \
  --resource-group "<CLUSTER_RG>" \
  --query "actionStates"
```

For troubleshooting validation failures, see [Troubleshoot validation failures](#troubleshoot-validation-failures).

## Operator Nexus Clusters with User Assigned Managed Identities (UAMI)

It's a best practice to first define all of the user provided resources (Storage Account, LAW, and Key Vault), the managed identities associated with those resources and then assign the managed identity the appropriate access to the resource. If these steps aren't done before Cluster creation, the steps need to be completed before Cluster deployment.

The impacts of not configuring these resources for a new Cluster are as follows:

- _Storage Account:_ Cluster creation fails as there's a check to ensure that `commandOutputSettings` exists on the Cluster input.
- _LAW:_ Cluster deployment fails as the LAW (Log Analytics Workspace) is required to install software extensions during deployment.
- _Key Vault:_ Credential rotations fail as there's a check to ensure write access to the user provided Key Vault before performing credential rotation.

> [!IMPORTANT]
> Starting with API version `2025-02-01`, Operator Nexus validates resource accessibility during cluster deployment and upgrades. Even if resources are defined, deployment fails if the managed identity lacks proper permissions on any resource. Ensure role assignments are complete before initiating deployment. See [Resource validation](#resource-validation) for details.

Updating the Cluster can be done at any time. Changing the LAW settings causes a brief disruption in sending metrics to the LAW as the extensions that use the LAW need to be reinstalled.

The following steps should be followed for using UAMIs with Nexus Clusters and associated resources.

1. [Create the UAMI or UAMIs](#create-the-uami-or-uamis)
1. [Create the resources and assign the UAMI to the resources](#create-the-resources-and-assign-the-uami-to-the-resources)
1. [Create or update the Cluster to use User Assigned Managed Identities and user provided resources](#create-or-update-the-nexus-cluster-to-use-user-assigned-managed-identities-and-user-provided-resources)
1. Deploy the Cluster (if new)

### Create the UAMI or UAMIs

1. Create the UAMI or UAMIs for the resources in question. For more information on creating the managed identities, see [Manage user-assigned managed identities](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities).

### Create the resources and assign the UAMI to the resources

#### UAMI Storage Accounts setup

1. Create a storage account, or identify an existing storage account that you want to use. See [Create an Azure storage account](/azure/storage/common/storage-account-create?tabs=azure-portal).
1. Create a blob storage container in the storage account. See [Create a container](/azure/storage/blobs/storage-quickstart-blobs-portal#create-a-container).
1. Assign the `Storage Blob Data Contributor` role to users and the UAMI that need access to the run-\* command output. See [Assign an Azure role for access to blob data](/azure/storage/blobs/assign-azure-role-data-access?tabs=portal).
1. To limit access to the Storage Account to a select set of IP or virtual networks, see [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal).
   1. The IPs for all users executing run-\* commands need to be added to the Storage Account's `Virtual Networks` and/or `Firewall` lists.
   1. Ensure `Allow Azure services on the trusted services list to access this storage account.` under `Exceptions` is selected.

#### UAMI Log Analytics Workspaces setup

1. Create a Log Analytics Workspace (LAW), or identify an existing LAW that you want to use. See [Create a Log Analytics Workspace](/azure/azure-monitor/logs/quick-create-workspace).
1. Assign the `Log Analytics Contributor` role to the UAMI for the log analytics workspace. See [Manage access to Log Analytics workspaces](/azure/azure-monitor/logs/manage-access?tabs=portal).

#### UAMI Key Vault setup

1. Create a Key Vault, or identify an existing Key Vault that you want to use. See [Create a Key Vault](/azure/key-vault/general/quick-create-cli).
1. Enable the Key Vault for Role Based Access Control (RBAC). See [Enable Azure RBAC permissions on Key Vault](/azure/key-vault/general/rbac-guide?tabs=azure-cli#enable-azure-rbac-permissions-on-key-vault).
1. Assign the `Operator Nexus Key Vault Writer Service Role (Preview)` role to the UAMI for the Key Vault. See [Assign role](/azure/key-vault/general/rbac-guide?tabs=azure-cli#assign-role).
   1. The role definition ID for the Operator Nexus Key Vault Writer Service Role is `44f0a1a8-6fea-4b35-980a-8ff50c487c97`. This format is required if using the Azure command line to do the role assignment.
1. To limit access to the Key Vault to a select set of IP or virtual networks, see [Configure Azure Key Vault firewalls and virtual networks](/azure/key-vault/general/network-security?WT.mc_id=Portal-Microsoft_Azure_KeyVault).
   1. The IPs for all users requiring access to the Key Vault need to be added to the Key Vault's `Virtual Networks` and/or `Firewall` lists.
   1. Ensure the `Allow trusted Microsoft services to bypass this firewall.` under `Exceptions` is selected.

### Create or update the Nexus Cluster to use User Assigned Managed Identities and user provided resources

#### Define the UAMI(S) on the Cluster

When creating or updating a Cluster with a user assigned managed identity, use the `--mi-user-assigned` parameter along with the Azure Resource Manager (ARM) resource identifier of the UAMI. If you wish to specify multiple UAMIs, list the UAMIs' Azure Resource Manager (ARM) resource identifiers with a space between them. Each UAMI that's used for a Key Vault, LAW, or Storage Account must be provided in this list.

When creating the Cluster, you specify the UAMIs in `--mi-user-assigned` and also define the resource settings. Updating the Cluster to set or change a UAMI should also include the resource settings changes to associate the UAMI to the resource.

#### UAMI Storage Account settings

The `--command-output-settings` data construct is used to define the Storage Account where run command output is written. It consists of the following fields:

- `container-url`: The URL of the storage account container that is to be used by the specified identities.
- `identity-resource-id`: The user assigned managed identity resource ID to use. Mutually exclusive with a system assigned identity type.
- `identity-type`: The type of managed identity that's being selected. Use `UserAssignedIdentity`.
- `overrides`: Optional. An array of override objects that can be used to override the storage account container and identity to use for specific types of run commands. Each override object consists of the following fields:
  - `command-output-type`: The type of run command to override.
  - `container-url`: The URL of the storage account container to use for the specified command type.
  - `identity-resource-id`: The user assigned managed identity resource ID to use for the specified command type.
  - `identity-type`: The type of managed identity that's being selected. Use `UserAssignedIdentity`.

Valid `command-output-type` values are:

- `BareMetalMachineRunCommand`: Output from the `az networkcloud baremetalmachine run-command` command.
- `BareMetalMachineRunDataExtracts`: Output from the `az networkcloud baremetalmachine run-data-extract` command.
- `BareMetalMachineRunDataExtractsRestricted`: Output from the `az networkcloud baremetalmachine run-data-extracts-restricted` command.
- `BareMetalMachineRunReadCommands`: Output from the `az networkcloud baremetalmachine run-read-command` command.
- `StorageRunReadCommands`: Output from the `az networkcloud storageappliance run-read-command` command.

Run command output is written to the storage account container defined in the `overrides` for the specific command type, using the associated identity for that override. If no matching override is found, the default `container-url` and `identity-resource-id` from the command output settings is used.

#### UAMI Log Analytics Workspace settings

The `--analytics-output-settings` data construct is used to define the LAW where metrics are sent. It consists of the following fields:

- `analytics-workspace-id`: The resource ID of the analytics workspace that is to be used by the specified identity.
- `identity-resource-id`: The user assigned managed identity resource ID to use. Mutually exclusive with a system assigned identity type
- `identity-type`: The type of managed identity that's being selected. Use `UserAssignedIdentity`.

#### UAMI Key Vault settings

The `--secret-archive-settings` data construct is used to define the Key Vault where rotated credentials are written. It consists of the following fields:

- `identity-resource-id`: The user assigned managed identity resource ID to use.
- `identity-type`: The type of managed identity that's being selected. Use `UserAssignedIdentity`.
- `vault-uri`: The URI for the key vault used as the secret archive.

#### UAMI Cluster create command examples

_Example 1:_ This example is an abbreviated Cluster create command that uses one UAMI across the Storage Account, LAW, and Key Vault.

```azurecli-interactive
az networkcloud cluster create --name "clusterName" -g "resourceGroupName" \

    ...

    --mi-user-assigned "/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI" \
    --command-output-settings identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI" \
      container-url="https://myaccount.blob.core.windows.net/mycontainer" \
    --analytics-output-settings analytics-workspace-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/microsoft.operationalInsights/workspaces/logAnalyticsWorkspaceName" \
      identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI" \
    --secret-archive-settings vault-uri="https://mykv.vault.azure.net/" \
      identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI"
```

_Example 2:_ This example is an abbreviated Cluster create command that uses two UAMIs. The Storage Account and LAW use the first UAMI and the Key Vault uses the second.

```azurecli-interactive
az networkcloud cluster create --name "clusterName" -g "resourceGroupName" \

    ...

    --mi-user-assigned "/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myFirstUAMI" "/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mySecondUAMI" \
    --command-output-settings identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myFirstUAMI" \
      container-url="https://myaccount.blob.core.windows.net/mycontainer" \
    --analytics-output-settings analytics-workspace-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/microsoft.operationalInsights/workspaces/logAnalyticsWorkspaceName" \
      identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myFirstUAMI" \
    --secret-archive-settings vault-uri="https://mykv.vault.azure.net/" \
      identity-type="UserAssignedIdentity" \
      identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mySecondUAMI"
```

#### Cluster update examples

Updating a Cluster is done as a single step. Update the cluster to include the UAMI in the `--mi-user-assigned` field and the corresponding `--identity-resource-id` for the Storage Account, LAW, or Key Vault.

If there are multiple UAMIs in use, the full list of UAMIs must be specified in the `--mi-user-assigned` field when updating. If a SAMI is in use on the Cluster and you're adding a UAMI, you must include `--mi-system-assigned` in the update command. Failure to include existing managed identities causes them to be removed.

For LAW and Key Vault, transitioning from the existing data constructs to the new constructs that use managed identities can be done via a Cluster Update.

_Example 1:_ Add a UAMI to a Cluster and assign the UAMI (`myUAMI`) to the secret archive settings (Key Vault). If this Cluster had a SAMI defined, the SAMI would be removed.

```azurecli-interactive
az networkcloud cluster update --name "clusterName" --resource-group "resourceGroupName" \
   --mi-user-assigned "/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI" \
   --secret-archive-settings identity-type="UserAssignedIdentity" \
     identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI" \
     vault-uri="https://keyvaultname.vault.azure.net/"
```

_Example 2:_ Add UAMI `mySecondUAMI` to a Cluster that already has `myFirstUAMI`, which is retained, and update the Cluster to assign `mySecondUAMI` to the command output settings (Storage Account).

```azurecli-interactive
az networkcloud cluster update --name "clusterName" --resource-group "resourceGroupName" \
   --mi-user-assigned "/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myFirstUAMI" "/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mySecondUAMI" \
  --command-output-settings identity-type="UserAssignedIdentity" \
    identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mySecondUAMI" \
    container-url="https://myaccount.blob.core.windows.net/mycontainer"
```

_Example 3:_ Update a Cluster that already has a SAMI and add a UAMI and assign the UAMI to the log analytics output settings (LAW). The SAMI is retained.

> [!CAUTION]
> Changing the LAW settings causes a brief disruption in sending metrics to the LAW as the extensions that use the LAW might need to be reinstalled.

```azurecli-interactive
az networkcloud cluster update --name "clusterName" --resource-group "resourceGroupName" \
   --mi-user-assigned "/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI" \
   --mi-system-assigned \
   --analytics-output-settings analytics-workspace-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/microsoft.operationalInsights/workspaces/logAnalyticsWorkspaceName" \
     identity-type="UserAssignedIdentity" \
     identity-resource-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI"
```

### View the principal ID for the User Assigned Managed Identity

The identity resource ID can be found by selecting "JSON view" on the identity resource; the ID is at the top of the panel that appears. The container URL can be found on the Settings -> Properties tab of the container resource.

The Azure CLI is another option for viewing the identity and the associated principal ID data within the cluster.

_Example:_

```azurecli-interactive
az networkcloud cluster show --ids /subscriptions/<Subscription ID>/resourceGroups/<Cluster Resource Group Name>/providers/Microsoft.NetworkCloud/clusters/<Cluster Name>
```

_Output:_

```json
    "identity": {
        "type": "UserAssigned",
        "userAssignedIdentities": {
            "/subscriptions/subscriptionID/resourcegroups/<resourceGroupName>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<userAssignedIdentityName>": {
                "clientId": "00001111-aaaa-2222-bbbb-3333cccc4444",
                "principalId": "bbbbbbbb-cccc-dddd-2222-333333333333"
            }
        }
    },
```

## Operator Nexus Clusters with a System Assigned Managed Identity

Using a System Assigned Managed Identity (SAMI) follows a slightly different pattern from UAMIs. While the user provided resources (Storage Account, LAW and Key Vault) should be included in the Cluster creation command or template, the SAMI doesn't exist until the Cluster is created. After Cluster creation, users need to query the Cluster to get the SAMI, assign the correct privileges to the SAMI for each resource before deploying the Cluster.

For a new Cluster, these steps need to be completed before Cluster deployment. The impacts of not configuring these resources by deployment time for a new Cluster are as follows:

- _Storage Account:_ Cluster creation fails as there's a check to ensure that `commandOutputSettings` exists on the Cluster input.
- _LAW:_ Cluster deployment fails as the LAW is required to install software extensions during deployment.
- _Key Vault:_ Credential rotations fail as there's a check to ensure write access to the user provided Key Vault before performing credential rotation.

Updating the Cluster can be done at any time. Changing the LAW settings causes a brief disruption in sending metrics to the LAW as the extensions that use the LAW need to be reinstalled.

The following steps should be followed for using UAMIs with Nexus Clusters and associated resources.

_**Cluster Creation:**_

1. [Create the user provided resources](#initial-user-provided-resources-creation)
1. [Create the Cluster with a SAMI and specify the resources that use the SAMI](#create-the-cluster-with-a-sami-and-user-provided-resources)
1. [Get the SAMI by querying the Cluster](#get-the-sami-by-querying-the-cluster)
1. [Update the resources and assign the SAMI to the resources](#update-the-resources-and-assign-the-sami-to-the-resources)
1. Deploy the Cluster

_**Cluster Update:**_

1. [Create the user provided resources](#initial-user-provided-resources-creation)
1. [Add a SAMI via Cluster update](#add-a-sami-via-cluster-update)
1. [Get the SAMI by querying the Cluster](#get-the-sami-by-querying-the-cluster)
1. [Update the resources and assign the SAMI to the resources](#update-the-resources-and-assign-the-sami-to-the-resources)
1. [Update the Cluster with the user provided resources information](#update-the-cluster-with-the-user-provided-resources-information)

### Initial user provided resources creation

This section provides external links for the user resource setup that needs to occur before Cluster creation.

#### Initial Storage Accounts setup

1. Create a storage account, or identify an existing storage account that you want to use. See [Create an Azure storage account](/azure/storage/common/storage-account-create?tabs=azure-portal).
1. Create a blob storage container in the storage account. See [Create a container](/azure/storage/blobs/storage-quickstart-blobs-portal#create-a-container).

#### Initial Log Analytics Workspaces setup

- Create a Log Analytics Workspace (LAW), or identify an existing LAW that you want to use. See [Create a Log Analytics Workspace](/azure/azure-monitor/logs/quick-create-workspace).

#### Initial Key Vault setup

- Create a Key Vault, or identify an existing Key Vault that you want to use. See [Create a Key Vault](/azure/key-vault/general/quick-create-cli).

### Create the Cluster with a SAMI and user provided resources

When creating a Cluster with a system assigned managed identity, use the `--mi-system-assigned` parameter. The Cluster creation process generates the SAMI information. The user provided resources are also defined at the time of Cluster creation.

#### SAMI Storage Account settings

The `--command-output-settings` data construct is used to define the Storage Account where run command output is written. It consists of the following fields:

- `container-url`: The URL of the storage account container that is to be used by the specified identities.
- `identity-resource-id`: Not required when using a SAMI
- `identity-type`: The type of managed identity that's being selected. Use `SystemAssignedIdentity`.

#### SAMI Log Analytics Workspace settings

The `--analytics-output-settings` data construct is used to define the LAW where metrics are sent. It consists of the following fields:

- `analytics-workspace-id`: The resource ID of the analytics workspace that is to be used by the specified identity.
- `identity-resource-id`: Not required when using a SAMI
- `identity-type`: The type of managed identity that's being selected. Use `SystemAssignedIdentity`.

#### SAMI Key Vault settings

The `--secret-archive-settings` data construct is used to define the Key Vault where rotated credentials are written. It consists of the following fields:

- `identity-resource-id`: Not required when using a SAMI
- `identity-type`: The type of managed identity that's being selected. Use `SystemAssignedIdentity`.
- `vault-uri`: The URI for the key vault used as the secret archive.

#### SAMI Cluster create command example

_Example:_ This example is an abbreviated Cluster create command that specifies a SAMI and uses the SAMI for each of the user provided resources.

```azurecli-interactive
az networkcloud cluster create --name "clusterName" -g "resourceGroupName" \

    ...

   --mi-system-assigned \
   --command-output-settings identity-type="SystemAssignedIdentity" \
    container-url="https://myaccount.blob.core.windows.net/mycontainer"
   --analytics-output-settings analytics-workspace-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/microsoft.operationalInsights/workspaces/logAnalyticsWorkspaceName" \
    identity-type="SystemAssignedIdentity" \
   --secret-archive-settings identity-type="SystemAssignedIdentity" \
     vault-uri="https://keyvaultname.vault.azure.net/"
```

### Add a SAMI via Cluster update

When updating a Cluster with a system assigned managed identity, use the `--mi-system-assigned` parameter. The Cluster update process generates the SAMI information. The user provided resources are updated later to use the SAMI once the appropriate role assignments are made.

> [!IMPORTANT]
> When updating a Cluster with a UAMI or UAMIs in use, you must include the existing UAMIs in the `--mi-user-assigned` identity list when adding a SAMI or updating. If a SAMI is in use on the Cluster and you're adding a UAMI, you must include `--mi-system-assigned` in the update command. Failure to do so causes the respective managed identities to be removed.

These examples are for updating an existing Cluster to add a SAMI.

_Example 1:_ This example updates a Cluster to add a SAMI. Any UAMIs defined on the Cluster are removed.

```azurecli-interactive
az networkcloud cluster update --name "clusterName" -g "resourceGroupName" \
    --mi-system-assigned
```

_Example 2:_ This example updates a Cluster to add a SAMI and keeps the existing UAMI, `myUAMI`.

```azurecli-interactive
az networkcloud cluster update --name "clusterName" -g "resourceGroupName" \
    --mi-user-assigned "/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myUAMI" \
    --mi-system-assigned
```

### Get the SAMI by querying the Cluster

The identity resource ID can be found by selecting "JSON view" on the identity resource in the Azure portal.

The CLI can also be used to view the identity and the associated principal ID data within the cluster.

Note the `principalId` of the identity that is used when granting access to the resources.

_Example_:

```azurecli-interactive
az networkcloud cluster show --ids /subscriptions/<Subscription ID>/resourceGroups/<Cluster Resource Group Name>/providers/Microsoft.NetworkCloud/clusters/<Cluster Name>
```

System-assigned identity example:

```json
    "identity": {
        "principalId": "aaaaaaaa-bbbb-cccc-1111-222222222222",
        "tenantId": "aaaabbbb-0000-cccc-1111-dddd2222eeee",
        "type": "SystemAssigned"
    },
```

### Update the resources and assign the SAMI to the resources

These updates are applicable post Cluster creation or update to ensure that the SAMI has the appropriate role assignments and the resources are configured properly for Operator Nexus usage.

#### SAMI Storage Accounts setup

1. Assign the `Storage Blob Data Contributor` role to users and the SAMI that need access to the run-\* command output. See [Assign an Azure role for access to blob data](/azure/storage/blobs/assign-azure-role-data-access?tabs=portal).
1. To limit access to the Storage Account to a select set of IP or virtual networks, see [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security?tabs=azure-portal).
   1. The IPs for all users executing run-\* commands need to be added to the Storage Account's `Virtual Networks` and/or `Firewall` lists.
   1. Ensure `Allow Azure services on the trusted services list to access this storage account.` under `Exceptions` is selected.

#### SAMI Log Analytics Workspaces setup

- Assign the `Log Analytics Contributor` role to the SAMI for the log analytics workspace. See [Manage access to Log Analytics workspaces](/azure/azure-monitor/logs/manage-access?tabs=portal).

#### SAMI Key Vault setup

1. Enable the Key Vault for Role Based Access Control (RBAC). See [Enable Azure RBAC permissions on Key Vault](/azure/key-vault/general/rbac-guide?tabs=azure-cli#enable-azure-rbac-permissions-on-key-vault).
1. Assign the `Operator Nexus Key Vault Writer Service Role (Preview)` role to the SAMI for the Key Vault. See [Assign role](/azure/key-vault/general/rbac-guide?tabs=azure-cli#assign-role).
   1. The role definition ID for the Operator Nexus Key Vault Writer Service Role is `44f0a1a8-6fea-4b35-980a-8ff50c487c97`. This format is required if using the Azure command line to do the role assignment.
1. To limit access to the Key Vault to a select set of IP or virtual networks, see [Configure Azure Key Vault firewalls and virtual networks](/azure/key-vault/general/network-security?WT.mc_id=Portal-Microsoft_Azure_KeyVault).
   1. The IPs for all users requiring access to the Key Vault need to be added to the Key Vault's `Virtual Networks` and/or `Firewall` lists.
   1. Ensure the `Allow trusted Microsoft services to bypass this firewall.` under `Exceptions` is selected.

### Update the Cluster with the user provided resources information

This step is only required after updating a Cluster to add a SAMI and should be performed after updating the resources to assign the SAMI the appropriate role or roles.

#### SAMI Storage Account update settings

The `--command-output-settings` data construct is used to define the Storage Account where run command output is written. It consists of the following fields:

- `container-url`: The URL of the storage account container that is to be used by the specified identities.
- `identity-resource-id`: Not required when using a SAMI
- `identity-type`: The type of managed identity that's being selected. Use `SystemAssignedIdentity`.

#### SAMI Log Analytics Workspace update settings

The `--analytics-output-settings` data construct is used to define the LAW where metrics are sent. It consists of the following fields:

- `analytics-workspace-id`: The resource ID of the analytics workspace that is to be used by the specified identity.
- `identity-resource-id`: Not required when using a SAMI
- `identity-type`: The type of managed identity that's being selected. Use `SystemAssignedIdentity`.

#### SAMI Key Vault update settings

The `--secret-archive-settings` data construct is used to define the Key Vault where rotated credentials are written. It consists of the following fields:

- `identity-resource-id`: Not required when using a SAMI
- `identity-type`: The type of managed identity that's being selected. Use `SystemAssignedIdentity`.
- `vault-uri`: The URI for the key vault used as the secret archive.

#### SAMI Cluster update examples

Updating a Cluster follows the same pattern as create. If you need to change the UAMI for a resource, you must include it in both the `--mi-user-assigned` field and corresponding `--identity-resource-id` for the Storage Account, LAW or Key Vault. If there are multiple UAMIs in use, the full list of UAMIs must be specified in the `--mi-user-assigned` field when updating.

For LAW and Key Vault, transitioning from the existing data constructs to the new constructs that use UAMI can be done via a Cluster Update.

_Example 1:_ Add or update the command output settings (Storage Account) for a Cluster.

```azurecli-interactive
az networkcloud cluster update --name "clusterName" --resource-group "resourceGroupName" \
   --command-output-settings identity-type="SystemAssignedIdentity" \
    container-url="https://myaccount.blob.core.windows.net/mycontainer"
```

_Example 2:_ Add or update the log analytics output settings (LAW) for a Cluster.

> [!CAUTION]
> Changing the LAW settings causes a brief disruption in sending metrics to the LAW as the extensions that use the LAW need to be reinstalled.

```azurecli-interactive
az networkcloud cluster update --name "clusterName" --resource-group "resourceGroupName" \
   --analytics-output-settings analytics-workspace-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/microsoft.operationalInsights/workspaces/logAnalyticsWorkspaceName" \
    identity-type="SystemAssignedIdentity" \
```

_Example 3:_ Add or update the secret archive settings (Key Vault) for a Cluster.

```azurecli-interactive
az networkcloud cluster update --name "clusterName" --resource-group "resourceGroupName" \
   --secret-archive-settings identity-type="SystemAssignedIdentity" \
     vault-uri="https://keyvaultname.vault.azure.net/"
```

_Example 4:_ This example combines all three resources using a SAMI into one update.

```azurecli-interactive
az networkcloud cluster update --name "clusterName" --resource-group "resourceGroupName" \
   --command-output-settings identity-type="SystemAssignedIdentity" \
     container-url="https://myaccount.blob.core.windows.net/mycontainer"
   --analytics-output-settings analytics-workspace-id="/subscriptions/subscriptionId/resourceGroups/resourceGroupName/providers/microsoft.operationalInsights/workspaces/logAnalyticsWorkspaceName" \
     identity-type="SystemAssignedIdentity" \
   --secret-archive-settings identity-type="SystemAssignedIdentity" \
     vault-uri="https://keyvaultname.vault.azure.net/"
```

## Update Cluster identities via APIs

Cluster managed identities can be assigned via CLI. The unassignment of the identities can be done via API calls.
Note, `<APIVersion>` is the API version 2024-07-01 or newer.

- To remove all managed identities, execute:

  ```azurecli
  az rest --method PATCH --url /subscriptions/$SUB_ID/resourceGroups/$CLUSTER_RG/providers/Microsoft.NetworkCloud/clusters/$CLUSTER_NAME?api-version=<APIVersion> --body "{\"identity\":{\"type\":\"None\"}}"
  ```

- If both User-assigned and System-assigned managed identities were added, the User-assigned can be removed by updating the `type` to `SystemAssigned`:

  ```azurecli
  az rest --method PATCH --url /subscriptions/$SUB_ID/resourceGroups/$CLUSTER_RG/providers/Microsoft.NetworkCloud/clusters/$CLUSTER_NAME?api-version=<APIVersion> --body @~/uai-body.json
  ```

  The request body (uai-body.json) example:

  ```azurecli
  {
    "identity": {
        "type": "SystemAssigned"
    }
  }
  ```

- If both User-assigned and System-assigned managed identities were added, the System-assigned can be removed by updating the `type` to `UserAssigned`:

  ```azurecli
  az rest --method PATCH --url /subscriptions/$SUB_ID/resourceGroups/$CLUSTER_RG/providers/Microsoft.NetworkCloud/clusters/$CLUSTER_NAME?api-version=<APIVersion> --body @~/uai-body.json
  ```

  The request body (uai-body.json) example:

  ```azurecli
  {
    "identity": {
        "type": "UserAssigned",
        "userAssignedIdentities": {
          "/subscriptions/$SUB_ID/resourceGroups/$UAI_RESOURCE_GROUP/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$UAI_NAME": {}
        }
    }
  }
  ```

- If multiple User-assigned managed identities were added, one of them can be removed by executing:

  ```azurecli
  az rest --method PATCH --url /subscriptions/$SUB_ID/resourceGroups/$CLUSTER_RG/providers/Microsoft.NetworkCloud/clusters/$CLUSTER_NAME?api-version=<APIVersion> --body @~/uai-body.json
  ```

  The request body (uai-body.json) example:

  ```azurecli
  {
    "identity": {
        "type": "UserAssigned",
        "userAssignedIdentities": {
          "/subscriptions/$SUB_ID/resourceGroups/$UAI_RESOURCE_GROUP/providers/Microsoft.ManagedIdentity/userAssignedIdentities/$UAI_NAME": null
        }
    }
  }
  ```

## Field deprecations and replacements

This section is a reference for the deprecated resource fields and their replacements. All fields are found on the Cluster resource except for the Cluster Manager managed identity used for the deprecated key vault method. This list also assumes that an associated managed identity is defined on the Cluster that corresponds with the managed identity for the resource.

`identity-resource-id` is only required when using a UAMI. It shouldn't be specified if using a SAMI for the resource.

### Cluster Overview

Cluster Overview in the Azure portal reflects the new data fields.

:::image type="content" source="media/bring-your-own-resource/cluster-landing-page-inline.png" alt-text="Screenshot of the Azure portal Operator Nexus Cluster Overview page." lightbox="media/bring-your-own-resource/cluster-landing-page.png":::

1. The Overview Properties section contains read only views for `Log analytics`, `Secret archive` (Key Vault), and `Storage account`.
   1. Selecting `edit` next to each resource takes you to the resource specific page within Operator Nexus and allows for updating the resource & managed identity information.
1. The `Settings` navigation menu provides links to manage each of the resources.

> [!NOTE]
> The `Secret Archive` example reflects an instance where the Cluster was updated to populate `secretArchiveSettings` with the Key Vault URI and associated managed identity, but the legacy `secretArchive` fields remain populated. The Overview reflects both fields from a display perspective but the system only uses the `secretArchiveSettings`. If just `secretArchiveSettings` is populated, then only `Key Vault URI` is populated. The `Key Vault` field would be empty.

### Log Analytics Workspace

_**Deprecated Fields:**_ `analytics-workspace-id`

# [Azure CLI](#tab/azurecli)

The LAW information is provided and viewed via the `analytics-output-settings` data construct.

_**Replacing Fields:**_

```azurecli
analytics-output-settings:
  analytics-workspace-id
  identity-type
  identity-resource-id
```

# [Azure portal](#tab/azureportal)

In the Azure portal, the LAW information can be viewed and modified on the `Log analytics` page within Cluster Settings.

:::image type="content" source="media/bring-your-own-resource/law-details-inline.png" alt-text="Screenshot of Azure portal Operator Nexus user provided LAW settings." lightbox="media/bring-your-own-resource/law-details.png":::

---

The input format (LAW Azure Resource Manager (ARM) resource ID) is the same between the deprecated `analytics-workspace-id` field and the `analytics-workspace-id` within `analytics-output-settings`. The system updates the deprecated `analytics-workspace-id` field with the `analytics-output-settings:analytics-workspace-id` field. Updating the deprecated was done for backwards compatibility purposes during the transition period when moving from using the Service Principal to managed identity for authentication. It no longer has any use but is still present.

### Key Vault

_**Deprecated Fields:**_

```azurecli
cluster-secret-archive:
  use-key-vault
  key-vault-id
```

The Cluster Manager managed identity is used for authentication.

_**Replacing Fields:**_

# [Azure CLI](#tab/azurecli)

The Key Vault information is provided and viewed via the `secret-archive-settings` data construct. The Cluster managed identity is used in this construct.

```azurecli
secret-archive-settings:
  vault-uri
  identity-type
  identity-resource-id
```

# [Azure portal](#tab/azureportal)

In the Azure portal, the Key Vault information can be viewed and modified on the `Secret archive` page within Cluster Settings.

:::image type="content" source="media/bring-your-own-resource/key-vault-details-inline.png" alt-text="Screenshot of Azure portal Operator Nexus user provided Key Vault settings." lightbox="media/bring-your-own-resource/key-vault-details.png":::

---

`vault-uri` in `secret-archive-settings` is the URI for the Key Vault being specified versus the Azure Resource Manager (ARM) resource ID that is specified for `key-vault-id`. The same managed identity that was specified for the Cluster Manager can be used on the Cluster.

### Storage Account

_**Deprecated Fields:**_ N/A - Previously, the Storage Account was automatically created as part of Cluster Manager creation and didn't require customer input.

_**Replacing Fields:**_

# [Azure CLI](#tab/azurecli)

The Storage Account information is provided and viewed via the `command-output-settings` data construct.

```azurecli
command-output-settings:
  container-url
  identity-type
  identity-resource-id
```

# [Azure portal](#tab/azureportal)

In the Azure portal, the Storage Account information can be viewed and modified on the `Storage account` page within Cluster Settings.

:::image type="content" source="media/bring-your-own-resource/storage-account-details-inline.png" alt-text="Screenshot of Azure portal Operator Nexus user provided Storage Account settings." lightbox="media/bring-your-own-resource/storage-account-details.png":::

---

## Troubleshoot validation failures

When resource validation fails, the cluster's `AzurePrerequisitesReady` condition and action status display error information. This section provides guidance for resolving common validation failures.

### General troubleshooting steps

1. **Check the validation status** on the cluster using the Azure portal or CLI (see [Viewing validation status](#viewing-validation-status)).
2. **Identify the failing resource** from the error message (Log Analytics Workspace, Storage Account, or Key Vault).
3. **Verify the managed identity** is correctly assigned to the cluster.
4. **Confirm role assignments** on the target resource for the managed identity.
5. **Check firewall rules** if the resource has network restrictions.

### Log Analytics Workspace validation errors

| Error code                             | Description                                               | Remediation                                                                                                             |
|----------------------------------------|-----------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| `LogAnalyticsWorkspaceIdMissing`       | Workspace ID wasn't provided in `analyticsOutputSettings` | Set `analyticsOutputSettings.analyticsWorkspaceId` to the full ARM resource ID of your workspace                        |
| `LogAnalyticsWorkspaceIdInvalid`       | Workspace ID isn't a valid ARM resource ID                | Verify the format: `/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.OperationalInsights/workspaces/{name}` |
| `LogAnalyticsWorkspaceAccessDenied`    | Managed identity lacks permissions on the workspace       | Assign the `Log Analytics Contributor` role to the managed identity on the workspace                                    |
| `LogAnalyticsWorkspaceNotFound`        | The specified workspace doesn't exist                     | Verify the workspace exists and the resource ID is correct                                                              |
| `LogAnalyticsWorkspaceIdentityMissing` | No identity configured for workspace access               | Set `analyticsOutputSettings.identityType` and `identityResourceId` (for UAMI)                                          |

### Storage Account validation errors

| Error code | Description | Remediation |
| ---------- | ----------- | ----------- |
| `BlobContainerUrlMissing` | Container URL wasn't provided in `commandOutputSettings` | Set `commandOutputSettings.containerUrl` to your blob container URL |
| `BlobContainerUrlInvalid` | Container URL format is incorrect | Use format: `https://{account}.blob.core.windows.net/{container}` |
| `BlobContainerAccessDenied` | Managed identity lacks permissions on the container | Assign `Storage Blob Data Contributor` role to the managed identity on the storage account or container |
| `BlobContainerNotFound` | The specified container doesn't exist | Create the blob container in your storage account |
| `BlobContainerIdentityMissing` | No identity configured for storage access | Set `commandOutputSettings.identityType` and `identityResourceId` (for UAMI) |

**Storage Account firewall configuration:**

If your storage account has firewall rules enabled:

1. Ensure `Allow Azure services on the trusted services list to access this storage account` is selected under **Exceptions**.
2. Add the IP addresses of users who need to access run command output to the firewall allowlist.

### Key Vault validation errors

| Error code                   | Description                                          | Remediation                                                                              |
|------------------------------|------------------------------------------------------|------------------------------------------------------------------------------------------|
| `KeyVaultUriMissing`         | Vault URI wasn't provided in `secretArchiveSettings` | Set `secretArchiveSettings.vaultUri` to your Key Vault URI                               |
| `KeyVaultUriInvalid`         | Vault URI format is incorrect                        | Use format: `https://{vault-name}.vault.azure.net/`                                      |
| `KeyVaultAccessDenied`       | Managed identity lacks permissions on the vault      | Assign `Operator Nexus Key Vault Writer Service Role (Preview)` to the managed identity  |
| `KeyVaultNotFound`           | The specified Key Vault doesn't exist                | Verify the Key Vault exists and the URI is correct                                       |
| `KeyVaultIdentityMissing`    | No identity configured for Key Vault access          | Set `secretArchiveSettings.identityType` and `identityResourceId` (for UAMI)             |
| `KeyVaultSecretCreateFailed` | Failed to write test secret                          | Check Key Vault access policies or RBAC permissions; ensure RBAC is enabled on the vault |
| `KeyVaultSecretReadFailed`   | Failed to read test secret                           | Verify the identity has read permissions on secrets                                      |

**Key Vault firewall configuration:**

If your Key Vault has firewall rules enabled:

1. Ensure `Allow trusted Microsoft services to bypass this firewall` is selected under **Exceptions**.
2. Add the IP addresses of users who need direct Key Vault access to the firewall allowlist.

### Retrying validation

After correcting the resource configuration or role assignments, Validation is retried during reconciliation (typically within 2 minutes) while the action is in progress; if it doesn't succeed within 10 minutes, the action fails and must be retried after fixing the issue. For deployment or upgrade actions that failed due to validation:

1. Fix the underlying resource or permission issue.
2. The action automatically retries if it's still in progress, or
3. Restart the deployment or upgrade action if it was marked as failed.

### Getting additional help

If validation continues to fail after following the remediation steps:

1. Check the managed identity's principal ID matches what's assigned on the resources.
2. Verify there are no Azure Policy restrictions blocking access.
3. Review Azure Activity Logs on the target resource for denied requests.
4. Contact Microsoft Support with the cluster resource ID and validation error details.

For comprehensive troubleshooting guidance including additional error codes and common scenarios, see [Troubleshoot Azure prerequisites validation](troubleshoot-azure-prerequisites-validation.md).
