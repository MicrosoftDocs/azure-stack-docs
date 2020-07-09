---
title: Telemetry and diagnostic data collection in Azure Stack HCI
description: An overview of the telemetry and diagnostic data collected by the Azure Stack HCI operating system and billing service, and how to control what data Microsoft collects.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.date: 07/09/2020
---

# Why does Azure Stack HCI collect telemetry and diagnostic information?

> Applies to Azure Stack HCI v20H2, Azure Stack HCI

Azure Stack HCI records telemetry and diagnostic information for billing purposes, for software updates, to improve systems stability, and to inform our decisions and focus our efforts in providing the most robust, most valuable HCI platform. This topic explains the telemetry we collect, the benefits, and how to change the diagnostic data levels. For information on diagnostic data collected by Windows Server, see [Configure Windows diagnostic data in your organization](/windows/privacy/configure-windows-diagnostic-data-in-your-organization).

## What telemetry and diagnostic data does Azure Stack HCI collect, and where does it go?

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

## How does Microsoft collect and handle personally identifiable information (PII)?

Microsoft collects data from you through our interactions with you and through our products. You provide some of this data directly, and we get some of it by collecting data about your interactions, use, and experiences with our products. The data we collect depends on the context of your interactions with Microsoft and the choices you make, including your privacy settings and the products and features you use. We also obtain data about you from third parties.

For more information about data privacy, see [Privacy at Microsoft](/privacy).

## Next steps

For related information, see also:

- [Diagnostic Data Viewer for PowerShell Overview](/windows/privacy/microsoft-diagnosticdataviewer)
- [Overview of Azure Cost Management and Billing](/azure/cost-management-billing/cost-management-billing-overview)
