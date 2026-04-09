---
title: Upgrade Network Fabric for Azure Operator Nexus
description: Learn how to upgrade Network Fabric for Azure Operator Nexus, and find out about required and recommended pre-validations.
author: RaghvendraMandawale 
ms.author: rmandawale
ms.date: 11/25/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

# Upgrade your Azure Operator Nexus Network Fabric runtime

In this article, you learn about both *required* and *recommended* pre-upgrade validations to carry out before you upgrade your Azure Operator Nexus Network Fabric runtime.

If you don't perform the *required* pre-validation checks and meet the conditions, your upgrade fails. Performing the *recommended* checks can help you ensure the consistency of your release.

## Overview

Runtime bundle components require operator consent for upgrades that might affect traffic behavior or necessitate device reboots. Network Fabric is designed to apply updates while also maintaining continuous data traffic flow.

Runtime changes are categorized as follows:

- **Device operating system updates**: These updates are necessary to support new features or resolve problems.

- **Base configuration updates**: These initial settings are applied during device bootstrapping.

- **Configuration structure updates**: These updates are generated based on user input for configurations (like isolation domains and ACLs). These updates accommodate new features without altering user input.

Follow the instructions in this article for a consistent, scalable, and secure approach to upgrading your Network Fabric components.

## <a name = "required-preupgrade-validations"></a> Required pre-upgrade validations

Before initiating the Network Fabric runtime upgrade, Users have the option to validate all the resource readiness prechecks as part of the upgrade workflow. These proactive validation steps help identify configuration or readiness issues early, reducing the risk of upgrade failures and minimizing potential service interruptions.

Starting with the 2604.1 release, an opt‑in enforcement mechanism is available to mandate pre‑upgrade validations. This enforcement is enabled through a support ticket and is governed by a fabric instance–level persistent feature flag.

When the feature flag is enabled, any pre‑upgrade validation failure will block the upgrade until the identified issues are remediated.

### Recommended guidance for feature flag (enabled) workflow
- Pre‑upgrade validations are enforced during the fabric runtime upgrade start.
- Users are expected to run incremental validation checks only, as applicable.

#### User guidance
- Run targeted incremental validation checks only for areas not covered by the automated pre‑upgrade checks.
- If validation failures occur, re‑run only the failed resource readiness validation tests.

### Recommended guidance for default workflow (feature flag disabled)
- The fabric upgrade start API does not block or interrupt the upgrade due to missing pre‑upgrade validations.
- No enhanced validations are performed; user‑initiated validations remain the primary validation mechanism.

#### User guidance
- Users must run the complete set of pre‑upgrade validation checks prior to initiating the fabric runtime upgrade.

| Check | Expectation | Automated feature flag workflow  | Post-upgrade check applicable? | Impacted runtime upgrade step (if pre-validation fails) |
| --- | --- | --- | --- | --- |
| Check the NFC provisioning state. | Provisioning state must be **Succeeded**. | Yes | No | The Network Fabric upgrade start step fails. |
| Check the administrative lock status of the Network Fabric resource. | The state must be **Unlocked**. For more: [Azure Operator Nexus: Use the administrative lock or unlock for Network Fabric](./howto-set-administrative-lock-or-unlock-for-network-fabric.md). | Yes | No | The Network Fabric upgrade start step fails. |
| Check the Network Fabric resource states. | Validate the resource states:<br/>• Administrative state is **Enabled**. <br/>• Provisioning state is **Succeeded**. <br/>• Configuration state is **Provisioned**. | Yes | Yes | The Network Fabric upgrade start command fails. |
| Check Fabric devices, including: network packet brokers (NPBs), top-of-rack switches (TORs), customer edge switches (CEs), and management switches (MGMTs). | Validate the resource states:<br/>• Administrative state is **Enabled**. <br/>• Provisioning state is **Succeeded**. <br/>• Configuration state is **Succeeded** or **Deferred Control**. | Yes | Yes | The device upgrade command fails for the corresponding device. |
| Check the disk space of Network Fabric devices. | You need a minimum of 2.5 GB of free space within the `/mnt` directory of each network device that's being upgraded. | No | No | The device upgrade command fails for the corresponding device. |
| Check the BGP summary validation. | Ensure that BGP sessions are established across all VRFs. (Show the `ip bgp summary vrf all` runro command on CEs.) | No | Yes | The CE device upgrade command fails due to a probable connectivity issue with the PE. |
| Check the GNMI metrics emission. | Confirm that GNMI metrics are being emitted for subscribed paths. | No | Yes | The device upgrade command fails for the corresponding device due to a probable connectivity issue. |
| Check the terminal server. | Confirm that the terminal server is accessible and running. | No | No | The Network Fabric upgrade start command fails. |
| Check the following elements:<br/>NetworkToNetworkConnect (NNI)<br/>Network interfaces referred in NNI<br/>Network monitor (BMP)<br/>ACLs and associated resources<br/>Ingress ACLs, CPU, and CP TP ACLs<br/>L2ISD resources<br/>L3ISD resources<br/>Route policies<br/>IPPrefixes<br/>IP communities<br/>IP extended communities | When the resource's administrative state is **Enabled**:<br/>• Provisioning state is **Succeeded**.<br/>• Configuration state is **Succeeded**.<br/><br/>When the resource's administrative state is **Disabled**, the resource has no impact on the runtime upgrade. | Yes | No | The Network Fabric upgrade start command fails. |
| Check the internal and external networks referred in L3 ISD. | When the L3 ISD administrative state is **Enabled**:<br/>• The internal and external networks' administrative state is **Enabled**.<br/>• Provisioning state is **Succeeded**.<br/>• Configuration state is **Succeeded**.<br/><br/>When the L3 ISD administrative state is **Disabled**, the internal and external network resource has no impact on the runtime upgrade. | Yes | No | The Network Fabric upgrade start command fails. |
| Check the network tap. | When the resource's administrative state is **Enabled**:<br/>• Provisioning state is **Succeeded**.<br/>• Configuration state is **Succeeded** or **Accepted**.<br/><br/>When the resource's administrative state in **Disabled**, the resource has no impact on the runtime upgrade. | Yes | No | The Network Fabric upgrade start command fails. |
| Check the network tap rule, the NNI, and the internal network associated with the network tap. | When the parent network tap's administrative state is **Enabled**:</br>• Provisioning state is **Succeeded**.</br>• Configuration state is **Succeeded** or **Accepted**.<br/><br/> When the network tap's administrative state is **Disabled**, this resource has no impact on the runtime upgrade. | Yes | No | The Network Fabric upgrade start command fails. |
| Check the neighbor group associated to the network tap. | When the parent network tap's administrative state is **Enabled**: </br>Provisioning state must be **Succeeded**.<br/><br/> When the network tap's administrative state is **Disabled**, this resource has no impact on the runtime upgrade. | Yes | No | The Network Fabric upgrade start command fails. |
| Check the CE-to-PE link traffic. | Validate the CE-to-PE uplink port interface traffic (`Et1/1` to `Et1/6`). | No | Yes | The CE device upgrade command fails due to a probable connectivity issue with the PE. |

## Recommended pre-upgrade checks

Before you initiate the Network Fabric runtime upgrade process, we *recommend* that you validate these resource states before you trigger the Network Fabric upgrade. Problems with these resources won't prevent the upgrade, but you should still check them before and after the upgrade to confirm that the state remains consistent.

| Network Fabric resource | Expectation |
| --- | --- |
| Cable validation of Network Fabric | All link connections should be up and stable per BOM description: [Validate cables for Azure Operator Nexus Network Fabric](./how-to-validate-cables.md). |

## Network Fabric upgrade procedure

### Check the Network Fabric status

Run the following command:

`az networkfabric fabric show -g xxxxxx --resource-name xxxxxxx`

Here are excerpts of the expected output:

`**"administrativeState": "Enabled",**`

`**"configurationState": "Provisioned"**`

`"fabricASN": 65025,`

`"fabricVersion": "5.0.0",`

`"fabricLocks": [
    {
      "lockState": "Disabled",
      "lockType": "Configuration"
    }
    ]`

### Trigger the upgrade

Trigger the upgrade `POST` action on Network Fabric via the Azure CLI or the Azure portal with the requested payload.

Here's a sample command for the Azure CLI:

`az networkfabric fabric upgrade -g xxxx --resource-name xxxx --action start --version "8.0.0"`

As part of the preceding `POST` action request, the managed Network Fabric resource provider performs a validation check to determine whether a version upgrade is permissible from the current Network Fabric version.

The preceding command designates that the fabric is in **Under Maintenance** mode and prevents any `create` or `update` operation within the fabric.

### Trigger the upgrade on a per-device basis

Trigger upgrade `POST` actions on a per-device basis. Each of the Network Fabric devices enters maintenance mode after you trigger the device upgrade `POST` action. The traffic drains and route advertisements stop.  

Here's a sample command for the Azure CLI:

`az networkfabric device upgrade --version 8.0.0 -g xxxx --resource-name xxx-CompRack1-TOR1 --debug`

#### Pre-validate each device

Use the Azure portal or the Azure CLI to validate the resource states of each Network Fabric device. Confirm that they're in the following states:

| Check | Expectation | Outcome and guidance |
| --- | --- | --- |
| Validate the Network Fabric device resource state. | Confirm these states:</br> - Provisioning state is **Succeeded**.</br> - Configuration state is **Succeeded** or **Deferred Control**.</br> - Administrative state is **Enabled**. | The device upgrade step is considered to be failed. Engage Microsoft support to diagnose and resolve the problem.|

Follow these steps:

1. Trigger the upgrade of odd-numbered TORs (parallel). (Example of an eight-rack: TORs 1, 3, 5, 7, 9, 11, 13, and 15.)

1. Perform mid-validations on the odd-numbered TORs to validate that the upgrade succeeded.

1. Trigger the upgrade of even-numbered TORs (parallel). (Example of an eight-rack: TORs 2, 4, 6, 8, 10, 12, 14, 16.)

1. Perform mid-validations on the even-numbered TORs to validate that the upgrade succeeded.

1. Trigger the upgrade of compute rack management switches (parallel).

1. Perform mid-validations on the compute rack management switches to validate that the upgrade succeeded.

1. Trigger the upgrade of the CE1.

1. Perform mid-validations on the CE1 to validate that the upgrade succeeded.

1. Trigger the upgrade of the CE2.

1. Perform mid-validations on the CE2 to validate that the upgrade succeeded.

1. Trigger the upgrade of NPBs (serial).

1. Perform mid-validations on the NPBs to validate that the upgrade succeeded.

1. Trigger the upgrade of aggregate rack management switches (serial).

1. Perform mid-validations on the aggregate rack management switches to validate that the upgrade succeeded.

#### Perform mid-validation checks

| Check | Expectation | Outcome and guidance |
| --- | --- | --- |
| Check the runtime and extensible operating system (EOS) version. | The resource runtime version should match the target runtime version provided in the `networkfabric device upgrade` command (for example, 8.0.0). The EOS version on the device should match the target EOS version in the release you're upgrading to (for example, `EOS64-4.34.1F.swi`). | The device upgrade step is considered failed. Engage Microsoft support to diagnose and resolve the problem. |
| Validate the Network Fabric device's resource state. | Validate the resource states:<br/>• Administrative state is **Enabled**. <br/>• Provisioning state is **Succeeded**. <br/>• Configuration state is **Succeeded** or **Deferred Control**. | The device upgrade step is considered failed. Engage Microsoft support to diagnose and resolve the problem. |
| Validate that the device state isn't in maintenance mode. | The device should be out of maintenance mode after the upgrade. | The device upgrade step is considered failed. Engage Microsoft support to diagnose and resolve the problem. |
| Validate the status of BGP sessions (applicable to CE and TOR). | All BGP sessions are expected to have a state of: **Established**. | The device upgrade step is considered failed. Engage Microsoft support to diagnose and resolve the problem. |
| Check telemetry accuracy for Azure connectivity. | Device CPU metrics should be received in Azure monitoring. | The device upgrade step is considered failed. Engage Microsoft support to diagnose and resolve the problem. |

### Complete the upgrade

After all the Network Fabric devices are successfully upgraded to the latest version (8.0.0), run the following command to take the fabric out of the maintenance state and complete the upgrade procedure.

Here's a sample command for the Azure CLI:

`az networkfabric fabric upgrade --action complete --version "8.0.0" -g "<resource-group>" --resource-name "<fabric-name>" --debug`

Beginning with Network Fabric version 8.0.0, network device certificate (GNMI certificate) rotation is now an automated step integrated into the Network Fabric runtime upgrade workflow. This enhancement ensures that all Network Fabric upgrades to version 8.0.0 and newer include the certificate lifecycle management step without requiring separate manual operations.

With the introduction of this automated step, the Network Fabric *upgrade complete* phase might increase the upgrade cycle by 45 to 60 minutes. This extended duration reflects the time required to safely rotate certificates across all network devices.

If an error occurs during certificate rotation:

- The error details surface in the `operationStatus` entry of the Network Fabric upgrade complete operation.
- When you perform the upgrade through the Azure CLI, error messages also directly display in the terminal. These messages appear only when errors occur.

After the Network Fabric upgrade finishes, verify the status of the fabric by running the following Azure CLI commands:

`az networkfabric fabric show -g <resource-group> --resource-name <fabric-name>
az networkfabric fabric list -g xxxxx --query "[].{name:name,fabricVersion:fabricVersion,configurationState:configurationState,provisioningState:provisioningState}" -o table`

### Rotate credentials (optional)

Validate the maintenance mode status of the device after you finish each cycle of credential rotation. The device shouldn't remain in the under-maintenance state after you rotate credentials.

## Post-upgrade validation steps

| Azure Operator Nexus Network Fabric post-runtime upgrade action | Expectation                                                                                                    |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------|
| Version compliance             | All Network Fabric devices must be in the target runtime version.                                                     |
| Maintenance status check       | Ensure that TOR and CE devices don't have a maintenance status of **Under Maintenance**. (Show the `maintenance` runro command.)           |
| Connectivity validation        | Verify that the CE-to-PE connections are stable or similar to the pre-upgrade status. (Show the `ip interface brief` runro command.) |
| BGP summary validation         | Ensure that BGP sessions are established across all VRFs. (Show the `ip bgp summary vrf all` runro command on CEs.)             |
| GNMI metrics emission          | Confirm that GNMI metrics are emitted for subscribed paths. (Check via dashboards or the Azure CLI.)                          |

## Appendix

The following table outlines the *step-by-step procedures* associated with selected pre-upgrade and post-upgrade actions referenced earlier in this guide.

Each entry in the table corresponds to a specific action, offering detailed instructions, relevant parameters, and operational notes to ensure successful implementation. This appendix serves as a practical reference for users seeking to deepen their understanding and confidently carry out the Azure Operator Nexus Network Fabric upgrade procedure.

| Action | Detailed steps |
| --- | --- |
| Device image validation | Confirm the latest image version is installed by running the `show version` runro command on each Network Fabric device. Use the `az networkfabric device run-ro -g xxxx -resource-name xxxx -ro-command "show version"` command. The output must reflect the latest image version according to the release documentation. |
| Maintenance status check | Ensure that TOR and CE device status isn't **Under Maintenance** by executing the `show maintenance` runro command. The previous status must not be **Maintenance mode is disabled**. |
| Connectivity validation | Verify that the CE-to-PE connections are stable by running the `show ip interface brief` runro command. |
| BGP summary validation | Ensure that BGP sessions are established across all VRFs by executing the `show ip bgp summary vrf all` runro command on CE devices. The previous status must ensure that peers should be in **Established state** (consistent with the pre-upgrade state). |

The following table outlines all resource types referenced in this article.

| Resource type    | Resource provider namespace                                             |
|----------------------|-----------------------------------------------------------------------------|
| NFC                  | `microsoft.managednetworkfabric/NetworkFabricControllers`                     |
| NF                   | `microsoft.managednetworkfabric/networkfabrics`                               |
| NNI                  | `microsoft.managednetworkfabric/networkfabrics/networktonetworkinterconnects` |
| BMP                  | `microsoft.managednetworkfabric/networkmonitors`                              |
| ACL                  | `microsoft.managednetworkfabric/accesscontrollists`                           |
| L2 ISD               | `microsoft.managednetworkfabric/l2isolationdomains`                           |
| L3 ISD               | `microsoft.managednetworkfabric/l3isolationdomains`                           |
| Route policies       | `microsoft.managedNetworkFabric/routePolicies`                                |
| IP prefixes          | `microsoft.managedNetworkFabric/IpPrefixes`                                   |
| IP communities       | `microsoft.managedNetworkFabric/IpCommunities`                                |
| IP-extended communities | `microsoft.managedNetworkFabric/IpExtendedCommunities`                        |
| Internal networks    | `microsoft.managednetworkfabric/l3isolationdomains/internalnetworks`          |
| External networks    | `microsoft.managednetworkfabric/l3isolationdomains/externalnetworks`          |
| Network taps         | `microsoft.managednetworkfabric/networktaps`                                  |
| Network tap rules    | `microsoft.managednetworkfabric/networktaprules`                              |
| NPB                  | `microsoft.managednetworkfabric/networkpacketbrokers`                         |
| Network devices      | `microsoft.managednetworkfabric/NetworkDevices`                               |
| Network interfaces   | `microsoft.managednetworkfabric/networkDevices/networkInterfaces`             |
