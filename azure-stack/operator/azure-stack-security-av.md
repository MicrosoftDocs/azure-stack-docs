---
title: Update Windows Defender Antivirus
titleSuffix: Azure Stack
description: Learn how to update Windows Defender Antivirus on Azure Stack
services: azure-stack
author: PatAltimore
manager: femila

ms.service: azure-stack
ms.topic: article
ms.date: 06/10/2019
ms.author: patricka
ms.reviewer: fiseraci
ms.lastreviewed: 06/10/2019

#Customer intent: As an Azure AD Administrator, I want to understand how antivirus is kept up to date on Azure Stack.
---
# Update Windows Defender Antivirus on Azure Stack

[Windows Defender Antivirus](https://docs.microsoft.com/windows/security/threat-protection/windows-defender-antivirus/windows-defender-antivirus-in-windows-10) is an anti-malware solution that provides security and virus protection. Every Azure Stack infrastructure component (Hyper-V hosts and virtual machines) is protected with Windows Defender Antivirus. For up-to-date protection, you need periodic updates to Windows Defender Antivirus definitions, engine, and platform. How updates are applied depends on your configuration.

## Connected scenario

For anti-malware definition and engine updates, the Azure Stack [update resource provider](azure-stack-updates.md#the-update-resource-provider) downloads anti-malware definitions and engine updates multiple times per day. Each Azure Stack infrastructure component gets the update from the update resource provider and applies the update automatically.

For anti-malware platform updates, apply the [monthly Azure Stack update](azure-stack-apply-updates.md). The monthly Azure Stack update includes Windows Defender Antivirus platform updates for the month.

## Disconnected scenario

 Apply the [monthly Azure Stack update](azure-stack-apply-updates.md). The monthly Azure Stack update includes Windows Defender Antivirus definitions, engine, and platform updates for the month.

## Next steps

[Learn more about Azure Stack security](azure-stack-security-foundations.md)
