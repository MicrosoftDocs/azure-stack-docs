---
title: Azure Stack HCI observability
description: Learn about observability in Azure Stack HCI.
author: alkohli
ms.author: alkohli
ms.date: 10/27/2023
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Azure Stack HCI observability

This article describes observability in Azure Stack HCI and the data sources through which it is achieved.

> Applies to: Azure Stack HCI, versions 23H2 (preview) and 22H2

## What is Azure Stack HCI observability?

Azure Stack HCI observability refers to the ability to monitor and understand the behavior of the Azure Stack HCI system.

Azure Stack HCI observability provides valuable tools for monitoring and understanding the behavior of the system, enabling faster and more efficient support and troubleshooting. Observability in Azure Stack HCI is achieved through the following data sources:

- **Telemetry.** This includes collection of telemetry and diagnostic information, which helps Microsoft gain valuable insights into the system's behavior. The Azure Stack HCI telemetry and diagnostics extension, enables the collection of this information.

- **Remote support.** This allows support engineers to get read-only remote access to clusters for first-step remediation.

- **Diagnostics.** This includes the ability to collect diagnostic logs, either manually or proactively. Manual log collection can be initiated on the device by an operator, while proactive log collection is a one-time enablement and allows the device to monitor its own health and send log collections to Microsoft proactively.

:::image type="content" source="media/observability/observability-components.png" alt-text="Diagram depicting the three data source types for Azure Stack HCI observability." lightbox="media/observability/observability-components.png":::

## Why is Azure Stack HCI observability important?

Observability is important for Azure Stack HCI because it allows for the collection of telemetry and diagnostic information from the system. This information helps Microsoft gain valuable insights into the system's behavior, which can be used to identify and fix potential problems.

## How is observability installed?

Observability and remote support are installed as part of the Azure Stack HCI deployment process. This is done through the [Lifecycle Manager](../update/whats-the-lifecycle-manager.md), which automates many of the steps involved in the deployment process. The goal is to offer a simple setup process that takes care of all the components, including observability. This can be verified in the action plan, please make sure the following steps have been completed.

- Observability volume  

- Register observability

- Setup observability volume

- Create observability subfolders and volume pruner

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

The following table provides a detailed comparison of different methods of log collection in Azure Stack HCI:

| Log collection method | Purpose | How to collect logs | Use cases |
|--|--|--|--|
| Manual log collection | Manually collect and send diagnostic logs for Azure Stack HCI to Microsoft. | Use `Send-DiagnosticData` cmdlet from any Azure Stack HCI server node. <br> <br> Logs are temporarily copied locally, parsed, sent, and then deleted. <br> <br> For detailed instructions on how to collect logs manually, see [Collect logs](../manage/collect-logs.md). | - Non-registration failures. <br> - Log collection request from Microsoft Support based on an open case. <br> - Log collection when a cluster is registered and connected. <br> - Log collection when the Observability components are installed and functional. <br> - Log collection when a cluster is partially registered. |
| Standalone log collection | Send diagnostic data to Microsoft if observability components are not deployed or if there are issues during the cluster registration process. | Save data locally and use `Send-AzStackHciDiagnosticData` command to send data to Microsoft. <br> <br> For detailed instructions on standalone log collections, see [Perform standalone log collection](../manage/troubleshoot-environment-validation-issues.md#perform-standalone-log-collection). | - Deployment failures. <br> - Registration failures. <br> - Log collection request from Microsoft Support based on an open case. <br> - Log collection when a cluster is not registered and doesn't have connectivity. <br> - Log collection when a cluster is partially registered. <br> - Log collection when the Observability components are not available. |
| Proactive log collection | Automatically collect and deliver diagnostic logs to Microsoft before a support ticket is opened. In this method, the diagnostic data is gathered only when a system health alarm is triggered. | Automatically collects and sends log when a system health alarm is triggered. It requires Azure Stack HCI telemetry and diagnostics extension. <br> For information, see [Azure Stack HCI telemetry and diagnostics extension](./telemetry-and-diagnostics-overview.md). | Preemptive log collection for troubleshooting and issue resolution. |  
| Autonomous log collection | Collect and store logs locally for failure analysis by customer support in case of intermittent or no connectivity to Azure. In this method, logs are not sent to Azure. | Logs are collected and stored locally for analysis and no automatic sending to Azure occurs. | For failure analysis by customer support when there is intermittent or no connectivity to Azure. |

## Next steps

- [Azure Stack HCI telemetry and diagnostics extension](./telemetry-and-diagnostics-overview.md)