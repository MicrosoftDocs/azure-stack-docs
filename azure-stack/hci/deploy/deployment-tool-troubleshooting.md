---
title: Troubleshoot Azure Stack HCI version 22H2 deployment (preview)
description: Learn to troubleshoot Azure Stack HCI version 22H2
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Troubleshoot Azure Stack HCI version 22H2 deployment (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article discusses troubleshooting and logging options for your Azure Stack HCI 22H2 preview deployment.

Also see [Known issues for Azure Stack HCI version 22H2](deployment-tool-known-issues.md).

## Rerun deployment

To rerun the deployment in case of a failure, run `InstallAzureStack-AsZ.ps1` with the parameter `-rerun`.

Depending on which step the deployment fails, it may require to run `Set-ExecutionPolicy bypass`.

## Reset deployment

If you must reset your deployment because it is in a not recoverable state, for example an incorrect network configuration, and rerun does not resolve the issue, it is necessary to reset the deployment.

1. Back up all your data first. The orchestrated deployment will always clean the drives used by Storage Spaces Direct in this preview release.
1. Remove the *ServerHCI.vhdx* and replace it with the *ServerHCI.vhdx* that you have downloaded.
1. Reinstall the Azure Stack HCI 22H2 operating system.

## Collect log data

For log data, you can manually send log files to Microsoft or you can provide consent to Microsoft to allow us to proactively collect log data.

Collect the following logs, zip them, and send to Microsoft: `-C:\Clouddeployment\Logs -C:\Maslogs`

If Network ATC doesn't run correctly and virtual network interfaces and virtual switches are not created, collect the logs in *C:\Windows\Networkatctrace.etl* and send them to Microsoft.

You can allow Microsoft to proactively collect diagnostic log data during deployment. Keep in mind that `-IncludeGetSDDCLogs` is set to `$true` by default.

To do this, run the following PowerShell cmdlet:

`Start on-demand log collection Import-module ASZDiagnosticsInitializer
Send-DiagnosticData`

To get a history of log collections for last the 90 days, run the following:

`Import-module ASZDiagnosticsInitializer Get-LogCollectionHistory`

## More information

See [Known issues for Azure Stack HCI version 22H2](deployment-tool-known-issues.md)