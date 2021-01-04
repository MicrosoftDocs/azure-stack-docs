---
title: Configure the time server in Azure Stack Hub 
description: Learn how to configure the time server in Azure Stack Hub.
author: PatAltimore
ms.topic: article
ms.date: 2/19/2020
ms.author: patricka
ms.reviewer: thoroet
ms.lastreviewed: 10/10/2019

# Intent: As an Azure Stack Hub operator, I want to configure the time server in Azure Stack Hub so my system time is accurate and synchronized.
# Keyword: time server azure stack hub

---

# Configure the time server for Azure Stack Hub

You can use the privileged endpoint (PEP) to update the time server in Azure Stack Hub. Use a host name that resolves to two or more NTP (Network Time Protocol) server IP addresses.

Azure Stack Hub uses NTP to connect to time servers on the internet. NTP servers provide accurate system time. Time is used across Azure Stack Hub's physical network switches, hardware lifecycle host, infrastructure service, and virtual machines. If the clock isn't synchronized, Azure Stack Hub may experience severe issues with the network and authentication. Log files, documents, and other files may be created with incorrect timestamps.

Providing one time server (NTP) is required for Azure Stack Hub to synchronize time. When you deploy Azure Stack Hub, you provide the address of an NTP server. Time is a critical datacenter infrastructure service. If the service changes, you need to update the time.

> [!NOTE]
> Azure Stack Hub supports synchronizing time with only one time server (NTP). You can't provide multiple NTPs for Azure Stack Hub to synchronize time with.

## Configure time

1. [Connect to the PEP](azure-stack-privileged-endpoint.md).
    > [!Note]  
    > It isn't necessary to unlock the privileged endpoint by opening a support ticket.

2. Run the following command to review the current configured NTP server:

    ```PowerShell
    Get-AzsTimeSource
    ```

3. Run the following command to update Azure Stack Hub to use the new NTP server and to immediately synchronize the time.

    > [!Note]  
    > This procedure doesn't update the time server on the physical switches. If your time server isn't a Windows-based NTP server, you need to add the flag `0x8`.

    ```PowerShell
    Set-AzsTimeSource -TimeServer NEWTIMESERVERIP -resync
    ```

    For servers other than Windows-based time servers:

    ```PowerShell
    Set-AzsTimeSource -TimeServer "NEWTIMESERVERIP,0x8" -resync
    ```

4. Review the output of the command for any errors.


## Next steps

[View the readiness report](azure-stack-validation-report.md)  
[General Azure Stack Hub integration considerations](azure-stack-datacenter-integration.md)  
