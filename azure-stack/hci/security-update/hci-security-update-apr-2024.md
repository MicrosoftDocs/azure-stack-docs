---
title:  April 2024 security update (KB 5036910) for Azure Stack HCI, version 23H2
description: Read about the April 2024 security update (KB 5036910) for Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 04/16/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# April 2024 OS security update (KB 5036910) for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the OS security update for Azure Stack HCI, version 23H2 that was released on April 16, 2024 and applies to OS build 25398.830.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

## Improvements

This security update includes quality improvements. When you install this KB:

- This update supports daylight saving time (DST) changes in Palestine. To learn more, see [Interim guidance for DST changes](https://techcommunity.microsoft.com/t5/daylight-saving-time-time-zone/interim-guidance-for-dst-changes-announced-by-palestinian/ba-p/4048966) announced by Palestinian Authority for 2024, 2025.

- This update supports DST changes in Kazakhstan. To learn more, see [Interim guidance for Kazakhstan time zone changes 2024](https://techcommunity.microsoft.com/t5/daylight-saving-time-time-zone/interim-guidance-for-kazakhstan-time-zone-changes-2024/ba-p/4048963).  

- This update supports DST changes in Samoa. To learn more, see [Interim guidance for Samoa DST changes 2021](https://techcommunity.microsoft.com/t5/daylight-saving-time-time-zone/interim-guidance-for-samoa-dst-changes-2021/ba-p/4048965).  

- This update addresses an issue that affects a network resource. You can't access it from a Remote Desktop session. This occurs when you turn on the Remote Credential Guard feature and the client is Windows 11, version 22H2 or higher.  

- This update addresses an issue that affects Microsoft Edge IE mode. When you open many tabs, it stops responding.  

- This update addresses an issue that affects DNS servers. They receive Event 4016 for a timeout of the Lightweight Directory Access Protocol (LDAP). This occurs when they perform DNS registrations. Name registrations fail with Active Directory Domain Services (AD DS). The issue remains until you restart the DNS service.  

- This update addresses an issue that affects workload virtual machines (VM). They lose their connection to the network in production environments.  

- This update addresses an issue that occurs when you deploy Failover Cluster Network Controllers. Node thumbprints don't refresh while certificates rotate on Software Defined Networking (SDN) hosts. This causes service disruptions. Once you install this or future updates, you must make a call to `Set-NetworkControllerOnFailoverCluster -RefreshNodeCertificateThumbprints $true` after you rotate host certificates.  

- This update addresses an issue that occurs when you use `LoadImage()` to load a top-down bitmap. If the bitmap has a negative height, the image doesn't load and the function returns NULL.  

- This update addresses an issue that affects the Group Policy service. It fails after you use *LGPO.exe* to apply an audit policy to the system.  

- This update addresses an issue that affects the display of a smart card icon. It doesn't appear when you sign in. This occurs when there are multiple certificates on the smart card.

- This update addresses an issue that causes your device to shut down after 60 seconds. This occurs when you use a smart card to authenticate on a remote system.

- This update addresses an issue that affects Secure Launch. It doesn't run on some processors.  

- This update addresses an issue that occurs when you run an application as an Administrator. When you use a PIN to sign in, the application won't run.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [April 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Apr).


## Known issues

Microsoft isn't currently aware of any issues with this update.

## To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).


## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5036910](https://go.microsoft.com/fwlink/?linkid=2267131).


## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Stack HCI, version 23H2.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Stack HCI, version 23H2.