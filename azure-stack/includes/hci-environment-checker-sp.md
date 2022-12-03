---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 12/03/2022
---

Before you deploy your Azure Stack HCI solution, you can now use a standalone, PowerShell tool to check your environment readiness. The Azure Stack HCI Environment Checker is a lightweight, easy-to-use tool that doesn't need an Azure subscription. This tool will let you validate your:

    - Internet connectivity.
    - Hardware.
    - Network infrastructure for valid IP ranges provided by customers for deployment.
    - Active Directory (an Active Directory prep tool is run prior to deployment).
    
    The Environment Checker tool runs tests on all the nodes of your Azure Stack HCI cluster, returns a Pass/Fail status for each test, and saves a log file and a detailed report file.
    
    To get started, you can [download this free tool here](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.2.5).
