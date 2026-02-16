---
title: Troubleshoot Azure Operator Nexus resource health alerts
titleSuffix: Azure Operator Nexus
description: Find troubleshooting guides for platform-emitted resource health alerts.
ms.service: azure-operator-nexus
ms.custom: troubleshooting
ms.topic: troubleshooting
ms.date: 02/16/2026
author: RaghvendraMandawale
ms.author: rmandawale
---

# Troubleshoot resource health alerts

This guide provides a breakdown of the resource health alerts emitted by the Azure Operator Nexus platform.
It includes a description of each alert and links to troubleshooting guides for each alert.

Resource health alerts emitted by the platform to indicate the health of a particular resource.
These alerts are generated based on the status of the resource and its dependencies.

## Cluster

| Resource Health Event Name                                                                                                                                                      | Troubleshooting Guide                                                 |
| ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------- |
| `1PExtensionsFailedInstall`                                                                                                                                                     | [Requires to contact support](#please-contact-support)                |
| `ClusterHeartbeatConnectionStatusDisconnectedClusterManagerOperationsAreAffectedPossibleNetworkIssues`, and `ClusterHeartbeatConnectionStatusTimedoutPossiblePerformanceIssues` | [Troubleshoot Cluster heartbeat connection status shows disconnected] |
| `AttachmentFailuresDegraded`, and `AttachmentFailuresUnhealthy`                                                                                                                 | [Troubleshoot failed volume attachments]                              |
| `NFSPodDegraded`, and `NFSPodUnhealthy`                                                                                                                                         | [Troubleshoot NFS unhealthy]                                          |
| `CSIControllerUnhealthy`, `CSINodeDegraded`, and `CSINodeUnhealthy`                                                                                                             | [Troubleshoot unhealthy CSI (storage)]                                |
| `ControlPlaneStorageConnectivityDegraded`, and `ControlPlaneStorageConnectivityUnhealthyVIP`                                                                                    | [Troubleshoot storage control plane disconnected]                     |

[Troubleshoot Cluster heartbeat connection status shows disconnected]: ./troubleshoot-cluster-heartbeat-connection-status-disconnected.md
[Troubleshoot failed volume attachments]: ./troubleshoot-failed-volume-attachments.md
[Troubleshoot NFS unhealthy]: ./troubleshoot-network-file-system-unhealthy.md
[Troubleshoot unhealthy CSI (storage)]: ./troubleshoot-unhealthy-container-storage-interface.md
[Troubleshoot storage control plane disconnected]: ./troubleshoot-storage-control-plane-disconnected.md


## Network Device

| **Signal Category** | **Metric / Event Name (as defined)** | **What It Represents** | **Reference / Sub Page** |
| --- | --- | --- | --- |
| **CPU or Memory** | HighCpuUtilizationAvg, UnhealthyCpuUtilizationAvg, LowCpuUtilizationAvg, HighMemoryUtilization, LowMemoryUtilization | Sustained high CPU utilization, CPU utilization beyond unhealthy threshold, CPU utilization at or near zero, High memory consumption, Memory utilization at or near zero | [Troubleshoot CPU and Memory Guide]: ./troubleshoot-cpu-and-memory-guide.md |
| **Temperature** | HighDeviceTemperature, LowDeviceTemperature, UnhealthyDeviceHighTemperature | Device temperature above normal range, Device temperature below normal range, Critically high device temperature | [Troubleshoot Temperature Guide]: ./troubleshoot-temperature-guide.md |
| **Power Supply – Input or Output Voltage** | AnyHighPowerSupplyInputVoltage, AnyLowPowerSupplyInputVoltage, AllHighPowerSupplyInputVoltage, AllLowPowerSupplyInputVoltage, AnyHighPowerSupplyOutputVoltage, AnyLowPowerSupplyOutputVoltage, AllHighPowerSupplyOutputVoltage, AllLowPowerSupplyOutputVoltage | At least one PSU input voltage too high, At least one PSU input voltage too low, All PSU input voltages too high, All PSU input voltages too low, At least one PSU output voltage too high, At least one PSU output voltage too low, All PSU output voltages too high, All PSU output voltages too low | [Troubleshoot Power Supply Voltage Guide]: ./troubleshoot-power-supply-voltage-guide.md |
| **Packets (Drops), Interface Discards, Interface Errors, Ethernet / L2 Errors, LACP Errors** | PositiveDroppedPacketsRate, PositiveInterfaceInDiscardsRate, HighInterfaceInDiscardsRate, PositiveInterfaceOutDiscardsRate, HighInterfaceOutDiscardsRate, PositiveInterfaceInErrorsRate, PositiveInterfaceOutErrorsRate, PositiveEthInCrcErrorsRate, PositiveLacpErrorsRate | Packets dropped due to forwarding/buffer conditions, Ingress interface discards, High ingress discard rate, Egress interface discards, High egress discard rate, Errors on ingress interface, Errors on egress interface, CRC errors on received Ethernet frames, LACP protocol or aggregation errors | [Troubleshoot Packet Drops and Discards Guide]: ./troubleshoot-packet-drops-and-discards-guide.md |

## Please contact support

For some resource health alerts, troubleshooting guides are not available.
If you encounter these alerts, it is recommended to [contact Azure support] for further assistance.

[contact Azure support]: https://portal.azure.com/?#blade/Microsoft_Azure_Support/HelpAndSupportBlade

[!include[stillHavingIssues](./includes/contact-support.md)]
