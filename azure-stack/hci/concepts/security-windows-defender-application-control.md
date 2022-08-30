---
title: Windows Defender Application Control for Azure Stack HCI (preview)
description: This topic provides guidance on Windows Defender Application Control for Azure Stack HCI (preview).
author:  alkohli
ms.author:  alkohli
ms.topic: conceptual
ms.date: 08/30/2022
---
<!-- To do:
 -- call out CIP before using acro -->

# Windows Defender Application Control for Azure Stack HCI (preview)

Applies to: Azure Stack HCI, version 22H2 (preview)

This article describes how to use Windows Defender Application Control (WDAC) to reduce the attack surface of Azure Stack HCI, version 22H2.

WDAC is a software-based security layer that reduces attack surface by enforcing an explicit list of software that is allowed to run. WDAC is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Windows Defender Application Control](/windows/security/threat-protection/windows-defender-application-control/wdac-and-applocker-overview#windows-defender-application-control).

## WDAC is enabled by default

This release comes with WDAC enabled and enforced by default. We're providing a base policy in a multiple-policy format CIP file.

Base policy details are as follows:

> * PolicyGuid    : {A6368F66-E2C9-4AA2-AB79-8743F6597683}
> * PolicyName    : MS_Base_Policy
> * PolicyVersion : MS_Base_Policy_1.0.0.0
> * PolicyScope   : Kernel & User

The base policy identifier is always the same across deployments. Customers and partners can build supplemental policies based on the base policy. The base policy is combined with the recommended block rules for drivers and applications documented here:

 > * [Microsoft recommended driver block rules](/windows/security/threat-protection/windows-defender-application-control/microsoft-recommended-driver-block-rules)
> * [Microsoft recommended block rules](/windows/security/threat-protection/windows-defender-application-control/microsoft-recommended-block-rules)

Here's the Microsoft base policy prior to merging with blocked rules:

```xml
<?xml version="1.0" encoding="utf-8"?>
<SiPolicy xmlns="urn:schemas-microsoft-com:sipolicy" PolicyType="Base Policy">
  <VersionEx>1.0.0.0</VersionEx>
  <BasePolicyID>{A6368F66-E2C9-4AA2-AB79-8743F6597683}</BasePolicyID>
  <PolicyID>{A6368F66-E2C9-4AA2-AB79-8743F6597683}</PolicyID>
  <PlatformID>{2E07F7E4-194C-4D20-B7C9-6F44A6C5A234}</PlatformID>
  <Rules  >
    <Rule>
      <Option>Enabled:Unsigned System Integrity Policy</Option>
    </Rule>
    <Rule>
      <Option>Enabled:UMCI</Option>
    </Rule>
    <Rule>
      <Option>Enabled:Allow Supplemental Policies</Option>
    </Rule>
    <Rule>
      <Option>Enabled:Update Policy No Reboot</Option>
    </Rule>
    <Rule>
      <Option>Required:WHQL</Option>
    </Rule>
  </Rules>
  <!--EKUS-->
  <EKUs />
  <!--File Rules-->
  <FileRules>
    <!--Requirement from WAC to allow files from WiX-->
    <Allow ID="ID_ALLOW_E_0_SHA1_0" FriendlyName="WiX wixca.dll" Hash="9DE61721326D8E88636F9633AA37FCB885A4BABE" />
    <Allow ID="ID_ALLOW_E_1_SHA1_PAGE_0" FriendlyName="WiX wixca.dll" Hash="B216DFA814FC856FA7078381291C78036CEF0A05" />
    <Allow ID="ID_ALLOW_E_2_SHA2_0" FriendlyName="WiX wixca.dll" Hash="233F5E43325615710CA1AA580250530E06339DEF861811073912E8A16B058C69" />
    <Allow ID="ID_ALLOW_E_3_SHA2_PAGE_0" FriendlyName="WiX wixca.dll" Hash="B216DFA814FC856FA7078381291C78036CEF0A05" />
    <Allow ID="ID_ALLOW_E_4_SHA1_0" FriendlyName="WiX wixca.dll 2" Hash="EB4CB5FF520717038ADADCC5E1EF8F7C24B27A90" />
    <Allow ID="ID_ALLOW_E_5_SHA1_PAGE_0" FriendlyName="WiX wixca.dll 2" Hash="6C65DD86130241850B2D808C24EC740A4C509D9C" />
    <Allow ID="ID_ALLOW_E_6_SHA2_0" FriendlyName="WiX wixca.dll 2" Hash="C8D190D5BE1EFD2D52F72A72AE9DFA3940AB3FACEB626405959349654FE18B74" />
    <Allow ID="ID_ALLOW_E_7_SHA2_PAGE_0" FriendlyName="WiX wixca.dll 2" Hash="6C65DD86130241850B2D808C24EC740A4C509D9C" />
    <Allow ID="ID_ALLOW_E_8_SHA1_0" FriendlyName="WiX firewall.dll" Hash="2F0903D4B21A0231ADD1B4CD02E25C7C4974DA84" />
    <Allow ID="ID_ALLOW_E_9_SHA1_PAGE_0" FriendlyName="WiX firewall.dll" Hash="868635E434C14B65AD7D7A9AE1F4047965740786" />
    <Allow ID="ID_ALLOW_E_10_SHA2_0" FriendlyName="WiX firewall.dll" Hash="5C29B8255ACE0CD94C066C528C8AD04F0F45EBA12FCF94DA7B9CA1B64AD4288B" />
    <Allow ID="ID_ALLOW_E_11_SHA2_PAGE_0" FriendlyName="WiX firewall.dll" Hash="868635E434C14B65AD7D7A9AE1F4047965740786" />
  </FileRules>
  <!--Signers-->
  <Signers>
    <Signer ID="ID_SIGNER_S_3D473" Name="Microsoft Code Signing PCA 2011">
      <CertRoot Type="TBS" Value="F6F717A43AD9ABDDC8CEFDDE1C505462535E7D1307E630F9544A2D14FE8BF26E" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3D4EA" Name="Microsoft Code Signing PCA 2011">
      <CertRoot Type="TBS" Value="F6F717A43AD9ABDDC8CEFDDE1C505462535E7D1307E630F9544A2D14FE8BF26E" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3D532" Name="Microsoft Code Signing PCA">
      <CertRoot Type="TBS" Value="27543A3F7612DE2261C7228321722402F63A07DE" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3D558" Name="Microsoft Code Signing PCA 2010">
      <CertRoot Type="TBS" Value="121AF4B922A74247EA49DF50DE37609CC1451A1FE06B2CB7E1E079B492BD8195" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3D55D" Name="Microsoft Code Signing PCA 2010">
      <CertRoot Type="TBS" Value="121AF4B922A74247EA49DF50DE37609CC1451A1FE06B2CB7E1E079B492BD8195" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3D646" Name="Microsoft Code Signing PCA 2010">
      <CertRoot Type="TBS" Value="121AF4B922A74247EA49DF50DE37609CC1451A1FE06B2CB7E1E079B492BD8195" />
      <CertPublisher Value="Microsoft Dynamic Code Publisher" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3D6C4" Name="Microsoft Code Signing PCA">
      <CertRoot Type="TBS" Value="27543A3F7612DE2261C7228321722402F63A07DE" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3D99F" Name="Microsoft Code Signing PCA">
      <CertRoot Type="TBS" Value="5095BF071B0D9976E40AE08412F4E1D241AFB58C" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3E2BB" Name="Microsoft Code Signing PCA">
      <CertRoot Type="TBS" Value="7251ADC0F732CF409EE462E335BB99544F2DD40F" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3EE5E" Name="Microsoft Windows Production PCA 2011">
      <CertRoot Type="TBS" Value="4E80BE107C860DE896384B3EFF50504DC2D76AC7151DF3102A4450637A032146" />
      <CertPublisher Value="Microsoft Windows" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3EE61" Name="Microsoft Windows Production PCA 2011">
      <CertRoot Type="TBS" Value="4E80BE107C860DE896384B3EFF50504DC2D76AC7151DF3102A4450637A032146" />
      <CertPublisher Value="Microsoft Windows Publisher" />
    </Signer>
    <Signer ID="ID_SIGNER_S_3EE6D" Name="Microsoft Windows Production PCA 2011">
      <CertRoot Type="TBS" Value="4E80BE107C860DE896384B3EFF50504DC2D76AC7151DF3102A4450637A032146" />
      <CertPublisher Value="Microsoft Windows" />
    </Signer>
    <Signer ID="ID_SIGNER_S_4153E" Name="Microsoft Code Signing PCA">
      <CertRoot Type="TBS" Value="122F29FFE889713C1568EF7A0F663373C98570E8" />
      <CertPublisher Value="Microsoft Corporation" />
    </Signer>
    <Signer ID="ID_SIGNER_S_415FE" Name="Microsoft Code Signing PCA 2010">
      <CertRoot Type="TBS" Value="121AF4B922A74247EA49DF50DE37609CC1451A1FE06B2CB7E1E079B492BD8195" />
      <CertPublisher Value="Microsoft Windows Early Launch Anti-malware Publisher" />
    </Signer>
    <Signer ID="ID_SIGNER_S_41603" Name="Microsoft Code Signing PCA 2010">
      <CertRoot Type="TBS" Value="121AF4B922A74247EA49DF50DE37609CC1451A1FE06B2CB7E1E079B492BD8195" />
      <CertPublisher Value="Microsoft Windows Early Launch Anti-malware Publisher" />
    </Signer>
    <Signer ID="ID_SIGNER_S_49DF2" Name="Microsoft Windows PCA 2010">
      <CertRoot Type="TBS" Value="90C9669670E75989159E6EEF69625EB6AD17CBA6209ED56F5665D55450A05212" />
      <CertPublisher Value="Microsoft Windows" />
    </Signer>
    <Signer ID="ID_SIGNER_S_4BBDA" Name="Microsoft Windows Third Party Component CA 2012">
      <CertRoot Type="TBS" Value="CEC1AFD0E310C55C1DCC601AB8E172917706AA32FB5EAF826813547FDF02DD46" />
      <CertPublisher Value="Microsoft Windows Hardware Compatibility Publisher" />
    </Signer>
    <Signer ID="ID_SIGNER_S_4C646" Name="Microsoft Windows Verification PCA">
      <CertRoot Type="TBS" Value="B1A2D28695B6B41B0A496AFB1EE9E5ED3247C4A9" />
      <CertPublisher Value="Microsoft Windows" />
    </Signer>
    <Signer ID="ID_SIGNER_S_4F3B4" Name="Microsoft Windows Third Party Component CA 2012">
      <CertRoot Type="TBS" Value="CEC1AFD0E310C55C1DCC601AB8E172917706AA32FB5EAF826813547FDF02DD46" />
      <CertPublisher Value="Microsoft Windows Hardware Compatibility Publisher" />
    </Signer>
    <Signer ID="ID_SIGNER_S_4F52D" Name="Microsoft Windows Third Party Component CA 2014">
      <CertRoot Type="TBS" Value="D8BE9E4D9074088EF818BC6F6FB64955E90378B2754155126FEEBBBD969CF0AE" />
      <CertPublisher Value="Microsoft Windows Hardware Compatibility Publisher" />
    </Signer>
    <Signer ID="ID_SIGNER_S_4F53F" Name="Microsoft Windows Third Party Component CA 2014">
      <CertRoot Type="TBS" Value="D8BE9E4D9074088EF818BC6F6FB64955E90378B2754155126FEEBBBD969CF0AE" />
      <CertPublisher Value="Microsoft Windows Hardware Compatibility Publisher" />
    </Signer>
    <Signer ID="ID_SIGNER_S_537E8" Name="AME CS CA 01">
      <CertRoot Type="TBS" Value="B3C1CB053296C713C7D9639BC51C4399A9A6A04B939BFA3967B08AE2535FF1EB" />
      <CertPublisher Value="Microsoft Azure Code Sign" />
    </Signer>
    <Signer ID="ID_SIGNER_S_537EB" Name="AME CS CA 01">
      <CertRoot Type="TBS" Value="2FF8883AD05888C0719739E7CEF281A8FCA2E744D7D7FE399F58A084D72D2BEF" />
      <CertPublisher Value="Microsoft Azure Stack 3rd Party Code Sign" />
    </Signer>
    <Signer ID="ID_SIGNER_S_53EA2" Name="AME CS CA 01">
      <CertRoot Type="TBS" Value="2FF8883AD05888C0719739E7CEF281A8FCA2E744D7D7FE399F58A084D72D2BEF" />
      <CertPublisher Value="Microsoft Azure Stack Code Sign" />
    </Signer>
    <Signer ID="ID_SIGNER_S_53EA5" Name="AME CS CA 01">
      <CertRoot Type="TBS" Value="2FF8883AD05888C0719739E7CEF281A8FCA2E744D7D7FE399F58A084D72D2BEF" />
      <CertPublisher Value="Microsoft Azure Stack Code Sign" />
    </Signer>
    <Signer ID="ID_SIGNER_S_54854" Name="Microsoft Code Signing PCA 2011">
      <CertRoot Type="TBS" Value="F6F717A43AD9ABDDC8CEFDDE1C505462535E7D1307E630F9544A2D14FE8BF26E" />
      <CertPublisher Value="Microsoft 3rd Party Application Component" />
    </Signer>
    <Signer ID="ID_SIGNER_S_54C44" Name="AME CS CA 01">
      <CertRoot Type="TBS" Value="B3C1CB053296C713C7D9639BC51C4399A9A6A04B939BFA3967B08AE2535FF1EB" />
      <CertPublisher Value="Microsoft Azure Code Sign" />
    </Signer>
    <Signer ID="ID_SIGNER_S_552A7" Name="AME CS CA 01">
      <CertRoot Type="TBS" Value="2FF8883AD05888C0719739E7CEF281A8FCA2E744D7D7FE399F58A084D72D2BEF" />
      <CertPublisher Value="Microsoft Azure Code Sign" />
    </Signer>
    <Signer ID="ID_SIGNER_S_552B2" Name="AME CS CA 01">
      <CertRoot Type="TBS" Value="2FF8883AD05888C0719739E7CEF281A8FCA2E744D7D7FE399F58A084D72D2BEF" />
      <CertPublisher Value="Microsoft Azure Code Sign" />
    </Signer>
  </Signers>
  <!--Driver Signing Scenarios-->
  <SigningScenarios>
    <SigningScenario Value="131" ID="ID_SIGNINGSCENARIO_DRIVERS_1" FriendlyName="Auto generated policy on 05-17-2022">
      <ProductSigners>
        <AllowedSigners>
          <AllowedSigner SignerId="ID_SIGNER_S_3D4EA" />
          <AllowedSigner SignerId="ID_SIGNER_S_3D558" />
          <AllowedSigner SignerId="ID_SIGNER_S_3D6C4" />
          <AllowedSigner SignerId="ID_SIGNER_S_3EE6D" />
          <AllowedSigner SignerId="ID_SIGNER_S_415FE" />
          <AllowedSigner SignerId="ID_SIGNER_S_4F3B4" />
          <AllowedSigner SignerId="ID_SIGNER_S_4F53F" />
          <AllowedSigner SignerId="ID_SIGNER_S_53EA5" />
          <AllowedSigner SignerId="ID_SIGNER_S_54C44" />
          <AllowedSigner SignerId="ID_SIGNER_S_552B2" />
        </AllowedSigners>
      </ProductSigners>
    </SigningScenario>
    <SigningScenario Value="12" ID="ID_SIGNINGSCENARIO_WINDOWS" FriendlyName="Auto generated policy on 05-17-2022">
      <ProductSigners>
        <FileRulesRef>
          <FileRuleRef RuleID="ID_ALLOW_E_0_SHA1_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_1_SHA1_PAGE_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_2_SHA2_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_3_SHA2_PAGE_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_4_SHA1_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_5_SHA1_PAGE_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_6_SHA2_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_7_SHA2_PAGE_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_8_SHA1_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_9_SHA1_PAGE_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_10_SHA2_0" />
          <FileRuleRef RuleID="ID_ALLOW_E_11_SHA2_PAGE_0" />
        </FileRulesRef>
        <AllowedSigners>
          <AllowedSigner SignerId="ID_SIGNER_S_3D473" />
          <AllowedSigner SignerId="ID_SIGNER_S_3D532" />
          <AllowedSigner SignerId="ID_SIGNER_S_3D55D" />
          <AllowedSigner SignerId="ID_SIGNER_S_3D646" />
          <AllowedSigner SignerId="ID_SIGNER_S_3D99F" />
          <AllowedSigner SignerId="ID_SIGNER_S_3E2BB" />
          <AllowedSigner SignerId="ID_SIGNER_S_3EE5E" />
          <AllowedSigner SignerId="ID_SIGNER_S_3EE61" />
          <AllowedSigner SignerId="ID_SIGNER_S_4153E" />
          <AllowedSigner SignerId="ID_SIGNER_S_41603" />
          <AllowedSigner SignerId="ID_SIGNER_S_49DF2" />
          <AllowedSigner SignerId="ID_SIGNER_S_4BBDA" />
          <AllowedSigner SignerId="ID_SIGNER_S_4C646" />
          <AllowedSigner SignerId="ID_SIGNER_S_4F52D" />
          <AllowedSigner SignerId="ID_SIGNER_S_537E8" />
          <AllowedSigner SignerId="ID_SIGNER_S_537EB" />
          <AllowedSigner SignerId="ID_SIGNER_S_53EA2" />
          <AllowedSigner SignerId="ID_SIGNER_S_54854" />
          <AllowedSigner SignerId="ID_SIGNER_S_552A7" />
        </AllowedSigners>
      </ProductSigners>
    </SigningScenario>
  </SigningScenarios>
  <UpdatePolicySigners />
  <CiSigners>
    <CiSigner SignerId="ID_SIGNER_S_3D45F" />
    <CiSigner SignerId="ID_SIGNER_S_3D473" />
    <CiSigner SignerId="ID_SIGNER_S_3D532" />
    <CiSigner SignerId="ID_SIGNER_S_3D55D" />
    <CiSigner SignerId="ID_SIGNER_S_3D646" />
    <CiSigner SignerId="ID_SIGNER_S_3D99F" />
    <CiSigner SignerId="ID_SIGNER_S_3E2BB" />
    <CiSigner SignerId="ID_SIGNER_S_3EE5E" />
    <CiSigner SignerId="ID_SIGNER_S_3EE61" />
    <CiSigner SignerId="ID_SIGNER_S_3F3DE" />
    <CiSigner SignerId="ID_SIGNER_S_3F89C" />
    <CiSigner SignerId="ID_SIGNER_S_4153E" />
    <CiSigner SignerId="ID_SIGNER_S_41603" />
    <CiSigner SignerId="ID_SIGNER_S_46DB3" />
    <CiSigner SignerId="ID_SIGNER_S_48465" />
    <CiSigner SignerId="ID_SIGNER_S_49DF2" />
    <CiSigner SignerId="ID_SIGNER_S_4BBD9" />
    <CiSigner SignerId="ID_SIGNER_S_4BBDA" />
    <CiSigner SignerId="ID_SIGNER_S_4C646" />
    <CiSigner SignerId="ID_SIGNER_S_4C6D2" />
    <CiSigner SignerId="ID_SIGNER_S_4F3B7" />
    <CiSigner SignerId="ID_SIGNER_S_4F425" />
    <CiSigner SignerId="ID_SIGNER_S_4F4FF" />
    <CiSigner SignerId="ID_SIGNER_S_4F501" />
    <CiSigner SignerId="ID_SIGNER_S_4F52C" />
    <CiSigner SignerId="ID_SIGNER_S_4F52D" />
    <CiSigner SignerId="ID_SIGNER_S_4F57C" />
    <CiSigner SignerId="ID_SIGNER_S_4F57F" />
    <CiSigner SignerId="ID_SIGNER_S_4F917" />
    <CiSigner SignerId="ID_SIGNER_S_4FAD9" />
    <CiSigner SignerId="ID_SIGNER_S_4FB53" />
    <CiSigner SignerId="ID_SIGNER_S_4FC23" />
    <CiSigner SignerId="ID_SIGNER_S_537E8" />
    <CiSigner SignerId="ID_SIGNER_S_537EB" />
    <CiSigner SignerId="ID_SIGNER_S_53EA2" />
    <CiSigner SignerId="ID_SIGNER_S_54680" />
    <CiSigner SignerId="ID_SIGNER_S_54854" />
    <CiSigner SignerId="ID_SIGNER_S_552A7" />
    <CiSigner SignerId="ID_SIGNER_S_557B4" />
    <CiSigner SignerId="ID_SIGNER_S_55B24" />
  </CiSigners>
  <HvciOptions>0</HvciOptions>
  <Settings />
</SiPolicy>
```

## Switching between WDAC policy modes

As a customer you can decide to have WDAC enabled during deployment or after deployment. In case you want to change the initial selection in the deployment wizard, you can do it after deployment using PowerShell. Future releases will provide a UI-based control with Windows Admin Center.  

Connect to one of the cluster nodes and use the cmdlets below to switch between nodes.

This is useful when:

1. You started with default recommended settings and now you need to install or run new software, usually third party software, in the node to later create a supplemental policy.
1. You started with WDAC disabled during deployment and now you want to enable WDAC to increase security protection or to validate that your software runs properly.
1. Your software or scripts are blocked by WDAC. In this case you can use audit mode to understand and troubleshoot the issue.

> [!NOTE]
>
> * When your application is blocked, WDAC will create a corresponding event. Review the Event log to understand the details of the policy that's blocking your application. For more information, see the [Windows Defender Application Control operational guide](/windows/security/threat-protection/windows-defender-application-control/windows-defender-application-control-operational-guide).
> * When your script is blocked because of the embedded script enforcement provided by WDAC, you will receive an error message around "Constrained Language Mode" or "Core Type in this language mode". For more information, see [about_Language_Modes for PowerShell](/powershell/module/microsoft.powershell.core/about/about_language_modes#constrained-language-constrained-language).

The following PowerShell commands interact with the Enterprise Cloud Engine to enable the selected modes.

```azurepowershell
Switch-ASWDACPolicy -Mode Audit

Switch-ASWDACPolicy -Mode Enforced

Get-ASWDACPolicyMode
  This returns an integer - for example,
	0 – Not deployed
	1 – Audit
	2 - Enforced
```
Here is a sample output:

```azurepowershell
Switch-WDACPolicyMode -To Audit
PS C:\temp> Get-WDACPolicyMode

2

PS C:\temp> Switch-WDACPolicyMode -To Audit
VERBOSE: Action plan instance ID specified: a61a1fa2-da14-4711-8de3-0c1cc3a71ff4
a61a1fa2-da14-4111-8de3-0c1cc3a71ff4

PS C:\temp> Get-WDACPolicyMode

1
```

## Support for OEM extensions

This release doesn't support partner extensions based on the SBE toolkit because internal-dependent components aren't present in this build. OEM partners can manually create a supplemental policy, as described below, until the SBE toolkit becomes available.

## Create a WDAC policy to enable third party software

While using this preview with WDAC in enforcement mode, for your non-Microsoft signed software to run, you’ll need to build on the Microsoft-provided base policy by creating a WDAC supplemental policy. Additional information can be found in our [public WDAC documentation](/windows/security/threat-protection/windows-defender-application-control/deploy-multiple-windows-defender-application-control-policies#supplemental-policy-creation).

> [!NOTE]
> To run or install new software, you might need to switch WDAC to audit mode first (see steps above), install your software, test that it works correctly, create the new supplemental policy, and then switch WDAC back to enforced mode.

Create a new policy in the Multiple Policy Format as shown below. Then use ```Set-CIPolicyIdInfo``` to convert it to a supplemental policy and specify which base policy it expands.

   Use either ```SupplementsBasePolicyID``` or ```BasePolicyToSupplementPath``` to specify the base policy.
> * ```SupplementsBasePolicyID``` is the GUID of base policy that the supplemental policy applies to. Use {A6368F66-E2C9-4AA2-AB79-8743F6597683} for the GUID, which corresponds to the Micrisoft base policy provided in Azure Stack HCI 22H2.
> * ```BasePolicyToSupplementPath``` is the path to base policy file that the supplemental policy applies to.

### Create a WDAC supplemental policy

Use the following steps to create a supplemental policy:

1. Before you begin, install the software that will be covered by the supplemental policy into its own directory. It's okay if there are subdirectories. When creating the supplemental policy, you must provide a directory to scan, and you don’t want your supplemental policy to cover all code on the system. In our example, this directory is C:\software\codetoscan.

1. Once you have all your software in place, run the following command to create your supplemental policy. Use a unique policy name to help identify it.

   ```azurepowershell
   New-CIPolicy -Level Publisher -FilePath c:\wdac\Contoso-supplemental-policy.xml -UserPEs -Fallback Hash -ScanPath c:\software\codetoscan
   ```

1. Add and delete policy rules. WDAC policy rules are as follows:

   ```azurepowershell
   # enable options 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 6 
 
   # delete options 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 0 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 1 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 2 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 3 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 4 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 5 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 7 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 8 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 9 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 10 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 11 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 12 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 13 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 14 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 15 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 16 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 17 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 18 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 19 -Delete 
   Set-RuleOption -FilePath c:\wdac\Contoso-supplemental-policy.xml -Option 20 -Delete
   ```

1. Modify the name of your supplemental policy.

   ```azurepowershell
   Set-CIPolicyIdInfo -FilePath c:\wdac\Contoso-supplemental-policy.xml -PolicyName "Contoso-supplemental-policy"
   ```

1. Link to the base policy file.

   ```azurepowershell
   $basePolicyId = "{A6368F66-E2C9-4AA2-AB79-8743F6597683}"
   Set-CIPolicyIdInfo -FilePath c:\wdac\Contoso-supplemental-policy.xml -SupplementsBasePolicyID $basePolicyId
   ```

1. After running these commands, you have the final supplemental policy. To put it to use, convert it to binary using the following command.

   ```azurepowershell
   ConvertFrom-CIPolicy c:\wdac\Contoso-supplemental-policy.xml c:\wdac\Contoso-supplemental-policy.bin
   ```

1. Deploy the policy.

   ```C:\Windows\System32\CodeIntegrity\CiPolicies\Active and named {PolicyID}.cip```

   The PolicyID can be found in the XML file.

   ```azurepowershell
   [XML]$policy = Get-Content c:\wdac\Contoso-supplemental-policy.xml 
   Copy-Item -Path c:\wdac\Contoso-supplemental-policy.bin -Destination “C:\Windows\System32\CodeIntegrity\CiPolicies\Active\$($policy.SiPolicy.PolicyId).cip"
   ```

1. To activate the supplemental policy, reboot your system or invoke the code integrity policy refresher tool ```refreshpolicy.exe```. The tool will try to activate all policies in the active policy folder.

## Next steps

 > * [Install an Azure Stack HCI, 22H2 (preview)](../manage/install-preview-version.md?tabs=windows-admin-center).
