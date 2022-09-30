---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.topic: include
ms.date: 09/30/2022
ms.reviewer: alkohli
---

1. Run PowerShell as an administrator.

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
   Switch-AsWdacPolicy -Mode <PolicyMode>
   ```
   
   For example, to switch the policy mode to audit, run:

   ```powershell
   Switch-AsWdacPolicy -Mode Audit
   ```

   > [!WARNING]
   > The Orchestrator will take up to 2 to 3 minutes to switch to the selected mode.

1. Run `Get-ASWDACPolicyInfo` again to confirm the policy mode is updated.

   ```powershell
   Get-AsWdacPolicyMode
   ```

Here's a sample output of these cmdlets:

```azurepowershell
PS C:\temp> Get-AsWdacPolicyMode

2

PS C:\temp> Switch-AsWdacPolicy -Mode Audit
VERBOSE: Action plan instance ID specified: a61a1fa2-da14-4711-8de3-0c1cc3a71ff4
a61a1fa2-da14-4111-8de3-0c1cc3a71ff4

PS C:\temp> Get-WDACPolicyMode

1
```