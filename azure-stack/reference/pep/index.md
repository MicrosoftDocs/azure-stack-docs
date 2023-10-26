---
title: Azure Stack Hub privileged endpoint reference
description: Reference for PowerShell Azure Stack privileged endpoint
author: sethmanheim
ms.topic: reference
ms.date: 03/22/2023
ms.author: sethm
---

# Azure Stack Hub privileged endpoint reference

The Azure Stack Hub privileged endpoint (PEP) is a pre-configured remote PowerShell console that provides you with the capabilities to perform a required task. The endpoint uses PowerShell JEA (Just Enough Administration) to expose only a restricted set of cmdlets.

## Privileged endpoint cmdlets

| Cmdlet | Description |
| --- | --- |
| [Close-PrivilegedEndpoint](close-privilegedendpoint.md) | No description. |
| [Get-ActionStatus](get-actionstatus.md) | Gets the status of the latest action for the operation with the specified function name. |
| [Get-AzsDnsForwarder](get-azsdnsforwarder.md) | Get the DNS forwarder IP addresses used by Azure Stack Hub |
| [Get-AzSDnsServerSettings](get-azsdnsserversettings.md) | Get DNS server settings |
| [Get-AzSLegalNotice](get-azslegalnotice.md) | Get legal notice caption and text |
| [Get-AzureStackLog](get-azurestacklog.md) | Get logs from various roles of AzureStack with timeout. |
| [Get-AzureStackStampInformation](get-azurestackstampinformation.md) | Gets the stamp information. |
| [Get-AzureStackSupportConfiguration](get-azurestacksupportconfiguration.md) | Gets Support Service configuration settings. |
| [Get-CloudAdminPasswordRecoveryToken](get-cloudadminpasswordrecoverytoken.md) | No description. |
| [Get-CloudAdminUserList](get-cloudadminuserlist.md) | No description. |
| [Get-ClusterLog](get-clusterlog.md) | No description. |
| [Get-GraphApplication](get-graphapplication.md) | Get-GraphApplication is a wrapper function to get the Graph application information for the application Name or Identifier specified. |
| [Get-StorageJob](get-storagejob.md) | No description. |
| [Get-SupportSessionInfo](get-supportsessioninfo.md) | No description. |
| [Get-SupportSessionToken](get-supportsessiontoken.md) | No description. |
| [Get-SyslogClient](get-syslogclient.md) | Gets the syslog Client settings. |
| [Get-SyslogServer](get-syslogserver.md) | Gets the syslog server endpoint. |
| [Get-ThirdPartyNotices](get-thirdpartynotices.md) | No description. |
| [Get-TLSPolicy](get-tlspolicy.md) | No description. |
| [Get-VirtualDisk](get-virtualdisk.md) | No description. |
| [Invoke-AzureStackOnDemandLog](invoke-azurestackondemandlog.md) | Generates on demand logs from AzureStack roles where applicable. |
| [New-AzureBridgeServicePrincipal](new-azurebridgeserviceprincipal.md) | Creates a new service principal in Microsoft Entra ID. |
| [New-AzureStackActivation](new-azurestackactivation.md) | Activate Azure Stack. |
| [New-CloudAdminUser](new-cloudadminuser.md) | No description. |
| [New-GraphApplication](new-graphapplication.md) | New-GraphApplication is a wrapper function to call ADFS Graph cmdlets on AD FS. |
| [New-RegistrationToken](new-registrationtoken.md) | Creates a new registration token |
| [Register-CustomAdfs](register-customadfs.md) | Script to register custom Active Directory Federation Service (ADFS) as claims provider with Azure Stack AD FS. |
| [Register-CustomDnsServer](register-customdnsserver.md) | Script to register custom DNS servers with Azure Stack DNS. |
| [Register-DirectoryService](register-directoryservice.md) | Script to register customer Active Directory with Graph Service. |
| [Remove-AzureStackActivation](remove-azurestackactivation.md) | No description. |
| [Remove-CloudAdminUser](remove-cloudadminuser.md) | No description. |
| [Remove-GraphApplication](remove-graphapplication.md) | Remove-GraphApplication is a wrapper function to call ADFS Graph cmdlets on AD FS. |
| [Repair-VirtualDisk](repair-virtualdisk.md) | No description. |
| [Reset-DatacenterIntegrationConfiguration](reset-datacenterintegrationconfiguration.md) | Script to reset Datacenter Integration changes. |
| [Send-AzureStackDiagnosticLog](send-azurestackdiagnosticlog.md) | Sends Azure Stack Diagnostic Logs to Microsoft. |
| [Set-AzSLegalNotice](set-azslegalnotice.md) | Set legal notice caption and text |
| [Set-AzsDnsForwarder](set-azsdnsforwarder.md) | Update the DNS forwarder IP addresses used by Azure Stack Hub |
| [Set-AzSDnsServerSettings](set-azsdnsserversettings.md) | Update DNS server settings |
| [Set-CloudAdminUserPassword](set-cloudadminuserpassword.md) | No description. |
| [Set-GraphApplication](set-graphapplication.md) | Set-GraphApplication is a wrapper function to call ADFS Graph cmdlets on AD FS. |
| [Set-ServiceAdminOwner](set-serviceadminowner.md) | Script to update service administrator. |
| [Set-SyslogClient](set-syslogclient.md) | Imports and applies syslog client endpoint certificate. |
| [Set-SyslogServer](set-syslogserver.md) | Sets the syslog server endpoint. |
| [Set-Telemetry](set-telemetry.md) | Enables or disables the transfer of telemetry data to Microsoft. |
| [Set-TLSPolicy](set-tlspolicy.md) | No description. |
| [Start-AzsCryptoWipe](start-azscryptowipe.md) | Performs cryptographic wipe of Azure Stack Hub infrastructure. |
| [Start-AzureStack](start-azurestack.md) | Starts all Azure Stack services. |
| [Start-SecretRotation](start-secretrotation.md) | Triggers secret rotation on a stamp. |
| [Stop-AzureStack](stop-azurestack.md) | Stops all Azure Stack services. |
| [Test-AzureStack](test-azurestack.md) | Validates the status of Azure Stack. |
| [Unlock-SupportSession](unlock-supportsession.md) | No description. |

## Next steps

For more information about the Privileged Endpoint on Azure Stack Hub, see [Using the privileged endpoint in Azure Stack](../../operator/azure-stack-privileged-endpoint.md).
