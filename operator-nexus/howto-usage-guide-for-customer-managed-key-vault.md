---
title: How-to usage guide for Customer Managed Key Vault
description: How-to usage guide for Customer Managed Key Vault
ms.service: azure-operator-nexus
ms.custom: template-how-to
ms.topic: how-to
ms.date: 03/30/2026
author: RaghvendraMandawale
ms.author: rmandawale
---

# How to usage guide for Customer Managed Key Vault

Network Fabrics use secrets (passwords) to access the Terminal Server and Network Devices and these secrets are stored in a Key Vault in the Network Fabric Controller Managed Resource Group.

In some regions (currently `West US3` and `Brazil South`), Key Vaults don't have automatic cross‑region (paired‑region) replication. As a workaround to protect against a region outage, a customer may define a _Customer Managed Key Vault_. Once configured, secrets that are exposed to customers are duplicated to this Customer Managed Key Vault each time a password rotation occurs.

 
## Secret Archive Settings Configuration

The following steps are required to enable a Customer Managed Key Vault.

1. The customer creates a Key Vault in a different region
2. The customer uses the `Settings, Networkworking` menu to ensure that `Enable trusted Microsoft services to bypass this firewall` is enabled for the Customer Managed Key Vault. This is required to ensure that Network Fabric has a route to the Customer Key Vault when making password write requests.
3. The customer associates the User Assigned Managed Identity with the Network Fabric
4. The customer assigns the User Assigned Managed Identity `Operator Nexus Key Vault Writer Service Role (Preview)` permission for the Customer Managed Key Vault.
5. The customer uses the `2026-01-15-preview` ARM API to configure Customer Key Vault settings; in the ARM API these settings are known as the `Secret Archive Settings`.  The customer must configure:

   - The URI of the Customer Managed Key Vault
   - The type of Managed Identity (`UserAssignedIdentity` is preferred but `SystemAssignedIdentity` is possible)
   - The resource ID of the User Assigned Managed Identity (don't provide a resource ID if using `SystemAssignedIdentity`).
6. The `Secret Archive Settings` configuration must then be committed by locking the Network Fabric and committing the configuration.

Once this has been achieved, future Password Rotation operations duplicate customer accessible secrets to the Customer Managed Key Vault and customer visible secret references in the Network Fabric and Network Device configuration will indicate the secret and secret version in the Customer Managed Key Vault.

 

### Examples

It's assumed that the customer has created a Customer Managed Key Vault, a User Assigned Managed Identity, and has given the User Assigned Managed Identity the `Operator Nexus Key Vault Writer Service Role (Preview)` permission for the Customer Managed Key Vault

1. Associate the User assigned Managed Identity with the Network Fabric.

> [!Note]
> Note that you must retain the existing System Assigned Managed Identity and any pre-existing User Assigned Managed Identities.  These may be identified by using the `JSON View` link for the Network Fabric from the Azure portal and selecting the `2026-01-15-preview` ARM API version from the dropdown.  The existing configuration will look something like this:
 

```

{

    ...,

    "identity": {

        "principalId": "11223344-5566-7788-99aa-bbccddeeff00",

        "tenantId": "00ffeedd-ccbb-aa99-8877-665544332211",

        "type": "SystemAssigned, UserAssigned",

        "userAssignedIdentities": {

            "/subscriptions/<some-subscription>/resourcegroups/<some-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<some-user-assigned-identity>": {

                "principalId": "12345678-1234-1234-1234-1234567890ab",

                "clientId": "87654321-4321-4321-4321-ba0987654321"

            }

        }

    },

    "properties": {

        ...

    }

}

```

2. Now use the following `az` command to associate the new User Assigned Managed Identity with the Network Fabric.

```bash

$ # Note that the User Assigned Managed Identities are an array of strings.

$ az networkfabric fabric update \

--resource-group <my-nf-rg> \

--resource-name <my-nf> \

--mi-system-assigned 11223344-5566-7788-99aa-bbccddeeff00 \

--mi-user-assigned [ \

"/subscriptions/<some-subscription>/resourcegroups/<some-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<some-user-assigned-identity>", \

"/subscriptions/<my-subscription>/resourcegroups/<my-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<my-user-assigned-identity>", \

]

```

 

3. Configure the Customer Key Vault to the Network Fabric by first creating a configuration JSON body that looks like this:

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

 

4. Now use an `az rest` request to update the Network Fabric configuration:

 

```bash

$ az rest --method patch --uri https://management.azure.com//subscriptions/<my-subscription>/resourceGroups/<my-nf-rg>/providers/microsoft.managednetworkfabric/NetworkFabrics/<my-nf>?api-version=2026-01-15-preview --body @<config.json>

```

 
> [!Note]
> A future update to the `az` CLI will allow this update to be used using syntax similar to:

> 

> `az networkfabric fabric update -secret-archive-settings...`

 

5. Now use the normal _lock and commit_ process to make the new configuration active

 

```bash

$ az networkfabric fabric lock-fabric --lock-type Configuration --resource-group <my-nf-rg> --resource-name <my-nf>

$ az networkfabric fabric commit-configuration --resource-group <my-nf-rg> --resource-name <my-nf>

```

 

6. The next password rotation will cause the new secrets to be duplicated to the Customer Managed Key Vault:

 

```bash

$ az networkfabric fabric rotate-password --resource-group <my-nf-rg> --resource-name <my-nf>

```

 

### Remove Secret Archive Settings Configuration

Removing Secret Archive Settings configuration will mean that future Password Rotations **do not** copy secrets to the Customer Managed Key Vault and after a Password Rotation, **all** secret references in the Network Fabric and Network Device configuration will reference the Key Vault in the NetworkFabric Controller Managed Resource Group.

 

1. The customer should use `az rest...` and the `2026-01-15-preview` ARM API to remove Customer Key Vault settings; in the ARM API these settings are known as the `Secret Archive Settings`.The customer should set the `Secret Archive Settings` to `null`.

 
 ```json
  {
    "properties": {
     "secretArchiveSettings": null
    }
   }
 ```


2. The `Secret Archive Settings` removal must then be committed by locking the Network Fabric and committing the configuration.
3. The customer removes the `Operator Nexus Key Vault Writer Service Role (Preview)` permissions for the Customer Managed Key Vault from the User Assigned Managed Identity.
4. The customer disassociates the User assigned Managed Identity from the Network Fabric using the `az network fabric update...` command as above
5. (Optional) The customer deletes the User Assigned Managed Identity
6. (Optional) The customer deletes the Customer Managed Key Vault.
