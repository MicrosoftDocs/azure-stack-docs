---
title: What are confidential virtual machines for Azure Local (preview)? 
description: Learn how confidential virtual machines on Azure Local bring hardware-based memory encryption and attestation to customer-owned edge infrastructure for stateless, security-sensitive workloads (preview).
author: sipastak
ms.author: sipastak
ms.date: 07/13/2026
ms.topic: overview
ms.service: azure-local
ms.subservice: hyperconverged
---

# What are confidential virtual machines for Azure Local (preview)?

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article provides an overview of confidential virtual machines (CVMs) on Azure Local.

CVMs on Azure Local bring hardware-based memory encryption and attestation to customer-owned edge infrastructure. By extending Azure's confidential computing platform to the edge, CVMs provide cryptographic assurance to protect and encrypt data that is in use, while in RAM, and during computation.

CVMs offer strong security and confidentiality over standard virtual machines (VMs) by providing robust hardware-based isolation between virtual machines, the hypervisor, and host management code. The trust boundary excludes host administrators, infrastructure operators, and actors with host-level or administrative access from accessing workload data.

The current release of CVMs on Azure Local supports exclusively AMD Genoa (Gen 4) processors with Secure Encrypted Virtualization – Secure Nested Paging (SEV-SNP).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Features

- **Guest memory isolation**: Hardware-encrypted memory by using AMD SEV-SNP ensures workload memory is cryptographically isolated from the host environment.

- **Disk integrity protection**:  You choose the security of the guest OS image. Microsoft provides a sample script to create a guest OS image that is hardened (for example, by turning off emergency shells) and to enable integrity protection. You can use this approach to also enable guest OS disk integrity protection for CVMs. Microsoft recommends enabling guest OS image integrity to protect against host-side tampering of the guest OS disk and boot chain.

- **Hardware-rooted attestation**: Platform firmware measurements bound to workload integrity enable remote verification before sensitive data or keys are released to the workload.

- **Stateless architecture**: CVMs are designed for stateless environments with a minimal Trusted Computing Base (TCB). Workloads fetch secrets post-boot via secure key release and process data entirely in encrypted RAM.

- **Remote attestation with Microsoft Azure Attestation for secure key release**: CVMs generate hardware-rooted attestation reports validated by Microsoft Azure Attestation to issue tokens for secure key release via Azure Key Vault.

## Technical architecture

The CVM architecture on Azure Local enables secure workload execution through a layered trust model. The process begins when a user, via the Azure portal or Azure CLI, requests whether an Azure Local cluster is CVM-capable and, upon confirmation, creates a CVM on the host. Within the host, a guest environment runs the customer workload alongside the guest attestation library, which generates cryptographic evidence. This evidence passes through the Host Compatibility Layer (HCL) and vTPM layer to the Combined Asset Manager (IGVM Agent), which obtains platform certificates. The CVM report is then attested by the Azure Attestation service combined endpoint. Upon successful attestation, the Azure Key Vault relying party performs a secure key release based on the attestation evidence. This process ensures that secrets are only released to verified, confidential compute environments running on trusted hardware and firmware.

The fundamental security model of CVMs on Azure Local involves hardware-based memory encryption, hardware-rooted firmware measurements, binding the vTPM implementation to the Trusted Execution Environment (TEE), and secure key release before accessing sensitive data.

In this approach, customers design solutions specifically for stateless environments with a minimal Trusted Computing Base (TCB). Workloads fetch secrets post-boot via secure key release and process data entirely in encrypted RAM. This approach provides the tightest security boundary by isolating only the data-handling components within the CVM boundary.

:::image type="content" source="media/cvm-overview/confidential-virtual-machines-architecture.png" alt-text="Diagram that shows the CVM on Azure Local technical architecture." border="true" lightbox="media/cvm-overview/confidential-virtual-machines-architecture.png":::

## Trust boundary

CVMs establish a strong trust boundary by excluding host administrators. This trust boundary ensures that workload data and execution remain protected even from infrastructure operators. However, consider any Azure resources as part of the trust boundary.

CVMs defend against threats such as remote attackers with host-level access, malicious datacenter personnel with console access, compromised host operating systems, and boot disk tampering through integrity verification mechanisms.

## Physical attack considerations

While Trusted Execution Environments (TEEs) such as AMD SEV-SNP don't protect against sophisticated physical side-channel attacks (for example, power, electromagnetic, timing, or logic analysis attacks), they significantly strengthen security by isolating workloads and protecting data from unauthorized access. When combined with physical safeguards such as secure facilities, tamper-evident controls, and environmental monitoring, TEEs provide a robust defense-in-depth approach that makes physical attacks substantially more difficult.

<!-- Steps to go through CVM Deployment Experience -->

## Supported operating systems

The current release supports Linux-based guest operating systems only – Ubuntu 24.04 using our integrity protected script.

Windows CVM guest support isn't available in this release.

## Supported OEM hardware

CVM deployment on Azure Local is validated on the following OEM server configurations with AMD Genoa Gen 4 CPU:

| OEM    | Server model                        |
|--------|-------------------------------------|
| Lenovo | ThinkAgile MX455 V3 Edge PR         |
| Lenovo | ThinkSystem SR665 V3 Validated Node |

You can find these configurations in the [Azure Local catalog](https://aka.ms/AzureStackHCICatalog).

## Limitations

- Guest Management isn't supported to maintain security boundary.  
- Sections of the file system are read-only.
- The entire file system is ephemeral.
- Images must be custom tailored to CVM.  
- Clean-room image preparation is required; username and password are fixed during image preparation.
- Cloud connectivity is required for Azure Attestation and secure key release (Azure Key Vault).

## Next steps

- [Deploy an Azure Local cluster via ARM template](../index.yml)