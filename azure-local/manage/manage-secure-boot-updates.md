---
title: Manage Secure Boot Updates
description: Manage Secure Boot updates, including 2023 certificate rollout and CVE-2023-24932 mitigations, for Azure Local clusters.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 03/25/2026
ms.subservice: hyperconverged
---

# Manage Secure Boot updates

::: moniker range="=azloc-2603"

This article describes how Azure Local manages the transition from the 2011 Secure Boot certificates, which expire in June 2026, to the 2023 Secure Boot certificates, including how it mitigates [CVE-2023-24932](https://github.com/advisories/GHSA-cgcm-2v5q-v3w9) and why the changes are delivered through a phased rollout.

It also covers how Azure Local orchestrates Secure Boot updates alongside OEM and hardware updates including Solution Builder Extension (SBE) packages and provides guidance for monitoring and validating each stage of the update process.

This article is intended for Azure Local cluster operators, OEMs, solution integrators, and IT administrators who manage Secure Boot, firmware (Basic Input/Output System (BIOS) or Unified Extensible Firmware Interface (UEFI)), and operating system updates and reboots.

> [!IMPORTANT]
> Secure Boot revocation actions can be irreversible while Secure Boot remains enabled. Always validate updates on representative hardware and follow Microsoft guidance before adding changes broadly.

## About Secure Boot certificates

- Secure Boot certificates are issued with defined lifetimes. Periodically refreshing these certificates helps keep them aligned with current security requirements. For Azure Local, you must install the 2023 Secure Boot certificate authorities (CAs) before the 2011 CAs begin to expire in June 2026.

- 2023 Secure Boot certificates are delivered via OEM firmware updates or Azure Local updates starting with the 2603 release. Azure Local built‑in orchestration provides Secure Boot 2023 certificate update when applied through a platform update.

- CVE-2023-24932 is a Secure Boot security feature bypass associated with the BlackLotus UEFI bootkit. Fully fixing it requires updating boot components and applying revocations, such as through DBX updates, so older vulnerable boot managers can't bypass Secure Boot.

- Because Secure Boot updates interact with platform firmware (UEFI variables) and boot-time security technologies like BitLocker and Virtualization-based Security (VBS), we recommend a phased approach with thorough testing and controlled rollout in enterprise environments.

- For Azure Local, a key consideration is maintaining clear sequencing between update types. Secure Boot updates should be applied separately from hardware or firmware (BIOS or UEFI) updates. Perform these updates in distinct maintenance steps to help ensure a stable and predictable boot‑time security state.

- Azure Local’s mitigation implementation therefore focuses on orchestration and gating:

    1. Orchestrate the installation of the 2023 Secure Boot certificates across cluster nodes, including required reboots, and installing boot manager signed by Windows UEFI CA 2023.
    1. Avoid applying Secure Boot updates on the same reboot as firmware updates.

## Background: CVE-2023-24932 and staged mitigations

Microsoft provides enterprise guidance for adding protections for CVE‑2023‑24932. These mitigations require coordinated changes across Windows and device firmware. To minimize risk and avoid operational disruption, we recommend you plan and test before adding these changes broadly.

- **Threat model:** An attacker with physical access or administrator privileges can attempt to bypass Secure Boot by using older trusted boot components.

- **Mitigation principle:** Update trust anchors and boot components and then apply revocations so older vulnerable boot managers become untrusted.

- **Operational reality:** Secure Boot updates interact with platform firmware in different ways. In rare cases, firmware behavior might affect boot outcomes. We recommend you test on representative hardware and coordinate with OEM firmware as part of a controlled update.

For more information, see [Enterprise deployment guidance for CVE-2023-24932 (Microsoft Support)](https://support.microsoft.com/topic/enterprise-deployment-guidance-for-cve-2023-24932-88b8f034-20b7-4a45-80cb-c6049b0f9967).

## Terminology and components

- **Secure Boot:** A security feature of UEFI based firmware that helps ensure only trusted software runs during the device boot (start) sequence.

- **UEFI Secure Boot databases:**
    - **DB:** Contains allowed signatures.
    - **DBX:** Contains revoked signatures.
    
    Updates are stored in the UEFI firmware variables.

- **Key Exchange Key (KEK):** Authorizes updates to the Secure Boot DB and DBX.

- **Certificates used:** The industry is transitioning from older 2011-era Microsoft Secure Boot CAs to newer 2023 CAs, such as **Windows UEFI CA 2023**. The 2011 Secure Boot certificates expire in 2026.

- **Windows Boot Manager revocations:** Policy and data (often in DBX) used to prevent older vulnerable or malicious boot managers from being accepted by Secure Boot.

- **Solution Builder Extension:** A package that lets OEMs publish and apply updates to the hardware and firmware components. An SBE uniquely tracks which Azure Local Solution Versions it's compatible with and includes health checks to ensure it's appropriate to install.

## Azure Local host Secure Boot 2023 certificates playbook

Secure Boot 2023 certificate updates and mitigations for CVE‑2023‑24932 aren’t a single "flip‑the‑switch" operation. Instead, they consist of a sequence of state transitions that must be validated against the specific platform firmware and boot configuration.

### Azure Local staged update model

To safely roll out the Secure Boot certificate updates, Azure Local tracks nodes through conceptual stages, as described in the following table:

| Stage | Description | Why it matters | Release version |
|----|----|----|----|
| Stage 0 | The 2023 Secure Boot CA isn't present in the firmware databases. | The node can't rely on 2023-signed boot components. | Before 2603 |
| Stage 1 | The 2023 Secure Boot CA is present in the firmware databases. | The node is closer to being ready, and subsequent steps can be scheduled. | 2603 |
| Stage 2 | The node boots by using the 2023 CA-signed boot manager. | The platform demonstrated compatibility, making later revocations safer to apply. | 2603 |
<!--| Stage 3 | The node has OEM-compatible firmware with the new Secure Boot 2023 certificates. | Both the hardware and OS layers are updated and ready for future fixes. | 2603-2604 |
| Stage 4 (future) | Revocation data applied, for example, DBX update, to block older vulnerable boot managers. | This stage closes the bypass path but can be hard to revert and must be carefully planned and tested. | Post-2603 (to be determined) |-->

> [!NOTE]
> For some hardware platforms, you might need to manually update firmware before advancing to stages 1 and 2 described in the preceding table.

### Why Azure Local adds extra orchestration

Azure Local servicing is cluster-aware and can include coordinated reboots, OS updates, and in some cases firmware or BIOS updates. Some platforms can experience boot-time security side effects if a Secure Boot update sequence and a firmware update sequence are applied too closely together, for example, during the same reboot cycle. To reduce this risk, Azure Local treats Secure Boot mitigation as a managed workflow with explicit prechecks, ordering guarantees, and safety gates.

## Azure Local host implementation details

### Orchestration mechanics (CAU plugin and node workflow)

Azure Local applies Secure Boot mitigations by using a cluster-aware orchestration component based on a Cluster-Aware Updating (CAU) plugin. The plugin coordinates node-by-node progression and ensures each node advances only when it's safe.

- **Preflight check:** Confirm that Secure Boot is enabled and the node is in a supported configuration. For example, no unexpected Secure Boot key customization.

- **Safety checks:** Confirm that boot protection technologies that can be sensitive to firmware variable changes (like BitLocker) are handled appropriately.

- **Controlled reboot sequencing:** When a Secure Boot update step requires a reboot, the plugin schedules and monitors the node reboot and validates progress before continuing.

- **Health states:** If a node fails to progress on the update (or reports firmware incompatibility), the workflow moves to the next node to avoid leaving the cluster in an unknown or partially updated state.

### Interaction with SBE and firmware updates (blocking + ordering)

A core design requirement is to avoid applying Secure Boot mitigation steps during the same reboot as a firmware update (BIOS or UEFI). Azure Local enforces this requirement by blocking or deferring SBE and firmware update actions while Secure Boot mitigation is in progress.

- If a firmware update is planned, Azure Local prefers to complete the Secure Boot readiness steps first, validating the outcome, and only then allowing firmware updates.

- If a subsequent Secure Boot step is scheduled after an earlier reboot, Azure Local attempts to avoid unplanned reboots that could later coincide with firmware updates before that second step completes.

### Observability: Monitoring progress

Windows records Secure Boot DB and DBX update successes and failure reasons in the Windows Event Log. These events are the primary supported method to determine whether updates are applied, postponed, or blocked due to safety conditions.

- Monitor the Secure Boot DB and DBX-related event IDs described by Microsoft. For example, events indicating BitLocker must be suspended, that a vulnerable bootloader is detected, or that DB or DBX updates succeeded.

- Track node stage transitions in Azure Local update logs (cluster update output) to verify that each node completes the expected sequence before moving to the next node.

## Azure Local host recommended workflow

### Before you start (inventory and readiness)

- Take inventory of all Azure Local nodes, including hardware model, firmware version, Secure Boot configuration, and boot media usage.

- Contact your OEM to understand whether a platform firmware is required to install 2023 Secure Boot certificates and when they are making it available.

- Validate the update process on representative hardware first (at least one system per platform type). Validate both normal boot scenarios and recovery or media‑based boot scenarios.

    > [!NOTE]
    > Azure Local solutions can be updated to version 2603 even if the required firmware updates aren’t available at the time of the update.

### During rollout

- Update to 2603 that includes the Secure Boot mitigation orchestration, using planned maintenance windows.

- Monitor Secure Boot update events during pilot phases. Don’t proceed to broad rollout if updates are blocked or postponed on pilot nodes.

- Use the following command to confirm whether Secure Boot certificate updates have completed:

    ```powershell
    Test-AzSSecureBootUpdateCompleted
    ```
    
    - If the returned value is `True`, the Secure Boot certificate update steps are complete.
    - If the returned value is `False`, follow the documented troubleshooting steps.

    > [!NOTE]
    > Azure Local solution updates retry the Secure Boot 2023 certificate update on a best‑effort basis. If the update can't be completed, the solution update proceeds, even when a firmware update is required by the hardware solution.

### After rollout (verification and continued operations)

- Confirm that all nodes boot with the expected updated boot components and that the Secure Boot mitigation reaches a stable stage across the cluster.

<!--## What happens after 2603 solution update

- Starting with release 2604, Azure Local performs prechecks to verify that the Secure Boot certificates and CVE mitigation are in place and the systems boot by using a Windows UEFI CA 2023-signed boot manager.

- OEM hardware updates delivered through firmware and SBE packages are scheduled beginning with solution update 2604 and later.

- Revocation of the **Microsoft Windows Production PCA 2011** certificate is planned for a future solution update, aligned with broader Microsoft guidance.-->

## Troubleshooting and safety notes

- If firmware blocks a Secure Boot update, work with your OEM to obtain the required firmware update. Don't force untrusting 2011 certificates without validating that the firmware can boot.

- Follow the documented troubleshooting guidance to diagnose blocked or postponed Secure Boot updates.

For more information, see [Original Equipment Manufacturer (OEM) pages for Secure Boot](https://support.microsoft.com/topic/original-equipment-manufacturer-oem-pages-for-secure-boot-9ecc3ba4-fb50-4bd3-9e9b-f16b35b8fb68).

<!-- Link to the Public TSG (for troubleshooting) is needed!-->

## What if I can't update before July 2026?

After Secure Boot-related certificates expire, devices without the new certificates can continue to boot and run, and regular Windows updates still install. However, these devices don't receive any new boot-level security updates or protections. This lack of updates includes Windows Boot Manager, Secure Boot databases, revocation lists, or fixes for new boot vulnerabilities.

We strongly recommend completing this update as soon as possible. If you require firmware updates for supported hardware, contact your OEM to understand availability and timelines.

## Azure Local VM Secure Boot 2023 certificates playbook

Azure Local clusters might host VMs that are affected by Secure Boot certificate expiration. The required actions depend on when the VMs were created.

- **VMs created before October 2024**

    If VMs (Arc-enabled VMs or VMs created using traditional deployment methods) were created before October 2024, the Secure Boot certificate exposed to the VM will be before 2023 CAs were broadly available. Manual action is required. Follow the guidance in [Windows Server Secure Boot playbook for certificates expiring in 2026](https://techcommunity.microsoft.com/blog/windowsservernewsandbestpractices/windows-server-secure-boot-playbook-for-certificates-expiring-in-2026/4495789).

- **VMs created after October 2024**

    If VMs (Arc-enabled VMs or VMs created using traditional deployment methods) were created after October 2024, the VM should already have the new 2023 CA firmware in place.

    Check for the 2023 CAs by running the following PowerShell commands. Each command should return `True`.

    ```powershell
    [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI db).bytes) -match 'Windows UEFI CA 2023'
    ```

    ```powershell
    [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI kek).bytes) -match 'Microsoft Corporation KEK 2K CA 2023'
    ```

## Support and escalation guidance

If you have issues while planning, orchestrating, or verifying Secure Boot updates, contact Microsoft Support before proceeding with other firmware (BIOS or UEFI) changes or enabling revocations in production environments.

### Severity mapping for Azure Local Secure Boot scenarios

| Severity | When to use it | Examples | What to include |
|---|---|---|---|
| Severity A (Critical) | Production outage or imminent business-critical impact. One or more nodes can't boot, or the cluster is down or can't provide service. | - Host fails to boot after Secure Boot update or revocation. <br>- Repeated boot loops. <br>- Cluster unavailable because nodes are stuck during boot.<br>- Recovery, WinRE, or installation media can't boot and recovery is blocked. | - Exact failure point and recent changes. <br>- Firmware (BIOS or UEFI) version and OEM model. <br>- Secure Boot-related event logs and last reboot time. <br>- BitLocker state or recovery prompt details (if applicable). |
| Severity B (High) | Production functionality is degraded or at-risk, but the cluster remains operational. Requires timely investigation. | - Secure Boot update stuck in a pending or scheduled state across reboots, <br>- Repeated Secure Boot DB or DBX update failure in event logs. <br>- Azure Local health shows persistent out-of-policy related to Secure Boot servicing. <br>- Planned firmware update must proceed but Secure Boot mitigation is mid-flight. | - Current mitigation stage (DB, Boot Manager, DBX). <br>- Relevant Secure Boot event IDs and messages. <br>- Evidence of pending reboot requirements. <br>-  Planned maintenance window details. |
| Severity C (Normal) | Questions, guidance requests, or non-production and testing issues with no service impact. | - Planning and validation questions. <br>- Confirming firmware readiness for certificate updates. <br>-  Updating boot media or WinPE and validating compatibility. <br>- Interpreting Secure Boot events and expected timing. | - Environment inventory (OEM models, firmware versions). <br>- Pilot or test results. <br>- Relevant KB references and completed steps. |

### When to contact support versus when to wait

1. Is any Azure Local node unable to boot, or is the cluster down or unavailable?  
    - Yes: Open a **Severity A** support request immediately.  
    - No: Continue.

2. Did you recently apply a Secure Boot update step that requires one or more reboots?  
    - Yes: Allow the required reboots to complete, then re-check Secure Boot event logs.  
    - No or not sure: Continue.

3. Do Secure Boot event logs show a blocking condition, such as BitLocker recovery risk, customized keys, or firmware not supporting the update?
    - Yes: Don't proceed with other steps or firmware updates. Open a **Severity B** request.  
    - No: Continue.

4. Is a firmware (BIOS or UEFI) update, including SBE-driven firmware updates, scheduled while a certificate update step is pending or scheduled?  
    - Yes: Pause or defer the firmware update if possible, and open a **Severity B** request for coordination guidance.  
    - No: Continue.

5. Are you validating the process in a test or lab environment with no service impact?  
    - Yes: Use **Severity C** for guidance and best practices.  
    - No: If production risk exists, use **Severity B**.

For more information about how to get support, see [Get support for Azure Local](./get-support.md).

## Appendix: Reference links

- [MSRC blog: Guidance related to Secure Boot manager changes associated with CVE-2023-24932](https://www.microsoft.com/msrc/blog/2023/05/guidance-related-to-secure-boot-manager-changes-associated-with-cve-2023-24932)

- [Enterprise deployment guidance for CVE-2023-24932](https://support.microsoft.com/topic/enterprise-deployment-guidance-for-cve-2023-24932-88b8f034-20b7-4a45-80cb-c6049b0f9967)

- [Updating Windows bootable media to use the PCA2023 signed boot manager - Microsoft Support](https://support.microsoft.com/topic/updating-windows-bootable-media-to-use-the-pca2023-signed-boot-manager-d4064779-0e4e-43ac-b2ce-24f434fcfa0f)

- [KB5016061: Secure Boot DB/DBX update events](https://support.microsoft.com/topic/secure-boot-db-and-dbx-variable-update-events-37e47cf8-608b-4a87-8175-bdead630eb69)

- [Frequently asked questions about the Secure Boot update process](https://support.microsoft.com/topic/frequently-asked-questions-about-the-secure-boot-update-process-b34bf675-b03a-4d34-b689-98ec117c7818)

- [Secure Boot playbook for certificates expiring in 2026 (Windows IT Pro Blog)](https://techcommunity.microsoft.com/blog/windows-itpro-blog/secure-boot-playbook-for-certificates-expiring-in-2026/4469235)

::: moniker-end

::: moniker range="<azloc-2603"

This feature is available only in Azure Local 2603.

::: moniker-end