---
title: Azure Stack HCI observability (preview)
description: Learn about observability in Azure Stack HCI.  (preview)
author: alkohli
ms.author: alkohli
ms.date: 11/17/2023
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Azure Stack HCI observability (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes observability in Azure Stack HCI and the data sources through which it is achieved.

[!INCLUDE [important](../../includes/hci-preview.md)]

## What is Azure Stack HCI observability?

Azure Stack HCI observability refers to the ability to monitor and understand the behavior of the Azure Stack HCI system.

Observability in Azure Stack HCI is important because it enables the collection of telemetry and diagnostic information from the system. This information helps Microsoft gain valuable insights into the system's behavior, which can be used to identify and fix potential problems.

Observability in Azure Stack HCI is achieved through the following data sources:

- **Telemetry.** This includes collection of telemetry and diagnostic information, which helps Microsoft gain valuable insights into the system's behavior. See [Telemetry](#telemetry).

- **Remote support.** This allows support engineers to get read-only remote access to clusters for first-step remediation. See [Remote support](#remote-support).

- **Diagnostics.** This includes the ability to collect diagnostic logs. See [Diagnostics](#diagnostics).

:::image type="content" source="media/observability/observability-components.png" alt-text="Diagram depicting the three data source types for Azure Stack HCI observability." lightbox="media/observability/observability-components.png":::

## How is observability installed?

Observability and remote support are installed as part of the Azure Stack HCI deployment process. This allows the [orchestrator](../update/whats-the-lifecycle-manager.md) automate many of the steps involved in the deployment process. The goal is to offer a simple setup process that takes care of all the components, including observability.

## Telemetry

Telemetry in Azure Stack HCI refers to the collection of data about the system's performance, functionality, and overall well-being. This data is collected through the Telemetry and Diagnostics extension, which enables the collection of telemetry and diagnostic information from the customer environment. See [Azure Stack HCI telemetry and diagnostics extension](./telemetry-and-diagnostics-overview.md).

Telemetry is important for Azure Stack HCI because it enables Microsoft to gain valuable insights into the system's behavior. This information can be used to improve the product, troubleshoot issues, and provide better support to customers. Telemetry data can also be used to proactively identify and mitigate potential issues, reducing the likelihood of downtime or other disruptions. Additionally, telemetry data can help Microsoft understand how customers are using Azure Stack HCI, which can inform future development and improvements to the product.

## Remote support

You can use remote support to allow a Microsoft support professional to solve your support case faster by permitting access to your device remotely and performing limited troubleshooting and repair. For instructions about how to get remote support, see [Get remote support for Azure Stack HCI](../manage/get-remote-support.md).

For remote support during the pre-deployment or pre-registration of your Azure Stack HCI cluster, see [Get remote support](../manage/troubleshoot-environment-validation-issues.md#get-remote-support).

## Diagnostics

Diagnostics in Azure Stack HCI helps identify and troubleshoot issues that may arise in the system. With the help of diagnostics, administrators can monitor the performance and health of their Azure Stack HCI environment and take proactive measures to prevent issues from occurring. Additionally, diagnostics can provide valuable insights into the behavior of the system, which can help optimize its performance and improve the overall user experience.

The following diagram illustrates various log collection methods in Azure Stack HCI.

:::image type="content" source="media/observability/log-collection.png" alt-text="Diagram showing different ways to collect diagnostic logs." lightbox="media/observability/log-collection.png":::

### Compare log collection methods

The following table provides a detailed comparison of different methods of log collection in Azure Stack HCI:

| Log collection method | Purpose | How to collect logs | Use cases |
|--|--|--|--|
| On-demand log collection | Manually collect and send diagnostic logs for Azure Stack HCI to Microsoft. | Use `Send-DiagnosticData` cmdlet from any Azure Stack HCI server node. <br> <br> Logs are temporarily copied locally, parsed, sent, and then deleted. <br> <br> For detailed instructions on how to perform on-demand log collection, see [Collect logs](../manage/collect-logs.md). | - Non-registration failures. <br> - Log collection request from Microsoft Support based on an open case. <br> - Log collection when a cluster is registered and connected. <br> - Log collection when the Observability components are installed and functional. <br> - Log collection when a cluster is partially registered. |
| Standalone log collection | Send diagnostic data to Microsoft if observability components are not deployed or if there are issues during the cluster registration process. | Save data locally and use `Send-AzStackHciDiagnosticData` command to send data to Microsoft. <br> <br> For detailed instructions on standalone log collections, see [Perform standalone log collection](../manage/get-support-for-deployment-issues.md#perform-standalone-log-collection). | - Deployment failures. <br> - Registration failures. <br> - Log collection request from Microsoft Support based on an open case. <br> - Log collection when a cluster is not registered and doesn't have connectivity. <br> - Log collection when a cluster is partially registered. <br> - Log collection when the Observability components are not available. |
| Proactive log collection | Automatically collect and deliver diagnostic logs to Microsoft before a support ticket is opened. In this method, the diagnostic data is gathered only when a system health alarm is triggered. | Automatically collects and sends log when a system health alarm is triggered. It requires Azure Stack HCI telemetry and diagnostics extension. <br> For information, see [Azure Stack HCI telemetry and diagnostics extension](./telemetry-and-diagnostics-overview.md). | Preemptive log collection for troubleshooting and issue resolution. |  
| Autonomous log collection | Collect and store logs locally for failure analysis by customer support in case of intermittent or no connectivity to Azure. In this method, logs are not sent to Azure. | Logs are collected and stored locally for analysis and no automatic sending to Azure occurs. | For failure analysis by customer support when there is intermittent or no connectivity to Azure. |

## Next steps

- [Azure Stack HCI telemetry and diagnostics extension](./telemetry-and-diagnostics-overview.md).