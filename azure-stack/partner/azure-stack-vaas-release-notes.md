---
title: Validation as a service release notes
titleSuffix: Azure Stack Hub
description: Release notes for Azure Stack Hub validation as a service.
author: mattbriggs
ms.topic: article
ms.date: 10/28/2019
ms.author: mabrigg
ms.reviewer: johnhas
ms.lastreviewed: 10/28/2019
---

# Validation as a service release notes

[!INCLUDE [Azure_Stack_Partner](./includes/azure-stack-partner-appliesto.md)]

This article has the release notes for Azure Stack Hub validation as a service.

## Version 4.4.2.1

2020 January 9

- Test content updates:
  - OEM Validation Workflow (Version 5.1.52.0 -> 5.1.53.0): Reduced the number of required parameters from the test schedule pane.
  - Bugfix for Compute test - TestVMOperations

- Known issues:
  - Contact vaashelp@microsoft.com if the following test cases fail to run during OEM Validation Workflow:
    - Test101LinuxEmptyAttachedDiskManagedDisk
    - Test101WindowsEmptyAttachedDiskManagedDisk

2019 December 3

- Test content updates:
  - Online documentation for the Monthly Azure Stack Hub Update workflow and the OEM Package Validation workflow have been updated. Please review the updated documentation here​ Validate OEM packages and here Validate software updates from Microsoft
  - VaaS Package Validation workflow update: OEM Validation Workflow is the only test required for monthly Azure Stack Hub update verification and OEM package validation. The test updates the stamp with the provided AzureStack/OEM packages and runs Cloud Simulation Engine verification tests.
  - VaaS PowerShell Extension update: Package Validation workflow automation is now supported. Please see Azure Stack Hub VaaS Automate with Powershell for detailed information about the location and step-by-step instructions to use this extension.

- Known issues:
  - Contact vaashelp@microsoft.com if the following test cases fail to run during OEM Validation Workflow:
    - Test101LinuxEmptyAttachedDiskManagedDisk
    - Test101WindowsEmptyAttachedDiskManagedDisk


## Version 4.3.5.3

2019 November 7

- Test content updates:
  - Monthly Azure Stack Hub Update Verification (Version 5.1.46.0 -> 5.1.49.0).
  - OEM Extension Package Verification (Version 5.1.46.0 -> 5.1.49.0).
  - Results for 5.1.46.0 have been retained. If you had a successful runs on 5.1.46.0, notify vaashelp@microsoft.com when submitting results.

- Bug fixes
  - Fixed an issue where Monthly Azure Stack Hub Update Verification failed to run if the update .zip contained special characters.

- Known issues
  - VaaS tests fail if mstest.exe isn't found. Workaround:
    1. CTRL+C the agent in the PowerShell window.
    1. Type mstest.exe to verify that mstest.exe is a recognized program.
    1. If mstest.exe isn't recognized, close the current PowerShell window.
    1. Click Start (not PowerShell on your taskbar), find PowerShell, and open as an administrator.
    1. Type mstest.exe and verify it's available as a command.
    1. Restart the agent and rerun the test.
  - Occasionally, Cloud Simulation Engine will report failures with \*vm tests. Contact vaashelp@microsoft.com before attempting a re-run.


2019 October 29

- Online documentation for the Monthly Azure Stack Hub Update workflow and the OEM Package Validation workflow have been updated.

    Please review the updated documentation here Validate OEM packages and here Validate software updates from Microsoft.
- VaaS Workflow Update: Monthly Azure Stack Hub Update  (Version 5.1.30.0 -> 5.1.46.0)  – the monthly Azure Stack Hub update verification test workflow has been updated.

    The workflow no longer requires manual intervention and can be scheduled to run seamlessly.
- VaaS Workflow Update: OEM Package Validation  (Version 5.1.30.0 -> 5.1.46.0)  –  OEM Package validation workflow has been updated.

    The workflow no longer requires manual intervention and can be scheduled to run seamlessly.
- Cloud Simulation Engine in the OEM Package Validation workflow (Version 5.1.30.0 -> 5.1.46.0) has been updated to expedite validation time: Run time reduced to 1 hour.
- Cloud Simulation Engine in the OEM Package Validation workflow and the Azure Stack Hub Update workflow  (Version 5.1.30.0 -> 5.1.46.0) require that the updates to be validated be in two distinct parent folders with no other updates in child folders.
- Cloud Simulation Engine in the OEM Package Validation workflow and the Azure Stack Hub Update workflow  (Version 5.1.30.0 -> 5.1.46.0) require that the tests be scheduled in the following order – Monthly Azure Stack Hub Update Verification test, OEM Extension Package Verification test, and finally Cloud Simulation Engine.
- VaaS Agent Update: The updated VaaS Agent now uses the Azure Stack Hub Cloud Admin credentials to query the stamp to get the stamp information in order to autopopulate the workflows.

    This update requires all of the agents to be updated and restarted. Please see these instructions on how to update the VaaS Agent: https://docs.microsoft.com/azure-stack/partner/azure-stack-vaas-local-agent
- VaaS Portal UI Update: The agent selection table has been moved above the test scheduling pane to facilitate testing.

    When scheduling a job, it's no longer requires to enter stamp information if the VaaS agents have been correctly updated.

## Version 4.0.5

2019 June 7

- Cloud Simulation Engine in the Package Validation workflow has been updated to expedite validation time:  
    Run time: Reduced to 6 hours  
    Version: 5.1.13.0 -> 5.1.22.0  


2019 January 17

- Disk Identification Test updated to address storage pool inconsistencies. Version: 5.1.14.0 -> 5.1.15.0
- Azure Stack Hub Monthly Update Verification updated to address approved software and content validation inconsistencies. Version: 5.1.14.0 -> 5.1.17.0
- OEM Extension Package Verification updated to perform necessary checks before the Azure Stack Hub update step. Version: 5.1.14.0 -> 5.1.16.0
- Internal bug fixes.

## Version 4.0.2

2019 January 7

If you're running the Azure Stack Hub Monthly Update Verification workflow and the version for your OEM update package isn't 1810 or higher, you'll receive an error once you get to the OEM update step. This is a bug. A fix is being developed. The mitigation steps are as follows:

1. Run the OEM update as normal.
2. Execute Test-AzureStack after successful application of the package and save the output.
3. Cancel the test.
4. Send the saved output to VaaSHelp@microsoft.com to receive passing results for the run.

## Version 4.0.2

2018 November 30

- Internal bug fixes.

## Version 4.0.1

2018 October 8

- VaaS prerequisites:

    `Install-VaaSPrerequisites` no longer requires cloud admin credentials. If you're running the latest version of this cmdlet, see [Download and install the local agent](azure-stack-vaas-local-agent.md#download-and-install-the-local-agent) for the revised commands for installing prerequisites. Here are the commands:

    ```powershell
    $ServiceAdminCreds = New-Object System.Management.Automation.PSCredential "<aadServiceAdminUser>", (ConvertTo-SecureString "<aadServiceAdminPassword>" -AsPlainText -Force)
    Import-Module .\VaaSPreReqs.psm1 -Force
    Install-VaaSPrerequisites -AadTenantId $AadTenantId `
                              -ServiceAdminCreds $ServiceAdminCreds `
                              -ArmEndpoint https://adminmanagement.$ExternalFqdn `
                              -Region $Region
    ```

## Version 4.0.0

2018 August 29

- VaaS prerequisites and VHD updates:

    `Install-VaaSPrerequisites` now requires cloud admin credentials to address an issue during Package Validation. The documentation at [Download and install the local agent](azure-stack-vaas-local-agent.md#download-and-install-the-local-agent) has been updated with the following:

    ```powershell
    $ServiceAdminCreds = New-Object System.Management.Automation.PSCredential "<aadServiceAdminUser>", (ConvertTo-SecureString "<aadServiceAdminPassword>" -AsPlainText -Force)
    $CloudAdminCreds = New-Object System.Management.Automation.PSCredential "<cloudAdminDomain\username>", (ConvertTo-SecureString "<cloudAdminPassword>" -AsPlainText -Force)
    Import-Module .\VaaSPreReqs.psm1 -Force
    Install-VaaSPrerequisites -AadTenantId $AadTenantId `
                              -ServiceAdminCreds $ServiceAdminCreds `
                              -ArmEndpoint https://adminmanagement.$ExternalFqdn `
                              -Region $Region `
                              -CloudAdminCredentials $CloudAdminCreds
    ```
    > [!NOTE]
    > The `$CloudAdminCreds` required by the script are for the Azure Stack Hub instance being validated. They're not the Azure Active Directory credentials used by the VaaS tenant.

- Local agent update:

    The previous version of the local agent isn't compatible with the current 4.0.0 release of the service. All users must update their local agents. See [Download and install the local agent](azure-stack-vaas-local-agent.md#download-and-install-the-local-agent) for instructions on installing the newest agent.

- PowerShell automation update:

    Changes were made to `LaunchVaaSTests` PowerShell scripts that require the latest version of the scripting packages. See [Launch the Test Pass workflow](azure-stack-vaas-automate-with-powershell.md) for instructions on installing the latest version of the scripting package.

- Validation as a service portal:

  - Package signing notifications

    When an OEM customization package is submitted as part of the Package Validation workflow, the package format will be validated to ensure that it follows the published specification. If the package doesn't comply, the run will fail. Email notifications will be sent to the email address of the registered Azure Active Directory contact for the tenant.

  - Interactive test category:

    The **Interactive** test category has been added. These tests exercise interactive, non-automated Azure Stack Hub scenarios.

  - Interactive Feature Verification:

    The ability to provide focused feedback for certain features is now available in the Test Pass workflow. The `OEM Update on Azure Stack Hub 1806 RC Validation 5.1.4.0` test checks to see if specific updates were correctly applied and then collects feedback.

## Next steps

- [Troubleshoot Validation as a Service](azure-stack-vaas-troubleshoot.md)
