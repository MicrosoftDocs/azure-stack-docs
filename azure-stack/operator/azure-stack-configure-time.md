---
title: Configure the time server for Azure Stack | Microsoft Docs
description: Learn how to configure the time server for Azure Stack.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/10/2019
ms.author: mabrigg
ms.reviewer: thoroet
ms.lastreviewed: 10/10/2019

---

# Configure the time server for Azure Stack

You can use the privileged endpoint (PEP) to update the time server in Azure Stack. Use a host name that resolves to two or more NTP server IP addresses.

Azure Stack uses the Network Time Protocol (NTP) to connect to time servers on the Internet. NTP servers provide accurate system time. Time is used across Azure Stack's physical network switches, hardware lifecycle host, infrastructure service, and virtual machines. If the clock isn't synchronized, Azure Stack may experience issues with the network. Log files, documents, and other files may be created with incorrect timestamps.

At least one time server (NTP) is necessary for Azure Stack to synchronize time. When you deploy Azure Stack, you provide the address of an NTP server. Time is a critical datacenter infrastructure service. If the service changes, you will need to update the time.

## Configure time

1. [Connect to the PEP](azure-stack-privileged-endpoint.md). 
    > [!Note]  
    > It isn't necessary to unlock the privileged endpoint by opening a support ticket.

2. Run the following command to review the current configured NTP server:

    ```PowerShell
    Get-AzsTimeSource
    ```

3. Run the following command to update Azure Stack to use the new NTP Server and to immediately synchronize the time.

    > [!Note]  
    > This procedure don't update the time server on the physical switches

    ```PowerShell
    Set-AzsTimeSource -TimeServer NEWTIMESERVERIP -resync
    ```

4. Review the output of the command for any errors.


## Next steps

[View the readiness report](azure-stack-validation-report.md)  
[General Azure Stack integration considerations](azure-stack-datacenter-integration.md)  
