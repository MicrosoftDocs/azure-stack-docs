---
title: Remediation Support Tool for Azure Local infrastructure component issues
description: Learn how to run commands in the Support.AksArc PowerShell module to remediate issues in Azure Local infrastructure components.
ms.topic: troubleshooting
author: alkohli 
ms.author: alkohli 
ms.date: 01/07/2026
---

# Use the Support tool to troubleshoot and fix Azure Local infrastructure problems

The [**Support tool**](https://www.powershellgallery.com/packages/Support.AksArc) (also known as AKS Arc Support Tool) is a PowerShell module that provides diagnostic and remediation capabilities for the infrastructure components used by Azure Local VMs and Azure Kubernetes Service (AKS) enabled by Azure Arc on Azure Local.

Before you open a support request, run the specified commands in this module to help diagnose and potentially resolve problems.

## Benefits of using the Support tool

The Support tool uses simple commands to identify problems without expert product knowledge. The tool provides:

- **Fixes for solution update problems**: Identifies and attempts to fix common problems that occur during the solution update.
- **Diagnostic checks**: Provides diagnostic health checks based on common problems, incidents, and telemetry data.

## Common problems where the Support tool might help

Run the commands if you experience any of the following symptoms:

- Solution update fails in Microsoft On Cloud (MOC) binaries state.
- Solution update fails in Arc resource bridge stage.
- MOC service doesn't stay online.
- Arc resource bridge is offline.

## Prerequisites

Before you begin, make sure that:

- You have access to an Azure Local instance that runs 2311.2 or later.
- You have access to a client that can connect to your Azure Local.

## Connect to your Azure Local instance

Follow these steps on your client to connect to one of the machines in your Azure Local instance.

1. Run PowerShell as an administrator on the client that you use to connect to your system.
1. Open a remote PowerShell session to a machine on your Azure Local instance. Run the following command and provide the credentials for your machine when prompted:

   ```powershell
   $cred = Get-Credential
   $ip = "<IP address of the Azure Local machine>"
   Enter-PSSession -ComputerName $ip -Credential $cred 
   ```

   > [!NOTE]
   > Sign in by using your deployment account credentials. This account is created when you prepare [Active Directory](/azure/azure-local/deploy/deployment-prep-active-directory) and use it to deploy Azure Local.


   <details>
   <summary>Expand this section to see an example output.</summary>


   Here's an example output:

   ```Console
   PS C:\Users\Administrator> $cred = Get-Credential
   PS C:\Users\Administrator> $ip = "100.100.100.10"
   cmdlet Get-Credential at command pipeline position 1
   Supply values for the following parameters:
   Credential
   PS C:\Users\Administrator> Enter-PSSession -ComputerName $ip -Credential $cred 
   [100.100.100.10]: PS C:\Users\Administrator\Documents>
   ```

   </details>

## Install the Support tool module

To install the Support tool module, run the following commands:

```powershell
Install-Module -Name Support.AksArc
Import-Module Support.AksArc -force
```

If you already have the module installed, update it by using the following cmdlet:

```powershell
Update-Module -Name Support.AksArc
```

>[!NOTE]
> When you import the module, it tries to automatically update from the PowerShell gallery. You can also update manually by using the following methods.

Make sure you have the latest module in the current instance by removing and importing the module:

```powershell
Remove-Module -Name Support.AksArc
Import-Module -Name Support.AksArc
```

## Use the Support tool

This section provides examples of the different cmdlets available in the Support tool.

> [!NOTE]
> Run these PowerShell commands locally, not in a PowerShell remote session.

### View available cmdlets

To see a list of available cmdlets in the PowerShell module, run the following cmdlet:

```powershell
Get-Command -Module Support.AksArc
```

### Perform diagnostic checks

You can run a diagnostic health check against the system to help detect common problems:

```powershell
Test-SupportAksArcKnownIssues
```

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

### Fix common problems

This command tests and fixes known problems with a given solution version:

```powershell
Invoke-SupportAksArcRemediation
```

## Related steps

- [Use the Diagnostic Support tool](./support-tools.md).
