---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 06/09/2023
---

Azure Stack HCI Environment Checker is a standalone, PowerShell tool that you can use prior to even ordering hardware to validate connectivity readiness.

For new deployments using the supplemental package, the Environment Checker automatically validates internet connectivity, hardware, identity, networking, and Arc integration across all the nodes of your Azure Stack HCI cluster. The tool also returns a Pass/Fail status for each test, and saves a log file and a detailed report file.

To get started, you can [download this free tool here](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.2.5). For more information, see [Assess your environment for deployment readiness](../hci/manage/use-environment-checker.md).
