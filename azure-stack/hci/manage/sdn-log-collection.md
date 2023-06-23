---
title: Collect Software Defined Networking logs on Azure Stack HCI
description: Learn how to collect logs to troubleshoot Software Defined Networking (SDN) in Azure Stack HCI.
ms.topic: how-to
ms.author: sethm
author: sethmanheim
ms.date: 04/24/2023
---

# Collect logs for Software Defined Networking on Azure Stack HCI

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019

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

1. To install the latest version of the `PackageManagement` module, run the following cmdlet:

    ```powershell
    Install-Module -name PackageManagement -Force
    ```

1. After the installation completes, close the PowerShell window and open a new PowerShell session as administrator. 

1. To reload the latest version of the `PackageManagement` module, run the following cmdlet:

    ```powershell
    Update-Module -Name PackageManagement -Force
    ```

1. To install the `SdnDiagnostics` module, run the following cmdlet:

    ```powershell
    Install-Module SdnDiagnostics
    ```

1. To import the `SdnDiagnostics` module, run the following cmdlet:

    ```powershell
    Import-Module SdnDiagnostics
    ```

## Install the SDN diagnostics PowerShell module on the SDN resources

After you've installed the `SdnDiagnostics` module on the client computer, install the `SdnDiagnostics` module on the SDN resources within the SDN fabric. This ensures that all the SDN resources run the same version of the `SdnDiagnostics` module.

Follow these steps in a new PowerShell window to install the `SdnDiagnostics` module on a Network Controller virtual machine (VM):

1. To set the variable for the Network Controller VM name, run the following cmdlet:

    ```powershell
    $NCVMName = ‘example: nc01.contoso.com’
    ```

1. To import the `SdnDiagnostics` module into the current session, run the following cmdlet:

    ```powershell
    Import-Module -Name SdnDiagnostics -Force
    ```

1. To set the variable for environment details, run the following cmdlet:

    ```powershell
    $EnvironmentDetails = Get-SdnInfrastructureInfo -NetworkController $NCVMName -Credential (get-credential)
    ```

1. To install the `SdnDiagnostics` module on the Network Controller VM, run the following cmdlet:

    ```powershell
    Install-SDNDiagnostics -ComputerName $EnvironmentDetails.FabricNodes -Credential (Get-Credential)
    ```

Here's a sample output of how to get environment details:

```output
PS C:\Users\AzureStackHCIUser> $NCVMName = 'nc01-pod06.tailwindtraders.com'
PS C:\Users\AzureStackHCIUser> $NCVMName
nc01-pod06.tailwindtraders.com
PS C:\Users\AzureStackHCIUser> Import-Module -Name SdnDiagnostics -Force
PS C:\Users\AzureStackHCIUser> $EnvironmentDetails = Get-Sdnlnfrastructurelnfo -NetworkController $NCVMName -Credential (get-credential)

cmdlet Get-Credential at command pipeline position 1 
Supply values for the following parameters:
Credential

PS C:\Users\AzureStackHCIUser> $EnvironmentDetails

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

After you've installed the `SdnDiagnostics` module on the management computer and the SDN resources within the SDN fabric, you're ready to run `Start-SdnDataCollection` to collect SDN logs.

### Before you run Start-SdnDataCollection

A few things to consider before you run the `Start-SdnDataCollection` cmdlet:
 
- The `Start-SdnDataCollection` takes some time to complete based on which roles the logs are collecting, time duration specified, and the number of SDN fabric servers in your Azure Stack HCI environment.

- If you don't specify the `FromDate` parameter, logs are collected for the past four hours by default.

- The `Start-SdnDataCollection` cmdlet collects configuration state and logs for the specified SDN role. The accepted values are: Gateway, NetworkController, Server, LoadBalancerMux. You can specify roles that are installed in your SDN environment or the roles that aren't working as expected.

- If you don't specify any credentials, the `Start-SdnDataCollection` cmdlet uses the credentials of the current user by default.

### Run Start-SdnDataCollection

Use the `Start-SdnDataCollection` cmdlet to collect information about the current configuration state and diagnostic logs for SDN.

Here's the syntax of the `Start-SdnDataCollection` cmdlet:

```powershell
Start-SdnDataCollection [-NetworkController <String>] [-NcUri <Uri>] -Role <SdnRoles[]> [-OutputDirectory <FileInfo>] [-IncludeNetView] [-IncludeLogs] [-FromDate <DateTime>] [-Credential <PSCredential>] [-NcRestCredential <PSCredential>] [-Limit <Int32>] [-ConvertETW <Boolean>] [<CommonParameters>]
```

For more information about the parameters and specifications, see the [Start-SdnDataCollection](https://github.com/microsoft/SdnDiagnostics/wiki/Start-SdnDataCollection) wiki page.

### Example of the `Start-SdnDataCollection` cmdlet usage

In this example, you run the `Start-SdnDataCollection` cmdlet from a Network Controller VM to collect logs from the deployed SDN components:

1. Set the variable for one of the Network Controller VMs:

    ```powershell
    $NCVMName = ‘example: nc01.contoso.com’
    ```

1. Run the following cmdlet to collect logs from Network Controller, Software Load Balancers, Gateways, and the servers running Azure Stack HCI:

    ```powershell
    Start-SdnDataCollection -NetworkController $NCVMName -Credential (Get-Credential) -Role Gateway,NetworkController,Server,LoadBalancerMux -IncludeLogs -IncludeNetView
    ```

Here's a sample output of the `Start-SdnDataCollection` cmdlet:

```output
PS C:\> Start-SdnDataCollection -Networkcontroller SSdnDiagnostics.Environmentinfo.NetworkController[0] -Role Gateway,LoadBalancerMux,Networkcontrol1er.server -includeLogs -Fromoate (Get-Date).AddHours(-l)
[    N26-2] Starting SDN Data Collection
[    N26-2] Results will be saved to C:\windows\Tracing\sdnDataCollection\20220ll8-23325l
[    N26-2]	Node N26-GW0l.sal8.nttest.microsoft.com with role Gateway added	for data collection
[    N26-2] Node N26-GW02.sal8.nttest.microsoft.com with role Gateway added	for data collection
[    N26-2] Node N26-Mux0l.sal8.nttest.microsoft.com with role SoftwareLoadßalancer added for data collection
[    N26-2]	Node N26-NC01 with role	Networkcontroller added	for	data collection
[    N26-2]	Node N26-NC02 with role	Networkcontroller added	for	data collection
[    N26-2]	Node N26-NC03 with role	Networkcontroller added	for	data collection
[    N26-2]	Node n26-l.sal8.nttest.microsoft.com with role Server added for	data collection
[    N26-2]	Node n26-2.sal8.nttest.microsoft.com with role Server added for	data collection
[    N26-2]	Node n26-4.sal8.nttest.microsoft.com with role Server added for	data collection
[    N26-2] Performing cleanup of C:\windows\Tracing\sdnDataCollection\Temp directory across
[    N26-2] Collect configuration state details for Gateway nodes:
[    N26-GW01] Collect configuration state details for role Gateway
[    N26-GW02] Collect configuration state details for role Gateway
[    N26-2] Collect diagnostics logs for Gateway nodes:
[    N26-GW01] Collect diagnostic logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:32:55 pm utc
[    N26-GW02] Collect diagnostic logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:32:55 pm	utc
[    N26-2] Collect event logs for Gateway nodes:
[    N26-GW01] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:32:57 pm utc 
[    N26-GW01] Collect the following events: Application,Microsoft-windows-RasAgilevpn*,Microsoft-windows-RemoteAccess*,Microsoft-windows-VPN*,system
WARNING: [SA20N26-GW01] No events found for Microsoft-windows-RasAgilevpn* 
WARNING: [SA20N26-GW01] No events found for Microsoft-windows-VPN*
[    N26-GW02] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:32:57 pm utc
[    N26-GW02] Collect the following events: Application,Microsoft-windows-RasAgilevpn*,Microsoft-windows-RemoteAccess*,Microsoft-windows-VPN*,system
WARNING: [SA20N26-GW02] no events found for Microsoft-windows-RasAgilevpn* 
WARNING: [SA20N26-GW02] no events found for Microsoft-windows-VPN*
[    N26-2] Performing cleanup of C:\windows\Tracing\sdnDataCollection\Temp directory across
[    N26-2] Collect configuration state details for Networkcontroller nodes:
[    N26-NC01] Collect configuration state details for role	NetworkController
[    N26-NC02] Collect configuration state details for role NetworkController
[    N26-NC03] Collect configuration state details for role	NetworkController
[    N26-2] Copying \\SA20N26-NC01\C$\Windows\Tracing\SDNDiagnostics\NetworkControl1erstate\* to C:\Windows\Tracing\SdnDataCol1ection\20220118-233251\NetworkControl1erState 
[    N26-2] Copying \\SA20N26-NC02\C$\Windows\Tracing\SDNDiagnostics\NetworkControl1erstate\* to C:\Windows\Tracing\SdnDataCol1ection\20220118-233251\NetworkControl1erState 
[    N26-2] Copying \\SA20N26-NC03\C$\windows\Tracing\SDNDiagnostics\NetworkControl1erstate\* to C:\windows\Tracing\sdnoataCol1ection\20220ll8-23325l\NetworkControl1 erstate
[    N26-2] Collect service fabric logs for Networkcontroller nodes:
[    N26-NC01] Collect Service Fabric logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:22 pm utc
[    N26-NC02] Collect Service Fabric logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:22 pm utc
[    N26-NC03] Collect Service Fabric logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:22 pm utc
[    N26-2] Collect diagnostics logs for Networkcontroller nodes:
[    N26-NC01] Collect diagnostic logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:45 pm utc
[    N26-NC02] Collect diagnostic logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:45 pm utc
[    N26-NC03] Collect diagnostic logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:45 pm utc
[    N26-2] Collect event logs for Networkcontroller nodes:
[    N26-NC0l] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:48 pm utc 
[    N26-NC0l] Collect the following events: Application,Microsoft-windows-NetworkController*,Microsoft-ServiceFabric*,System
[    N26-NC02] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:48 pm utc
[    N26-NC02] Collect the following events: Application,Microsoft-windows-NetworkController*,Microsoft-ServiceFabric*,System 
[    N26-NC03] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:34:48 pm utc
[    N26-NC03] Collect the following events: Application,Microsoft-windows-NetworkController*,Microsoft-ServiceFabric*,System
[    N26-2] Performing cleanup of C:\Windows\Tracing\sdnDataCollection\Temp directory across 
[    N26-2] Collect configuration state details for server nodes: :
[    N26-l] Collect configuration state details for role Server
WARNING: [	N26-1] 00155D865002 attached to netl does not have a port profile
[    N26-2] Collect configuration state details for role Server
[    N26-4] collect diagnostics logs for server nodes:
[    N26-2] Collect diagnostic logs between 1/18/2022 10:32:51 pm and 1/18/2022	ll:41:19 pm	utc
[    N26-1] Collect diagnostic logs	between	1/18/2022 10:32:51 pm and 1/18/2022	11:41:19 pm	utc
[    N26-2] Collect diagnostic logs	between	1/18/2022 10:32:51 pm and 1/18/2022	ll:41:19 pm	utc
[    N26-4] collect event logs for Server nodes:
[    N26-2] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:41:22 pm utc
[    N26-1] Collect the following events: Application,Microsoft-Windows-Hyper-V*,System
[    N26-1] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:41:21 pm utc
[    N26-2] Collect the following events: Application,Microsoft-Windows-Hyper-V*,System
[    N26-2] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:41:22 pm utc
[    N26-4] collect the following events: Application,Microsoft-Windows-Hyper-V*,System
[    N26-2] Performing cleanup of C:\windows\Tracing\sdnoataCollection\Temp directory across
[    N26-2] Collect configuration state details for LoadBalancerMux nodes:
[    N26-MUX01] collect configuration state details for role LoadBalancerMux
[    N26-2] Collect diagnostics logs for LoadBalancerMux nodes:
[    N26-MUX01] collect diagnostic logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:44:48 pm utc
[    N26-2] Collect event logs for LoadBalancerMux nodes:
[    N26-MUX01] Collect event logs between 1/18/2022 10:32:51 pm and 1/18/2022 11:44:49 pm utc
[    N26-MUX01] Collect the following events: Application,Microsoft-windows-SlbMux*,System
[    N26-2] Copying \\	 \C$\windows\Tracing\sdnoataCollection\Temp to C:\Windows\Tracing\sdnDataCollection\20220ll8-23325l\
[    N26-2] Copying \\	C$\windows\Tracing\sdnDataCol1ection\Temp to C:\windows\Tracing\SdnDataCol1ection\20220ll8-23325l\
[    N26-2] Copying \\	\C$\Windows\Tracing\sdnoataCol1ection\Temp to C:\windows\Tracing\SdnoataCol1ection\20220ll8-23325l
[    N26-2] Copying \\	\C$\Windows\Tracing\sdnoataCol1ection\Temp to C:\windows\Tracing\sdnoataCol1ection\20220ll8-23325l
[    N26-2] Copying \\	\C$\Windows\Tracing\sdnoataCollection\Temp to C:\Windows\Tracing\sdnDataCollection\20220ll8-23325l.
[    N26-2] Copying \\	\C$\Windows\Tracing\sdnDataCol1ection\Temp to C:\windows\Tracing\sdnoataCol1ection\20220ll8-23325l
[    N26-2] Detected that is local machine
[    N26-2] Copying C:\windows\Tracina\sdnoataCol1ection\Temp to C:\windows\Tracing\sdnoatacol1ection\20220ll8-23325l\
[    N26-2] Copying \\	\C$\windows\Tracing\sdnDataCol1ection\Temp to C:\windows\Tracing\sdnoataCol1ection\20220ll8-23325l\
WARNING: TCP connect to (10.127.134.193 : 445) failed
WARNING: [    N26-2] Unable to establish TCP connection to i:445. Attempting to copy files using winRM
[    N26-2] Copying C:\windows\Tracing\sdnoataCol1ection\Temp to C:\windows\Tracing\sdnoatacol1ection\20220ll8-23325l\ using winRM session id 311
[    N26-2] Performing cleanup of C:\windows\Tracing\sdnDataCollection\Temp directory across
[    N26-2] Data collection completed
PS C:\>

```

## Next steps

- [Contact Microsoft Support](get-support.md)