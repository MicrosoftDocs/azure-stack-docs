---
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
ms.topic: include
ms.service: azure-operator-nexus
---

> [!IMPORTANT]
> When the Azure Connected Machine agent (`azcmagent`) is installed, there's a known issue that affects the ability to successfully `az login` and retrieve access tokens from the Instance Metadata Service (IMDS) endpoint.
> For this reason, install the `azcmagent` binary only AFTER completing all required `az login` and access token retrieval operations.
> Once the binary is installed, configuration changes affect routing traffic through the Host Identity Management Service (HIMS) causing `az login` and direct access token retrieval commands to fail.
> If you need to perform those commands after installation, remove (uninstall) the `azcmagent` binary; once removed the `az login` and token retrieval operations resume working.
