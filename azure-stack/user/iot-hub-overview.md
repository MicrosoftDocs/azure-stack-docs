---
title: Overview of IoT Hub on Azure Stack Hub
description: Learn about the IoT Hub resource provider on Azure Stack Hub.
author: yiyiguo 
ms.author: yiygu 
ms.service: azure-stack
ms.topic: how-to
ms.date: 12/12/2019 
---

# Overview of IoT Hub on Azure Stack Hub

[!INCLUDE [preview-banner](../includes/iot-hub-preview.md)]

IoT Hub on Azure Stack Hub allows you to create hybrid IoT solutions. IoT Hub is a managed service, acts as a central message hub for bi-directional communication between your IoT application and the devices it manages. You can use IoT Hub on Azure Stack Hub to build IoT solutions with reliable and secure communications between IoT devices and a on-prem solution backend.

## Features

| Feature | IoT Hub on Azure | IoT Hub on Azure Stack Hub preview (S2/S3) |
|-|-|-|
|Device-to-cloud telemetry| ✔ | ✔ |
|Cloud-to-device messaging| ✔ | ✔ |
|Per-device identity| ✔ | ✔ |
|Message routing <sub>1</sub>,<sub>4</sub>| ✔ | ✔ |
|HTTP, AMQP, MQTT protocols| ✔ | ✔ |
|Multi-tenancy| ✔ | ✔ |
|Monitoring and diagnostics| ✔ | ✔ |
|Cloud-to-device messaging| ✔ | ✔ |
|Device management, device twin, module twin| ✔ | ✔ |
|Twin notifications, device life cycle events| ✔ | ✔ |
|Edge layered deployment| ✔ | coming |
|Administrator portal <sub>2</sub>| ✘ | ✔ |
|Secret rotation <sub>2</sub>| ✘ | ✔ |
|Capacity management <sub>2</sub>| ✘ | ✔ |
|Backup & restore <sub>3</sub>| ✘ | ✘ |
|DeviceConnected, DeviceDisconnected, ASC <sub>4</sub>| ✔ | ✘ |
|Device module configuration| ✔ | coming |
|Device streaming, IoT plug and play, jobs, file upload <sub>5</sub>| ✔ | ✘ |
|Monitor device connection state using Event Grid <sub>4</sub>| ✔ | ✘ |
|Failover <sub>6</sub>| ✔ | ✘ |

<sub>1</sub> Limited to built-in endpoints, Event Hubs and Storage. Service Bus is not available on Azure Stack Hub.  
<sub>2</sub> For operators to manage IoT Hub on ASH.  
<sub>3</sub> Backup is available in preview release. Restore will be supported in GA.  
<sub>4</sub> Depends on other services that are not available on Azure Stack Hub.  
<sub>5</sub> In the roadmap to bring to Azure Stack Hub.  
<sub>6</sub> Not applicable on Azure Stack Hub.  

## API available for IoT Hub on Azure Stack Hub

|APIs|IoT Hub on Azure Stack Hub|
|-|-|
|Apply Configuration On Device| ✔ |
| Configuration Create | ✔ |
| Configuration Delete | ✔ |
| Configuration Read | ✔ |
|Configuration Read Many| ✔ |
|Configuration Service Apply|  ✔ |
|Configuration Update|  ✔ |
|Device Direct Invoke Method|  ✔ |
|GetDeviceAndModuleInScope|  ✔ |
|GetDevicesAndModulesInScope| ✔ |
|Unregister Device| ✔ |
|Get Devices| ✔ |
|Update Module Twin| ✔ |
|D2C Get Twin| ✔ |
|Import Devices| ✔ |
|Get Twin| ✔ |
|Unregister Module| ✔ |
|Update Device| ✔ |
|Update Module| ✔ |
|Query Devices| ✔ |
|Export Devices| ✔ |
|Back up and Restore – ADM| ✔ |
|Replace Twin| ✔ |
|Back up and Restore – DSS| ✔ |
|D2C Notify DesiredProperties| ✔ |
|D2C Patch ReportedProperties| ✔ |
|Get Module Twin| ✔ |
|Module D2C Get Twin| ✔ |
|Get Module| ✔ |
|Module D2C Notify DesiredProperties| ✔ |
|Module D2C Patch ReportedProperties| ✔ |
|Module Direct Invoke Method| ✔ |
|Update Twin| ✔ |
|Bulk Device Operations| ✔ |
|Device to Cloud Telemetry| ✔ |
|Register Device| ✔ |
|Register Module| ✔ |
|Replace Module Twin| ✔ |
|GenericAuthentication| ✔ |
|Get Device| ✔ |
|Partition Move/Role Change| ✔ |

## Differences between IoT Hub on Azure Cloud and IoT Hub on Azure Stack

| Aspect | IoT Hub on Cloud | IoT Hub on Stack |
|-|-|-|
| Message Consumption | https://docs.microsoft.com/azure/iot-hub/iot-hub-devguide-messages-read-builtin |By default, messages are routed to the built-in service-facing endpoint (messages/events) that is compatible with Event Hubs. On Azure cloud, you can access the messages from the end point by providing either IoT Hub connection string or Event Hub connection string. However, on Azure Stack hub, only event hub connection string is supported. |

## Next Steps

To learn how to use IoT Hub, refer to [the Azure IoT Hub documentation](/azure/iot-hub/).

