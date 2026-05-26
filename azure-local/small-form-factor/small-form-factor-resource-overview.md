---
title: Resource Overview for Small Form Factor Deployments of Azure Local (preview)
description: Understand the Azure resources created for small form factor deployments of Azure local and how they relate to each other (preview).
author: sipastak
ms.topic: concept-article
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Small form factor deployments of Azure Local resource overview (preview)

This article describes the Azure resources involved in small form factor deployments of Azure Local. Understanding these resources and how they relate to each other is essential for managing, troubleshooting, and extending your small form factor deployment.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Resource hierarchy

Small form factor deployments of Azure Local create several interconnected Azure resources. The following diagram shows the relationship between these resources:

```
Azure Subscription
└── Resource Group (user-created)
    ├── Provisioned Machine A
    ├── Provisioned Machine B
    ├── ...
    └── Azure Arc Site
        └── Managed Resource Group (auto-created, one per site; name derived from site name unless overridden)
            └── Arc for Servers instance (one per provisioned machine)
                ├── Azure Edge Device Management Extension
                └── Azure Edge Telemetry And Monitoring Extension
```

## Provisioned machine

The provisioned machine is the top-level Azure resource that represents your physical small form factor device. It provides a cloud-based management surface for the hardware running at your edge location.

> [!NOTE]
> In the Azure Resource Manager API, this resource is referred to as an "Edge Machine." This name exists for backwards compatibility with previous versions of the API. The CLI and portal continue to refer to it as a "Provisioned Machine," but the underlying API refers to it as an "Edge Machine."

Through the provisioned machine resource, you can perform lifecycle operations on the physical device, including:

- **Install OS**: Deploy the Azure Local operating system (such as Azure Linux) to the physical device, specifying the target OS image, network configuration, and SSH public key for access.
- **Reset OS**: Return the device to its maintenance environment, wiping the installed operating system while preserving the underlying hardware configuration.

These operations are available through the Azure CLI using the `az provisionedmachine` command group:

```azurecli
# Install the operating system on the small form factor device
az provisionedmachine install-os \
    --name <device-name> \
    --resource-group <resource-group> \
    --os-image AzureLinux \
    --ip-address <device-ip> \
    --ssh-public-key "<public-key>"

# Reset the device to its maintenance environment
az provisionedmachine reset-os \
    --name <device-name> \
    --resource-group <resource-group>
```

The provisioned machine resource tracks the state of these operations, allowing you to monitor progress from the Azure portal or CLI.

## Azure Arc site

The **Azure Arc site** is a resource that represents a physical location where one or more small form factor devices are deployed — for example, a retail store, a factory floor, or a branch office. The site is created in the user-managed resource group alongside the provisioned machine resources.

The Arc site plays two key roles:

- **Location grouping**: It logically groups all provisioned machines at the same physical location. This makes it straightforward to identify and manage all devices at a given site from the Azure portal.
- **Managed resource group ownership**: The site, not the individual provisioned machine, owns the managed resource group. Azure creates one managed resource group per site, and all provisioned machines associated with that site share it. By default, the managed resource group name is derived from the site name, but you can override that name during configuration. This means the Arc for Servers instances for all devices at a site live in the same managed resource group.

This design has practical implications:

- **Adding a device** to an existing site doesn't create a new managed resource group. A new Arc for Servers instance is created inside the existing managed resource group for that site.
- **Removing a single device** from a multi-device site doesn't delete the managed resource group — it only removes that device's Arc for Servers instance.
- **Deleting the site** removes the managed resource group and all Arc for Servers instances within it.

## Managed resource group

When you create an Azure Arc site, Azure automatically creates a **managed resource group**. This resource group is distinct from the user-created resource group where the site and provisioned machine resources live. A single managed resource group is created per site, and all provisioned machines associated with that site share it. If you don't specify a custom managed resource group name, Azure derives the name from the site name. If you do specify an override, Azure uses the custom name instead.

The managed resource group has the following characteristics:

- **Automatically created and managed**: Azure creates this resource group when the site is provisioned. You don't create it manually.
- **Name derived by default, but overridable**: If no custom managed resource group name is configured, Azure derives the managed resource group name from the site name. If a custom name is provided, Azure uses that override.
- **One per site**: All provisioned machines within an Arc site share the same managed resource group. Each device gets its own Arc for Servers instance inside it, but they all live in one group.
- **Lifecycle bound to the site**: The managed resource group is tied to the lifecycle of the Arc site, not individual provisioned machines. Removing a single device from a multi-device site doesn't delete the managed resource group.
- **Contains supporting resources**: The managed resource group holds the Arc for Servers instances and their extensions, which provide the cloud-to-device management channel for each device at the site.

> [!IMPORTANT]
> Don't manually delete or modify resources within the managed resource group. These resources are managed by the Azure Local platform, and manual changes can cause the deployment to enter an inconsistent state.

## Arc for Servers instance

Inside the managed resource group, Azure creates an **Arc for Servers** instance. This resource represents the Azure Arc agent running on the physical small form factor device, and it serves as the primary management channel between Azure and the device operating system.

The Arc for Servers instance provides this functionality:

- **Extension hosting**: Azure extensions are installed on the Arc for Servers instance to add management and monitoring capabilities to the device.
- **Remote access**: Secure SSH connectivity to the device can be established through the Arc for Servers instance without exposing the device directly to the internet.

> [!NOTE]
> Arc for Servers instances in the Azure Local small form factor product are short-lived. They're tied either to the maintenance OS or a particular OS installation. The provisioned machine deletes Arc for Servers instances and creates new ones as needed to execute different commands.

## Extensions

Extensions are software components installed on the Arc for Servers instance that provide specific management and observability capabilities. In a small form factor deployment, two extensions are installed by default.

### Azure Edge Device Management Extension

The **Azure Edge Device Management** extension provides the control plane for managing the small form factor device's hardware and operating system lifecycle. This extension enables Azure to communicate with the device for operations such as:

- Operating system installation and reset
- Configuration management and updates

The device management extension is the bridge that allows `az provisionedmachine` commands initiated from Azure to be executed on the physical hardware.

### Azure Edge Telemetry And Monitoring Extension

The **Azure Edge Telemetry And Monitoring** extension collects diagnostic and telemetry data from the small form factor device and transmits it to Azure. This extension supports:

- **Telemetry collection**: Continuously streams curated system events, performance metrics, and health signals to Azure for analysis.
- **Diagnostics**: Enables on-demand diagnostic log collection to assist with troubleshooting. Logs can be collected and sent to Microsoft Support when needed.
- **Crash dump collection**: Automatically captures crash dump data for analysis when system failures occur, aiding in root cause identification.

Telemetry data helps Microsoft improve product quality, proactively identify issues, and provide faster support.

> [!NOTE]
> Both extensions are required for the small form factor deployment to function correctly. Removing or disabling them may prevent Azure from managing the device and degrade support capabilities.

## Next steps

- [Container orchestrators on small form factor deployments of Azure Local](small-form-factor-container-orchestrators.md)