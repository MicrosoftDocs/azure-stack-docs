---
title: Get support for Azure Local deployment issues
description: Learn how to get Microsoft support for Azure Local deployment issues, including log collection and remote support.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 12/17/2024
---

# Get support for Azure Local deployment issues

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to get Microsoft support for Azure Local deployment issues, including log collection and remote support.

## Potential deployment issues

The following table outlines potential issues you might encounter during deployment, along with recommended troubleshooting actions.

| Issues | Recommended troubleshooting actions |
|--|--|
| - Active directory preparation issues. <br> - Azure Stack HCI Operating System installation configuration issues. <br> - Deployment experience issues through the Azure portal and template. | [File a support ticket](/azure/azure-portal/supportability/how-to-create-azure-support-request). |
| - Environment validation issues. <br> - Initialization and registration issues. <br> - Deployment validation issues. <br> - Deployment failure issues. | 1. [File a support ticket](/azure/azure-portal/supportability/how-to-create-azure-support-request). <br> 2. [Perform standalone log collection](#perform-standalone-log-collection). |

## Perform standalone log collection

If observability components aren't deployed or you run into issues during system deployment or registration, perform standalone log collection to collect and send diagnostic data to Microsoft for troubleshooting. Make sure to file a support ticket before you start log collection.

Here are the high-level steps for standalone log collection:

1. As instructed by Microsoft Support, copy the requested diagnostic data from the Azure Local machine to a system, which has connectivity to Azure.
1. Use `Send-AzStackHciDiagnosticData` to transmit the copied diagnostic data to Microsoft for troubleshooting purposes. Microsoft can access that data after you file a support ticket.

If the observability feature is already set up, send diagnostic data to Microsoft using the on-demand log collection process. For instructions, see [Collect logs](./collect-logs.md). To learn about other log collection methods in Azure Local and when to use them, see [Diagnostics](../concepts/observability.md#diagnostics).

### Send logs to Microsoft

You can use any of the following credentials to send logs:

- Device code credentials ($RegistrationWithDeviceCode). See [Send logs using device code credentials](#send-logs-using-device-code-credentials).
- Service principal name (SPN) credentials ($RegistrationSPCredential). See [Send logs using SPN credentials](#send-logs-using-spn-credentials).
- Registration with existing context credentials ($RegistrationWithExistingContext). See [Send logs using registration with existing context credentials](#send-logs-using-registration-with-existing-context-credentials).

#### Send logs using device code credentials

When you run the following command, you're prompted to open a web browser and enter the provided code to continue the authentication process.

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

In the pre-deployment or pre-registration scenarios, you're prompted to install and enable remote support via the Environment Checker to evaluate the readiness for deployment. If you enable remote support, Microsoft Support can connect to your device remotely and offer assistance. If you want to get remote support post-deployment of the system, see [Get remote support for Azure Local](./get-remote-support.md).

The high-level workflow to get remote support in the pre-deployment or pre-registration scenario is as follows:

- [Submit a support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).
- Enable remote support via PowerShell. This is a one-time configuration.

### Enable remote support

To enable remote support, follow these steps:

1. Establish a remote PowerShell session with the machine. Run PowerShell as administrator and run the following command:

   ```powershell
   Enter-PsSession -ComputerName <MachineName> -Credential $cred
   ```

1. To enable remote support, run the following command. The sample Shared Access Signature (SAS) is provided by the Microsoft support team.

   ```powershell
   Enable-AzStackHciRemoteSupport -AccessLevel <Diagnostics Or DiagnosticsRepair> -ExpireInMinutes <1440> -SasCredential <Sample SAS> -PassThru
   ```

   > [!NOTE]
   > When you run the command to enable remote support, you can get the following error:
   >
   > `Processing data from remote server <MachineName> failed with the following error message: The I/O operation has been aborted because of either a thread exit or an application request.`
   >
   > This means the Just Enough Administration (JEA) configuration isn't established. When you enable remote support, a service restart is required to activate JEA. During the remote support JEA configuration, Windows Remote Management (WinRM) restarts twice, which can disrupt the PsSession to the machine. To fix this error, wait a few minutes before reconnecting to the remote machine, and then run the `Enable-AzStackHciRemoteSupport` command again to enable remote support.
   >

For remote support usage scenarios, see [Enable remote support diagnostics](./get-remote-support.md#enable-remote-support-diagnostics) and [Other remote support operations](./get-remote-support.md#other-remote-support-operations).

## Next steps

For detailed remediation for common known issues, check out:
> [!div class="nextstepaction"]
> [Azure Local Supportability repository](https://github.com/Azure/AzureStackHCI-Supportability)

Alternatively, you can:

- [Collect diagnostic logs](collect-logs.md).
- [Contact Microsoft Support](get-support.md).
