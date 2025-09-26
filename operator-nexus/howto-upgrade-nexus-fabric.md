---
title: How to upgrade Network Fabric for Azure Operator Nexus
description: Learn the process for upgrading Network Fabric for Azure Operator Nexus.
author: RaghvendraMandawale 
ms.author: rmandawale
ms.date: 09/26/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

# Network Fabric Upgrade from 5.0.x or 6.0.0 to 6.1.0

## PURPOSE

This guide outlines a streamlined upgrade process for network fabric infrastructure, designed to support users in modernizing and managing their network environments efficiently. It provides step-by-step instructions leveraging both the Azure Portal and Azure CLI, enabling comprehensive lifecycle management of nexus fabric network devices. Regular updates are crucial for maintaining system integrity and accessing the latest product improvements

## Overview

**Runtime bundle components**: These components require operator consent for upgrades that may affect traffic behavior or necessitate device reboots. The network fabric's design allows for updates to be applied while maintaining continuous data traffic flow.

Runtime changes are categorized as follows:

**Operating system updates**: Necessary to support new features or resolve issues.

**Base configuration updates**: Initial settings applied during device bootstrapping.

**Configuration structure updates**: Generated based on user input for configurations like isolation domains and ACLs. These updates accommodate new features without altering user input.

By following this guide, users can ensure a consistent, scalable, and secure approach to upgrading their network fabric components.

## Prerequisites & Prechecks

| **Pre RT Upgrade action** | **Expectation** | **Owner** |
| --- | --- | --- |
| Check for NFC provisioning state | Must be in Succeeded | Customer/Deployment engineering |
| Cable validation of Network Fabric | All link connections must be up and stable per BOM description - [Validate Cables for Nexus Network Fabric - Operator Nexus | Microsoft Learn](https://learn.microsoft.com/en-us/azure/operator-nexus/how-to-validate-cables) | Customer/Deployment engineering team |
| Check for Administrative lock status of Network Fabric resource | Must be in unlocked state - [Azure Operator Nexus - How to Use Administrative Lock or Unlock Network fabric - Operator Nexus | Microsoft Learn](https://learn.microsoft.com/en-us/azure/operator-nexus/howto-set-administrative-lock-or-unlock-for-network-fabric) | Customer/Deployment engineering |
| Network Fabric resource state checks | The following “Network Fabric” resource states must be validated in the portal:   * Provisioning state is in “**succeeded**” state, * Configuration state is in “**provisioned**” state. * Administrative state is in “**enabled**” status. | Customer/Deployment engineering team |
| NNF device disk space | Minimum 3.0 GB free space within /mnt directory of all the network devices that are getting upgraded. | Customer/Deployment engineering team |
| Terminal Server reprovision | Copy new TS tarball files before proceeding to the upgrade step. | Deployment engineering team |
| Check TOR Speed Setting which is required for runtime version > RT 6.0.0 | Enable 50G as default speed Setting to address CRC errors observed on SKUs. | Deployment engineering team |

Before initiating the **Network Fabric (NF) Upgrade** process, it is **strongly recommended** that users manually validate these resource states prior to triggering the NF upgrade. These proactive validation steps help prevent upgrade failures prior and avoid service interruption challenges. If the required resource states are not met, NNF upgrade process will be stopped.

The following NNF resources (Parent Resources/Child Resources) must satisfy **all** of the following conditions:

- Administration state must be in “enabled” state
- Provisioning state must be in “succeeded” state
- Configuration state must be in “succeeded” state

NNF Resources (Parent Resources/Child Resources)

- NetworkToNetworkConnect (NNI)
- NetworkMonitor (BMP)
- ACLs & Associated resources (Ingress ACLs, CPU & CP TP ACLs)
- L2ISD Resources
- L3ISD & Child resources
    - Internal Network
    - External Network
- Route Policies (Associated resources)
    - IPPrefixes & TrustedIpPrefixes
    - IPCommunityList
    - IPExtendedCommunityList
- NPB (Associated resources)
- Network Tap ->
    - Associated NetworkToNetworkConnect->
    - Internal Network
    - NetworkTAPRule

## NNF Upgrade Procedure

**STEP 0: Network Fabric Status**

az networkfabric fabric show -g xxxxxx --resource-name xxxxxxx

Excepts of the Expected output:

**"administrativeState": "Enabled",**
**"configurationState": "Provisioned**

"fabricASN": 65025,

"fabricVersion": "5.0.0",

"fabricLocks": [
    {
      "lockState": "Disabled",
      "lockType": "Configuration"
    }
    ]

**STEP #1: TRIGGER UPGRADE**

Nexus Network Fabric administrator/Deployment engineer triggers the upgrade POST action on NetworkFabric via AZCLI/Portal with requested payload as:

**Sample az CLI command:**

az networkfabric fabric upgrade -g xxxx --resource-name xxxx --action start --version "6.0.0"

As part of the above POST action request, Managed Network Fabric Resource Provider (RP) performs a validation check to determine whether a version upgrade is permissible from the current fabric version.

The above command marks the Network Fabric in “Under Maintenance” mode and prevents any create or update operation within the Network fabric instance.

**STEP #2: TRIGGER UPGRADE PER DEVICE**

Nexus Network Fabric administrator/Deployment engineer triggers upgrade POST actions per device. Each of the NNF device resource states must be validated either Azure Portal or Azure CLI:

* Provisioning state is in “**succeeded**” state,
* Configuration state is in “**provisioned**” state.
* Administrative state is in “**Enabled**” state

Each of the NNF devices will enter maintenance mode post triggering the upgrade. Traffic is drained and route advertisements will be stopped.

**NNF Upgrade sequence:**

* Odd numbered TORs (Parallel).
* Even numbered TORs (Parallel).
* Compute rack management switches (Parallel).
* CEs are to be upgraded one after the other in a serial manner. Stop the upgrade procedure if there are any failures corresponding to CE upgrade operation. After each CE upgrade, wait for a duration of five minutes to ensure that the recovery process is complete before proceeding to the next CE device upgrade.
* Remaining aggregate rack switches are to be upgraded one after the other in a serial manner.
* Upgrade Network Packet Broker (NPB) devices in a serial manner.

**Sample az CLI command:**

* az networkfabric device upgrade --version 6.1.0 -g xxxx --resource-name xxx-CompRack1-TOR1 --debug

**Post validation for Step #2 :**

1. After all network fabric devices upgrades are completed, User must ensure that none of the NNF devices are “Under Maintenance” and these devices runtime versions must be in either 6.0.0 or 6.1.0 by running the following commands.

**Sample az CLI command:**

az networkfabric device list -g <resource-group> --query "[].{name:name,version:version}" -o table

**STEP 3: COMPLETE UPGRADE**

Once all the NNF devices are successfully upgraded to the latest version i.e either 6.0.0 or 6.1.0, Nexus Network Fabric administrator/Deployment engineer will run the following command to take the network fabric out of maintenance state and complete the upgrade procedure.

**Sample az CLI command:**

az networkfabric fabric upgrade --action complete --version "6.1.0" -g "<resource-group>" --resource-name "<fabric-name>" --debug

Once the fabric upgrade is done, we can verify the status of the network fabric by executing the following az cli commands:

az networkfabric fabric show -g <resource-group> --resource-name <fabric-name>

az networkfabric fabric list -g xxxxx --query "[].{name:name,fabricVersion:fabricVersion,configurationState:configurationState,provisioningState:provisioningState}" -o table

**STEP 4: Credential rotation (optional step).**

Deployment engineer/Directly Responsible Individual (DRI) must validate the device's maintenance mode status after each cycle of credential rotation is completed. The device should not remain in the under-maintenance state post credential rotation.

**Note** : There is no customer action required for the above step.

## Post Upgrade validation steps:

|  |  |  |
| --- | --- | --- |
| **Post NNF RT Upgrade action** | **Expectation** | **Owner** |
| Version compliance | All Network Fabric devices must be in either RT version 6.0.0 or 6.1.0 | Customer/Deployment engineering team |
| Maintenance status check | Ensure TOR and CE devices maintenance status is “NOT under Maintenance” (show maintenance runro command) | Customer/Deployment engineering team |
| Connectivity Validation | Verify CE ↔ PE connections are stable or similar to the pre-upgrade status (show ip interface brief runro command) | Customer/Deployment engineering team |
| Reachability Checks | Confirm all NF devices are reachable via jump server (ping <MA1\_IP>, ping6 <Loopback6\_IP>) | Customer/Deployment engineering team |
| BGP Summary Validation | Ensure BGP sessions are established across all VRFs (show ip bgp summary vrf all runro command on CEs) | Customer/Deployment engineering team |
| GNMI Metrics Emission | Confirm GNMI metrics are being emitted for subscribed paths (check via dashboards or CLI) | Customer/Deployment engineering team |

## Appendix :

The following table outlines the **step-by-step procedures** associated with selected pre and post upgrade actions referenced earlier in this guide

Each entry in the table corresponds to a specific action, offering detailed instructions, relevant parameters, and operational notes to ensure successful implementation. This appendix serves as a practical reference for users seeking to deepen their understanding and confidently carry out the NNF upgrade procedure

|  |  |
| --- | --- |
| **Action** | **Detailed steps** |
| Device image validation | Confirm latest image version is installed by executing “show version” runro command on each NF device.  az networkfabric device run-ro -g xxxx --resource-name xxxx --ro-command "show version".  The above output must reflect the latest image version as per the release documentation. |
| Maintenance status check | Ensure TOR and CE device status is not under maintenance by executing “show maintenance” runro command. The above status must not be in “Maintenance mode is disabled”. |
| Connectivity Validation | Verify CE ↔ PE connections are stable.  “Show ip interface brief” runro command. |
| Reachability Checks | Confirm all NF devices are reachable via jump server:   * MA1 address ping <MA1\_IP> * Loopback6 address ping6 <Loopback6\_IP> |
| BGP Summary Validation | Ensure BGP sessions are established across all VRFs by executing “show ip bgp summary vrf all” “runro command” on CE devices.The above status must ensure that peers should be in Established state – consistent with pre upgrade state. |
