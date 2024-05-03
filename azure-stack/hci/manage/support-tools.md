---
title: Support tool for Azure Stack HCI (22H2)
description: This article provides guidance on the Azure Stack HCI Support Diagnostic Tool for Azure Stack HCI, version 22H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 03/06/2024
---

# Use the Azure Stack HCI Support Diagnostic tool to troubleshoot issues 

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2.md)]

This article provides information on the Azure Stack HCI Support Diagnostic Tool that helps you troubleshoot and diagnose complex issues on your Azure Stack HCI. The tool consists of a set of PowerShell commands that simplify data collection, troubleshooting, and resolution of common issues in Azure Stack HCI.

> [!NOTE]
> This tool is currently only available for Azure Stack HCI, version 22H2.

This tool is designed to simplify the support and troubleshooting process and isn't a substitute for expert knowledge. If you encounter any issues, we recommend that you reach out to Microsoft Support for assistance.



## Benefits

The Azure Stack HCI Support Diagnostic Tool simplifies the support and troubleshooting process by providing simple commands that don't require any knowledge of the underlying product. This means that you can quickly get a first glance at what might be causing an issue, without needing to be an expert on the product.

The tool currently offers the following features:

- **Easy installation and updates**: Can be installed and updated natively using PowerShell Gallery, without any extra requirements.

- **Diagnostic checks**: Offers diagnostic checks based on common issues, incidents, and telemetry data.

- **Automatic data collection**: Automatically collects important data in case you want to reach out to Microsoft Customer Support.

- **Regular updates**: Is regularly updated with new checks and useful commands to manage, troubleshoot, and diagnose issues on Azure Stack HCI.

## Prerequisites

The following prerequisites must be completed to ensure the PowerShell module runs properly:

- Download the Azure Stack HCI Support Diagnostic tool from the [PowerShell Gallery](https://www.powershellgallery.com/packages?q=hci).

- Import the module into an elevated PowerShell window by an account with administrator privileges on the local system.

- Install the  module on each node of the Azure Stack HCI system.

## Install and use the tool

To install the tool, run the following command in PowerShell:

```powershell
Install-Module –Name Microsoft.AzureStack.HCI.CSSTools
```

To list all diagnostic checks that are available, run the following command:

```powershell
Invoke-AzsSupportDiagnosticCheck –ProductName <BaseSystem, Registration>
```

You can check all diagnostic checks by pressing `CTRL+SPACE` after the parameter `ProductName`.

## Example scenario

To troubleshoot Azure Stack HCI core products, for example, you can run the following cmdlet:


#### For registration issues

```powershell
Invoke-AzsSupportDiagnosticCheck -ProductName Registration
```

Here's an example of the output for registration issue:

```output
PS C:\temp> Invoke-AzsSupportDiagnosticCheck -ProductName Registration
Starting known issue check for Azure Stack HCI: Registration.                                                                                                       
Starting Azure Stack HCI base system validation.                                                                                                                        
Gathering information from all clustered nodes.                                                                                                                         
We are preparing to collect diagnostic information from your environment                                                                                                
We started the diagnostic data collection! This might take some time.                                                                                                   
Finished collecting diagnostic information.                                                                                                                             
====[ Validating registration state on node: HCI-N-1 ]====                                                                                                              
[Pass] [Azure Stack HCI - General registration state]                                                                                                                   
Validate that the cluster is registered
Details: Validation successfull

[Fail] [Azure Stack HCI - Azure Connection state]
Validate that the cluster is in a connected state
Details: This Azure Stack HCI node does not seem to be connected to azure. Ensure that this node is in a connected state.
Documentation: https://learn.microsoft.com/en-us/azure-stack/hci/deploy/troubleshoot-hci-registration

[Pass] [Azure Arc Agent - Connection state]
Validate that the azure arc agent is connected
Details: Validation successfull

[Pass] [Azure Arc Agent - Service state]
Validate that all azure arc services are running
Details: Validation successfull

[Pass] [Azure Arc Agent - Heartbeat state]
Validate that the azure arc agent has sent out a heartbeat at least a day ago
Details: Validation successfull

[Pass] [Azure Stack HCI - Arc Agent onboarded]
Validate that all arc agent checks are passed
Details: Validation successfull

[Fail] [Validation summary]

Details: At least one node reported an invalid registration state.

We will collect log information from your envirorment.
Creating local storage container for diagnostic data.
Gathering cluster data ... this might take a while.
Cluster data collection complete.
We are preparing to collect diagnostic information from your environment
We started the diagnostic data collection! This might take some time.
Waiting for all diagnostic output to be generated and compressed ... this might take a while.
Finished collecting diagnostic information.
Starting copy of items ... this might take a while.
All items copied.
Successfully created archive C:\temp\6c5a4685-6e32-4b68-aeec-05475f8d6c6f\log-collection-RegistrationInformation07-22_06-03-2024.zip. Removing raw data C:\temp\6c5a4685-6e32-4b68-aeec-05475f8d6c6f\container.
Data collection done . Please upload the file to the Microsoft Workspace.
```

#### For base Azure Stack HCI system issues

```powershell
Invoke-AzsSupportDiagnosticCheck -ProductName BaseSystem
```
Here's an example of the output for base system issues:

```output
PS C:\temp> Invoke-AzsSupportDiagnosticCheck -ProductName BaseSystem
Starting known issue check for Azure Stack HCI: BaseSystem.
Gathering information from all clustered nodes.
We are preparing to collect diagnostic information from your environment
We started the diagnostic data collection! This might take some time.
Starting to validate cluster settings.
[Pass] [Failover Clustering - Cluster validation report contains no errors]
Validate that there are no critical errors in the cluster validation report
Details: Validation successfull

[Pass] [Failover Clustering - Cluster Networks have redundancy]
Validate that we have redundancy in clustered networks
Details: Validation successfull

[Pass] [Failover Clustering - Validation Summary]
Validate that there are no critical issues in our cluster validation report.
Details: Validation successfull

Collecting node data.
Finished collecting diagnostic information.
====[ Validating data from node: HCI-N-1 ]====
[Pass] [Windows Features - All windows features installed]
Verify that all features required for Azure Stack HCI are installed.
Details: Validation successfull

[Pass] [Validation summary]
Ensure that no other check has returned a failed state
Details: Validation successfull
```

Afterwards, a comprehensive overview of the different components that are required for properly connected Azure Stack HCI systems is created. Based on this overview, you can either follow the troubleshooting guidance or reach out to Microsoft Support for further assistance.




## Next steps

For related information, see also:

- [Get support for Azure Stack HCI](get-support.md).
