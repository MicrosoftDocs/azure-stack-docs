---
author: ManikaDhiman
ms.author: alkohli
ms.service: azure-stack
ms.topic: include
ms.date: 11/29/2023
ms.reviewer: alkohli
---

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell command using local administrator credentials or deployment user (AzureStackLCMUser) credentials.

   > [!IMPORTANT]
   > Cmdlets that require to be signed in as deployment user (AzureStackLCMUser) need proper credentials authorization via the security group (PREFIX-ECESG) and CredSSP (when using remote PowerShell) or Console session (RDP).

1. Run the following cmdlet to check the WDAC policy mode that is currently enabled:

   ```powershell
   Get-AsWdacPolicyMode
   ```
   This cmdlet returns Audit or Enforced Mode per Node.
	
1. Run the following cmdlet to switch the policy mode:

   ```powershell
   Enable-AsWdacPolicy -Mode <PolicyMode [Audit | Enforced]>
   ```
   
   For example, to switch the policy mode to audit, run:

   ```powershell
   Enable-AsWdacPolicy -Mode Audit
   ```

   > [!WARNING]
   > The Orchestrator will take up to two to three minutes to switch to the selected mode.

1. Run `Get-ASWDACPolicyMode` again to confirm the policy mode is updated.

   ```powershell
   Get-AsWdacPolicyMode
   ```

   Here's a sample output of these cmdlets:

   ```azurepowershell
   PS C:\> Get-AsWdacPolicyMode
   VERBOSE: Getting WDAC Policy Mode on Node01
   VERBOSE: WDAC Policy Mode on Node01 is Enforced.
   VERBOSE: Getting WDAC Policy Mode on Node01
   VERBOSE: WDAC Policy Mode on Node01 is Enforced.

   NodeName     PolicyMode
   --------     ----------
   Node01 	Enforced
   Node01 	Enforced

   PS C:\> Enable-AsWdacPolicy -Mode Audit
   WARNING: Setting WDAC Policy to Audit Mode on all nodes. This will not protect your system against untrusted applications
   VERBOSE: Action plan instance ID specified: 6826fbf2-cb00-450e-ba08-ac24da6df4aa
   VERBOSE: Started an action plan 6826fbf2-cb00-450e-ba08-ac24da6df4aa to set WDAC Policy to Audit Mode.
   6826fbf2-cb00-450e-ba08-ac24da6df4aa

   PS C:\> Get-AsWdacPolicyMode
   VERBOSE: Getting WDAC Policy Mode on Node01
   VERBOSE: WDAC Policy Mode on Node01 is Audit.
   VERBOSE: Getting WDAC Policy Mode on Node01
   VERBOSE: WDAC Policy Mode on Node01 is Audit.

   NodeName     PolicyMode
   --------     ----------
   Node01 	Audit
   Node01	Audit
   ```
