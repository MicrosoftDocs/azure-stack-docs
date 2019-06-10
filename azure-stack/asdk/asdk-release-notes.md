---
title: Microsoft Azure Stack Development Kit release notes | Microsoft Docs
description: Improvements, fixes, and known issues for Azure Stack Development Kit.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila

ms.assetid:
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 06/04/2019
ms.author: sethm
ms.reviewer: misainat
ms.lastreviewed: 06/04/2019

---

# ASDK release notes

This article provides information about changes, fixes, and known issues in the Azure Stack Development Kit (ASDK). If you're not sure which version you're running, you can [use the portal to check](../operator/azure-stack-updates.md#determine-the-current-version).

Stay up-to-date with what's new in the ASDK by subscribing to the [![RSS](./media/asdk-release-notes/feed-icon-14x14.png)](https://docs.microsoft.com/api/search/rss?search=Azure+Stack+Development+Kit+release+notes&locale=en-us#) [RSS feed](https://docs.microsoft.com/api/search/rss?search=Azure+Stack+Development+Kit+release+notes&locale=en-us#).

## Build 1.1905.0.40

<!-- ### Changes -->

### New features

- For a list of new features in this release, see [this section](../operator/azure-stack-release-notes-1905.md#whats-in-this-update) of the Azure Stack release notes.

### Fixed and known issues

- Due to a service principal timeout when running the registration script, in order to [register the ASDK](asdk-register.md) successfully you must edit the **RegisterWithAzure.psm1** PowerShell script. Do the following:

  1. On the ASDK host computer, open the file **C:\AzureStack-Tools-master\Registration\RegisterWithAzure.psm1** in an editor with elevated permissions.
  2. On line 1249, add a `-TimeoutInSeconds 1800` parameter at the end. This is required due to a service principal timeout when running the registration script. Line 1249 should now appear as follows:

     ```powershell
      $servicePrincipal = Invoke-Command -Session $PSSession -ScriptBlock { New-AzureBridgeServicePrincipal -RefreshToken $using:RefreshToken -AzureEnvironment $using:AzureEnvironmentName -TenantId $using:TenantId -TimeoutInSeconds 1800 }
      ```

- For a list of other Azure Stack issues fixed in this release, see [this section](../operator/azure-stack-release-notes-1905.md#fixes) of the Azure Stack release notes.
- For a list of known issues, see [this article](../operator/azure-stack-release-notes-known-issues-1905.md).
- Note that [available Azure Stack hotfixes](../operator/azure-stack-release-notes-1905.md#hotfixes) are not applicable to the Azure Stack ASDK.

## Build 1.1904.0.36

<!-- ### Changes -->

### New features

- For a list of new features in this release, see [this section](../operator/azure-stack-release-notes-1904.md#whats-in-this-update) of the Azure Stack release notes.

### Fixed and known issues

- Due to a service principal timeout when running the registration script, in order to [register the ASDK](asdk-register.md) successfully you must edit the **RegisterWithAzure.psm1** PowerShell script. Do the following:

  1. On the ASDK host computer, open the file **C:\AzureStack-Tools-master\Registration\RegisterWithAzure.psm1** in an editor with elevated permissions.
  2. On line 1249, add a `-TimeoutInSeconds 1800` parameter at the end. This is required due to a service principal timeout when running the registration script. Line 1249 should now appear as follows:

     ```powershell
      $servicePrincipal = Invoke-Command -Session $PSSession -ScriptBlock { New-AzureBridgeServicePrincipal -RefreshToken $using:RefreshToken -AzureEnvironment $using:AzureEnvironmentName -TenantId $using:TenantId -TimeoutInSeconds 1800 }
      ```

- Fixed the VPN connection issue identified [here, in release 1902](#known-issues).

- For a list of other Azure Stack issues fixed in this release, see [this section](../operator/azure-stack-release-notes-1904.md#fixes) of the Azure Stack release notes.
- For a list of known issues, see [this article](../operator/azure-stack-release-notes-known-issues-1904.md).
- Note that [available Azure Stack hotfixes](../operator/azure-stack-release-notes-1904.md#hotfixes) are not applicable to the Azure Stack ASDK.

## Build 1903

The 1903 payload does not include an ASDK release.

## Build 1.1902.0.69

### New features

- The 1902 build introduces a new user interface on the Azure Stack Administrator portal for creating plans, offers, quotas, and add-on plans. For more information, including screenshots, see [Create plans, offers, and quotas](../operator/azure-stack-create-plan.md).

- For a list of other changes and improvements in this release, see [this section](../operator/azure-stack-update-1902.md#improvements) in the Azure Stack release notes.

<!-- ### New features

- For a list of new features in this release, see [this section](../operator/azure-stack-update-1902.md#new-features) of the Azure Stack release notes.

### Fixed and known issues

- For a list of issues fixed in this release, see [this section](../operator/azure-stack-update-1902.md#fixed-issues) of the Azure Stack release notes. For a list of known issues, see [this section](../operator/azure-stack-update-1902.md#known-issues-post-installation).
- Note that [available Azure Stack hotfixes](../operator/azure-stack-update-1902.md#azure-stack-hotfixes) are not applicable to the Azure Stack ASDK. -->

### Known issues

- There is an issue with establishing a VPN connection from another host into the ASDK using the steps in [this article](asdk-connect.md). When you attempt to connect from your VPN client to the ASDK environment, you will see an error that **The user name or password is incorrect**, even when you're sure you have used the correct account, and typed the password correctly. The issue is not with your credentials, but rather with a change to the authentication protocol used for the VPN connection on the ASDK. To work around this issue, perform the following steps:

   First, make changes to the authentication protocol used on the ASDK server side:

   1. RDP to the ASDK host.
   2. Open an elevated PowerShell session, signing in as AzureStack\AzureStackAdmin, using the password you provided at the time of deployment.
   3. Run the following commands:

      ```powershell
      netsh nps set np name = "Connections to Microsoft Routing and Remote Access server" profileid = "0x100a" profiledata = "1A000000000000000000000000000000" profileid = "0x1009" profiledata = "0x5"
      restart-service remoteaccess -force
      ```

   Next, modify the client-side connection script. The easiest way to do this is to make changes directly to the C:\AzureStack-Tools-master\connect\azurestack.connect.psm1 script module:

   1. Modify the **Add-AzsVpnConnection** cmdlet to change the `AuthenticationMethod` parameter from `MsChapv2` to `EAP`:

      ```powershell
      $connection = Add-VpnConnection -Name $ConnectionName -ServerAddress $ServerAddress -TunnelType L2tp -EncryptionLevel Required -AuthenticationMethod Eap -L2tpPsk $PlainPassword -Force -RememberCredential -PassThru -SplitTunneling
      ```

   2. Change the **Connect-AzsVpn** cmdlet from using `rasdial @ConnectionName $User $PlainPassword` to using `rasphone`, as EAP requires interactive sign in:

      ```powershell
      rasphone $ConnectionName
      ```

   3. Save your changes and then re-import the **azurestack.connect.psm1** module.
   4. Follow the instructions in [this article](asdk-connect.md#set-up-vpn-connectivity).
   5. When you connect to the ASDK via VPN, connect by navigating to the Windows **Network & Internet Settings**, then **VPN**, rather than connecting from the taskbar, to ensure that you are prompted for credentials.

- An issue has been identified in which packets over 1450 bytes to an Internal Load Balancer (ILB) are dropped. The issue is due to the MTU setting on the host being too low to accommodate VXLAN encapsulated packets that traverse the role, which as of 1901 has been moved to the host. There are at least two scenarios that you might encounter in which we have seen this issue manifest itself:

  - SQL queries to SQL Always-On that is behind an Internal Load Balancer (ILB), and are over 660 bytes.
  - Kubernetes deployments fail if you attempt to enable multiple masters.  

  The issue occurs when you have communication between a VM and an ILB in the same virtual network but on different subnets. You can work around this issue by running the following commands in an elevated command prompt on the ASDK host:

  ```shell
  netsh interface ipv4 set sub "hostnic" mtu=1660
  netsh interface ipv4 set sub "management" mtu=1660
  ```
