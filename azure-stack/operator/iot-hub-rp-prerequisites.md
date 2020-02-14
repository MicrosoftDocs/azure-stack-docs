---
title: Prerequisites for installing IoT Hub on Azure Stack Hub
description: Learn about the required prerequisites, before installing IoT Hub resource provider on Azure Stack.
author: yiyiguo
ms.author: yiygu
ms.service: azure-stack
ms.topic: how-to
ms.date: 1/6/2020 
---
# Prerequisites for installing IoT Hub on Azure Stack Hub

The following prerequisites must be completed before you can install IoT Hub on Azure Stack Hub. **Several days or weeks of lead time may be required** to complete all steps.

> [!IMPORTANT]
> These prerequisites assume that you've already deployed at least a 4-node Azure Stack Hub integrated system. <!-- TZLASDKFIX The IoT Hub resource provider is not supported on the Azure Stack Hub Development Kit (ASDK).-->

## Prerequisites

1. Ensure that you are on Stack build 1912 or higher.
2. Download and [install Event Hubs](event-hubs-rp-install.md) from the Marketplace. The deployment of Event hubs must happen BEFORE the deployment of IoT Hub is started.
3. Before starting the deployment of IoT Hub, wait for 10 minutes after a successful installation of Event Hubs.
4. For faster download and install of IoT Hub, download the following items from Marketplace before downloading IoT hub package. Otherwise, during IoT Hub deployment, it will try to download the dependent packages, which could take a long time:
    * Custom Script Extension
    * PowerShell Desired State Configuration
    * Free License: SQL Server 2016 SP2 Express on Windows Server 2016
    * SQL IaaS Extension
    * Azure Stack Add-On RP Windows Server

## Certificate requirements

IoT Hub on Azure Stack Hub needs Public key infrastructure (PKI) SSL certificates. The Subject Alternate Name (SAN) must adhere to the following naming pattern: `CN=*.mgmtiothub.<region>.<fqdn>.`

Subject Name may be specified, but it's not used by IoT Hub when handling certificates. Only the Subject Alternate Name is used. See [PKI certificate requirements](azure-stack-pki-certs.md) for the full list of detailed requirements.

[![iot hub certificate example](media\iot-hub-rp-prerequisites\certificate.png)](media/iot-hub-rp-prerequisites/certificate.png#lightbox)

## Next steps

Next, install the IoT Hub resource provider on [connected Azure Stack](iot-hub-rp-install.md).
