---
title: Troubleshoot BMM Warning messages in Azure Operator Nexus
description: Troubleshooting guide for Bare Metal Machines Warning status messages in Azure Operator Nexus.
ms.service: azure-operator-nexus
ms.custom: azure-operator-nexus
ms.topic: troubleshooting
ms.date: 06/16/2026
author: mbethi527
ms.author: mbethi
ms.reviewer: ekarandjeff
---

# Troubleshoot _'Warning'_ detailed status messages on an Azure Operator Nexus Cluster Bare Metal Machine

This document provides basic troubleshooting information for Bare Metal Machine (BMM) resources that are reporting a _Warning_ message in the BMM detailed status message.

## Prerequisites

- Access to the Azure portal or Azure CLI
- Permissions to view and manage Bare Metal Machine resources
- For diagnostic commands: SSH access via BareMetalMachineKeySet (see [Manage emergency access to a Bare Metal Machine](./howto-baremetal-bmm-ssh.md))

## Symptoms

The Detailed status message of the Bare Metal Machine (Operator Nexus) resource includes one or more of the following.

| Detailed status message                                      | Details and mitigation                                                                                                     |
|--------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------|
| `Warning: PXE port is unhealthy`                             | [`Warning: PXE port is unhealthy`](#warning-pxe-port-is-unhealthy)                                                         |
| `Warning: BMM power state doesn't match expected state`      | [`Warning: BMM power state doesn't match expected state`](#warning-bmm-power-state-doesnt-match-expected-state)            |
| `Warning: Disk I/O failures detected`                        | [`Warning: Disk I/O failures detected`](#warning-disk-io-failures-detected)                                                |
| `Warning: health monitoring agent is not responding`         | [`Warning: health monitoring agent is not responding`](#warning-node-problem-detector-heartbeat-failures-detected)         |
| `Warning: This machine has failed hardware validation`       | [`Warning: This machine has failed hardware validation`](#warning-this-machine-has-failed-hardware-validation)             |

## Troubleshooting

Evaluate the current status of all BMMs in the specified resource group.
Any active _Warning_ conditions are visible in the Detailed Status Message, as seen in the following example.

To check for any Bare Metal Machines (BMMs) which are reporting _Warning_ messages, run:

```azurecli
az networkcloud baremetalmachine list -g <ResourceGroup_Name> -o table
Name            ResourceGroup                       DetailedStatus    DetailedStatusMessage
--------------  ----------------------------------  ----------------  -------------------------------------------------------------------------------------------
rack1control01  cluster-1-HostedResources-3EA53DF9  Provisioned       The OS is provisioned to the machine.
rack1control02  cluster-1-HostedResources-3EA53DF9  Available         Available to participate in the cluster.
rack1compute02  cluster-1-HostedResources-3EA53DF9  Provisioned       The OS is provisioned to the machine. Warning: PXE port is unhealthy
rack1compute01  cluster-1-HostedResources-3EA53DF9  Provisioned       The OS is provisioned to the machine. Warning: BMM power state doesn't match expected state
```

For more information, use an Azure CLI Bare Metal Machine `run-read-command` command such as the following to inspect the `conditions` status of the corresponding kubernetes BMM object.

```azurecli
az networkcloud baremetalmachine run-read-command \
  -g <ResourceGroup_Name> \
  -n rack1control01 \
  --limit-time-seconds 60 \
  --commands "[{command:'kubectl get',arguments:[-n,nc-system,bmm,rack1compute01,-o,json]}]" \
  --output-directory .
```

- Replace `<ResourceGroup_Name>` with the name of the resource group containing the BMM resources.
- Replace `rack1control01` with the name of a BMM resource for a healthy Kubernetes control plane node, from which to execute the `kubectl get` command.
- Replace `rack1compute01` with the name of the affected BMM.

For more information about the `run-read-command` feature and available diagnostic commands, see [Troubleshoot Bare-Metal Machines by Using the run-read Command](./howto-baremetal-run-read.md).

Review the `lastTransitionTime` and `message` fields for more information about the corresponding error condition, as shown in the following example output.

**Example `run-read-command` output (`kubectl get bmm`):**

```json
{
  "status": {
    "conditions": [
       {
        "lastTransitionTime": "2026-06-20T17:24:47Z",
        "message": "No persistent disk I/O errors detected",
        "reason": "DiskIOHealthy",
        "status": "True",
        "type": "BmmDiskIOHealthy"
      },
      {
        "lastTransitionTime": "2026-06-20T17:24:47Z",
        "status": "True",
        "type": "BmmInExpectedNodeReadiness"
      },
      {
        "lastTransitionTime": "2026-06-20T17:24:47Z",
        "message": "BareMetalMachine expected to be powered on",
        "reason": "BmmPoweredOnExpected",
        "severity": "Error",
        "status": "False",
        "type": "BmmInExpectedPowerState"
      },
      {
        "lastTransitionTime": "2026-06-20T17:24:47Z",
        "message": "Node Problem Detector heartbeat is healthy",
        "reason": "Last NPD heartbeat is within the last 15 mins",
        "status": "True",
        "type": "BmmNpdHeartbeatHealthy"
      },
      {
        "lastTransitionTime": "2026-06-20T17:24:47Z",
        "message": "PXE network port (pxe) is up and stable",
        "reason": "PxePortsHealthy",
        "status": "True",
        "type": "BmmPxePortHealthy"
      }
    ],
    "detailedStatus": "Provisioned",
    "detailedStatusMessage": "The OS is provisioned to the machine. Warning: BMM power state doesn't match expected state"
  }
}
```

You can also check for any potentially related recent lifecycle actions (such as Restart or Power off actions) in the Azure portal. See [Monitor status in Bare Metal Machine JSON properties](./howto-bare-metal-best-practices.md#monitor-status-in-bare-metal-machine-json-properties). If available, this information is also visible in the output of the previous `run-read-command` in the `actionStates` status field.

## `Warning: PXE port is unhealthy`

This message in the BMM _Detailed status message_ field indicates a problem with network connectivity on the Preboot Execution Environment (PXE) Ethernet port on the underlying bare metal host.
The PXE port is used during provisioning and upgrades to download the operating system image and other software components.
PXE connectivity issues don't directly affect customer workloads running on a bare metal host.
However they can cause failures in BMM lifecycle operations such as the following.

- Cluster Provisioning
- Cluster Upgrade
- BMM Reimage
- BMM Replace

Either of the following conditions can trigger this _Warning_. These conditions can be due to hardware, cabling, or network configuration issues.

- PXE network port is down (physical link is down)
- PXE network port is flapping (more than two changes in physical link state in the previous 15 minutes)

To troubleshoot this issue:

- review the `conditions` status of the kubernetes `bmm` object, as described in the [Troubleshooting](#troubleshooting) section
- this information should identify the specific root cause (port down or port flapping) and approximate time of the issue
- check the Ethernet cabling and Top Of Rack (TOR) switch for the affected PXE port
- check for any other BMMs that are also reporting unhealthy PXE status or other network-related problems
- check for any recent deployment or infrastructure changes that coincide with the time of failure.

**Example `conditions` output for PXE warning**

```
"conditions": [
  {
    "lastTransitionTime": "2025-03-04T16:43:29Z",
    "message": "Physical link down on PXE interface: pxe",
    "reason": "PxePortUnhealthy",
    "status": "False",
    "type": "BmmPxePortHealthy"
  },
],
```

## `Warning: BMM power state doesn't match expected state`

This message in the BMM _Detailed status message_ field indicates that either:

- the underlying host is powered off when it should be on, or
- the underlying host is powered on when it should be off.

This message can indicate an issue with the underlying bare metal host or baseboard management controller (BMC).

To troubleshoot this issue:

- review the `conditions` status of the kubernetes `bmm` object, as described in the [Troubleshooting](#troubleshooting) section
- review the `actionStates` status field of the kubernetes `bmm` object for any recently initiated lifecycle actions (such as a Restart or Power off) as described in the [Troubleshooting](#troubleshooting) section
- this information should identify the approximate time of the issue and any other available details
- check the power feed, power cables, and physical hardware for the specified BMM
- check whether any other BMMs are also reporting an unexpected power state Warning, which might indicate a broader issue with the underlying infrastructure
- check for any recent deployment or infrastructure changes that coincide with the time of failure
- review the power state and logs on the BMC for the affected host.

For more information about logging into the BMC, see [Troubleshoot Hardware Validation Failure](./troubleshoot-hardware-validation-failure.md).

> [!WARNING]
> In versions 2502.1 and 2502.3, there's a known issue where `BMM power state doesn't match expected state` is incorrectly reported during deprovisioning and provisioning.
> For example, the issue can happen when running the BMM Reimage or Replace actions. This issue is fixed in version 2504.1.

**Example `conditions` output for unexpected power state**

```json
"conditions": [
    {
      "lastTransitionTime": "2025-03-04T15:59:36Z",
      "message": "BareMetalMachine expected to be powered on",
      "reason": "BmmPoweredOnExpected",
      "severity": "Error",
      "status": "False",
      "type": "BmmInExpectedPowerState"
    },
],
```

## `Warning: This machine has failed hardware validation`

This BMM _Detailed status message_ indicates that hardware validation for the BMM failed. Hardware validation typically occurs during initial cluster provisioning or during a BMM Replace action.

## `Warning: Disk I/O failures detected`

This message in the BMM _Detailed status message_ field indicates that Node Problem Detector reported disk input/output failures on the host.
This condition can indicate storage media issues, filesystem or kernel I/O errors, or intermittent device-path problems.

To troubleshoot this problem:

- Review the `conditions` status of the Kubernetes `bmm` object, as described in the [Troubleshooting](#troubleshooting) section.
- identify the `lastTransitionTime`, `reason`, and `message` values to determine when and why disk I/O failures were reported
- review host logs (for example, `dmesg`, kernel logs, and storage subsystem logs) for disk or block-device errors around the same time
- check if any tenant workload on this BMM has memory failures
- if errors persist, collect diagnostics and engage hardware/vendor support for deeper storage-path investigation

**Example `conditions` output for disk I/O warning**

```json
"conditions": [
  {
    "lastTransitionTime": "2026-06-19T09:12:45Z",
    "message": "Disk I/O errors detected in the last 15 min for device(s): sda",
    "reason": "DiskIOErrorDetected",
    "status": "False",
    "type": "BmmDiskIOHealthy"
  },
],
```

## `Warning: node problem detector heartbeat failures detected`

This message in the BMM _Detailed status message_ field indicates that Node Problem Detector heartbeat updates are stale (older than 15 minutes).
When heartbeat data is stale, health signals from Node Problem Detector might not represent the current host state. Any new tenant workload creation might fail on BMM, due to scheduling issues.

To troubleshoot this issue:

- Review the `conditions` status of the Kubernetes `bmm` object, as described in the [Troubleshooting](#troubleshooting) section.
- check the `BmmNpdHeartbeatHealthy` condition and confirm whether the heartbeat is reported as older than 15 minutes
- verify the node ready state of the BMM.
- verify the health and restart history of the Node Problem Detector components on the affected node
- check for transient control-plane, kubelet, or node resource pressure events that may have delayed condition updates
- after remediation, verify that heartbeat updates resume and the warning condition clears

**Example `conditions` output for stale NPD heartbeat warning**

```json
"conditions": [
  {
    "lastTransitionTime": "2026-06-19T09:12:45Z",
    "message": "Warning: health monitoring agent is not responding; problems on this machine may not be detected",
    "reason": "Last NPD heartbeat is older than 15 mins",
    "status": "False",
    "type": "BmmNpdHeartbeatHealthy"
  },
],
```

For more information about troubleshooting hardware validation failures, see [Troubleshoot Hardware Validation Failure](./troubleshoot-hardware-validation-failure.md).
