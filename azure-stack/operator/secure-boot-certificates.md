---
title: Manage Secure Boot certificate updates
description: Learn how to prepare for and complete Secure Boot certificate-related mitigation steps on Azure Stack Hub integrated systems.
author: sethmanheim
ms.author: sethm
ms.reviewer: mlawindi
ms.date: 05/06/2026
ms.topic: concept-article

---

# Manage Secure Boot certificate updates

This article provides guidance for Azure Stack Hub operators to prepare for and complete Secure Boot certificate-related mitigation steps on Azure Stack Hub integrated systems.

## Overview

Azure Stack Hub uses an OEM firmware package prerequisite model for Secure Boot certificate readiness. Updated Secure Boot certificates are expected to be delivered through OEM firmware packages. Platform hotfixes and platform updates then finalize the mitigation by ensuring the boot manager is updated to use the new certificate chain and by surfacing alerts when prerequisites aren't met.

## Azure Stack Hub Secure Boot certificates expiring in 2026

All Windows-based devices include a standard set of Microsoft certificates in the Key Exchange Key (KEK) and Secure Boot database (DB). These certificates are approaching their expiration date. Azure Stack Hub hosts are affected if they contain any of the listed certificate versions as shown in the following table. To continue receiving regular Secure Boot updates, update the certificates by first applying the appropriate Azure Stack Hub OEM firmware package that refreshes the Secure Boot certificates, and then applying the required Azure Stack Hub hotfixes or updates to complete the mitigation. After applying hotfixes or updates, system alerts guide administrators to perform additional actions, such as updating the OEM firmware package (if not already applied), or running a Privileged Endpoint (PEP) cmdlet to update the boot manager, if required.

| **Expiring certificate** | **Expiration date** | **New certificate** | **Storing location** | **Purpose** |
|----|----|----|----|----|
| **Microsoft Corporation KEK CA 2011** | June 2026 | Microsoft Corporation KEK 2K CA 2023 | Stored in KEK | Signs updates to DB and DBX. |
| **Microsoft Windows Production PCA 2011** | Oct 2026 | Windows UEFI CA 2023 | Stored in DB | Used for signing the   Windows boot loader. |
| **Microsoft UEFI CA 2011*\**** | June 2026 | Microsoft UEFI CA 2023 | Stored in DB | Signs third-party boot loaders and EFI applications. |
| **Microsoft UEFI CA 2011*\**** | June 2026 | Microsoft Option ROM UEFI CA 2023 | Stored in DB | Signs third-party option ROMs |

> [!IMPORTANT]
> Azure Stack Hub systems continue to operate without immediate disruption if Secure Boot certificates aren't updated. However, systems that don't update their platform trust anchors might not be able to apply future security updates that rely on updated Secure Boot signing authorities. Over time, this condition can result in a weakening of the system's security posture.

## Before you begin

Before you begin, make sure you have the following prerequisites in place:

## Prerequisites

- Install the most recent OEM firmware package that refreshes the Secure Boot certificates recommended for your Azure Stack Hub integrated system.
- Apply the Azure Stack Hub hotfix or platform update that contains Secure Boot mitigation logic (see [Supported release paths](#supported-release-paths)).
- Be prepared for controlled, automated node reboots that occur as part of applying hotfixes or updates, or during the enforcement step when triggered through the Privileged Endpoint (PEP) cmdlet as part of the mitigation process.

## Supported release paths

You can enable Secure Boot mitigation support by updating Azure Stack Hub to versions **2501, 2506, 2601, and 2604**, in addition to applying the corresponding Secure Boot mitigation hotfixes for versions **2501, 2506, and 2601 with the latest hotfix installed**.

- Azure Stack Hub versions **2501, 2506, 2601, and 2604** can receive mitigation support by:
  - Updating to these platform versions, or
  - Applying the Secure Boot mitigation hotfix available for the current supported versions **2501, 2506, and 2601**.

These updates and hotfixes enable the platform to:

- Validate the presence of required Secure Boot 2023 certificates delivered through the OEM firmware package.
- Raise alerts when Secure Boot 2023 certificates are not present.
- Detect when the boot manager isn't yet updated to use the new certificate chain.
- Finalize the boot manager update when prerequisites are satisfied.
- If you apply updates or hotfixes after the platform updates the certificates through the OEM firmware package, the boot manager updates automatically as part of the update or hotfix process.
- Prompt administrators, through platform alerts, to run a Privileged Endpoint (PEP) cmdlet to finalize the boot manager update when the OEM firmware package is applied after hotfixes or updates.

> [!IMPORTANT]
> If you apply an Azure Stack Hub update or hotfix before installing the updated OEM firmware package that contains the required Secure Boot 2023 certificates, the platform surfaces alerts providing guidance to apply the appropriate OEM firmware package. After you successfully apply the OEM firmware package update, operators can run the following PEP cmdlet to apply the final mitigation step to the boot manager, as indicated by the platform alerts: `Start-SecretRotation -UpdateBootManager`.

This enforcement action plan updates the boot manager to use the updated Secure Boot certificate chain and might initiate controlled, automated node reboots as part of completing the mitigation.

## Recommended mitigation workflow

To ensure a smooth mitigation process with clear visibility through platform alerts and minimize the risk of disruption, follow this workflow:

### Stage 1: apply OEM firmware first (recommended)

- Apply the OEM firmware package that installs the updated Secure Boot 2023 certificates.
- Complete any OEM-required activation steps (OEM-specific).

### Stage 2: apply Azure Stack Hub hotfix or update

- Update Azure Stack Hub to version **2501, 2506, 2601, or 2604**, or apply the Secure Boot mitigation hotfix for versions **2501, 2506, or 2601**.
- During or after servicing, the platform evaluates certificate readiness and surfaces alerts as needed.

### Stage 3: finalize boot manager update (if required)

- If the platform indicates, via alerts, that firmware certificates are present but the boot manager isn't yet updated to use the new certificate chain (in case you applied the OEM firmware package after applying AzureStack hotfix or update), run the following PEP cmdlet to enforce the final mitigation step, as indicated by the platform alerts: `Start-SecretRotation -UpdateBootManager`.

## Detailed mitigation logic (what the platform checks)

The platform performs the following checks and actions as part of the mitigation process:

### Certificate readiness checks and alerts

The platform checks for the presence of required Secure Boot 2023 certificates. If any required certificate is missing, the platform raises an alert for that certificate and directs the operator to apply the latest OEM firmware package that installs the missing certificates.

### Boot manager chain validation and alerts

If the minimum required certificates are present (including **Windows UEFI CA 2023** in DB and **2023 KEK**), the platform validates whether the boot manager is using the updated certificate chain. If the boot manager isn't updated, the platform raises an alert instructing the operator to run the PEP cmdlet to finalize the boot manager update.

## HLH guidance

For environments where you manage the Hardware Lifecycle Host (HLH), check with your OEM for HLH-specific guidance. If such guidance isn't available, follow the standard Microsoft Windows guidance to update firmware based on the HLH make and model, and to complete the required mitigation steps as described in:  
[Windows Secure Boot certificate expiration and CA updates - Microsoft Support](https://support.microsoft.com/topic/windows-secure-boot-certificate-expiration-and-ca-updates-7ff40d33-95dc-4c3c-8725-a9b95457578e).

> [!NOTE]
> If the HLH runs an older Windows Server version, this guidance might not apply. You might need to update or redeploy the HLH. For a list of Windows Server versions that support Secure Boot certificate mitigation, see [KB5012170: Security update for Secure Boot DBX - Microsoft Support](https://support.microsoft.com/topic/kb5012170-security-update-for-secure-boot-dbx-72ff5eed-25b4-47c7-be28-c42bd211bb15#:~:text=NOTE%20Improved%20diagnostics%20have%20been,vulnerability%20exists%20in%20secure%20boot).

## Impact on tenant virtual machines

Secure Boot certificate updates and boot manager mitigation actions in Azure Stack Hub don't directly affect tenant virtual machines.

- Azure Stack Hub tenant VMs are Gen1 virtual machines, which don't support Secure Boot.
- Secure Boot mitigation actions apply only to the host boot chain and don't modify tenant VM configuration or guest operating systems.
- No guest‑level changes, reconfiguration, or mitigation steps are required for tenant workloads.
- Tenant workloads remain unaffected.

## Impact on Azure Stack Hub infrastructure

Secure Boot certificate mitigation primarily targets physical Azure Stack Hub hosts.

- Infrastructure VMs are managed and refreshed by the Azure Stack Hub platform during hub updates.
- Infrastructure VMs created or refreshed as part of platform updates automatically pick up the updated Secure Boot state.

## FAQ

This section answers some frequently asked questions about the Secure Boot certificate mitigation process.

### Do I need both a hotfix and 2604?

No. You should either apply the down-level hotfix for your current Hub version **2501, 2506, 2601** or update to **2501, 2506, 2601, 2604**. In both cases, the OEM firmware package is the prerequisite for certificate installation. The platform then finalizes the boot manager update when prerequisites are satisfied.

### What if I installed the hotfix or update before the OEM firmware package?

The platform supports this scenario. Initially, platform alerts indicate that the new Secure Boot certificates are missing and prompt you to update the OEM firmware package. After you apply the OEM firmware update, follow the platform alerts. If prompted, run the following Privileged Endpoint (PEP) cmdlet to finalize the boot manager update: `Start-SecretRotation -UpdateBootManager`.

### Does the PEP cmdlet reboot my system?

The PEP enforcement flow is designed to reboot nodes one at a time during the finalization step.

## Troubleshooting

This section provides troubleshooting steps for common issues that might arise during the mitigation process.

### Alert indicates missing certificates

- Install the latest OEM firmware package that provides the missing certificates.
- After you apply the OEM firmware package update, follow the platform alerts. If prompted, run the following Privileged Endpoint (PEP) cmdlet to finalize the boot manager update: `Start-SecretRotation -UpdateBootManager`.

### Alert indicates boot manager not updated

Run: `Start-SecretRotation -UpdateBootManager`
