---
title: Security features for Azure Stack HCI, version 23H2 (preview)
description: Learn about security features available for new deployments of Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/27/2023
---

# Security features for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

Azure Stack HCI is a secure-by-default product that has more than 300 security settings enabled right from the start. Default security settings provide a consistent security baseline to ensure that devices start in a known good state.

This article describes the following security features associated with your Azure Stack HCI cluster, version 23H2 (preview):

- [Secure baseline and drift control](#secure-baseline-and-drift-control) - Improves the security posture by disabling legacy protocols and ciphers, reduces operating expenditure (OPEX) with built-in drift protection, and enables consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- [Windows Defender Application Control](#windows-defender-application-control) - A software-based security layer that reduces attack surface by enforcing an explicit list of software that is allowed to run.
- [Bitlocker encryption](#bitlocker-encryption) - By default, data-at-rest encryption is enabled on data volumes created during deployment.
- [Local built-in user accounts](#local-built-in-user-accounts) - The names of local built-in users associated with the `RID 500` and `RID 501` accounts have been updated in this release.
- Other security features:
  - [Manage secrets in Azure Stack HCI](#manage-secrets-in-azure-stack-hci) - Enables you to create and rotate internal secrets.
  - [Syslog forwarding of security events](#syslog-forwarding-of-security-events) - Enables you to forward security-related events to a security information and event management (SIEM) system.

> [!IMPORTANT]
> Security compliance requires strict log and audit of security events; in Azure Stack HCI, we recommend that customers use our Azure Cloud Sentinel service. For more information, see [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel).

For additional security considerations, see:

- [Manage Windows Defender Application Control](../whats-new.md).
- [Manage baseline security settings and drift control](../whats-new.md).
- [Manage BitLocker](../whats-new.md).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Secure baseline and drift control

Your Azure Stack HCI has more than 300 security settings enabled by default that provide a consistent security baseline, a baseline management system, and an associated drift control mechanism.

You can monitor the security baseline and secured-core settings during both deployment and runtime. You can also disable drift control during deployment when you configure security settings.

With drift control applied, security settings are refreshed every 90 minutes. This refresh interval ensures remediation of any changes from the desired state. Continuous monitoring and auto-remediation allows you to have a consistent and reliable security posture throughout the lifecycle of the device.

Secure baseline on Azure Stack HCI:

- Improves the security posture by disabling legacy protocols and ciphers.
- Reduces OPEX with a built-in drift protection mechanism and enables consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- Enables you to closely meet Center for Internet Security (CIS) benchmark and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the OS and recommended security baseline.

For more information about secure baseline on Azure Stack HCI, see [Manage secure baseline](../whats-new.md).

## Windows Defender Application Control

Windows Defender Application Control (WDAC) is a software-based security layer that reduces attack surface by enforcing an explicit list of software that is allowed to run. WDAC is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Manage Windows Defender Application Control for Azure Stack HCI, version 23H2 (preview)](../whats-new.md).

## BitLocker encryption

All data-at-rest on your Azure Stack HCI cluster is protected with BitLocker XTS-AES 256-bit encryption. When you deploy your cluster, you have the option to modify security settings. By default, data-at-rest encryption is enabled on data volumes created during deployment. We recommend that you accept the default setting.

We recommend that you store BitLocker recovery keys in a secure location outside of the system. Once Azure Stack HCI is successfully deployed, you can retrieve BitLocker recovery keys.

For more information about BitLocker, see:

- [Use BitLocker with Cluster Shared Volumes (CSV)](../manage/bitlocker-on-csv.md).
- [BitLocker encryption on Azure Stack HCI (preview)](./security-bitlocker.md).

## Local built-in user accounts

In this release, the following local built-in users, associated with `RID 500` and `RID 501`, are available on your Azure Stack HCI system:

|Name in initial OS image |Name after deployment |Enabled by default |Description |
|-----|-----|-----|-----|
|Administrator |ASBuiltInAdmin |True |Built-in account for administering the computer/domain |
|Guest |ASBuiltInGuest |False |Built-in account for guest access to the computer/domain, protected by the security baseline drift control mechanism. |

> [!IMPORTANT]
> We recommend that you create your own local administrator account, and that you disable the well-known `RID 500` user account.

## Manage secrets in Azure Stack HCI

The Lifecycle Manager on Azure Stack HCI requires multiple components to maintain secure communications with other infrastructure resources and services. To ensure security, we implemented internal secret creation and rotation capabilities.

All services exposed internally by Lifecycle Manager have authentication or encryption certificates associated with them. When you review your cluster nodes, you will see several certificates created under the path `LocalMachine/Personal certificate store (Cert:\LocalMachine\My).

In this release, the following capabilities are enabled:

- The ability to create certificates during deployment and after cluster scale operations.
- Automated auto-rotation mechanism before certificates expire, and an option to rotate certificates during the lifetime of the cluster.
- The ability to monitor and alert whether certificates are still valid.

> [!NOTE]
> This action will take about 10 minutes, depending on the size of the cluster.  The operation requires the user to belong to the `LCM authorization` group (PREFIX-ECESG) and `CredSSP` for remote PowerShell invocation or remote desktop protocol (RDP) connection.

## Syslog forwarding of security events

For customers and organizations that require their own local SIEM, Azure Stack HCI version 23H2 includes an integrated mechanism that enables you to forward security-related events to a SIEM.

Azure Stack HCI has an integrated syslog forwarder that, once configured, generates syslog messages defined in RFC3164, with the payload in Common Event Format (CEF).

The following diagram illustrates integration of Azure Stack HCI with an SIEM. All audits, security logs, and alerts are collected on each host and exposed via syslog with the CEF payload.

:::image type="content" source="media/other-security-features/integration-of-azure-stack-hci-with-external-siem.png" alt-text="The following diagram describes the integration of Azure Stack HCI with an external security information and event management (SIEM) system." border="false" lightbox="media/other-security-features/integration-of-azure-stack-hci-with-external-siem.png":::

Syslog forwarding agents are deployed on every Azure Stack HCI host to forward syslog messages to the customer-configured syslog server. Syslog forwarding agents work independently from each other but can be managed together on any one of the hosts.

The syslog forwarder in Azure Stack HCI supports various configurations based on whether syslog forwarding is with TCP or UDP, whether the encryption is enabled or not, and whether there is unidirectional or bidirectional authentication.

For more information, see [Manage syslog forwarding](../manage/manage-syslog-forwarding.md).

## Next steps

- [Assess deployment readiness via the Environment Checker](../manage/use-environment-checker.md).
