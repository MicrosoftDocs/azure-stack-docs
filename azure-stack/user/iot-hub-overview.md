---
title: IoT Hub on Azure Stack Hub overview
description: Learn about the IoT Hub resource provider on Azure Stack Hub.
author: yiyiguo 
ms.author: yiygu 
ms.service: azure-stack
ms.topic: how-to
ms.date: 12/12/2019 
---

# IoT Hub on Azure Stack Hub overview

IoT Hub on Azure Stack Hub allows you to create hybrid IoT solutions. IoT Hub is a managed service, acts as a central message hub for bi-directional communication between your IoT application and the devices it manages. You can use IoT Hub on Azure Stack Hub to build IoT solutions with reliable and secure communications between IoT devices and a on-prem solution backend.

## Features
| Feature | IoT Hub on Azure Stack Hub | IoT Hub on Azure Cloud |
|-|-|-|-|
| Operator administrator experience | ✔ | ✘ |
| Multi-tenancy | ✔ | ✔ |
| Integrated deployment with Marketplace | ✔ | ✔ |
| IoT Services Updating |✘ | ✔ |
| CLI and POSH support  | ✘| ✔ |
| Multi-scale unit |✘ | ✔|
| Admin Support Operations |✘ | ✔ |
| Device Provisioning Service (DPS) Support |✘ | ✔ |
| Billing |✘ | ✔ |
| Manual Fail-over | ✘| ✔ |
| Per Device Identity | ✔ | ✔ |
| Device-to-cloud telemetry | ✔ | ✔ |
| Cloud-to-device messaging | ✘ | ✔ |
| Message Routing | ✘ | ✔ |
| Event Grid Integration |✘ | ✔ |
| HTTP, AMQP, MQTT Protocols  | ✔ | ✔ |
| Monitoring and diagnostics  | ✔ | ✔ |
| Device Management, Device Twin | ✔ | ✔ |
| IoT Edge Module Twin | ✔ | ✔ |
| Queries | ✔ | ✔ |
| Jobs | ✘ | ✔ |
| Device Stream | ✘ | ✔ |
| Tenant Portal | ✔ | ✔ |


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

To learn how to use IoT Hub, refer to documentation of IoT Hub on Azure Cloud: https://docs.microsoft.com/azure/iot-hub/.

