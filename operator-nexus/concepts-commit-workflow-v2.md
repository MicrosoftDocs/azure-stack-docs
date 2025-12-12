---
title: Azure Operator Nexus Network Fabric - Commit Workflow v2
description: Learn about the Commit Workflow v2 process in Azure Operator Nexus – Network Fabric.
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 05/16/2025
ms.custom: template-concept
---

# Commit Workflow v2 in Azure Operator Nexus - Network Fabric

Commit Workflow v2 introduces a modernized and transparent approach for applying configuration changes to Azure Operator Nexus – Network Fabric resources. This enhanced workflow provides better operational control, visibility, and error handling during the configuration update process.

With this update, users can lock configuration states, preview device-level changes, validate updates, and commit with confidence. Users can overcome earlier limitations, such as the inability to inspect pre- or post-configurations and difficulty in diagnosing failures.

## Key concepts and capabilities

Commit Workflow v2 is built around a structured change management flow. The following core features are available:

- **Explicit configuration locking:** Requires users to explicitly lock the configuration of a Network Fabric resource after they make changes. This process ensures that updates are applied in a predictable and controlled manner.
- **Full device configuration preview:** Enables visibility into the exact configuration that's applied to each device before the commit. This step helps validate intent and catch issues early.
- **Commit configuration to devices:** Commits changes to devices after validation. This final step applies the locked configuration updates across the fabric.
- **Discard batch updates:** Allows rollback of all uncommitted resource changes to their last known state.
- **Enhanced constraints:** Enforces strict update rules during lock, maintenance, and upgrade phases for stability.

## Prerequisites

Before you use Commit Workflow v2, ensure that the following environment requirements are met.

## Commit workflow-compatible versions

The commit workflow version supported depends on the combination of Network Fabric runtime, portal release version, and API version in use. Use the following table to identify which commit workflow applies to your environment.

| Network Fabric version     | Release version | API versions                                                                                  | Commit workflow version |
|------------------------|---------------------|------------------------------------------------------------------------------------------------------|------------------------------|
| 3.0, 4.0, 5.0          | 8.1 and earlier     | `2024-06-15-preview`<br>`2024-02-15-preview`<br>`2023-06-15-stable`                                  | Commit Workflow v1          |
| 5.0.0                  | 8.2, 8.3            | `2024-06-15-preview`<br>`2024-02-15-preview`<br>`2023-06-15-stable`                                  | Commit Workflow v1          |
| 5.0.0                  | 9.0            | `2024-06-15-preview`                                  | Commit Workflow v1          |
| 5.0.1                  | 8.2, 8.3            | `2024-06-15-preview`                                                                                 | Commit Workflow v2          |
| 6.0 and later          | 9.0 and later       | `2024-06-15-preview` and later                                                                       | Commit Workflow v2          |

> [!NOTE]
> If you run Network Fabric version `5.0.1` or later, Commit Workflow v2 is required. Commit Workflow v1 is no longer supported.

### Required versions

If you're unsure which commit workflow version applies to your setup, refer to the commit workflow-compatible versions:

* **Runtime version**: Version `5.0.1` or later is required for Commit Workflow v2.
* **Network Fabric API version**: Version `2024-06-15-preview`.
* **AzCLI version**: Version `8.0.0.b3` or later.

### Supported upgrade paths to runtime version 5.0.1

* **Direct upgrade**: From `4.0.0` to `5.0.1` or from `5.0.0` to `5.0.1`
* **Sequential upgrade**: From `4.0.0` to `5.0.0` to `5.0.1`

> [!NOTE]
> More actions might be required when you upgrade from version 4.0.0. For guidance on upgrade-specific steps, refer to the [Runtime release notes](#).

## Behavior and constraints

Commit Workflow v2 introduces new operational expectations and constraints to ensure consistency and safety in configuration management.

### Availability and locking rules

- Available only on runtime version 5.0.1+. Downgrade to v1 isn't supported.
- Locking is allowed only when:

  - No commit is in progress.
  - Fabric isn't under maintenance or upgrade.
  - Fabric is in an administrative-enabled state.

### Unsupported during maintenance or upgrade

The `Lock`, `ViewDeviceConfiguration`, and `related post-actions` operations aren't allowed during maintenance or upgrade windows.

### Commit finality

After changes are committed, they *can't be rolled back*. Any further edits require a new lock-validate-commit cycle.

### Discard batch behavior

- The `discard-commit-batch` operation:

  - Reverts all Azure Resource Manager resource changes to their last known good state.
  - Updates administrative/configuration states (for example, external/internal networks become disabled and rejected).
  - Doesn't delete resources. Users must delete them manually if desired.
  - Enables further patching to reapply changes.

- When the discard batch action is performed:

  - The administrative state of internal/external network resources moves to disabled. Their configuration state moves to rejected. The resources aren't deleted automatically. A separate delete operation is required for removal.
  - The enabled Network Monitor resources attached to a fabric can't be attached to another fabric unless first detached and committed.
  - The configuration state moves to rejected for Network Monitor resources that are in a disabled administrative state (in commit queue). Users can reapply updates (PUT/patch) and commit again to enable.

### Resource update restrictions

**Post-lock**: Only a limited set of `Create`/`Update`/`Delete` (CUD) actions are supported (for example, unattached access control lists (ACLs) or test access point (TAP) rules).

Resources that affect devices, such as Network-to-Network Interconnect (NNI), isolation domain (ISD), route policy, or ACLs attached to parent resources, are blocked during configuration lock.

### Supported resource actions via Commit Workflow v2 (when parent resources are in administrative state – enabled)

| Supported resource actions that require commit workflow                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | Unsupported resource actions that don't require commit workflow                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **All resource updates that affect device configuration:**<br>• Updates to Network Fabric resource<br>• Updates to NNI<br>• Updates to ISD (L2 and L3)<br>• Creation and updates to internal and external networks of enabled L3 ISD<br>• Addition/update/removal of route policy in internal, external, ISD, and NNI resources<br>• Addition/update/removal of IP Prefixes, IP Community, and Extended IP Community when attached to route policy or Network Fabric<br>• Addition/update/removal of ACLs to internal, external, ISD, and NNI resources<br>• Addition/update/removal of Network Fabric resource in Network Monitor resource<br>• Additional description updates to Network Device properties<br>• Creation of multiple NNI | **Creation and updates of resources that don't affect device configuration:**<br>• Creation of ISD (L3 and L2)<br>• Network Fabric Controller (NFC) creation and updates<br>• Creation and updates to Network TAP rules, Network TAP, Neighbor groups<br>• Creation and updates to Network TAP rules, Network TAP, Neighbor groups<br>• Creation of new route policy and connected resources (IP Prefix, IP Community, IP Extended Community)<br>• Update of route policy and connected resources when not attached to ISD, internal, external, NNI<br>• Creation and update of new ACL, which isn't attached<br><br>**Resource Manager resource updates only:**<br>• Tag updates for all supported resources<br><br>**Other administrative actions and post actions that manage lifecycle events:**<br>• Enable/Disable ISD, Return Material Authorization, upgrade, and all administrative actions (enable/disable), serial number update<br>• Deletion of all Nexus Network Fabric resources |

### Allowed actions after configuration lock

The following table shows supported actions after configuration lock is enabled on the fabric. The actions are categorized by type and support status.

---

### Supported and unsupported actions post configuration lock

| Actions                          | Supported resource actions when fabric is under configuration lock                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Unsupported resource actions when fabric is under configuration lock                                                                                                                                                                                                                                                                                                                                                                                           |
| ------------------------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| Resource actions (CUD)           | - NFC (only update)<br>- Network TAP rules, Network TAP, Neighbor group (CUD) <br>- ACL (create/update) when not attached to parent resource<br>- Network Monitor created without Fabric ID<br>- Creation/Update of `IPPrefix`, `IPCommunity` List, `IPExtendedCommunity` when not attached to route policy<br>- Read of all Network Nexus Fabric resources<br>- Delete of disabled resources and not attached to any parent resources | - No CUD operations allowed on:<br>  • NNI<br>  • ISDs (L2 & L3)<br>  • Internal/External networks (additions/updates)<br>  • Route policy, `IPPrefix`, `IPCommunity` List, `IPExtendedCommunity`<br>  • ACLs when attached to parent resources (for example, NNI, external network)<br>  • Network Monitor when attached to Network Fabric<br>  • Deletion of all enabled resources |
| Post actions                     | - Lock Network Fabric (administrative state)<br>- View device configuration<br>- Commit configuration<br>- `ARMConfig Diff` <br>- Commit batch status                                                                                                                                                                                                                                                                                                                                                         | - All other post actions are blocked and must be done prior to enabling configuration lock.*                                                                                                                                                                                                                                                                                                                                              |
| Service actions/Geneva actions | - Not available                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | - All service actions are blocked.                                                                                                                                                                                                                                                                                                                                                                                                                      |

## Related content

- [Use Commit Workflow v2 in Azure Operator Nexus](./howto-use-commit-workflow-v2.md)
