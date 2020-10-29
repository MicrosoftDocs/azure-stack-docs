---
title: Prerequisites for installing IoT Hub on Azure Stack Hub
description: Learn about the required prerequisites, before installing IoT Hub resource provider on Azure Stack Hub.
author: yiyiguo
ms.author: yiygu
ms.service: azure-stack
ms.topic: how-to
ms.date: 1/6/2020 
---
# Prerequisites for installing IoT Hub on Azure Stack Hub

[!INCLUDE [preview-banner](../includes/iot-hub-preview.md)]

The following prerequisites must be completed before you can install IoT Hub on Azure Stack Hub. **Several days or weeks of lead time may be required** to complete all steps.

> [!IMPORTANT]
> These prerequisites assume that you've already deployed at least a 4-node Azure Stack Hub integrated system, **build number 1.2005.6.53** or higher. The IoT Hub resource provider is not supported on the Azure Stack Hub Development Kit (ASDK).

## Common prerequisites

[!INCLUDE [Common RP prerequisites](../includes/resource-provider-prerequisites.md)]

## Dependency prerequisites

1. Download and [install Event Hubs](event-hubs-rp-install.md) from the Marketplace. The deployment of Event Hubs must happen BEFORE the deployment of IoT Hub is started.
2. For a faster download and install of IoT Hub, download the following dependent items from Marketplace before downloading IoT Hub package. Otherwise, IoT Hub deployment will try to download the dependent packages:
    * Custom Script Extension
    * PowerShell Desired State Configuration
    * Free License: SQL Server 2016 SP2 Express on Windows Server 2016
    * SQL IaaS Extension
    * Azure Stack Add-On RP Windows Server
3. Wait at least 10 minutes after the successful installation of Event Hubs, before continuing with the deployment of IoT Hub.

## Certificate requirements

1. Procure a public key infrastructure (PKI) TLS/SSL certificate for Event Hubs. The Subject Alternative Name (SAN) must adhere to the following naming pattern: `CN=*.mgmtiothub.<region>.<fqdn>`.

   Subject Name may be specified, but it's not used by IoT Hub when handling certificates. Only the Subject Alternative Name is used. See [PKI certificate requirements](azure-stack-pki-certs.md) for the full list of detailed requirements.

   ![iot hub certificate example](media\iot-hub-rp-prerequisites\certificate.png)

2. Be sure to review [Validate your certificate](azure-stack-validate-pki-certs.md). The article shows you how to prepare and validate the certificates you use for the IoT Hub resource provider. 

## DNS configuration requirements
 
For IoT Hub to work on the network properly on Azure Stack Hub, the network administrator needs to configure DNS. Find the DNS conditional forwarding setting in the DNS management tool, and add a conditional forwarding rule to allow traffic for: `<region>.cloudapp.<externaldomainname>`. For example, `ussouth.cloudapp.contoso.com`.

## Next steps

Next, install the IoT Hub resource provider on [connected Azure Stack](iot-hub-rp-install.md).
