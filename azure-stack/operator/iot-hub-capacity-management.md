---
title: Capacity management for IoT Hub on Azure Stack Hub
description: Learn how to manage capacity for the IoT Hub resource provider on Azure Stack Hub.
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 10/30/2020 
---
# Capacity management for IoT Hub on Azure Stack Hub

[!INCLUDE [preview-banner](../includes/iot-hub-preview.md)]

This article provides the guidance and instructions necessary to perform capacity management of the IoT Hub on Azure Stack Hub resource provider.

## Overview

Operators manage and operate their Azure Stack Hub instances in the same manner as any cloud operator. They make sure instances are installed properly in the specified environments, configured correctly and securely, operated in HA, coherently and efficiently. Operators are provided tools to perform those tasks, which are documented in the [Azure Stack Hub Operator Documentation](./operator). 

As to IoT Hub service, one of tasks operators would perform is to manage the capacity of IoT Hub.

ASH is on-prem data center with limited resources. All services running on ASH share and compete the same resource pool. Operators need plan and manage the capacity based on the business need.

IoT Hub has single VM type. As part of IoT Hub deployment, the system provisions a set of VMs on ASH. These set of VMs can support certain number of devices and message throughput. The default setting should be able to meet many customers’ requirements. However, if customers need more devices or higher message throughput, operators can increase the capacity using Admin portal or CLI/PowerShell . Through the tools, operators can:
•	Monitor current capacity status
o	number of VMs provisioned with IoT Hub, and their resource utilizations
•	Increase capacity: operators can add more VMs if they want. They can add any number of VMs as long as the resources are available. 
•	Decrease capacity is not supported. 
Here are the steps to increase the capacity:
1)	From Admin portal (https://adminportal.redmond.ext-s46r0607.masd.stbtest.microsoft.com/#blade/Microsoft_Azure_IoTHub_Admin/IoTHubAdminMenuBlade/overview), operators can see overview such as alerts, the quotas created on the stamp, and total capacity allocated for IoT Hub. 

   ![iot hub certificate example](media\iot-hub-rp-capacity-management\dashboard-rp-iot-hub.png.png)

2. Operators can view the capacity by clicking “Capacity”. The number of nodes is number of nodes allocated to IoT Hub. 
 
3)	Operators can increase capacity by clicking the Name and then change the number. The number can only go up.
 
Operators can also monitor the alerts and quotas:
4)	Operators can click Alerts to see details. 
 
5)	Operators can also click Quotas to see the list of quotas. 
•	For public preview, “Create” is disabled. It will be enabled when GA. The default quota is unlimited. 
 





## Next steps

