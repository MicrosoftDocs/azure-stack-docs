---
title: Azure Stack HCI telemetry and diagnostics.
description: This article describes the design and policies associated with diagnostic data collected by Azure Stack HCI.
author: ronmiab
ms.author: robess
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/01/2023
zone_pivot_groups: telemetry-diagnostics-data-collection
---

# Azure Stack HCI telemetry and diagnostics (preview)

::: zone pivot="legacy-collection"

> [!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes required data collected to keep Azure Stack HCI secure, up to date, and working as expected.

::: zone-end

::: zone pivot="extension-collection"

> [!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes the telemetry and diagnostics extension in Azure Stack HCI.

::: zone-end

::: zone pivot="legacy-collection"

Customer data, including the names, metadata, configuration, and contents of your on-premises virtual machines (VMs) is never sent to the cloud unless you turn on additional services like Azure Backup or Azure Site Recovery, or unless you enroll those VMs individually into cloud management services like Azure Arc.

We do collect diagnostic data. The data described below is required for Microsoft to provide Azure Stack HCI. This data is collected once a day, and data collection events can be viewed in the event logs. Azure Stack HCI collects the minimum data required to keep your clusters up to date, secure, and operating properly.

   > [!IMPORTANT]
   > The data described below that Azure Stack HCI collects is independent from Windows diagnostic data, which can be configured for various levels of collection. In Azure Stack HCI, the default setting for Windows diagnostic data collection is Security (off), meaning that no Windows diagnostic data is sent unless the administrator changes the diagnostic data settings. For more information, see [Configure Windows diagnostic data in your organization](/windows/privacy/configure-windows-diagnostic-data-in-your-organization). Microsoft is an independent controller of any Windows diagnostic data collected in connection with Azure Stack HCI. Microsoft will handle the Windows diagnostic data in accordance with the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement).

## Data collection and residency

This Azure Stack HCI data:

- isn't sent to Microsoft until the product is registered with Azure. When Azure Stack HCI is unregistered, this data collection stops.
- is logged to the Microsoft-AzureStack-HCI/Analytic event channel.
- is in JSON format, so that system administrators can examine and analyze the data being sent.

Data is stored in a secure Microsoft-operated datacenter as follows:

- Billing and census data is sent to the respective resource of the region where the customer has registered the device to. This data is the information shown about the resource in the Azure portal and the data needed to bill and license the cluster nodes.

- Diagnostic data (classified as support data) will be stored within the US or the EU based on what the customer has opted for at the time of deployment.

- Telemetry data (classified as OII data) is always stored within the US.

To learn about how Microsoft stores diagnostic data in Azure, see [Data residency in Azure](https://azure.microsoft.com/global-infrastructure/data-residency/).

## Data retention

After Azure Stack HCI collects this data, it's retained for 90 days. Aggregated, de-identified data may be kept longer.

## Data that Azure Stack HCI collects?

Azure Stack HCI collects:

- Information about servers such as operating system version, processor model, number of processor cores, memory size, cluster identifier, and hash of hardware ID
- List of installed Azure Stack HCI server features (For example, BitLocker)
- Information necessary to compute the reliability of the Azure Stack HCI operating system
- Information necessary to compute the reliability of the health collection data
- Information gathered from the event log for specific errors, such as update download failed
- Information for computing storage reliability
- Information for computing physical disk reliability
- Information for computing the reliability of volume encryption
- Information for computing the reliability and performance of Storage Spaces repair
- Information to validate security of the Azure Stack HCI operating system
- Information to compute reliability of the antivirus/antimalware state of the Azure Stack HCI operating system
- Information to correlate reliability of the networking components
- Information to correlate networking performance
- Information to correlate reliability of updates and installations
- Information to measure reliability of Hyper-V
- Information to measure/correlate reliability of the clustering components
- Information to track the success of the Cluster Aware Updating (CAU) feature
- Information to measure/correlate the reliability of the Disaster Recovery feature
- Information to describe the SMB bandwidth limits applied to Azure Stack HCI servers
- Information about SMB and NFS share configuration

## View the collected data

1. Enable the analytic log using the following PowerShell command:

   ```PowerShell
   wevtutil sl Microsoft-AzureStack-HCI/Analytic /e:True
   ```

2. View the log to see the collected data:

   ```PowerShell
   Get-WinEvent -LogName Microsoft-AzureStack-HCI/Analytic -Oldest
   ```

3. Format the data for exporting:

   ```PowerShell
   Get-WinEvent -LogName Microsoft-AzureStack-HCI/Analytic -Oldest `
   | Where-Object Id -eq 802 `
   | ForEach-Object { 
       [pscustomobject] @{
           TimeCreated = $_.TimeCreated 
           EventName=$_.Properties[0].Value 
           Value=$_.Properties[1].Value 
       } 
   }
   ```

The output should look something like this:

```shell
TimeCreated            EventName                                                  Value
-----------            ---------                                                  -----
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.Core                   {"OEMName":"Microsoft Corporation"...
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.ProductFeatures        {"InstalledFeatures":["Server-Core...
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.OSReliability          {"DailyDirtyRestarts":0,"WeeklyDir...
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.DiagnosticHealth       {"DailySuccessfulDiagnosticUploads...
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.ErrorSummary           {"ErrorSummary":[{"EventName":"Win...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.VolumeSummary          {"VolumeCount":2,"HealthyVolumeCou...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.DiskSummary            {"DiskCount":33,"Summary":[]}
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.BitlockerVolumeSummary {"BitlockerVolumeCount":0,"Summary...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.StorageErrors          {"ErrorSummary":[{"EventName":"Sto...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.StorageRepairSummary   {"DailyRepairStartCount":0,"Weekly...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.TrustedPlatformModule  {"Manufacturer":"MSFT","Manufactur...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.MicrosoftDefender      {"AMEngineVersion":"1.1.17600.5","...
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.NetworkInfo            {"NetworkDirect":true,"NetworkDire...
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.NetworkAdapterSummary  {"NetworkAdapterGroup":[{"DriverNa...
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.OSDeploy               {"OSInstallType":0}
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.ClusterProperties      {"Id":"fd2fc061-b924-4d61-a45b-3b3...
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.DisasterRecovery       {"IsDisasterRecoveryEnabled":false...
```

::: zone-end

::: zone pivot="extension-collection"

## About telemetry and diagnostics

Telemetry and diagnostics, an Azure arc extension that allows Microsoft to collect logs and telemetry data from all the nodes in the servers, in your Azure Stack HCI cluster. This mandatory extension is available for both new and existing Azure Stack HCI clusters. Use this extension as an important tool to monitor and troubleshoot the functionality of your Azure Stack HCI clusters.

A registered Azure Stack HCI device has an Azure Arc Connected, agent installed on it. After you've configured the extension, it can continue to function even if the arc agent fails.

The extension only requires the arc agent installation initially, and it can continuously operate even if the agent isn't running.

## Benefits of the telemetry and diagnostics extension

Azure Stack HCI previously used the operating system to report telemetry data to Microsoft. Now, telemetry data is installed and managed through the telemetry and diagnostics extension.

Here are some advantages of the extension:

- **Improved transparency:** Supplies the extension name, version, and status directly in the Azure portal.

- **Resource consumption controls:** Ensures that no more than 5% CPU is consumed, and control of the process is enforced via the Azure Arc extension framework.

- **Reduced update impact:** Updates non-disruptively and changes don't require a reboot of the host server.

  - When available you can seamlessly update the environment with new or improved functionality.

- **Improved compliance:** Allows the telemetry and diagnostic data to be compliant with data uploads as per regional service and data residency requirements.
  
- **Simplified log gathering:** It's easier to collect diagnostics logs when the collection functionality is readily available. With the proactive log collection functionality enabled, Microsoft can help look for certain errors or exception patterns and collect logs proactively, which saves support time.

- **Faster case resolution**: Microsoft customer support and engineering teams can use your Azure Stack HCI system logs to efficiently identify and quickly resolve your issues.

## Telemetry and diagnostics extension management

When you have installed and run the telemetry extension, you still maintain control over whether you send telemetry data to Microsoft. To access the options to send telemetry data, go to your cluster **Settings** in the Azure portal and select **Extensions**.

:::image type="content" source="media/telemetry-diagnostics/telemetry-diagnostics-extension-1.png" alt-text="Screenshot of the extension settings screen." lightbox="media/telemetry-diagnostics/telemetry-diagnostics-extension-1.png":::

You can configure the extension to be:

- **Off:** You don't send system data to Microsoft.

- **Basic:** You send Microsoft the minimum system data required to keep clusters current, secure, and operating properly. Benefits of basic telemetry:

  - Supports an improved user experience.
  - Critical reliability issues are identified for greater resolution.
  - Provides quality features, deployment, and other product improvements.
  - Drives developments and intelligence into Azure Stack HCI management and monitoring solutions.

- **Enhanced:** You send more system data to help Microsoft identify and fix operational issues and for product improvements. It's highly recommended that you enable **enhanced diagnostics**. Benefits of enhanced telemetry:

  - System data might remain for up to 30 days.
  - Errors are captured more accurately ensuring timely diagnostic information without the need for operator interaction.
  - You have a connected experience with proactive log collection. Your logs are automatically uploaded to an Azure Storage account managed and controlled by Microsoft. These logs are used to resolve your issues.
  - Microsoft can begin to troubleshoot and resolve problems sooner in some cases.
  - The product team can diagnose problems due to failure events and improve the quality of the product.

For basic or enhanced diagnostics, when there's no or intermittent connectivity to Azure, logs are captured and stored locally for failure events. These logs are access  by Microsoft for a support case and not sent to Azure.

## Consent for data collection

Microsoft collects data in accordance with its standard privacy practices. The new telemetry agent doesn't override your existing control setting.

If you decide to revoke your consent for data collection, any data collected before revocation isn't affected. Microsoft continues to handle and use the data collected, in accordance with the terms that were in place at the time of the data collection.

Here are a couple of things to consider with data collection:

- A review of Microsoft's privacy practices and policies to understand how Microsoft handles and uses your data.

- A consultation with legal or privacy professionals to ensure that they fully understand the implications of consenting to data collection and the revocation of consent.

### Azure Stack HCI privacy considerations

Azure Stack HCI routes system data back to a protected cloud storage location. Only Microsoft personnel with a valid business need are given access to the system data. Microsoft doesn't share personal customer data with third parties, except at the customer's discretion or for the limited purposes described in the Microsoft Privacy Statement. Data sharing decisions are made by an internal Microsoft team including privacy, legal, and data management stakeholders.

Don't include any confidential information or personal information in resource names or file names. For example, VM names, volume names, configuration file names, storage file names (VHD names), or cluster resource names.

## Extension artifacts

As part of the extension installment, artifacts generated from your cluster node are created on the stamp. Here's a description of the artifact names and locations:

|Artifact name     | Location                                                                   |
|------------------|----------------------------------------------------------------------------|
| Extension        |C:\Packages\Plugins\Microsoft.AzureStack.Observability.TelemetrAndDiagnostics\<Version#>\                                                              |
| Extension logs   |C:\ProgramData\GuestConfig\extension_logs\Microsoft.AzureStack.Observability.TelemetrAndDiagnostics\ObservabilityExtension.log                                               |
|GMA process logs  |SystemDrive\GMACache                                                        |
| Diagnostics logs |SystemDrive\Observability                                                   |

## Error handling

To handle errors in extensions, we have identified and provided expected messages with unique error codes.

Here are some examples:

| Error code | Error message | Description | Mitigation steps |
|------------|---------------|-------------|------------------|
| 7 | There's at least one GMA process already running on the stamp. To proceed with the extension installation, shut down the relevant processes. | During the extension installation, you can't run other GMA processes on the stamp. The extension raises an error message. | Remove the other GMA processes and then continue. Use `Get-Process MonitoringAgent` to identify active processes on the stamp. |
| 9 | There's insufficient disk space available on the drive. To proceed with the extension installation, delete some files to free up space. | The extension validates as a pre-installation step and requires a minimum of 20 GB of space for the GMA cache on the SystemDrive. If the drive doesn't have enough space, the extension raises an error message for this issue. | Free up the disk space to allow the extension to continue.|
| 12 | The extension can't create the tenant JSON configuration files if either the `Get-AzureStackHCI` or `Get-ClusterNode` cmdlet isn't available to retrieve the necessary information. | The extension uses the `Get-AzureStackHCI` and `Get-ClusterNode` cmdlets to identify parameters and retrieve information needed to create the tenant JSONs. If these cmdlets aren't present, the extension raises an error message with an indication that it can't proceed without them. | Complete the Azure Stack HCI registration step correctly. |
| 1 | An unhandled exception has occurred. | If an unhandled exception occurs, an error message is displayed. You can find the complete error message and its stack trace in the [Extension logs](legacy-collection-telemetry-extension.md#extension-artifacts) file. | Look at the generic error message and contact Microsoft Support. |

::: zone-end

## Next steps

Learn about [Azure Arc extension management on Azure Stack HCI](/azure-stack/hci/manage/arc-extension-management.md).
