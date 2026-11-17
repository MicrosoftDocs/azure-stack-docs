---
title: Deploy and validate a multi-rack cluster for Azure Local
description: Create the Cluster Manager, and then create, deploy, and validate the Cluster for a multi-rack deployment of Azure Local by using Azure CLI.
author: dmattern14
ms.author: dylanmattern
ms.service: azure-local
ms.subservice: multi-rack
ms.topic: how-to
ms.date: 11/03/2026
---

# Deploy and validate a multi-rack cluster for Azure Local

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to use Azure CLI to first create the Cluster Manager, and then create, deploy, and validate the Cluster for a multi-rack deployment of Azure Local.

## About the Cluster Manager and the Cluster

- **Cluster Manager**: An Azure resource of type `Microsoft.NetworkCloud/clusterManagers` that manages the lifecycle of your Clusters. It references your Network Fabric Controller (NFC), provides the custom location where you create the Cluster, and lists the cluster runtime versions that you can deploy.
- **Cluster**: An Azure resource of type `Microsoft.NetworkCloud/clusters` that represents the servers and storage appliance in your racks. It references your network fabric.

Creating the Cluster resource doesn't change anything on your servers. The Cluster stays in the `PendingDeployment` state until you run the deploy action, which validates the Azure prerequisites and the hardware, provisions the servers, and installs the cluster runtime.

## Prerequisites

- Complete the [prerequisites for multi-rack deployments of Azure Local](multi-rack-prerequisites.md), including registering the resource providers in your subscription.
- Install Azure CLI and the `networkcloud` extension. For more information, see [Install Azure CLI extensions for multi-rack deployments of Azure Local](multi-rack-cli-extensions.md).
- Use a Bash shell, such as Azure Cloud Shell or a Linux workstation, and install `jq`. The examples use Bash variables, and `jq` reads the rack definitions from files.
- Sign in to Azure CLI, and select the subscription that contains your NFC and network fabric.
- Have permission to create resources and to assign roles in the target resource groups, such as the Owner role, or the Contributor and Role Based Access Control Administrator roles.
- [Create the NFC](multi-rack-deploy-network-fabric-controller.md), and confirm that its `provisioningState` is `Succeeded`.
- Ensure that the servers and the storage appliance in your racks are installed, cabled, and powered on according to your approved bill of materials.
- Before you create the Cluster resource, complete network fabric deployment, provisioning, and cabling validation by using your deployment's network plan, as described in [Deploy and validate the network fabric](multi-rack-deploy-network-fabric.md). Confirm that the fabric's `configurationState` is `Provisioned`, address any reported validation failures, and save its resource ID. You can complete [Create the Cluster Manager](#create-the-cluster-manager) before or while the fabric is being provisioned.

## Gather the rack and server details

For each rack, gather:

- The resource ID of the network rack that the network fabric created for it. To list them, run `az networkfabric rack list --resource-group <fabric-resource-group> --query "[].{name:name, id:id}" --output table`.
- The resource ID of the rack SKU that matches your hardware. To list the rack SKUs, run `az networkcloud racksku list --output table`.
- A unique rack serial number or other identifier, and optionally a description of the rack's location.

For each server in a compute rack, gather:

- A machine name of 2–64 letters and numbers.
- The rack slot and the serial number or service tag.
- The MAC address of the baseboard management controller (BMC) and the MAC address of the boot (PXE) network interface. Use the addresses that you recorded from the installed hardware.
- The BMC user name and password.

For the storage appliance in the aggregator rack, gather its name, rack slot, serial number, and administrator user name and password.

Don't enter these passwords in the Cluster definition. Instead, store them as secrets in a key vault and give the Cluster each secret's URI, as described in [Store the hardware passwords in a key vault](#store-the-hardware-passwords-in-a-key-vault).

## Set the variables

Set the variables that the commands in this article use, and replace the placeholders with your values. `NFC_ID` and `FABRIC_ID` are the resource IDs of the NFC and the network fabric. If you created the NFC and the network fabric in the same shell session, they're already set, and the first two lines keep their values.

```azurecli
NFC_ID="${NFC_ID:-/subscriptions/<subscription-id>/resourceGroups/<nfc-resource-group>/providers/Microsoft.ManagedNetworkFabric/networkFabricControllers/<nfc-name>}"
FABRIC_ID="${FABRIC_ID:-/subscriptions/<subscription-id>/resourceGroups/<fabric-resource-group>/providers/Microsoft.ManagedNetworkFabric/networkFabrics/<fabric-name>}"
RESOURCE_GROUP="<resource-group>"
LOCATION="<azure-region>"
CLUSTER_MANAGER_NAME="<cluster-manager-name>"
CLUSTER_NAME="<cluster-name>"
CLUSTER_MRG="<cluster-managed-resource-group-name>"
CLUSTER_IDENTITY_NAME="<identity-name>"
WORKSPACE_NAME="<log-analytics-workspace-name>"
STORAGE_ACCOUNT_NAME="<storage-account-name>"
CONTAINER_NAME="<container-name>"
KEY_VAULT_NAME="<key-vault-name>"
CREDENTIALS_KEY_VAULT_NAME="<credentials-key-vault-name>"
```

## Create the Cluster Manager

1. Create the Cluster Manager from the NFC:

    ```azurecli
    az networkcloud clustermanager create \
      --resource-group $RESOURCE_GROUP \
      --location $LOCATION \
      --name $CLUSTER_MANAGER_NAME \
      --fabric-controller-id $NFC_ID \
      --kind AzureLocal \
      --mi-system-assigned \
      --output none
    ```

1. Check the status of the Cluster Manager:

    ```azurecli
    az networkcloud clustermanager show \
      --resource-group $RESOURCE_GROUP \
      --name $CLUSTER_MANAGER_NAME \
      --query "{provisioningState:provisioningState, detailedStatus:detailedStatus}" \
      --output json
    ```

    The Cluster Manager is ready when `provisioningState` is `Succeeded` and `detailedStatus` is `Available`. If your session ends before the create command returns, the operation continues in Azure.

1. List the cluster runtime versions that the Cluster Manager can deploy:

    ```azurecli
    az networkcloud clustermanager show \
      --resource-group $RESOURCE_GROUP \
      --name $CLUSTER_MANAGER_NAME \
      --query "clusterVersions[].{version:targetClusterVersion, supportExpiryDate:supportExpiryDate}" \
      --output table
    ```

    Your account team tells you which runtime version to use for your hardware. Save that version.

    ```azurecli
    CLUSTER_VERSION="<cluster-version>"
    ```

1. Save the Cluster Manager's custom location:

    ```azurecli
    CM_CUSTOM_LOCATION_ID=$(az networkcloud clustermanager show \
      --resource-group $RESOURCE_GROUP \
      --name $CLUSTER_MANAGER_NAME \
      --query managerExtendedLocation.name \
      --output tsv)
    echo $CM_CUSTOM_LOCATION_ID
    ```

## Prepare the managed identity and Azure resources

The Cluster uses a user-assigned managed identity to write logs to a Log Analytics workspace, write command output to a storage container, and store the credentials that it manages in a key vault. Create the identity and grant it access before you create the Cluster. For this walkthrough, create the managed identity, Log Analytics workspace, storage account, and key vault in the same Azure region as the Cluster.

1. Create the user-assigned managed identity, and save its resource ID and principal ID:

    ```azurecli
    az identity create --resource-group $RESOURCE_GROUP --location $LOCATION --name $CLUSTER_IDENTITY_NAME --output none

    CLUSTER_IDENTITY_ID=$(az identity show --resource-group $RESOURCE_GROUP --name $CLUSTER_IDENTITY_NAME --query id --output tsv)
    CLUSTER_IDENTITY_PRINCIPAL_ID=$(az identity show --resource-group $RESOURCE_GROUP --name $CLUSTER_IDENTITY_NAME --query principalId --output tsv)
    ```

1. Create the Log Analytics workspace, or use an existing one, and save its resource ID:

    ```azurecli
    az monitor log-analytics workspace create --resource-group $RESOURCE_GROUP --location $LOCATION --workspace-name $WORKSPACE_NAME --output none

    WORKSPACE_ID=$(az monitor log-analytics workspace show --resource-group $RESOURCE_GROUP --workspace-name $WORKSPACE_NAME --query id --output tsv)
    ```

1. Create the storage account and the blob container, or use existing ones, and save their IDs.

    Ensure that the identity running Azure CLI has the **Storage Blob Data Contributor** role, or equivalent data permissions, on the storage account or a parent scope. This permission is separate from the role assigned to the Cluster's managed identity, and Owner or Contributor permissions alone don't grant it. If the role was just assigned, allow time for the assignment to propagate before you create the container.

    ```azurecli
    az storage account create --resource-group $RESOURCE_GROUP --location $LOCATION --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --allow-blob-public-access false --output none
    az storage container create --account-name $STORAGE_ACCOUNT_NAME --name $CONTAINER_NAME --auth-mode login --output none

    STORAGE_ACCOUNT_ID=$(az storage account show --resource-group $RESOURCE_GROUP --name $STORAGE_ACCOUNT_NAME --query id --output tsv)
    CONTAINER_ID="$STORAGE_ACCOUNT_ID/blobServices/default/containers/$CONTAINER_NAME"
    CONTAINER_URL="https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$CONTAINER_NAME"
    ```

1. Create a key vault that uses Azure role-based access control (RBAC), or use an existing one, and save its ID and URI:

    ```azurecli
    az keyvault create --resource-group $RESOURCE_GROUP --location $LOCATION --name $KEY_VAULT_NAME --enable-rbac-authorization true --output none

    KEY_VAULT_ID=$(az keyvault show --resource-group $RESOURCE_GROUP --name $KEY_VAULT_NAME --query id --output tsv)
    KEY_VAULT_URI=$(az keyvault show --resource-group $RESOURCE_GROUP --name $KEY_VAULT_NAME --query properties.vaultUri --output tsv)
    ```

1. Grant the identity access to each resource:

    ```azurecli
    az role assignment create --assignee-object-id $CLUSTER_IDENTITY_PRINCIPAL_ID --assignee-principal-type ServicePrincipal \
      --role "Log Analytics Contributor" --scope $WORKSPACE_ID --output none

    az role assignment create --assignee-object-id $CLUSTER_IDENTITY_PRINCIPAL_ID --assignee-principal-type ServicePrincipal \
      --role "Storage Blob Data Contributor" --scope $CONTAINER_ID --output none

    az role assignment create --assignee-object-id $CLUSTER_IDENTITY_PRINCIPAL_ID --assignee-principal-type ServicePrincipal \
      --role "44f0a1a8-6fea-4b35-980a-8ff50c487c97" --scope $KEY_VAULT_ID --output none
    ```

    The last command assigns the built-in role that lets the Cluster write secrets to the key vault. It uses the role's ID.

## Store the hardware passwords in a key vault

The Cluster reads the BMC and storage appliance passwords from Key Vault secrets. In the rack definitions, the `password` field holds the URI of the secret, not the password. The Cluster retrieves each password once, when it's created or updated, and then stores it securely.

Use a separate key vault for these secrets, rather than the key vault that the Cluster writes to. This separation keeps access to each key vault to the least privilege that it needs.

1. Create a key vault that uses Azure RBAC for the hardware passwords, or use an existing one, and save its ID:

    ```azurecli
    az keyvault create --resource-group $RESOURCE_GROUP --location $LOCATION --name $CREDENTIALS_KEY_VAULT_NAME --enable-rbac-authorization true --output none

    CREDENTIALS_KEY_VAULT_ID=$(az keyvault show --resource-group $RESOURCE_GROUP --name $CREDENTIALS_KEY_VAULT_NAME --query id --output tsv)
    ```

1. Add a secret for the BMC password and a secret for the storage appliance password to the key vault. If your servers use different BMC passwords, add a secret for each password. To keep the passwords out of your command history, add the secrets in the Azure portal or with your organization's secret management process. You need the **Key Vault Secrets Officer** role, or equivalent permissions, on the key vault to add secrets.

1. Save the URI of each secret:

    ```azurecli
    BMC_PASSWORD_URI=$(az keyvault secret show --vault-name $CREDENTIALS_KEY_VAULT_NAME --name <bmc-password-secret-name> --query id --output tsv)
    STORAGE_PASSWORD_URI=$(az keyvault secret show --vault-name $CREDENTIALS_KEY_VAULT_NAME --name <storage-password-secret-name> --query id --output tsv)
    echo $BMC_PASSWORD_URI $STORAGE_PASSWORD_URI
    ```

    Each URI has the form `https://<key-vault-name>.vault.azure.net/secrets/<secret-name>/<version>`. The version is optional. Include it to use a specific version of the secret.

1. Let the Cluster's managed identity read the secrets by assigning it the **Key Vault Secrets User** role on the key vault:

    ```azurecli
    az role assignment create --assignee-object-id $CLUSTER_IDENTITY_PRINCIPAL_ID --assignee-principal-type ServicePrincipal \
      --role "Key Vault Secrets User" --scope $CREDENTIALS_KEY_VAULT_ID --output none
    ```

    This role is separate from the role that lets the Cluster write secrets to its own key vault.

## Prepare the rack definitions

Describe the aggregator rack and the compute racks in two JSON files. In each `password` field, enter the URI of the Key Vault secret that holds the password. The files contain no passwords.

1. Create a file named `aggregator-rack.json` that describes the aggregator rack and its storage appliance:

    ```json
    {
      "network-rack-id": "<aggregator-network-rack-resource-id>",
      "rack-sku-id": "<aggregator-rack-sku-resource-id>",
      "rack-serial-number": "<aggregator-rack-serial-number>",
      "rack-location": "<aggregator-rack-location>",
      "bare-metal-machine-configuration-data": [],
      "storage-appliance-configuration-data": [
        {
          "storage-appliance-name": "<storage-appliance-name>",
          "rack-slot": <storage-appliance-rack-slot>,
          "serial-number": "<storage-appliance-serial-number>",
          "admin-credentials": { "username": "<storage-admin-user-name>", "password": "<storage-password-secret-uri>" }
        }
      ]
    }
    ```

1. Create a file named `compute-racks.json` that lists each compute rack and its servers. Add one rack object for each compute rack, and one machine object for each server in the rack:

    ```json
    [
      {
        "network-rack-id": "<compute-network-rack-1-resource-id>",
        "rack-sku-id": "<compute-rack-sku-resource-id>",
        "rack-serial-number": "<compute-rack-1-serial-number>",
        "rack-location": "<compute-rack-1-location>",
        "storage-appliance-configuration-data": [],
        "bare-metal-machine-configuration-data": [
          {
            "machine-name": "<machine-name>",
            "rack-slot": <rack-slot>,
            "serial-number": "<serial-number>",
            "bmc-mac-address": "<bmc-mac-address>",
            "boot-mac-address": "<boot-mac-address>",
            "machine-details": "<asset-tag-or-other-details>",
            "bmc-credentials": { "username": "<bmc-user-name>", "password": "<bmc-password-secret-uri>" }
          }
        ]
      }
    ]
    ```

## Create the Cluster

1. Create the Cluster resource. Set `value` in `--compute-deployment-threshold` to the percentage of compute servers that must pass hardware validation for deployment to continue.

    ```azurecli
    az networkcloud cluster create \
      --resource-group $RESOURCE_GROUP \
      --location $LOCATION \
      --name $CLUSTER_NAME \
      --extended-location name=$CM_CUSTOM_LOCATION_ID type=CustomLocation \
      --cluster-type MultiRack \
      --cluster-version $CLUSTER_VERSION \
      --network-fabric-id $FABRIC_ID \
      --mrg name=$CLUSTER_MRG \
      --mi-user-assigned $CLUSTER_IDENTITY_ID \
      --analytics-output-settings analytics-workspace-id=$WORKSPACE_ID identity-type=UserAssignedIdentity identity-resource-id=$CLUSTER_IDENTITY_ID \
      --command-output-settings container-url=$CONTAINER_URL identity-type=UserAssignedIdentity identity-resource-id=$CLUSTER_IDENTITY_ID \
      --secret-archive-settings vault-uri=$KEY_VAULT_URI identity-type=UserAssignedIdentity identity-resource-id=$CLUSTER_IDENTITY_ID \
      --compute-deployment-threshold type=PercentSuccess grouping=PerCluster value=<percent> \
      --aggregator-or-single-rack-definition "$(jq -c . aggregator-rack.json)" \
      --compute-rack-definitions "$(jq -c . compute-racks.json)" \
      --output none
    ```

1. Check the status of the Cluster resource:

    ```azurecli
    az networkcloud cluster show \
      --resource-group $RESOURCE_GROUP \
      --name $CLUSTER_NAME \
      --query "{provisioningState:provisioningState, detailedStatus:detailedStatus}" \
      --output json
    ```

    The Cluster resource is ready for deployment when `provisioningState` is `Succeeded` and `detailedStatus` is `PendingDeployment`.

1. Confirm that Azure created a resource for each server, and that each server has a BMC connection string. Don't deploy the Cluster until every server has one.

    ```azurecli
    az networkcloud baremetalmachine list \
      --resource-group $CLUSTER_MRG \
      --query "[].{name:name, rackSlot:rackSlot, bmcConnectionString:bmcConnectionString}" \
      --output table
    ```

## Deploy the Cluster

> [!WARNING]
> Deployment provisions every server in the Cluster. Hardware validation resets the storage controllers, which erases all data on the servers' disks. Back up any data that you need before you deploy.

1. Run the deploy action:

    ```azurecli
    az networkcloud cluster deploy \
      --resource-group $RESOURCE_GROUP \
      --name $CLUSTER_NAME \
      --no-wait
    ```

    The deploy action checks that the Cluster's identity can reach the Log Analytics workspace, the storage container, and the key vault. It then validates the hardware, provisions the servers, and installs the cluster runtime.

1. Check the progress until `detailedStatus` changes to `Running` or `Failed`:

    ```azurecli
    az networkcloud cluster show \
      --resource-group $RESOURCE_GROUP \
      --name $CLUSTER_NAME \
      --query "{detailedStatus:detailedStatus, message:detailedStatusMessage}" \
      --output json
    ```

    While the Cluster is being deployed, `detailedStatus` is `Deploying`, and `message` describes the current stage.

### If the deployment fails

To see why the deploy action failed, check its `message` and step states:

```azurecli
az networkcloud cluster show \
  --resource-group $RESOURCE_GROUP \
  --name $CLUSTER_NAME \
  --query "actionStates[].{action:actionType, status:status, message:message, steps:stepStates[].{step:stepName, status:status}}" \
  --output json
```

- **The Azure prerequisites step or hardware validation fails**: Check the reported cause, and check `hardwareValidationStatus` and `detailedStatusMessage` for each server. If the message reports an access error for the workspace, the container, or either key vault, check the role assignments of the Cluster's identity, and allow time for new assignments to propagate. Correct the cause, and then run the deploy action again.
- **`detailedStatus` is `Failed`, or the failure occurred after server provisioning began**: Collect the Cluster resource ID and the deploy action's `message` and step states, and open a support request for recovery guidance before you delete or re-create the Cluster.

## Verify the deployment

1. Confirm that the Cluster is running and connected:

    ```azurecli
    az networkcloud cluster show \
      --resource-group $RESOURCE_GROUP \
      --name $CLUSTER_NAME \
      --query "{detailedStatus:detailedStatus, connection:clusterConnectionStatus, managerConnection:clusterManagerConnectionStatus}" \
      --output json
    ```

    The deployment succeeds when `detailedStatus` is `Running`, `connection` is `Connected`, and `managerConnection` is `Connected`.

1. Check the servers and the storage appliance:

    ```azurecli
    az networkcloud baremetalmachine list \
      --resource-group $CLUSTER_MRG \
      --query "[].{name:name, detailedStatus:detailedStatus, readyState:readyState, hardwareValidation:hardwareValidationStatus.result}" \
      --output table

    az networkcloud storageappliance list \
      --resource-group $CLUSTER_MRG \
      --query "[].{name:name, detailedStatus:detailedStatus}" \
      --output table
    ```

    Each deployed server shows `Provisioned`, `True`, and `Pass`, and the storage appliance shows `Available`.

## Next steps

- [Security concepts for multi-rack deployments of Azure Local](multi-rack-security.md)
- [Manage Layer 3 isolation domains for multi-rack deployments of Azure Local](multi-rack-configure-layer-3-isolation-domain.md)
