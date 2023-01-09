---
title: Collect logs for Software Defined Networking
description: You can use this topic to learn how to manage certificates for Network Controller Northbound and Southbound communications when you deploy Software Defined Networking (SDN) in Windows Server 2019 and 2016 Datacenter.
ms.topic: article
ms.author: v-mandhiman
author: ManikaDhiman
ms.date: 01/04/2023
---

# Collect logs for Software Defined Networking

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016, Azure Stack HCI, versions 22H2, 21H2, and 20H2

This article describes how to collect logs for Software Defined Networking (SDN) on your Azure Stack HCI system. You can use these logs to identify and troubleshoot any issues with your SDN deployment before contacting Microsoft support. You can also use these logs to test a recently deployed SDN environment or re-test an existing deployment. In addition to log collection, we also execute a series of validation tests to gain a current goal state of the environment and check for common misconfiguration issues.

## Prerequisites

Before you begin, complete the following tasks:

- Make sure the client computer that you use for log collection has access to the SDN environment, such as Windows Admin Center management computer.
- Make sure that the client computer used is running PowerShell 5.1 or later.
-  

## Install the SDN Diagnostics PowerShell module

To install the SDN Diagnostics PowerShell module on the client computer, follow these steps:

1. Run PowerShell as administrator (5.1 or later). If you need to install PowerShell, see [Installing PowerShell on Windows](/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2&preserve-view=true).
1. 
From a workstation that has access to the SDN environment such as Windows Admin Center, open an elevated PowerShell window and run the following commands: 
1.	Install-Module -name PackageManagement -Force
2.	Update-Module -Name PackageManagement -Force
Note: It is important to close all PowerShell sessions to reload the latest version of Package Management
3.	Install-Module SdnDiagnostics
4.	Import-Module SdnDiagnostics


## Discover the SDN components deployed and Install the Module on SDN fabric nodes

After the SDN Diagnostics module has been installed, we must discover all the SDN components that have been deployed. To do so, run the following commands:
1.	Set the variable for one of the Network Controller VM Names:
a.	$NCVMName = ‘example: nc01.contoso.com’
2.	Import-Module -Name SdnDiagnostics -Force
3.	$EnvironmentDetails = Get-SdnInfrastructureInfo -NetworkController $NCVMName -Credential (get-credential)
4.	Install-SDNDiagnostics -ComputerName $environmentdetails.FabricNodes -Credential (Get-Credential)
Once this step has completed, we will have checked for the latest version of SdnDiagnostics hosted on GitHub, checked the installed version on all SDN fabric nodes, and installed/upgraded to the latest version. 

## SDN Log Collection using SdnDiagnostics

Now that SdnDiagnostics module has been installed on SDN fabric nodes and the management VM (like Windows Admin Center VM), we can now collect logs. This command will collect logs from Network Controller, Load Balancers, Gateways, and the Azure Stack HCI hosts. 
1.	Set the variable for one of the Network Controller VMs:
a.	$NCVMName = ‘example: nc01.contoso.com’
2.	Start-SdnDataCollection -NetworkController $NCVMName -Credential (Get-Credential) -Role Gateway,NetworkController,Server,SoftwareLoadBalancer -IncludeLogs -IncludeNetView
You can remove roles that may not be installed and/or that are working as expected. Collecting all logs provides a holistic view of the environment. By default, we will collect the last 4 hours of logs and ETLs of various components. These are further documented here.
