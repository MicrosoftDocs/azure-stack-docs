---
title: "Azure Operator Nexus Network Fabric - Secret Rotation v1"
description: Learn about the password rotation v1 process in Azure Operator Nexus Network Fabric.
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 09/26/2025
ms.custom: template-concept
---

# Secret rotation in Nexus Network Fabric

Azure Operator Nexus Network Fabric enables API-driven, fabric-scoped operator password rotation for Nexus Network Fabric in release 9.2 and Nexus Network Fabric general availability (GA) API version 2025-07-15 for both GF and BF instances. It replaces manual, ticket-based flows with a predictable, automatable operation by using the Azure CLI. The rotation runs as a long-running Azure Resource Manager action for reliability and transient fault tolerance at scale.

When rotation is triggered, the service securely generates and updates operator credentials on Terminal Server and supported devices. Secrets are stored by using Azure Key Vault secret versioning, which allows safe rollback and continuity during partial updates. Fabrics can temporarily operate in a split-key state until devices converge via resync. Deterministic outcomes are provided per device along with a fabric-level status.

## Capabilities

- Fabric-scoped rotation in a single command. The password is rotated for the following user profiles. The target for this API is to include an Opengear Terminal Server when you enable at the Nexus Network Fabric scope:

   * Admin
   * AzureOperatorRO
   * AzureOperatorRW
   * TelcoRO
   * TelcoRW
   * TelcoRO1 to TelcoRO14 (depends upon the feature flag also known as the MethodDv1.5 feature request)
   * TelcoRW1 and TelcoRW2 (depends upon the feature flag also known as the MethodDv1.5 feature request)
   * Terminal Server password

- The service uses the versioning capability of Key Vault when multiple sets of passwords exist. The service uses the new secrets template to generate secrets.
- The service enables support to provide a deterministic status of the executed rotation. It provides a deterministic status like the last rotation time, overall state, per-device success/failure lists, and unique password set count. The configured key vault has the latest copy of the password that corresponds to device users.
- The service provides targeted resync. Device-scope resync operations (a single device by Azure Resource Manager ID) rotate the password for a specific device and also secure secret handling with Key Vault secret versioning.
- The service continues to support split-key continuity, which is supported until convergence.

## Limitations/constraints

### Password rotation API behavior

- Password rotation via API is blocked when an administrator locks Nexus Network Fabric.
- During password rotation, the service moves fabric to maintenance mode, and certain actions, such as commit, return merchandise authorization (RMA), and device disablement, aren't available.
- Passwords aren't rotated for the specific device when the device is in an administrative state (disabled). This behavior occurs during RMA, under maintenance, or in cases where the device isn't provisioned. You must enable the device via a POST action to retry rotations.
- The service moves the fabric configuration state to Succeeded after the rotation POST action is finished. When there are failed devices, the status of the rotation shows the appropriate states with details about the failed devices.
- If password rotation fails on any device, the service moves the device state to Deferred control. You can use resync passwords on specific device resources to retry password rotation on failed devices. You can't perform RMA because it disables devices in this scenario.
- Previously, device passwords were stored in the Network Fabric Controller key vault under several different names. Only the following naming convention is used to generate secrets. (The format is aligned across Nexus.) All older naming conventions will be retired post release 9.2 for GF and BF after migration via API rotation or the new Geneva action.
- Secrets are stored in the Network Fabric Controller key vault as before: `<subscription ID>-<resource group name>-<fabric name>-<username>-devicePassword-<deterministic hash>`. An example device password is 
   `00000000-0000-0000-0000-000000000000-exampleRG-exampleFabric-admin-devicePassword-4418bf71`.

- Instead of relying on older naming conventions, you must rely on the new `secretArchiveReference` fields in the 2025-07-15 API to find device passwords in the key vault.

   For example, on a network device, to find the admin password, look for `secretArchiveReference` in `secretRotationStatus`:

    ```
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
    ```
- When the bring your own key vault (BYOKV) feature becomes available, secrets are copied to your key vault in the same format, as shown in the preceding example.
- On the Nexus Network Fabric resource, the capability to delete all secrets that pertain to Nexus Network Fabric is purged from the Network Fabric Controller key vault (similar to present-day behavior).
- Password rotation behavior with other common workflows is listed in the following table:

    | Scenario | User action (recommended) | Nexus Network Fabric state updates | Device state updates | Password/certificate rotation notes |
    | --- | --- | --- | --- | --- |
    | Commit operation | You must perform password rotation only after the commit batch was either successful or failed. <br><br>&nbsp;<br><br>&nbsp; | Administrative state: Accepted <br><br>&nbsp; | Not available  | Password rotation isn't catered while the Nexus Network Fabric state is in the Accepted state. |
    | Upgrade | You must perform password rotation or a resync operation only after the upgrade was successful. | Administrative state: Under maintenance | Administrative state: Under maintenance | Password rotation isn't catered while the fabric is in the Upgrade or Upgrade failure state. |
    | Device disabled (one or more devices) | 1. You must enable all devices before you perform password rotation. <br><br>&nbsp; | Administrative state:  Enabled | Administrative state: Enabled-Deferred control (if Persist read/write configuration exists) | Password rotation is catered. |
    |     | 2. If device enablement fails because of a connectivity issue, you must perform reboot with zero touch provisioning (ZTP) and perform device enablement. | Administrative state: Enabled | Administrative state: Disabled | Password is catered to post enablement of the device. |

### Retry framework and resync behavior

- The service has implicit retries built in if there's a failure, but it also provides API-driven retry capabilities. The service also provides resync POST action to rotate the passwords of specific devices.
- Rotation of passwords is blocked when the maximum set of unique passwords is present for a fabric. You must rotate all devices via resync.
- Resync isn't initiated in the following scenarios:

    | Scenario | Fabric state | Device state | Comments |
    | --- | --- | --- | --- |
    | Fabric lock | Administrative state: Locked | Not available  | State to be implemented. The fabric lock property shows the state of the fabric lock. |
    | Upgrade | Configuration state: Under maintenance | Configuration state: Under maintenance | &nbsp; |
    | Device disabled | Administrative state: Enabled-Degraded | Administrative state: Disabled | &nbsp; |
    | RMA | Administrative state: Enabled-Degraded | Administrative state: RMA | &nbsp; |
    | Commit | Configuration state: Accepted | Not available  | &nbsp; |

### Other scenarios

- Fabric upgrade is blocked if all device passwords aren't the same.
- Service behavior for RMA scenarios is described in the following table:

    | &nbsp;Scenario | User action (recommended) | Fabric state updates | Device state updates | Password/Certificate rotation notes |
    | --- | --- | --- | --- | --- |
    | Device is unreachable because of failure and is unable to serve traffic. | 1\. You must perform a POST action to mark the administrative state as Disabled for the specific device immediately. | Administrative state: Enabled-Degraded. | Administrative state: Disabled | Password rotation can't be catered when the device is disabled. Password rotation can happen via RMA flow, which initiates ZTP and bootstrap. |
    |     | 2. You must perform a device serial number patch update and the POST action to mark the administrative state as RMA after the replacement device is available. | Administrative state: Enabled-Degraded unless the RMA is finished and all devices are enabled. | Administrative state: RMA |     |
    | Device is flaky and has intermittent issues, but it can serve traffic. | 1\. You must perform the POST action to mark the administrative state as Disabled whenever the device needs to stop serving traffic. <br><br>&nbsp;<br><br>&nbsp; | Administrative state: Enabled-Degraded. | Administrative state: Disabled | Password rotation can't be catered when the device is disabled. Password rotation can happen via RMA flow, which initiates ZTP and bootstrap. |
    |     | 2. You must perform a device serial number patch update and the POST action to mark the administrative state as RMA after the replacement device is available. | Administrative state: Enabled-Degraded unless the RMA is finished and all devices are enabled. | Administrative state: RMA |     |
    | Device is flaky and has intermittent issues but is unable to serve traffic. | 1\. You must perform a POST action to mark the administrative state as disabled for the specific device immediately. <br><br>&nbsp;<br><br>&nbsp; | Administrative state: Enabled-Degraded. | Administrative state: Disabled | Password rotation isn't catered when the device is disabled. Password rotation can happen via RMA flow, which initiates ZTP and bootstrap. |
    |     | 2. You must perform a device serial number patch update and the POST action to mark the administrative state as RMA after the replacement device is available. | Administrative state: Enabled-Degraded unless the RMA is finished and all devices are enabled. | Administrative state: RMA |     |
    | Device is to be RMA in the future for known issues except serving traffic. | 1\. You must perform the POST action to mark the administrative state as disabled whenever the device needs to stop serving traffic. <br><br>&nbsp;<br><br>&nbsp; | Administrative state: Enabled-Degraded. | Administrative state: Disabled | Password rotation isn't catered when the device is disabled. Password rotation can happen via RMA flow, which initiates ZTP and bootstrap. |
    | &nbsp; | &nbsp;2. You must perform a device serial number patch update and the POST action to mark the administrative state as RMA after the replacement device is available. | Administrative state: Enabled-Degraded unless the RMA is finished and all devices are enabled. | Administrative state: RMA | &nbsp; |

- Two Geneva actions are available to handle migration of instances to use the latest secrets format.

    | Geneva action | Compatible API version | Locked in lockbox | Secrets format | Behavior/Constraints |
    | --- | --- | --- | --- | --- |
    | Old Geneva action | \- 2024-06-15 preview and older versions <br>- GA version 2025-07-15 | Yes | Old secrets format only | \- Rotates BF instances (built before release 9.2), which use the old secret format.<br><br>\- After instances are migrated to the new secrets format via API rotation or the new Geneva action, this Geneva action doesn't work and provides a suitable error. |
    | New Geneva action | \- GA version 2025-07-15 | Yes | New secrets format only | \- Rotates all GF and BF instances (which currently have the old and new format).<br><br>\- All new GF instances from release 9.2 have the new secrets format.<br><br>\- Requires 2025-07-15 Azure Resource Manager API rolled out. API-based password rotation must be enabled. |

> [!NOTE]
> Greenfield 9.2 is deployed by using the new secrets template. For this reason, it isn't possible to rotate secrets on Greenfield 9.2 deployments until the 2025-07-15 API version is available.

## Related content

- [Use password rotation v1 in Azure Operator Nexus](./howto-use-password-rotation-v1.md)
