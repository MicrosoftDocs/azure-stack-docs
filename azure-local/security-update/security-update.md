---
title:  Security updates for Azure Local
description: Security updates for Azure Local.
author: alkohli
ms.topic: article
ms.date: 12/01/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Security updates for Azure Local

This article lists the various security updates that are available for Azure Local.

::: moniker range="=azloc-2512"

## December OS security update (KB5072033) for Azure Local

This section provides the 2512 security updates associated with OS build **26200.7442** and **26100.7442** released on December 9, 2025, and also includes key notifications, announcements, change logs, and end-of-support notices.

## Windows Secure Boot certificate expiration

Secure Boot certificates used by most Windows devices are set to expire starting in June 2026. This might affect the ability of certain personal and business devices to boot securely if not updated in time. To avoid disruption, we recommend reviewing the guidance and taking action to update certificates in advance. For details and preparation steps, see [Windows Secure Boot certificate expiration and CA updates](https://support.microsoft.com/en-us/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e?preview=true).

To learn more about differences between security updates, optional non-security preview updates, out-of-band (OOB) updates, and continuous innovation, see [Windows monthly updates explained](https://techcommunity.microsoft.com/blog/windows-itpro-blog/windows-monthly-updates-explained/3773544). For information on Windows update terminology, see the different types of [Windows software updates](/troubleshoot/windows-client/installing-updates-features-roles/standard-terminology-software-updates). For an overview, see the update history page for Azure Stack HCI, version 24H2.  

## Improvements

This security update contains fixes and quality improvements from [KB5070311] (released November 25, 2025). The following summary outlines key issues addressed by this update. Also, included are available new features. The bold text within the brackets indicates the item or area of the change.

- **[Copilot]** Fixed: This update addresses an issue where Ask Copilot didn’t activate the **Click to Do** window as expected. The window now appears in the foreground when you share data with Copilot.

- **[File Explorer (known issue)]** Fixed: This update addresses an issue where File Explorer briefly flashes white when you navigate between pages. This issue might occur after you install [KB5070311]. 

- **[Networking]** Fixed: This update fixes an issue where external virtual switches lose their physical network adapter (NIC) bindings after a host reboot. When this happens, the switches revert to internal mode, resulting in loss of network connectivity for virtual machines and blocking normal server operations.

If you've already installed previous updates, your device will download and install only the new updates included in this package.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [December 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Dec).

## Known issues

The following is a known issue with this update.

**Issue**
Password icon might be missing or invisible in the lock screen sign-in options.

**Symptoms**
After installing the August 2025 non-security preview update (KB5064081) or later updates, you might notice that the password icon is not visible in the sign-in options on the lock screen. If you hover over the space where the icon should appear, you’ll see that the password button is still available. Select this placeholder to open the password text box and enter your password. After entering your password, you can sign in normally.

**Workaround**
Microsoft is working to resolve this issue and will provide information when it’s available. 

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB 5072033](https://go.microsoft.com/fwlink/?linkid=).

::: moniker-end


::: moniker range="=azloc-2511"

## November OS security update (KB5068861) for Azure Local

<!-- This article describes the OS security update for the 2511 release of Azure Local on November 11, 2025 and applies to OS builds 26100.7171 and 26200.7171.

For the 2511 release of Azure Local, Microsoft released two security updates, each corresponding to a specific OS build. The following table provides the details of these security updates, including their associated OS builds and release dates.

| Security update | OS build | Release date |
|--|--|--|
| KB5068779 | 25398.1965 | November 11, 2025 |
| KB5068861 | 26100.7171<br>26200.7171 | November 11, 2025 |

 # [OS build 25398.xxxx](#tab/os-build-25398-xxxx)

This section provides the 2511 security updates associated with OS build **25398.1965**.

## Windows Secure Boot certificate expiration

Secure Boot certificates used by most Windows devices are set to expire starting in June 2026. This might affect the ability of certain personal and business devices to boot securely if not updated in time. To avoid disruption, we recommend reviewing the guidance and taking action to update certificates in advance. For details and preparation steps, see [Windows Secure Boot certificate expiration and CA updates](https://support.microsoft.com/en-us/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e?preview=true).

To learn more about Windows update terminology, see [types of Windows updates](/troubleshoot/windows-client/installing-updates-features-roles/standard-terminology-software-updates) and [monthly quality update types](https://techcommunity.microsoft.com/blog/windows-itpro-blog/windows-monthly-updates-explained/3773544).
  
## Improvements

This security update contains fixes and quality improvements from [KB5066780](https://support.microsoft.com/topic/october-14-2025-kb5066780-os-build-25398-1913-fcae5a50-170f-40dd-af68-ea2a267a74e6?preview=true) (released October 14, 2025) and [KB5070879](https://support.microsoft.com/topic/october-23-2025-kb5070879-os-build-25398-1916-out-of-band-e192ac2e-3519-44c6-8706-d7e40c556c8c?preview=true) (released October 23, 2025). The following summary outlines key issues addressed by this update. Also, included are available new features. The bold text within the brackets indicates the item or area of the change.

- **[Windows Security]** Fixed: This update addresses an issue that affected SmartScreen application reputation (Apprep) events from being logged. As a result, you couldn’t always see the level of protection provided by Microsoft Defender SmartScreen.

- **[Networking]** Fixed: This update fixes an issue in the `HTTP.sys` request parser, a Windows component that reads and processes HTTP requests. The parser allowed a single line break within HTTP/1.1 chunk extensions, where the RFC 9112 standard requires a carriage return and line feed (CRLF) sequence to terminate each chunk. This can cause a parsing discrepancy when front end proxies are a part of the setup.
 
To turn on strict parsing, use the following registry key and values: 

**Registry key**:
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Http\Parameters]`

**Registry value:** `"HttpAllowLenientChunkExtParsing"=dword:00000000`

**Data to be set**: `0`

If you've already installed previous updates, your device will download and install only the new updates included in this package.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [November 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Nov).

## Known issues

The following issues are known for this update.​​​​​

**Issue**

Windows Server Update Services (WSUS) does not display error details

**Symptoms**

After installing [KB5070879](https://support.microsoft.com/topic/october-23-2025-kb5070879-os-build-25398-1916-out-of-band-e192ac2e-3519-44c6-8706-d7e40c556c8c?preview=true) or later updates, Windows Server Update Services (WSUS) does not display synchronization error details within its error reporting.

As a result, this functionality is temporarily removed to address the Remote Code Execution Vulnerability, [CVE-2025-59287](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2025-59287).  

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5068779.](https://go.microsoft.com/fwlink/?linkid=2340950). 


# [OS build 26100.xxxx](#tab/os-build-26100-xxxx) -->

This section provides the 2511 security updates associated with OS build **26200.7171** and **26100.7171** released on November 11, 2025, and also includes key notifications, announcements, change logs, and end-of-support notices.

## Simplified Windows update titles

A new, standardized title format makes Windows updates easier to read and understand. It improves clarity by removing unnecessary technical elements like platform architecture. Key identifiers such as date prefixes, the KB number, and build or version are retained to help you quickly recognize each update.

<!--For more information, see Simplified Windows Update titles or the accompanying blog post. -->

## Windows Secure Boot certificate expiration

Secure Boot certificates used by most Windows devices are set to expire starting in June 2026. This might affect the ability of certain personal and business devices to boot securely if not updated in time. To avoid disruption, we recommend reviewing the guidance and taking action to update certificates in advance. For details and preparation steps, see [Windows Secure Boot certificate expiration and CA updates](https://support.microsoft.com/en-us/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e?preview=true).

To learn more about Windows update terminology, see [types of Windows updates](/troubleshoot/windows-client/installing-updates-features-roles/standard-terminology-software-updates) and [monthly quality update types](https://techcommunity.microsoft.com/blog/windows-itpro-blog/windows-monthly-updates-explained/3773544). 
 
## Improvements

This security update contains fixes and quality improvements from [KB5068861](https://support.microsoft.com/topic/november-11-2025-kb5068861-os-builds-26200-7171-and-26100-7171-2e0512e4-3ad4-4da6-958c-a468a1af949e) (released November 11, 2025). The following summary outlines key issues addressed by this update. Also, included are available new features. The bold text within the brackets indicates the item or area of the change. 

- **[Gaming]**
    - Fixed: This update addresses an issue that affects gaming handheld devices. These devices were unable to stay in low-power states, which caused faster battery drain.​​​​​​​

    - Fixed: This update addresses an issue on some handheld gaming devices where after signing in using the built-in gamepad, the controller might not respond in apps for about five seconds, causing a delay. After you submit your password or PIN, the touch keyboard on the sign-in screen hides automatically.

- **[Storage]** Fixed: This update addresses an issue that could cause some Storage Spaces to become inaccessible or Storage Spaces Direct to fail when creating a storage cluster.

- **[System utilities (known issue)]** Fixed: This update addresses an issue where closing Task Manager with the Close button didn’t fully end the process, leaving background instances that could slow performance over time.  This might occur after installing [KB5067036](https://support.microsoft.com/topic/october-28-2025-kb5067036-os-builds-26200-7019-and-26100-7019-preview-ec3da7dc-63ba-4b1d-ac41-cf2494d2123a?preview=true).

- **[Voice Access]** Fixed: This update addresses an issue where **Voice Access** failed during initial setup if no microphone was connected and the voice model wasn’t installed.

- **​​​​​​​[Window management]** Fixed: his update addresses an issue where selecting the desktop could unexpectedly open **Task View**.

- **[Networking]** Fixed: This update fixes an issue in the `HTTP.sys` request parser, a Windows component that reads and processes HTTP requests. The parser allowed a single line break within HTTP/1.1 chunk extensions, where the RFC 9112 standard requires a carriage return and line feed (CRLF) sequence to terminate each chunk. This can cause a parsing discrepancy when front end proxies are a part of the setup.
 
To turn off strict parsing, use the following registry key and values:

**Registry Key:** 
`HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Http\Parameters]`

**Registry value:**
`"HttpAllowLenientChunkExtParsing"=dword:00000001`

**Data to be set**: `1`  

If you've already installed previous updates, your device will download and install only the new updates included in this package.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [November 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Nov).

## Known issues

Microsoft is not currently aware of any issues with this update. 

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB 5068861](https://go.microsoft.com/fwlink/?linkid=2340951).

::: moniker-end


::: moniker range="=azloc-2510"

## October OS security updates (KB5066780 and KB5066835) for Azure Local

For the 2510 release of Azure Local, Microsoft released two security updates, each corresponding to a specific OS build. The following table provides the details of these security updates, including their associated OS builds and release dates.

| Security update | OS build | Release date |
|--|--|--|
| KB5066780 | 25398.1913 | October 14, 2025 |
| KB5066835 | 26100.6899<br>26200.6899 | October 14, 2025 |

# [OS build 25398.xxxx](#tab/os-build-25398-xxxx)

This section provides the 2510 security updates associated with OS build **25398.1913**.

## Windows Secure Boot certificate expiration

Secure Boot certificates used by most Windows devices are set to expire starting in June 2026. This might affect the ability of certain personal and business devices to boot securely if not updated in time. To avoid disruption, we recommend reviewing the guidance and taking action to update certificates in advance. For details and preparation steps, see [Windows Secure Boot certificate expiration and CA updates](https://support.microsoft.com/en-us/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e?preview=true).

To learn more about Windows update terminology, see [types of Windows updates](/troubleshoot/windows-client/installing-updates-features-roles/standard-terminology-software-updates) and [monthly quality update types](https://techcommunity.microsoft.com/blog/windows-itpro-blog/windows-monthly-updates-explained/3773544).  
## Improvements

This security update contains fixes and quality improvements from [KB5066780](https://support.microsoft.com/en-us/topic/october-14-2025-kb5066780-os-build-25398-1913-fcae5a50-170f-40dd-af68-ea2a267a74e6) (released October 14, 2025). The following summary outlines key issues addressed by this update. Also, included are available new features. The bold text within the brackets indicates the item or area of the change.

- **[Input]**
    - Fixed: An issue where some characters didn’t display correctly when using the Chinese Input Method Editor (IME).
    - Fixed: This update addresses an issue where certain Chinese characters appeared as empty boxes in some text fields, such as those used in [Connection Manager Administration Kit](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/hh831675(v=ws.11)), when a character limit was set.​​​​​​​

- **[Networking (known issue)]** Fixed: This update addresses an issue where you might not be able to connect to shared files and folders if you're using the Server Message Block (SMB) v1 protocol on NetBIOS over TCP/IP NetBIOS ([NetBT](/windows-hardware/customize/desktop/unattend/microsoft-windows-netbt)). This can happen after installing update [KB5065425](https://support.microsoft.com/en-us/topic/september-9-2025-kb5065425-os-build-25398-1849-5cbdf982-3ed6-49bf-a936-457f0edc7056?preview=true).

- **[PowerShell]** Fixed: This update addresses that affects PowerShell Remoting and Windows Remote Management (WinRM). Commands might time out after 10 minutes. ​​​​​

- **[Stability]** Fixed. This update addresses an issue observed in rare cases after installing the May 2025 security update and subsequent updates causing devices to experience stability issues. Some devices became unresponsive and stopped responding in specific scenarios.

- **[Compatibility]** Fixed. This update removes the ltmdm64.sys driver. Fax modem hardware dependent on this specific driver will no longer work in Windows. 

If you've already installed previous updates, your device will download and install only the new updates included in this package.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [October 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Oct).

## Known issues

Microsoft is not currently aware of any issues with this update.​​​​​

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5066780.](https://go.microsoft.com/fwlink/?linkid=2338807).

# [OS build 26100.xxxx](#tab/os-build-26100-xxxx)

This section provides the 2510 security updates associated with OS build **26200.6899** and **26100.6899**.

## Windows Secure Boot certificate expiration

Secure Boot certificates used by most Windows devices are set to expire starting in June 2026. This might affect the ability of certain personal and business devices to boot securely if not updated in time. To avoid disruption, we recommend reviewing the guidance and taking action to update certificates in advance. For details and preparation steps, see [Windows Secure Boot certificate expiration and CA updates](https://support.microsoft.com/en-us/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e?preview=true).

To learn more about Windows update terminology, see [types of Windows updates](/troubleshoot/windows-client/installing-updates-features-roles/standard-terminology-software-updates) and [monthly quality update types](https://techcommunity.microsoft.com/blog/windows-itpro-blog/windows-monthly-updates-explained/3773544).  
## Improvements

This security update contains fixes and quality improvements from [KB5066835](https://support.microsoft.com/en-us/topic/october-14-2025-kb5066835-os-builds-26200-6899-and-26100-6899-1db237d8-9f3b-4218-9515-3e0a32729685) (released October 14, 2025). The following summary outlines key issues addressed by this update. Also, included are available new features. The bold text within the brackets indicates the item or area of the change. 

- **[Browser]** Fixed: This update addresses an issue that caused the print preview screen to stop responding in Chromium-based browsers.

- **[Gaming]** Fixed: An issue occurred when users signed in to a Windows device using only a Gamepad at the lock screen. If no other input methods, such as touch or fingerprint, were used during sign-in, apps and games did not respond to input afterward.

- **[PowerShell]**
    - Fixed: This update addresses an issue that affects PowerShell Remoting and Windows Remote Management (WinRM), where commands might time out after 10 minutes.
    - ​Fixed: This update addresses an issue that prevented an audit event from being logged.

- **[Windows Hello]** Fixed: This update addresses an issue that affects the setup process for Windows Hello face recognition when using USB infrared camera modules. Users were unable to complete setup due to a persistent error message, such as "Make sure your face is centered in the frame."

- **[Compatibility]** Fixed. This update removes the ltmdm64.sys driver. Fax modem hardware dependent on this specific driver will no longer work in Windows. 

If you've already installed previous updates, your device will download and install only the new updates included in this package.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [October 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Oct).

## Known issues

The following is a known issue with this update.

**Issue**

Problems playing protected content in some BluRay/DVD/Digital TV apps.

**Symptoms**

Some Digital TV and Blu-ray/DVD apps might not play protected content as expected after installing the August 29, 2025, Windows non-security preview update ([KB5064081](https://support.microsoft.com/topic/august-29-2025-kb5064081-os-build-26100-5074-preview-3f9eb9e1-72ca-4b42-af97-39aace788d93?preview=true)), or later updates.

Apps that use [Enhanced Video Renderer](/windows/win32/medfound/enhanced-video-renderer) with [HDCP enforcement](https://www.digital-cp.com/hdcp-specifications) or [Digital Rights Management (DRM)](/windows-hardware/drivers/audio/drm-overview) for digital audio might show copyright protection errors, frequent playback interruptions, unexpected stops, or black screens. 

Streaming services are not affected.  

**Workaround**

This issue is partially resolved. Problems affecting certain applications that use [Enhanced Video Renderer](/windows/win32/medfound/enhanced-video-renderer) with [HDCP enforcement](https://www.digital-cp.com/hdcp-specifications) have been addressed in the September 2025 Windows preview update ([KB5065789](https://support.microsoft.com/topic/september-29-2025-kb5065789-os-builds-26200-6725-and-26100-6725-preview-fa03ce47-cec5-4d1c-87d0-cac4195b4b4e?preview=true)) and later updates.

We recommend installing the latest update for your device. It includes important improvements and fixes, including a resolution for this issue.

However, some apps that use [DRM for digital audio](/windows-hardware/drivers/audio/drm-overview) might still experience problems. 

​​​​​​​We're investigating a long-term solution for affected apps and will share more information when it's available. 

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB 5066835](https://go.microsoft.com/fwlink/?linkid=2338912).

::: moniker-end

::: moniker range="=azloc-2509"

## September OS security updates (KB5065425 and KB5065426) for Azure Local

For the 2509 release of Azure Local, Microsoft released two security updates, each corresponding to a specific OS build. The following table provides the details of these security updates, including their associated OS builds and release dates.

| Security update | OS build | Release date |
|--|--|--|
| KB5065425 | 25398.1849 | September 09, 2025 |
| KB5065426 | 26100.6584 | September 09, 2025 |

# [OS build 25398.xxxx](#tab/os-build-25398-xxxx)

This section provides the 2509 security updates associated with OS build **25398.1849**.

## Windows Secure Boot certificate expiration

Secure Boot certificates used by most Windows devices are set to expire starting in June 2026. This might affect the ability of certain personal and business devices to boot securely if not updated in time. To avoid disruption, we recommend reviewing the guidance and taking action to update certificates in advance. For details and preparation steps, see [Windows Secure Boot certificate expiration and CA updates](https://support.microsoft.com/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e?preview=true).

To learn more about Windows update terminology, see [types of Windows updates](/troubleshoot/windows-client/installing-updates-features-roles/standard-terminology-software-updates) and [monthly quality update types](https://techcommunity.microsoft.com/blog/windows-itpro-blog/windows-monthly-updates-explained/3773544).  

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[App compatibility (known issue)]** Fixed: Addresses an issue that caused non-admin users to receive unexpected User Account Control (UAC) prompts when MSI installers perform certain custom actions. These actions might include configuration or repair operations in the foreground or background, during the initial installation of an application.

    This issue could prevent non-admin users from running apps that perform MSI repairs, including Office Professional Plus 2010 and multiple applications from Autodesk (including AutoCAD). This fix reduces the scope for requiring UAC prompts for MSI repairs and enables IT admins to disable UAC prompts for specific apps by adding them to an allowlist.

    For more information, see [Unexpected UAC prompts when running MSI repair operations after installing the August 2025 Windows security update](https://support.microsoft.com/topic/unexpected-uac-prompts-when-running-msi-repair-operations-after-installing-the-august-2025-windows-security-update-5806f583-e073-4675-9464-fe01974df273?preview=true).

- **[Device management]**​​​​​​​ Fixed: An issue where the removable storage policy didn’t correctly block external devices such as USB flash drives.  

- **[File sharing]** Fixed: This update addresses an issue where accessing files on a Server Message Block (SMB) share over Quick UDP Internet Connections (QUIC) might result in unexpected delays.

- **[File server]**: This update enabled auditing SMB client compatibility for SMB Server signing as well as SMB Server EPA. This allows customers to assess their environment and identify any potential device or software incompatibility issues before deploying the hardening measures that are already supported by SMB Server. For detailed guidance, see [CVE-2025-55234](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2025-55234).

- **[Input]**:

    - Fixed: This update fixes an issue where using Snap to organize desktop windows could cause the system to stop responding.

    - Fixed: An issue in Desktop Window Manager (uDWM) might cause the screen to stop responding during certain display operations.

    - Fixed: This update addresses an issue with the Chinese (Simplified) Input Method Editor (IME) where some extended characters appeared as empty boxes.

- **[Performance]** Improved: Added support for Certificate Revocation List (CRL) partitioning in Windows Certificate Authorities.  

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/security-guidance) and the [September 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Sep).

## Known issues

Microsoft is not currently aware of any issues with this update.​​​​​

## To install

**Before you install this update**

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

**Install this update**

| Release Channel | Available | Next Step |
|--|--|--|
| Windows Update and Microsoft Update | Yes | This update downloads and installs automatically from Windows Update. |
| Windows Update for Business | Yes | This update downloads and installs automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the [Microsoft Update Catalog](https://www.catalog.update.microsoft.com/Search.aspx?q=KB5065426). |
| Windows Server Update Services (WSUS) | Yes | This update automatically syncs with WSUS if you configure Products and Classifications as follows:<br>**Product:** Azure Stack HCI<br>**Classification:** Security Updates |

**If you want to remove the LCU**

To remove the LCU after installing the combined SSU and LCU package, use the DISM/Remove-Package command line option with the LCU package name as the argument. You can find the package name by using this command: **DISM /online /get-packages**.

Running [Windows Update Standalone Installer](https://support.microsoft.com/topic/description-of-the-windows-update-standalone-installer-in-windows-799ba3df-ec7e-b05e-ee13-1cdae8f23b19) **(wusa.exe)** with the **/uninstall** switch on the combined package will not work because the combined package contains the SSU. You cannot remove the SSU from the system after installation.

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5065425](https://go.microsoft.com/fwlink/?linkid=2335305).

# [OS build 26100.xxxx](#tab/os-build-26100-xxxx)

This section provides the 2509 security updates associated with OS build **26100.6584**.

## Windows Secure Boot certificate expiration

Secure Boot certificates used by most Windows devices are set to expire starting in June 2026. This might affect the ability of certain personal and business devices to boot securely if not updated in time. To avoid disruption, we recommend reviewing the guidance and taking action to update certificates in advance. For details and preparation steps, see [Windows Secure Boot certificate expiration and CA updates](https://support.microsoft.com/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e?preview=true).

To learn more about Windows update terminology, see [types of Windows updates](/troubleshoot/windows-client/installing-updates-features-roles/standard-terminology-software-updates) and [monthly quality update types](https://techcommunity.microsoft.com/blog/windows-itpro-blog/windows-monthly-updates-explained/3773544).  

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[App compatibility (known issue)]** ​​​​​​​Fixed: Addresses an issue that caused non-admin users to receive unexpected User Account Control (UAC) prompts when MSI installers perform certain [custom actions](/windows/win32/msi/custom-actions). These actions might include configuration or repair operations in the foreground or background, during the initial installation of an application.
    
    This issue could prevent non-admin users from running apps that perform MSI repairs, including Office Professional Plus 2010 and multiple applications from Autodesk (including AutoCAD). This fix reduces the scope for requiring UAC prompts for MSI repairs and enables IT admins to disable UAC prompts for specific apps by adding them to an allowlist.

    For more information, see [Unexpected UAC prompts when running MSI repair operations after installing the August 2025 Windows security update](https://support.microsoft.com/topic/unexpected-uac-prompts-when-running-msi-repair-operations-after-installing-the-august-2025-windows-security-update-5806f583-e073-4675-9464-fe01974df273?preview=true).

- **[File server]**: This update enabled auditing SMB client compatibility for SMB Server signing as well as SMB Server EPA. This allows customers to assess their environment and identify any potential device or software incompatibility issues before deploying the hardening measures that are already supported by SMB Server. For detailed guidance, see [CVE-2025-55234](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2025-55234).

- **[Input]**: 

    - Fixed: This update addresses an issue that caused certain apps to stop responding input in some input method scenarios.

    - Fixed: This update addresses an issue that caused some Internet Information Services (IIS) modules to disappear from IIS Manager, preventing users from configuring IIS using the IIS Manager interface.
    
- **[Networking (known issue)]** Fixed: This update addresses an issue that affects audio in apps using the Network Device Interface (NDI). Audio stutters when Display Capture is on in OBS Studio Application. This can occur after installing [KB5063878](https://support.microsoft.com/topic/august-12-2025-kb5063878-os-build-26100-4946-e4b87262-75c8-4fef-9df7-4a18099ee294?preview=true).

For details about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide) website and the [September 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Sep).

To find more information on Azure local, see [Azure Local solution overview](../overview.md).

## Known issues

The following is a known issue with this update:

**PSDirect connections failing in hotpatched devices**

**Symptoms**
 
We are aware of an edge case affecting hotpatched devices that have installed the September 2025 Hotpatch update [(KB5065474)](https://support.microsoft.com/topic/september-9-2025-kb5065474-hotpatch-for-windows-11-enterprise-version-24h2-os-build-26100-6508-1591ce1b-9c6f-4bc9-8d3d-d65240a738ee?preview=true) or the September 2025 security update [(KB5065426)](https://support.microsoft.com/topic/september-9-2025-kb5065426-os-build-26100-6584-77a41d9b-1b7c-4198-b9a5-3c4b6706dea9?preview=true). These devices might experience failures with [PowerShell Direct (PSDirect)](/windows-server/virtualization/hyper-v/powershell-direct) connections when the host and guest virtual machines (VMs) are both not fully updated.

When a patched guest VM attempts to connect to an unpatched host (or vice versa), the system is expected to fall back to a legacy handshake and clean up the socket gracefully. However, this fallback mechanism fails intermittently, resulting in socket cleanup issues. The connection failure might appear random, and users might observe Event ID [4625](/previous-versions/windows/it-pro/windows-10/security/threat-protection/auditing/event-4625) logged in the Security Event log within Windows Event Viewer.  

**Workaround**

This issue is addressed in [KB5066360](https://support.microsoft.com/topic/kb5066360-security-update-for-windows-powershell-hotpatch-1168dc4c-fa82-439d-9fc8-7d4231de0d5c?preview=true). If your hotpatched device is experiencing issues with PSDirect connection, we recommend updating both the host and guest VM with these updates.

## To install

**Before you install this update**

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

**Install this update**

| Release Channel | Available | Next Step |
|--|--|--|
| Windows Update and Microsoft Update | Yes | This update downloads and installs automatically from Windows Update. |
| Windows Update for Business | Yes | This update downloads and installs automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the [Microsoft Update Catalog](https://www.catalog.update.microsoft.com/Search.aspx?q=KB5065426). |
| Windows Server Update Services (WSUS) | Yes | This update automatically syncs with WSUS if you configure Products and Classifications as follows:<br>**Product:** Azure Stack HCI<br>**Classification:** Security Updates |

**If you want to remove the LCU**

To remove the LCU after installing the combined SSU and LCU package, use the DISM/Remove-Package command line option with the LCU package name as the argument. You can find the package name by using this command: **DISM /online /get-packages**.

Running [Windows Update Standalone Installer](https://support.microsoft.com/topic/description-of-the-windows-update-standalone-installer-in-windows-799ba3df-ec7e-b05e-ee13-1cdae8f23b19) **(wusa.exe)** with the **/uninstall** switch on the combined package will not work because the combined package contains the SSU. You cannot remove the SSU from the system after installation.

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5065426](https://go.microsoft.com/fwlink/?linkid=2334930).

::: moniker-end

::: moniker range="=azloc-2508"

## August OS security updates (KB5063899 and KB5063878) for Azure Local

For the 2508 release of Azure Local, Microsoft released two security updates, each corresponding to a specific OS build. The following table provides the details of these security updates, including their associated OS builds and release dates.

| Security update | OS build | Release date |
|--|--|--|
| KB5063899 | 25398.1791 | August 12, 2025 |
| KB5063878 | 26100.4946 | August 12, 2025 |

# [OS build 25398.xxxx](#tab/os-build-25398-xxxx)

This section provides the 2508 security updates associated with OS build **25398.1791**.

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Input]** Fixed: An issue when using the Microsoft Changjie IME (input method editor) for Traditional Chinese might cause problems such as not being able to form or select words, unresponsive spacebar or blank key, incorrect word output, or a broken candidate window display. This can occur after installing KB5062570.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [August 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Aug).

## Known issues

Microsoft is not currently aware of any issues with this update.​​​​​ 

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5063899](https://go.microsoft.com/fwlink/?linkid=2331617).


# [OS build 26100.xxxx](#tab/os-build-26100-xxxx)

This section provides the 2508 security updates associated with OS build **26100.4946**.

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Authentication]** Fixed: This update addresses an issue that caused delays during sign-in on new devices. The delay was due to certain pre-installed packages.  

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [August 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Aug).

## Known issues

Microsoft is not currently aware of any issues with this update.​​​​​ 

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5063878](https://go.microsoft.com/fwlink/?linkid=2331814).

::: moniker-end

::: moniker range="=azloc-2507"

## July OS security updates (KB5062570 and KB5062553) for Azure Local

For the 2507 release of Azure Local, Microsoft released two security updates, each corresponding to a specific OS build. The following table provides the details of these security updates, including their associated OS builds and release dates.

| Security update | OS build | Release date |
|--|--|--|
| KB5062570 | 25398.1732 | July 8, 2025 |
| KB5062553 | 26100.4652 | July 8, 2025 |

# [OS build 25398.xxxx](#tab/os-build-25398-xxxx)

This section provides the 2507 security updates associated with OS build **25398.1732**.

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[DNS Server]** Fixed: This update addresses an issue where a full zone transfer can't be completed from a Windows DNS server to another DNS server when Extension Mechanisms for DNS is enabled. 

- **[Language and character support]** Fixed: An issue that affected some Chinese characters and experienced compliance issues with GB18030. These characters didn't display correctly or weren't accepted when using extended Unicode. A modern ICU-based solution now properly supports GB18030-2022 requirements. 

- **[Performance]** Fixed: This update addresses an issue that prevented the complete removal of unused language packs and Feature on Demand packages, which previously led to unnecessary storage use and longer Windows Update installation times. 

- **[Security]** Fixed: This update upgrades the curl tool in Windows to version 8.13.0 to help protect against potential security risks, including unauthorized access to data or service disruptions.

- **[Microsoft RPC Netlogon protocol]** Fixed: This update includes a security hardening change to the Microsoft RPC Netlogon protocol. This change improves security by tightening access checks for a set of remote procedure call (RPC) requests. After this update is installed, Active Directory domain controllers will no longer allow anonymous clients to invoke some RPC requests through the Netlogon RPC server. These requests are typically related to domain controller location. Certain file and print service software can be affected, including Samba. If your organization uses Samba, please refer to the [Samba release notes](https://www.samba.org/samba/history/samba-4.22.3.html).

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [July 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Jul).

## Known issues

Microsoft is not currently aware of any issues with this update.​​​​​ 

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5062570.](https://go.microsoft.com/fwlink/?linkid=2326815).


# [OS build 26100.xxxx](#tab/os-build-26100-xxxx)

This section provides the 2507 security updates associated with OS build **26100.4652**.

## Improvements

This security update includes quality improvements. Here is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Graphics]** Fixed: This issue occurs only if the June 2025 non-security update (KB5060829) is installed. The cursor might shift out of place after pressing **ALT+Tab** to switch away from certain games running in full screen exclusive mode, when the game resolution doesn't match the desktop resolution. 

- **[Multimedia]** Fixed: This update addresses an issue where notification sounds didn't play. Affected sounds included those for on-screen alerts, volume adjustments, and sign-in.

- **[Windows Firewall]** Fixed: This update addresses an issue found in Event Viewer as Event 2042 for Windows Firewall with Advanced Security. The event appears as "Config Read Failed" with the message "More data is available." For more information about this issue, see "Error events are logged for Windows Firewall" in the Windows Health Dashboard.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [July 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Jul).

## Known issues

The following are known issues with this update:

### Azure Local VM with Trusted Launch disabled

**Symptom**

A small subset of Generation 2 Azure Virtual Machines (VMs) with Trusted Launch disabled and Virtualization-Based Security (VBS) enforced via registry key might be unable to boot after installing this update.

To check if your virtual machine might be impacted:

1. Check if your VM is created as "Standard".

1. Check if VBS is enabled. Open **System Information** (msinfo32.exe) and confirm that Virtualization-based security is running and that the Hyper-V role is not installed on the VM.

**Workaround**

The workaround is addressed in [KB5064489](https://support.microsoft.com/topic/july-13-2025-kb5064489-os-build-26100-4656-out-of-band-14a82ab2-100f-4dd4-8141-f490ec90c8f4).

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5062553.](https://go.microsoft.com/fwlink/?linkid=2326816).

::: moniker-end

::: moniker range="=azloc-2506"

## June OS security updates (KB5060118 and KB5060842) for Azure Local

For the 2506 release of Azure Local, Microsoft released two security updates, each corresponding to a specific OS build. The following table provides the details of these security updates, including their associated OS builds and release dates.

| Security update | OS build | Release date |
|--|--|--|
| KB5060118 | 25398.1665 | June 10, 2025 |
| KB5060842 | 26100.4349 | June 10, 2025 |

# [OS build 25398.xxxx](#tab/os-build-25398-xxxx)

This section provides the 2506 security updates associated with OS build **25398.1665**.

## Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Graphics]** Fixed: An issue where some characters appear wider than standard characters, and the sample paragraph in the font preview section doesn’t display correctly.

- **[Memory leak]** Fixed: This update addresses an issue in the Input Service that causes increased memory usage, potentially impacting performance in multi-user, multilingual, and remote desktop environments.

- **[Windows Hello]** Fixed: This update addresses an issue that prevents users from signing in with self-signed certificates when using Windows Hello for Business with the Key Trust model.​​​​​​​

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [June 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Jun).

## Known issues

Microsoft is not currently aware of any issues with this update.​​​​​

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5060118.](https://go.microsoft.com/fwlink/?linkid=2323858).

# [OS build 26100.xxxx](#tab/os-build-26100-xxxx)

This section provides the 2506 security updates associated with OS build **26100.4349**.

## Improvements

This security update includes quality improvements. Here is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[System Restore]** After installing the June 2025 Windows security update, Azure Local, version 24H2 retains system restore points for up to 60 days. To apply a restore point, select **Open System Restore**. Restore points older than 60 days aren't available. This 60-day limit also applies to later releases of Azure Local, version 24H2.

- **[Windows Hello]** Fixed: This update addresses an issue that prevents users from signing in with self-signed certificates when using Windows Hello for Business with the Key Trust model.​​​​​​​

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [June 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Jun).

## Known issues

### Noto fonts

**Symptoms**

There are reports of blurry or unclear CJK (Chinese, Japanese, Korean) text when displayed at 96 DPI (100% scaling) in Chromium-based browsers such as Microsoft Edge and Google Chrome. The March 2025 Preview Update introduced Noto fonts in collaboration with Google, for CJK languages as fallbacks to improve text rendering when websites or apps don’t specify appropriate fonts. The issue is due to limited pixel density at 96 DPI, which can reduce the clarity and alignment of CJK characters. Increasing the display scaling improves clarity by enhancing text rendering.

**Resolution**

As a temporary workaround, increase your display scaling to 125% or 150% to improve text clarity. For more information, see Change your screen resolution and layout in Windows.

We're investigating this issue and will provide more information when it's available.

## To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

## File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5060842.](https://go.microsoft.com/fwlink/?linkid=2323769).

::: moniker-end

::: moniker range="=azloc-previous"

## May OS security updates (KB5058384 and KB5058411) for Azure Local

For the 2505 release of Azure Local, Microsoft released two security updates, each corresponding to a specific OS build. The following table provides the details of these security updates, including their associated OS builds and release dates.

| Security update | OS build | Release date |
|--|--|--|
| KB5058384 | 25398.1611 | May 13, 2025 |
| KB5058411 | 26100.4061 | May 13, 2025 |

# [OS build 25398.xxxx](#tab/os-build-25398-xxxx)

This section provides the 2505 security updates associated with OS build **25398.1611**.

### Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Graphics]** Fixed: This update addresses an issue where users are unable to export or generate PDF or XLSX format reports with charts. 

- **[Graphics kernel]** Fixed: This update addresses an issue that affects users trying to start a new console session after closing the previous one, where the new session doesn't start successfully. 

- **[Windows Kernel Vulnerable Driver Blocklist file (DriverSiPolicy.p7b)]** This update adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks. 

- **[Azure Virtual Network]** Fixed: You can turn off the network interface card (NIC) symmetry check feature with the following registry keys:  

    - Registry key: **SYSTEM\CurrentControlSet\Services\NetworkAtc\\**

    - Registry value: **NicSymmetryCheckEnabled**

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [May 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-May).

### Known issues

Microsoft is not currently aware of any issues with this update.​​​​​ 

### To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

> [!NOTE]
> This LCU includes an update for AI components in the Microsoft Update Catalog. Even though the AI component updates are included in this LCU, the AI components are only applicable to Windows Copilot+ PCs and won't install on Windows PC or Windows Server.

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5058384.](https://go.microsoft.com/fwlink/?linkid=2320746).

# [OS build 26100.xxxx](#tab/os-build-26100-xxxx)

This section provides the 2505 security updates associated with OS build **26100.4061**.

### Improvements

This security update includes quality improvements. Here is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Audio]** Fixed: This update addresses an issue where the audio from your microphone might mute unexpectedly.

- **[Eye controller]** Fixed: The eye controller app doesn't launch.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [May 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-May).

### AI components

The following AI components have been updated with this release: 

| AI Component | Version |
| -- | -- |
| Image Search | 1.7.824.0 |
| Content Extraction | 1.7.824.0 |
| Semantic Analysis | 1.7.824.0 |

### Known issues

Microsoft is not currently aware of any issues with this update.​​​​​ 

### To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5058411.](https://go.microsoft.com/fwlink/?linkid=2320918).

---

## April OS security updates (KB5055527 and KB5055523) for Azure Local

For the 2504 release of Azure Local, Microsoft released two security updates, each corresponding to a specific OS build. The following table provides the details of these security updates, including their associated OS builds and release dates.

| Security update | OS build | Release date |
|--|--|--|
| KB5055527 | 25398.1551 | April 12, 2025 |
| KB5055523 | 26100.3775 | April 12, 2025 |

# [OS build 25398.xxxx](#tab/os-build-25398-xxxx)

This section provides the 2504 security updates associated with OS build **25398.1551**.

### Improvements

This security update includes quality improvements. Here is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Daylight saving time (DST)]** Update for the Aysen region in Chile to support the government DST change order in 2025. For more info about DST changes, see the [Daylight Saving Time & Time Zone Blog](https://techcommunity.microsoft.com/category/windows/blog/dstblog).

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [April 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Apr).

### Known issues

The following is a known issue with this update.

**Symptom**

Devices that have certain Citrix components installed might be unable to complete installation of the January 2025 Windows security update.
  
Affected devices might initially download and apply the January 2025 Windows security update correctly, such as via the Windows Update page in Settings. However, when restarting the device to complete the update installation, an error message with text similar to "*Something didn't go as planned. No need to worry – undoing changes*" appears. The device then reverts to the Windows updates previously present on the device.  
  
This issue likely affects a limited number of organizations as version 2411 of the SRA application is a new version. Home users aren't expected to be affected by this issue.

**Workaround**

The issue has been resolved in Citrix Session Recording Agent version 2503, released on April 28, 2025, and newer versions.


### To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5055527](https://go.microsoft.com/fwlink/?linkid=2313660).

# [OS build 26100.xxxx](#tab/os-build-26100-xxxx)

This section provides the 2504 security updates associated with OS build **26100.3775**.

### Improvements

This security update includes quality improvements. Here is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Authentication]** This update addresses an issue affecting machine password rotation in the Identity Update Manager certificate/Pre-Bootstrapping Key Initialization path. This issue occurred particularly when Kerberos was used and Credential Guard was enabled, potentially causing user authentication problems. The feature **Machine Accounts in Credential Guard**, which is dependent on password rotation via Kerberos, is disabled until a permanent fix is made available.

- **[Daylight Saving Time (DST)]** This update is for the Aysen region in Chile to support the government DST change order in 2025. For more info about DST changes, see the [Daylight Saving Time & Time Zone Blog](https://techcommunity.microsoft.com/category/windows/blog/dstblog).

- **[PcaUiArm]** This update addresses an issue affecting the **PcaUiArmUpdate** feature, which results in unexpected behavior in specific scenarios.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [April 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Apr).

### Known issues

This update has the following known issues:

**Symptom**

Devices that have certain Citrix components installed might be unable to complete installation of the January 2025 Windows security update.
  
Affected devices might initially download and apply the January 2025 Windows security update correctly, such as via the Windows Update page in Settings. However, when restarting the device to complete the update installation, an error message with text similar to *"Something didn't go as planned. No need to worry – undoing changes"* appears. The device will then revert to the Windows updates previously present on the device.  
  
This issue likely affects a limited number of organizations as version 2411 of the SRA application is a new version. Home users aren't expected to be affected by this issue.  

**Workaround**

The issue has been resolved in Citrix Session Recording Agent version 2503, released on April 28, 2025, and newer versions.


### To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5055523](https://go.microsoft.com/fwlink/?linkid=2313854).

---

## March OS security update (KB5053599) for Azure Local

This article describes the OS security update for Azure Local that was released on March 11, 2025 and applies to OS build 25398.1486.

### Improvements 

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Daylight saving time (DST)]** This update supports (DST) changes in Paraguay.

- **[Open Secure Shell (OpenSSH) (known issue)]** Fixed: The service fails to start, which stops SSH connections. There's no detailed logging, and you must run the sshd.exe process manually. 

- **[GB18030-2022]** This update adds support for this amendment. 

- **[Azure Virtual Network]** Fixed: You can turn off the virtual network metering feature with the following registry key:

    **HKLM\CurrentControlSet\Services\NcHostAgent\Parameters\Plugins\Vnet**

    Registry value:  **MeteringDisabled (DWORD type)**

    Data to be set: 1 

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [March 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Mar).

### Known issues

The following is a known issue with this update.

**Symptom**

Devices that have certain Citrix components installed might be unable to complete installation of the January 2025 Windows security update.
  
Affected devices might initially download and apply the January 2025 Windows security update correctly, such as via the Windows Update page in Settings. However, when restarting the device to complete the update installation, an error message with text similar to "*Something didn't go as planned. No need to worry – undoing changes*" appears. The device will then revert to the Windows updates previously present on the device.  
  
This issue likely affects a limited number of organizations as version 2411 of the SRA application is a new version. Home users are not expected to be affected by this issue.  

**Workaround**

The issue has been resolved in Citrix Session Recording Agent version 2503, released on April 28, 2025, and newer versions.

### To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5053599](https://go.microsoft.com/fwlink/?linkid=2309855).

## February OS security update (KB5051980) for Azure Local

This article describes the OS security update for Azure Local that was released on February 11, 2025 and applies to OS build 25398.1425.

### Improvements 

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Cluster stability]** Fixed: Many machines within the same system suddenly shut down. The network is less available, and latency rises.  

- **[Task Manager]** Fixed: The CPU index number might be wrong when you set process affinity. This occurs on servers that have two or more non-uniform memory access (NUMA) nodes.  

- **[GB18030-2022]** This update adds support for this amendment.  

- **[Memory leak]** Fixed: Leaks occur when predictive input ideas show.  

- **[Windows Kernel Vulnerable Driver Blocklist file (DriverSiPolicy.p7b)]** This update adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.  

- **[Virtual machine (VM) storage pool]** Fixed: Some operations that rely on a storage pool stop working. This occurs because the virtual machine (VM)can't reclaim disk space to do task such as load balancing.

- **[USB cameras]** Fixed: Your device does not recognize the camera is on. This issue occurs after you install the January 2025 security update.

- **Digital/Analog converter (DAC)** Fixed: You might experience issues with USB audio devices. This is more likely when you use a DAC audio driver based on [USB 1.0](/windows-hardware/drivers/audio/usb-audio-class-system-driver--usbaudio-sys-). USB audio devices might stop working, which stops playback.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [February 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Feb).

### Known issues

The following is a known issue with this update.

**Symptom**

Following the installation of the October 2024 security update, some customers report that the OpenSSH (Open Secure Shell) service fails to start, preventing SSH connections. The service fails with no detailed logging, and manual intervention is required to run the sshd.exe process.

This issue is affecting enterprise, IOT, and education customers, with a limited number of devices impacted. Microsoft is investigating whether consumer customers using Home or Pro editions of Windows are also affected.

**Workaround**

You can temporarily resolve this issue by updating permissions (ACLs) on the affected directories. Follow these steps:

1. Open PowerShell as an administrator.

1. Update the permissions for *C:\ProgramData\ssh* and *C:\ProgramData\ssh\logs* to allow full control for **System** and the **Administrators** group, while allowing read access for **Authenticated Users**. You can restrict read access to specific users or groups by modifying the permissions string if needed.

1. Use the following commands to update the permissions:

    ```azurecli
    $directoryPath = "C:\ProgramData\ssh" $acl = Get-Acl -Path $directoryPath $sddlString = "O:BAD:PAI(A;OICI;FA;;;SY)(A;OICI;FA;;;BA)(A;OICI;0x1200a9;;;AU)" $securityDescriptor = New-Object System.Security.AccessControl.RawSecurityDescriptor $sddlString $acl.SetSecurityDescriptorSddlForm($securityDescriptor.GetSddlForm("All")) Set-Acl -Path $directoryPath -AclObject $acl
    ```

1. Repeat the above steps for *C:\ProgramData\ssh\logs*.

Microsoft is actively investigating the issue and will provide a resolution in an upcoming Windows update. Further communications will be provided when a resolution or addition is available.

### To install

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB 5051980](https://go.microsoft.com/fwlink/?linkid=2303533).

## January OS security update (KB5049984) for Azure Local

This article describes the OS security update for Azure Local that was released on January 14, 2025 and applies to OS build 25398.1369.

### Improvements

This security update includes quality improvements. Here is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Virtual machine (VM) Fixed]**: A Windows guest machine fails to start up. This occurs when you turn on nested virtualization on a host that supports Advanced Vector Extensions 10 (AVX10).  

- **[Windows Kernel Vulnerable Driver Blocklist file (DriverSiPolicy.p7b)]**: This update adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.

- **[Win32_NetworkAdapter and Win32_NetworkAdapterConfiguration Fixed]**: You can't retrieve LAN over USB details on a certain platform. This occurs when you install two drivers on a device, and one of them has a different class ID. If you still have this issue after you install this update, run the commands below with administrative rights.
    - `pnputil /remove-device <Instance ID>`
    - `pnputil /scan-device`


For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [January 2025 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2025-Jan).

### Known issues

Microsoft is not currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB5049984](https://go.microsoft.com/fwlink/?linkid=2300815).

## December OS security update (KB5048653) for Azure Local

This section describes the OS security update for Azure Local that was released on December 17, 2024 and applies to OS build 25398.1308.

### Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[Motherboard replacement]** Fixed: Windows does not activate after you replace a motherboard.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [December 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Dec).

### Known issues

Microsoft is not currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB 5048653](https://go.microsoft.com/fwlink/?linkid=2299751).

## November OS security update (KB) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on November 12, 2024 and applies to OS build 25398.1251.

### Improvements

This security update includes quality improvements. Below is a summary of the key issues that this update addresses when you install this KB. If there are new features, it lists them as well. The bold text within the brackets indicates the item or area of the change.

- **[FrameShutdownDelay]** Fixed: The browser ignores its value in the *HKLM\SOFTWARE\Microsoft\Internet Explorer\Main* registry key.  

- **[vmswitch]** Fixed: A VMswitch triggers a stop error. This occurs when you use Load Balancing and Failover (LBFO) teaming with two virtual switches on a virtual machine (VM). In this case, one virtual switch uses single root Input/Output Virtualization (SR-IOV).  

- **[Collector sets]** Fixed: They don't close properly when an exception occurs during startup or while the set is active. Because of this, the command to stop a collector set stops responding.  

- **[Windows Kernel Vulnerable Driver Blocklist file (DriverSiPolicy.p7b)]** This update adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.  

- **[Windows Backup]** Fixed: Backup sometimes fails. This occurs when a device has an Extensible Firmware Interface (EFI) system partition (ESP).

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [November 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Nov).

### Known issues

Microsoft is not currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Stack Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update KB 5046618](https://go.microsoft.com/fwlink/?linkid=2296832).

## October OS security update (KB 5044288) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on October 8, 2024 and applies to OS build 25398.1189.

<!--For an overview of Azure Local, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. The following key issues and new features are present in this update:

- **Microsoft Defender for Endpoint**: Work Folders files fail to sync when Defender for Endpoint is on.

- **Input Method Editor (IME)** When a combo box has input focus, a memory leak might occur when you close that window.

- **AppLocker** The rule collection enforcement mode is not overwritten when rules merge with a collection that has no rules. This occurs when the enforcement mode is set to "Not Configured".

- **Remote Desktop Gateway Service** The service stops responding. This occurs when a service uses remote procedure calls (RPC) over HTTP. Because of this, the clients that are using the service disconnect.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [October 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Oct).

### Known issues

Microsoft is not currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5044288](https://go.microsoft.com/fwlink/?linkid=2289974).

## September OS security update (KB 5043055) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on September 10, 2024 and applies to OS build 25398.1128.

<!--For an overview of Azure Local, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. The following key issues and new features are present in this update:

- **Windows Installer** When repairing an application, the User Account Control (UAC) doesn't prompt for your credentials. After you install this update, the UAC will then prompt for them. Because of this, you must update your automation scripts. Application owners must add the Shield icon. It indicates that the process requires full administrator access. To turn off the UAC prompt, set the `HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer\DisableLUAInRepair` registry value to `1`.

    The changes in this update might affect automatic Windows Installer repairs - see [Application Resiliency: Unlock the Hidden Features of Windows Installer](/previous-versions/dotnet/articles/aa302344(v=msdn.10)).  

- **BitLocker** You might not be able to decrypt a BitLocker data drive. This occurs when you move that drive from a newer version of Windows to an older version.  

- **Unified Write Filter (UWF) Windows Management Instrumentation (WMI)** API calls to shut down or restart a system results in an `access denied` exception.  

- **Azure Virtual Desktop** A deadlock stops you from signing in to sessions.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [September 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-sep).

### Known issues

Microsoft is not currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5043055](https://go.microsoft.com/fwlink/?linkid=2278952).

## August 2024 OS security update (KB 5041573) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on August 13, 2024 and applies to OS build 25398.1085.

<!--For an overview of Azure Local, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. The following key issues and features are present in this update:

- **Stability of clusters on Windows Server 2022**. Machines in the same cluster shutdown when you don't expect them to. This leads to high latency and network availability issues.  

- **Bootloader**. A race condition might stop a computer from starting. This occurs when you configure the bootloader to start many operating systems.  

- **Autopilot**. Using Autopilot to provision a Surface Laptop SE device fails.  

- **Windows Defender Application Control (WDAC)**. A memory leak occurs that might exhaust system memory as time goes by. This issue occurs when you provision a device.  

- **Protected Process Light (PPL) protections**. You can bypass them.  

- **Windows Kernel Vulnerable Driver Blocklist file (DriverSiPolicy.p7b)**. This update adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.  

- **NetJoinLegacyAccountReuse**. This update removes this registry key. For more information, see [KB 5020276 Net join: Domain join hardening changes](https://support.microsoft.com/topic/kb5020276-netjoin-domain-join-hardening-changes-2b65a0f3-1f4c-42ef-ac0f-1caaf421baf8).

- **BitLocker (known issue)**. A [BitLocker recovery screen](/windows/security/operating-system-security/data-protection/bitlocker/recovery-overview) shows when you start up your device. This occurs after you install the July 9, 2024, update. This issue is more likely to occur if [device encryption](https://support.microsoft.com/windows/turn-on-device-encryption-0c453637-bc88-5f74-5105-741561aae838) is on. Go to **Settings > Privacy & Security > Device encryption**. To unlock your drive, Windows might ask you to enter the recovery key from your Microsoft account.

- **Lock screen**. This update addresses CVE-2024-38143. As a result, the **Use my windows user account** check box isn't available on the lock screen to connect to Wi-Fi.

- **Secure Boot Advanced Targeting (SBAT) and Linux Extensible Firmware Interface (EFI)**. This update applies SBAT to systems that run Windows and stops vulnerable Linux EFI (shim bootloaders) from running. This update doesn't apply to systems that dual-boot Windows and Linux. After the update is applied, older Linux ISO images might not boot. If this occurs, work with your Linux vendor to get an updated ISO image.

- **Domain Name System (DNS)**. This update hardens DNS server security to address CVE-2024-37968. If the configurations of your domains aren't up to date, you might get the SERVFAIL error or a time-out.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [August 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Aug).

### Known issues

Microsoft isn't currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5041573](https://go.microsoft.com/fwlink/?linkid=2282056).

## July 2024 OS security update (KB 5040438) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on July 16, 2024 and applies to OS build 25398.1009.

<!--For an overview of Azure Local, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. The following key issues and features are present in this update:

- **BitLocker**. This update adds PCR 4 to PCR 7 and 11 for the default Secure Boot validation profile. For more information, see [CVE-2024-38058](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2024-38058).

- **Absent apps and features**. Some apps and features are absent after you upgrade to Windows 11.

- **[BCryptSignHash](/windows/win32/api/bcrypt/nf-bcrypt-bcryptsignhash) API known issue**. Because of this issue, the API returns `STATUS_INVALID_PARAMETER`. This occurs when callers use NULL padding input parameters for RSA signatures. This issue is more likely to occur when Customer-Managed Keys (CMKs) are in use, like on an Azure Synapse dedicated SQL pool.

- **Input Method Editor (IME)**. The candidate list fails to show or shows it in the wrong position.

- **Windows Presentation Foundation (WPF)**. A malformed Human Interface Device (HID) descriptor causes WPF to stop responding.

- **Handwriting panels and touch keyboards**. They don't appear when you use the tablet pen.

- ***HKLM\Software\Microsoft\Windows\DWM ForceDisableModeChangeAnimation (REG_DWORD)***. This is a new registry key. When you set its value to `1` (or a non-zero number), it turns off the display mode change animation. If the value is `0` or the key doesn't exist, the animation is set to on.

- **Remote Desktop MultiPoint Server**. A race condition causes the service to stop responding.

- **Windows Local Administrator Password Solution (LAPS)**. Post Authentication Actions (PAA) don't occur at the end of the grace period. Instead, they occur at restart.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [July 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Jul).

### Known issues

#### BitLocker recovery key issue

After you apply the July security updates, devices enabled with Secure Boot and BitLocker protection might enter BitLocker recovery mode. This might happen after one or two reboots.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5040438](https://go.microsoft.com/fwlink/?linkid=2278952).

## June 2024 OS security update (KB 5039236) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on June 19, 2024 and applies to OS build 25398.950.

<!--For an overview of Azure Local, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. When you install this KB:

- This update affects Server Message Block (SMB) over Quick UDP Internet Connections (QUIC). It turns on the SMB over QUIC client certificate authentication feature. Administrators can use it to restrict which clients can access SMB over QUIC servers. For more information, see [Configure SMB over QUIC client access control in Windows Server](/windows-server/storage/file-server/configure-smb-over-quic-client-access-control).

- This update affects the version of **curl.exe** that is in Windows. The version number is now 8.7.1.  

- This update addresses an issue that affects **lsass.exe**. It stops responding. This occurs after you install the April 2024 security updates on Windows servers.

- This update addresses an issue that affects Microsoft Edge. The UI is wrong for the **Internet Options Data Settings**.  

- This update affects the Antimalware Scan Interface (AMSI) **AmsiUtil** class. It helps to detect the bypass of the AMSI scan. This update also addresses some long-term issues that expose your device to threats.  

- This update addresses an issue that affects Storage Spaces Direct (S2D) and Remote Direct Memory Access (RDMA). When you use them with SMBdirect in your networks, the networks fail. You also lose the ability to manage clusters.  

- This update addresses an issue that affects **dsamain.exe**. It stops responding. This occurs when the Knowledge Consistency Checker (KCC) runs evaluations.  

- This update addresses an issue that affects **lsass.exe**. It leaks memory. This occurs during a Local Security Authority (Domain Policy) Remote Protocol (LSARPC) call.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [June 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-June).

### Known issues

Microsoft isn't currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5039236](https://go.microsoft.com/fwlink/?linkid=2275128).

## May 2024 OS security update (KB 5037781) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on May 14, 2024 and applies to OS build 25398.887.

<!--For an overview of Azure Local, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. When you install this KB:

- This update affects Windows Defender Application Control (WDAC). The update addresses an issue that might cause some applications to fail when you apply WDAC Application ID policies.

- This update addresses an issue that affects IE mode. A web page may stop working as expected when there's an open modal dialog.

- This update addresses an issue that affects IE mode. It stops responding. This occurs if you press the left arrow key when an empty text box has focus and caret browsing is on.

- This update addresses an issue that affects Wi-Fi Protected Access 3 (WPA3) in the Group Policy editor. HTML preview rendering fails.

- This update addresses an issue that affects Packet Monitor (pktmon). It's less reliable.

- This update addresses an issue that affects a machine after you remove it from a domain. The `Get-LocalGroupMember` cmdlet returns an exception. This occurs if the local groups contain domain members.

- This update affects next secure record 3 (NSEC3) validation in a recursive resolver. Its limit is now 1,000 computations. One computation is equal to the validation of one label with one iteration. DNS Server Administrators can change the default number of computations. To do this, use the registry setting below:

    - Name: `\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\DNS\Parameters\MaxComputationForNsec3Validation`
    - Type: DWORD
    - Default: 1000
    - Max: 9600
    - Min: 1

- This update addresses an issue that might affect the cursor when you type in Japanese. The cursor might move to an unexpected place.

- This update addresses an issue that affects the cursor. Its movement lags in some screen capture scenarios. This is especially true when you're using the remote desktop protocol (RDP).

- This update includes quarterly changes to the Windows Kernel Vulnerable Driver Blocklist file, `DriverSiPolicy.p7b`. It adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.

- This update addresses an issue that affects Trusted Platform Modules (TPM). On certain devices, they don't initialize correctly. Because of this, TPM-based scenarios stop working.

- This update addresses an issue that affects Active Directory. Bind requests to IPv6 addresses fail. This occurs when the requestor isn't joined to a domain.

- This update addresses an issue that might affect Virtual Secure Mode (VSM) scenarios. They might fail. These scenarios include VPN, Windows Hello, Credential Guard, and Key Guard.

- This update addresses an issue that might affect domain controllers. NTLM authentication traffic might increase.

- This update addresses a known issue that might cause your VPN connection to fail. This occurs after you install the update dated April 9, 2024 or later.

For more information about security vulnerabilities, see the [Security Update Guide](https://portal.msrc.microsoft.com/security-guidance) and the [May 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-May).


### Known issues

Microsoft isn't currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Local instance, see [Update Azure Local instances](../update/about-updates-23h2.md).

### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5037781](https://go.microsoft.com/fwlink/?linkid=2271901).

## April 2024 OS security update (KB 5036910) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on April 16, 2024 and applies to OS build 25398.830.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. When you install this KB:

- This update supports daylight saving time (DST) changes in Palestinian Authority. To learn more, see [Interim guidance for DST changes](https://techcommunity.microsoft.com/t5/daylight-saving-time-time-zone/interim-guidance-for-dst-changes-announced-by-palestinian/ba-p/4048966) announced by Palestinian Authority for 2024, 2025.

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


### Known issues

Microsoft isn't currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).


### File list

For a list of the files that are provided in this update, download the file information for [Cumulative update 5036910](https://go.microsoft.com/fwlink/?linkid=2267131).

## March 2024 OS security update (KB 5035856) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on March 20, 2024 and applies to OS build 25398.763.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. When you install this KB:

- This update addresses an issue that affects Windows Defender Application Control (WDAC). It prevents a stop error that occurs when you apply more than 32 policies.

- This update addresses an issue that makes the troubleshooting process fail. This occurs when you use the **Get Help** app.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [March 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Mar).

<!--## Servicing stack update - 25398.760

This update makes quality improvements to the servicing stack, which is the component that installs Windows updates. Servicing stack updates (SSU) ensure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.-->

### Known issues

Microsoft isn't currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI clusters](../update/about-updates-23h2.md).

<!--| Release Channel | Available | Next Step |
|--| -- |--|
| Windows Update and Microsoft Update | Yes | None. This update is downloaded automatically from Windows Update. |
| Windows Update for Business | Yes | None. This update is downloaded automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the Microsoft Update Catalog website. |
| Windows Server Update Services (WSUS) | Yes | This update automatically syncs with WSUS if you configure Products and Classifications as follows:<br>Product: Azure Stack HCI<br>Classification: Security Updates |-->


### File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5035856](https://go.microsoft.com/fwlink/?linkid=2263215).


## February 2024 OS security update (KB 5034769) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the OS security update for Azure Local that was released on February 13, 2024 and applies to OS build 25398.709.

<!--For an overview of Azure Stack HCI, version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. When you install this KB:

- This update affects software defined networking (SDN). You can now deploy SDN on Windows failover clustering. Service Fabric SDN deployment remains in support.

- This update addresses a handle leak in Windows Management Instrumentation (WMI) provider traces. Because of this, WMI commands fail at a random stage when you deploy a cluster.

- This update addresses an issue that affects remote direct memory access (RDMA) performance counters. They don't return networking data on VMs in the right way.

- This update addresses an issue that affects **fontdrvhost.exe**. It stops responding when you use Compact Font Format version 2 (CFF2) fonts.

- This update addresses an issue that affects clusters. It stops you from registering a cluster using Network ATC. This occurs after you set the proxy to use Network ATC. The issue also stops a preset proxy configuration from clearing.

- This update addresses a memory leak in **TextInputHost.exe**. The leak might cause text input to stop working on devices that haven't restarted for many days.

- This update addresses an issue that affects touchscreens. They don't work properly when you use more than one monitor.

- This update includes quarterly changes to the Windows Kernel Vulnerable Driver Blocklist file, **DriverSiPolicy.p7b**. It adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.

- This update affects Unified Extensible Firmware Interface (UEFI) Secure Boot systems. It adds a renewed signing certificate to the Secure Boot DB variable. You can now opt for this change. For more information, see [KB5036210](https://support.microsoft.com/topic/kb5036210-deploying-windows-uefi-ca-2023-certificate-to-secure-boot-allowed-signature-database-db-a68a3eae-292b-4224-9490-299e303b450b).

- This update addresses an issue that occurs after you run a [Push-button reset](/windows-hardware/manufacture/desktop/how-push-button-reset-features-work). You can't set up Windows Hello facial recognition. This affects devices that have Windows Enhanced Sign-in Security (ESS) turned on.

- This update addresses an issue that affects the download of device metadata. Downloads from the Windows Metadata and Internet Services (WMIS) over HTTPS are now more secure.

- This update addresses an issue that affects the Local Security Authority Subsystem Service (LSASS). It might stop working. This occurs when you access the Active Directory database.

- This update addresses an issue that affects the Certificate Authority snap-in. You can't select the "Delta CRL" option. This stops you from using the GUI to publish Delta CRLs.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [February 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Feb). 

To return to the Azure Stack HCI documentation site.

<!--## Servicing stack update - 25398.700

This update makes quality improvements to the servicing stack, which is the component that installs Windows updates. Servicing stack updates (SSU) ensure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.-->

### Known issues

Microsoft isn't currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI via PowerShell](../update/update-via-powershell-23h2.md).

<!--| Release Channel | Available | Next Step |
|----|----|----|
| Windows Update and Microsoft Update | Yes | None. This update is downloaded automatically from Windows Update. |
| Windows Update for Business | Yes | None. This update is downloaded automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the Microsoft Update Catalog website. |
| Windows Server Update Services (WSUS) | Yes | This update automatically syncs with WSUS if you configure Products and Classifications as follows:<br>Product: Azure Stack HCI<br>Classification: Security Updates |-->

<!--## To remove the LCU

To remove the LCU after installing the combined SSU and LCU package, use the DISM [Remove-WindowsPackage](/powershell/module/dism/remove-windowspackage) command line option with the LCU package name as the argument. You can find the package name by using this command: `DISM /online /get-packages`.

Running [Windows Update Standalone Installer](https://support.microsoft.com/topic/description-of-the-windows-update-standalone-installer-in-windows-799ba3df-ec7e-b05e-ee13-1cdae8f23b19) (wusa.exe) with the /uninstall switch on the combined package won't work because the combined package contains the SSU. You can't remove the SSU from the system after installation.-->

### File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5034769](https://go.microsoft.com/fwlink/?linkid=2260628).

<!--For a list of the files that are provided in the servicing stack update, download the file information for the [SSU - version 25398.700](https://go.microsoft.com/fwlink/?linkid=2260170).-->

## January 2024 OS security update (KB 5034130) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the security update for Azure Local that was released on January 9, 2024 and applies to OS build 25398.643.

<!--For an overview of Azure Stack HCI version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->


### Improvements

This security update includes quality improvements. When you install this KB:

- This update addresses an issue that affects the Trusted Sites Zone sign in policy. You can't manage it using mobile device management (MDM).

- This update addresses an issue that affects the ActiveX scroll bar. It doesn't work in IE mode.

- This update addresses an issue that causes your device to shut down after 60 seconds. This occurs when you use a smart card to authenticate on a remote system.

- This update addresses an issue that affects the display of a smart card icon. The icon doesn't appear when you sign in. This occurs when there are multiple certificates on the smart card.

- This update addresses an issue that affects the Key Distribution Service (KDS). It doesn't start in the time required if LDAP referrals are needed.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [January 2024 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2024-Jan).

<!--## Servicing stack update - 25398.640

This update makes quality improvements to the servicing stack, which is the component that installs Windows updates. Servicing stack updates (SSU) ensure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.-->

### Known issues

Microsoft isn't currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI via PowerShell](../update/update-via-powershell-23h2.md).

<!--| Release Channel | Available | Next Step |
|--| -- |--|
| Windows Update and Microsoft Update | Yes | None. This update is downloaded automatically from Windows Update. |
| Windows Update for Business | Yes | None. This update is downloaded automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the Microsoft Update Catalog website. |
| Windows Server Update Services (WSUS) | Yes | This update will automatically sync with WSUS if you configure **Products and Classifications** as follows:<br>**Product**: Azure Stack HCI<br>**Classification**: Security Updates |-->

<!--## To remove the LCU

To remove the LCU after installing the combined SSU and LCU package, use the DISM [Remove-WindowsPackage](/powershell/module/dism/remove-windowspackage) command line option with the LCU package name as the argument. You can find the package name by using this command: `DISM /online /get-packages`.

Running [Windows Update Standalone Installer](https://support.microsoft.com/topic/description-of-the-windows-update-standalone-installer-in-windows-799ba3df-ec7e-b05e-ee13-1cdae8f23b19) (wusa.exe) with the /uninstall switch on the combined package won't work because the combined package contains the SSU. You can't remove the SSU from the system after installation.-->

### File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5034130](https://go.microsoft.com/fwlink/?linkid=2257353).

<!--For a list of the files that are provided in the servicing stack update, download the file information for the [SSU - version 25398.640](https://go.microsoft.com/fwlink/?linkid=2257446).-->


## December 2023 OS security update (KB 5033383) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This section describes the security update for Azure Local that was released on December 12, 2023 and applies to OS build 25398.584.

<!--For an overview of Azure Stack HCI version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. When you install this KB:

- This update changes the English name of the former Republic of Türkiye. The new, official name is the Republic of Türkiye.

- This update supports the currency change in Croatia from the Kuna to the Euro.

- This update affects the Netherlands time zone. It adds the recent artificial landmass outside of Rotterdam to the shape files.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [December 2023 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2023-Dec).

<!--## Servicing stack update - 25398.521

This update makes quality improvements to the servicing stack, which is the component that installs Windows updates. Servicing stack updates (SSU) ensure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.-->

### Known issues

Microsoft isn't currently aware of any issues with this update.

### To install this update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

<!--To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI via PowerShell](../update/update-via-powershell-23h2.md).

| Release Channel | Available | Next Step |
|----|----|----|
| Windows Update and Microsoft Update | Yes | None. This update is downloaded automatically from Windows Update. |
| Windows Update for Business | Yes | None. This update is downloaded automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the [Microsoft Update Catalog](https://www.catalog.update.microsoft.com/Search.aspx?q=KB5032202). |
| Windows Server Update Services (WSUS) | Yes | This update automatically syncs with WSUS if you configure Products and Classifications as follows:<br>**Product**: Azure Stack HCI<br>**Classification**: Security Updates |-->

<!--## To remove the LCU

To remove the LCU after installing the combined SSU and LCU package, use the DISM [Remove-WindowsPackage](/powershell/module/dism/remove-windowspackage) command line option with the LCU package name as the argument. You can find the package name by using this command: `DISM /online /get-packages`.

Running [Windows Update Standalone Installer](https://support.microsoft.com/topic/description-of-the-windows-update-standalone-installer-in-windows-799ba3df-ec7e-b05e-ee13-1cdae8f23b19) (wusa.exe) with the `/uninstall` switch on the combined package won't work because the combined package contains the SSU. You can't remove the SSU from the system after installation.-->

### File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5033383](https://go.microsoft.com/fwlink/?linkid=2255814).

<!--For a list of the files that are provided in the servicing stack update, download the file information for the [SSU - version 25398.521](https://go.microsoft.com/fwlink/?linkid=2252176).-->

## November 2023 OS security update (KB 5032202) for Azure Local

<!-- [!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)] -->

This security update for Azure Local was released on November 14, 2023 and applies to OS build 25398.531.

<!--For an overview of Azure Stack HCI version 23H2 release notes, see the [update history](https://support.microsoft.com/topic/release-notes-for-azure-stack-hci-version-23h2-018b9b10-a75b-4ad7-b9d1-7755f81e5b0b).-->

### Improvements

This security update includes quality improvements. When you install this KB:

- This update supports daylight saving time (DST) changes in Syria. To learn more, see [Interim guidance for Syria DST changes 2022](https://techcommunity.microsoft.com/t5/daylight-saving-time-time-zone/interim-guidance-for-syria-dst-changes-2022/ba-p/3911223).

- This update changes the spelling of Ukraine's capital from Kiev to Kyiv.

- This update addresses an issue that affects an Application Virtualization (App-V) environment. Copy operations within it stop working. This occurs after you install the April 2023 update.

- This update addresses an issue that blocks external connections. This occurs when you set up a Kubernetes load balanced service and turn on session affinity.

- This update includes quarterly changes to the Windows Kernel Vulnerable Driver Blocklist file, **DriverSiPolicy.p7b**. It adds to the list of drivers that are at risk for Bring Your Own Vulnerable Driver (BYOVD) attacks.

- This update addresses an issue that affects Windows LAPS. Its PasswordExpirationProtectionEnabled policy fails to turn on the setting.

- This update addresses an issue that affects a COM+ component. It might stop responding. This occurs because of a deadlock during COM+ Just-in-Time (JIT) activation. However, this part of this update is off by default for this version of Windows. If you have this issue, you must contact Microsoft support to turn it on.

For more information about security vulnerabilities, see the [Security Update Guide](https://msrc.microsoft.com/update-guide/) and the [November 2023 Security Updates](https://msrc.microsoft.com/update-guide/releaseNote/2023-Nov).

<!--## Servicing stack update - 25398.521

This update makes quality improvements to the servicing stack, which is the component that installs Windows updates. Servicing stack updates (SSU) ensure that you have a robust and reliable servicing stack so that your devices can receive and install Microsoft updates.-->

### Known issues

Microsoft isn't currently aware of any issues with this update.

### Install the update

Microsoft now combines the latest servicing stack update (SSU) for your operating system with the latest cumulative update (LCU). For general information about SSUs, see [Servicing stack updates](/windows/deployment/update/servicing-stack-updates) and [Servicing Stack Updates (SSU): Frequently Asked Questions](https://support.microsoft.com/topic/servicing-stack-updates-ssu-frequently-asked-questions-06b62771-1cb0-368c-09cf-87c4efc4f2fe).

To install the LCU on your Azure Stack HCI cluster, see [Update Azure Stack HCI via PowerShell](../update/update-via-powershell-23h2.md).

<!--| Release Channel | Available | Next Step |
|--| -- | -- |
| Windows Update and Microsoft Update | Yes | None. This update is downloaded automatically from Windows Update. |
| Windows Update for Business | Yes | None. This update is downloaded automatically from Windows Update in accordance with configured policies. |
| Microsoft Update Catalog | Yes | To get the standalone package for this update, go to the [Microsoft Update Catalog](https://www.catalog.update.microsoft.com/Search.aspx?q=KB5032202). |
| Windows Server Update Services (WSUS) | Yes | This update automatically syncs with WSUS if you configure **Products and Classifications** as follows:<br>**Product**: Azure Stack HCI<br>**Classification**: Security Updates |-->

<!--## To remove the LCU

To remove the LCU after installing the combined SSU and LCU package, use the DISM [Remove-WindowsPackage](/powershell/module/dism/remove-windowspackage) command line option with the LCU package name as the argument. You can find the package name by using this command: `DISM /online /get-packages`.

Running [Windows Update Standalone Installer](https://support.microsoft.com/topic/description-of-the-windows-update-standalone-installer-in-windows-799ba3df-ec7e-b05e-ee13-1cdae8f23b19) (wusa.exe) with the /uninstall switch on the combined package won't work because the combined package contains the SSU. You can't remove the SSU from the system after installation.-->

### File list

For a list of the files that are provided in this update, download the file information for [cumulative update 5032202](https://go.microsoft.com/fwlink/?linkid=2309855).

<!--For a list of the files that are provided in the servicing stack update, download the file information for the [SSU - version 25398.521](https://go.microsoft.com/fwlink/?linkid=2252176).-->

::: moniker-end

## Next steps

- [Install updates via PowerShell](../update/update-via-powershell-23h2.md) for Azure Local.
- [Install updates via Azure Update Manager in Azure portal](../update/azure-update-manager-23h2.md) for Azure Local.
