---
title: Support.AksArc diagnostic and remediation tool
description: Learn how to run commands in the Support.AksArc PowerShell module to diagnose and remediate issues in AKS Arc environments.
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 07/22/2025
ms.reviewer: sumsmith
ms.lastreviewed: 07/22/2025

---

# Support.AksArc module

The [**Support.AksArc**](https://www.powershellgallery.com/packages/Support.AksArc) PowerShell module provides diagnostic and remediation capabilities for AKS Arc environments. Before you open a support request, you can run the specified commands in this module to help diagnose and potentially resolve issues.

You should run the commands if you experience any of the following symptoms:

- Solution upgrade fails in MOC binaries state.
- Solution upgrade fails in Arc Resource Bridge stage.
- MOC service doesn't stay online.
- Arc Resource Bridge is offline.

## Commands

The **Support.AksArc** module contains the following PowerShell commands:

- `Test-SupportAksArcKnownIssues`: tests for known issues.
- `Invoke-SupportAksArcRemediation`: fixes identified issues.

## Installation

To install the module, run the following commands:

```powershell
Install-Module -Name Support.AksArc
Import-Module Support.AksArc
```

## Usage

> [!NOTE]
> Make sure to run these PowerShell commands locally, not in a PowerShell remote session.

The following command performs a health check:

```powershell
Test-SupportAksArcKnownIssues
```

This command performs auto-remediation (tests and fixes all issues):

```powershell
Invoke-SupportAksArcRemediation
```

## Example output

The following example output from the `Test-SupportAksArcKnownIssues` command shows the results of a failed test:

```output
Test Name                                                  Status Message
---------                                                  --------------
Validate Failover Cluster Service Responsiveness           Passed Failover Cluster service is responsive.
Validate Missing MOC Cloud Agents                          Passed No missing MOC cloud agents found.
Validate MOC Cloud Agent Running                           Passed MOC Cloud Agent is running
Validate Missing MOC Node Agents                           Passed All MOC nodes have the Node Agent service installed and healthy.
Validate Missing MOC Host Agents                           Passed All nodes have MOC host agents installed and healthy
Validate MOC is on Latest Patch Version                    Failed MOC is not on the latest patch version. Current: 1.15.5.10626, Latest: 1.15.7.10719
Validate Expired Certificates                              Passed No expired certificates found
Validate MOC Nodes Not Active                              Passed All MOC nodes are in the 'Active' state
Validate Multiple MOC Cloud Agent Instances                Passed No multiple instances of MOC Cloud Agent found
Validate Windows Event Log Running                         Passed Windows Event Log is running
Validate Gallery Image Stuck In Deleting                   Passed No gallery images are stuck in deleting state
Validate Virtual Machine Stuck In Pending                  Passed No virtual machines are stuck in pending state
Validate Virtual Machine Management Service Responsiveness Passed Virtual Machine Management service is responsive
```

The following example output shows a successful result for all tests:

```output
Test Name                                                  Status Message
---------                                                  --------------
Validate Failover Cluster Service Responsiveness           Passed  Failover Cluster service is responsive.
Validate Missing MOC Cloud Agents                          Passed  No missing MOC cloud agents found.
Validate MOC Cloud Agent Running                           Passed  MOC Cloud Agent is running
Validate Missing MOC Node Agents                           Passed  All MOC nodes have the Node Agent service installed and healthy.
Validate Missing MOC Host Agents                           Passed  All nodes have MOC host agents installed and healthy.
Validate MOC is on Latest Patch Version                    Passed  MOC is on the latest patch version.
Validate Expired Certificates                              Passed  No expired certificates found.
Validate MOC Nodes Not Active                              Passed  All NMC nodes are in the 'Active' state.
Validate NMC Nodes Sync with Cluster Nodes                 Passed  All NMC nodes are in sync with cluster nodes.
Validate Multiple NMC Cloud Agent Instances                Passed  No multiple instances of NMC Cloud Agent found.
Validate NMC Powershell Not Stuck in Updating              Passed  NMC Powershell is not stuck in updating state.
Validate Windows Event Log Running                         Passed  Windows Event Log is running
Validate Gallery Image Stuck In Deleting                   Passed  No gallery images are stuck in deleting state.
Validate Virtual Machine Stuck In Pending                  Passed  No virtual machines are stuck in pending state.
Validate Virtual Machine Management Service Responsiveness Passed  Virtual Machine Management service is responsive.
```

## Next steps

[Use the diagnostic checker tool to identify common environment issues](aks-arc-diagnostic-checker.md)
