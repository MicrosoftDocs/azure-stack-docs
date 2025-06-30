---
title: Azure Local telemetry and diagnostics extension
description: This article describes the telemetry and diagnostics extension in Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.reviewer: shisab
ms.date: 06/18/2025
---
# Azure Local telemetry and diagnostics extension

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

This article provides a brief overview, benefits, and available options for the telemetry and diagnostics extension used for your Azure Local.

## About the extension

The Telemetry and Diagnostics Arc extension, shown as AzureEdgeTelemetryAndDiagnostics in the Azure portal, enables the collection of telemetry and diagnostics information from your Azure Local instance. This data provides Microsoft with valuable insights into the system's behavior.

:::image type="content" source="../concepts/media/telemetry-and-diagnostics-overview/telemetry-diagnostics-extension-1.png" alt-text="Screenshot of the Telemetry and Diagnostics extension in the Azure portal." lightbox="../concepts/media/telemetry-and-diagnostics-overview/telemetry-diagnostics-extension-1.png":::

Use the telemetry and diagnostics extension to monitor and assess the performance, functionality, and overall health of your Azure Local environment. The diagnostic information collection through this extension helps Microsoft more effectively troubleshoot and address any potential issues in your system.

For more information, see [Azure Arc extension management on Azure Local](../manage/arc-extension-management.md#azure-managed-extensions-in-azure-local).

### Test observability

Test Observability is a feature designed to diagnose issues related to the telemetry and diagnostics extension. This feature ensures the proper functionality of the data transmission pipeline to Microsoft. It validates the existence and accuracy of configuration files, checks the status of relevant services, and confirms endpoint connectivity.

Here's sample output:

```output
Test-Observability Report 
Overall Result: PASS
General Information
GCSEnvironment:                   DiagnosticsPROD
GCSGenevaAccount:                 AzureEdgeObsPPE
GCSNamespace:                     AEOppeDiag
AEOAssemblyBuild:                 99.9999.0.2
AEOClusternodeName:               V-HOST1
AEONodeid:                        cluster-test1
AEOClusterNodeARCResourceUri:     /Subscription/<subscriptionid>/
AEODeviceArmResourceUri:          /Subscription/<subscriptionid>/
AEORegion:                        westeurope
AEOStampid:                       cluster-test1
AEOClusterName:                   my-cluster
AEOOSBuild:                       10.0.25398.763
Test Name: TestTenantJSON
Overall Result: PASS 
Has Repair Action: No 
Repair Description: N/A
```

## Benefits

Some of the advantages of the telemetry and diagnostics extension include:

- **Improved compliance:** Enables the telemetry and diagnostics data to comply with regional service and data residency requirements during data uploads.
  
- **Simplified log gathering and faster case resolution:** Lets you easily collect diagnostics logs. These logs are used by Microsoft Support and engineering team to resolve any system issues quickly.

- **Reduced update impact:** Allows nondisruptive update of your Azure Local instance and doesn't require a reboot of the host machine.

- **Resource consumption controls:** Ensures that no more than 5% CPU is consumed. Control of the process is enforced via the Azure Arc extension framework.

## Prerequisites

To use the telemetry and diagnostics extension, you must have:

- An Azure Local instance deployed and running.

## Data collection consent

Microsoft collects data in accordance with its [standard privacy practices](https://privacy.microsoft.com/). The new telemetry agent doesn't override your existing control setting.

If you withdraw your consent for data collection, any data collected before withdrawal isn't affected. Microsoft continues to handle and use the data collected in accordance with the terms that were in place at the time of the data collection.

Here are a couple of things to consider with data collection:

- Understand how Microsoft handles and uses your data. Review Microsoft's privacy practices and policies.

- Understand the implications of consenting to data collection and the withdrawal of consent. Consult with legal or privacy professionals to ensure complete understanding.

### Data privacy considerations

Azure Local routes system data back to a protected cloud storage location. Only Microsoft personnel with a valid business need are given access to the system data. Microsoft doesn't share personal customer data with third parties, except at the customer's discretion or for the limited purposes described in the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement). Data sharing decisions are made by an internal Microsoft team including privacy, legal, and data management stakeholders.

Don't include any confidential information or personal information in resource or file names. For example, VM names, volume names, configuration file names, storage file names (VHD names), or system resource names.

## Diagnostic data collection

To identify and fix issues with your Azure Local solution, you can collect and send diagnostic logs to Microsoft using one of the following methods:

- `Send-DiagnosticData`
- The Azure portal

To manually collect and send diagnostic logs to Microsoft, use the `Send-DiagnosticData` cmdlet from any Azure Local machine. We recommend that you use this cmdlet to upload diagnostic data before opening a support case.

For more information, see [Collect diagnostic logs](../manage/collect-logs.md).

To collect and send diagnostic logs to Microsoft using the Azure portal, follow these steps:

1. In the Azure portal, navigate to your Azure Local instance.
1. In the left pane, under **Settings**, select **Diagnostics and Remote Support**.
1. Select **Send logs**.
1. In the Diagnostics pane, set your **Log start time** and **Log end time**.
1. Click the **Collect and upload logs** button.

:::image type="content" source="../concepts/media/telemetry-and-diagnostics-overview/send-logs-azure-portal.png" alt-text="Screenshot of the steps to collect and send diagnostics logs via the Azure portal." lightbox="../concepts/media/telemetry-and-diagnostics-overview/send-logs-azure-portal.png":::

## Support operations

You can grant remote access to Microsoft support by using remote support operations. After enabling remote support, assign a specific access level to Microsoft support based on your requirements. For more information, see [Enable remote support diagnostics](../manage/get-remote-support.md#enable-remote-support-diagnostics) and the [List of Microsoft support operations](../manage/remote-support-arc-extension.md#list-of-microsoft-support-operations).

## Next step

Learn about [Azure Arc extension management on Azure Local](../manage/arc-extension-management.md).
