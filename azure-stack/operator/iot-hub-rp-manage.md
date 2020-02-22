---
title: How to manage IoT Hub on Azure Stack Hub
description: IoT Hub management experience and Alerts 
author: yiyiguo 
ms.author: yiygu 
ms.service: azure-stack
ms.topic: how-to
ms.date: 1/6/2020
---

# How to manage IoT Hub on Azure Stack Hub

The IoT Hub management experience allows you to visualize its status and alerts.

[![dashboard](media\iot-hub-rp-manage\dashboard.png)](media/iot-hub-rp-manage\dashboard.png#lightbox)

## Alerts

Currently, the IoT Hub resource provider supports the following alerts:

|Category|Alert|Type|Description|
|-|-|-|-|
|Performance|IoT Hub CPU usage needs attention.|Warning|The average of % CPU usage of IoT hub resource provider in the last 6 hours is over 75%.|
|Performance|IoT Hub memory usage needs attention.|Warning|The remaining memory usage of IoT Hub resource provider in the last 6 hours is less than 1024 MB.|
|Performance|Low disk space for IoT Hub resource provider.|Warning|The remaining disk space is less than 10%.|
|Resource|Creating or updating IoT Hub resource failed.|Warning|IoT Hub Resource Provider Create or Update IoT Hub Failure Count is no less than 1 in 15 minutes.|
|Service|IoT Hub resource provider log errors needs attention.|Warning|IoT Hub resource provider log failure count per role instance is more than 3 in 15 minutes.|
|Service|IoTHub-SU-InternalError|Warning|IoTHub SU Internal Failure and Timeout Count is no less than 5 in the last 30 minutes.|
|Service|IoT Hub data plane backup failure occurred.|Warning|IoT Hub data plane had backup failures during the past 15 minutes. Device data will not be protected.|
|Service|IoT Hub data plane consecutive backup failure has occurred.|Warning|IoT Hub data plane had consecutive backup failures during the past 15 minutes. Device data will not be protected.|
|Service|IoT Hub data plane no success backup failure occurred.|Warning|IoT Hub has no successful backup in last 3 hours. Your device data may not be protected.|
|Service|IoT Hub data plane restore failed.|Warning|IoT Hub device information restore failed. IotHubPerformanceMetrics exceeds threshold for the past 15 minutes.|
|Service|IoT Hub gateway failure occurred.|Warning|IoT Hub gateway failure occurred. Device telemetry functionality may be impacted.|
|Service|IoT Hub Container failure occurred.|Warning|IoT Hub container failure has occurred. Device authentication may fail. |
|Service|IoT Hub device management container failure occurred.|Warning|IoT Hub device management container failure has occurred. Device twin, direct method functionalities may be degraded.|

## Next steps

For more information on:

Azure Stack Hub monitoring capabilities, including alerting, refer to [Monitor Health and Alerts](azure-stack-monitor-health.md).

Azure Stack Hub log collection, see [Overview of Azure Stack diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md).