---
title: What are Confidential Virtual Machines (VMs) for Azure Local (preview)?
description: Learn how confidential virtual machines (CVMs) on Azure Local bring hardware-based memory encryption and attestation to customer-owned edge infrastructure for stateless, security-sensitive workloads (preview).
author: sipastak
ms.author: sipastak
ms.date: 07/27/2026
ms.topic: overview
ms.service: azure-local
ms.subservice: hyperconverged
---

# What are confidential VMs for Azure Local (preview)?

::: moniker range=">=azloc-2607"

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article provides an overview of confidential virtual machines (CVMs) on Azure Local.

CVMs on Azure Local bring hardware-based memory encryption and attestation to customer-owned edge infrastructure. They extend Azure's confidential computing platform to the edge to provide cryptographic assurance that protects and encrypts data in use, in RAM, and during computation.

CVMs offer stronger security and confidentiality than standard virtual machines (VMs). They provide hardware-based isolation between virtual machines, the hypervisor, and host management code.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Features

- **Guest memory isolation**: Hardware-encrypted memory by using AMD SEV-SNP ensures workload memory is cryptographically isolated from the host environment.

- **Disk integrity protection**: You choose the security of the guest OS image. Microsoft provides a sample script that creates a hardened guest OS image (for example, by turning off emergency shells) and enables integrity protection. This approach also enables guest OS disk integrity protection for CVMs. To protect against host-side tampering of the guest OS disk and boot chain, enable guest OS image integrity.

- **Hardware-rooted attestation**: Platform firmware measurements bound to workload integrity enable remote verification before sensitive data or keys are released to the workload.

- **Stateless architecture**: CVMs are designed for stateless environments with a minimal Trusted Computing Base (TCB). Workloads fetch secrets post-boot through secure key release and process data entirely in encrypted RAM.

- **Remote attestation with Microsoft Azure Attestation for secure key release**: CVMs generate hardware-rooted attestation reports that Microsoft Azure Attestation validates to issue tokens for secure key release through Azure Key Vault.

## Technical architecture

The CVM architecture on Azure Local enables secure workload execution through a layered trust model. The process begins when you use the Azure portal or Azure CLI to check whether an Azure Local cluster is CVM-capable and, after confirmation, create a CVM on the host. Within the host, a guest environment runs the customer workload alongside the guest attestation library. This library allows the user to obtain cryptographic evidence bound to the CVM, so the workload can prove via attestation that it's running in a trusted environment. The Azure Attestation service combined endpoint then attests the CVM report. After successful attestation, the Azure Key Vault relying party performs a secure key release based on the attestation evidence. This process ensures that secrets are released only to verified, confidential compute environments that run on trusted hardware and firmware.

The fundamental security model of CVMs on Azure Local involves hardware-based memory encryption, hardware-rooted firmware measurements, binding the vTPM implementation to the Trusted Execution Environment (TEE), and secure key release before accessing sensitive data.

In this approach, you design solutions specifically for stateless environments with a minimal Trusted Computing Base (TCB). Workloads fetch secrets post-boot through secure key release and process data entirely in encrypted RAM. This approach provides the tightest security boundary because it isolates only the data-handling components within the CVM boundary.

:::image type="content" source="media/cvm-overview/confidential-virtual-machines-architecture.png" alt-text="Diagram that shows the CVM on Azure Local technical architecture." border="true" lightbox="media/cvm-overview/confidential-virtual-machines-architecture.png":::

## Trust boundary

CVMs establish a strong trust boundary by excluding host administrators. This trust boundary ensures that workload data and execution remain protected even from infrastructure operators. However, consider any Azure resources as part of the trust boundary.

CVMs defend against threats such as remote attackers with host-level access, malicious datacenter personnel with console access, compromised host operating systems, and boot disk tampering. Integrity verification mechanisms help protect against these threats.

## Physical attack considerations

Trusted Execution Environments (TEEs) such as AMD SEV-SNP don't protect against sophisticated physical side-channel attacks (for example, power, electromagnetic, timing, or logic analysis attacks). However, they significantly strengthen security by isolating workloads and protecting data from unauthorized access. When combined with physical safeguards such as secure facilities, tamper-evident controls, and environmental monitoring, TEEs provide a robust defense-in-depth approach that makes physical attacks substantially more difficult.

<!-- Steps to go through CVM Deployment Experience -->

## Supported operating systems

The current release supports Linux-based guest operating systems only – Ubuntu 24.04 using our integrity protected script.

Windows CVM guest support isn't available in this release.

## Supported OEM hardware

CVM deployment on Azure Local is validated on the following OEM server configurations with AMD EPYC 9004 Series (Genoa) processors. Example processors include AMD EPYC 9654, 9754, and 9684X.

| OEM    | Server model                        |
|--------|-------------------------------------|
| Lenovo | ThinkAgile MX455 V3 Edge PR         |
| Lenovo | ThinkSystem SR665 V3 Validated Node |

You can find these configurations in the [Azure Local catalog](https://aka.ms/AzureStackHCICatalog).

## Limitations

- To maintain the security boundary, guest management isn't supported.
- Sections of the file system are read-only.
- The entire file system is ephemeral.
- You must custom-tailor images to CVM.
- Clean-room image preparation is required. The username and password are fixed during image preparation.
- Cloud connectivity is required for Azure Attestation and secure key release (Azure Key Vault).

## Next steps

- [Deploy an Azure Local cluster via ARM template for confidential VMs](confidential-vm-deploy-cluster-via-arm-template.md)

::: moniker-end

::: moniker range="<=azloc-2606"

This feature is available only in Azure Local 2607 or later.

::: moniker-end
