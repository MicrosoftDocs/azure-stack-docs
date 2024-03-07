---
title: Security features for Azure Stack HCI, version 23H2.
description: Learn about security features available for new deployments of Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/22/2024
---

# Security features for Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

Azure Stack HCI is a secure-by-default product that has more than 300 security settings enabled right from the start. Default security settings provide a consistent security baseline to ensure that devices start in a known good state.

This article provides a brief conceptual overview of the various security features associated with your Azure Stack HCI cluster. This includes security defaults, Windows Defender for Application Control (WDAC), volume encryption via BitLocker, secret rotation, local built-in user accounts, Microsoft Defender for Cloud, and more.

## Windows Defender Application Control

Application control (WDAC) is a software-based security layer that reduces attack surface by enforcing an explicit list of software that is allowed to run. WDAC is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Manage Windows Defender Application Control for Azure Stack HCI, version 23H2](../manage/manage-wdac.md).

## Security defaults

Your Azure Stack HCI has more than 300 security settings enabled by default that provide a consistent security baseline, a baseline management system, and an associated drift control mechanism.

You can monitor the security baseline and secured-core settings during both deployment and runtime. You can also disable drift control during deployment when you configure security settings.

With drift control applied, security settings are refreshed every 90 minutes. This refresh interval ensures remediation of any changes from the desired state. Continuous monitoring and auto-remediation allow you to have a consistent and reliable security posture throughout the lifecycle of the device.

Secure baseline on Azure Stack HCI:

- Improves the security posture by disabling legacy protocols and ciphers.
- Reduces OPEX with a built-in drift protection mechanism and enables consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- Enables you to closely meet Center for Internet Security (CIS) benchmark and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the OS and recommended security baseline.

For more information, see [Manage security defaults on Azure Stack HCI](../manage/manage-secure-baseline.md).

## BitLocker encryption

Data-at-rest encryption is enabled on data volumes created during deployment. These data volumes include both infrastructure volumes and workload volumes. When you deploy your cluster, you have the option to modify security settings.

By default, data-at-rest encryption is enabled during deployment. We recommend that you accept the default setting.

You must store BitLocker recovery keys in a secure location outside of the system. Once Azure Stack HCI is successfully deployed, you can retrieve BitLocker recovery keys.

For more information about BitLocker encryption, see:

- [Use BitLocker with Cluster Shared Volumes (CSV)](../manage/bitlocker-on-csv.md).
- [Manage BitLocker encryption on Azure Stack HCI](../manage/manage-bitlocker.md).

## Local built-in user accounts

In this release, the following local built-in users, associated with `RID 500` and `RID 501`, are available on your Azure Stack HCI system:

|Name in initial OS image |Name after deployment |Enabled by default |Description |
|-----|-----|-----|-----|
|Administrator |ASBuiltInAdmin |True |Built-in account for administering the computer/domain |
|Guest |ASBuiltInGuest |False |Built-in account for guest access to the computer/domain, protected by the security baseline drift control mechanism. |

> [!IMPORTANT]
> We recommend that you create your own local administrator account, and that you disable the well-known `RID 500` user account.

## Secret creation and rotation

The orchestrator in Azure Stack HCI requires multiple components to maintain secure communications with other infrastructure resources and services. All the services running on the cluster have authentication and encryption certificates associated with them.

To ensure security, we have implemented internal secret creation and rotation capabilities. When you review your cluster nodes, you see several certificates created under the path LocalMachine/Personal certificate store (`Cert:\LocalMachine\My`).

In this release, the following capabilities are enabled:

- The ability to create certificates during deployment and after cluster scale operations.
- Automated auto-rotation mechanism before certificates expire, and an option to rotate certificates during the lifetime of the cluster.
- The ability to monitor and alert whether certificates are still valid.

> [!NOTE]
> This action takes about ten minutes, depending on the size of the cluster.

For more information, see [Manage secrets rotation](../manage/manage-secrets-rotation.md).

## Syslog forwarding of security events

For customers and organizations that require their own local SIEM, Azure Stack HCI version 23H2 includes an integrated mechanism that enables you to forward security-related events to a SIEM.

Azure Stack HCI has an integrated syslog forwarder that, once configured, generates syslog messages defined in RFC3164, with the payload in Common Event Format (CEF).

The following diagram illustrates integration of Azure Stack HCI with an SIEM. All audits, security logs, and alerts are collected on each host and exposed via syslog with the CEF payload.

:::image type="content" source="media/security-features/integration-of-azure-stack-hci-with-external-siem.png" alt-text="The following diagram describes the integration of Azure Stack HCI with an external security information and event management (SIEM) system." lightbox="media/security-features/integration-of-azure-stack-hci-with-external-siem.png":::

Syslog forwarding agents are deployed on every Azure Stack HCI host to forward syslog messages to the customer-configured syslog server. Syslog forwarding agents work independently from each other but can be managed together on any one of the hosts.

The syslog forwarder in Azure Stack HCI supports various configurations based on whether syslog forwarding is with TCP or UDP, whether the encryption is enabled or not, and whether there is unidirectional or bidirectional authentication.

For more information, see [Manage syslog forwarding](../manage/manage-syslog-forwarding.md).

## Microsoft Defender for Cloud (preview)

Microsoft Defender for Cloud is a security posture management solution with advanced threat protection capabilities. It provides you with tools to assess the security status of your infrastructure, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. It performs all these services at high speed in the cloud with no deployment overhead through auto-provisioning and protection with Azure services.

With the basic Defender for Cloud plan, you get recommendations on how to improve the security posture of your Azure Stack HCI system at no extra cost. With the paid Defender for Servers plan, you get enhanced security features including security alerts for individual servers and Arc VMs.

For more information, see [Manage system security with Microsoft Defender for Cloud (preview)](../manage/manage-security-with-defender-for-cloud.md).

## Next steps

- [Assess deployment readiness via the Environment Checker](../manage/use-environment-checker.md).
- [Read the Azure Stack HCI security book](https://assetsprod.microsoft.com/mpn/azure-stack-hci-security-book.pdf).
- [View the Azure Stack HCI security standards](/azure-stack/hci/assurance/azure-stack-security-standards).
