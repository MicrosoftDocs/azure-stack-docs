---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.topic: include
ms.date: 09/30/2022
ms.reviewer: alkohli
---

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell command using local administrator credentials or LCM deployment user credentials.

> [!IMPORTANT]
Cmdlets inteacting with LCM (Lifecycle Manager) requires proper credentials authorization via the security group (PREFIX-ECESG) and CredSSP (when using remote PowerShell) or Console session (RDP)

1. Run the following cmdlet to check the WDAC policy mode that is currently enabled:

   ```powershell
   Get-AsWdacPolicyMode
   ```
   This cmdlet returns an integer:
	
   - 0 – Not deployed
   - 1 – Audit
   - 2 - Enforced

1. Run the following cmdlet to switch the policy mode:

   ```powershell
   Enable-AsWdacPolicy -Mode <PolicyMode [Audit | Enforced]>
   ```
   
   For example, to switch the policy mode to audit, run:

   ```powershell
   Enable-AsWdacPolicy -Mode Audit
   ```

   > [!WARNING]
   > The Orchestrator will take up to 2 to 3 minutes to switch to the selected mode.

1. Run `Get-ASWDACPolicyMode` again to confirm the policy mode is updated.

   ```powershell
   Get-AsWdacPolicyMode
   ```

   Here's a sample output of these cmdlets:

   ```azurepowershell
   PS C:\> Get-AsWdacPolicyMode

   2

   PS C:\> Enable-AsWdacPolicy -Mode Audit
   VERBOSE: Action plan instance ID specified: a61a1fa2-da14-4711-8de3-0c1cc3a71ff4
   a61a1fa2-da14-4111-8de3-0c1cc3a71ff4

   PS C:\temp> Get-WDACPolicyMode

   1
   ```
