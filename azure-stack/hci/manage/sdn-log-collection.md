---
title: Collect Software Defined Networking logs on Azure Stack HCI
description: Learn how to collect logs to troubleshoot Software Defined Networking (SDN) in Azure Stack HCI.
ms.topic: how-to
ms.author: sethm
author: sethmanheim
ms.date: 06/07/2024
---

# Collect logs for Software Defined Networking on Azure Stack HCI

> Applies to: Azure Stack HCI, versions 23H2 and 22H2; Windows Server 2022, Windows Server 2019

This article describes how to collect logs for Software Defined Networking (SDN) on your Azure Stack HCI cluster.

The SDN logs help you identify and troubleshoot advanced issues in your SDN environment. Use these logs to gather key information before you contact Microsoft support.

Use SDN logs to also test a recently deployed SDN environment or retest an existing SDN deployment. In addition to log collection, you can run validation tests to get the state of your SDN environment and check for common configuration issues.

## Prerequisites

Before you begin, make sure that:

- The client computer that you use for log collection has access to the SDN environment. For example, a management computer running Windows Admin Center that can access SDN.

- The client computer is running PowerShell 5.1 or later.

- All the SDN resources within the SDN fabric run the same version of the `SdnDiagnostics` module.

- All the SDN resources within the SDN fabric are configured to run remote PowerShell. Run `Enable-PSRemoting` to configure remote PowerShell. For more information, see the [Enable-PSRemoting](/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-5.1&preserve-view=true) reference documentation.

## SDN log collection workflow

Here's a high-level workflow for SDN log collection:

- [Install the SDN diagnostics PowerShell module on the client computer](#install-the-sdn-diagnostics-powershell-module-on-the-client-computer)
- [Install the SDN diagnostics PowerShell module on the SDN resources within the SDN fabric](#install-the-sdn-diagnostics-powershell-module-on-the-sdn-resources)
- [Collect logs using SdnDiagnostics](#collect-sdn-logs-using-sdndiagnostics)

## Install the SDN diagnostics PowerShell module on the client computer

Use the `SdnDiagnostics` PowerShell module to simplify the data collection and diagnostics in your SDN environment. For more information about `SdnDiagnostics`, see the [SdnDiagnostics wiki page](https://github.com/microsoft/SdnDiagnostics/wiki).

Follow these steps to install the `SdnDiagnostics` PowerShell module on the client computer that has access to the SDN environment:

1. Run PowerShell as administrator (5.1 or later). If you need to install PowerShell, see [Installing PowerShell on Windows](/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2&preserve-view=true).

1. Update to the latest version of `PackageManagement`. To update, run the following cmdlet:

    ```powershell
    Update-Module -Name PackageManagement -Force
    ```

1. To install the `SdnDiagnostics` module, run the following cmdlet:

    ```powershell
    Install-Module -Name SdnDiagnostics
    ```

1. Alternatively, if you already have `SdnDiagnostics` installed, ensure you are running the latest version by running the following cmdlet:

    ```powershell
    Update-Module -Name SdnDiagnostics
    ```

1. To import the `SdnDiagnostics` module, run the following cmdlet:

    ```powershell
    Import-Module -Name SdnDiagnostics
    ```

1. To confirm the version of `SdnDiagnostics` module loaded into the runspace, run the following cmdlet:

    ```powershell
    Get-Module -Name SdnDiagmostics
    ```
    - If you have multiple versions loaded into the runspace, we recommend removing and then re-importing the module.

        ```powershell
        Remove-Module -Name SdnDiagnostics
        Import-Module -Name SdnDiagnostics
        ```

## Install the SDN diagnostics PowerShell module on the SDN resources

After you installed the `SdnDiagnostics` module on the client computer, install the `SdnDiagnostics` module on the SDN resources within the SDN fabric. This ensures that all the SDN resources run the same version of the `SdnDiagnostics` module.

Follow these steps in a new PowerShell window to install the `SdnDiagnostics` module on a Network Controller virtual machine (VM):

1. To get the environment details, run the following cmdlet:

    ```powershell
    Get-SdnInfrastructureInfo -NetworkController 'nc01.contoso.com'
    ```
    - The environment details will be stored into global variable that can be accessed at any time in the current PowerShell runpsace by accessing `Global:SdnDiagnostics`.
1. To install the `SdnDiagnostics` module on the SDN infrastructure nodes, run the following cmdlet:

    ```powershell
    Install-SDNDiagnostics -ComputerName $Global:SdnDiagnostics.EnvironmentInfo.FabricNodes
    ```

Here's a sample output of how to get environment details:

```output
PS C:\Users\AzureStackHCIUser> Get-SdnInfrastructureInfo -NetworkController 'nc01.contoso.com'

Name				Value
----				----

RestApiVersion		V4.1
FabricNodes			{nc01-pod06.tailwindtraders.com, nc02-pod06.tailwindtraders.com, nc03-pod06.tailwindt...
NcUrl				https ://SDN-POD06.TAILWINDTRADERS.COM
Server			    {CPPE-P06N01.tailwindtraders.com, CPPE-P06N02.tailwindtraders.com, CPPE-P06N03.tailwi...
Gateway			    {nc01-pod06.tailwindtraders.com, nc02-pod06.tailwindtraders.com, nc03-pod06.tailwindt...
LoadBalancerMux
NetworkController

```

## Collect SDN logs using SdnDiagnostics

After you installed the `SdnDiagnostics` module on the management computer and the SDN resources within the SDN fabric, you're ready to run `Start-SdnDataCollection` to collect SDN logs.

### Before you run Start-SdnDataCollection

A few things to consider before you run the `Start-SdnDataCollection` cmdlet:

- The `Start-SdnDataCollection` takes some time to complete based on which roles the logs are collecting, time duration specified, and the number of SDN fabric servers in your Azure Stack HCI environment.

- If you don't specify the `FromDate` parameter, logs are collected for the past four hours by default.

- The `Start-SdnDataCollection` cmdlet collects configuration state and logs for the specified SDN role. The accepted values are: Gateway, NetworkController, Server, SoftwareLoadBalancer. You can specify roles that are installed in your SDN environment or the roles that aren't working as expected.

- If you don't specify any credentials, the `Start-SdnDataCollection` cmdlet uses the credentials of the current user by default.

### Run Start-SdnDataCollection

Use the `Start-SdnDataCollection` cmdlet to collect information about the current configuration state and diagnostic logs for SDN.

Here's the syntax of the `Start-SdnDataCollection` cmdlet:

```powershell
Start-SdnDataCollection [-NetworkController <String>] [-NcUri <Uri>] -Role <SdnRoles[]> [-OutputDirectory <FileInfo>] [-IncludeNetView] [-IncludeLogs] [-FromDate <DateTime>] [-ToDate <DateTime>] [-Credential <PSCredential>] [-NcRestCredential <PSCredential>] [-Limit <Int32>] [-ConvertETW <Boolean>] [<CommonParameters>]
```

For more information about the parameters and specifications, see the [Start-SdnDataCollection](https://github.com/microsoft/SdnDiagnostics/wiki/Start-SdnDataCollection) wiki page.

## Collect logs from large SDN clusters
Some SDN clusters can be exceptionally large with the number of nodes for each role. In these scenarios, `Start-SdnDataCollection` will limit how much data to collect which is enforced by the `-Limit` parameter. This parameter is optional and currently defaults to 16, meaning that the data collection will be limited to the first 16 nodes per role. This is designed to prevent excessive amounts of data being collected.

You can update the `-Limit` parameter, however there is no control on which node(s) will be selected as it will typically pick the first ones in the array alphabetically.

### Target specific nodes for data collection

To be more specific about which nodes the data is collected for, you can instead define the `-ComputerName` parameter which is a string array. The `SdnDiagnostics` module will automatically perform the mapping to identify the appropriate roles for each, and then process as normal.

```powershell
# this command is being executed on a Network Controller node directly
Get-SdnInfrastructureInfo
$computers = @()
$computers += $Global:SdnDiagnostics.EnvironmentInfo.NetworkController # will add all the network controllers
$computers += 'Host01','Host02' # will add specific computers

Start-SdnDataCollection -ComputerName $computers -IncludeLogs -FromDate (Get-Date).AddHours(-2)
```

## Next steps

- [Contact Microsoft Support](get-support.md)
