---
title: Security baseline settings on Azure Stack HCI (preview)
description: Learn about the default security baseline settings available for new deployments of Azure Stack HCI (preview).
author: meaghanlewis
ms.author: mosagie
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/06/2022
---

# Security baseline settings for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes the security baseline settings associated with your Azure Stack HCI cluster. Azure Stack HCI is a secure-by-default product and has more than 200 security settings enabled right from the start. These settings provide a consistent security baseline and ensure that the device always starts in a known good state.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Benefits of the security baseline

The security baseline on Azure Stack HCI:

- Enables you to closely meet Center for Internet Security (CIS) benchmark and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the operating system (OS) and the Microsoft recommended security baseline.
- Reduces the operating expenditure (OPEX) with its built-in drift protection mechanism and consistent at scale monitoring via the Azure Arc Hybrid Edge baseline.
- Improves the security posture by disabling legacy protocols and ciphers.

## View the settings

You can find and download the complete list of settings at: [aka.ms/hci-securitybase](https://aka.ms/hci-securitybase).

## Next steps

- [Azure Stack HCI security considerations](./security.md)
