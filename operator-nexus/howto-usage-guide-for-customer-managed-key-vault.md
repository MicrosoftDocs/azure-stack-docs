---
title: Usage Guide for Customer-Managed Key Vault
description: This article lists steps you need to take to enable a customer-managed key vault. The article includes examples to help you use a customer-managed key vault.
ms.service: azure-operator-nexus
ms.custom: template-how-to
ms.topic: how-to
ms.date: 03/30/2026
author: ronmiab
ms.author: robess
---

# Enable and use a customer-managed key vault

Network Fabric uses secrets (passwords) to access the terminal server and network devices. These secrets are stored in Azure Key Vault in the Network Fabric Controller managed resource group.

In some regions (currently `West US3` and `Brazil South`), key vaults don't have automatic cross‑region (paired‑region) replication. As a workaround to protect against a region outage, you can define a _customer-managed key vault_. After you configure this type of key vault, each time a password rotation occurs, you duplicate secrets that are exposed to customers to this key vault.

## Secret archive settings configuration

The following steps are required to enable a customer-managed key vault.

1. Create a key vault in a different region.

1. Use the **Settings** > **Networkworking** menu to ensure that **Enable trusted Microsoft services to bypass this firewall** is enabled for the key vault. This step is required to ensure that Network Fabric has a route to the key vault when the service makes password write requests.

1. Associate the user-assigned managed identity (UAMI) with Network Fabric.

1. Assign the UAMI **Operator Nexus Key Vault Writer Service Role (Preview)** permission for the key vault.

1. Use the **2026-01-15-preview** Azure Resource Manager API to configure key vault settings. These settings are known as the _secret archive settings_. You must configure:

    - The URI of the customer-managed key vault.  
    - The type of managed identity (`UserAssignedIdentity` is preferred, but `SystemAssignedIdentity` is possible).  
    - The resource ID of the UAMI. Don't provide a resource ID if you're using `SystemAssignedIdentity`.

1. Lock the Network Fabric and commit the secret archive settings configuration.

After you complete these steps, future password rotation operations duplicate customer accessible secrets to the key vault. Customer visible secret references in the Network Fabric and network device configuration indicate the secret and secret version in the customer-managed key vault.

### Examples

For these examples, let's assume that you create a customer-managed key vault. You also create a UAMI, and you give the UAMI the `Operator Nexus Key Vault Writer Service Role (Preview)` permission for the key vault.

1. Associate the UAMI with Network Fabric.

    > [!Note]
    > You must retain the existing system-assigned managed identity and any pre-existing UAMIs. You can identify these by using the `JSON View` link for Network Fabric from the Azure portal. Select the `2026-01-15-preview` Azure Resource Manager API version from the dropdown list. The existing configuration looks something like the following code.

   ```
    {
        ...,
        "identity": {
            "principalId": "aaaaaaaa-bbbb-cccc-1111-222222222222",
            "tenantId": "aaaabbbb-0000-cccc-1111-dddd2222eeee",
            "type": "SystemAssigned, UserAssigned",
            "userAssignedIdentities": {
                "/subscriptions/<some-subscription>/resourcegroups/<some-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<some-user-assigned-identity>": {
                    "principalId": "bbbbbbbb-cccc-dddd-2222-333333333333",
                    "clientId": "00001111-aaaa-2222-bbbb-3333cccc4444"
                }
            }
        },
    
        "properties": {
            ...
        }
    }
    ```

1. Now use the following `az` command to associate the new UAMI with Network Fabric.

    ```bash
    $ # Note that the UAMIs are an array of strings.
    $ az networkfabric fabric update \
    --resource-group <my-nf-rg> \
    --resource-name <my-nf> \
    --mi-system-assigned aaaaaaaa-bbbb-cccc-1111-222222222222 \
    --mi-user-assigned [ \
    "/subscriptions/<some-subscription>/resourcegroups/<some-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<some-user-assigned-identity>", \
    "/subscriptions/<my-subscription>/resourcegroups/<my-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<my-user-assigned-identity>", \
    ]
    ```

1. Configure the key vault to Network Fabric by first creating a configuration JSON body. Your code looks like this example.

    ```json
    {
      "properties": {
        "secretArchiveSettings": {
          "vaultUri": "https://mykeyvaultname.vault.azure.net/",
          "associatedIdentity": {
            "identityType": "UserAssignedIdentity",
            "userAssignedIdentityResourceId": "/subscriptions/<my-subscription>/resourceGroups/<my-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<my-user-assigned-managed-identity>"
          }
        }
      }
    }
    ```

1. Now use an `az rest` request to update the Network Fabric configuration:

    ```bash
    $ az rest --method patch --uri https://management.azure.com//subscriptions/<my-subscription>/resourceGroups/<my-nf-rg>/providers/microsoft.managednetworkfabric/NetworkFabrics/<my-nf>?api-version=2026-01-15-preview --body @<config.json>
    ```

1. Use the normal _lock and commit_ process to make the new configuration active.

    ```bash
    $ az networkfabric fabric lock-fabric --lock-type Configuration --resource-group <my-nf-rg> --resource-name <my-nf>
    $ az networkfabric fabric commit-configuration --resource-group <my-nf-rg> --resource-name <my-nf>
    ```

1. The next password rotation causes the new secrets to be duplicated to the key vault.

    ```bash
    
    $ az networkfabric fabric rotate-password --resource-group <my-nf-rg> --resource-name <my-nf>
    
    ```

## Remove secret archive settings configuration

You can remove the secret archive settings configuration. If you do so, future password rotations don't copy secrets to the key vault. After a password rotation, all secret references in the Network Fabric and network device configuration reference the key vault in the Network Fabric Controller managed resource group.

1. Use `az rest...` and the `2026-01-15-preview` Azure Resource Manager API to remove key vault settings. In the Azure Resource Manager API, these settings are known as the `Secret Archive Settings`. Set `Secret Archive Settings` to `null`.

     ```json
      {
        "properties": {
         "secretArchiveSettings": null
        }
       }
     ```

1. Lock the Network Fabric and commit the `Secret Archive Settings` removal configuration.

1. Remove the `Operator Nexus Key Vault Writer Service Role (Preview)` permissions for the key vault from the UAMI.

1. Disassociate the UAMI from Network Fabric by using the `az network fabric update...` command.

1. (Optional) Delete the UAMI.

1. (Optional) Delete the key vault.
