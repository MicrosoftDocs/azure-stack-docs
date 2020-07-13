---
title: Telemetry and diagnostic data collection in Azure Stack HCI
description: An overview of the telemetry and diagnostic data collected by the Azure Stack HCI operating system and billing service, and how to control what data Microsoft collects.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.date: 07/21/2020
---

# Telemetry in Azure Stack HCI

> Applies to Azure Stack HCI v20H2, Azure Stack HCI

Like Windows Server, Azure Stack HCI includes the Connected User Experiences and Telemetry component, which uses Event Tracing for Windows (ETW) tracelogging technology that gathers and stores diagnostic data events and data.

## Why does Azure Stack HCI collect data?

Azure Stack HCI records itw own telemetry along with the standard [diagnostic data collected by Windows Server](/windows/privacy/configure-windows-diagnostic-data-in-your-organization). This data is used for billing purposes, for software updates, to improve stability, and to inform our decisions and focus our efforts in providing the most robust, most valuable HCI platform. This topic explains the data we collect, the benefits, and how to change the diagnostic data levels.

## What diagnostic data does Azure Stack HCI collect, and where does it go?

The following table lists the Azure Stack HCI telemetry function descriptions and the corresponding endpoints to which telemetry and diagnostic data are transmitted.

| Endpoint                                 | Function                                                                                                           |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| setting-win.data.microsoft.com           | Cloud configuration endpoint for UTC/DiagTrack/Feedback Hub                                                        |
| ctrdl.windowsupdate.com                  | Windows Update to automatically check the list of trusted authorities to see if an update is available             |
| *.events.data.microsoft.com              | UTC/DiagTrack/WER/Aria endpoints                                                                                   |
| sls.update.microsoft.com                 | Used for getting updates from Windows Update internet locations                                                    |
| *.update.microsoft.com                   | Windows Update                                                                                                     |
| *delivery.mp.microsoft.com               | Enable connections to Windows Update, Microsoft Update, and the online services of the Store                       |
| *.download.windowsupdate.com             | Accessed exclusively by Windows Update when trying to update the system                                            |
| www.microsoft.com/pkiops/certs/*         | Certificate downloads                                                                                              |
| *.prod.do.dsp.mp.microsoft.com           | Delivery optimization service                                                                                      |
| *.emdl.ws.microsoft.com                  | Delivery optimization metadata                                                                                     |
| tsfe.trafficshaping.dsp.mp.microsoft.com | Used for download content regulation                                                                               |
| www.msftconnecttest.com*                 | Network Connection Status Indicator (NCSI) detects internet connectivity and corporate network connectivity status |
| wdcp.microsoft.com                       | Used for Windows Defender when cloud-based protection is enabled                                                   |
| watson.telemetry.microsoft.com           | Windows Error Reporting (WER)                                                                                      |
| watson.microsoft.com                     | Windows Error Reporting (WER)                                                                                      |
| *watcab02.blob.core.windows.net          | Windows Error Reporting (WER)                                                                                      |
| oca.telemetry.microsoft.com              | Online Crash Analysis (OCA)                                                                                        |
| oca.microsoft.com                        | Online Crash Analysis (OCA)                                                                                        |
| *-azurestackhci-usage.azurewebsites.net  | Azure Stack HCI billing                                                                                            |
| *-azurestackhci-rp.azurewebsites.net     | Azure Stack HCI resource provider                                                                                  |

## What properties are available for Azure Stack HCI clusters?

The following table list the properties reported by Azure Stack HCI clusters.

| Property       | Description                                                          |
| -------------- | -------------------------------------------------------------------- |
| clusterId      | Unique id generated by the on-prem cluster                           |
| clusterVersion | Version of the cluster software                                      |
| nodes          | Array of nodes reported by the cluster                               |
| lastUpdated    | Last time the cluster reported the data                              |
| nodeId         | ID/node #                                                            |
| manufacturer   | Manufacturer of the cluster node hardware                            |
| model          | Model name of the cluster node hardware                              |
| osName         | Operating system running on the cluster node                         |
| osVersion      | Version of the operating system running on the cluster node          |
| serialNumber   | Immutable ID of the cluster node                                     |
| hardwareId     | SECRET - Immutable ID of the cluster node hardware                   |
| coreCount      | Number of physical processor cores on the cluster node (for billing) |
| memoryInGiB    | Total available memory on the cluster node                           |

## How does Microsoft collect and handle personally identifiable information (PII)?

Microsoft collects data from you through our interactions with you and through our products. You provide some of this data directly, and we get some of it by collecting data about your interactions, use, and experiences with our products. The data we collect depends on the context of your interactions with Microsoft and the choices you make, including your privacy settings and the products and features you use. We also obtain data about you from third parties.

For more information about data privacy, see [Privacy at Microsoft](/privacy).

## Next steps

For related information, see also:

- [Diagnostic Data Viewer for PowerShell Overview](/windows/privacy/microsoft-diagnosticdataviewer)
- Azure Stack HCI Billing and Payment
