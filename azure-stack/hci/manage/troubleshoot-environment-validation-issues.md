---
title: Troubleshoot environment validation issues (preview)
description: How to get support from Microsoft to troubleshoot Azure Stack HCI environment validation issues.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/14/2023
---

# Troubleshoot environment validation issues (preview)

> Applies to: Azure Stack HCI, version 23H2 (preview)

This article describes how to get support from Microsoft to troubleshoot validation issues that may arise during the pre-deployment or pre-registration of the Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Get support from Microsoft

Starting with Azure Stack HCI, version 23H2 (preview) and later, you can get support from Microsoft to troubleshoot any issues that may arise during the environment validation process for Azure Stack HCI.

To troublehoot environment validation issues, you can begin by filing a support ticket and then do the following:

- Collect diagnostic data locally and submit it to Microsoft to assist with troubleshooting. See [Collect diagnostic data locally and send to Microsoft](#collect-diagnostic-data-locally-and-send-to-microsoft).
- Enable remote support to allow Microsoft Support to connect to your device remotely and provide assistance. See [Get remote support](#get-remote-support).

### Collect diagnostic data locally and send to Microsoft

If the environment validation process fails, you can collect local diagnostic data and transmit it to Microsoft for troubleshooting purposes. Microsoft can access that data after you file a support case.  

Use the `Send-DiagnosticData` cmdlet to collect and save logs locally and the `Send-AzStackHciDiagnosticData` cmdlet to manually send the diagnostic data to Microsoft.

[!INCLUDE [include](../../includes/hci-send-logs-manually.md)]

### Get remote support

In the pre-deployment or pre-registration scenarios, you are prompted to install and enable remote support via the Environment Checker to evaluate the readiness for deployment. If you enable remote support, Microsoft Support can connect to your device remotely and offer assistance. If you want to get remote support post-deployment of the cluster, see [Get remote support for Azure Stack HCI](./get-remote-support.md).

The high-level workflow to get remote support in the pre-deployment or pre-registration scenario is as follows:

- [Submit a support request](/azure/azure-portal/supportability/how-to-create-azure-support-request)
- Enable remote support via PowerShell. This is a one-time configuration.

#### Enable remote support

This is a one-time configuration when you enable remote support for the first time during the pre-deployment or pre-registeration of the cluster.

When you enable remote support, a service restart is required to activate Just Enough Administration (JEA). During the remote support JEA configuration, the Windows Remote Management (WinRM) restarts twice, which may disrupt the PsSession to the node. You need to wait for a few minutes before you can reconnect to the remote node and run the cmdlet to enable remote support again.

1. Establish a remote PowerShell session with the cluster node. Run PowerShell as administrator and run the following command:

   ```powershell
   Enter-PsSession -ComputerName <NodeName> -Credential $cred
   ```

1. Run the following command to enable remote support:

   ```powershell
   Enable-AzStackHciRemoteSupport -AccessLevel <Diagnostics Or DiagnosticsRepair> -ExpireInMinutes <1440> -SasCredential <Sample SAS> -PassThru
   ```

   When you run the enable remote support command for the first time, you get the following error:

   `Processing data from remote server <NodeName> failed with the following error message: The I/O operation has been aborted because of either a thread exit or an application request.`

1. Wait for a few minutes. Run the following command to re-establish a remote PowerShell session with the cluster node:

   ```powershell
   Enter-PsSession -ComputerName <NodeName> -Credential $cred
   ```

1. Run the following command to enable remote support again:

   ```powershell
   Enable-AzStackHciRemoteSupport -AccessLevel <Diagnostics Or DiagnosticsRepair> -ExpireInMinutes <1440> -SasCredential <Sample SAS> -PassThru
   ```

   The one-time configuration completes here.  

After you enable remote support, see [Remote support examples](./get-remote-support.md#remote-support-examples) for usage scenarios.

## Next steps

- [Collect diagnostic logs](collect-logs.md)
- [Contact Microsoft Support](get-support.md)
