---
title:  Azure Local security book data protection
description: Data protection for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Data protection

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

## Data at rest protection

[BitLocker Drive Encryption](/windows/security/operating-system-security/data-protection/bitlocker/) is a data protection feature that addresses the threats of data theft or exposure from lost, stolen, or inappropriately decommissioned computers or storage components. With Azure Local, all infrastructure and tenant data is encrypted at rest using BitLocker. Both OS volumes (or system volumes containing the OS VHDX in boot from VHDX scenarios) and Cluster Shared Volumes are by default encrypted with BitLocker using XTS-AES 256-bit encryption algorithm. In situations where BitLocker is unable to unlock a local OS volume or data volume, it denies access to the encrypted data. To learn more about BitLocker protection, see [BitLocker encryption on Azure Local](../manage/manage-bitlocker.md).

## Data in transit protection

### Transport layer security (TLS)

Transport Layer Security (TLS) is the internet’s most deployed security protocol, encrypting data in transit to provide a secure communication channel between two endpoints. Azure Local enables the latest protocol versions and strong cipher suites by default and offers a full suite of extensions such as client authentication for enhanced machine security, or session resumption for improved application performance. TLS 1.3 is the latest version of the protocol and is enabled by default in Azure Local. This version eliminates obsolete cryptographic algorithms, enhances security over older versions, and aims to encrypt as much of the TLS handshake as possible. The handshake is more performant with one fewer round trip per connection on average and supports only strong cipher suites, which provide perfect forward secrecy and less operational risk. Using TLS 1.3 provides more privacy and lower latencies for encrypted online connections. If the client or machine application on either side of the connection doesn't support TLS 1.3, Azure Local falls back to TLS 1.2. Azure Local uses the latest Datagram Transport Layer Security (DTLS) 1.2 for UDP communications.

### Server Messaging Block (SMB) signing and encryption

All the major security industry baselines recommend enabling Server Message Block (SMB) signing. To make it easier for you to get your infrastructure to be compliant with those baselines and best practices, we're enabling SMB signing requirement for client connections by default in Azure Local. SMB encryption of intra-system traffic isn't enabled by default but is an option you can enable during or after deployment. SMB encryption can impact performance depending on the system configuration.

For signing and encryption security, Azure Local now supports AES-256-GCM and AES-256-CCM cryptographic suites for the SMB 3.1.1 protocol used by client-server file traffic as well as the intra-system data fabric. It continues to support the more broadly compatible AES-128 as well. Azure Local also supports SMB Direct encryption, an option that was previously unavailable without significant performance impact. Data is encrypted before placement, leading to less performance degradation while adding AES-128 and AES-256 protected packet privacy.

Furthermore, Azure Local now supports granular control of encrypting intra-machine storage communications for Cluster Shared Volumes (CSV) and the storage bus layer (SBL). This means that when using Storage Spaces Direct, you can decide if you wish to use encryption or signing on remote file system, CSV, and the SBL traffic separately from each other. And finally, Azure Local supports the accelerated AES-128-GMAC signing option with lower latency and CPU usage. You can use Windows Admin Center (WAC) and PowerShell cmdlets for granular control of SMB signing and encryption. All of these combine to give the maximum flexibility for your threat model and performance requirements. For more information, see [SMB security enhancements](/windows-server/storage/file-server/smb-security).

## Related content

- [Trustworthy addition overview](trustworthy-addition-overview.md)