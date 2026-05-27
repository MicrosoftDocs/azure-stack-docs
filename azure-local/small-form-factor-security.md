---
title: Security Features for Small Form Factor Deployments of Azure Local (Preview)
description: Security guidance and best practices for securing small form factor deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.topic: concept-article
ms.service: azure-local
ms.date: 05/26/2026
ms.subservice: small-form-factor
---

# Security features for small form factor deployments of Azure Local (preview)

This article describes the built-in security capabilities for small form factor deployments and provides guidance for securing your environment.

[!INCLUDE [hci-preview](includes/hci-preview.md)]

Small form factor deployments of Azure Local run in distributed edge environments where physical access, connectivity, and operational controls differ from traditional datacenters.

These environments often include:

- Retail stores, factory floors, or remote sites.
- Limited physical security or on-site administration.
- Intermittent or constrained network connectivity.

These conditions increase exposure to risks such as device tampering, unauthorized software modification, and data exfiltration.

## Security approach

Small form factor deployments are designed with these constraints in mind. Microsoft built security into the platform from the ground up - anchored in secure device provisioning, reinforced through platform protections, and extended into cloud-based management. This approach helps devices start in a known, trusted state, protect sensitive data, and support secure management at scale when deployed and configured according to Microsoft guidance.

As deployments grow across locations, Azure Arc provides centralized governance capabilities to help you control access, apply policies, and collect diagnostics across a distributed fleet, subject to connectivity and configuration.

The security posture of Azure Local small form factor is built on four core pillars:

- [**Hardware-rooted trust and platform integrity**](#hardware-rooted-trust-and-platform-integrity): Device identity and integrity are anchored in hardware-based protections that help detect and reduce the risk of unauthorized changes during boot and operation.

- [**Data protection by default**](#data-protection-by-default): Sensitive data and credentials are encrypted at rest and in transit, reducing the risk of exposure, even in the event of device loss or compromise.

- [**Secure lifecycle and defense in depth**](#secure-lifecycle-and-defense-in-depth): Microsoft develops, deploys, and updates platform software by using secure engineering practices. Layered protections help reduce risk across the software lifecycle.

- [**Centralized access, policy, and diagnostics**](#centralized-access-policy-and-diagnostics): Azure-based management supports centralized access control, policy enforcement, and operational visibility across distributed environments, subject to connectivity and configuration.

## Hardware-rooted trust and platform integrity

Small form factor deployments use hardware-anchored identity and integrity capabilities to help establish device trust at startup and maintain platform integrity during operation. These capabilities reduce the risk of unauthorized changes to the platform across distributed edge deployments.

For details on provisioning, see [Install small form factor deployments of Azure Local](https://review.learn.microsoft.com/azure/azure-local/small-form-factor/small-form-factor-installation?&branch=pr-en-us-20809).

### Establishing a trusted boot process

Azure Local small form factor deployments rely on Secure Boot to enforce a chain of trust from device startup. Secure Boot enables the device to only boot software signed by a trusted certificate authority configured in the device’s Secure Boot database. This feature helps prevent unauthorized or tampered firmware and bootloaders from executing during startup. Ensure Secure Boot is enabled on your device to activate this protection - either configured by you on self-sourced hardware or provisioned by your OEM.
  
At each stage in the boot sequence, the platform records measurements in the Trusted Platform Module (TPM). The system unlocks encrypted data volumes when these measurements match expected, trusted values. This process helps the system start in a known-good state and reduces the risk of sensitive data exposure if the platform state is modified.

### Applying defense-in-depth supply chain verification during onboarding

Microsoft implements the industry standard FIDO Device Onboarding (FDO) protocol to establish device identity and ownership. When Azure Local is first bootstrapped, Microsoft or the OEM generates and provides an Ownership Voucher. Microsoft cryptographically binds this voucher to the device’s hardware identifiers and secrets. During onboarding, Azure Local validates the voucher against the provisioned device's reported state and might prevent onboarding if the validation doesn't succeed. This process helps establish a secure link between the physical device and Azure and reduces the risk of certain supply chain threats, such as unauthorized device replacement or cloning.

### Detecting changes to device platform software across boots

After Azure verifies your device's identity, the device downloads and installs the approved target operating system image and prepares the system to run workloads. When booting the target operating system, the system only unlocks the encrypted data volumes if the recorded TPM measurements match previous and trusted values. The device doesn't boot if measurements have changed.

### Protecting platform software integrity at runtime

Azure Local small form factor deployments help protect the integrity of critical non-data volumes through dm-verity and read-only permissions. If the system detects any unauthorized modifications for key files such as system binaries and libraries, either offline or at runtime, it may restrict or interrupt normal operation. These controls help mitigate risks from pre-boot and post-boot tampering, persistent malware, and unauthorized changes that could survive reboots.

## Data protection by default
  
Azure Local small form factor deployments help protect sensitive data through multiple layers of encryption designed to safeguard information both at rest and in transit. 
  
### Encrypting data at rest

Persistent data partitions that store customer or workload data, such as application data, configuration files, and logs, are encrypted by default. The devices use hardware-backed disk encryption. The devices' TPM seals the encryption keys and only releases them when the platform boots into a known, verified state by using Secure and Measured boot. These partitions stay encrypted at rest to help protect data even if the storage device is physically removed, lost, stolen, or booted by using unauthorized or alternate media. This protection helps reduce the risk of offline data exfiltration and unauthorized inspection of stored data.
  
### Encrypting data in transit

All platform communication uses industry-standard encryption protocols. Azure Local enables applications and platform components to use end-to-end encrypted communication for data in transit by leveraging Transport Layer Security (TLS) and industry-standard cryptographic ciphers supported by Azure services. TLS 1.3 is enabled by default, with fallback to TLS 1.2 when required. Datagram TLS (DTLS) 1.2 is supported for UDP-based communication. These protections reduce the risks from eavesdropping, man-in-the-middle attacks, and data tampering by helping ensure network traffic is encrypted by using modern encryption protocols and cipher suites without known weaknesses.

If you're running AKS Arc, your cross-node communication between Kubernetes control plane components is encrypted. To learn more, see [AKS Arc Security Book - Configure TLS encryption and authentication](/azure/azure-arc/kubernetes/conceptual-secure-your-workloads#configure-tls-encryption-and-authentication-withintofrom-workloads).

### Centralized secrets management

For scenarios requiring tighter control over sensitive credentials, you can store secrets in Azure Key Vault and sync only the required secrets locally using the Azure Key Vault Secret Store Extension. This reduces the amount of sensitive data persisted on edge devices while supporting offline operation when needed.

## Secure lifecycle and defense in depth

Azure Local small form factor deployments are built and maintained by using secure engineering practices that reduce vulnerabilities over time and support reliable delivery of updates. Implement security as defense in depth by combining layered controls across the software lifecycle and runtime environment.

### Embedding Microsoft Security Development Lifecycle best practices

Azure Local small form factor applies the [Microsoft Security Development Lifecycle (SDL)](https://www.microsoft.com/en-us/securityengineering/sdl/?msockid=3800329235a16ddf0ac627e7341b6c83), which integrates security best practices throughout the design, implementation, testing, and release of platform software. Azure Local build and release workflows integrate SDL practices such as threat modeling, dependency governance, and automated security testing. Additionally, complementary secure engineering practices, including Software Bill of Materials (SBOM) generation and safe deployment workflows, support platform software supply chain integrity and enable the safe rollout of updates and out-of-band security fixes. These practices reduce the likelihood of vulnerabilities being introduced into released software over time.

### Operating system level isolation and least-privilege design

Small form factor deployments follow defense‑in‑depth principles across the platform stack to help reduce risk and limit blast radius if a component is misconfigured or compromised. At the operating system layer, platform services and extensions minimize unnecessary access by using scoped permissions and constrained privileges wherever possible. This approach reduces reliance on broad administrative permissions and supports clearer privilege boundaries between platform components.

## Centralized access, policy, and diagnostics

Azure Local small form factor deployments provide centralized control over access and policy enforcement across distributed edge environments. Azure-integrated mechanisms authenticate and authorize devices, users, and services that interact with the platform and Azure control plane, helping ensure that only trusted entities can perform management operations.

Use these capabilities to apply consistent access controls and security policies across your deployment.
  
### Establishing trusted device and service identities

Azure Local relies on strong, cryptographically backed, and where supported, hardware-backed identities (for example, TPM-anchored identities) for devices and platform services when interacting with Azure control plane endpoints (for example, during provisioning, management, policy evaluation, and update operations). These identities establish which devices and services are trusted to communicate with Azure, forming the foundation for secure control plane interactions and helping prevent unauthorized systems from participating in management or lifecycle operations.

### Controlling access through role‑based authorization
  
After a device or service authenticates, Azure role‑based access control (RBAC) governs access to resources and management operations. RBAC determines what authenticated users and services are allowed to do – such as viewing configuration, initiating upgrades, or performing administrative actions. To reduce risk, apply least‑privilege principles when assigning Azure roles, limit standing administrative access, and regularly review role assignments. Using scoped roles for routine operations helps ensure that day‑to‑day tasks don't require elevated permissions, reducing the impact of compromised credentials.

When running Kubernetes-based deployments, either with AKS Arc or on third-party clusters such as K3s, refer to [AKS Arc Security Book – Secure your operations](/azure/azure-arc/kubernetes/conceptual-secure-your-operations) for guidance on controlling access to Azure and Kubernetes control plane using Azure RBAC and Kubernetes RBAC.

### Direct device access via Secure Shell (SSH)

Direct device access, such as SSH, is supported as an operational option for specific administrative or troubleshooting scenarios. Where enabled, restrict and control direct access by using strong authentication methods, least‑privilege access, and limited network exposure.

SSH access isn't required for routine platform management and should be enabled only when operationally necessary. Scope access tightly, apply network restrictions, and disable direct access when no longer needed, consistent with your security policies and operational requirements. For step-by-step instructions on how to connect, see [Connect to the machine over SSH](https://review.learn.microsoft.com/azure/azure-local/small-form-factor/small-form-factor-connect-portal?&branch=pr-en-us-20809#connect-to-the-machine-over-ssh).

### Security baselines and best practices enabled by default

By default, Azure Local small form factor deployments enable security baseline settings and security best practices based on Microsoft recommendations and industry best practices. The tailored security baseline is applied during provisioning to help establish a secure foundation. These protections include controls for network configuration hardening, authentication policy enforcement, and secure system configuration settings, which help reduce the risk of misconfiguration and limit exposure to common host‑level risks such as unauthorized data access, weak credential use, and certain network‑based attacks.  
  
This security baseline is informed by widely adopted standards, such as the [Center for Internet Security (CIS) Benchmark](https://www.cisecurity.org/cis-benchmarks), [Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG)](https://www.cyber.mil/stigs/), Federal Information Processing Standards (FIPS 140-2) requirements for the operating system (OS), and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-linux). The security baseline settings are verified for compatibility and performance impact and are designed to evolve alongside industry standards.

### Collecting system logs for troubleshooting and operational review

Azure Local supports secure log collection workflows to help with troubleshooting, auditing, and security investigations. Role‑based access controls and supported collection processes govern access to logs and diagnostic data. You're responsible for retention, access, and downstream use in line with your organizational policies.
  
For more information about the process of log collection, see [Collect logs for small form factor deployments of Azure Local](https://review.learn.microsoft.com/azure/azure-local/small-form-factor/small-form-factor-collect-system-logs?&branch=pr-en-us-20809).

## Next steps

- [Set up your Azure subscription for small form factor deployments of Azure Local](https://review.learn.microsoft.com/azure/azure-local/small-form-factor/small-form-factor-subscription-setup?&branch=pr-en-us-20809).
