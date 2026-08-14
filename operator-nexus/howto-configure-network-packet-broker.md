---
title: "Azure Operator Nexus: Configure the network packet broker"
description: Learn how to configure a Network Packet Broker in Azure Operator Nexus to mirror and forward network traffic. Includes troubleshooting for common errors.
author: dougbristow
ms.author: dbristow
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 07/09/2026
ms.custom: template-how-to, devx-track-Azurecli
---

# How to configure Network Packet Broker (NPB)

This guide explains how to set up a Network Packet Broker (NPB) to capture, filter, and forward network traffic to monitoring tools (vProbes).

## Prerequisites

- **Provisioned NPB devices**: Ensure NPB devices are correctly racked, stacked, and provisioned. For details, see [Network Fabric Provisioning](./howto-configure-network-fabric.md).

- **vProbes configuration**: Set up each vProbe with dedicated IPs.

- **Internal vProbes (optional)**: If you use internal vProbes, create Layer 3 isolation domains with internal networks. Configure required subnets, and set the **NPB extension flag** for internal networks. For details, see [Isolation Domains](./howto-configure-isolation-domain.md).

- **Network-to-Network Interconnect (NNI) use case**: If applicable, create an NNI of type `NPB`. Ensure appropriate Layer 2 and Layer 3 properties are defined during creation. For details, see [Network Fabric Provisioning](./howto-configure-network-fabric.md).


## Step 1: Create a network TAP rule

A **network TAP rule** defines the traffic you want to capture and the actions to perform once a packet matches.

**Key points:**

* A TAP rule consists of one or more **matching configurations**.

* The system evaluates **match conditions** as logical **“AND”** tuples, so all conditions must be satisfied for a packet to match.

* The system executes **actions** when a packet matches a configuration.

* You can create TAP rules **inline** (Azure CLI, portal, or Azure Resource Manager) for content up to 2 MB or **file-based** (upload from a storage URL). File updates support **push or pull mechanisms**.

> [!NOTE]
> On `M8-A400-A100-C16-ab` / `-ac` NPBs, truncation is limited to one neighbor group (redirect) and one NNI (mirror) per NPB, allocated first-come, first-served. See [Known limitations](./concepts-nexus-network-tap-rules.md#known-limitations).

**CLI examples:**

```bash
# Create a TAP rule
az networkfabric taprule create \
  --resource-group <rg-name> \
  --fabric-name <fabric-name> \
  --name <taprule-name> \
  --configurations <configurations-json>

# Update a TAP rule
az networkfabric taprule update --name <taprule-name> --resource-group <rg-name> --fabric-name <fabric-name>

# Delete a TAP rule
az networkfabric taprule delete --name <taprule-name> --resource-group <rg-name> --fabric-name <fabric-name>

# Show a TAP rule
az networkfabric taprule show --name <taprule-name> --resource-group <rg-name> --fabric-name <fabric-name>
```
### How to create a file‑based TAP rule with trusted mode enabled:
Refer to [How to Configure Network TAP Rules with User Assigned Managed Identity (UAMI)](./howto-configure-network-tap-rules-with-user-assigned-managed-identity.md).


## Step 2: Create a neighbor group

A **neighbor group** defines **destinations** for the traffic that a TAP forwards.

**Key points:**

* Destinations can include **network interfaces** or monitoring tools like **vProbes**.
* You can also use IP addresses behind Azure Load Balancer as destinations, but traffic goes directly to the specified addresses.
* Grouping multiple destinations simplifies configuration.

**CLI examples:**

```AzCLI
# Create a neighbor group

az networkfabric neighborgroup create \
  --resource-group <rg-name> \
  --fabric-name <fabric-name> \
  --name <neighborgroup-name> \
  --destinations <destinations-json>

# Delete a neighbor group

az networkfabric neighborgroup delete --name <neighborgroup-name> --resource-group <rg-name> --fabric-name <fabric-name>

# Show a neighbor group

az networkfabric neighborgroup show --name <neighborgroup-name> --resource-group <rg-name> --fabric-name <fabric-name>
```

> [!Note]
> Update operations aren't currently supported for neighbor groups. Changes you make through `CLI` or `API` don't appear on the network device.

## Step 3: Create a network TAP

A **network TAP** captures traffic from a specified **source network interface** and forwards it according to a TAP rule and neighbor group.

**Key points:**

* Associate the TAP rule and neighbor group that you created in previous steps.
* Use Azure CLI, portal, or Azure Resource Manager to create the TAP.
* You can **enable or disable** the TAP to start or stop traffic forwarding.

**CLI examples:**

```AzCLI
# Create a network TAP
az networkfabric tap create \
  --resource-group <rg-name> \
  --fabric-name <fabric-name> \
  --name <tap-name> \
  --source-interface <interface-id> \
  --taprule <taprule-name> \
  --neighborgroup <neighborgroup-name>

# Update a network TAP
az networkfabric tap update --name <tap-name> --resource-group <rg-name> --fabric-name <fabric-name>

# Delete a network TAP
az networkfabric tap delete --name <tap-name> --resource-group <rg-name> --fabric-name <fabric-name>

# Show a network TAP
az networkfabric tap show --name <tap-name> --resource-group <rg-name> --fabric-name <fabric-name>
```


## Step 4: Enable or disable a network TAP

After creating a TAP, you need to enable it to start the NPB NNI's packet brokering process. You can disable it at any time to stop forwarding traffic.

**CLI example:**

```AzCLI
# Enable a network TAP
az networkfabric tap update-admin-state \
  --resource-group <rg-name> \
  --fabric-name <fabric-name> \
  --name <tap-name> \
  --enabled true

# Disable a network TAP
az networkfabric tap update-admin-state \
  --resource-group <rg-name> \
  --fabric-name <fabric-name> \
  --name <tap-name> \
  --enabled false
```

## Operational notes

* NPB **doesn't analyze traffic**; it only captures, filters, and forwards packets.

* You can configure multiple TAPs to monitor different sources simultaneously.

* You can apply updates to TAP rules or neighbor groups dynamically without disrupting other flows.

* NPB NNIs are disabled until you create and enable a TAP rule.

## Common errors for NPB

### ErrorCode: ResourceCreationValidateFailed

| Error Message                                                                                | User Action                                                                  |
| --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------- |
| Network tap creation failed as the API request is not valid                                   | Fix the request following the error message and retry the operation.         |
| REPUT on network tap failed as the tap resource is in Enabled Administrative state            | Disable the tap resource and retry the operation.                            |
| Network tap creation failed as the tap resource registration with Azure ARM failed            | Retry the operation. If the error persists, contact Microsoft support               |
| REPUT on network tap failed as the tap resource is in Accepted Configuration state            | Re-put request isn't allowed as Configuration State is Accepted.            |
| Network tap creation failed as the Administrative state is Enabled in the request payload     | Fix the request payload and retry the operation.                             |
| Network tap creation failed as the network fabric resource is in Administrative locked state. | Remove the lock on fabric before proceeding with the tap creation operation. |

### ErrorCode: ResourcePatchValidateFailed

| Error Message                                                                                      | User Action                                                          |
| --------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| Network tap deletion failed as the Administrative state is Enabled in the request                   | Fix the request payload and retry the operation.                     |
| Network tap patch failed as the internal request to get the associated Network tap resource failed. | Retry the operation. If the error persists, contact Microsoft support       |
| Network tap patch failed as the request payload did not satisfy the patch schema                    | Fix the request following the error message and retry the operation. |
| Network tap DOWNGRADE patch failed as the request payload did not satisfy the patch schema          | Fix the request following the error message and retry the operation. |
| Network tap patch failed as the API request is not valid                                            | Fix the request following the error message and retry the operation. |

### ErrorCode: ResourceDeletionValidateFailed

| Error Message  | User Action                                                                  |
| -------------------------------- | -------------------------------------------- |
| Network tap deletion failed as the network fabric resource is in Administrative locked state. | Remove the lock on fabric before proceeding with the tap deletion operation. |

### ErrorCode: ResourcePostActionFailed

| Error Message                                                                | User Action                                                                        |
| ----------------------------------------------------------------------------- | ---------------------------------------------------------------------------------- |
| Network tap POST action failed as the action is not supported for Network tap | Check if the POST action is allowed on the tap resource for the given API-version. |


### Other error codes
| ErrorCode                             | Error Message                                                                                                                 | User Action                                                                                                                |
| ------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- |
| NFNPBIsdConfigError                   | Failed to ProcessNPBConfig due to: \<err> for device: \<device>                                                               | Make sure L3 ISD payload is free from validation errors. The payload errors are contained in \<err>.                                                                   |
| NFNPBNniConfigError                   | Failed to ProcessNPBConfig due to: \<err> for device: \<device>                                                               | Make sure NNI payload is free from validation errors. The payload errors are contained in \<err>.                                                                       |
| NFTapValidateDstEmptyInfoError        | Network Tap destination received with empty info                                                                              | Make sure Destination name, type, NNI, Internal Network ID, and Encapsulation aren't empty.                               |
| NFTapValidateDstNghGroupsMissingError | Network Tap destination NeighborGroups is nil/empty</br>Neighbor group definition is not found                                | Ensure Neighbor group definition is not empty.                                                                             |
| NFTapValidateDstEncapInvalidError     | Network Tap ISD destination Encapsulation type is invalid<br>network Tap NNI Direct destination Encapsulation type is invalid | Make sure the Encapsulation type for the ISD is GRE                                                                        |
| NFTapValidateDstNghGroupDestIpv4Error | Neighbor group \<name> destination v4 should not be empty<br>Neighbor group \<name> destination count exceeds max limit       | Provide non-empty IPv4 destinations and keep count <= 16.                                                                  |
| NFTapValidateDstNghGroupDestIpv6Error | Neighbor group \<name> destination v6 should not be empty<br>Neighbor group \<name> destination v6 count exceeds max limit    | Provide non-empty IPv4 destinations and keep count <= 16.                                                                  |
| GnmiConnectionError                   | GNMI connection to device failed: \<err>                                                                                      | Failure in connecting to the device. Check if device is connected to Azure or reach out to support.                 |
| GnmiSetError                          | GNMI SET failed: \<err>                                                                                                       | Failure in pushing configuring to the device. Check if device is connected to Azure or reach out to support.        |
| GnoiConnectionError                   | GNOI connection to device failed: \<err>                                                                                      | Failure in connecting to the device. Check if device is connected to Azure or reach out to support.                 |
| GnoiOsActivateError                   | Image activation failed. \<err>                                                                                               | Failed to activate the image during device upgrade. Contact support.                                                |
| GNMI GET failed \<err>                | GNMI GET failed: \<err>                                                                                                       | Failure in retrieving configuration from the device. Check if device is connected to Azure or reach out to support. |


### ErrorCode: BadRequest

| Error Message                                                                                                                                                              | User Action                                                                                                                                 |
| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| Network tap creation failed as the referenced NPB resource is not available.                                                                                                | Make sure the NPB resource associated with the network tap exists.                                                                          |
| Network tap creation failed as the referenced Network tap rule resource is not available.                                                                                   | Make sure the Network tap rule resource associated with the network tap exists.                                                             |
| Network tap creation failed as the referenced Network tap rule destination resource is not available.                                                                       | Make sure the Network tap rule destination resource associated with the network tap exists.                                                 |
| Network tap creation failed as the network fabric resource is in Administrative locked state.                                                                               | Remove the lock on fabric before proceeding with the tap creation operation.                                                                |
| Network tap creation failed as the network tap rules name is not unique at the NPB level.                                                                                   | Correct the names of the tap rules resources associated with the network tap and retry the operation                                        |
| Network tap creation failed as the network tap and one or more of the referenced tap rules resources are not in the same Azure region.                                      | Ensure that the tap and tap rule resources are in the same location and retry the operation.                                                |
| Network tap creation failed as the request payload was invalid and could not be deserialized                                                                                | Make sure the request payload is valid and retry the operation.                                                                             |
| Network tap creation failed as the Neighbor group is not referenced in the tap rule match configuration for tap.                                                            | Ensure neighbor group is part of the network tap rules configuration.                                                                       |
| Network tap patch failed as the referenced NPB resource is not available.                                                                                                   | Make sure the NPB resource associated with the network tap exists.                                                                          |
| Network tap patch failed as the Network Fabric resource associated with the NPB resource is not available.                                                                  | Make sure the Network Fabric resource associated with the network tap exists.                                                               |
| Network tap patch failed as the network fabric resource is in Administrative locked state.                                                                                  | Remove the lock on fabric before proceeding with the tap updation operation.                                                                |
| Network tap patch failed as the network tap rules name is not unique at the NPB level.                                                                                      | Correct the names of the tap rules resources associated with the network tap and retry the operation                                        |
| Network tap patch failed as the referenced Network tap rule resource is not available.                                                                                      | Make sure the Network tap rule resource associated with the network tap exists.                                                             |
| Network tap patch failed as the network tap and one or more of the referenced tap rules resources are not in the same Azure region.                                         | Ensure that the tap and tap rule resources are in the same location and retry the operation.                                                |
| Network tap patch failed as the referenced Network tap rule destination resource is not available.                                                                          | Make sure the Network tap rule destination resource associated with the network tap exists.                                                 |
| Network tap patch failed as the Neighbor group is not referenced in the tap rule match configuration for tap.                                                               | Ensure neighbor group is part of the network tap rules configuration.                                                                       |
| Network tap patch failed as the request payload was invalid and could not be deserialized                                                                                   | Make sure the request payload is valid and retry the operation.                                                                             |
| Network tap delete failed as the tap is in Administrative Enabled state                                                                                                     | Disable the network tap and retry the operation.                                                                                            |
| Network tap delete failed as the network fabric resource is in Administrative locked state.                                                                                 | Remove the lock on fabric before proceeding with the tap deletion operation.                                                                |
| Network tap delete failed as the network fabric configuration state is in PendingCommit                                                                                     | Only fabric commit operations are allowed, other operations are not allowed.                                                                |
| Network tap admin state update failed as the tap resource is not available.                                                                                                 | Make sure the network tap resource is available in Azure.                                                                                   |
| Network tap admin state update failed as the referenced NPB resource is not available.                                                                                      | Make sure the NPB resource associated with the network tap exists.                                                                          |
| Network tap admin state update failed as the Network Fabric resource associated with the NPB resource is not available.                                                     | Make sure the Network Fabric resource associated with the network tap exists.                                                               |
| Network tap admin state update failed as the network fabric configuration state is in PendingCommit                                                                         | Only fabric commit operations are allowed, other operations are not allowed.                                                                |
| Network tap admin state update failed as the network fabric resource is in Administrative locked state.                                                                     | Remove the lock on fabric before proceeding with the operation.                                                                             |
| Network tap admin state update failed due to its InternalOperationalState                                                                                                   | Network Fabric is blocked for any operation, wait for upgrade to finish and retry, contact support if error persists.                      |
| Network tap resync failed as the tap resource is not available in Azure.                                                                                                    | Make sure the Network tap resource exists.                                                                                                  |
| Network tap resync failed as the tap resource is in invalid state                                                                                                           | ProvisioningState should be Succeeded, AdminState should be Enabled and ConfigState should be Accepted                                              |
| Network tap resync failed as the referenced Network tap destination resource is not available.                                                                              | Make sure the destination resource associated with the network tap exists.                                                                  |
| Network tap resync failed as the Internal Network destination resource is not in Admin enabled state or ProvisioningState is not succeeded or config state is not succeeded. | Please fix the states and retry the operation.                                                                                              |
| Network tap resync failed as the referenced L3 ISD destination resource is not available.                                                                                   | Make sure the L3 ISD destination resource associated with the network tap exists.                                                           |
| Network tap resync failed as the L3ISD destination resource is not in Admin enabled state or ProvisioningState is not succeeded or config state is not succeeded.            | Please fix the states and retry the operation.                                                                                              |
| Network tap resync failed as the referenced neighborgroup resource is not available.                                                                                        | Make sure the neighbor group resource associated with the network tap exists.                                                               |
| Network tap resync failed as the referenced neighborgroup provisioningState is not Succeeded.                                                                               | Please fix the states and retry the operation.                                                                                              |
| Network tap resync failed as the destination NNI resource provisioningState is not Succeeded or configState is not Succeeded.                                               | Please fix the states and retry the operation.                                                                                              |
| Network tap resync failed as the referenced tap rule resource is not available.                                                                                             | Make sure the tap rule resource associated with the network tap exists.                                                                     |
| Network tap resync failed as the referenced tap rule resource provisioningState is not Succeeded or configState is not Accepted and Succeeded.                              | Please fix the states and retry the operation.                                                                                              |
| Network tap resync failed as the referenced NPB resource does not exist.                                                                                                    | Make sure the NPB resource associated with the network tap exists.                                                                          |
| Network tap resync failed as the associated fabric resource does not exist.                                                                                                 | Make sure the fabric resource associated with the network tap exists.                                                                       |
| Network tap resync failed as the Network Fabric is blocked for any operation.                                                                                               | Wait for upgrade to finish and retry, contact support if error persists.                                                                    |
| Network tap resync failed as the associated fabric resource is in Administrative locked state.                                                                              | Remove the lock on fabric before proceeding with the tap resync operation.                                                                  |
| Network tap resync failed as the network fabric configuration state is in PendingCommit                                                                                     | Only fabric commit operations are allowed, other operations are not allowed.                                                                |
| Network tap rule creation failed as the referenced match configuration destination resource is not available.                                                               | Make sure the associated destination resources exists in Azure.                                                                             |
| Network tap rule patch failed as the Network tap rule resource is not available.                                                                                            | Make sure the Network tap rule resource exists.                                                                                             |
| Network tap rule patch failed as the referenced match configuration destination resource is not available.                                                                  | Make sure the associated destination resources exists in Azure.                                                                             |
| Network tap rule delete failed as the network fabric configuration state is in PendingCommit                                                                                | Only fabric commit operations are allowed, other operations are not allowed.                                                                |
| Network tap rule resync failed as the tap rule resource is not available.                                                                                                   | Make sure the Network tap rule resource exists.                                                                                             |
| Network tap rule resync failed as the tap rule resource is in invalid state.                                                                                                | Allowed states are ConfigurationState: Accepted and AdministrativeState: Enabled.                                                           |
| Network tap rule resync failed because of unsupported resourceType for destination resource in taprule                                                                      | Allowed destination resource types are neighborgroups and networktonetworkinterconnects                                                     |
| Network tap rule resync failed as the destination neighbor group resource is not available.                                                                                 | Make sure the destination neighborgroup resource exists.                                                                                    |
| Network tap rule resync failed as the destination neighbor group is not in successful state.                                                                                | Make sure the destination neighborgroup resource is successfully provisioned.                                                               |
| Network tap rule resync failed as the destination NNI resource is not available.                                                                                            | Make sure the destination networktonetworkinterconnects resource exists.                                                                    |
| Network tap rule resync failed as the destination NNI resource is not in successful state.                                                                                  | Make sure the the provisioningState and configurationState of the destination networktonetworkinterconnects resource should be Succeeded.   |
| Network tap rule resync failed as the network fabric configuration state is in PendingCommit                                                                                | Only fabric commit operations are allowed, other operations are not allowed.                                                                |
| Network tap rule resync failed as the associated network fabric resource is not available.                                                                                  | Make sure the network fabric resource is available in Azure.                                                                                |
| Network tap rule resync failed as one of the fabric device resources is not available.                                                                                       | Make sure the network device resource is available in Azure.                                                                                |
| Network tap post action failed as the post action is not supported for network tap resource.                                                                                | Support post actions on network tap: UpdateAdministrativeState and Resync                                                                  |
| Network tap UpdateAdminState post action failed as the requested admin state is not valid                                                                                   | Valid Administrative states for Network tap: Enable and Disable                                                                            |
| Network tap UpdateAdminState Enable post action failed as the tap state is not valid for this action.                                                                       | For Enable Admin state the tap resource should be in Disabled Admin State, Succeeded ProvisionState and Config state should not be Accepted |
| Network tap resync post action failed as the tap state is not valid for this action.                                                                                        | For Resync the tap resource should be in Enabled Admin State, Succeeded ProvisionState and Accepted Config state                            |


### ErrorCode: ResourceLocked

| Error Message                                                                                     | User Action                                                                       |
| -------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Network tap rule creation failed as the network fabric resource is in Administrative locked state. | Remove the lock on fabric before proceeding with the tap rule creation operation. |
| Network tap rule patch failed as the network fabric resource is in Administrative locked state.    | Remove the lock on fabric before proceeding with the tap rule patch operation.    |
| Network tap rule delete failed as the network fabric resource is in Administrative locked state.   | Remove the lock on fabric before proceeding with the tap rule delete operation.   |
| Network tap rule resync failed as the network fabric resource is in Administrative locked state.   | Remove the lock on fabric before proceeding with the tap rule resync operation.   |

### ErrorCode: InvalidInput*

| Error Message                                                                          | User Action                                                                                                          |
| -------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| Network tap creation failed as the referenced destination resource is of invalid type. | Make sure the destination resource type is one of the following: [IsolationDomain, Direct] and retry the operation. |
| Network tap patch failed as the referenced destination resource is of invalid type.    | Make sure the destination resource type is one of the following: [IsolationDomain, Direct] and retry the operation. |

### ErrorCode: Internal Server Error

| Error Message                                                                                                | User Action                                                                   |
| ------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Network tap creation failed due to some internal service error.                                               | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap patch failed due to some internal service error.                                                  | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap delete failed due to some internal service error.                                                 | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap admin state update failed due to some internal service error.                                     | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap resync failed due to some internal service error.                                                 | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap rule creation failed due to some internal service error.                                          | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap rule patch failed due to some internal service error.                                             | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap rule delete failed due to some internal service error.                                            | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap rule resync failed due to some internal service error.                                            | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap creation failed as the Network Fabric resource associated with the NPB resource is not available. | Make sure the Network Fabric resource associated with the network tap exists. |
| Network tap deletion failed as the internal request to get the associated NPB resource failed                 | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap deletion failed as the internal request to get the associated Network Fabric resource failed      | Retry the operation. If the error persists, contact Microsoft support                |
| Network tap post action failed as the internal request to get the tap resource failed                                                                                       | Retry the operation. If the error persists, contact Microsoft support                                                                              |
| Network tap post action failed as the internal request to get the associated NPB resource failed                                                                            | Retry the operation. If the error persists, contact Microsoft support                                                                              |
| Network tap post action failed as the internal request to get the associated Network fabric resource failed                                                                 | Retry the operation. If the error persists, contact Microsoft support                                                                              |

### ErrorCode: TooManyRequests

| Error Message                                                                                                                        | User Action                   |
| ------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------- |
| Network tap creation failed as the internal request to get the associated NPB resource got throttled.                                 | Wait and retry the operation. |
| Network tap creation failed as the internal request to get the associated Network tap rule resource got throttled.                    | Wait and retry the operation. |
| Network tap creation failed as the internal request to get the associated Network tap rule destination resource got throttled.        | Wait and retry the operation. |
| Network tap patch failed as the internal request to get the associated NPB resource got throttled.                                    | Wait and retry the operation. |
| Network tap patch failed as the internal request to get the associated Network Fabric resource got throttled.                         | Wait and retry the operation. |
| Network tap patch failed as the internal request to get the associated Network tap rule resource got throttled.                       | Wait and retry the operation. |
| Network tap patch failed as the internal request to get the associated Network tap rule destination resource got throttled.           | Wait and retry the operation. |
| Network tap deletion failed as the internal request to get the associated Network tap rule resource got throttled.                    | Wait and retry the operation. |
| Network tap deletion failed as the internal request to get the associated Network tap rule destination resource got throttled.        | Wait and retry the operation. |
| Network tap admin state update failed as the internal request to get the tap resource got throttled.                                  | Wait and retry the operation. |
| Network tap admin state update failed as the internal request to get the associated NPB resource got throttled.                       | Wait and retry the operation. |
| Network tap admin state update failed as the internal request to get the associated Network Fabric resource got throttled.            | Wait and retry the operation. |
| Network tap resync failed as the internal request to get the tap resource got throttled                                               | Wait and retry the operation. |
| Network tap rule creation failed as the internal request to get the tap rule resource got throttled                                   | Wait and retry the operation. |
| Network tap rule creation failed as the internal request to get the referenced match configuration destination resource got throttled | Wait and retry the operation. |
| Network tap rule creation failed as the internal request to patch the tap rule config state got throttled                             | Wait and retry the operation. |
| Network tap rule patch failed as the internal request to get the tap rule resource got throttled.                                     | Wait and retry the operation. |
| Network tap rule patch failed as the internal request to get the referenced match configuration destination resource got throttled    | Wait and retry the operation. |
| Network tap rule resync failed as the internal request to get the tap rule got throttled                                              | Wait and retry the operation. |
| Network tap rule resync failed as the internal request to get the associated fabric resource got throttled                            | Wait and retry the operation. |
| Network tap rule resync failed as the internal request to get the fabric device resource got throttled                                | Wait and retry the operation. |
| Network tap resync failed as the internal request to get the associated Network tap destination resource got throttled.               | Wait and retry the operation. |
| Network tap resync failed as the internal request to get the associated Network tap L3ISD destination resource got throttled.         | Wait and retry the operation. |
| Network tap resync failed as the internal request to get the associated neighborgroup resource got throttled.                         | Wait and retry the operation. |
| Network tap resync failed as the internal request to get the referenced tap rule resource got throttled.                              | Wait and retry the operation. |
| Network tap resync failed as the internal request to get the referenced NPB resource got throttled.                                   | Wait and retry the operation. |
| Network tap resync failed as the internal request to get the associated fabric resource got throttled.                                | Wait and retry the operation. |
| Network tap rule resync failed as the internal request to get the destination neighbor group resource got throttled                                                         | Wait and retry the operation.                                                                                                               |
| Network tap rule resync failed as the internal request to get the destination NNI resource got throttled                                                                    | Wait and retry the operation.                                                                                                               |



## Additional resources
- [Concepts: Network Packet Broker](./concepts-nexus-network-packet-broker.md)
- [Deep Dive: Network TAP Rules](./concepts-nexus-network-tap-rules.md)
- [Configure the Network Fabric](./howto-configure-network-fabric.md)
- [Network Fabric Services](./concepts-network-fabric-services.md)
