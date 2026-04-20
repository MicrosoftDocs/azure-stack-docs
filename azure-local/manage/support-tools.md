---
title: Support Tool for Azure Local Hyperconverged Deployments
description: This article provides guidance on the Support Diagnostic Tool for Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 04/05/2026
ms.subservice: hyperconverged
---

# Use the Support Diagnostic Tool to troubleshoot Azure Local issues

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article provides information to download and use the Azure Local Support Diagnostic Tool. The tool is a set of PowerShell commands to simplify data collection, troubleshooting, and resolution of common issues.

This tool isn't a substitute for expert knowledge. If you encounter any issues, contact Microsoft Support for assistance.

## Benefits

The Azure Local Support Diagnostic Tool uses simple commands to identify issues without expert product knowledge.

The tool provides:

- **Easy installation and updates**: Install and update natively using PowerShell Gallery, without extra requirements.

- **Diagnostic checks**: Provides diagnostic checks based on common issues, incidents, and telemetry data.

- **Automatic data collection**: Automatically collects important data to provide to Microsoft Support.

- **Regular updates**: Updates with new checks and useful commands to manage, troubleshoot, and diagnose issues on Azure Local.

## Prerequisites

Before you use the PowerShell module:

- Make sure to use an account that has administrative access to the Azure Local machines.

- Ensure that PSRemoting is configured on the Azure Local machines. Run `Enable-PSRemoting` to configure remote PowerShell. For more information, see the [Enable-PSRemoting](/powershell/module/microsoft.powershell.core/enable-psremoting) reference documentation.

## Install or update the Azure Local Support Diagnostic Tool

Run PowerShell as an administrator and then run the following commands:

To install the tool, run the following command:

```powershell
Install-Module -Name Microsoft.AzLocal.CSSTools
```

If you already have the module installed, you can update using the following cmdlet:

```powershell
Update-Module -Name Microsoft.AzLocal.CSSTools
```

>[!NOTE]
>When you import the module, it attempts to automatically update from PowerShell gallery. You can also update manually using the following methods.

Ensure that you have the latest module loaded into the current runspace by removing and importing the module.

```powershell
Remove-Module -Name Microsoft.AzLocal.CSSTools
Import-Module -Name Microsoft.AzLocal.CSSTools
```

>[!NOTE]
>Ensure all machines within Azure Local are updated to use the same version. Remove existing PSSessions to ensure the correct module version is loaded into the remote runspace.

## Use the Azure Local Support Diagnostic Tool

This section provides different cmdlets for using the Azure Local Support Diagnostic Tool.

### View available cmdlets

To see a list of available cmdlets within the PowerShell module, run the following cmdlet:

```powershell
Get-Command -Module Microsoft.AzLocal.CSSTools
```

## Perform diagnostic checks

You can perform a diagnostic check of your environment to check for common known issues. This test can be executed on a per node basis, or across the entire cluster. Once completed, it will provide a summary and location which contains a data bundle along with HTML files for viewing of the test results. Ensure you have the same version of CSSTools on each of the nodes.

```powershell
Invoke-AzsSupportInsight -ComputerName (Get-ClusterNode).Name
```

You can also toggle which components you want to check by leveraging the `-Component` field and enumerating which components are available.

```output
================================================================================
 Azure Local Insights Summary                                                                                                                  ================================================================================
Time    : 2025-10-23 20:41:05
Report  : C:\Temp\Azs.Support\20251023160853\InsightReport                                                                                                              ================================================================================                                                                                                                                      Summary:
Nodes           : {PREFIX}-N03, {PREFIX}-N04, {PREFIX}-N02, {PREFIX}-N01
Total Analyzers : 104 (Success: 103 | Warning: 1 | Failure: 0)
Total Rules     : 266 (Success: 260 | Warning: 2 | Failure: 0)                                                                                                                                                        ================================================================================

Node: {PREFIX}-N03
  Azure Local Services: [SUCCESS]  2 | [WARNING]  0 | [FAILURE]  0
  Host Compute:         [SUCCESS]  2 | [WARNING]  0 | [FAILURE]  0
  Host Network:         [SUCCESS]  4 | [WARNING]  0 | [FAILURE]  0
  Host Storage:         [SUCCESS] 16 | [WARNING]  0 | [FAILURE]  0
  Operating System:     [SUCCESS]  1 | [WARNING]  0 | [FAILURE]  0
  Support.AksArc:       [SUCCESS]  1 | [WARNING]  0 | [FAILURE]  0

Node: {PREFIX}-N04
  Azure Local Services: [SUCCESS]  2 | [WARNING]  0 | [FAILURE]  0
  Host Compute:         [SUCCESS]  2 | [WARNING]  0 | [FAILURE]  0
  Host Network:         [SUCCESS]  4 | [WARNING]  0 | [FAILURE]  0
  Host Storage:         [SUCCESS] 16 | [WARNING]  0 | [FAILURE]  0
  Operating System:     [SUCCESS]  1 | [WARNING]  0 | [FAILURE]  0
  Support.AksArc:       [SUCCESS]  1 | [WARNING]  0 | [FAILURE]  0

Node: {PREFIX}-N02
  Azure Local Services: [SUCCESS]  2 | [WARNING]  0 | [FAILURE]  0
  Host Compute:         [SUCCESS]  2 | [WARNING]  0 | [FAILURE]  0
  Host Network:         [SUCCESS]  4 | [WARNING]  0 | [FAILURE]  0
  Host Storage:         [SUCCESS] 15 | [WARNING]  1 | [FAILURE]  0
  Operating System:     [SUCCESS]  1 | [WARNING]  0 | [FAILURE]  0
  Support.AksArc:       [SUCCESS]  1 | [WARNING]  0 | [FAILURE]  0

Node: {PREFIX}-N01
  Azure Local Services: [SUCCESS]  2 | [WARNING]  0 | [FAILURE]  0
  Host Compute:         [SUCCESS]  2 | [WARNING]  0 | [FAILURE]  0
  Host Network:         [SUCCESS]  4 | [WARNING]  0 | [FAILURE]  0
  Host Storage:         [SUCCESS] 16 | [WARNING]  0 | [FAILURE]  0
  Operating System:     [SUCCESS]  1 | [WARNING]  0 | [FAILURE]  0
  Support.AksArc:       [SUCCESS]  1 | [WARNING]  0 | [FAILURE]  0
================================================================================

For detailed analysis, view the HTML report at:
  C:\Temp\Azs.Support\20251023160853\InsightReport
```


## Collect data for support

- To collect data using one of our predefined collection sets, run the following command:

    ```powershell
    New-AzsSupportDataBundle –Component <Component>
    ```

- To check all data collection sets, press `CTRL+SPACE` after the parameter `Component`.

- To collect your own dataset, run the following command:

    ```powershell
    $ClusterCommands = @(<clusterCommand1>,<clusterCommand2>)
    $nodeCommands = @(<nodeCommand1>,<nodeCommand2>)
    $nodeEvents = @(<eventLogName1>,<eventLogName2>)
    $nodeRegistry = @(<registryPath1>,<registryPath2>)
    $nodeFolders = @(<folderPath1>,<folderPath2>)


    New-AzsSupportDataBundle -ClusterCommands $clusterCommands `
    -NodeCommands $nodeCommands `
    -NodeEvents $nodeEvents `
    -NodeRegistry $nodeRegistry `
    -NodeFolders $nodeFolders `
    -ComputerName @(<computerName1>,<computerName2>)
    ```

## Questions or feedback?

Do you have an issue? Would you like to share feedback with us about the Azure Local Support Diagnostic Tool?
To submit feedback, contact [azlocaldiagfeedback@microsoft.com](mailto:azlocaldiagfeedback@microsoft.com).

Release notes: [AzureLocal-Supportability-GH](https://github.com/Azure/AzureLocal-Supportability/tree/main/TSG/CSSTools/ReleaseNotes)

## Next steps

For related information, see also:

- [Get support for Azure Local](get-support.md).
