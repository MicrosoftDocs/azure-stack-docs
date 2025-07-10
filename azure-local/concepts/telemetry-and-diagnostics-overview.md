---
title: Azure Local telemetry and diagnostics extension
description: This article describes the telemetry and diagnostics extension in Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.reviewer: shisab
ms.date: 10/22/2024

# CustomerIntent: As a content writer for Azure Local, I want to share viable information on the telemetry and diagnostics extension that will help users understand the feature and ways they can benefit from using it.
---
# Azure Local telemetry and diagnostics extension

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

This article provides a brief overview, benefits, and available options for the telemetry and diagnostics extension used for your Azure Local.

## About the extension

The Telemetry and Diagnostics Arc extension (shown as AzureEdgeTelemetryAndDiagnostics in the Azure portal) enables the collection of telemetry and diagnostics information from your Azure Local instance. This information helps Microsoft gain valuable insights into the system's behavior.

Use the telemetry and diagnostics extension to monitor and assess the performance, functionality, and overall health of your Azure Local. Microsoft can also use the diagnostics information from this extension to troubleshoot and address any potential issues in your system.

For more information, see [Azure Arc extension management on Azure Local](../manage/arc-extension-management.md#azure-managed-extensions-in-azure-local).

## Benefits

Some of the advantages of the telemetry and diagnostics extension include:

- **Improved compliance:** Enables the telemetry and diagnostics data to comply with regional service and data residency requirements during data uploads.
  
- **Simplified log gathering and faster case resolution:** Lets you easily collect diagnostics logs. These logs are used by Microsoft Support and engineering team to resolve any system issues quickly.

- **Reduced update impact:** Allows non-disruptive update of your Azure Local instance and doesn't require a reboot of the host machine.

- **Resource consumption controls:** Ensures that no more than 5% CPU is consumed. Control of the process is enforced via the Azure Arc extension framework.

## Telemetry and diagnostics settings

You maintain control over whether you send telemetry data to Microsoft, even after you've installed and run the telemetry extension.

To access the options to send telemetry data, follow these steps:

1. Go to your Azure Local resource in the Azure portal. In the left-pane, go to **Settings** and then select **Extensions**.

   :::image type="content" source="media/telemetry-and-diagnostics-overview/telemetry-diagnostics-extension-1.png" alt-text="Screenshot of the extension settings screen." lightbox="media/telemetry-and-diagnostics-overview/telemetry-diagnostics-extension-1.png":::

2. Choose one of the following options for sharing telemetry data:

   - **Off:** Select this option to not send system data to Microsoft.

   - **Basic:** Select this option to send Microsoft the minimum system data required to keep systems current, secure, and operating properly.

   - **Enhanced:** Select this option to send more system data to help Microsoft identify and fix operational issues and for product improvements. We strongly recommend that you enable **enhanced diagnostics**.

     Some of the benefits of enhanced data sharing include:

     - Retention of system data for up to a month.
     - Automatic capture of error and diagnostics information for speedier issue resolution. No operator intervention is required.

## Diagnostic data collection

To identify and fix issues with your Azure Local solution, you can collect and send diagnostic logs to Microsoft. To manually collect and send diagnostic logs to Microsoft, use the `Send-DiagnosticData` cmdlet from any Azure Local machine. We recommend that you use this cmdlet to upload diagnostic data before opening a support case.

For more information, see [Collect diagnostic logs](../manage/collect-logs.md).

## Data collection consent

Microsoft collects data in accordance with its [standard privacy practices](https://privacy.microsoft.com/). The new telemetry agent doesn't override your existing control setting.

If you withdraw your consent for data collection, any data collected before withdrawal isn't affected. Microsoft continues to handle and use the data collected in accordance with the terms that were in place at the time of the data collection.

Here are a couple of things to consider with data collection:

- Understand how Microsoft handles and uses your data. Review Microsoft's privacy practices and policies.

- Understand the implications of consenting to data collection and the withdrawal of consent. Consult with legal or privacy professionals to ensure complete understanding.

### Data privacy considerations

Azure Local routes system data back to a protected cloud storage location. Only Microsoft personnel with a valid business need are given access to the system data. Microsoft doesn't share personal customer data with third parties, except at the customer's discretion or for the limited purposes described in the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement). Data sharing decisions are made by an internal Microsoft team including privacy, legal, and data management stakeholders.

Don't include any confidential information or personal information in resource or file names. For example, VM names, volume names, configuration file names, storage file names (VHD names), or system resource names.

## Error handling

The following section discusses the error codes, messages and suggested resolution for any issues that you may experience with the telemetry and diagnostics extension:

### Error code 1

**Error message:** An unhandled exception has occurred.

**Cause:** If an unhandled exception occurs, an error message is displayed. You can find the complete error message and its stack trace in the Extension logs.

**Suggested resolution:** Check the generic error message and contact Microsoft Support. Collect the logs from the following path and provide these logs to Microsoft Support:
`C:\ProgramData\GuestConfig\extension_logs\Microsoft.AzureStack.Observability.TelemetrAndDiagnostics\ObservabilityExtension.log`.

### Error code 9

**Error message:** There's insufficient disk space available on the drive. To proceed with the extension installation, delete some files to free up space.

**Cause:** The extension validates as a pre-installation step and requires a minimum of 20 GB of space for the GMA cache on the system drive. If the drive doesn't have enough space, the extension raises an error message for this issue.

**Suggested resolution:** Free up the disk space to allow the extension to continue.

### Error code 12

**Error message:** The extension can't create the tenant JSON configuration files if either the `Get-AzureStackHCI` or `Get-ClusterNode` cmdlet isn't available to retrieve the necessary information.

**Cause:** The extension uses the `Get-AzureStackHCI` and `Get-ClusterNode` cmdlets to identify parameters and retrieve information needed to create the tenant JSONs. If these cmdlets aren't present, the extension raises an error message with an indication that it can't proceed without them.

**Suggested resolution:** Verify Azure Local registration.

## Next step

Learn about [Azure Arc extension management on Azure Local](../manage/arc-extension-management.md).
