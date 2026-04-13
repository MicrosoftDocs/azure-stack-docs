title: Terminal Server as an Azure Operator Nexus Resource
description: Learn how Terminal Servers (Bootstrap Devices) are modeled as ARM resources in Azure Operator Nexus for observability, automation, and lifecycle management.
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 04/09/2026
ms.custom: template-concept

# Terminal Server as an Azure Operator Nexus Resource

Terminal Servers (Bootstrap Devices) are modeled as Azure Resource Manager (ARM) resources within the Azure Operator Nexus (AON) platform to enable observability, automation, and lifecycle management.

Each Terminal Server is represented by two resource types:

- `NetworkBootstrapDevice` – captures device-level metadata such as hostname, serial number, SKU, version, administrative state, and provisioning status.
- `NetworkBootstrapInterface` – captures interface-level details such as interface type, administrative state, physical identifier, connected device, IP addresses, and description.

The `NetworkBootstrapInterface` is exposed as a child-resource of the `NetworkBootstrapDevice`. The physical interfaces on the terminal server such as `Net1`, `Net2`, and `Net3` are each modeled as ARM resources.

These resources are defined within the AON Managed Network Fabric API specification and are reflected in Azure Resource Manager under the Managed Network Fabric Resource Provider. They're also available in the Azure Resource Graph.

> [!NOTE]
> The Terminal Server (`NetworkBootstrapDevice`) doesn't support patchable properties or post-action workflows. Only read-only GET operations are supported, and no post actions are available as of the NNF `2604.1` release.

## Prerequisites

The Greenfield and Brownfield environments must run NNF MBU version `11.0`, Fabric Runtime version `8.0.0`, and API `2026-01-15-preview` to enable complete support for Terminal Server as an AON resource.

> [!NOTE]
> - If a user performs a Runtime (RT) upgrade to NF version `8.0.0` using the `2026-01-15-preview` API version, the Terminal Server ARM resources are created using the `2026-01-15-preview` API version.
> - If a user performs a Runtime (RT) upgrade to NF version `8.0.0` using the `2025-07-15` GA API version, the Terminal Server ARM resources are created using the `2025-07-15` GA API version.
> - If a user performs a Runtime (RT) upgrade to NF version `8.0.0` using ≤ `2025-07-15`, the Terminal Server ARM resources are created with the `2025-07-15` API version.
> - The same behavior applies during Greenfield deployments where the Network Fabric is created with NF RT version `8.0.0`.

## Customer Actions

### Greenfield Deployments

1. Initiate Network Fabric (NF) creation using the standard API or CLI; no additional presteps are required.
2. Provide basic Terminal Server device details (IP address, password) in the NF create payload. No changes to the existing workflow are required.
3. The service provisions NetworkBootstrapDevice and NetworkBootstrapInterface resources.
4. Service hydrates Bootstrap Device properties.
5. Service updates Bootstrap Device state to Succeeded or Failed based on reachability outcomes.

### Brownfield Deployments

1. Verify that the fabric version meets the prerequisites listed above; perform a runtime upgrade if needed.
2. The service identifies existing Bootstrap Devices, creates and associates the corresponding NetworkBootstrapDevice and NetworkBootstrapInterface resources.
3. The Service hydrates Bootstrap Device properties, and updates Bootstrap Device state based on validation results.

## Resource Properties

### NetworkBootstrapDevice

The `NetworkBootstrapDevice` resource captures device-level metadata for each Terminal Server associated with a Network Fabric. All properties listed below are **read-only** and are hydrated by the service during creation.

| Property | Type | Description |
|---|---|---|
| `hostName` | string | The hostname of the Terminal Server (Bootstrap Device). |
| `serialNumber` | string | The serial number of the Terminal Server device. |
| `networkDeviceSku` | string | The SKU identifier representing the device model and hardware type. |
| `version` | string | The firmware or software version running on the Terminal Server. |
| `networkFabricId` | string | The resource ID of the Network Fabric with which this device is associated. |
| `administrativeState` | string | The administrative state of the device (for example, `Enabled`, `Disabled`). |
| `provisioningState` | string | The provisioning state of the resource (for example, `Succeeded`, `Failed`, `Accepted`). |
| `configurationState` | string | The configuration state of the resource (for example, `Succeeded`, `Failed`). |
| `primaryManagementIpv4Address` | string | The primary IPv4 management address derived for Net1. |
| `secondaryManagementIpv4Address` | string | The secondary IPv4 management address derived for Net2. |
| `dhcpV4ServerIpAddress` | string | The DHCP IPv4 server address derived for Net3. |
| `primaryManagementIpv6Address` | string | The primary IPv6 management address. |
| `secondaryManagementIpv6Address` | string | The secondary IPv6 management address. |
| `secretRotationStatus` | array | The status of secret rotation for each credential type, including last rotation time, synchronization status, and Key Vault reference. |

### NetworkBootstrapInterface

The `NetworkBootstrapInterface` resource captures interface-level details for each Terminal Server interface. It's exposed as a child-resource of `NetworkBootstrapDevice`. `Net1`, `Net2`, and `Net3` are each modeled as ARM resources. All properties listed below are **read-only** and are hydrated by the service during creation.

| Property | Type | Description |
|---|---|---|
| `interfaceType` | string | The type of the interface. |
| `administrativeState` | string | The administrative state of the interface. |
| `operationalState` | string | The operational state of the interface. |
| `physicalIdentifier` | string | The physical port identifier on the Terminal Server device. |
| `connectedTo` | string | The network device to which this interface is connected. |
| `ipv4Address` | string | The IPv4 address assigned to the interface. |
| `ipv6Address` | string | The IPv6 address assigned to the interface. |
| `description` | string | An optional description of the interface. |
| `additionalDescription` | string | Supplementary description for the interface, used for operational context. |
| `provisioningState` | string | The provisioning state of the interface resource. |

## API Reference

The following section provides sample response payloads for `NetworkBootstrapDevice` and `NetworkBootstrapInterface` resources using the `2026-01-15-preview` API version.

### GET NetworkBootstrapDevice

Retrieves the device-level metadata for a Terminal Server (Bootstrap Device) associated with a Network Fabric.

#### Request

```http
GET /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/{networkBootstrapDeviceName}?api-version=2026-01-15-preview
```

| Parameter | Description |
|---|---|
| `subscriptionId` | The Azure subscription ID. |
| `resourceGroupName` | The name of the resource group. |
| `networkBootstrapDeviceName` | The name of the Terminal Server (Bootstrap Device) resource. |

**Request Body:** None.

#### Sample Response—200 OK

```json
{
  "id": "/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/example-device",
  "name": "example-device",
  "type": "microsoft.managednetworkfabric/networkbootstrapdevices",
  "location": "eastuseuap",
  "properties": {
    "annotation": "annotation",
    "hostName": "NFA-Device",
    "serialNumber": "Vendor;DCS-7280XXX-24;12.05;JPE2111XXXX",
    "networkDeviceSku": "DeviceSku",
    "version": "1.0",
    "networkFabricId": "/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourcegroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkFabrics/example-fabric",
    "administrativeState": "Enabled",
    "operationalState": "Up",
    "provisioningState": "Accepted",
    "configurationState": "Succeeded",
    "primaryManagementIpv4Address": "10.10.10.10",
    "secondaryManagementIpv4Address": "10.10.10.10",
    "dhcpV4ServerIpAddress": "10.10.10.10",
    "primaryManagementIpv6Address": "2F::1/100",
    "secondaryManagementIpv6Address": "2F::1/100",
    "controlPlaneAcls": [
      "/subscriptions/xxxxxx/resourceGroups/resourcegroupname/providers/Microsoft.ManagedNetworkFabric/accessControlLists/example-acl"
    ],
    "secretRotationStatus": [
      {
        "lastRotationTime": "2025-08-09T04:51:41.251Z",
        "synchronizationStatus": "InSync",
        "secretArchiveReference": {
          "keyVaultUri": "https://example-kv.vault.azure.net/secrets/example-secret-1/7e61b8efbcdd4e28963560dba3021df7",
          "keyVaultId": "/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourceGroups/example-rg/providers/Microsoft.KeyVault/vaults/example-kv",
          "secretName": "example-secret-1",
          "secretVersion": "7e61b8efbcdd4e28963560dba3021df7"
        },
        "secretType": "Admin user password"
      },
      {
        "lastRotationTime": "2025-08-09T02:32:12.904Z",
        "synchronizationStatus": "OutOfSync",
        "secretArchiveReference": {
          "keyVaultUri": "https://example-kv.vault.azure.net/secrets/example-secret-2/11a536561da34d6b8b452d880df58f3a",
          "keyVaultId": "/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourceGroups/example-rg/providers/Microsoft.KeyVault/vaults/example-kv",
          "secretName": "example-secret-2",
          "secretVersion": "11a536561da34d6b8b452d880df58f3a"
        },
        "secretType": "AzureOperatorRW user password"
      },
      {
        "lastRotationTime": "2025-08-09T02:32:12.904Z",
        "synchronizationStatus": "Synchronizing",
        "secretArchiveReference": {
          "keyVaultUri": "https://example-kv.vault.azure.net/secrets/example-secret-3/22b646561da34d6b8b452d880df69a4b",
          "keyVaultId": "/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourceGroups/example-rg/providers/Microsoft.KeyVault/vaults/example-kv",
          "secretName": "example-secret-3",
          "secretVersion": "22b646561da34d6b8b452d880df69a4b"
        },
        "secretType": "AzureOperatorRO user password"
      }
    ]
  },
  "systemData": {
    "createdBy": "email@address.com",
    "createdByType": "User",
    "createdAt": "2023-06-09T04:51:41.251Z",
    "lastModifiedBy": "UserId",
    "lastModifiedByType": "User",
    "lastModifiedAt": "2023-06-09T04:51:41.251Z"
  }
}
```

### GET NetworkBootstrapInterface

Retrieves the interface-level details for a specific Terminal Server interface.

#### Request

```http
GET /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/{networkBootstrapDeviceName}/networkBootstrapInterfaces/{networkBootstrapInterfaceName}?api-version=2026-01-15-preview
```

| Parameter | Description |
|---|---|
| `subscriptionId` | The Azure subscription ID. |
| `resourceGroupName` | The name of the resource group. |
| `networkBootstrapDeviceName` | The name of the parent Terminal Server (Bootstrap Device) resource. |
| `networkBootstrapInterfaceName` | The name of the interface resource (`net1`, `net2`, or `net3`). |

**Request Body:** None.

#### Sample Response—200 OK

```json
{
  "id": "/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourcegroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/example-device/networkBootstrapInterfaces/example-interface",
  "name": "example-interface",
  "type": "microsoft.managednetworkfabric/networkBootstrapDevices/networkBootstrapInterfaces",
  "properties": {
    "annotation": "annotation",
    "administrativeState": "Enabled",
    "operationalState": "Up",
    "interfaceType": "Management",
    "additionalDescription": "additionalDescription",
    "provisioningState": "Accepted",
    "physicalIdentifier": "physicalIdentifier",
    "connectedTo": "connectedTo",
    "description": "description",
    "ipv4Address": "10.10.10.10",
    "ipv6Address": "2001:0db8:85a3:0000:0000:8a2e:0370:7334"
  },
  "systemData": {
    "createdBy": "email@address.com",
    "createdByType": "User",
    "createdAt": "2023-06-09T04:51:41.251Z",
    "lastModifiedBy": "UserId",
    "lastModifiedByType": "User",
    "lastModifiedAt": "2023-06-09T04:51:41.251Z"
  }
}
```

### Response Codes

| Code | Description |
|---|---|
| `200 OK` | The request succeeded. The response body contains the NetworkBootstrapInterface resource. |
| `400 Bad Request` | The request was malformed or contained invalid parameters. |
| `404 Not Found` | The specified resource doesn't exist. |
