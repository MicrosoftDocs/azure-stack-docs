---
title: How to upgrade Network Fabric for Azure Operator Nexus
description: Learn the process for upgrading Network Fabric for Azure Operator Nexus, including required and recommended prevalidations.
author: RaghvendraMandawale 
ms.author: rmandawale
ms.date: 11/25/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

# Network Fabric Runtime Upgrade

This guide outlines, which preupgrade validations are required for a successful Network Fabric runtime upgrade and which validations are recommended. Required prevalidation checks lead to an upgrade failure if conditions of the validations aren't met. Recommended prevalidation checks help ensure consistency of the release. 

## Overview

**Runtime bundle components**: These components require operator consent for upgrades that may affect traffic behavior or necessitate device reboots. The network fabric's design allows for updates to be applied while maintaining continuous data traffic flow.

Runtime changes are categorized as follows:

**Operating system updates**: Necessary to support new features or resolve issues.

**Base configuration updates**: Initial settings applied during device bootstrapping.

**Configuration structure updates**: Generated based on user input for configurations like Isolation Domains and ACLs. These updates accommodate new features without altering user input.

By following this guide, users can ensure a consistent, scalable, and secure approach to upgrading their network fabric components.

## Required Pre-Upgrade Validations

Before initiating the **Network Fabric (NF) Runtime Upgrade** process, it's **required** that users validate these resource states prior to triggering the upgrade. These proactive validation steps help prevent upgrade failures and avoid service interruption challenges. If the required resource states aren't met, NNF upgrade process should be stopped. Observations may be taken during the upgrade's major milestones to ensure resource states remain consistent. It's recommended to perform these checks after the TOR and Mgmt switch upgrades. Validation for the CE devices should be performed after each CE upgrade before proceeding to the next CE device upgrade.

| **Check** | **Expectation** | **Post Upgrade Check Applicable?** | **RT Upgrade Failure Phase** |
| --- | --- | --- | --- |
| Check for NFC provisioning state | Provisioning state must be in "Succeeded" | No | Fabric upgrade start step fails |
| Check for Administrative lock status of Network Fabric resource | Must be in unlocked state - [Azure Operator Nexus - How to Use Administrative Lock or Unlock Network fabric - Operator Nexus](./howto-set-administrative-lock-or-unlock-for-network-fabric.md) | No | Fabric upgrade start step fails |
| Network Fabric resource state checks | Resource states must be validated:<br/>• Administrative state is "Enabled" <br/>• Provisioning state is "Succeeded" <br/>• Configuration state is "Provisioned" | Yes | Fabric upgrade start command fails |
| Fabric Devices - NPB, TOR, CE, Mgmt switch | Resource states must be validated:<br/>• Administrative state is "Enabled" <br/>• Provisioning state is "Succeeded" <br/>• Configuration state is "Succeeded" | Yes | Device upgrade command fails for corresponding device |
| NNF device disk space | Minimum 2.5 GB of free space within /mnt directory of all the network devices that are getting upgraded | No | Device upgrade command fails for corresponding device |
| BGP Summary Validation | Ensure BGP sessions are established across all VRFs (show ip bgp summary vrf all runro command on CEs) | Yes | CE Device upgrade command fails (probable connectivity issue with PE) |
| GNMI Metrics Emission | Confirm GNMI metrics are being emitted for subscribed paths | Yes | Device upgrade command fails for corresponding device (Probable connectivity issue) |
| Terminal Server | The Terminal Server shall be confirmed to be accessible and running | No | Fabric upgrade start command fails |
| NetworkToNetworkConnect (NNI)<br/>Network Interfaces referred in NNI<br/>Network Monitor (BMP)<br/>ACLs & Associated resources<br/>Ingress ACLs, CPU & CP TP ACLs<br/>L2ISD Resources<br/>L3ISD Resources<br/>Route Policies<br/>IPPrefixes<br/>IP Communities<br/>IP Extended Communities | When the Resource has an Administrative state is in "Enabled" status:<br/>• Provisioning state is "Succeeded"<br/>• Configuration state is "Succeeded"<br/><br/>When the Resource has an Administrative state in "Disabled" status, the resource has no impact on the runtime upgrade | No | Fabric upgrade start command fails |
| Internal and External Networks referred in L3 ISD | When L3 ISD Administrative state is in "Enabled" status:<br/>• Internal & External Networks Administrative state is in "Enabled" status<br/>• Provisioning state is in "Succeeded" status<br/>• Configuration State is in "Succeeded" status | No | Fabric upgrade start command fails |
| Network Tap | When the Resource has an Administrative state is in "Enabled" status:<br/>• Provisioning state shall is "Succeeded" state<br/>• Configuration state is in "Succeeded" or "Accepted" state | No | Fabric upgrade start command fails |
| Network Tap Rule, NNI, and Internal network associated with Network Tap | Parent Network Tap has an Administrative state is in "Enabled" status:<br/>• Provisioning state shall need to be in "Succeeded" state<br/>• Configuration state in "Succeeded" or "Accepted" state | No | Fabric upgrade start command fails |
| Neighbor Group associated to Network Tap | Parent Network Tap has an Administrative state is in "Enabled" status:<br/>• Provisioning state shall need to be in "Succeeded" state | No | Fabric upgrade start command fails |

## Recommended Pre-Upgrade Validations

Before initiating the Network Fabric (NF) Runtime Upgrade process, it's **recommended** that users validate these resource states prior to triggering the NF upgrade. These resources won't prevent the upgrade, but should be checked before and after to confirm state remains consistent.

| **NNF Resource** | **Expectation** |
| --- | --- |
| Cable validation of Network Fabric | All link connections should be up and stable per BOM description - [Validate Cables for Nexus Network Fabric - Operator Nexus](./how-to-validate-cables.md) |


## Step by Step Nexus Fabric Upgrade Procedure

### Step 0: Network Fabric Status

`az networkfabric fabric show -g xxxxxx --resource-name xxxxxxx`

Excerpts of the Expected output:

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

### Step 1: Trigger Upgrade

Nexus Network Fabric customer triggers the upgrade POST action on NetworkFabric via AZ CLI/Portal with requested payload as:

#### Sample az CLI command

`az networkfabric fabric upgrade -g xxxx --resource-name xxxx --action start --version "6.1.0"`

As part of the above POST action request, Managed Network Fabric Resource Provider (RP) performs a validation check to determine whether a version upgrade is permissible from the current fabric version.

The above command marks the Network Fabric in "Under Maintenance" mode and prevents any create or update operation within the Network fabric instance.

### Step 2: Trigger Upgrade Per Device

Nexus Network Fabric customer triggers upgrade POST actions per device. Each of the NNF device resource states must be validated either Azure portal or Azure CLI:

* Provisioning state is in **Succeeded** state,
* Configuration state is in **Provisioned** state.
* Administrative state is in **Enabled** state

Each of the NNF devices enter maintenance mode post triggering the upgrade. Traffic is drained and route advertisements are stopped.

#### NNF Upgrade sequence

* Odd numbered TORs (parallel).
* Even numbered TORs (parallel).
* Compute rack management switches (parallel).
* CEs are to be upgraded one after the other in a serial manner. Stop the upgrade procedure if there are any failures corresponding to CE upgrade operation. After each CE upgrade, wait for a duration of five minutes to ensure that the recovery process is complete before proceeding to the next CE device upgrade.
* Upgrade Network Packet Broker (NPB) devices in a serial manner.
* Aggregate rack management switches are to be upgraded one after the other in a serial manner.

Similar to the preupgrade validation steps, it's recommended to validate the NNF device resource states post triggering the upgrade at the following checkpoints:
* After odd numbered TORs complete, prior to even numbered TORs upgrade.
* After CE1 upgrade, prior to CE2 upgrade.
* After Agg switch1 upgrade, prior to Agg switch2 upgrade.


#### Sample az CLI command

`az networkfabric device upgrade --version 6.1.0 -g xxxx --resource-name xxx-CompRack1-TOR1 --debug`

#### Post validation for Step 2 

After all Network Fabric devices upgrades are completed, User must ensure that none of the NNF devices are "Under Maintenance" and these devices runtime versions must be showing 6.1.0 by running the following commands.

#### Sample az CLI command:

`az networkfabric device list -g <resource-group> --query "[].{name:name,version:version}" -o table`

### Step 3: Complete Upgrade

Once all the NNF devices are successfully upgraded to the latest version,  i.e., 6.1.0, Nexus Network Fabric customer runs the following command to take the network fabric out of maintenance state and complete the upgrade procedure.

#### Sample az CLI command

`az networkfabric fabric upgrade --action complete --version "6.1.0" -g "<resource-group>" --resource-name "<fabric-name>" --debug`

Once the Fabric upgrade is done, we can verify the status of the network fabric by executing the following az cli commands:

`az networkfabric fabric show -g <resource-group> --resource-name <fabric-name>
az networkfabric fabric list -g xxxxx --query "[].{name:name,fabricVersion:fabricVersion,configurationState:configurationState,provisioningState:provisioningState}" -o table`

### Step 4: Credential rotation (optional step).

Customer performing action must validate the device's maintenance mode status after each cycle of credential rotation is completed. The device shouldn't remain in the under-maintenance state post credential rotation.


## Post Upgrade validation steps

| **Post NNF RT Upgrade action** | **Expectation**                                                                                                    |
|--------------------------------|--------------------------------------------------------------------------------------------------------------------|
| Version compliance             | All Network Fabric devices must be in either RT version 6.1.0                                                      |
| Maintenance status check       | Ensure TOR and CE devices maintenance status is "NOT under Maintenance" (show maintenance runro command)           |
| Connectivity Validation        | Verify CE ↔ PE connections are stable or similar to the preupgrade status (show ip interface brief runro command) |
| Reachability Checks            | Confirm all NF devices are reachable via jump server (ping &lt;MA1_IP&gt;, ping6 &lt;Loopback6_IP&gt;)             |
| BGP Summary Validation         | Ensure BGP sessions are established across all VRFs (show ip bgp summary vrf all runro command on CEs)             |
| GNMI Metrics Emission          | Confirm GNMI metrics are being emitted for subscribed paths (check via dashboards or CLI)                          |

## Appendix 

The following table outlines the **step-by-step procedures** associated with selected pre and post upgrade actions referenced earlier in this guide

Each entry in the table corresponds to a specific action, offering detailed instructions, relevant parameters, and operational notes to ensure successful implementation. This appendix serves as a practical reference for users seeking to deepen their understanding and confidently carry out the NNF upgrade procedure

| **Action** | **Detailed steps** |
| --- | --- |
| Device image validation | Confirm latest image version is installed by executing "show version" runro command on each NF device. az networkfabric device run-ro -g xxxx -resource-name xxxx -ro-command "show version." The above output must reflect the latest image version as per the release documentation. |
| Maintenance status check | Ensure TOR and CE device status isn't under maintenance by executing "show maintenance" runro command. The above status must not be in "Maintenance mode is disabled". |
| Connectivity Validation | Verify CE ↔ PE connections are stable. "Show ip interface brief" runro command. |
| Reachability Checks | Confirm all NF devices are reachable via jump server: \* MA1 address ping &lt;MA1_IP&gt; \* Loopback6 address ping6 &lt;Loopback6_IP&gt; |
| BGP Summary Validation | Ensure BGP sessions are established across all VRFs by executing "show ip bgp summary vrf all" "runro command" on CE devices. The above status must ensure that peers should be in Established state - consistent with pre upgrade state. |

The following table outlines all Resource Types referenced in this document

| **Resource Type**    | **Resource Provider Namespace**                                             |
|----------------------|-----------------------------------------------------------------------------|
| NFC                  | microsoft.managednetworkfabric/NetworkFabricControllers                     |
| NF                   | microsoft.managednetworkfabric/networkfabrics                               |
| NNI                  | microsoft.managednetworkfabric/networkfabrics/networktonetworkinterconnects |
| BMP                  | microsoft.managednetworkfabric/networkmonitors                              |
| ACL                  | microsoft.managednetworkfabric/accesscontrollists                           |
| L2 ISD               | microsoft.managednetworkfabric/l2isolationdomains                           |
| L3 ISD               | microsoft.managednetworkfabric/l3isolationdomains                           |
| Route Policies       | microsoft.managedNetworkFabric/routePolicies                                |
| IP Prefixes          | microsoft.managedNetworkFabric/IpPrefixes                                   |
| IP Communities       | microsoft.managedNetworkFabric/IpCommunities                                |
| IP Extd. Communities | microsoft.managedNetworkFabric/IpExtendedCommunities                        |
| Internal Networks    | microsoft.managednetworkfabric/l3isolationdomains/internalnetworks          |
| External Networks    | microsoft.managednetworkfabric/l3isolationdomains/externalnetworks          |
| Network Taps         | microsoft.managednetworkfabric/networktaps                                  |
| Network Tap Rules    | microsoft.managednetworkfabric/networktaprules                              |
| NPB                  | microsoft.managednetworkfabric/networkpacketbrokers                         |
| Network Devices      | microsoft.managednetworkfabric/NetworkDevices                               |
| Network Interfaces   | microsoft.managednetworkfabric/networkDevices/networkInterfaces             |
