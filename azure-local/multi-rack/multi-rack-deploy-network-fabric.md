---
title: Deploy and validate the network fabric for multi-rack deployments
description: Create, provision, and validate the network fabric for a multi-rack deployment of Azure Local by using Azure CLI.
author: dmattern14
ms.author: dylanmattern
ms.service: azure-local
ms.subservice: multi-rack
ms.topic: how-to
ms.date: 11/03/2026
---

# Deploy and validate the network fabric for multi-rack deployments

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to deploy the network fabric for a multi-rack deployment of Azure Local by using Azure CLI. You create the fabric, connect it to your network, record the serial numbers of the network devices, provision the fabric, and then validate it before you deploy the Cluster.

The network fabric is an Azure resource of type `Microsoft.ManagedNetworkFabric/networkFabrics`. It represents the network devices, racks, and cabling in your datacenter, and Azure uses it to configure and manage those devices. For an introduction, see [Network fabric overview for multi-rack deployments of Azure Local](multi-rack-network-fabric-overview.md).

## Prerequisites

- Complete the [prerequisites for multi-rack deployments of Azure Local](multi-rack-prerequisites.md), including registering the `Microsoft.ManagedNetworkFabric` resource provider.
- Install Azure CLI and the `managednetworkfabric` extension. For more information, see [Install Azure CLI extensions for multi-rack deployments of Azure Local](multi-rack-cli-extensions.md).
- Use a Bash shell, such as Azure Cloud Shell or a Linux workstation, and install `jq`. The examples use Bash variables, and `jq` builds the terminal server configuration.
- [Create the Network Fabric Controller (NFC)](multi-rack-deploy-network-fabric-controller.md). Its `provisioningState` must be `Succeeded`, and you need its resource ID.
- Have permission to create resources in the target resource group, such as the Contributor role, and permission to assign the user-assigned managed identity to a resource, such as the Managed Identity Operator role on the identity.
- Make sure that the racks and network devices are installed, cabled, and powered on according to your approved bill of materials, and get the serial number of each network device.
- Configure your provider edge devices for the management network-to-network interconnect (NNI), and get the peering values from your network team.
- Have permission to assign Azure roles on the storage account and on the user-assigned managed identity, such as the Owner or User Access Administrator role.

## Prepare the storage account and managed identity

The fabric stores the results of validation commands in an Azure Storage account that you own, and it accesses that storage account by using a user-assigned managed identity. You supply both when you create the fabric. Prepare them first:

1. Create a user-assigned managed identity in the subscription where you deploy the fabric, or use an existing one. For more information, see [Manage user-assigned managed identities](/entra/identity/managed-identities-azure-resources/how-manage-user-assigned-managed-identities).
1. Create a storage account, or use an existing one. For more information, see [Create a storage account](/azure/storage/common/storage-account-create).
1. On the storage account, assign the **Storage Blob Data Contributor** role to the managed identity and to every user who needs to read the validation results. For more information, see [Assign an Azure role for access to blob data](/azure/storage/blobs/assign-azure-role-data-access).
1. Optionally, restrict network access to the storage account. In the storage account's firewall and virtual network settings, add the IP addresses of every user who needs to read the validation results. For more information, see [Configure Azure Storage firewalls and virtual networks](/azure/storage/common/storage-network-security).
1. In the storage account's network settings, under **Exceptions**, select **Allow Azure services on the trusted services list to access this storage account**.
1. On the managed identity, assign the **Managed Identity Operator** role to the **Managed Network Fabric RP** application, so that the fabric can use the identity. In the Azure portal, go to the managed identity, select **Access control (IAM)** > **Add role assignment**, select the **Managed Identity Operator** role, assign access to **User, group, or service principal**, select the **Managed Network Fabric RP** application as the member, and then select **Review + assign**.

## Set the variables

Set the variables that the commands in this article use, and replace the placeholders with your values. Use the fabric SKU for your approved hardware, and the fabric runtime version that your deployment supports. For `RACK_COUNT`, enter the number of compute racks, and don't count the aggregator rack. Choose a fabric ASN, an IPv4 prefix, and an IPv6 prefix that don't overlap your other networks. Get the terminal server values and the management peering values from your network team. The management networks use Option A peering, so for both the infrastructure and workload management networks you need the VLAN ID, the provider edge ASN, and the primary and secondary IPv4 prefixes. If you created the NFC in the same shell session, `NFC_ID` is already set, and the first line keeps its value.

```azurecli
NFC_ID="${NFC_ID:-/subscriptions/<subscription-id>/resourceGroups/<nfc-resource-group>/providers/Microsoft.ManagedNetworkFabric/networkFabricControllers/<nfc-name>}"
RESOURCE_GROUP="<resource-group>"
LOCATION="<azure-region>"
FABRIC_NAME="<fabric-name>"
FABRIC_SKU="<fabric-sku>"
FABRIC_VERSION="<fabric-runtime-version>"
RACK_COUNT="<compute-rack-count>"
SERVER_COUNT_PER_RACK="<servers-per-rack>"
FABRIC_ASN="<fabric-asn>"
FABRIC_IPV4_PREFIX="<ipv4-prefix>"
FABRIC_IPV6_PREFIX="<ipv6-prefix>"
TS_USERNAME="<terminal-server-user-name>"
TS_PRIMARY_IPV4_PREFIX="<terminal-server-primary-ipv4-prefix>"
TS_SECONDARY_IPV4_PREFIX="<terminal-server-secondary-ipv4-prefix>"
INFRA_VLAN_ID="<infrastructure-vlan-id>"
INFRA_PEER_ASN="<infrastructure-provider-edge-asn>"
INFRA_PRIMARY_IPV4_PREFIX="<infrastructure-primary-ipv4-prefix>"
INFRA_SECONDARY_IPV4_PREFIX="<infrastructure-secondary-ipv4-prefix>"
WORKLOAD_VLAN_ID="<workload-vlan-id>"
WORKLOAD_PEER_ASN="<workload-provider-edge-asn>"
WORKLOAD_PRIMARY_IPV4_PREFIX="<workload-primary-ipv4-prefix>"
WORKLOAD_SECONDARY_IPV4_PREFIX="<workload-secondary-ipv4-prefix>"
STORAGE_ACCOUNT_ID="/subscriptions/<subscription-id>/resourceGroups/<storage-resource-group>/providers/Microsoft.Storage/storageAccounts/<storage-account-name>"
IDENTITY_ID="/subscriptions/<subscription-id>/resourceGroups/<identity-resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identity-name>"
```

Enter the terminal server password at a hidden prompt so that it doesn't appear on screen or in your shell history. Then build the terminal server configuration with `jq`, which escapes any special characters in the password:

```bash
read -rsp "Terminal server password: " TS_PASSWORD; echo
TS_CONFIG=$(jq -n \
  --arg username "$TS_USERNAME" \
  --arg password "$TS_PASSWORD" \
  --arg primary "$TS_PRIMARY_IPV4_PREFIX" \
  --arg secondary "$TS_SECONDARY_IPV4_PREFIX" \
  '{username: $username, password: $password, primaryIpv4Prefix: $primary, secondaryIpv4Prefix: $secondary}')
```

## Create the fabric

1. Create the fabric:

    ```azurecli
    az networkfabric fabric create \
      --resource-group $RESOURCE_GROUP \
      --location $LOCATION \
      --resource-name $FABRIC_NAME \
      --nfc-id $NFC_ID \
      --nf-sku $FABRIC_SKU \
      --fabric-version $FABRIC_VERSION \
      --rack-count $RACK_COUNT \
      --server-count-per-rack $SERVER_COUNT_PER_RACK \
      --fabric-asn $FABRIC_ASN \
      --ipv4-prefix $FABRIC_IPV4_PREFIX \
      --ipv6-prefix $FABRIC_IPV6_PREFIX \
      --ts-config "$TS_CONFIG" \
      --managed-network-config "{infrastructureVpnConfiguration:{peeringOption:OptionA,optionAProperties:{mtu:1500,vlanId:$INFRA_VLAN_ID,peerASN:$INFRA_PEER_ASN,primaryIpv4Prefix:'$INFRA_PRIMARY_IPV4_PREFIX',secondaryIpv4Prefix:'$INFRA_SECONDARY_IPV4_PREFIX'}},workloadVpnConfiguration:{peeringOption:OptionA,optionAProperties:{mtu:1500,vlanId:$WORKLOAD_VLAN_ID,peerASN:$WORKLOAD_PEER_ASN,primaryIpv4Prefix:'$WORKLOAD_PRIMARY_IPV4_PREFIX',secondaryIpv4Prefix:'$WORKLOAD_SECONDARY_IPV4_PREFIX'}}}" \
      --mi-user-assigned $IDENTITY_ID \
      --storage-account-config "{storageAccountId:'$STORAGE_ACCOUNT_ID',storageAccountIdentity:{identityType:UserAssignedIdentity,userAssignedIdentityResourceId:'$IDENTITY_ID'}}" \
      --output none
    ```

1. Clear the password and the terminal server configuration from your shell:

    ```bash
    unset TS_PASSWORD TS_CONFIG
    ```

1. Check that the fabric was created, and save its resource ID:

    ```azurecli
    az networkfabric fabric show \
      --resource-group $RESOURCE_GROUP \
      --resource-name $FABRIC_NAME \
      --query provisioningState \
      --output tsv

    FABRIC_ID=$(az networkfabric fabric show \
      --resource-group $RESOURCE_GROUP \
      --resource-name $FABRIC_NAME \
      --query id \
      --output tsv)
    ```

    The fabric is created when the state is `Succeeded`.

## Create the management NNI

Create the NNI that connects the fabric's customer edge (CE) devices to your provider edge network. The management NNI uses Option A peering, so set `--use-option-b` to `False`. In the layer 2 configuration, set the MTU to 1500 and list the resource IDs of the interfaces on both CE devices that connect to your provider edge devices. Set the values from your network team, and then create the NNI:

```azurecli
NNI_NAME="<nni-name>"
NNI_CE1_INTERFACE_ID="<ce1-interface-resource-id>"
NNI_CE2_INTERFACE_ID="<ce2-interface-resource-id>"
NNI_PEER_ASN="<provider-edge-asn>"
NNI_VLAN_ID="<vlan-id>"
NNI_PRIMARY_IPV4_PREFIX="<primary-ipv4-prefix>"
NNI_SECONDARY_IPV4_PREFIX="<secondary-ipv4-prefix>"

az networkfabric nni create \
  --resource-group $RESOURCE_GROUP \
  --fabric $FABRIC_NAME \
  --resource-name $NNI_NAME \
  --is-management-type True \
  --use-option-b False \
  --layer2-configuration "{mtu:1500,interfaces:['$NNI_CE1_INTERFACE_ID','$NNI_CE2_INTERFACE_ID']}" \
  --option-b-layer3-configuration "{peerASN:$NNI_PEER_ASN,vlanId:$NNI_VLAN_ID,primaryIpv4Prefix:'$NNI_PRIMARY_IPV4_PREFIX',secondaryIpv4Prefix:'$NNI_SECONDARY_IPV4_PREFIX'}" \
  --output none
```

Confirm that the NNI's provisioning state is `Succeeded`:

```azurecli
az networkfabric nni show \
  --resource-group $RESOURCE_GROUP \
  --fabric $FABRIC_NAME \
  --resource-name $NNI_NAME \
  --query provisioningState \
  --output tsv
```

## Set the device serial numbers

Azure uses each device's serial number to identify the physical switch that it configures. You can't provision the fabric while any device is missing its serial number.

1. List the network devices in the fabric:

    ```azurecli
    az networkfabric device list \
      --resource-group $RESOURCE_GROUP \
      --query "[?networkFabricId=='$FABRIC_ID'].{name:name, role:networkDeviceRole, rack:networkRackId, serialNumber:serialNumber}" \
      --output table
    ```

1. For each device, set the serial number in the format `Make;Model;HardwareRevisionId;SerialNumber`. Use the values for the physical switch that you installed in the device's position.

    ```azurecli
    az networkfabric device update \
      --resource-group $RESOURCE_GROUP \
      --resource-name "<device-name>" \
      --serial-number "<make>;<model>;<hardware-revision-id>;<serial-number>" \
      --output none
    ```

1. Run the list command again, and confirm that every device has a serial number.

## Provision the fabric

Provisioning applies the configuration to the network devices.

```azurecli
az networkfabric fabric provision \
  --resource-group $RESOURCE_GROUP \
  --resource-name $FABRIC_NAME
```

If your session ends before the command returns, the operation continues in Azure. Check its progress as described in [Verify the fabric](#verify-the-fabric).

## Verify the fabric

Check the fabric states:

```azurecli
az networkfabric fabric show \
  --resource-group $RESOURCE_GROUP \
  --resource-name $FABRIC_NAME \
  --query "{provisioningState:provisioningState, configurationState:configurationState, administrativeState:administrativeState}" \
  --output json
```

The fabric is provisioned when `provisioningState` is `Succeeded`, `configurationState` is `Provisioned`, and `administrativeState` is `Enabled`.

If `configurationState` is `ErrorProvisioning`, first check the cabling and the device serial numbers:

- If you find a cabling or serial number mismatch, deprovision and delete the fabric, correct the cabling or the serial numbers, and then deploy the fabric again from [Create the fabric](#create-the-fabric):

    ```azurecli
    az networkfabric fabric deprovision \
      --resource-group $RESOURCE_GROUP \
      --resource-name $FABRIC_NAME

    az networkfabric fabric delete \
      --resource-group $RESOURCE_GROUP \
      --resource-name $FABRIC_NAME
    ```

- If you don't find a mismatch, get the details of the last operation, and then open a support request with the fabric resource ID and those details:

    ```azurecli
    az networkfabric fabric show \
      --resource-group $RESOURCE_GROUP \
      --resource-name $FABRIC_NAME \
      --query lastOperation.details \
      --output json
    ```

## Validate the fabric

After the fabric is provisioned, validate the cabling. The fabric writes the results to its storage account.

```azurecli
az networkfabric fabric validate-configuration \
  --resource-group $RESOURCE_GROUP \
  --resource-name $FABRIC_NAME \
  --validate-action Cabling
```

The command returns a `url` that points to the results in the storage account. Fix every reported mismatch, such as a cable connected to the wrong port, and then run the validation again. When the validation reports no mismatches, the fabric is ready. You need its resource ID, `FABRIC_ID`, to deploy the Cluster.

## Next steps

- [Deploy and validate a multi-rack cluster for Azure Local](multi-rack-deploy-cluster.md)
- [Manage Layer 3 isolation domains for multi-rack deployments of Azure Local](multi-rack-configure-layer-3-isolation-domain.md)
