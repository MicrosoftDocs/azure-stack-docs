---
title: What's in Azure Stack HCI, Supplemental Package and preview channel
description: How to join the Azure Stack HCI preview channel and install feature updates by using Windows PowerShell or Windows Admin Center.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/03/2022
---

# What's in preview

> Applies to: Azure Stack HCI, Supplemental Package; Azure Stack HCI preview channel

This article describes the new features or enhancements that are currently available in the preview for Azure Stack HCI. This includes:

- [What's in the preview channel](#whats-in-the-azure-stack-hci-preview-channel).
- [What's in Azure Stack HCI, Supplemental Package](#whats-in-the-azure-stack-hci-supplemental-package).

## What's in the Azure Stack HCI preview channel

The Azure Stack HCI release preview channel currently features


For more information, see [Join the preview channel]().

## What's in the Azure Stack HCI, Supplemental Package

Azure Stack HCI, Supplemental Package is now in preview. This package deploys on servers running Azure Stack HCI, version 22H2 which is now generally available. The following features are available in the supplemental package:

- **New deployment tool** - In this release, you can perform new deployments using the Azure Stack HCI, Supplemental Package (preview). The new deployment tool can be launched on servers running Azure Stack HCI, version 22H2. You can deploy the supplemental package via a brand new deployment tool in one of the three ways - interactively, using an existing configuration file or via PowerShell.
    
    > [!IMPORTANT]
    > When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the supplemental package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.

    To learn more about the new deployment methods, see [Deployment overview](./deploy/deployment-tool-introduction.md). Download the Supplemental Package here:  

    | Azure Stack HCI Supplemental Package component| URL                                             |
    |-----------------------------------------------|-------------------------------------------------|
    | Boostrap PowerShell                           | https://go.microsoft.com/fwlink/?linkid=2210545 |
    | CloudDeployment.zip                           | https://go.microsoft.com/fwlink/?linkid=2210546 |
    | Verify Cloud Deployment PowerShell            | https://go.microsoft.com/fwlink/?linkid=2210608 |

- **New security capabilities** - The new installations with Azure Stack HCI, Supplemental Package release start with a *secure-by-default* strategy. The new version has a tailored security baseline coupled with a security drift control mechanism and a set of well-known security features enabled by default.

    To summarize, this release provides:
    
    - A tailored security baseline with over 200 security settings configured and enforced with a security drift control mechanism that ensures the cluster always starts and remains in a known good security state.
    
        The security baseline enables you to closely meet the Center for Internet Security (CIS) Benchmark, Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG), Common Criteria, and  Federal Information Processing Standards (FIPS) requirements for the OS and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-windows). 
    
        For more information, see [Security baseline settings for Azure Stack HCI](./concepts/secure-baseline.md).
    
    - Improved security posture achieved through a stronger set of protocols and cipher suites enabled by default.
    
    - Secured-Core Server that achieves higher protection by advancing a combination of hardware, firmware, and driver capabilities.
    
    - Out-of-box protection for data and network with SMB signing and BitLocker encryption for OS and Cluster Shared Volumes. For more information, see [BitLocker encryption for Azure Stack HCI](./concepts/security-bitlocker.md).
    
    - Reduced attack surface as Windows Defender Application Control is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Windows Defender Application Control for Azure Stack HCI](./concepts/security-windows-defender-application-control.md).

- **New Azure Stack HCI Environment Checker tool** - Before you deploy your Azure Stack HCI solution, you can now use a standalone, PowerShell tool to check your environment readiness. The Azure Stack HCI Environment Checker is a lightweight, easy-to-use tool that doesn't need an Azure subscription. This tool will let you validate your:

    - Internet connectivity.
    - Hardware.
    - Network infrastructure for valid IP ranges provided by customers for deployment.
    - Active Directory (an Active Directory prep tool is run prior to deployment).
    
    The Environment Checker tool runs tests on all the nodes of your Azure Stack HCI cluster, returns a Pass/Fail status for each test, and saves a log file and a detailed report file.
    
    To get started, you can [download this free tool here](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.2.5).

## Next steps

> [!div class="nextstepaction"]
> [Install a preview version of Azure Stack HCI](../manage/install-preview-version.md)

- For new Azure Stack HCI deployments:
    - Read the [Deployment overview](./deploy/deployment-tool-introduction.md).
    - Learn how to [Deploy interactively](./deploy/deployment-tool-new-file.md) using the Azure Stack HCI, Supplemental Package.

