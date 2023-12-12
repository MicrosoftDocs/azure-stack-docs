---
title: Security features for Azure Stack HCI, version 23H2 (preview)
description: Learn about security features available for new deployments of Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/11/2023
---

# Security features for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

Azure Stack HCI is a secure-by-default product and has more than 300 security settings enabled right from the start. Default security settings provide a consistent security baseline to ensure that devices start in a known good state.

This article describes the following security features associated with your Azure Stack HCI cluster, version 23H2 (preview):

- [Local built-in user accounts](#local-built-in-user-accounts) - The names of local built-in users associated with the `RID 500` and `RID 501` accounts have been updated in this release.
- [Secure baseline and drift control](#secure-baseline-and-drift-control) - Improves the security posture by disabling legacy protocols and ciphers, reduces operating expenditure (OPEX) with built-in drift protection, and enables consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- [Manage secrets in Azure Stack HCI](#manage-secrets-in-azure-stack-hci) - Enables you to create and rotate internal secrets.
- [Syslog forwarding](#syslog-forwarding) - Enables you to forward security-related events to a security information and event management (SIEM) system.
- [Bitlocker encryption](#bitlocker-encryption) - By default, data-at-rest encryption is enabled on data volumes created during deployment.
- [Windows Defender Application Control](#windows-defender-application-control) - A software-based security layer that reduces attack surface by enforcing an explicit list of software that is allowed to run.

For additional security considerations, see...

- links to "manage" articles.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Local built-in user accounts

The names of local built-in users associated with the `RID 500` and `RID 501` accounts have been updated:

|Name |Enabled |Description |
|-----|-----|-----|
|ASBuiltInAdmin |True |Built-in account for administering the computer/domain |
|ASBuiltInGuest |False |Built-in account for guest access to the computer/domain |

> [!Important]
> We recommend that you create your own local administrator account, and that you disable the well-known `RID 500` user account.

The `ASBuiltInGuest` account is protected by the security baseline drift control mechanism. For more information, see [Security baseline settings for Azure Stack HCI (preview)](/azure-stack/hci/concepts/secure-baseline).

We also added two new components in the 23H2 release:

- [Secrets management engine]().
- [SIEM syslog forwarder agent]().

For more information about local built-in user accounts, see []().

## Secure baseline and drift control

When you prepare Active Directory for Azure Stack HCI and create a dedicated organizational unit, existing Group Policy and Group Policy Object (GPO) inheritance are blocked by default. Blocking these policies ensures that there is no conflict of security settings.

Secure baseline on Azure Stack HCI:

- Improves the security posture by disabling legacy protocols and ciphers.
- Reduces OPEX with a built-in drift protection mechanism, and enables consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- Enables you to closely meet Center for Internet Security (CIS) benchmark and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the OS and recommended security baseline.

For more information about secure baseline, see []().

### Drift control

You can monitor and perform drift protection of the default enabled security baseline and secured-core settings during both deployment and runtime. You can also disable drift protection during deployment when you configure the security settings.

With drift protection applied, security settings are refreshed regularly every 90 minutes. This refresh interval is the same as that for Group Policies and ensures that any changes from the desired state are remediated. Continuous monitoring and auto-remediation allows you to have a consistent and reliable security posture throughout the device lifecycle.

For detailed steps to configure syslog forwarding and drift control, see [Manage syslog forwarding]() and [Manage baseline security settings]().

## Manage secrets in Azure Stack HCI

The Lifecycle Manager (LCM) stack requires multiple components to maintain secure communications with other infrastructure resources and services. To ensure security, we implemented internal secret creation and rotation capabilities.

All services exposed internally by LCM have authentication or encryption certificates associated with them. When you look into your cluster nodes, you will see several certificates created under the path `LocalMachine/Personal certificate store (Cert:\LocalMachine\My).

This new component enables the following capabilities:

- The ability to create certificates during deployment and post deployment cluster scale actions.
- Automated auto-rotation mechanism before certificates expire, and a customer option to rotate certificates during the lifetime of the cluster.
- The ability to monitor and alert if certificates are still valid.

> [!NOTE]
> This action will take place using LCM actions and will last about 10 minutes, depending on the size of the cluster.  This action affects all nodes that use LCM, and requires the user to belong to the `LCM authorization` group (PREFIX-ECESG) and `CredSSP` for remote Powershell invocation or remote desktop protocol (RDP) connection.

## Syslog forwarding

For customers and organizations that require their own local SIEM, Azure Stack HCI version 23H2 includes an integrated mechanism that enables you to forward security-related events to an SIEM.

Azure Stack HCI has an integrated syslog forwarder that, once configured, generates syslog messages defined in RFC3164, with the payload in Common Event Format (CEF).

The following diagram illustrates integration of Azure Stack HCI with an SIEM. All audits, security logs, and alerts are collected on each host and exposed via syslog with the CEF payload.

:::image type="content" source="media/other-security-features/integration-of-azure-stack-hci-with-external-siem.png" alt-text="The following diagram describes the integration of Azure Stack HCI with an external SIEM." border="false" lightbox="media/other-security-features/integration-of-azure-stack-hci-with-external-siem.png":::

### About syslog forwarding

Syslog forwarding agents are deployed on every Azure Stack HCI host. Each syslog forwarding agent will forward syslog messages collected from its host to the customer-configured syslog server.

Syslog forwarding agents work independently from each other but can be managed together on any one of the hosts. You can use provided cmdlets with administrator privileges on any host to control the behavior of all forwarder agents.

The syslog forwarder in Azure Stack HCI supports the following configurations:

- **Syslog forwarding with TCP, mutual authentication (client and server), and TLS 1.2 encryption:** In this configuration, both the syslog server and the syslog client can verify the identity of each other via certificates. Messages are sent over a TLS 1.2 encrypted channel. For more information, see [Syslog forwarding with TCP, mutual authentication, and TLS 1.2 encryption](#syslog-forwarding-with-tcp-mutual-authentication-and-tls-12-encryption).
- **Syslog forwarding with TCP, server authentication, and TLS 1.2 encryption** In this configuration, the syslog client can verify the identity of the syslog server via a certificate. Messages are sent over a TLS 1.2 encrypted channel. For more information, see [Syslog forwarding with TCP, server authentication, and TLS 1.2 encryption](#syslog-forwarding-with-tcp-server-authentication-and-tls-12-encryption).
- **Syslog forwarding with TCP and no encryption:** In this configuration, the syslog client and syslog server identities aren’t verified. Messages are sent in clear text over TCP. For more information, see [Syslog forwarding with TCP and no encryption](#syslog-forwarding-with-tcp-and-no-encryption).
- **Syslog with UDP and no encryption:** In this configuration, the syslog client and syslog server identities aren’t verified. Messages are sent in clear text over UDP. For more information, see [Syslog forwarding with UDP and no encryption](#syslog-forwarding-with-udp-and-no-encryption).

For additional security considerations:  Security compliance requires strict log and audit of security events; in Azure Stack HCI, we recommend that customers use our Azure Cloud Sentinel service. For more information, see [Microsoft Sentinel](https://azure.microsoft.com/products/microsoft-sentinel).

## BitLocker encryption

All data-at-rest on your Azure Stack HCI cluster is protected with BitLocker XTS-AES 256-bit encryption. When you deploy your cluster, you have the option to modify security settings. By default, data-at-rest encryption is enabled on data volumes created during deployment. We recommend that you accept the default setting.

We recommend that you store BitLocker recovery keys in a secure location outside of the system. Once Azure Stack HCI is successfully deployed, you can retrieve BitLocker recovery keys.

For more information about BitLocker, see:

- [Use BitLocker with Cluster Shared Volumes (CSV)](../manage/bitlocker-on-csv.md).
- [Enable Bitlocker encryption on newly created volumes](#manage-bitlocker-encryption).
- [BitLocker encryption on Azure Stack HCI (preview)](./security-bitlocker.md).

## Windows Defender Application Control

Windows Defender Application Control (WDAC) is a software-based security layer that reduces attack surface by enforcing an explicit list of software that is allowed to run. WDAC is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see Windows Defender Application Control. For more infromation, see [Manage Windows Defender Application Control for Azure Stack HCI, version 23H2 (preview)](../manage/manage-wdac.md).

## Next steps

- [Assess deployment readiness via the Environment Checker](../manage/use-environment-checker.md).
- [Security baseline settings for Azure Stack HCI](./secure-baseline.md).
- [Windows Defender Application Control for Azure Stack HCI](./security-windows-defender-application-control.md).
- [Security baseline settings on Azure Stack HCI (preview)](/azure-stack/hci/concepts/secure-baseline).
