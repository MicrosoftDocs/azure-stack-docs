---
title: Get support for Azure Stack HCI deployment issues (preview)
description: Learn how to get Microsoft support for Azure Stack HCI deployment issues, including log collection and remote support (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/13/2023
---

# Get support for Azure Stack HCI deployment issues (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to get Microsoft support for Azure Stack HCI deployment issues, including log collection and remote support.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Potential deployment issues

The following table outlines potential issues you might encounter during deployment, along with recommended troubleshooting actions.

| Issues | Recommended troubleshooting actions |
|--|--|
| - Active directory preparation issues. <br> - Azure Stack HCI operating system installation configuration issues. <br> - Deployment experience issues through the Azure portal and template. | [File a support ticket](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| - Environment validation issues. <br> - Initialization and registration issues. <br> - Deployment validation issues. <br> - Deployment failure issues. | 1. [File a support ticket](/azure/azure-portal/supportability/how-to-create-azure-support-request). <br> 2. [Perform standalone log collection](#perform-standalone-log-collection). |

## Perform standalone log collection

If observability components have not been deployed or if you encounter issues during the cluster deployment or registration process, you can perform standalone log collection to collect and send diagnostic data to Microsoft for troubleshooting purposes. Make sure to file a support ticket before you proceed with the log collection.

Here are the high-level steps for standalone log collection:

1. As instructed by Microsoft Support, copy the requested diagnostic data from the Azure Stack HCI node to a system which has connectivity to Azure.
1. Use `Send-AzStackHciDiagnosticData` to transmit the copied diagnostic data to Microsoft for troubleshooting purposes. Microsoft can access that data after you file a support ticket.

If the observability feature is already configured, you can send diagnostic data to Microsoft using the on-demand log collection process. For instructions, see [Collect logs](./collect-logs.md). To explore additional log collection methods in Azure Stack HCI and understand when to use them, see [Diagnostics](../concepts/observability.md#diagnostics).

### Send logs to Microsoft

You can use any of the following credentials to send logs:

- Device code credentials ($RegistrationWithDeviceCode). See [Send logs using device code credentials](#send-logs-using-device-code-credentials).
- Service principal name (SPN) credentials ($RegistrationSPCredential). See [Send logs using SPN credentials](#send-logs-using-spn-credentials).
- Registration with existing context credentials ($RegistrationWithExistingContext). See [Send logs using registration with existing context credentials](#send-logs-using-registration-with-existing-context-credentials).

#### Send logs using device code credentials

When you run the following command, you'll be prompted to open a web browser and enter the provided code to proceed with the authentication process.

```powershell
Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationWithDeviceCode -DiagnosticLogPath <LogPath> -RegistrationRegion <RegionName> -Cloud <AzureCloud>    
```

#### Send logs using SPN credentials

```powershell
Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationSPCredential <RegistrationSPCredential> -DiagnosticLogPath <LogPath> -RegistrationRegion <RegionName> -Cloud <AzureCloud>
```

You can use the following commands to get SPN credentials:

```powershell
$SPNAppID = "<Your App ID>"  
$SPNSecret= "<Your SPN Secret>"  
$SPNsecStringPassword = ConvertTo-SecureString  
$SPNSecret -AsPlainText -Force  
$SPNCred = New-Object System.Management.Automation.PSCredential ($SPNAppID, $SPNsecStringPassword)
```

#### Send logs using registration with existing context credentials

```powershell
Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationWithExistingContext -DiagnosticLogPath <LogPath> - RegistrationRegion <RegionName> -Cloud <AzureCloud>        
```

## Get remote support

In the pre-deployment or pre-registration scenarios, you are prompted to install and enable remote support via the Environment Checker to evaluate the readiness for deployment. If you enable remote support, Microsoft Support can connect to your device remotely and offer assistance. If you want to get remote support post-deployment of the cluster, see [Get remote support for Azure Stack HCI](./get-remote-support.md).

The high-level workflow to get remote support in the pre-deployment or pre-registration scenario is as follows:

- [Submit a support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).
- Enable remote support via PowerShell. This is a one-time configuration.

### Enable remote support

Follow these steps to enable remote support:

1. Establish a remote PowerShell session with the cluster node. Run PowerShell as administrator and run the following command:

   ```powershell
   Enter-PsSession -ComputerName <NodeName> -Credential $cred
   ```

1. Run the following command to enable remote support. The sample Shared Access Signature (SAS) is provided by the Microsoft support team.

   ```powershell
   Enable-AzStackHciRemoteSupport -AccessLevel <Diagnostics Or DiagnosticsRepair> -ExpireInMinutes <1440> -SasCredential <Sample SAS> -PassThru
   ```

   > [!NOTE]
   > When you run the command to enable remote support, you may get the following error:
   >
   > `Processing data from remote server <NodeName> failed with the following error message: The I/O operation has been aborted because of either a thread exit or an application request.`
   > 
   > This means the Just Enough Administration (JEA) configuration has not been established. When you enable remote support, a service restart is required to activate JEA. During the remote support JEA configuration, the Windows Remote Management (WinRM) restarts twice, which may disrupt the PsSession to the node. To resolve this error, wait for a few minutes before reconnecting to the remote node and then run the `Enable-AzStackHciRemoteSupport` command again to enable remote support.
   >

For remote support usage scenarios, see [Remote support examples](./get-remote-support.md#remote-support-examples).

## Next steps

- [Collect diagnostic logs](collect-logs.md)
- [Contact Microsoft Support](get-support.md)