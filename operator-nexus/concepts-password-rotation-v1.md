---
title: "Azure Operator Nexus Network Fabric - Password Rotation v1"
description: Learn about Password Rotation v1 process in Azure Operator Nexus – Network Fabric
author: RaghvendraMandawale
ms.author: rmandawale
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 09/26/2025
ms.custom: template-concept
---

# Secret Rotation in Nexus Network Fabric

NNF enables API-driven, fabric-scoped operator password rotation for NNF in release 9.2 and NNF GA API version **2025-07-15 f**or both GF and BF instances. It replaces manual, ticket-based flows with a predictable, automatable operation using Azure CLI. The rotation runs as a long-running Azure Resource Manager (ARM) action for reliability and transient fault tolerance at scale.

When rotation is triggered, the service securely generates and updates operator credentials on Terminal Server (TS) and supported devices. Secrets are stored using Azure Key Vault secret versioning, allowing safe rollback and continuity during partial updates. Fabrics can temporarily operate in a split-key state until devices converge via resync. Deterministic outcomes are provided per device along with a fabric-level status.

## Capabilities

- Fabric-scoped rotation in a single command. Password will be rotated for following users’ profiles. The target for this API is to include OpenGear Terminal Server when enabling at Fabric scope
   * Admin
   * AzureOperatorRO
   * AzureOperatorRW
   * TelcoRO
   * TelcoRW
   * TelcoRO1 to TelcoRO14 (depends upon feature flag aka MethodDv1.5 feature req)
   * TelcoRW1 and TelcoRW2 (depends upon feature flag aka MethodDv1.5 feature req)
   * TS password
- Service will leverage the versioning capability of Azure Key Vault when multiple sets of passwords exist.Service uses the new secrets template to generate secrets.
- Service will enable support to provide a deterministic status of the executed rotation. It will provide deterministic status: lastRotationTime, overall state, per-device success/failure lists, unique Password Set Count. The configured key vault will have the latest copy of password corresponding device users.
- Service will provide targeted resync: device-scope resync operations (single device by ARM ID) to rotate the password for a specific device and also secure secret handling with Azure Key Vault secret versioning.
- Service will continue to support split-key continuity supported until convergence.

## Limitations/Constraints

**Password rotation API behaviour**

- Password rotation via API will be blocked when Fabric is Administratively locked.
- During Password rotation service will move fabric to maintenance mode and certain action such as Commit, RMA,Device disablement will not be available. 
- Passwords shall not be rotated for the specific device when the device is in an administrative state (disabled). This occurs during RMA, under maintenance, or in cases where the device is not provisioned. The user must enable the device via a post action to retry rotations
- The service will move the fabric configuration state to successful once the rotation post action is completed. When there are failed devices, the status of rotation will show appropriate state(s). with details of failed device(s)
- If password rotation failed on any device service will move to Device state Deferred control .Customer can use resync-passwords on specific device resource to retry password rotation on failed devices. User cannot perfom RMA, disabling of devices in such scenario.
- Previously, device passwords were stored in the NFC key vault under several different names. Only the following naming convention will be used for generating secrets (format aligned across Nexus).All older naming conventions will be retired post 9.2 for GF and BF once migrated via API rotation or new geneva action
- . Secrets will be stored in NFC key Vault as before.  `<subscription ID>-<resource group name>-<fabric name>-<username>-devicePassword-<deterministic hash>` .  Example - # device password
   00000000-0000-0000-0000-000000000000-exampleRG-exampleFabric-admin-devicePassword-4418bf71

- Going forward, instead of relying on older naming conventions, user must rely on the new secretArchiveReference fields in the 2025-07-15 API to find device passwords in the key vault.

   For example, on a network device, to find the admin password, look for the secretArchiveReference in its secretRotationStatus.
- “secretRotationStatus”: [
   {
       “lastRotationTime”: “2025-08-09T04:51:41.251Z”,
       “synchronizationStatus”: “InSync”,
       “secretArchiveReference”: {
         “keyVaultUri”: “https://example-kv.vault.azure.net/secrets/example-secret-1/7e61b8efbcdd4e28963560dba3021df7”,
         “keyVaultId”: “/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourceGroups/example-rg/providers/Microsoft.KeyVault/vaults/example-kv”,
         “secretName”: “example-secret-1”,
         “secretVersion”: “7e61b8efbcdd4e28963560dba3021df7”
       },
       “secretType”: “Admin user password”
     },
- Once the BYOKV feature in available (TBD) the same secrets will be copied in customer Key Vault in the above format.
- On Fabric resource delete all secrets pertaining to that Fabric will be purged from NFC Key Vault (similar to present day behaviour)
- Password rotation behavior with other common workflows

| **Scenario** | **User Action (Recommended)** | **Fabric State Updates** | **Device State Updates** | **Password / Certificate rotation Notes** |
| --- | --- | --- | --- | --- |
| Commit operation | 1\. User must perform password rotation only after commit batch is either successful or failed <br><br>&nbsp;<br><br>&nbsp; | 1\. Administrative state - Accepted <br><br>&nbsp; | NA  | Password rotation shall not be catered while fabric state is in accepted |
| Upgrade | 1.User must perform password rotation or resync operation only after upgrade is successful | 1.Administrative state - Under maintenance | 1.Administrative state - Under maintenance | Password rotation shall not be catered while fabric is under upgrade or upgrade failure state |
| Device Disabled (one or more devices ) | 1.User must enable all devices before performing password rotation <br><br>&nbsp; | Administrative state -  Enabled | Administrative state -  Enabled/Deferred control (if Persist RW config exists) | 1.Password rotation is catered. |
|     | 2.If Device enablement fails due to connectivity issue - User must perform reboot with ZTP and perform device enablement | Administrative state -  Enabled | Administrative state -  Disabled | Password will be catered to post enablement of the device |

**Retry framework and Resync behaviour**

- Service has implicit retries built in case of failure but will also provide an API driven retry capabilities. Service also provides resync post action to rotate passwords of specific devices.
- Rotation of passwords will be blocked when max set of unique passwords are present for a Fabric, and the user must rotate all devices via resync
- Resync will not be initiated in below scenarios

| **Scenario** | **Fabric State** | **Device state** | **Comments** |
| --- | --- | --- | --- |
| Fabric Lock | Administrative state - Locked | NA  | State to be implemented, today fabric lock property shows the state of fabric lock |
| Upgrade | Configuration state - Under Maintenance | Configuration state - Under maintenance | &nbsp; |
| Device Disabled | Admin state - Enabled-Degraded | Admin state - Disabled | &nbsp; |
| RMA | Admin state - Enabled-Degraded | Admin state - RMA | &nbsp; |
| Commit | Configuration state- Accepted | NA  | &nbsp; |

**Other scenarios**

- Fabric upgrade will be blocked if all device passwords are not same.
- Service behavior for RMA scenarios as below

| &nbsp;**Scenario** | **User Action (Recommended)** | **Fabric State Updates** | **Device State Updates** | **Password / Certificate rotation Notes** |
| --- | --- | --- | --- | --- |
| Device is unreachable due to failure and unable to serve traffic | 1\. User must perform a POST action to mark Administrative State disabled for the specific device immediately | 1\. Administrative state - Enabled Degraded | 1\. Administrative state: Disabled | Password rotation shall not be catered when the device is disabled. Password rotation can happen via RMA flow which initiates ZTP and bootstrap |
|     | 2.User must perform device serial number patch update and the POST action to mark Administrative State as RMA once replacement device is available | 2\. Administrative state - Enabled Degraded unless the RMA is complete, and all devices are in enabled state | 2\. Administrative state: RMA |     |
| Device is flaky and has intermittent issues but able to serve traffic | 1\. User must perform the POST action to mark Administrative State Disabled whenever the device needs to stop serving traffic <br><br>&nbsp;<br><br>&nbsp; | 1\. Administrative state - Enabled Degraded | 1\. Administrative state: Disabled | Password rotation shall not be catered when device is disabled. Password rotation can happen via RMA flow which initiates ZTP and bootstrap |
|     | 2.User must perform device serial number patch update and the POST action to mark Administrative State as RMA once replacement device is available | 2\. Administrative state - Enabled Degraded unless the RMA is complete, and all devices are in enabled state | 2\. Administrative state: RMA |     |
| Device is flaky and has intermittent issues but unable to serve traffic | 1\. User must perform a POST action to mark administrative state disabled for the specific device immediately <br><br>&nbsp;<br><br>&nbsp; | 1\. Administrative state - Enabled Degraded | 1\. Administrative state: Disabled | Password rotation will not be catered when device is disabled. Password rotation can happen via RMA flow which initiates ZTP and bootstrap |
|     | 2.User must perform device serial number patch update and the POST action to mark Administrative State as RMA once replacement device is available | 2\. Administrative state - Enabled Degraded unless the RMA is complete, and all devices are in enabled state | 2\. Administrative state: RMA |     |
| Device is to be RMA in the future for known issues but serving traffic | 1\. User must perform the POST action to mark Administrative State Disabled whenever the device needs to stop serving traffic <br><br>&nbsp;<br><br>&nbsp; | 1\. Administrative state - Enabled Degraded | 1\. Administrative state: Disabled | Password rotation will not be catered when device is disabled. Password rotation can happen via RMA flow which initiates ZTP and bootstrap |
| &nbsp; | &nbsp;2.User must perform device serial number patch update and the POST action to mark Administrative State as RMA once replacement device is available | &nbsp;2. Administrative state - Enabled Degraded unless the RMA is complete, and all devices are in enabled state | &nbsp;2. Administrative state: RMA | &nbsp; |

- **Geneva actions**- There are couple of Geneva actions available to handle migration of instances to use the latest secrets format

| **Geneva action** | **Compatible API version** | **Lockboxed** | **Secrets format** | **Behaviour/Constraints** |
| --- | --- | --- | --- | --- |
| Old Geneva action | \--2024-06-15-preview and older versions ---GA version - 2025-07-15 | Yes | Old secrets format only | \--Rotates BF instances (built prior to 9.2) which use old secret format<br><br>\--Once instances are migrated to new secrets format via API rotation or new Geneva action, this Geneva action will not work & provide suitable error |
| New Geneva action | \---GA version - 2025-07-15 | Yes | New secrets format only | \--Rotates all GF and BF (which currently have old and new format)<br><br>\--All new GF instances from 9.2 will be having new secrets format.<br><br>\-- Requires 2025-07-15 ARM API rolled out and API based password rotation enabled. |

> [!NOTE]
> Greenfield 9.2 deployments are deployed using the new secrets template. This means it's not possible to rotate secrets on greenfield 9.2 deployments until 2025-07-15 API version is available.



## Next steps

[How to use password rotation v1 in Azure Operator Nexus](./howto-use-password-rotation-v1.md)
