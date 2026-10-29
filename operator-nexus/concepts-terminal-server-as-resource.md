---
title: Terminal server as an Azure Operator Nexus Resource
description: Learn how Terminal Servers (Bootstrap Devices) are modeled as ARM resources in Azure Operator Nexus for observability, automation, and lifecycle management.
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: concept-article
ms.date: 10/18/2026
ms.custom: template-concept
---

# Terminal server as an Azure Operator Nexus resource

Terminal Servers (Bootstrap Devices) are modeled as Azure Resource Manager (ARM) resources within the Azure Operator Nexus (AON) platform to enable observability, automation, and lifecycle management.

Each Terminal Server is represented by two resource types:

- `NetworkBootstrapDevice` – captures device-level metadata such as hostname, serial number, SKU, version, administrative state, and provisioning status.
- `NetworkBootstrapInterface` – captures interface-level details such as interface type, administrative state, physical identifier, connected device, IP addresses, and description.

The `NetworkBootstrapInterface` is exposed as a child-resource of the `NetworkBootstrapDevice`. The physical interfaces on the terminal server such as `Net1`, `Net2`, and `Net3` are each modeled as ARM resources.

These resources are defined within the AON Managed Network Fabric API specification and are reflected in Azure Resource Manager under the Managed Network Fabric Resource Provider. They're also available in the Azure Resource Graph.

> [!NOTE]
> - You can create the Net2 interface, but it isn't operational as a backup for Net1.

## Prerequisites
- Network Fabric runtime version `8.0.0` or later.
- API version `2026-01-15-preview` or later.

Additional requirements for metrics, NTP synchronization, and RMA are listed in their sections.

When a Network Fabric is created with, or upgraded to, runtime version `8.0.0` or later, the service discovers the Terminal Servers, creates the corresponding `NetworkBootstrapDevice` and `NetworkBootstrapInterface` resources, populates their properties, and updates the device state based on reachability checks.

> [!NOTE]
> The Terminal Server resources are created with the API version used for the fabric creation or runtime upgrade. If you use the `2026-01-15-preview` API version, the resources are created with that version. If you use `2025-07-15` or earlier, they're created with the `2025-07-15` API version.

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

The `NetworkBootstrapInterface` resource captures interface-level details for each Terminal Server interface. It's exposed as a child-resource of `NetworkBootstrapDevice`. `Net1`, `Net2`, and `Net3` are each modeled as ARM resources. All properties listed below are **read-only** and the service sets them during creation.

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

The following section provides sample response payloads for `NetworkBootstrapDevice` and `NetworkBootstrapInterface` resources by using the `2026-01-15-preview` API version.

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

## Terminal server NTP synchronization

Azure Operator Nexus automatically configures NTP on the Terminal Server (Network Bootstrap Device) by using the platform-managed Infrastructure NTP Service. The Terminal Server uses the same NTP servers as the Network Fabric devices, which provides consistent device time for time-sensitive platform operations.

You don't need to configure NTP servers or manage server addresses on the Terminal Server.

### Prerequisites for NTP synchronization

- Network Fabric runtime version `8.0.0` or later.

### Enable NTP synchronization

NTP is configured automatically on the Terminal Server during Network Fabric provisioning, or when a runtime upgrade to version `8.0.0` or later completes. NTP is also configured on a replacement Terminal Server as part of the RMA post action. No action is required.

### Check NTP synchronization

Azure doesn't show an NTP synchronization status or metric for the Terminal Server. To check that NTP is running and the clock is synchronized, sign in to the Terminal Server and view the NTP status on the device.

> [!NOTE]
> If NTP isn't configured on the Terminal Server, open a support request to reprovision the Terminal Server.


## Post Actions

Users can invoke the following post actions:

- Reboot
- Interface Admin Down / Up for `Net3` only
- Refresh Configuration
- Resync Password
- Terminal Server replacement (RMA): Disable, RMA, and Enable

All post actions are auditable, state-driven, and security-bounded. Use the `2026-01-15-preview` API version or later to invoke these post actions, except RMA, which requires the `2026-07-15-preview` API version

### Reboot

Reboot performs a controlled restart of the Terminal Server OS for recovery or maintenance.

#### Request

```http
POST "/subscriptions/<subscriptionId>/resourceGroups/<resourcegroup> /providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/<networkbootstrapdevicename>/reboot?api-version=<api-version>"
```

| Parameter | Description |
|---|---|
| `subscriptionId` | The Azure subscription ID. |
| `resourceGroupName` | The name of the resource group. |
| `networkBootstrapDeviceName` | The name of the Terminal Server (`NetworkBootstrapDevice`) resource. |

**Request Body:** None.

#### Sample Response - 202 Accepted

```http
HTTP/1.1 202 Accepted
Azure-AsyncOperation: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-15-preview
Location: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-15-preview
Retry-After: 30
```

**Response Body:** None.

### Update administrative state

This post action updates the administrative state of the Terminal Server `Net3` interface. Use this action to administratively enable or disable `Net3` for troubleshooting or isolation.

#### Request

```http
post "/subscriptions/<subscriptionId>/resourceGroups/<resourcegroup>/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/<networkbootstrapdevicename>/networkBootstrapInterfaces/net3/UpdateAdministrativeState?api-version=<api-version>" "{""state"":""Enable""}"
```

| Parameter | Description |
|---|---|
| `subscriptionId` | The Azure subscription ID. |
| `resourceGroupName` | The name of the resource group. |
| `networkBootstrapDeviceName` | The name of the parent Terminal Server (`NetworkBootstrapDevice`) resource. |
| `networkBootstrapInterfaceName` | The name of the interface resource. For this release, use `net3`. |

#### Request Body

Use `Enable` to administratively enable the interface and `Disable` to administratively disable the interface.

```json
{
  "state": "Enable"
}
```

#### Sample Response - 202 Accepted

```http
HTTP/1.1 202 Accepted
Azure-AsyncOperation: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-15-preview
Location: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-15-preview
Retry-After: 30
```

**Response Body:** None.

### Refresh Configuration

This post action re-applies Microsoft-managed Terminal Server configuration. This action refreshes the software package, regenerates configuration for the current fabric version, copies required certificates and Network Fabric configuration, and restarts required components. It doesn't modify customer-managed configuration.

#### Request

```http
 post "/subscriptions/<subscriptionId>/resourceGroups/<resourcegroup>/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/<networkbootstrapdevicename>/refreshConfiguration?api-version=<api-version>"
```

| Parameter | Description |
|---|---|
| `subscriptionId` | The Azure subscription ID. |
| `resourceGroupName` | The name of the resource group. |
| `networkBootstrapDeviceName` | The name of the Terminal Server (`NetworkBootstrapDevice`) resource. |

**Request Body:** None.

#### Sample Response - 202 Accepted

```http
HTTP/1.1 202 Accepted
Azure-AsyncOperation: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-15-preview
Location: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-15-preview
Retry-After: 30
```

**Response Body:** None.

### Resync Passwords

This post action synchronizes the Terminal Server with the latest device credential reference. The response never includes credentials. If the operation fails, the prior credential remains active, and the response provides error details through operation status.

#### Request

```http
post "/subscriptions/<subscriptionId>/resourceGroups/<resourcegroup>/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/<networkbootstrapdevicename>/resyncPasswords?api-version=<api-version>" 
```

| Parameter | Description |
|---|---|
| `subscriptionId` | The Azure subscription ID. |
| `resourceGroupName` | The name of the resource group. |
| `networkBootstrapDeviceName` | The name of the Terminal Server (`NetworkBootstrapDevice`) resource. |

**Request Body:** None.

#### Sample Response - 202 Accepted

```http
HTTP/1.1 202 Accepted
Azure-AsyncOperation: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-15-preview
Location: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-15-preview
Retry-After: 30
```

**Response Body:** None.

### Terminal server replacement (RMA)

Azure Operator Nexus supports replacing a failed Terminal Server (Network Bootstrap Device) and returning the replacement device to service as an Azure Operator Nexus resource. The replacement is driven by administrative state post actions on the `NetworkBootstrapDevice` resource: Disable takes the Terminal Server out of service, RMA reprovisions the replacement device and automatically discovers and updates its serial number, and Enable returns it to service.

NTP is configured on the replacement device, and Terminal Server metrics resume after the device is enabled. Use the `2026-07-15-preview` API version to invoke this post action.

#### RMA prerequisites

- Network Fabric runtime version `8.0.0` or later.
- The Network Fabric is provisioned (provisioning state `Succeeded` and configuration state `Provisioned`).
- The Network Fabric isn't administratively locked or configuration-locked. Post actions are blocked while the fabric is locked.
- Customer-managed firewall configuration is applied to the replacement device before you run the RMA post action.

#### Replace a terminal server

1. Disable the Terminal Server. The Network Fabric administrative state changes to `EnabledDegraded`.
1. If the existing Terminal Server is still accessible, complete the [pre-replacement cleanup](howto-replace-terminal-server.md#pre-replacement-cleanup-customer-action).
1. Remove the existing device, and then install and set up the replacement device. For the steps, see [Device removal](howto-replace-terminal-server.md#device-removal-customer-action) and [Installation of new device](howto-replace-terminal-server.md#installation-of-new-device-customer-action).
1. Run the RMA post action to reprovision the replacement device.
1. After the RMA completes, the Terminal Server remains in the `UnderMaintenance` state. Enable the Terminal Server to return it to service.

#### Operations blocked while the terminal server is disabled

While the Terminal Server is in the `Disabled` or `UnderMaintenance` state, the following operations are rejected with a `BadRequest` error until the Terminal Server is enabled:

- Terminal Server: Reboot, Refresh Configuration, Resync Passwords, and Network Bootstrap Interface administrative state updates.
- Network devices: ZTP-based reboot, certificate resynchronization, and RMA. Reboot without ZTP isn't affected.

Fabric provisioning, initial ZTP, fabric upgrade, and device reimage aren't blocked, but they might fail if they require the Terminal Server DHCP or HTTP services. Enable, Disable, and RMA of the Terminal Server itself remain available, and resource create, update, and delete operations aren't affected.

> [!NOTE]
> If the replacement device runs a different OS version, the `version` property of the `NetworkBootstrapDevice` resource continues to show the version recorded before the RMA.

#### Pre-validation errors

Each post action validates the Network Fabric and Terminal Server state before it runs. If a check fails, the request is rejected:

| Condition | Error code |
|---|---|
| The Network Fabric is administratively locked or configuration-locked. | `ResourceLocked` |
| The Network Fabric isn't in an allowed state for the action. | `BadRequest` |
| The Terminal Server isn't in an allowed state for the action. For example, RMA is accepted only when the Terminal Server is `Disabled`. | `BadRequest` |

#### Update terminal server administrative state

Use this post action to disable, replace (RMA), or enable the Terminal Server.

- `Disable` takes the Terminal Server out of service before replacement.
- `RMA` reprovisions the replacement Terminal Server and updates its serial number. Run it after the Terminal Server is disabled and the device is physically replaced.
- `Enable` returns the Terminal Server to service, including after an RMA completes.

##### Request

```http
POST /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/{networkBootstrapDeviceName}/updateAdministrativeState?api-version=2026-07-15-preview
```

| Parameter | Description |
|---|---|
| `subscriptionId` | The Azure subscription ID. |
| `resourceGroupName` | The name of the resource group. |
| `networkBootstrapDeviceName` | The name of the Terminal Server (`NetworkBootstrapDevice`) resource. |

##### Request Body

Set `state` to `Disable`, `RMA`, or `Enable`.

```json
{
  "state": "Disable"
}
```

##### Sample Response - 202 Accepted

```http
HTTP/1.1 202 Accepted
Azure-AsyncOperation: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=-07-15-preview
Location: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-07-15-preview
Retry-After: 30
```

**Response Body:** None.


### Response Codes

| Code | Description |
|---|---|
| `200 OK` | The request succeeded. The response body contains the NetworkBootstrapInterface resource. |
| `400 Bad Request` | The request was malformed or contained invalid parameters, or a pre-validation check failed. |
| `404 Not Found` | The specified resource doesn't exist. |
| `202 Accepted` | The post action request is accepted. |


## Terminal server metrics

Azure Operator Nexus collects health and utilization metrics from the Terminal Server (Network Bootstrap Device) and publishes them to Azure Monitor on the `NetworkBootstrapDevice` resource. The metrics give you visibility into the health of the device, including system resources, network interfaces, serial port traffic, and power supplies, for operational monitoring, dashboards, and alerts.

Metrics are collected securely over SNMPv3 by using a read-only account that the service configures and manages. You don't need to set up SNMP on the Terminal Server.

### Supported metrics

The following Terminal Server metrics are collected every five minutes and are available in Azure Monitor on the `NetworkBootstrapDevice` resource.

| Metric group | Metrics | Applies to | Reported as |
|---|---|---|---|
| Storage and memory | `hrStorageUsed`, `hrStorageSize` | Physical memory, virtual memory, `/mnt/nvram`, `/var/log`, and `/tmp` | Used and total allocation units |
| Network interfaces | `ifAdminStatus`, `ifOperStatus`, `ifInOctets`, `ifOutOctets`, `ifInDiscards`, `ifOutDiscards`, `ifInErrors`, `ifOutErrors` | Terminal Server network interfaces | Status: state value. Octets, discards, and errors: cumulative counts |
| Voltage | `lmVoltSensorsValue` | Voltage sensors `in2` and `in4` | Millivolts |
| Serial ports | `ogOmSerialPortRxBytes`, `ogOmSerialPortTxBytes` | Serial ports | Cumulative byte counts |
| Power supplies | `ogOmPowerSupplyInputVoltage`, `ogOmPowerSupplyOutputCurrent`, `ogOmPowerSupplyOutputPower` | Power supplies PSU1 and PSU2 | Millivolts, milliamps, and watts |

Values are reported as emitted by the Terminal Server, without unit conversion. Counters are reported as cumulative counts, not as rates or percentages. No values are filled in for intervals with no data.

### Prerequisites for metrics

- Network Fabric runtime version `9.0.0`.
- Terminal Server (Opengear) OS version `25.11.5` or later.
- SNMPv3 polling access over UDP port `161` on `Net1`.
- The `NetworkBootstrapDevice` resource is available for the Network Fabric.
- The Terminal Server firewall allows SNMP traffic: add `snmp` to the `wan` firewall zone address filters.

### Enable terminal server metrics

Metrics are enabled automatically when the Network Fabric runs runtime version `9.0.0`. No additional configuration is required.

If you upgrade the Terminal Server OS to a supported version later, run the Refresh Configuration post action on the `NetworkBootstrapDevice` resource to start metrics collection.

#### Request

```http
POST /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedNetworkFabric/networkBootstrapDevices/{networkBootstrapDeviceName}/refreshConfiguration?api-version=2026-07-15-preview
```

| Parameter | Description |
|---|---|
| `subscriptionId` | The Azure subscription ID. |
| `resourceGroupName` | The name of the resource group. |
| `networkBootstrapDeviceName` | The name of the Terminal Server (`NetworkBootstrapDevice`) resource. |

**Request Body:** None.

#### Sample Response - 202 Accepted

```http
HTTP/1.1 202 Accepted
Azure-AsyncOperation: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-07-15-preview
Location: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.ManagedNetworkFabric/locations/{location}/operationStatuses/{operationId}?api-version=2026-07-15-preview
Retry-After: 30
```

**Response Body:** None.

### Resolve out-of-sync SNMP credentials

The `synchronizationStatus` value in the `secretRotationStatus` property of the `NetworkBootstrapDevice` resource shows the status of the SNMP credentials. If the SNMP credentials are `OutOfSync`, run the **Refresh Configuration** post action on a Network Fabric that runs runtime version `9.0.0`.

A successful Refresh Configuration generates and applies new SNMP credentials and sets their status to `InSync`. It doesn't resynchronize the existing out-of-sync credentials.

### View Terminal Server metrics

In the Azure portal, open the `NetworkBootstrapDevice` resource and select **Monitoring** > **Metrics**.

> [!NOTE]
> - SNMP traps and syslog aren't supported.
> - During a Terminal Server RMA, metrics pause and resume after the replacement device is enabled.
