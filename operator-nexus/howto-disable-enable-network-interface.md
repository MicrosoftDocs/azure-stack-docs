---
title: How to disable and enable a network interface within Nexus Network Fabric
description: Process of disabling and enabling network interface admin state
author: satya talluri
ms.author: stalluri
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 02/04/2026
ms.custom: template-how-to, devx-track-azurecli
---

# Disable and enable network interface

This guide explains how to disable and enable a network interface on a network device within the Nexus Network Fabric. Disabling an interface administratively shuts down the port, preventing any traffic from passing through it. Enabling the interface restores it to normal operation.

## Key considerations

- Disabling an interface stops all traffic on that port.
- Ensure you understand the impact on your network before disabling an interface.
- Always verify the interface state after making changes.

## Parameters required for interface admin state update

Before you begin, you need to understand the parameters required for managing the admin state of an interface. Here is a quick reference table:

| Parameter              | Description                  | Example              |
|------------------------|------------------------------|----------------------|
| `--resource-group`     | Resource group name          | example-rg           |
| `--network-device-name`| Name of the network device   | example-device       |
| `--resource-name`      | Name of the network interface| example-interface    |
| `--state`              | State of the interface       | Disable or Enable    |

## Disabling a network interface

To disable a network interface, follow these steps:

1. Install the latest version of the [az CLI extension](./howto-install-cli-extensions.md).

2. Open your command-line interface (CLI).

3. Use the `az networkfabric interface update-admin-state` command with the appropriate parameters.

### Command syntax

```azurecli
az networkfabric interface update-admin-state --resource-group "resource-group-name" --network-device-name "device-name" --resource-name "interface-name" --state Disable
```

### Example command

```azurecli
az networkfabric interface update-admin-state --resource-group "example-rg" --network-device-name "example-device" --resource-name "example-interface" --state Disable
```

### Expected output

After executing the command, you can verify the state of the interface using the `az networkfabric interface show` command:

```azurecli
az networkfabric interface show --resource-group "resource-group-name" --network-device-name "device-name" --resource-name "interface-name"
```

#### Example output

```json
{
  "administrativeState": "Disabled",
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkDevices/example-device/networkInterfaces/example-interface",
  "name": "example-interface",
  "provisioningState": "Succeeded",
  "resourceGroup": "example-rg",
  "systemData": {
    "createdAt": "2024-04-23T18:06:34.7467102Z",
    "createdBy": "cbe7d642-9e0a-475d-b2bf-2cb0a9825e13",
    "createdByType": "Application",
    "lastModifiedAt": "2026-02-04T10:30:00.0000000Z",
    "lastModifiedBy": "cbe7d642-9e0a-475d-b2bf-2cb0a9825e13",
    "lastModifiedByType": "Application"
  },
  "type": "microsoft.managednetworkfabric/networkdevices/networkinterfaces"
}
```

## Enabling a network interface

Once you need to restore the interface to normal operation, you can enable it.

### Command syntax

```azurecli
az networkfabric interface update-admin-state --resource-group "resource-group-name" --network-device-name "device-name" --resource-name "interface-name" --state Enable
```

### Example command

```azurecli
az networkfabric interface update-admin-state --resource-group "example-rg" --network-device-name "example-device" --resource-name "example-interface" --state Enable
```

### Expected output

Verify the state of the interface using the `az networkfabric interface show` command:

```azurecli
az networkfabric interface show --resource-group "resource-group-name" --network-device-name "device-name" --resource-name "interface-name"
```

#### Example output

```json
{
  "administrativeState": "Enabled",
  "id": "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkDevices/example-device/networkInterfaces/example-interface",
  "name": "example-interface",
  "provisioningState": "Succeeded",
  "resourceGroup": "example-rg",
  "systemData": {
    "createdAt": "2024-04-23T18:06:34.7467102Z",
    "createdBy": "cbe7d642-9e0a-475d-b2bf-2cb0a9825e13",
    "createdByType": "Application",
    "lastModifiedAt": "2026-02-04T11:00:00.0000000Z",
    "lastModifiedBy": "cbe7d642-9e0a-475d-b2bf-2cb0a9825e13",
    "lastModifiedByType": "Application"
  },
  "type": "microsoft.managednetworkfabric/networkdevices/networkinterfaces"
}
```

By following these steps, you can efficiently manage the admin state of your network interfaces, enabling you to control traffic flow on specific ports as needed.
