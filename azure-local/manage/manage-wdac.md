---
title: Manage Application Control for Azure Local, version 23H2
description: This article describes how to use Application Control on Azure Local, version 23H2.
author:  alkohli
ms.author:  alkohli
ms.topic: how-to
ms.date: 02/03/2025
ms.service: azure-local
---

# Manage Application Control for Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to use Application Control to reduce the attack surface of Azure Local. For more information, see [Manage baseline security settings on Azure Local](../whats-new.md).

## Prerequisites

Before you begin, make sure that you have access to an Azure Local instance that is deployed, registered, and connected to Azure.

## View Application Control settings via Azure portal

To view the Application Control settings in the Azure portal, make sure that you have applied the MCSB initiative. For more information, see [Apply Microsoft Cloud Security Benchmark initiative](./manage-security-with-defender-for-cloud.md#apply-microsoft-cloud-security-benchmark-initiative).

You can use Application Control policies to manage which drivers and apps are allowed to run on your system. You can only view Application Control settings via Azure portal. To manage the settings, see [Manage Application Control settings with PowerShell](manage-wdac.md#manage-application-control-settings-with-powershell).

:::image type="content" source="media/manage-wdac/manage-wdac.png" alt-text="Screenshot that shows the Application Control page on Azure portal." lightbox="media/manage-wdac/manage-wdac.png":::

## Manage Application Control settings with PowerShell

### Enable Application Control policy modes

You can enable Application Control during or after deployment. Use PowerShell to enable or disable Application Control after deployment.

Connect to one of the machines and use the following cmdlets to enable the desired Application Control policy in "Audit" or "Enforced" mode.

In this build release there are two cmdlets:

- `Enable-AsWdacPolicy` - Affects all cluster nodes.
- `Enable-ASLocalWDACPolicy` - Affects only the node on which the cmdlet is run.

Depending on your use case, you should run a global cluster change or a local node change.

This is useful when:

- You started with default, recommended settings.
- You must install or run new third party software. You can switch your policy modes to create a supplemental policy.
- You started with Application Control disabled during deployment and now you want to enable Application Control to increase security protection or to validate that your software runs properly.
- Your software or scripts are blocked by Application Control. In this case you can use audit mode to understand and troubleshoot the issue.

> [!NOTE]
> When your application is blocked, Application Control creates a corresponding event. Review the Event log to understand details of the policy that's blocking your application. For more information, see the [Application Control operational guide](/windows/security/threat-protection/windows-defender-application-control/windows-defender-application-control-operational-guide).

### Switch Application Control policy modes

Follow these steps to switch between Application Control policy modes. These PowerShell commands interact with the Orchestrator to enable the selected modes.

[!INCLUDE [Switch WDAC policy mode](../includes/hci-switch-wdac-policy-mode.md)]

<!--- ## Support for OEM extensions --->

### Create an Application Control policy to enable third party software

While using Application Control in enforcement mode, for your non-Microsoft signed software to run, build on the Microsoft-provided base policy by creating an Application Control supplemental policy. Additional information can be found in the [public Application Control documentation](/windows/security/threat-protection/windows-defender-application-control/deploy-multiple-windows-defender-application-control-policies#supplemental-policy-creation).

> [!NOTE]
> To run or install new software, you might need to switch Application Control to audit mode first (see steps above), install your software, test that it works correctly, create the new supplemental policy, and then switch Application Control back to enforced mode.

Create a new policy in the Multiple Policy Format as shown below. Then use ```Add-ASWDACSupplementalPolicy -Path Policy.xml``` to convert it to a supplemental policy and deploy it across nodes in the cluster.

#### Create an Application Control supplemental policy

Use the following steps to create a supplemental policy:

1. Before you begin, install the software that will be covered by the supplemental policy into its own directory. It's okay if there are subdirectories. When creating the supplemental policy, you must provide a directory to scan, and you don't want your supplemental policy to cover all code on the system. In our example, this directory is C:\software\codetoscan.

1. Once you have all your software in place, run the following command to create your supplemental policy. Use a unique policy name to help identify it.

   ```powershell
   New-CIPolicy -MultiplePolicyFormat -Level Publisher -FilePath c:\wdac\Contoso-policy.xml -UserPEs -Fallback Hash -ScanPath c:\software\codetoscan
   ```

1. Run the following cmdlet to modify the metadata of your supplemental policy:

   ```powershell

    # Path of new created XML)
    $policyPath = "c:\wdac\Contoso-policy.xml"

   # Set Policy Version (VersionEx in the XML file)
    $policyVersion = "1.0.0.1"
    Set-CIPolicyVersion -FilePath $policyPath -Version $policyVersion

    # Set Policy Info (PolicyName, PolicyID in the XML file)
    Set-CIPolicyIdInfo -FilePath $policyPath -PolicyID "Contoso-Policy_$policyVersion" -PolicyName "Contoso-Policy"
   ```

1. Run the following cmdlet to deploy the policy:

   ```powershell
   Add-ASWDACSupplementalPolicy -Path c:\wdac\Contoso-policy.xml
   ```

1. Run the following cmdlet to check the status of the new policy:

   ```powershell
   Get-ASLocalWDACPolicyInfo
   ```

   Here's a sample output of these cmdlets:

   ```powershell
   C:\> Get-ASLocalWDACPolicyInfo

   NodeName          : Node01
   PolicyMode        : Enforced
   PolicyGuid        : {A6368F66-E2C9-4AA2-AB79-8743F6597683}
   PolicyName        : AS_Base_Policy
   PolicyVersion     : AS_Base_Policy_1.1.4.0
   PolicyScope       : Kernel & User
   MicrosoftProvided : True
   LastTimeApplied   : 10/26/2023 11:14:24 AM
    
   NodeName          : Node01
   PolicyMode        : Enforced
   PolicyGuid        : {2112036A-74E9-47DC-A016-F126297A3427}
   PolicyName        : Contoso-Policy
   PolicyVersion     : Contoso-Policy_1.0.0.1
   PolicyScope       : Kernel & User
   MicrosoftProvided : False
   LastTimeApplied   : 10/26/2023 11:14:24 AM
   ```

## Next steps

- [Complete the prerequisites and deployment checklist and install Azure Local](../deploy/deployment-prerequisites.md).
