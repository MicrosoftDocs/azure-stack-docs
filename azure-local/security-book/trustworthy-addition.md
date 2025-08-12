---
title:  Trustworthy addition for the Azure Local security book
description: Learn about trustworthy addition for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 08/11/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Trustworthy addition for the Azure Local security book

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

Trustworthy addition for Azure Local means using security by default, application control, credential protection, memory integrity protectionm, data protection, network security, malware protection, and privacy controls.


## Overview

Our customers face the significant burden of getting their infrastructure to meet a wide variety of security standards and be compliant with industry specific compliance requirements. They may spend several millions of dollars on external tools to get their infrastructure to meet those requirements. This is a tall order for many customers as they need to identify and enable various security capabilities. Even when they do, how those various security capabilities work together is yet another challenge to deal with. 
 
Our goal is to empower customers to achieve their security requirements, regardless of industry regulations or compliance, more easily and in a flexible manner. Azure Local builds on industry-leading security features such as Application Control for Windows and BitLocker. With Azure Local, we've enabled security right from the start, where the system is by default deployed in a known good state in accordance with the [Microsoft Cloud Security Benchmark](/security/benchmark/azure/overview). 
 
With this change, customers don't have to burden themselves with the mechanics of enabling the various security capabilities, at least not for most of the well-known security requirements. From a customer standpoint, security "just works". 

## Security by default

### Security baselines and best practices enabled by default

By default, Azure Local enables [security baseline settings](/azure/azure-local/manage/manage-secure-baseline) and security best practices based on Microsoft recommended security baselines and industry best practices. A tailored security baseline with over 300 security settings is enforced with a drift control mechanism which ensures that the system starts and remains in a known good security state.

This security baseline enables you to closely meet the Center for Internet Security (CIS) Benchmark, Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG), and Federal Information Processing Standards (FIPS 140-2) requirements for the operating system (OS), and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-windows). The security baseline settings have been verified for compatibility and performance impact. The default enablement of those security baselines is intended to make it easier for customers to meet their compliance and regulatory requirements. 

### Insecure protocols disabled by default

Insecure protocols such as TLS versions less than 1.2, DTLS versions less than 1.2, SMB 1.0, and WDigest which have inherent vulnerabilities are disabled by default in Azure Local.  

### Use of secure protocols and cryptographic standards

Azure Local uses secure protocols such as Transport Layer Security (TLS) versions 1.2 or higher, Datagram Transport Layer Security (DTLS) versions 1.2 or higher, and Server Messaging Blok (SMB) 2.0 or higher. It supports National Institute of Standards and Technology (NIST) [guidelines for cryptographic standards](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-175Br1.pdf).

### Mitigations for speculative side-channel hardware vulnerabilities

Modern CPUs achieve performance by using idle CPU cycles to perform speculative and out of order execution of instructions. For instance, the CPU may predict the target of a branch instruction and speculatively execute the instructions at the predicted branch target.

If the CPU later discovers that the branch prediction was incorrect, all the machine state that was computed speculatively is discarded. However, this operation can leave residual traces in various caches that are used by the CPU. These residual traces can leave observable side effects (side channel) which attackers may be able to use to extract information about private data using a timing attack. Spectre and Meltdown are some of the original transient execution CPU vulnerabilities. Azure Local enables mitigations for known speculative execution [side channel hardware vulnerabilities](https://support.microsoft.com/topic/kb4072698-windows-server-and-azure-stack-hci-guidance-to-protect-against-silicon-based-microarchitectural-and-speculative-execution-side-channel-vulnerabilities-2f965763-00e2-8f98-b632-0d96f30c8c8e) by default.

## Application control

Preventing unwanted or malicious applications from running is an important part of an effective security strategy. Application control is one of the most effective means for addressing the threat of executable file-based malware. Application control helps mitigate security threats by restricting the applications that users are allowed to run.  

While most customers inherently understand the value of application control, the reality is that only some have been able to employ application control solutions in a manageable way. [Application Control for Windows](/windows/security/application-security/application-control/app-control-for-business/appcontrol) provides powerful control over what applications are allowed to run and the code that runs in the OS (kernel).

Application Control for Windows is enabled by default on Azure Local, and out of the box it includes a set of base policies to ensure that only known platform components and applications are allowed to run. You can extend and customize this application control policy. For more information on base policies included in Azure Local and how to create supplemental policies, see [Manage Application Control for Azure Local](/azure/azure-local/manage/manage-wdac).

## Credential protection

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

[Credential Guard](/windows/security/identity-protection/credential-guard/how-it-works) uses virtualization-based security (VBS) to protect against credential theft. With Credential Guard, the Local Security Authority (LSA) stores and protects Active Directory secrets in an isolated environment that is not accessible to the rest of the operating system. By protecting the LSA process with virtualization-based security, Credential Guard shields systems from credential theft attack techniques like pass-the-hash or pass-the-ticket. It also helps prevent malware from accessing system secrets even if the process is running with admin privileges. Credential Guard is enabled by default in Azure Local. 

## Memory integrity protection

Kernel Mode Code Integrity is the Windows process that checks whether all kernel code is properly signed and hasn't been tampered with before it is allowed to run. [Hypervisor-protected code integrity (HVCI)](/windows-hardware/design/device-experiences/oem-hvci-enablement), also called memory integrity, uses virtualization-based security (VBS) to run Kernel Mode Code Integrity inside the secure VBS environment instead of the main Windows kernel. This helps prevent attacks that attempt to modify kernel mode code such as drivers.

Memory integrity also restricts kernel memory allocations that are used to compromise the system, ensuring that kernel memory pages are only made executable after passing code integrity checks inside the secure VBS environment, and executable pages themselves are never writable. That way, even if there are vulnerabilities like buffer overflow that allows malware to attempt to modify memory, executable code pages can't be modified, and modified memory can't be made executable. Memory integrity helps protect against attacks that rely on the ability to inject malicious code into the kernel using bugs in kernel-mode software. Memory integrity protection is enabled by default in Azure Local.

## Data at rest protection

[BitLocker Drive Encryption](/windows/security/operating-system-security/data-protection/bitlocker/) is a data protection feature that addresses the threats of data theft or exposure from lost, stolen, or inappropriately decommissioned computers or storage components. With Azure Local, all infrastructure and tenant data is encrypted at rest using BitLocker. Both OS volumes (or system volumes containing the OS VHDX in boot from VHDX scenarios) and Cluster Shared Volumes are by default encrypted with BitLocker using XTS-AES 256-bit encryption algorithm. In situations where BitLocker is unable to unlock a local OS volume or data volume, it denies access to the encrypted data. To learn more about BitLocker protection, see [BitLocker encryption on Azure Local](../manage/manage-bitlocker.md).

## Data in transit protection

### Transport layer security (TLS)

Transport Layer Security (TLS) is the internet’s most deployed security protocol, encrypting data in transit to provide a secure communication channel between two endpoints. Azure Local enables the latest protocol versions and strong cipher suites by default and offers a full suite of extensions such as client authentication for enhanced machine security, or session resumption for improved application performance. TLS 1.3 is the latest version of the protocol and is enabled by default in Azure Local. This version eliminates obsolete cryptographic algorithms, enhances security over older versions, and aims to encrypt as much of the TLS handshake as possible. The handshake is more performant with one fewer round trip per connection on average and supports only strong cipher suites, which provide perfect forward secrecy and less operational risk. Using TLS 1.3 provides more privacy and lower latencies for encrypted online connections. If the client or machine application on either side of the connection doesn't support TLS 1.3, Azure Local falls back to TLS 1.2. Azure Local uses the latest Datagram Transport Layer Security (DTLS) 1.2 for UDP communications.

### Server Messaging Block (SMB) signing and encryption

All the major security industry baselines recommend enabling Server Message Block (SMB) signing. To make it easier for you to get your infrastructure to be compliant with those baselines and best practices, we're enabling SMB signing requirement for client connections by default in Azure Local. SMB encryption of intra-system traffic isn't enabled by default but is an option you can enable during or after deployment. SMB encryption can impact performance depending on the system configuration.

For signing and encryption security, Azure Local now supports AES-256-GCM and AES-256-CCM cryptographic suites for the SMB 3.1.1 protocol used by client-server file traffic as well as the intra-system data fabric. It continues to support the more broadly compatible AES-128 as well. Azure Local also supports SMB Direct encryption, an option that was previously unavailable without significant performance impact. Data is encrypted before placement, leading to less performance degradation while adding AES-128 and AES-256 protected packet privacy.

Furthermore, Azure Local now supports granular control of encrypting intra-machine storage communications for Cluster Shared Volumes (CSV) and the storage bus layer (SBL). This means that when using Storage Spaces Direct, you can decide if you wish to use encryption or signing on remote file system, CSV, and the SBL traffic separately from each other. And finally, Azure Local supports the accelerated AES-128-GMAC signing option with lower latency and CPU usage. You can use Windows Admin Center (WAC) and PowerShell cmdlets for granular control of SMB signing and encryption. All of these combine to give the maximum flexibility for your threat model and performance requirements. For more information, see [SMB security enhancements](/windows-server/storage/file-server/smb-security).

## Network security

### Software defined networking (SDN) and micro-segmentation

With Azure Local, you can take steps towards ensuring that your applications and workloads are protected from external as well as internal attacks. Through micro-segmentation, you can create granular network policies between applications and services. This essentially reduces the security perimeter to a fence around each application or VM. This fence permits only necessary communication between application tiers or other logical boundaries, thus making it exceedingly difficult for cyberthreats to spread laterally from one system to another. Micro-segmentation securely isolates networks from each other and reduces the total attack surface of a network security incident.

Micro-segmentation in Azure Local is implemented through Network Security Groups (NSGs), like Azure. With NSGs, you can create allow or deny firewall rules where your rule source and destination are network prefixes. We also support tag-based segmentation, where you can assign any custom tags to classify your VMs, and then apply NSGs based on the tags to restrict communication to/from external as well as internal sources. So, to prevent your SQL VMs from communicating with your web server VMs, simply tag corresponding VMs with "SQL" and "Web" tags and create a NSG to prevent "Web" tag from communicating with "SQL" tag. These policies are available for VMs on traditional VLAN networks and on SDN overlay networks.

Management of NSGs is supported through Windows Admin Center, PowerShell, and REST APIs. To learn more about NSGs, see [Configure network security groups with tags in Windows Admin Center](../manage/configure-network-security-groups-with-tags.md).

Finally, we also support default network access policies. Default network access policies help ensure that all virtual machines (VMs) in your Azure Local instance are secure by default from external threats. If you choose to enable default policies for a virtual machine (VM), we will block inbound access to the VM by default, while giving the option to enable specific selective inbound management ports and thus securing the VM from external attacks. To learn more about default network access policies, see [Manage default network access policies on your Azure Local](../manage/manage-default-network-access-policies-virtual-machines.md).

## Malware protection

Microsoft Defender Antivirus is real-time, behavior-based, and heuristic antivirus protection. It helps protect the operating system against viruses, malware, spyware, and other threats. In addition to real-time protection, updates are downloaded automatically to help keep your device safe and protect it from threats.

The combination of always-on content scanning, file and process behavior monitoring, and other heuristics effectively prevents security threats. Microsoft Defender Antivirus continually scans for malware and threats, and it detects and blocks potentially unwanted applications (PUA) which are applications that are deemed to negatively impact your device but are not considered malware. Microsoft Defender Antivirus always-on protection is integrated with cloud-delivered protection, which helps ensure near instant detection and blocking of new and emerging threats. To learn more, see Microsoft Defender Antivirus. By default, [Microsoft Defender Antivirus](/defender-endpoint/microsoft-defender-antivirus-on-windows-server) is enabled in Azure Local.

## Privacy

Azure Local collects the minimum data required to keep the system current, secure, and operating properly. This includes telemetry event data and diagnostics data. Telemetry pipeline transmits a steady stream of curated events to Azure. The diagnostics pipeline emits an episodic set of diagnostic data to Azure only when allowed by the customer. Data collection is enabled by default in Azure Local. However, you can disable data collection by changing the service health data setting via the Azure portal. For more information, see [Azure Local data collection](/previous-versions/azure/azure-local/concepts/data-collection).


## Related content

[Operational security](operational-security.md)

