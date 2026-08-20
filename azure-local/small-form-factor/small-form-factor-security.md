---
title: Security Features for Small Form Factor Deployments of Azure Local (Preview)
description: Security guidance and best practices for securing small form factor deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.topic: concept-article
ms.service: azure-local
ms.date: 08/17/2026
ms.subservice: small-form-factor
---

# Security features for small form factor deployments of Azure Local (preview)

This article describes the built-in security capabilities for small form factor deployments of Azure Local and provides guidance for securing your environment.

For security guidance when running Kubernetes-based deployments on small form factor devices, either with AKS on Azure Arc or on third-party clusters such as K3s, see the [Azure Arc-enabled Kubernetes and AKS enabled by Azure Arc Security Book](/azure/azure-arc/kubernetes/conceptual-security-book). This reference book doesn't cover security guidance for running raw containers with Docker.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

Small form factor deployments run in distributed edge environments where physical access, connectivity, and operational controls differ from traditional datacenters.

These environments often include:

- Retail stores, factory floors, or remote sites.
- Limited physical security or on-site administration.
- Intermittent or constrained network connectivity.

These conditions increase exposure to risks such as device tampering, unauthorized software modification, and data exfiltration.

## Security approach

Azure Local small form factor deployments are designed with these constraints in mind. The platform has security built in from the ground up - anchored in secure device provisioning, reinforced through platform protections, and extended into cloud-based management. This approach helps devices start in a known, trusted state, protect sensitive data, and support secure management at scale when you deploy and configure the devices according to Microsoft guidance.

As deployments grow across locations, Azure Arc provides centralized governance capabilities to help you control access, apply policies, and collect diagnostics across a distributed fleet, subject to connectivity and configuration.

The security posture of Azure Local small form factor deployments is built on four core pillars:

- **Hardware-rooted trust and platform integrity**: Device identity and integrity are anchored in hardware-based protections that help detect and reduce the risk of unauthorized changes during boot and operation.
- **Data protection by default**: Sensitive data and credentials are encrypted at rest and in transit, reducing the risk of exposure, even in the event of device loss or compromise.
- **Secure lifecycle and defense in depth**: Platform software is developed, deployed, and updated by using secure engineering practices, with layered protections designed to help reduce risk across the software lifecycle.
- **Centralized access, policy, and diagnostics**: Azure-based management supports centralized access control, policy enforcement, and operational visibility across distributed environments, subject to connectivity and configuration.

This security book describes the built-in protections across these four pillars. It also provides guidance on additional measures you can take to further strengthen the security posture of your deployments.

## 1. Hardware-rooted trust and platform integrity

Azure Local small form factor deployments use hardware-anchored identity and integrity capabilities that help establish device trust at startup and maintain platform integrity during operation. These capabilities help reduce the risk of unauthorized changes to the platform across distributed edge deployments.

For details on provisioning and setup flows, see [Install the maintenance environment on your machine](small-form-factor-installation.md) and [Zero-Touch Provisioning for Small Form Factor Deployments of Azure Local](small-form-factor-zero-touch-provisioning.md).

### Establishing a trusted boot process

Azure Local small form factor deployments rely on Secure Boot to enforce a chain of trust from device startup. Secure Boot enables the device to boot only software signed by a trusted certificate authority configured in the device's Secure Boot database. This process helps prevent unauthorized or tampered firmware and bootloaders from executing during startup. Ensure Secure Boot is enabled on your device to activate this protection, either configured by you on self-sourced hardware or provisioned by your OEM.

At each stage in the boot sequence, the platform records measurements in the Trusted Platform Module (TPM). The system unlocks encrypted data volumes when these measurements match expected, trusted values. This process helps the system start in a known-good state and reduces the risk of sensitive data exposure if the platform state is modified.

### Applying defense-in-depth supply chain verification during onboarding

Azure Local uses concepts and core technology from the FIDO Device Onboard (FDO) specification to establish device identity and ownership. After the maintenance environment is installed, the device produces an ownership voucher, a cryptographic document that links the physical device to its digital identity. Keep the voucher in a secure, backed-up location until the device is registered, and delete it after registration.

During onboarding, Azure uses the uploaded voucher to authenticate and claim the device before provisioning. Ownership vouchers are one-time use, and the Zero-Touch Provisioning service rejects attempts to claim a device that is already assigned to a provisioned machine. This process helps reduce the risk of claiming the wrong device or sending configuration to an untrusted endpoint. For more information, see [Zero-Touch Provisioning for Small Form Factor Deployments of Azure Local](small-form-factor-zero-touch-provisioning.md).

### Detecting changes to device platform software across boots

After Azure verifies your device's identity, the device downloads and installs the approved target operating system image and prepares the system to run workloads. When booting the target operating system, encrypted data volumes are unlocked only if the recorded TPM measurements match previous, trusted values. This prevents the device from booting if the measurements changed.

### Protecting platform software integrity at runtime

Azure Local small form factor deployments help protect the integrity of critical non-data volumes through dm-verity and read-only permissions. If the system detects unauthorized modifications to key files such as system binaries and libraries, either offline or at runtime, it might restrict or interrupt normal operation. These controls help mitigate risks from preboot and post-boot tampering, persistent malware, and unauthorized changes that could survive reboots.

## 2. Data protection by default

Azure Local small form factor deployments help protect sensitive data through multiple layers of encryption designed to safeguard information both at rest and in transit.

### Encrypting data at rest

Persistent data partitions that store customer or workload data, such as application data, configuration files, and logs, are encrypted by default by using hardware-backed disk encryption on devices. Encryption keys are sealed to the device's TPM and released only when the platform boots into a known, verified state by using Secure and Measured Boot. These partitions are designed to remain encrypted at rest and help protect data if the storage device is physically removed, lost, stolen, or booted by using unauthorized or alternate media. This protection helps reduce the risk of offline data exfiltration and unauthorized inspection of stored data.

### Encrypting data in transit

All platform communication is secured by using industry-standard encryption protocols. Azure Local enables applications and platform components to use end-to-end encrypted communication for data in transit by using Transport Layer Security (TLS) and industry-standard cryptographic ciphers supported by Azure services. TLS 1.3 is enabled by default, with fallback to TLS 1.2 when required. Datagram TLS (DTLS) 1.2 is supported for UDP-based communication. These protections reduce the risks from eavesdropping, man-in-the-middle attacks, and data tampering by helping ensure network traffic is encrypted by using modern encryption protocols and cipher suites without known weaknesses.

If you're running AKS Arc, cross-node communication between Kubernetes control plane components is encrypted. For more information, see [Configure TLS encryption and authentication with, within, and from workloads](/azure/azure-arc/kubernetes/conceptual-secure-your-workloads#configure-tls-encryption-and-authentication-withintofrom-workloads).

### Centralized secrets management

When you run Kubernetes-based deployments with AKS Arc or on third-party clusters such as K3s, store secret values like passwords and keys in a vault such as [Azure Key Vault](/azure/key-vault/general/overview) for tighter control over sensitive credentials. Use the [Azure Key Vault Secret Store Extension](/azure/azure-arc/kubernetes/secret-store-extension) to sync only the required secrets locally. This approach reduces the amount of sensitive data persisted on edge devices while supporting offline operation when needed. For more information, see [Secure your data in Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-secure-your-data#use-a-vault-to-store-your-secrets-and-sync-to-the-cluster-as-needed).

To further enhance your security, manually install and enable the Key Management Service (KMS) plugin on an Arc-connected, single-node K3s cluster to encrypt Kubernetes secrets. The plugin uses hardware-backed TPM protection where available and process-based isolation otherwise. For more information, see [Encrypt Kubernetes secrets on K3s on small form factor deployments of Azure Local](small-form-factor-encrypt-kubernetes-secrets.md).

## 3. Secure lifecycle and defense in depth

The Azure Local small form factor deployments are built and maintained by using secure engineering practices that reduce vulnerabilities over time and support reliable delivery of updates. Security is implemented as defense in depth, combining layered controls across the software lifecycle and runtime environment.

### Embedding Microsoft Security Development Lifecycle best practices

Azure Local small form factor applies the [Microsoft Security Development Lifecycle (SDL)](https://www.microsoft.com/securityengineering/sdl), which integrates security best practices throughout the design, implementation, testing, and release of platform software. The Azure Local build and release workflows integrate SDL practices such as threat modeling, dependency governance, and automated security testing. Complementary secure engineering practices, including Software Bill of Materials (SBOM) generation and safe deployment workflows, support platform software supply chain integrity and enable the safe rollout of updates and out-of-band security fixes. These practices reduce the likelihood of vulnerabilities being introduced into released software over time.

### Supporting a predictable security support window

Azure Local small form factor deployments are designed to remain continuously updatable, helping you maintain devices within supported and secure configurations over time. The platform defines clear support windows for the operating system, enabling predictable lifecycle management and reducing exposure to known vulnerabilities.

Azure makes updates available through the portal and CLI. You're responsible for initiating and applying updates to keep devices within supported versions. You receive notifications when new updates become available, including security updates that might be released outside the standard cadence to address urgent risks. To learn more, see [Update your Azure Local small form factor deployment](small-form-factor-upgrade.md).

During preview, you're responsible for maintaining the security of the underlying hardware, including applying firmware and BIOS updates in line with OEM guidance.

### Preserving operational safety during update and recovery scenarios

Azure Local small form factor update workflows preserve recoverability and operational resilience if an update is interrupted or fails. They preserve critical device state, including persistent data volumes and security-sensitive material, across upgrades. Devices return to a functional, secure, and updatable state. These workflows also incorporate rollback support and configuration reconciliation capabilities to restore devices to a known, supported configuration following update failures or interruptions. This design reduces the risk of prolonged device unavailability or configuration drift in distributed edge environments.

### Operating system-level isolation and least-privilege design

Azure Local small form factor deployments use defense-in-depth principles across the platform stack to reduce risk and limit the impact if a component is misconfigured or compromised. At the operating system layer, platform services and extensions minimize unnecessary access by using scoped permissions and constrained privileges. This approach reduces reliance on broad administrative permissions and supports clearer privilege boundaries between platform components.

Just-in-Time (JIT) access supports defense in depth by enabling time-bound, auditable privilege elevation for administrative operations instead of standing access. This approach minimizes exposed remote management pathways. For more information, see [Limit elevated access with Just-In-Time controls](#limiting-elevated-access-with-just-in-time-jit-controls).


## 4. Centralized access, policy, and diagnostics

Azure Local small form factor deployments enable centralized control over access and policy enforcement across distributed edge environments. Azure-integrated mechanisms authenticate and authorize devices, users, and services that interact with the platform and Azure control plane. This authentication and authorization process helps ensure that only trusted entities can perform management operations.

Use these capabilities to apply consistent access controls and security policies across your deployment.


### Establishing trusted device and service identities

Azure Local relies on strong, cryptographically backed, and hardware-backed identities, such as TPM-anchored identities, for devices and platform services when interacting with Azure control plane endpoints. These interactions include provisioning, management, policy evaluation, and update operations. These identities establish which devices and services are trusted to communicate with Azure. They form the foundation for secure control plane interactions and help prevent unauthorized systems from participating in management or lifecycle operations.


### Controlling access through role-based authorization

After a device or service is authenticated, Azure role-based access control (RBAC) governs access to resources and management operations. RBAC determines what authenticated users and services are allowed to do, such as viewing configuration, initiating upgrades, or performing administrative actions. To reduce risk, apply least-privilege principles when assigning Azure roles, limit standing administrative access, and regularly review role assignments. Using scoped roles for routine operations helps ensure that day-to-day tasks don't require elevated permissions, reducing the impact of compromised credentials.

When running Kubernetes-based deployments, either with AKS Arc or on third-party clusters such as K3s, see [Secure your operations in Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-secure-your-operations) for guidance on controlling access to the Azure and Kubernetes control planes by using Azure RBAC and Kubernetes RBAC.

### Limiting elevated access with Just-in-Time (JIT) controls

Azure Local small form factor deployments support Just-in-Time (JIT) access in preview, helping you reduce the risk associated with standing administrative privileges and long-lived credentials. By using Microsoft Entra Privileged Identity Management (PIM), you can give users eligible, resource-scoped roles that they activate only when access is required and for a limited period of up to eight hours.

After activation, the user connects over SSH by using a short-lived certificate and temporary session account. Access ends automatically when the activated role expires. You can further protect privileged operations with Microsoft Entra controls such as multifactor authentication, Conditional Access, activation justification, and approval.

This approach helps you apply least privilege, limit the impact of compromised credentials, reduce opportunities for unauthorized or insider access, and maintain an auditable record of privileged access, while enabling administrators to reach devices when needed.

For prerequisites, preview limitations, and connection instructions, see [Connect to small form factor deployments of Azure Local by using Just-in-Time access](small-form-factor-connect-jit.md).

### Security baselines and best practices enabled by default

By default, Azure Local small form factor deployments enable security baseline settings and security best practices based on Microsoft recommendations and industry best practices. The tailored security baseline is applied during provisioning to help establish a secure foundation. These protections include controls for network configuration hardening, authentication policy enforcement, and secure system configuration settings. Together, these controls help reduce the risk of misconfiguration and limit exposure to common host-level risks such as unauthorized data access, weak credential use, and certain network-based attacks.

This security baseline is informed by widely adopted standards, such as the [Center for Internet Security (CIS) Benchmark](https://www.cisecurity.org/cis-benchmarks), [Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG)](https://www.cyber.mil/stigs/), Federal Information Processing Standards (FIPS 140-2) requirements for the operating system, and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-linux). The security baseline settings are verified for compatibility and performance impact and are designed to evolve alongside industry standards.

These baselines are also designed to support detection of configuration and runtime drift from an intended security posture, along with policy-driven corrective actions where supported. This helps identify deviations introduced over time and restore systems toward an expected configuration. When privileged access is granted by using JIT, the resulting access events are logged and can be reviewed as part of your monitoring or configuration management processes to help assess changes from an intended security posture.

### Collecting system logs for troubleshooting and operational review

Azure Local supports secure log collection workflows to help with troubleshooting, auditing, and security investigations. Role-based access controls and supported collection processes govern access to logs and diagnostic data. You're responsible for retention, access, and downstream use in accordance with your organizational policies.

For more information, see [Collect logs for small form factor deployments of Azure Local](small-form-factor-collect-system-logs.md).

## Endnotes

This document is provided "as-is." Information, views, URLs, and other Internet website references might change without notice. Some information relates to prereleased product, which might be substantially modified before it's commercially released.
