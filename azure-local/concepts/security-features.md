---
title: Security features for Azure Local, version 23H2.
description: Learn about security features available for new deployments of Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: article
ms.service: azure-local
ms.date: 03/24/2025
---

# Security features for Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

Azure Local is a secure-by-default product that has more than 300 security settings enabled right from the start. Default security settings provide a consistent security baseline to ensure that devices start in a known good state.

This article provides a brief conceptual overview of the various security features associated with your Azure Local instance. Features include security defaults, Application Control, volume encryption via BitLocker, secret rotation, local built-in user accounts, Microsoft Defender for Cloud, and more.

## Security defaults

Your Azure Local has security settings enabled by default that provide a consistent security baseline, a baseline management system, and a drift control mechanism.

You can monitor the security baseline and secured-core settings during both deployment and runtime. You can also disable drift control during deployment when you configure security settings.

With drift control applied, security settings are refreshed every 90 minutes. This refresh interval ensures remediation of any changes from the desired state. Continuous monitoring and autoremediation enable a consistent and reliable security posture throughout the lifecycle of the device.

Secure baseline on Azure Local:

- Improves the security posture by disabling legacy protocols and ciphers.
- Reduces OPEX with a built-in drift protection mechanism that enables consistent at-scale monitoring via the Azure Arc Hybrid Edge baseline.
- Enables you to meet Center for Internet Security (CIS) benchmark and Defense Information System Agency (DISA) Security Technical Implementation Guide (STIG) requirements for the OS and recommended security baseline.

For more information, see [Manage security defaults on Azure Local](../manage/manage-secure-baseline.md).

## Application Control

Application Control is a software-based security layer that reduces attack surface by enforcing an explicit list of software that is allowed to run. Application Control is enabled by default and limits the applications and code that you can run on the core platform. For more information, see [Manage Application Control for Azure Local](../manage/manage-wdac.md#manage-application-control-settings-with-powershell).

Application Control provides two main operation modes, Enforcement mode and Audit mode. In Enforcement mode, untrusted code is blocked and events are recorded. In Audit mode, untrusted code is allowed to run and events are recorded. To learn more about Application Control-related events, see [List of Events](/windows/security/application-security/application-control/windows-defender-application-control/operations/event-id-explanations).

> [!IMPORTANT]
> To minimize security risk, always run Application Control in Enforcement mode.

### About Application Control policy design

Microsoft provides base signed policies on Azure Local for both Enforcement mode and Audit mode. Additionally, policies include a predefined set of platform behavior rules and block rules to apply to the application control layer.

#### Composition of base policies

Azure Local base policies include the following sections:

- **Metadata**: The metadata defines unique properties of the policy such as the policy name, version, GUID, and more.
- **Option Rules**: These rules define policy behavior. Supplemental policies can only differ from a small set of the option rules tied to their base policy.
- **Allow and Deny Rules**: These rules define code trust boundaries. Rules can be based on Publishers, Signers, File Hash, and more.

#### Option rules

This section discussed the option rules enabled by the base policy.

For the enforced policy, the following option rules are enabled by default:

|Option rule|Value|
|-----|-----|
|Enabled|UMCI|
|Required|WHQL|
|Enabled|Allow Supplemental Policies|
|Enabled|Revoked Expired As Unsigned|
|Disabled|Flight Signing|
|Enabled|Unsigned System Integrity Policy (Default)|
|Enabled|Dynamic Code Security|
|Enabled|Advanced Boot Options Menu|
|Disabled|Script Enforcement|
|Enabled|Managed Installer|
|Enabled|Update Policy No Reboot|

Audit policy adds the following option rules to the base policy:

|Option rule|Value|
|-----|-----|
|Enabled|Audit Mode (Default)|

For more information, see the full [List of option rules](/windows/security/application-security/application-control/windows-defender-application-control/design/select-types-of-rules-to-create#table-1-windows-defender-application-control-policy---policy-rule-options).

#### Allow and Deny rules

Allow rules in the base policy allow all Microsoft components delivered by the OS and the cloud deployments to be trusted. Deny rules block user mode applications and kernel components considered unsafe for the security posture of the solution.

> [!NOTE]
> The Allow and Deny rules in the base policy are updated regularly to improve product functionality and maximize protection of your solution.

To learn more about Deny rules, see:

- [Driver blocklist](/windows/security/application-security/application-control/windows-defender-application-control/design/microsoft-recommended-driver-block-rules).

- [User Mode blocklist](/windows/security/application-security/application-control/windows-defender-application-control/design/applications-that-can-bypass-wdac).

## BitLocker encryption

Data-at-rest encryption is enabled on data volumes created during deployment. These data volumes include both infrastructure volumes and workload volumes. When you deploy your system, you can modify security settings.

By default, data-at-rest encryption is enabled during deployment. We recommend that you accept the default setting.

Once Azure Local is successfully deployed, you can retrieve BitLocker recovery keys. You must store BitLocker recovery keys in a secure location outside of the system.

For more information about BitLocker encryption, see:

- [Use BitLocker with Cluster Shared Volumes (CSV)](../manage/bitlocker-on-csv.md).
- [Manage BitLocker encryption on Azure Local](../manage/manage-bitlocker.md).

## Local built-in user accounts

In this release, the following local built-in users associated with `RID 500` and `RID 501` are available on your Azure Local system:

|Name in initial OS image |Name after deployment |Enabled by default |Description |
|-----|-----|-----|-----|
|Administrator |ASBuiltInAdmin |True |Built-in account for administering the computer/domain. |
|Guest |ASBuiltInGuest |False |Built-in account for guest access to the computer/domain, protected by the security baseline drift control mechanism. |

> [!IMPORTANT]
> We recommend that you create your own local administrator account, and that you disable the well-known `RID 500` user account.

## Secret creation and rotation

The orchestrator in Azure Local requires multiple components to maintain secure communications with other infrastructure resources and services. All services running on the system have authentication and encryption certificates associated with them.

To ensure security, we implement internal secret creation and rotation capabilities. When you review your system nodes, you see several certificates created under the path LocalMachine/Personal certificate store (`Cert:\LocalMachine\My`).

In this release, the following capabilities are enabled:

- The ability to create certificates during deployment and after system scale operations.
- Automated autorotation before certificates expire, and an option to rotate certificates during the lifetime of the system.
- The ability to monitor and alert whether certificates are still valid.

> [!NOTE]
> Secret creation and rotation operations take about 10 minutes to complete, depending on the size of the system.

For more information, see [Manage secrets rotation](../manage/manage-secrets-rotation.md).

## Syslog forwarding of security events

For customers and organizations that require their own local security information and event management (SIEM) system, Azure Local includes an integrated mechanism that enables you to forward security-related events to a SIEM.

Azure Local has an integrated syslog forwarder that, once configured, generates syslog messages defined in RFC3164, with the payload in Common Event Format (CEF).

The following diagram illustrates integration of Azure Local with an SIEM. All audits, security logs, and alerts are collected on each host and exposed via syslog with the CEF payload.

:::image type="content" source="media/security-features/integration-of-azure-stack-hci-with-external-siem.png" alt-text="The following diagram describes the integration of Azure Local with an external security information and event management (SIEM) system." lightbox="media/security-features/integration-of-azure-stack-hci-with-external-siem.png":::

Syslog forwarding agents are deployed on every Azure Local host to forward syslog messages to the customer-configured syslog server. Syslog forwarding agents work independently from each other but can be managed together on any one of the hosts.

The syslog forwarder in Azure Local supports various configurations based on whether syslog forwarding is with TCP or UDP, whether the encryption is enabled or not, and whether there's unidirectional or bidirectional authentication.

For more information, see [Manage syslog forwarding](../manage/manage-syslog-forwarding.md).

## Microsoft Defender Antivirus

Azure Local comes with Microsoft Defender Antivirus enabled and configured by default. We strongly recommend that you use Microsoft Defender Antivirus with your Azure Local instances. Microsoft Defender Antivirus provides real-time protection, cloud-delivered protection, and automatic sample submission.

Although we recommend using Microsoft Defender Antivirus for Azure Local, if you prefer non-Microsoft antivirus and security software, **we advise selecting one that your Independent Software Vendor (ISV) has validated for Azure Local** to minimize potential functionality issues.

For more information, see:

- [Microsoft Defender Antivirus compatibility with other security products](/defender-endpoint/microsoft-defender-antivirus-compatibility).
- [Microsoft Defender Antivirus and non-Microsoft antivirus solutions without Defender for Endpoint](/defender-endpoint/defender-antivirus-compatibility-without-mde).

In the rare instance that you experience any functionality issues with Azure Local using non-Microsoft antivirus software, you can exclude the following paths:

- C:\Agents\\*
- C:\CloudContent\\*
- C:\CloudDeployment\\*
- C:\ClusterStorage\\*
- C:\EceStore\\*
- C:\MASLogs\\*
- C:\NugetStore\\*
- C:\deploymentpackage\\*
- C:\ProgramData\GuestConfig\extension_logs\\*

> [!NOTE]
> If you remove the Microsoft Defender Antivirus feature, leave the settings associated with the feature from the security baseline as-is. You don't need to remove these settings.

## Microsoft Defender for Cloud (preview)

Microsoft Defender for Cloud is a security posture management solution with advanced threat protection capabilities. It provides you with tools to assess the security status of your infrastructure, protect workloads, raise security alerts, and follow specific recommendations to remediate attacks and address future threats. It performs all these services at high speed in the cloud through autoprovisioning and protection with Azure services, with no deployment overhead.

With the basic Defender for Cloud plan, you get recommendations on how to improve the security posture of your Azure Local system at no extra cost. With the paid Defender for Servers plan, you get enhanced security features including security alerts for individual machines and Arc VMs.

For more information, see:

- [Manage system security with Microsoft Defender for Cloud (preview)](../manage/manage-security-with-defender-for-cloud.md).

## Next steps

- [Assess deployment readiness via the Environment Checker](../manage/use-environment-checker.md).
- [Read the Azure Local security book](https://github.com/Azure-Samples/AzureLocal/blob/main/SecurityBook/Azure%20Local%20Security%20Book_01172025.pdf).
- [View the Azure Local security standards](/azure-stack/hci/assurance/azure-stack-security-standards).
