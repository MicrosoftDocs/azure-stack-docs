---
title: Troubleshoot environment validation issues (preview)
description: How to get support from Microsoft to troubleshoot Azure Stack HCI environment validation issues.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/30/2023
---

# Troubleshoot environment validation issues (preview)

> Applies to: Azure Stack HCI, version 23H2 (preview)

This article describes how to get support from Microsoft to troubleshoot validation issues that may arise during the pre-deployment or pre-registration of the Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Get support from Microsoft

Starting with Azure Stack HCI, version 23H2 (preview) and later, you can get support from Microsoft to troubleshoot any issues that may arise during the environment validation process for Azure Stack HCI.

To troubleshoot environment validation issues, you can begin by filing a support ticket and then do the following:

- Collect diagnostic data locally and submit it to Microsoft to assist with troubleshooting. See [Collect diagnostic data locally and send to Microsoft](#collect-diagnostic-data-locally-and-send-to-microsoft).
- Enable remote support to allow Microsoft Support to connect to your device remotely and provide assistance. See [Get remote support](#get-remote-support).

## Collect diagnostic data locally and send to Microsoft

If the environment validation process fails, you can save diagnostic data to a local Server Message Block (SMB) share and then transmit it to Microsoft for troubleshooting purposes. Microsoft can access that data after you file a support case.  

### Save logs on a local file share

You can save diagnostic logs to a local share, typically in the following scenarios:

- **Pre-deployment or pre-registration.** To troubleshoot any validation issues that may arise during the pre-deployment or pre-registration of the cluster.
- **Post-deployment.** If you're normally connected but experiencing connectivity issues, you can save logs locally to help with troubleshooting.

Run the following command on each node of the cluster to collect logs and save them locally:

```powershell
Send-DiagnosticData –ToSMBShare -BypassObsAgent –SharePath <Path to the SMB share> -ShareCredential <Crendentials to connect to the SharePath>  
```

### Send logs to Microsoft

Microsoft retains the diagnostic data that you send for up to 29 days and handles it as per the [standard privacy practices](https://privacy.microsoft.com/).

You can send logs to Microsoft using `Send-DiagnosticData` and `Send-AzStackHciDiagnosticData` cmdlets, as described in the following sections.

#### Send logs using `Send-DiagnosticData`

If the SMB share where you saved the logs has outbound connectivity, you can run the following command to send logs after log collection on all the nodes finishes:

```powershell
Send-DiagnosticData –FromSMBShare –BypassObsAgent –SharePath <Path to the SMB share> -ShareCredential <Crendentials to connect to the SharePath>
```

#### Send logs using `Send-AzStackHciDiagnosticData`

Use the `Send-AzStackHciDiagnosticData` cmdlet to send logs from any machine with outbound connectivity, outside of the Azure Stack HCI stamp.

The input parameters used to send logs using `Send-AzStackHciDiagnosticData` are the same that are required as part of the deployment process. For description about the input parameters, see [Deploy Azure Stack HCI using PowerShell (preview)](../deploy/deployment-tool-powershell.md).

You can use any of the following credentials to send logs:

- $RegistrationCredential
- $RegistrationWithDeviceCode
- $RegistrationSPCredential
- $RegistrationWithExistingContext

You can find the parameter values in `C:\Deployment`. Run the following command to see the output:

```powershell
$deployArgs = Import-Clixml -Path C:\Deployment\DeployArguments.xml
```

#### Get information for the required parameters

The following parameters are required to use the `Send-AzStackHciDiagnosticData` cmdlet. Consult your network administrator as needed for this information.

- `ResourceGroupName`: Name of the Azure resource group, which must be the same as used during the deployment process. Follow these steps to get the resource group name:

   1. Establish a remote PowerShell session with one of the cluster nodes. Run PowerShell as administrator and run the following command:
   
      ```powershell
      Enter-PsSession -ComputerName <NodeName> -Credential $cred
      ```
   
   1. Run the following command to get the resource group name:
   
      ```powershell
      Import-Module C:\CloudDeployment\ECEngine\EnterpriseCloudEngine.psd1 -ErrorAction SilentlyContinue
      $eceConfig = Get-EceConfiguration -ErrorAction SilentlyContinue
      if ($eceConfig.Xml -match "<RegistrationResourceGroupName>(.*)</RegistrationResourceGroupName>")
      {
      $resourcegroupname =  $matches[1].Trim()
      }
      ```

- `SubscriptionId`: Name of the Azure subscription ID, which must be the same as used during the deployment process. Use the following command to get the subscription ID:

   ```powershell
   $subscriptionId = $deployArgs.RegistrationSubscriptionId
   ```

- `TenantId`: Azure tenant ID, which must be the same as used during the deployment process. Use the following command to get the tenant ID:

   ```powershell
   $cloudName = $deployargs.RegistrationCloudName
   Import-Module "$env:SystemDrive\CloudDeployment\Setup\Common\RegistrationHelpers.psm1"
   $RegistrationTenantId = Get-TenantId -AzureEnvironment $CloudName -SubscriptionId $subscriptionid
   ```

- `RegistrationRegion`: Registration region, which must be the same as used during the deployment process.

- `Cloud`: Azure cloud name, which must be the same as used during the deployment process.

- `CacheFlushWaitTimeInSec`: Optional wait time in seconds to flush the cache folder. The default value is 600.

- `RegistrationCredential`: Azure credentials to authenticate with Azure. This is mandatory in `DefaultSet` parameter set.

- `DiagnosticLogPath`: Diagnostics log path where logs are stored.

- `RegistrationWithDeviceCode`: The switch that allows Azure authentication with the device code.

- `RegistrationWithExistingContext`: Use this switch if current PowerShell window already had `Connect-AzAccount` executed and use the existing context for Azure authentication.

- `RegistrationSPCredential`: Part of the `ServicePrincipal` parameter set. Use this to send `ServicePrincipal` credential.

#### Send logs using different credentials

Based on the type of credentials you have, use one of the following commands to send logs:

- **Send logs using registration credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> -RegistrationCredential <RegistrationCredential> -DiagnosticLogPath <LogPath> -RegistrationRegion <RegionName> -Cloud <AzureCloud>
   ```

   Use the following command to set up the registration credentials:

   ```powershell
   $registrationaccountusername = $deployArgs.RegistrationAccountUserName
   $regPassword = $deployArgs.RegistrationAccountPassword
   $registrationCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $registrationaccountusername, (ConvertTo-SecureString -AsPlainText $regPassword -Force) $registrationCredential
   ```

- **Send logs using device code credentials**

   When you run the following command, you'll be prompted to open a web browser and enter the provided code to proceed with the authentication process.

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationWithDeviceCode -DiagnosticLogPath <LogPath> -RegistrationRegion <RegionName> -Cloud <AzureCloud>    
   ```

- **Send logs using service principal name (SPN) credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationSPCredential <RegistrationSPCredential> -DiagnosticLogPath <LogPath> -RegistrationRegion <RegionName> -Cloud <AzureCloud>
   ```

   You can use the following cmdlets to get SPN credentials:

   ```powershell
   $SPNAppID = "<Your App ID>"  
   $SPNSecret= "<Your SPN Secret>"  
   $SPNsecStringPassword = ConvertTo-SecureString  
   $SPNSecret -AsPlainText -Force  
   $SPNCred = New-Object System.Management.Automation.PSCredential ($SPNAppID, $SPNsecStringPassword)
   ```

- **Send logs using registration with existing context credentials**

   ```powershell
   Send-AzStackHciDiagnosticData -ResourceGroupName <ResourceGroupName> -SubscriptionId <SubscriptionId> -TenantId <TenantId> - RegistrationWithExistingContext -DiagnosticLogPath <LogPath> - RegistrationRegion <RegionName> -Cloud <AzureCloud>        
   ```

## Get remote support

In the pre-deployment or pre-registration scenarios, you are prompted to install and enable remote support via the Environment Checker to evaluate the readiness for deployment. If you enable remote support, Microsoft Support can connect to your device remotely and offer assistance. If you want to get remote support post-deployment of the cluster, see [Get remote support for Azure Stack HCI](./get-remote-support.md).

The high-level workflow to get remote support in the pre-deployment or pre-registration scenario is as follows:

- [Submit a support request](/azure/azure-portal/supportability/how-to-create-azure-support-request)
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
   > This means the Just Enough Administration (JEA) configuration has not been established. When you enable remote support, a service restart is required to activate JEA. During the remote support JEA configuration, the Windows Remote Management (WinRM) restarts twice, which may disrupt the PsSession to the node. To resolve this error, wait for a few minutes before reconnecting to the remote node and then run the `Enable-AzStackHciRemoteSupport` cmdlet again to enable remote support.
   >

For remote support usage scenarios, see [Remote support examples](./get-remote-support.md#remote-support-examples).

## Next steps

- [Collect diagnostic logs](collect-logs.md)
- [Contact Microsoft Support](get-support.md)
