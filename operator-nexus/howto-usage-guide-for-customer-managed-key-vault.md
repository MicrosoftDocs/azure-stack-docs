---
title: Usage Guide for Customer-Managed Key Vault
description: This article lists steps you need to take to enable a customer-managed key vault. The article includes examples to help you use a customer-managed key vault.
ms.service: azure-operator-nexus
ms.custom: template-how-to
ms.topic: how-to
ms.date: 06/17/2026
author: raghvendramandawale
ms.author: rmandawale
---

# Enable and use a customer-managed key vault

Network Fabric uses secrets (passwords) to access the terminal server and network devices. The Network Fabric Controller managed resource group stores these secrets in an Azure Key Vault.

In some regions (currently `West US3` and `Brazil South`), Key Vaults don't have automatic cross‑region (paired‑region) replication. As a workaround to protect against a region outage, you can define a _customer-managed Key Vault_. After you configure this type of Key Vault, each time a password rotation occurs, you duplicate secrets that are exposed to customers to this Key Vault.

## Secret archive settings configuration

To enable a customer-managed Key Vault, complete the following steps:

1. Create a customer-managed Key Vault in a different region.

1. Use the **Settings** > **Networking** menu to ensure that **Enable trusted Microsoft services to bypass this firewall** is enabled for the Key Vault. This step ensures that Network Fabric has a route to the customer-managed Key Vault when the service makes password write requests.

1. Associate the user-assigned managed identity (UAMI) with the Network Fabric.  Confirm the association is correct before continuing.

1. Assign the UAMI **Operator Nexus Key Vault Writer Service Role (Preview)** permission for the customer-managed Key Vault.

1. Use the **2026-01-15-preview** Azure Resource Manager API to configure customer-managed Key Vault settings. These settings are known as the _Secret Archive Settings_. You must configure:

    - The URI of the customer-managed Key Vault.  
    - The type of managed identity should be `UserAssignedIdentity`.  `SystemAssignedIdentity` isn't supported and is rejected.  
    - The resource ID of the UAMI.

1. Lock the Network Fabric and commit the `Secret Archive Settings` configuration.

After you complete these steps, future password rotation operations duplicate customer accessible secrets to the customer-managed Key Vault. Customer visible secret references in the Network Fabric and Network Device configuration indicate the secret and secret version in the customer-managed Key Vault.

### Examples

For these examples, assume that you created a customer-managed Key Vault. You also created a UAMI, and you gave the UAMI the `Operator Nexus Key Vault Writer Service Role (Preview)` permission for the customer-managed Key Vault.

1. Update the `az` CLI `managednetworkfabric` extension
    ```bash
    $ az extension add --name managednetworkfabric --upgrade --allow-preview true
    ```
    This update allows you to install the preview version of the extension, which contains the new support for `Secret Archive Settings`.  The preview version at time of writing is `10.0.0b1`; the full release `10.0.0` will contain this functionality. Once this version is released, you can run the preceding command without the need for `--allow-preview true`.

1. Associate the UAMI with the Network Fabric.

    > [!Note]
    > You must retain the existing system-assigned managed identity and any pre-existing UAMIs. You can identify these identities by using the `JSON View` link for Network Fabric from the Azure portal. Select the `2026-01-15-preview` Azure Resource Manager API version from the dropdown list. The existing configuration looks something like the following code, but be aware that there might not be an existing user-assigned managed identity in your Network Fabric.

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

1. Use the following `az` command to associate the new UAMI with Network Fabric.

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

1. Confirm that your UAMI has `Operator Nexus Key Vault Writer Service Role (Preview) permission` for the customer-managed Key Vault.  The next step validates this permission by making a test write to the customer-managed Key Vault. If this test write fails, the update to the Network Fabric fails.

1. Configure the `Secret Archive Settings` to Network Fabric:

    ```bash
    $ az networkfabric fabric update --secret-archive-settings "{associated-identity:{identity-type:UserAssignedIdentity,user-assigned-identity-resource-id:/subscriptions/<my-subscription>/resourceGroups/<my-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<my-uami>},vault-uri:'https://mykeyvault.vault.azure.net/'}" --resource-group <my-nf-rg> --resource-name <my-nf>
    ```

1. Use the normal _lock and commit_ process to make the new configuration active.

    ```bash
    $ az networkfabric fabric lock-fabric --lock-type Configuration --resource-group <my-nf-rg> --resource-name <my-nf>
    $ az networkfabric fabric commit-configuration --resource-group <my-nf-rg> --resource-name <my-nf>
    ```

1. The next password rotation causes the new secrets to be duplicated to the customer-managed Key Vault.

    ```bash   
    $ az networkfabric fabric rotate-password --resource-group <my-nf-rg> --resource-name <my-nf>
    ```

## Remove `Secret Archive Settings` configuration

You can remove the customer-managed Key Vault configuration. If you remove this configuration, future password rotations don't copy secrets to the customer-managed Key Vault. After a password rotation, all secret references in the Network Fabric and Network Device configuration reference the Key Vault in the Network Fabric Controller managed resource group.

1. Use the `az` CLI to remove the `Secret Archive Settings`.

     ```bash
     $ az networkfabric fabric update --secret-archive-settings null --resource-group <my-nf-rg> --resource-name <my-nf>
     ```

1. Lock the Network Fabric and commit the `Secret Archive Settings` removal configuration.

1. Remove the `Operator Nexus Key Vault Writer Service Role (Preview)` permissions for the key vault from the UAMI.

1. (Optional) Disassociate the UAMI from the Network Fabric by using the `az network fabric update...` command.

1. (Optional) Delete the UAMI.

1. (Optional) Delete the key vault.

## Creating a Network Fabric with `Secret Archive Settings`
You can create a Network Fabric directly with customer-managed Key Vault configuration but keep the following points in mind:
- Before attempting to create the Network Fabric, ensure that the UAMI has `Operator Nexus Key Vault Writer Service Role (Preview)` permissions to the customer-managed Key Vault.
- As part of creating the Network Fabric, you must also associate the UAMI with the Network Fabric.
- During Network Fabric creation, the process validates access to the customer-managed Key Vault by using a test write. If the UAMI isn't associated with the Network Fabric, or the `Secret Archive Settings` are incorrect, or the UAMI doesn't have `Operator Nexus Key Vault Writer Service Role (Preview)` permission for the customer-managed Key Vault, Network Fabric creation fails.
