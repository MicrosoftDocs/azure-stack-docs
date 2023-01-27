---
title: Validation tests in AKS hybrid
description: Learn how to validate your environment and configuration prior to installing AKS hybrid.
author: sethmanheim
ms.topic: troubleshooting
ms.date: 01/26/2023
ms.author: sethm 
ms.lastreviewed: 01/26/2023
ms.reviewer: waltero

---

# AKS hybrid pre-install validation tests

The following table lists the tests that are executed when you run the [Set-AksHciConfig](reference/ps/set-akshciconfig.md) and [Set-AksHciRegistration](reference/ps/set-akshciregistration.md) PowerShell cmdlets. The tests help to ensure that when you run the actual installation with [Install-AksHci](reference/ps/install-akshci.md), the installation process avoids many common environment and configuration issues. For a better understanding of the terms used in the tests, see the [AKS hybrid concepts article](kubernetes-concepts.md).

|Test name   |Description   |Troubleshooting resources   |
|---|---|---|
|[MOC](concepts-node-networking.md) host internet connectivity   |The test validates that the machine hosting MOC has internet connectivity to key Microsoft endpoints. |* Ensure that there is connectivity from the physical hosts to the internet.
* [Troubleshooting network issues in Azure Stack HCI](https://techcommunity.microsoft.com/t5/networking-blog/introducing-network-hud-for-azure-stack-hci/ba-p/3676097)
* [Blog post on troubleshooting network issues in Windows Server](https://techcommunity.microsoft.com/t5/itops-talk-blog/how-to-troubleshoot-windows-server-network-connectivity-issues/ba-p/1500934)
* [Firewall requirements for Azure Stack HCI](/azure-stack/hci/concepts/firewall-requirements)
   |
|   |   |   |
|   |   |   |
|   |   |   |
|   |   |   |
|   |   |   |
|   |   |   |
|   |   |   |
|   |   |   |
|   |   |   |