---
title: Security baseline settings
description: See the default secure baseline settings available.
author: meaghanlewis
ms.author: mosagie
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/22/2022
---

# Security baseline

We’re working diligently to provide a secure by default product to our customers. Part of this work is to provide a consistent security baseline from the cloud to the edge, on-premises. You may notice that over 200 security settings are now enabled by default right from the start. These settings ensure that the device always starts in a known good state. We'll continue to expand the list of default security settings over time.

This security baseline enables customers to closely meet with CIS Benchmark and DISA STIG requirements for the OS and the Microsoft recommended security baseline. It reduces OPEX - with built-in drift protection, and consistent at scale monitoring via Azure Arc Hybrid edge baseline. Finally, it also improves the security posture via disablement of legacy protocols and ciphers.

Try exercising your regular day-to-day workflows and confirm that nothing is inadvertently worsened or blocked.

## Secure baseline settings

| **Security settings** | **Type** | **Location** | **ValueName** | **Value** |
|:---:|:---:|:---:|:---:|:---:|
| **Interactive logon: Do not require CTRL+ALT+DEL** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | DisableCAD | 0 |
| **Interactive logon: Don't display last signed-in** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | DontDisplayLastUserName | 1 |
| **Interactive logon: Require Domain Controller authentication to unlock workstation** | Registry | HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon | ForceUnlockLogon | 0 |
| **Microsoft network client: Digitally sign communications (always)** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters | RequireSecuritySignature | 1 |
| **Microsoft network client: Send unencrypted password to third-party SMB servers** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\LanmanWorkstation\Parameters | EnablePlainTextPassword | 0 |
| **Enable insecure guest logons** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation | AllowInsecureGuestAuth | 0 |
| **Enumerate administrator accounts on elevation** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI | EnumerateAdministrators | 0 |
| **Audit: Shut down system immediately if unable to log security audits** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | CrashOnAuditFail | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 2 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 4 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 6 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 7 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 8 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 9 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 10 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 11 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 13 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 14 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 15 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 16 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 17 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 18 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 19 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 20 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 21 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 22 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 23 | 0 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 24 | 0 |
| **Disallow Digest authentication** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client | AllowDigest | 0 |
| **Domain controller: Refuse machine account password changes** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters | RefusePasswordChange | 0 |
| **Domain member: Disable machine account password changes** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters | DisablePasswordChange | 0 |
| **Process even if the Group Policy objects have not changed** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2} | NoGPOListChanges | 0 |
| **WDigest Authentication must be disabled** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\WDigest | UseLogonCredential | 0 |
| **prevent Internet Control Message Protocol (ICMP) redirects from overriding Open Shortest Path First (OSPF)-generated routes** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters | EnableICMPRedirect | 0 |
| **Interactive logon: Smart card removal behavior** | Registry | HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon | ScRemoveOption | 1 |
| **Do not allow drive redirection** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services | fDisableCdm | 1 |
| **Do not allow passwords to be saved** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services | DisablePasswordSaving | 1 |
| **Do not display network selection UI** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\System | DontDisplayNetworkSelectionUI | 1 |
| **Allow Telemetry** | Registry | HKLM:\Software\Policies\Microsoft\Windows\DataCollection | AllowTelemetry | 0 |
| **Audit: Force audit policy subcategory settings (Windows Vista or later) to override audit policy category settings** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | SCENoApplyLegacyAuditPolicy | 1 |
| **Configure Automatic Updates** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU | NoAutoUpdate | 1 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 1 | 1 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 3 | 1 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 5 | 1 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | 12 | 1 |
| **Configure TPM platform validation profile for native UEFI firmware configurations** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE\OSPlatformValidation_UEFI | Enabled | 0 |
| **Configure Windows Defender SmartScreen** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\System | EnableSmartScreen | 1 |
| **Default AutoRun Behavior** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer | NoAutorun | 1 |
| **Disable Windows Error Reporting** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting | Disabled | 1 |
| **Disallow Autoplay for non-volume devices** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer | NoAutoplayfornonVolume | 1 |
| **Domain member: Digitally encrypt or sign secure channel data (always)** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters | RequireSignOrSeal | 1 |
| **Domain member: Digitally encrypt secure channel data (when possible)** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters | SealSecureChannel | 1 |
| **Domain member: Digitally sign secure channel data (when possible)** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters | SignSecureChannel | 1 |
| **Domain member: Require strong (Windows 2000 or later) session key** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters | RequireStrongKey | 1 |
| **Network security: Configure encryption types allowed for Kerberos** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Kerberos\Parameters | SupportedEncryptionTypes | 2147483644 |
| **Prevent downloading of enclosures** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds | DisableEnclosureDownload | 1 |
| **Prevent enabling lock screen slide show** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization | NoLockScreenSlideshow | 1 |
| **Remote host allows delegation of non-exportable credentials** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\CredentialsDelegation | AllowProtectedCreds | 1 |
| **Require a password when a computer wakes (on battery)** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51 | DCSettingIndex | 1 |
| **Require a password when a computer wakes (plugged in)** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51 | ACSettingIndex | 1 |
| **Require secure RPC communication** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services | fEncryptRPCTraffic | 1 |
| **ignore NetBIOS name release requests except from WINS servers** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Netbt\Parameters | NoNameReleaseOnDemand | 1 |
| **Turn off downloading of print drivers over HTTP** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers | DisableWebPnPDownload | 1 |
| **Turn off Inventory Collector** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat | DisableInventory | 1 |
| **Turn off printing over HTTP** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Printers | DisableHTTPPrinting | 1 |
| **Domain controller: LDAP server signing requirements** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\NTDS\Parameters | LDAPServerIntegrity | 2 |
| **The system must be configured to prevent IP source routing** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters | DisableIPSourceRouting | 2 |
| **IPv6 source routing must be configured to highest protection** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters | DisableIpSourceRouting | 2 |
| **Set client connection encryption level** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services | MinEncryptionLevel | 3 |
| **Interactive logon: Number of previous logons to cache (in case domain controller is not available)** | Registry | HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon | CachedLogonsCount | 0 |
| **Interactive logon: Prompt user to change password before expiration** | Registry | HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon | PasswordExpiryWarning | 5 |
| **Domain member: Maximum machine account password age** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\Netlogon\Parameters | MaximumPasswordAge | 30 |
| **Turn off Autoplay** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer | NoDriveTypeAutoRun | 255 |
| **Interactive logon: Machine inactivity limit** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | InactivityTimeoutSecs | 4900 |
| **Network security: Minimum session security for NTLM SSP based (including secure RPC) clients** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 | NTLMMinClientSec | 537395200 |
| **Network security: Minimum session security for NTLM SSP based (including secure RPC) servers - Require 128-bit encryption** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 | NTLMMinServerSec | 537395200 |
| **Audit: Audit the use of Backup and Restore privilege** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | FullPrivilegeAuditing | 00 |
| **Interactive logon: Require Windows Hello for Business or smart card** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | ScForceOption | 0 |
| **Microsoft network server: Digitally sign communications (always)** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters | RequireSecuritySignature | 1 |
| **Network access: Do not allow anonymous enumeration of SAM accounts and shares** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | RestrictAnonymous | 0 |
| **Network access: Do not allow storage of passwords and credentials for network authentication** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | DisableDomainCreds | 0 |
| **Network access: Let Everyone permissions apply to anonymous users** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | EveryoneIncludesAnonymous | 0 |
| **Network access: Sharing and security model for local accounts** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | ForceGuest | 0 |
| **Network security: Allow LocalSystem NULL session fallback** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0 | Allownullsessionfallback | 0 |
| **Recovery console: Allow floppy copy and access to all drives and all folders** | Registry | HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Setup\RecoveryConsole | SetCommand | 0 |
| **Shutdown: Allow system to be shut down without having to log on** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | ShutdownWithoutLogon | 0 |
| **Shutdown: Clear virtual memory pagefile** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management | ClearPageFileAtShutdown | 0 |
| **System settings: Use Certificate Rules on Windows Executables for Software Restriction Policies** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers | AuthenticodeEnabled | 0 |
| **User Account Control: Allow UIAccess applications to prompt for elevation without using the secure desktop** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | EnableUIADesktopToggle | 0 |
| **User Account Control: Behavior of the elevation prompt for standard users** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | ConsentPromptBehaviorUser | 0 |
| **User Account Control: Only elevate executables that are signed and validated** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | ValidateAdminCodeSignatures | 0 |
| **Accounts: Limit local account use of blank passwords to console logon only** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | LimitBlankPasswordUse | 1 |
| **Devices: Allow undock without having to log on** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | UndockWithoutLogon | 0 |
| **Devices: Prevent users from installing printer drivers** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Print\Providers\LanMan Print Services\Servers | AddPrinterDrivers | 1 |
| **Network access: Do not allow anonymous enumeration of SAM accounts** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | RestrictAnonymousSAM | 1 |
| **Network access: Restrict anonymous access to Named Pipes and Shares** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters | RestrictNullSessAccess | 1 |
| **Network security: Allow Local System to use computer identity for NTLM** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | UseMachineId | 1 |
| **Network security: Do not store LAN Manager hash value on next password change** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | NoLMHash | 1 |
| **Network security: LDAP client signing requirements** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\LDAP | LDAPClientIntegrity | 1 |
| **System cryptography: Use FIPS compliant algorithms for encryption, hashing, and signing** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FIPSAlgorithmPolicy | Enabled | 1 |
| **Disable SHA1** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\SecurityProviders\Schannel\Hashes\SHA | Enabled | 0 |
| **Configuring speculative execution side-channel mitigation FeatureSettingsOverride** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management | FeatureSettingsOverride | 72 |
| **Configuring speculative execution side-channel mitigation FeatureSettingsOverrideMask** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management | FeatureSettingsOverrideMask | 3 |
| **Protect against microarchitectural and execution side-channel vulnerabilities** | Registry | HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization | MinVmVersionForCpuBasedMitigations | 1.0 |
| **System objects: Require case insensitivity for non-Windows subsystems** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Kernel | ObCaseInsensitive | 1 |
| **System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager | ProtectionMode | 1 |
| **User Account Control: Behavior of the elevation prompt for administrators in Admin Approval Mode** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | ConsentPromptBehaviorAdmin | 1 |
| **User Account Control: Detect application installations and prompt for elevation** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | EnableInstallerDetection | 1 |
| **User Account Control: Only elevate UIAccess applications that are installed in secure locations** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | EnableSecureUIAPaths | 1 |
| **User Account Control: Run all administrators in Admin Approval Mode** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | EnableLUA | 1 |
| **User Account Control: Switch to the secure desktop when prompting for elevation** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | PromptOnSecureDesktop | 1 |
| **User Account Control: Virtualize file and registry write failures to per-user locations** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | EnableVirtualization | 1 |
| **Microsoft network server: Amount of idle time required before suspending session** | Registry | HKLM:\SYSTEM\CurrentControlSet\Services\LanManServer\Parameters | AutoDisconnect | 15 |
| **System cryptography: Force strong key protection for user keys stored on the computer** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\Cryptography | ForceKeyProtection | 2 |
| **Network security: LAN Manager authentication level** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\Lsa | LmCompatibilityLevel | 5 |
| **User Account Control: Admin Approval Mode for the Built-in Administrator account** | Registry | HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System | FilterAdministratorToken | 1 |
| **SSL3.0 is disabled by default - client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client | DisabledByDefault | 1 |
| **SSL3.0 is not enabled – client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Client | Enabled | 0 |
| **SSL3.0 is disabled by default - server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server | DisabledByDefault | 1 |
| **SSL3.0 is not enabled – server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 3.0\Server | Enabled | 0 |
| **SSL2.0 is disabled by default - client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client | DisabledByDefault | 1 |
| **SSL2.0 is not enabled – client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Client | Enabled | 0 |
| **SSL2.0 is disabled by default - server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server | DisabledByDefault | 1 |
| **SSL2.0 is not enabled – server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\SSL 2.0\Server | Enabled | 0 |
| **TLS1.0 is disabled by default - client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client | DisabledByDefault | 1 |
| **TLS1.0 is not enabled – client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client | Enabled | 0 |
| **TLS1.0 is disabled by default - server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server | DisabledByDefault | 1 |
| **TLS1.0 is not enabled – server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server | Enabled | 0 |
| **TLS1.1 is disabled by default - client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client | DisabledByDefault | 1 |
| **TLS1.1 is not enabled – client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Client | Enabled | 0 |
| **TLS1.1 is disabled by default - server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server | DisabledByDefault | 1 |
| **TLS1.1 is not enabled – server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.1\Server | Enabled | 0 |
| **TLS1.2 is enabled by default - client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client | DisabledByDefault | 0 |
| **TLS1.2 is enabled – client** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client | Enabled | 1 |
| **TLS1.2 is enabled by default - server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server | DisabledByDefault | 0 |
| **TLS1.2 is enabled – Server** | Registry | HKLM:\System\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Server | Enabled | 1 |
| **FVE EncryptionMethodWithXtsFdv** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | EncryptionMethodWithXtsFdv | 7 |
| **FVE EncryptionMethodWithXtsOs** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | EncryptionMethodWithXtsOs | 7 |
| **FVE  EncryptionMethodWithXtsRdv** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | EncryptionMethodWithXtsRdv | 7 |
| **FVE FDVActiveDirectoryBackup** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | FDVActiveDirectoryBackup | 1 |
| **FVE FDVActiveDirectoryInfoToStore** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | FDVActiveDirectoryInfoToStore | 1 |
| **FVE FDVHideRecoveryPage** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | FDVHideRecoveryPage | 0 |
| **FVE FDVManageDRA** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | FDVManageDRA | 1 |
| **FVE FDVRecovery** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | FDVRecovery | 1 |
| **FVE FDVRecoveryKey** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | FDVRecoveryKey | 2 |
| **FVE FDVRecoveryPassword** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | FDVRecoveryPassword | 2 |
| **FVE FDVRequireActiveDirectoryBackup** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | FDVRequireActiveDirectoryBackup | 0 |
| **FVE OSActiveDirectoryBackup** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | OSActiveDirectoryBackup | 1 |
| **FVE OSActiveDirectoryInfoToStore** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | OSActiveDirectoryInfoToStore | 1 |
| **FVE OSHideRecoveryPage** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | OSHideRecoveryPage | 0 |
| **FVE OSManageDRA** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | OSManageDRA | 1 |
| **FVE OSRecovery** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | OSRecovery | 1 |
| **FVE OSRecoveryKey** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | OSRecoveryKey | 2 |
| **FVE OSRecoveryPassword** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | OSRecoveryPassword | 2 |
| **FVE OSRequireActiveDirectoryBackup** | Registry | HKLM:\SOFTWARE\Policies\Microsoft\FVE | OSRequireActiveDirectoryBackup | 0 |
| **DeviceGuard EnableVirtualizationBasedSecurity** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard | EnableVirtualizationBasedSecurity | 1 |
| **DeviceGuard RequirePlatformSecurityFeatures** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard | RequirePlatformSecurityFeatures | 3 (with secureboot enabled) |
| **DeviceGuard Locked** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard | Locked | 1 |
| **DeviceGuard RequireMicrosoftSignedBootChain** | Registry | HKLM:\SYSTEM\CurrentControlSet\Control\DeviceGuard | RequireMicrosoftSignedBootChain | 1 |
| **Accounts: Guest account status** | AuditPolicy | EnableGuestAccount | System Access | 0 |
| **Network access: Allow anonymous SID/name translation** | AuditPolicy | LSAAnonymousNameLookup | System Access | 0 |
| **Store passwords using reversible encryption** | AuditPolicy | ClearTextPassword | System Access | 0 |
| **Minimum password age** | AuditPolicy | MinimumPasswordAge | System Access | 1 |
| **Accounts: Administrator account status** | AuditPolicy | EnableAdminAccount | System Access | 1 |
| **Network security: Force logoff when logon hours expire** | AuditPolicy | ForceLogoffWhenHourExpire | System Access | 1 |
| **Password must meet complexity requirements - method implemented already - SamSetPolicyValue_AccountPolicies_PasswordMustMeetComplexityRequirement** | AuditPolicy | PasswordComplexity | System Access | 1 |
| **Audit Audit Policy Change** | AuditPolicy | AuditPolicyChange | System Access | 3 |
| **Enforce password history** | AuditPolicy | PasswordHistorySize | System Access | 24 |
| **Maximum password age** | AuditPolicy | MaximumPasswordAge | System Access | 42 |
| **Bypass traverse checking** | AuditPolicy | SeChangeNotifyPrivilege | Privilege Rights | \*S-1-5-32-544,\*S-1-5-11,\*S-1-5-32-551,\*S-1-5-19,\*S-1-5-20 |
| **Access this computer from the network** | AuditPolicy | SeNetworkLogonRight | Privilege Rights | \*S-1-5-11,\*S-1-5-32-544 |
| **Replace a process level token** | AuditPolicy | SeAssignPrimaryTokenPrivilege | Privilege Rights | \*S-1-5-19,\*S-1-5-20 |
| **Create global objects** | AuditPolicy | SeCreateGlobalPrivilege | Privilege Rights | \*S-1-5-19,\*S-1-5-20,\*S-1-5-32-544,\*S-1-5-6 |
| **Change the system time** | AuditPolicy | SeSystemtimePrivilege | Privilege Rights | \*S-1-5-19,\*S-1-5-32-544 |
| **Change the time zone** | AuditPolicy | SeTimeZonePrivilege | Privilege Rights | \*S-1-5-19,\*S-1-5-32-544 |
| **Create a pagefile** | AuditPolicy | SeCreatePagefilePrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Create symbolic links** | AuditPolicy | SeCreateSymbolicLinkPrivilege | Privilege Rights | \*S-1-5-32-544, \*S-1-5-83-0 |
| **Debug programs** | AuditPolicy | SeDebugPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Force shutdown from a remote system** | AuditPolicy | SeRemoteShutdownPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Load and unload device drivers** | AuditPolicy | SeLoadDriverPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Manage auditing and security log** | AuditPolicy | SeSecurityPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Modify firmware environment values** | AuditPolicy | SeSystemEnvironmentPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Allow log on locally** | AuditPolicy | SeInteractiveLogonRight | Privilege Rights | \*S-1-5-32-544 |
| **Backup files and directories** | AuditPolicy | SeBackupPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Profile single process** | AuditPolicy | SeProfileSingleProcessPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Restore files and directories** | AuditPolicy | SeRestorePrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Shut down the system** | AuditPolicy | SeShutdownPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Log on as a batch job** | AuditPolicy | SeBatchLogonRight | Privilege Rights | \*S-1-5-32-544,\*S-1-5-32-551,\*S-1-5-32-559 |
| **Profile system performance** | AuditPolicy | SeSystemProfilePrivilege | Privilege Rights | \*S-1-5-32-544,\*S-1-5-80-3139157870-2983391045-3678747466-658725712-1809340420 |
| **Increase scheduling priority** | AuditPolicy | SeIncreaseBasePriorityPrivilege | Privilege Rights | \*S-1-5-32-544,\*S-1-5-90-0 |
| **Deny access to this computer from the network** | AuditPolicy | SeDenyNetworkLogonRight | Privilege Rights | \*S-1-5-32-546 |
| **Deny log on as a batch job** | AuditPolicy | SeDenyBatchLogonRight | Privilege Rights | \*S-1-5-32-546 |
| **Deny remote desktop access to this computer** | AuditPolicy | SeDenyRemoteInteractiveLogonRight | Privilege Rights | \*S-1-5-32-546 |
| **Deny log on locally** | AuditPolicy | SeDenyInteractiveLogonRight | Privilege Rights | \*S-1-5-32-546 |
| **Log on as a service** | AuditPolicy | SeServiceLogonRight | Privilege Rights | \*S-1-5-80-0, \*S-1-5-83-0 |
| **Audit IPsec Driver** | AuditPolicy | IPsec Driver | Audit | 3 |
| **Audit Other Account Management Events** | AuditPolicy | Other Account Management Events | Audit | 3 |
| **Audit Other System Events** | AuditPolicy | Other System Events | Audit | 3 |
| **Audit Directory Service Changes** | AuditPolicy | Directory Service Changes | Audit | 3 |
| **Audit directory service access** | AuditPolicy | directory service access | Audit | 3 |
| **Audit Credential Validation** | AuditPolicy | Credential Validation | Audit | 3 |
| **Audit Security Group Management** | AuditPolicy | Security Group Management | Audit | 3 |
| **Audit Security System Extension** | AuditPolicy | Security State Change | Audit | 3 |
| **Audit Sensitive Privilege Use** | AuditPolicy | Sensitive Privilege Use | Audit | 3 |
| **Audit System Integrity** | AuditPolicy | System Integrity | Audit | 3 |
| **Audit User Account Management** | AuditPolicy | User Account Management | Audit | 3 |
| **Audit Logoff** | AuditPolicy | Logoff | Audit | 3 |
| **Audit Group Membership** | AuditPolicy | Group Membership | Audit | 3 |
| **Audit Computer Account Management** | AuditPolicy | Computer Account Management | Audit | 3 |
| **Audit Authorization Policy Change** | AuditPolicy | Authorization Policy Change | Audit | 3 |
| **Audit Authentication Policy Change** | AuditPolicy | Authentication Policy Change | Audit | 3 |
| **Audit Removable Storage** | AuditPolicy | Removable Storage | Audit | 3 |
| **Audit Special Logon** | AuditPolicy | Special Logon | Audit | 3 |
| **Accounts: Rename administrator account** | AuditPolicy | NewAdministratorName | System Access | Administrator |
| **Take ownership of files or other objects** | AuditPolicy | SeTakeOwnershipPrivilege | Privilege Rights | \*S-1-5-32-544 |
| **Accounts: Rename guest account** | AuditPolicy | NewGuestName | System Access | AszGuest |

## Next steps

- [Azure Stack HCI security considerations](./security.md)
