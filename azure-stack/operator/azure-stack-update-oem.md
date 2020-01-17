---
title: Apply an original equipment manufacturer (OEM) update to Azure Stack Hub | Microsoft Docs
description: Learn to apply an original equipment manufacturer (OEM) update to Azure Stack Hub.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/15/2019
ms.author: mabrigg
ms.lastreviewed: 08/15/2019
ms.reviewer: ppacent 

---

# Apply Azure Stack Hub original equipment manufacturer (OEM) updates

You can apply original equipment manufacturer (OEM) updates to your Azure Stack Hub hardware components to receive driver and firmware improvements as well as security patches while minimizing the impact on your users. In this article, you can learn about OEM updates, OEM contact information, and how to apply an OEM update.

## Overview of OEM updates

In addition to Microsoft Azure Stack Hub updates, many OEMs also release regular updates for your Azure Stack Hub hardware, such as driver and firmware updates. These are referred to as **OEM Package Updates**. To understand whether your OEM releases OEM Package Updates, check your [OEM's Azure Stack Hub documentation](#oem-contact-information).

These OEM package updates are uploaded into the **updateadminaccount** storage account and applied via the Azure Stack Hub Administrator portal. For more information, see [Applying OEM Updates](#apply-oem-updates).

Ask your original equipment manufacturer (OEM) about their specific notification process to ensure OEM package update notifications reach your organization.

Some hardware vendors may require a *hardware vendor VM* that handles the internal firmware update process. For more information, see [Configure hardware vendor VM](#configure-hardware-vendor-vm)

## OEM contact information 

This section contains OEM contact information and links to OEM Azure Stack Hub reference material.

| Hardware Partner | Region | URL |
|------------------|--------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Cisco | All | [Cisco Integrated System for Microsoft Azure Stack Hub Operations Guide]()<br><br>[UCS C-Series Rack-Mount UCS-Managed Server Software](https://aka.ms/aa708e2) |
| Dell EMC | All | [Cloud for Microsoft Azure Stack Hub 14G (account and login required)](https://support.emc.com/downloads/44615_Cloud-for-Microsoft-Azure-Stack-14G)<br><br>[Cloud for Microsoft Azure Stack Hub 13G (account and login required)](https://support.emc.com/downloads/42238_Cloud-for-Microsoft-Azure-Stack-13G) |
| Fujitsu | JAPAN | [Fujitsu managed service support desk (account and login required)](https://eservice.fujitsu.com/supportdesk-web/) |
|  | EMEA & US | [Fujitsu support IT products and systems](https://support.ts.fujitsu.com/IndexContact.asp?lng=COM&ln=no&LC=del) |
| HPE | All | [HPE ProLiant for Microsoft Azure Stack Hub](http://www.hpe.com/info/MASupdates) |
| Lenovo | All | [ThinkAgile SXM Best Recipes](https://datacentersupport.lenovo.com/us/en/solutions/ht505122)
| Wortmann |  | [OEM/firmware package](https://aka.ms/AA6z600)<br>[terra Azure Stack Hub documentation (including FRU)](https://aka.ms/aa6zktc)

## Apply OEM updates

Apply the OEM packages with the following steps:

> [!IMPORTANT]
> Before applying updates in Azure Stack Hub, ensure you have completed **ALL** steps in the [Pre-Update Checklist](release-notes-checklist.md) and have scheduled an appropriate maintenance window for the update type that you are applying.

1. You will need to contact your OEM to:
      - Determine the current version of your OEM package.  
      - Find the best method to download your OEM package.  
2. Before applying an OEM package update, you should always apply the latest Azure Stack Hub hotfix available on your system's current Azure Stack Hub version. For more information about hotfixes see [Azure Stack Hub Hotfixes](https://docs.microsoft.com/azure-stack/operator/azure-stack-servicing-policy).
3. Prepare your OEM package with the steps outlined in [Download update packages for integrated systems](azure-stack-servicing-policy.md).
4. Apply the updates with the steps outlined in [Apply updates in Azure Stack Hub](azure-stack-apply-updates.md).

## Configure hardware vendor VM

Some hardware vendors may require a VM to help with the OEM update process. Your hardware vendor will be responsible for creating these VMs and documenting if you require `ProxyVM` or `HardwareManager` for **-VMType** when running the **Set-OEMExternalVM** cmdlet as well as which credential should be used for **-Credential**. Once the VMs are created, configure them with the **Set-OEMExternalVM** from the privileged endpoint.

For more information about the privileged endpoint on Azure Stack Hub, see [Using the privileged endpoint in Azure Stack Hub](azure-stack-privileged-endpoint.md).

1.  Access the privileged endpoint.

    ```powershell  
    $cred = Get-Credential
    $session = New-PSSession -ComputerName <IP Address of ERCS>
    -ConfigurationName PrivilegedEndpoint -Credential $cred
    ```

2. Configure the hardware vendor VM using the **Set-OEMExternalVM** cmdlet. The cmdlet validates the IP address and credentials for **-VMType** `ProxyVM`. For **-VMType** `HardwareManager` the cmdlet won't validate the input. The **-Credential** parameter provided to **Set-OEMExternalVM** is one that will be clearly documented by the hardware vendor documentation.  It is NOT the CloudAdmin credential used with the privileged endpoint, or any other existing Azure Stack Hub credential.

    ```powershell  
    $VmCred = Get-Credential
    Invoke-Command -Session $session
        { 
    Set-OEMExternalVM -VMType <Either "ProxyVM" or "HardwareManager">
        -IPAddress <IP Address of hardware vendor VM> -Credential $using:VmCred
        }
    ```

## Next steps

[Azure Stack Hub updates](azure-stack-updates.md)
