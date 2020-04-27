---
title: Azure Stack Hub privileged endpoint reference
description: Reference for Powershell Azure Stack privileged endpoint
author: mattbriggs

ms.topic: reference
ms.date: 04/27/2020
ms.author: mabrigg
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Azure Stack Hub Privileged Endpoint Reference

The PEP is a pre-configured remote PowerShell console that provides you with just enough capabilities to help you perform a required task. The endpoint uses PowerShell JEA (Just Enough Administration) to expose only a restricted set of cmdlets.

## Privilege Endpoint cmdlets

| Cmdlet | Description |
| --- | --- |
| [Close-PrivilegedEndpoint](Close-PrivilegedEndpoint.md) | No description. |
| [Get-ActionStatus](Get-ActionStatus.md) | Gets the status of the latest action for the operation with the specified function name. |
| [Get-AzureStackLog](Get-AzureStackLog.md) | Get logs from various roles of AzureStack with timeout. |
| [Get-AzureStackStampInformation](Get-AzureStackStampInformation.md) | Gets the stamp information. |
| [Get-AzureStackSupportConfiguration](Get-AzureStackSupportConfiguration.md) | Gets Support Service configuration settings. |
| [Get-CloudAdminPasswordRecoveryToken](Get-CloudAdminPasswordRecoveryToken.md) | No description. |
| [Get-CloudAdminUserList](Get-CloudAdminUserList.md) | No description. |
| [Get-ClusterLog](Get-ClusterLog.md) | No description. |
| [Get-GraphApplication](Get-GraphApplication.md) | Get-GraphApplication is a wrapper function to get the Graph application information for the Applicaiton Name or Identifier specified. |
| [Get-StorageJob](Get-StorageJob.md) | No description. |
| [Get-SupportSessionInfo](Get-SupportSessionInfo.md) | No description. |
| [Get-SupportSessionToken](Get-SupportSessionToken.md) | No description. |
| [Get-SyslogClient](Get-SyslogClient.md) | Gets the Syslog Client settings |
| [Get-SyslogServer](Get-SyslogServer.md) | Gets the Syslog server endpoint |
| [Get-ThirdPartyNotices](Get-ThirdPartyNotices.md) | No description. |
| [Get-TLSPolicy](Get-TLSPolicy.md) | No description. |
| [Get-VirtualDisk](Get-VirtualDisk.md) | No description. |
| [Invoke-AzureStackOnDemandLog](Invoke-AzureStackOnDemandLog.md) | Generates on demand logs from AzureStack roles where applicable. |
| [New-AzureBridgeServicePrincipal](New-AzureBridgeServicePrincipal.md) | Creates a new servcie principal in Azure Active Directory |
| [New-AzureStackActivation](New-AzureStackActivation.md) | Activate Azure Stack |
| [New-CloudAdminUser](New-CloudAdminUser.md) | No description. |
| [New-GraphApplication](New-GraphApplication.md) | New-GraphApplication is a wrapper funnction to call ADFS Graph cmdlets on ADFS. |
| [New-RegistrationToken](New-RegistrationToken.md) | Creates a new registration token |
| [Register-CustomAdfs](Register-CustomAdfs.md) | Script to register custom Active Directory Federation Service (ADFS) as claims provider with Azure Stack ADFS |
| [Register-CustomDnsServer](Register-CustomDnsServer.md) | Script to register custom DNS servers with Azure Stack DNS. |
| [Register-DirectoryService](Register-DirectoryService.md) | Script to register customer Active Directory with Graph Service |
| [Remove-AzureStackActivation](Remove-AzureStackActivation.md) | No description. |
| [Remove-CloudAdminUser](Remove-CloudAdminUser.md) | No description. |
| [Remove-GraphApplication](Remove-GraphApplication.md) | Remove-GraphApplication is a wrapper funnction to call ADFS Graph cmdlets on ADFS. |
| [Repair-VirtualDisk](Repair-VirtualDisk.md) | No description. |
| [Reset-DatacenterIntegrationConfiguration](Reset-DatacenterIntegrationConfiguration.md) | Script to reset Datacenter Integration changes |
| [Send-AzureStackDiagnosticLog](Send-AzureStackDiagnosticLog.md) | Sends Azure Stack Diagnostic Logs to Microsoft. |
| [Set-CloudAdminUserPassword](Set-CloudAdminUserPassword.md) | No description. |
| [Set-GraphApplication](Set-GraphApplication.md) | Set-GraphApplication is a wrapper funnction to call ADFS Graph cmdlets on ADFS. |
| [Set-ServiceAdminOwner](Set-ServiceAdminOwner.md) | Script to update service admin upn |
| [Set-SyslogClient](Set-SyslogClient.md) | Imports and applies Syslog client endpoint certificate |
| [Set-SyslogServer](Set-SyslogServer.md) | Sets the Syslog server endpoint |
| [Set-Telemetry](Set-Telemetry.md) | Enables or disables the transfer of telemetry data to Microsoft. |
| [Set-TLSPolicy](Set-TLSPolicy.md) | No description. |
| [Start-AzureStack](Start-AzureStack.md) | Starts all Azure Stack services. |
| [Start-SecretRotation](Start-SecretRotation.md) | Triggers secret rotation on a stamp. |
| [Stop-AzureStack](Stop-AzureStack.md) | Stops all Azure Stack services. |
| [Test-AzureStack](Test-AzureStack.md) | Validates the status of Azure Stack |
| [Unlock-SupportSession](Unlock-SupportSession.md) | No description. |

## Next steps

For more information, about the Privileged Endpoint on Azure Stack Hub see [Using the privileged endpoint in Azure Stack](https://docs.microsoft.com/azure-stack/operator/azure-stack-privileged-endpoint).
