---
title: Join the Azure Stack HCI preview channel
description: How to join the Azure Stack HCI preview channel and install feature updates by using Windows PowerShell or Windows Admin Center.
author: jasongerend
ms.author: jgerend
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/08/2022
---

# Join the Azure Stack HCI preview channel

> Applies to: Azure Stack HCI preview channel

The Azure Stack HCI release preview channel is an opt-in program that lets customers install the next version of the operating system before it's officially released. This program is intended for customers who want to evaluate new features, system architects who want to build a solution before conducting a broader deployment, or anyone who wants to see what's next for Azure Stack HCI. There are no program requirements or commitments. Preview builds are available via Windows Update using Windows Admin Center or PowerShell.

   > [!WARNING]
   > Azure Stack HCI clusters that are managed by Microsoft System Center shouldn't join the preview channel. System Center (including Virtual Machine Manager, Operations Manager, and other components) supports the latest generally available version of Azure Stack HCI, but might not be tested or supported with preview channel builds. See the [System Center blog](https://techcommunity.microsoft.com/t5/system-center-blog/bg-p/SystemCenterBlog) for the latest updates.

   > [!WARNING]
   > Don't use preview builds in production. Preview builds contain experimental pre-release software made available for evaluating and testing only. You might experience crashes, security vulnerabilities, or data loss. Be sure to back up any important virtual machines (VMs) before upgrading your cluster. Once you install a build from the preview channel, the only way to go back is a clean install.

## How to join the preview channel

Before joining the preview channel, make sure that all servers in the cluster are online, and that the cluster is [registered with Azure](../deploy/register-with-azure.md).

   > [!IMPORTANT]
   > You can't skip versions. For example, if you're running Azure Stack HCI, version 21H2, you must update to Azure Stack HCI, version 22H2 before installing a newer preview version.

1. Make sure you have the latest version of Windows Admin Center installed on a management PC or server.

2. Connect to the Azure Stack HCI cluster on which you want to install feature updates and select **Settings** from the bottom-left corner of the screen. Select **Join the preview channel**, then **Get started**.

   :::image type="content" source="media/preview-channel/join-preview-channel.png" alt-text="Select join the preview channel, then Get started" lightbox="media/preview-channel/join-preview-channel.png":::

3. You'll be reminded that preview builds are provided as-is and aren't eligible for production-level support. Select the **I understand** checkbox, then click **Join the preview channel**.

4. You should see a confirmation that you've successfully joined the preview channel and that the cluster is now ready to flight preview builds.

   :::image type="content" source="media/preview-channel/joined-preview-channel.png" alt-text="Your cluster is now ready to flight preview builds" lightbox="media/preview-channel/joined-preview-channel.png":::

   > [!NOTE]
   > If any of the servers in the cluster say **Not configured** for preview builds, try repeating the process.

Once you've joined the preview channel, you're ready to install Azure Stack HCI using either Windows Admin Center or PowerShell.

## What's new in the preview channel

Azure Stack HCI, Supplemental Package is now in preview. This package deploys on servers running Azure Stack HCI, version 22H2 which is now generally available. The following features are available in the Supplemental Package:

- **New deployment tool** - In this release, you can perform new deployments using the Azure Stack HCI, Supplemental Package (preview). The new deployment tool can be launched on servers running Azure Stack HCI, version 22H2. You can deploy the supplemental package via a brand new deployment tool in one of the three ways - interactively, using an existing configuration file or via PowerShell.
    
    When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the supplemental package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.

    To learn more about the new deployment methods, see [Deployment overview](./deploy/deployment-tool-introduction.md). Download the Supplemental Package here:  

    | Azure Stack HCI Supplemental Package component| URL                                             |
    |-----------------------------------------------|-------------------------------------------------|
    | Boostrap PowerShell                           | https://go.microsoft.com/fwlink/?linkid=2210545 |
    | CloudDeployment.zip                           | https://go.microsoft.com/fwlink/?linkid=2210546 |
    | Verify Cloud Deployment PowerShell            | https://go.microsoft.com/fwlink/?linkid=2210608 |

- **Security settings** - The new installations with Azure Stack HCI, Supplemental Package release start with a *secure-by-default* strategy. The new version has a tailored security baseline coupled with a security drift control mechanism and a set of well-known security features enabled by default.

    To summarize, this release provides:
    
    - A tailored security baseline with over 200 security settings configured and enforced with a security drift control mechanism that ensures the cluster always starts and remains in a known good security state.
    
        The security baseline enables you to closely meet the Center for Internet Security (CIS) Benchmark, Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG), Common Criteria, and  Federal Information Processing Standards (FIPS) requirements for the OS and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-windows). 
    
        For more information, see [Security baseline settings for Azure Stack HCI](./concepts/secure-baseline.md).
    
    - Improved security posture achieved through a stronger set of protocols and cipher suites enabled by default.
    
    - Secured-Core Server that achieves higher protection by advancing a combination of hardware, firmware, and driver capabilities.
    
    - Out-of-box protection for data and network with SMB signing and BitLocker encryption for OS and Cluster Shared Volumes. For more information, see [BitLocker encryption for Azure Stack HCI](./concepts/security-bitlocker.md).
    
    - Reduced attack surface as Windows Defender Application Control is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Windows Defender Application Control for Azure Stack HCI](./concepts/security-windows-defender-application-control.md).

- **Environment checker tool** - Before you deploy your Azure Stack HCI solution, you can now use a standalone, PowerShell tool to check your environment readiness. The Azure Stack HCI Environment Checker is a lightweight, easy-to-use tool that doesn't need an Azure subscription. This tool will let you validate your:

    - Internet connectivity.
    - Hardware.
    - Network infrastructure for valid IP ranges provided by customers for deployment.
    - Active Directory (an Active Directory prep tool is run prior to deployment).
    
    The Environment Checker tool runs tests on all the nodes of your Azure Stack HCI cluster, returns a Pass/Fail status for each test, and saves a log file and a detailed report file.
    
    To get started, you can [download this free tool here](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker/0.2.5). 

## Next steps

> [!div class="nextstepaction"]
> [Install a preview version of Azure Stack HCI](../manage/install-preview-version.md)
