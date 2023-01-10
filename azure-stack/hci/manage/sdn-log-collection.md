---
title: Collect logs for Software Defined Networking
description: Learn how to collect logs to troubleshoot Software Defined Networking (SDN) in Azure Stack HCI.
ms.topic: article
ms.author: v-mandhiman
author: ManikaDhiman
ms.date: 01/04/2023
---

# Collect logs for Software Defined Networking

[!INCLUDE [hci-applies-to-22h2-21h2-20h2](../../includes/hci-applies-to-22h2-21h2-20h2.md)]

This article describes how to collect logs for Software Defined Networking (SDN) in Azure Stack HCI.

The SDN logs can help you gather key information to identify and troubleshoot issues before contacting Microsoft support. You can also use these logs to test a recently deployed SDN environment or retest an existing SDN deployment. In addition to log collection, you can also execute a series of validation tests to gain a current goal state of your SDN environment and check for common misconfigured issues.

## Prerequisites

Before you begin, make sure that:

- The client computer that you use for log collection has access to the SDN environment. For example, a management computer running Windows Admin Center that can access SDN.
- The client computer is running PowerShell 5.1 or later.
- All the servers within the SDN fabric run the same version of the `SdnDiagnostics` module.
- All the servers within the SDN fabric are enabled with PSRemoting. You can run `Enable-PSRemoting` to enable PSRemoting. For more information about how to enable PSRemoting, see the [Enable-PSRemoting](/powershell/module/microsoft.powershell.core/enable-psremoting?view=powershell-5.1&preserve-view=true) reference documentation.

## SDN log collection workflow

Here's a high-level workflow for SDN log collection:

- [Install the SDN diagnostics PowerShell module on the client computer](#install-the-sdn-diagnostics-powershell-module-on-the-client-computer)
- [Install the SDN diagnostics PowerShell module on the SDN resources within the SDN fabric](#install-the-sdn-diagnostics-powershell-module-on-the-sdn-resources-within-the-sdn-fabric)
- [Collect logs using SdnDiagnostics](#collect-sdn-logs-using-sdndiagnostics)

## Install the SDN diagnostics PowerShell module on the client computer

`SdnDiagnostics` is a PowerShell module used to simplify the data collection and diagnostics of SDN. For more information about `SdnDiagnostics`, see the [SdnDiagnostics wiki page](https://github.com/microsoft/SdnDiagnostics/wiki).

Follow these steps to install the `SdnDiagnostics` PowerShell module on the client computer that has access to the SDN environment:

1. Run PowerShell as administrator (5.1 or later). If you need to install PowerShell, see [Installing PowerShell on Windows](/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2&preserve-view=true).

1. Enter the following cmdlet to install the latest version of the `PackageManagement` module:

    ```powershell
    Install-Module -name PackageManagement -Force
    ```

1. After the installation completes, close the PowerShell window and open a new PowerShell session as administrator. Enter the following cmdlet to reload the latest version of the `PackageManagement` module:

    ```powershell
    Update-Module -Name PackageManagement -Force
    ```

1. Enter the following cmdlet to install the `SdnDiagnostics` module:

    ```powershell
    Install-Module SdnDiagnostics
    ```

1. Enter the following cmdlet to import the `SdnDiagnostics` module:

    ```powershell
    Import-Module SdnDiagnostics
    ```

## Install the SDN diagnostics PowerShell module on the SDN resources within the SDN fabric

After you've installed the `SdnDiagnostics` module on the client computer, install the `SdnDiagnostics` module on the appropriate servers within the SDN fabric. This ensures that all the servers run the same version of the `SdnDiagnostics` module.

Follow these steps in a new PowerShell window to install the `SdnDiagnostics` module on a Network Controller virtual machine (VM):

1. Set the variable for the Network Controller VM name:

    ```powershell
    $NCVMName = ‘example: nc01.contoso.com’
    ```

1. Run the following cmdlet to import the `SdnDiagnostics` module to the current session:

    ```powershell
    Import-Module -Name SdnDiagnostics -Force
    ```

1. Set the variable for environment details:

    ```powershell
    $EnvironmentDetails = Get-SdnInfrastructureInfo -NetworkController $NCVMName -Credential (get-credential)
    ```

1. Run the following cmdlet to install the `SdnDiagnostics` module on the Network Controller VM:

    ```powershell
    Install-SDNDiagnostics -ComputerName $EnvironmentDetails.FabricNodes -Credential (Get-Credential)
    ```

## Collect SDN logs using SdnDiagnostics

After you've installed the `SdnDiagnostics` module on the management computer and the SDN resources with the SDN fabric, you're ready to run `Start-SdnDiagnostics` to collect SDN logs.

Use the `Start-SdnDiagnostics` cmdlet to collect information about the current configuration state and diagnostic logs for SDN.

Here's the syntax of the `Start-SdnDiagnostics` cmdlet:

```powershell
Start-SdnDataCollection [-NetworkController <String>] [-NcUri <Uri>] -Role <SdnRoles[]> [-OutputDirectory <FileInfo>] [-IncludeNetView] [-IncludeLogs] [-FromDate <DateTime>] [-Credential <PSCredential>] [-NcRestCredential <PSCredential>] [-Limit <Int32>] [-ConvertETW <Boolean>] [<CommonParameters>]
```

For more information about the parameters and specifications, see the [Start SdnDataCollection](https://github.com/microsoft/SdnDiagnostics/wiki/Start-SdnDataCollection) wiki page.

A few things to consider before you run the `Start-SdnDiagnostics` cmdlet:
 
- The `Start-SdnDiagnostics` takes some time to complete based on which roles the logs are collecting, time duration specified, and the number of SDN fabric servers in your Azure Stack HCI environment.

- If you don't specify the `FromDate` parameter, logs are collected for the past four hours by default.

- The `Start-SdnDiagnostics` cmdlet collects configuration state and logs for the specified SDN role. The accepted values are: Gateway, NetworkController, Server, SoftwareLoadBalancer. You can specify roles that are installed in your SDN environment or the roles that aren't working as expected.

- If you don't specify any credentials, the `Start-SdnDiagnostics` cmdlet uses the credentials of the current user by default.

### Example of the `Start-SdnDiagnostics` cmdlet usage

In this example, you run the `Start-SdnDiagnostics` cmdlet from a Network Controller VM to collect logs from the deployed SDN components:

1. Set the variable for one of the Network Controller VMs:

    ```powershell
    $NCVMName = ‘example: nc01.contoso.com’
    ```

1. Run the following cmdlet to collect logs from Network Controller, Software Load Balancers, Gateways, and the servers running Azure Stack HCI:

    ```powershell
    Start-SdnDataCollection -NetworkController $NCVMName -Credential (Get-Credential) -Role Gateway,NetworkController,Server,SoftwareLoadBalancer -IncludeLogs -IncludeNetView
    ```

## Next steps

- [Contact Microsoft Support](get-support.md)