---
title: Plan updates for Azure Local disconnected operations
description: Learn how to plan updates for the control plane, data plane, and workloads in Azure Local disconnected operations.
ms.date: 10/07/2026
ms.topic: overview
author: arduppal
ms.author: arduppal
---

# Plan updates for Azure Local disconnected operations

::: moniker range=">=azloc-2602"

This article describes how to plan and sequence updates for the control plane, data plane, and workloads in Azure Local disconnected operations.

## Understand update layers and responsibilities

When you operate Azure Local in a disconnected or air-gapped environment, maintain a consistent update strategy to ensure platform reliability, security compliance, and workload health.

Azure Local disconnected operations provides a structured update model that separates updates into three layers:

- **Control plane (Disconnected Operations) updates**

- **Data plane (Azure Local Instance) updates**

- **Workload updates**

It’s important to understand the different layers and the roles responsible for:

- **Providing and bringing updates into the system:** The control plane operator provides and maintains the control plane.
- **Applying updates:** Azure Local administrators manage the data plane within their respective facilities.

## Recommended update sequence and version compatibility

**Recommended approach:** Keep the control plane within its six-month support window. Update the control plane when required by its support lifecycle or when a downstream update depends on newer control-plane capabilities. Otherwise, compatible data plane and workload updates can continue on their own cadences.

**Update order:** Control plane (Disconnected Operations) → data plane (Azure Local instances) → workloads (VMs, guest operating systems, AKS, and applications)

The following diagram shows a compatibility hierarchy rather than a one-to-one release mapping. One supported control-plane version can enable multiple data-plane releases, and one compatible data-plane version can support multiple workload update cycles.

:::image type="content" source="media/disconnected-operations-plan-updates/disconnected-operations-update-path.png" alt-text="Diagram of disconnected operations control plane update path, showing releases and supported Azure Local versions per release." lightbox="media/disconnected-operations-plan-updates/disconnected-operations-update-path.png":::

## Control plane updates (Disconnected operations)

The control plane provides management, orchestration, monitoring, and lifecycle capabilities for Azure Local environments and cloud services. The operator maintains the control plane, monitors its six-month support window, and coordinates dependencies with downstream updates.

> [!IMPORTANT]
> The control plane is unavailable during a control-plane update. This downtime affects management operations for all Azure Local clusters that the control plane manages. Schedule the update as a coordinated maintenance event and notify affected administrators and workload owners in advance.

### What gets updated?
Examples include:

- Azure services

- Azure portal (local instance)

- Azure Arc services

- Resource providers

- Infrastructure services

### When is a control-plane update required?

Update the control plane when one or more of the following conditions apply:

- The installed control-plane version is approaching the end of its six-month support window.

- Required features are available only in a newer control-plane release.

- A security, reliability, or critical bug fix requires a newer control-plane version.

- The current control-plane version no longer supports the intended downstream data plane or workload version.

If none of these conditions apply, keep the current supported control plane version. When a control plane update is required, validate and apply the new version before you update any dependent downstream data plane or workload.

For more information, see [Update the control plane](./disconnected-operations-update.md).

## Data plane updates (Azure Local instances)

Administrators can apply supported data-plane updates within the compatibility range of the installed control-plane version.

### What gets updated?

The data plane consists of the Azure Local infrastructure that hosts workloads, including:

- Azure Local instances (cluster components)

- Underlying hypervisor and virtualization components

- Host operating systems

- Storage infrastructure

- Networking components

- Platform agents and services

For more information, see [Update the data plane](./disconnected-operations-update.md#update-azure-local-disconnected).

## Workload updates

Workload owners, application owners, and platform teams manage workload updates on their required cadence. Confirm that each workload version remains compatible with the underlying data-plane version.

### Virtual machines

For virtual machine environments, updates might include:

- Guest operating system patches

- Security updates

- Application updates

- Driver and agent updates

- Endpoint protection signatures

Examples:

- Windows Server guest updates

- Linux operating system updates

- Business application patches

To manage guest operating system updates, use Windows Server Update Services (WSUS) or Azure Update Manager.

### AKS enabled by Azure Arc and containerized workloads

Organizations running Kubernetes workloads should also maintain:

- AKS versions

- Node images

- Application containers

- Helm charts and deployment artifacts

Typical update tasks include:

1. Update AKS enabled by Azure Arc by using the CLI, or the local control plane.

1. Update container images.

1. Validate application functionality and monitoring.

## Next steps

- [About updates for disconnected operations](./disconnected-operations-update.md)

::: moniker-end

::: moniker range="<=azloc-2601"

This feature is available only in Azure Local 2602 or later.

::: moniker-end
