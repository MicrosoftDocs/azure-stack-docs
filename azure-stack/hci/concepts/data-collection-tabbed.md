---
title: Azure Stack HCI telemetry and diagnostics.
description: This topic describes the design and policies associated with diagnostic data collected by Azure Stack HCI.
author: ronmiab
ms.author: robess
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/10/2023
zone_pivot_groups: telemetry-diagnostics-data-collection
---

# Azure Stack HCI telemetry and diagnostics (preview)

::: zone pivot="legacy-collection"

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

This topic describes required data collected to keep Azure Stack HCI secure, up to date, and working as expected.

::: zone-end

::: zone pivot="extension-collection"

> Applies to: Azure Stack HCI, versions 22H2 and 21H2.

This article describes the telemetry and diagnostics extension in Azure Stack HCI.

::: zone-end

::: zone pivot="legacy-collection"

Customer data, including the names, metadata, configuration, and contents of your on-premises virtual machines (VMs) is never sent to the cloud unless you turn on additional services like Azure Backup or Azure Site Recovery, or unless you enroll those VMs individually into cloud management services like Azure Arc.

We do collect diagnostic data. The data described below is required for Microsoft to provide Azure Stack HCI. This data is collected once a day, and data collection events can be viewed in the event logs. Azure Stack HCI collects the minimum data required to keep your clusters up to date, secure, and operating properly.

   > [!IMPORTANT]
   > The data described below that Azure Stack HCI collects is independent from Windows diagnostic data, which can be configured for various levels of collection. In Azure Stack HCI, the default setting for Windows diagnostic data collection is Security (off), meaning that no Windows diagnostic data is sent unless the administrator changes the diagnostic data settings. For more information, see [Configure Windows diagnostic data in your organization](/windows/privacy/configure-windows-diagnostic-data-in-your-organization). Microsoft is an independent controller of any Windows diagnostic data collected in connection with Azure Stack HCI. Microsoft will handle the Windows diagnostic data in accordance with the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement).

## Data collection and residency

This Azure Stack HCI data:

- is not sent to Microsoft until the product is registered with Azure. When Azure Stack HCI is unregistered, this data collection stops.
- is logged to the Microsoft-AzureStack-HCI/Analytic event channel.
- is in JSON format, so that system administrators can examine and analyze the data being sent.
- is stored within the United States in a secure Microsoft-operated datacenter.

To learn about how Microsoft stores diagnostic data in Azure, see [Data residency in Azure](https://azure.microsoft.com/global-infrastructure/data-residency/).

## Data retention

After Azure Stack HCI collects this data, it is retained for 90 days. Aggregated, de-identified data may be kept longer.

## What data is collected?

Azure Stack HCI collects:

- Information about servers such as operating system version, processor model, number of processor cores, memory size, cluster identifier, and hash of hardware ID
- List of installed Azure Stack HCI server features (e.g. BitLocker)
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

## View this data

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

Telemetry and diagnostics, an ARC extension designed to set up a Geneva based observability pipeline, is the extension that allows Microsoft to collect logs and telemetry data from all the nodes in a stamp cluster in the Azure Stack HCI environment. The telemetry and diagnostics extension is an important tool used to monitor and troubleshoot the functionality of stamp clusters in the Azure Stack HCI environment.

The extension is a mandatory part for both new (green field) and existing (brown field) stamps in Azure Stack HCI, and the Azure Stack HCI RP Team manages the lifecycle of the extension.

## Benefits of the telemetry and diagnostics extension

Azure Stack HCI has always reported telemetry data to Microsoft. Previously, the component responsible for sending telemetry was part of the operating system. Now, Azure Arc installs and manages sending telemetry; it's no longer part of the operating system.

Here are some of the advantages of the extension:

- **Improved transparency:** Supplies the extensions name, version, and status directly in the Azure portal.

- **Resource consumption controls:** Automatically throttled to consume no more than 5% CPU (the expected amount is much less), and control of the process is enforced via the Azure Arc extension framework.

- **Reduced update impact:** The telemetry piece updates non-disruptively and changes don't require a reboot of the host server.

  - When available you can manage changes from the Azure portal.
  
  - Changes allow Microsoft to seamlessly update the environment with new or improved functionality, when applicable.

- **Improved compliance:** Allows the telemetry and diagnostic data to be compliant with data uploads as per regional service and data residency requirements.
  
  - Cloud assets are allocated to support regional boundaries and the resources become redundant within the regions.

- **Simplified log gathering:** It's easier to collect diagnostics logs when the functionality to collect the logs is readily available on the stamp.

  - With the proactive log collection functionality enabled, Microsoft can help look for certain errors or exception patterns, and collect logs proactively, thereby saving support time.

## Telemetry and diagnostics extension management

When you have installed and run the telemetry extension, you can still retain control over whether you send telemetry data to Microsoft. To access the control, go to your cluster **Settings** in Azure portal and select **Extensions**.

:::image type="content" source="media/telemetry-diagnostics/telemetry-diagnostics-extension-2.png" alt-text="Screenshot of the extension settings screen." lightbox="media/telemetry-diagnostics/telemetry-diagnostics-extension-2.png":::

You can configure the extension to be:

- **Off:** You don't send diagnostics data to Microsoft.

- **Basic:** You send the minimum diagnostic data required to keep clusters current, secure, and operating properly.

- **Enhanced:** You send more diagnostic data to help Microsoft identify and fix operational issues and for product improvements. Diagnostics data might remain for up to 30 days.

Basic diagnostics data shares minimum pieces of data back to Microsoft. For more information, see [Data collected](../manage/telemetry-diagnostics-extension.md#data-collected).

It's highly recommended that you enable **enhanced diagnostics**. The enhanced function allows the product team to diagnose problems due to failure events and improve the quality of the product. It captures logs with the correct error conditions and ensures it collects the correct diagnostic information, at the right time, without the need for any operator interaction. Microsoft can begin to troubleshoot and resolve problems sooner in some cases.

The new telemetry agent respects the same control as before. If you have already chosen these settings before you installed the extension, they still apply, and you don't need to set them again. In other words, the telemetry extension doesn't override your existing control over telemetry data sent to Microsoft.

Microsoft collects data in accordance with its standard privacy practices. If you decide to revoke your consent for data collection any data collected, with your consent, before revocation isn't affected. Microsoft continues to handle and use the data collected, in accordance with the terms that were in place at the time of the data collection.

Here are a couple of things you might want to consider with data collection:

- A review of Microsoft's privacy practices and policies to understand how Microsoft handles and uses your data.

- A consultation with legal or privacy professionals to ensure that they fully understand the implications of consenting to data collection and the revocation of consent.

## Telemetry and diagnostics workflow

A registered Azure Stack HCI device has an ARC (Azure Arc Connected) machine agent installed on it. This extension runs in the local system context, which gives it the necessary permissions to install the Geneva Monitoring Agent (GMA) on all cluster nodes. The GMA extension relies on the ARC agent's Instance Metadata Service (IMDS) to install and configure itself.

After you've configured the extension, it can continue to function even if the ARC agent fails for any reason. Meaning the extension only requires the ARC agent installation initially, and it can continuously operate even if the agent isn't running.

> [!NOTE]
> This extension installs the Geneva Monitoring Agent on all the cluster nodes.

### Flow of events

1. When you trigger the extension installation, the installation, and Watchdog Service start.

    - The purpose of the Watchdog Service is to monitor the GMA process and ensure that it runs as expected.

    - The Watchdog Service periodically checks the status of the GMA process and takes appropriate action if it detects any issues or errors. For example, if the GMA process stops running or becomes unresponsive, the Watchdog Service attempts to restart the process automatically or triggers a notification alert.

    - The Watchdog Service helps improve the reliability and availability of the extension and supports the smooth operation of stamp clusters in the Azure Stack HCI environment.

2. The installation creates a tenant JSON for telemetry and diagnostics.

    - The JSON file contains information about the identity parameters of the stamp cluster, such as the Azure Resource Manager (ARM) resource URI and Stamp ID, to help identify which stamp the data belongs to.

    - To obtain these identity parameters, the installation process uses the `Get-AzureStackHCI` cmdlet. This cmdlet retrieves information about the Azure Stack HCI environment, including details about the stamp cluster.

3. The GMA process starts.

4. A scheduled task during installation runs every hour to fetch the telemetry status from the `Get-AzureStackHCI` cmdlet.

    - The purpose of this task is to ensure that the telemetry configuration is up-to-date and accurate based on the current telemetry status. Based on this telemetry status, the extension either adds or removes telemetry configuration from the JSON drop location.

    - This task is useful in situations where you might change your mind about whether to enable or disable telemetry. For example, if you initially consent to telemetry but later decide to disable it, the scheduled task detects your change. It then updates the telemetry configuration to ensure respect for your telemetry preferences and makes sure the extension only collects telemetry data when explicitly authorized to do so.

5. Scheduled tasks download updated events from the Geneva configuration at regular intervals.

6. The collection of telemetry events starts. Collected events get sent to the Geneva accounts or namespace.

## Extension artifacts

As part of the extension installment, artifacts generated from your cluster node are created on the stamp. Here's a description of the artifact names and locations.

|Artifact Name     | Location                                                                   |
|------------------|----------------------------------------------------------------------------|
| Extension        |C:\Packages\Plugins\Microsoft.AzureStack.Observability.TelemetrAndDiagnostics\<Version#>\                                                              |
| Extension logs   |C:\ProgramData\GuestConfig\extension_logs\Microsoft.AzureStack.Observability.TelemetrAndDiagnostics\ObservabilityExtension.log                                               |
|GMA process logs  |SystemDrive\GMACache                                                        |
| Diagnostics logs |SystemDrive\Observability                                                   |

## Error handling

To handle errors in extensions, we have identified specific code paths for expected errors and have provided error messages with unique error codes.

Here are some examples from that list:

| Error Code | Error Message | Description | Mitigation Steps |
|------------|---------------|-------------|------------------|
| 7 | There's at least one GMA process already running on the stamp. To proceed with the extension installation, shut down the relevant processes. | During the extension installation, you can't run  other GMA processes on the stamp. The extension raises an error message. | Remove the other GMA processes and then continue. `Get-Process MonitoringAgent`. |
| 9 | There's insufficient disk space available on the drive. To proceed with the extension installation, delete some files to free up space. | The extension validates as a pre-installation step and requires a minimum of 20 GB of space for the GMA cache on the SystemDrive. If the drive doesn't have enough space, the extension raises an error message for this issue. | Free up the disk space to allow the extension to continue.|
| 12 | If either the `Get-AzureStackHCI` or `Get-ClusterNode` cmdlet isn't available to retrieve the necessary information, the extension can't create the tenant JSON configuration files. | The extension uses the `Get-AzureStackHCI` and `Get-ClusterNode` cmdlets to retrieve the information needed to create the tenant JSONs, specifically for identity parameters. If these cmdlets aren't present, the extension raises an error message with an indication that it can't proceed without them. | Complete the Azure Stack HCI registration step correctly. |
| 1 | An unhandled exception has occurred. | If an unhandled exception occurs, an error message displays. You can find the complete error message and its stack trace in the [Extension logs](../manage/telemetry-diagnostics-extension.md#extension-artifacts) file. | Look at the generic error message and contact Microsoft Support. |

## Data Collected

Here's a list of details collected and shared back to Microsoft with the basic option enabled. This list is subject to change, check back for updates.

- Information about servers such as operating system version, processor model, number of processor cores, memory size, cluster identifier, and hash of hardware ID.
- List of installed Azure Stack HCI server features (for example, BitLocker).
- Information necessary to compute the reliability of the Azure Stack HCI operating system.
- Information necessary to compute the reliability of the health collection data.
- Information gathered from the event log for specific errors, such as update download failed.
- Information for computing storage reliability.
- Information for computing physical disk reliability.
- Information for computing the reliability of volume encryption.
- Information for computing the reliability and performance of Storage Spaces repair.
- Information to validate security of the Azure Stack HCI operating system.
- Information to compute reliability of the antivirus/antimalware state of the Azure Stack HCI operating system.
- Information to correlate reliability of the networking components.
- Information to correlate networking performance.
- Information to correlate reliability of updates and installations.
- Information to measure reliability of Hyper-V.
- Information to measure/correlate reliability of the clustering components.
- Information to track the success of the Cluster Aware Updating (CAU) feature.
- Information to measure/correlate the reliability of the Disaster Recovery feature.
- Information to describe the SMB bandwidth limits applied to Azure Stack HCI servers.
- Information about SMB and NFS share configuration.
- Information about Action plan status.
- Information about OS update.
- Information about environment validator.
- Information about windows UTC events.
- Information about OS process performance.
- Information about Hyper-V process performance.
- Information about StorageSpaces process performance.
- Information about Network Adapter performance.
- Information about NUMA Node performance.
- Information about CSV process performance from OS Cluster
- Information about Cluster Storage process performance from OS Cluster Storage.
- Information about OEM setup completion telemetry.
- Information about deployment status.
- Information about VM Network Performance counters for each VM on each host.
- Information about the health agent.
- Information about cluster registration details.
- Information about WAC.
- Information about Update status.

::: zone-end
