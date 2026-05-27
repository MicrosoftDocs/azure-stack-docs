---
title: Security Book for Small Form Factor Deployments of Azure Local (Preview)
description: Security guidance and best practices for securing small form factor deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.topic: concept-article
ms.service: azure-local
ms.date: 05/26/2026
ms.subservice: small-form-factor
---

# Security features for small form factor deployments of Azure Local (preview)

[!INCLUDE [hci-preview](includes/hci-preview.md)]

This security book applies to small form factor deployments of Azure Local running the current preview release.

## Overview

Small form factor deployments of Azure Local operate in distributed edge environments where physical access, network reliability, and operational controls differ significantly from traditional datacenters. Devices are often deployed at scale, ranging from hundreds to thousands of nodes across retail stores, factory floors, or remote sites, where physical security and administrative access is limited, and connectivity may be intermittent. These conditions increase exposure to risks such as device tampering, unauthorized software modification, and data exfiltration.

Small form factor deployments are designed with these constraints in mind. Security is built into the platform from the ground up - anchored in secure device provisioning, reinforced through platform protections, and extended into cloud-based management. This approach is intended to help devices start in a known, trusted state, protect sensitive data, and support secure management at scale when deployed and configured according to Microsoft guidance.

As deployments grow across locations, Azure Arc provides centralized governance capabilities to help you control access, apply policies, and collect diagnostics across a distributed fleet, subject to connectivity and configuration.

The security posture of Azure Local small form factor is built on four core pillars:

1. [Hardware-rooted trust and platform integrity](#hardware-rooted-trust-and-platform-integrity): Device identity and integrity are anchored in hardware-based protections that help detect and reduce the risk of unauthorized changes during boot and operation.

1. [Data protection by default](#data-protection-by-default): Sensitive data and credentials are encrypted at rest and in transit, reducing the risk of exposure, even in the event of device loss or compromise.

1. [Secure lifecycle and defense in depth](#secure-lifecycle-and-defense-in-depth): Platform software is developed, deployed, and updated using secure engineering practices, with layered protections designed to help reduce risk across the software lifecycle.

1. [Centralized access, policy, and diagnostics](#centralized-access-policy-and-diagnostics): Azure-based management supports centralized access control, policy enforcement, and operational visibility across distributed environments, subject to connectivity and configuration.

This security book describes the built-in protections across these four pillars. It also provides guidance on additional measures you can take to further strengthen the security posture of your deployments.

## Hardware-rooted trust and platform integrity

Azure Local small form factor deployments use hardware-anchored identity and integrity capabilities intended to help establish device trust at startup and to help maintain platform integrity during operation. These capabilities are designed to help reduce risk of unauthorized changes to the platform across distributed edge deployments.

For details on provisioning and setup flows, see [Install small form factor deployments of Azure Local](https://review.learn.microsoft.com/azure/azure-local/small-form-factor/small-form-factor-installation?&branch=pr-en-us-20809).

### Establishing a trusted boot process

Azure Local small form factor deployments rely on Secure Boot to enforce a chain of trust from device startup. Secure Boot enables the device to only boot software signed by a trusted certificate authority configured in the device’s Secure Boot database. This helps prevent unauthorized or tampered firmware and bootloaders from executing during startup. You should ensure Secure Boot is enabled on your device to activate this protection - either configured by you on self-sourced hardware or provisioned by your OEM.  
  
At each stage in the boot sequence, the platform records measurements in the Trusted Platform Module (TPM). Encrypted data volumes are unlocked when these measurements match expected, trusted values. This helps the system start in a known-good state and helps reduce the risk of sensitive data exposure if the platform state has been modified.

### Applying defense-in-depth supply chain verification during onboarding

Microsoft implements the industry standard FIDO Device Onboarding (FDO) protocol to establish device identity and ownership. When Azure Local is first bootstrapped, Microsoft or the OEM generates and provides an Ownership Voucher. Microsoft cryptographically binds this voucher to the device’s hardware identifiers and secrets. During onboarding, Azure Local validates the voucher against the provisioned devices reported state and may prevent onboarding if the validation does not succeed. This process helps establish a secure link between the physical device and Azure and is designed to reduce the risk of certain supply chain threats, such as unauthorized device replacement or cloning.

### Detecting changes to device platform software across boots

After Azure verifies your device's identity, the device downloads and installs the approved target operating system image and prepares the system to run workloads. When booting the target operating system, the encrypted data volumes are only unlocked if the recorded TPM measurements match previous and trusted values, preventing the device from booting if measurements have changed.

### Protecting platform software integrity at runtime

Azure Local Small form factor deployments help protect the integrity of critical non-data volumes through dm-verity and read-only permissions. If any unauthorized modifications are detected for key files such as system binaries and libraries, either offline or at runtime, the system may restrict or interrupt normal operation. These controls help mitigate risks from pre-boot and post-boot tampering, persistent malware, and unauthorized changes that could survive reboots.

## Data protection by default
  
Azure Local Small form factor deployments help protect sensitive data through multiple layers of encryption designed to safeguard information both at rest and in transit.  
  
### Encrypting data at rest
 
Persistent data partitions that store customer or workload data (such as application data, configuration files, and logs) are encrypted by default, using hardware-backed disk encryption on devices. Encryption keys are sealed to the devices' TPM and only released when the platform boots into a known, verified state using Secure and Measured boot. These partitions are designed to remain encrypted at rest, and the intention is to help protect data even if the storage device is physically removed, lost, stolen, or booted using unauthorized or alternate media. This helps reduce the risk of offline data exfiltration and unauthorized inspection of stored data.  
  
### Encrypting data in transit

All platform communication is secured using industry-standard encryption protocols. Azure Local enables applications and platform components use end‑to‑end encrypted communication for data in transit, leveraging Transport Layer Security (TLS) and industry‑standard cryptographic ciphers supported by Azure services. TLS 1.3 is enabled by default, with fallback to TLS 1.2 when required. Datagram TLS (DTLS) 1.2 is supported for UDP-based communication. These protections reduce the risks from eavesdropping, man‑in‑the‑middle attacks, and data tampering by helping ensure network traffic is encrypted using modern encryption protocols and cipher suites without known weaknesses.

If you’re running AKS Arc, your cross-node communication between Kubernetes control plane components is encrypted. To learn more, refer to [AKS Arc Security Book - Configure TLS encryption and authentication](/azure/azure-arc/kubernetes/conceptual-secure-your-workloads#configure-tls-encryption-and-authentication-withintofrom-workloads).  

### Centralized secrets management

For scenarios requiring tighter control over sensitive credentials, you can store secrets in Azure Key Vault and sync only the required secrets locally using the Azure Key Vault Secret Store Extension. This reduces the amount of sensitive data persisted on edge devices while supporting offline operation when needed.

## Secure lifecycle and defense in depth

Azure Local small form factor deployments are built and maintained using secure engineering practices intended to reduce vulnerabilities over time and support reliable delivery of updates. Security is implemented as defense in depth, combining layered controls across the software lifecycle and runtime environment.

### Embedding Microsoft Security Development Lifecycle best practices

Azure Local Small form factor applies the [Microsoft Security Development Lifecycle (SDL)](https://www.microsoft.com/en-us/securityengineering/sdl/?msockid=3800329235a16ddf0ac627e7341b6c83), which integrates security best practices throughout the design, implementation, testing, and release of platform software. SDL practices such as threat modeling, dependency governance, and automated security testing are integrated into Azure Local build and release workflows. Additionally, complementary secure engineering practices, including Software Bill of Materials (SBOM) generation and safe deployment workflows, are applied to support platform software supply chain integrity and enable the safe rollout of updates and out‑of‑band security fixes, reducing the likelihood of vulnerabilities being introduced into released software over time.

### Operating system level isolation and least-privilege design

Small form factor deployments are designed with defense‑in‑depth principles across the platform stack to help reduce risk and limit blast radius if a component is misconfigured or compromised. At the Operating System layer, platform services and extensions are designed to minimize unnecessary access by using scoped permissions and constrained privileges wherever possible. This approach is intended to reduce reliance on broad administrative permissions and support clearer privilege boundaries between platform components

## Centralized access, policy, and diagnostics

Azure Local small form factor deployments enable centralized control over access and policy enforcement across distributed edge environments. Devices, users, and services interacting with the platform and Azure control plane are authenticated and authorized through Azure-integrated mechanisms, helping ensure that only trusted entities can perform management operations.

You can use these capabilities to apply consistent access controls and security policies across your deployment.  
  
### Establishing trusted device and service identities

Azure Local relies on strong, cryptographically backed and where supported, hardware-backed identities (for example, TPM-anchored identities) for devices and platform services when interacting with Azure control plane endpoints (for example, during provisioning, management, policy evaluation, and update operations. These identities establish which devices and services are trusted to communicate with Azure, forming the foundation for secure control plane interactions and helping prevent unauthorized systems for participating in management or lifecycle operations.

### Controlling access through role‑based authorization
  
Once a device or service is authenticated, access to resources and management operations is governed through Azure role‑based access control (RBAC). RBAC determines what authenticated users and services are allowed to do – such as viewing configuration, initiating upgrades, or performing administrative actions. To reduce risk, you should apply least‑privilege principles when assigning Azure roles, limit standing administrative access, and regularly review role assignments. Using scoped roles for routine operations helps ensure that day‑to‑day tasks do not require elevated permissions, reducing the impact of compromised credentials.

When running Kubernetes-based deployments, either with AKS Arc or on third-party clusters such as K3s, refer to [AKS Arc Security Book – Secure your operations](/azure/azure-arc/kubernetes/conceptual-secure-your-operations) for guidance on controlling access to Azure and Kubernetes control plane using Azure RBAC and Kubernetes RBAC.

### Direct device access via Secure Shell (SSH)

Direct device access, such as SSH, is supported as an operational option for specific administrative or troubleshooting scenarios. Where enabled, direct access is intended to be restricted and controlled, using strong authentication methods, least‑privilege access, and limited network exposure.

SSH access is not required for routine platform management and should be enabled only when operationally necessary. You are encouraged to scope access tightly, apply network restrictions, and disable direct access when no longer needed, consistent with your security policies and operational requirements. For step-by-step instructions on how to connect, see [Connect to the machine over SSH](https://review.learn.microsoft.com/azure/azure-local/small-form-factor/small-form-factor-connect-portal?&branch=pr-en-us-20809#connect-to-the-machine-over-ssh).

### Security baselines and best practices enabled by default

By default, Azure Local small form factor deployments enable security baseline settings and security best practices based on Microsoft recommendations and industry best practices. The tailored security baseline is applied during provisioning to help establish a secure foundation. These protections include controls for network configuration hardening, authentication policy enforcement, and secure system configuration settings, which help reduce the risk of misconfiguration and limit exposure to common host‑level risks such as unauthorized data access, weak credential use, and certain network‑based attacks.  
  
This security baseline is informed by widely adopted standards, such as the [Center for Internet Security (CIS) Benchmark](https://www.cisecurity.org/cis-benchmarks), [Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG)](https://www.cyber.mil/stigs/), Federal Information Processing Standards (FIPS 140-2) requirements for the operating system (OS), and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-linux). The security baseline settings have been verified for compatibility and performance impact and are designed to evolve alongside industry standards.

### Collecting system logs for troubleshooting and operational review

Azure Local supports secure log collection workflows to assist with troubleshooting, auditing, and security investigations. Access to logs and diagnostic data is governed by role‑based access controls and supported collection processes, with you being responsible for retention, access, and downstream use in accordance with your organizational policies.  
  
To learn more about the process of log collection, see [Collect logs for small form factor deployments of Azure Local](https://review.learn.microsoft.com/azure/azure-local/small-form-factor/small-form-factor-collect-system-logs?&branch=pr-en-us-20809).

## Next steps

- [Set up your Azure subscription for small form factor deployments of Azure Local](https://review.learn.microsoft.com/azure/azure-local/small-form-factor/small-form-factor-subscription-setup?&branch=pr-en-us-20809).
