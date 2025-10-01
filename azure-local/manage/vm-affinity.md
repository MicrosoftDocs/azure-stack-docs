---
title: Set up VM affinity rules using Windows PowerShell
description: Learn how to set up VM affinity rules using Windows PowerShell
author: alkohli
ms.topic: how-to
ms.date: 10/23/2024
ms.author: alkohli
ms.reviewer: robhind
ms.service: azure-local
---

# Create machine and site affinity rules for VMs

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

Using either Windows Admin Center or Windows PowerShell, you can easily create affinity and anti-affinity rules for virtual machines (VMs) in your Azure Local instance.

[!INCLUDE [hci-arc-vm](../includes/hci-arc-vm.md)]

Affinity is a rule that establishes a relationship between two or more resource groups or roles, such as VMs, to keep them together on the same machine, system, or site. Anti-affinity is the opposite in that it's used to keep the specified VMs or resource groups apart from each other, such as two domain controllers placed on separate machines, or in separate sites for disaster recovery.

Affinity and anti-affinity rules are used similarly to the way Azure uses Availability Zones. In Azure, you can configure Availability Zones to keep VMs in separate zones and away from each other or in the same zone with each other.  

Using affinity and anti-affinity rules, any clustered VM would either stay on the same machine or be prevented from being together on the same machine. In this way, the only way to move a VM out of a machine would be to do it manually. You can also keep VMs together with its own storage, such as the Cluster Shared Volume (CSV) that its VHDX resides on.

<!--Combining affinity and anti-affinity rules, you can also configure a stretched system across two sites and keep your VMs in the site they need to be in.-->

## Using Windows Admin Center

You can create basic affinity and anti-affinity rules using Windows Admin Center.

:::image type="content" source="media/vm-affinity/vm-affinity-rules.png" alt-text="Virtual machines screen" lightbox="media/vm-affinity/vm-affinity-rules.png":::

1. In Windows Admin Center home, under **All connections**, select the machine or system you want to create the VM rule for.
1. Under **Tools**, select **Settings**.
1. Under **Settings**, select **Affinity rules**, then select **Create rule** under **Affinity rules**.
1. Under **Rule name**, enter a name for your rule.
1. Under Rule type, select either **Together (same machine)** or **Apart (different machines)** to place your VMs on the same machine or on different machines.
1. Under **Applies to**, select the VMs that this rule applies to. Use the **Add** button to add more VMs to the rule.
1. When finished, select **Create rule**.
1. To delete a rule, select it and select **Delete rule**.

## Using Windows PowerShell

You can create more complex rules using Windows PowerShell than using Windows Admin Center. Typically, you set up your rules from a remote computer, rather than on a host machine in a system. This remote computer is called the management computer.

When running Windows PowerShell commands from a management computer, include the `-Name` or `-Cluster` parameter with the name of the system you're managing. If applicable, you also need to specify the fully qualified domain name (FQDN) when using the `-ComputerName` parameter for a machine.

### New PowerShell cmdlets

To create affinity rules for clusters, use the following new PowerShell cmdlets:

#### New-ClusterAffinityRule

The **`New-ClusterAffinityRule`** cmdlet is used to create new rules. With this command, you would specify the name of the rule and the type of rule it is, where:

**`-Name`** is the name of the rule

**`-RuleType`**    values are `SameFaultDomain` | `SameNode` | `DifferentFaultDomain` | `DifferentNode`

Example:

```powershell
New-ClusterAffinityRule -Name Rule1 -RuleType SameFaultDomain
```

#### Set-ClusterAffinityRule

The **`Set-ClusterAffinityRule`** cmdlet is used to enable or disable a rule, where:

**`-Name`** is the name of the rule to enable or disable

**`-Enabled`** | **`Disabled`** enables or disables the rule

Example:

```powershell
Set-ClusterAffinityRule -Name Rule1 -Enabled
```

#### Get-ClusterAffinityRule

The **`Get-ClusterAffinityRule`** cmdlet is used to display the specified rule and what type it is. If **`-Name`** isn't specified, it lists all rules.

Example:

```powershell
Get-ClusterAffinityRule -Name Rule1
```

#### Add-ClusterGroupToAffinityRule

The **`Add-ClusterGroupToAffinityRule`** cmdlet is used to add a VM role or group name to a specific affinity rule, where:

**`-Groups`** is the name of the group or role to add to the rule.

**`-Name`** is the name of the rule to add to.

Example:

```powershell
Add-ClusterGroupToAffinityRule -Groups Group1 -Name Rule1
```

#### Add-ClusterSharedVolumeToAffinityRule

The **`Add-ClusterSharedVolumeToAffinityRule`** allows your VMs to stay together with the Cluster Shared Volume the VHDX resides on, where:

**`-ClusterSharedVolumes`** is the CSV disk that you wish to add to the rule

**`-Name`** is the name of rule to add to

Example:

```powershell
Add-ClusterSharedVolumeToAffinityRule -ClusterSharedVolumes CSV1 -Name Rule1
```

#### Remove-ClusterAffinityRule

The **`Remove-ClusterAffinityRule`** deletes the specified rule, where **`-Name`** is the name of the rule.

Example:

```powershell
Remove-ClusterAffinityRule -Name Rule1
```

#### Remove-ClusterGroupFromAffinityRule

The **`Remove-ClusterGroupFromAffinityRule`** removes a VM group or role from a specific rule but doesn't disable or delete the rule, where:

**`-Name`** is the name of the rule

**`-Groups`** are the groups or roles that you wish to remove from the rule

Example:

```powershell
Remove-ClusterGroupFromAffinityRule -Name Rule1 -Groups Group1
```

#### Remove-ClusterSharedVolumeFromAffinityRule

The **`Remove-ClusterSharedVolumeFromAffinityRule`** cmdlet is used to remove the Cluster Shared Volumes from a specific rule but doesn't disable or delete the rule, where:

**`-ClusterSharedVolumes`** is the CSV disk that you want to remove from the rule.

**`-Name`** is the name of the rule to add to.

Example:

```powershell
Remove-ClusterSharedVolumeFromAffinityRule -ClusterSharedVolumes CSV1 -Name Rule1
```

### Existing PowerShell cmdlets

With the advent of the new cmdlets, we also added extra new switches to a few existing cmdlets.

#### Move-ClusterGroup

The new `-IgnoreAffinityRule` switch ignores the rule and moves the cluster resource group to another machine. For more information on this cmdlet, see [Move-ClusterGroup](/powershell/module/failoverclusters/move-clustergroup).

Example:

```powershell
Move-ClusterGroup -IgnoreAffinityRule -Cluster Cluster1
```

> [!NOTE]
> If a move rule is valid (supported), all groups and roles that are affected will also move. If a VM move will knowingly violate a rule, yet it's needed on a one-time temporary basis, use the `-IgnoreAffinityRule` switch to allow the move to occur. In this case, a violation warning for the VM will be displayed. You can then enable the rule back as necessary.

#### Start-ClusterGroup

The new `-IgnoreAffinityRule` switch ignores the rule and brings the cluster resource group online in its current location. For more information on this cmdlet, see [Start-ClusterGroup](/powershell/module/failoverclusters/start-clustergroup).

Example:

```powershell
Start-ClusterGroup -IgnoreAffinityRule -Cluster Cluster1
```

## Affinity rule examples

Affinity rules are "together" rules that keep resources on the same machine, system, or site. Here are a few common scenarios for setting up affinity rules.

### Scenario 1

Suppose you have a SQL Server VM and a Web Server VM. These two VMs need to always remain in the same site but don't necessarily need to be on the same machine. Using `SameFaultDomain`, this is possible, as shown:

```powershell
New-ClusterAffinityRule -Name WebData -Ruletype SameFaultDomain -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups SQL1,WEB1 –Name WebData -Cluster Cluster1

Set-ClusterAffinityRule -Name WebData -Enabled 1 -Cluster Cluster1
```

To see this rule and how it's configured, use the **`Get-ClusterAffinityRule`** cmdlet to see the output:

```powershell
Get-ClusterAffinityRule -Name WebData -Cluster Cluster1

Name        RuleType          Groups        Enabled
----        ---------         ------        -------
WebData     SameFaultDomain   {SQL1, WEB1}     1
```

### Scenario 2

Let's use the same scenario except specify that the VMs must reside on the same machine. Using `SameNode`, set it as follows:

```powershell
New-ClusterAffinityRule -Name WebData1 -Ruletype SameNode -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups SQL1,WEB1 –Name WebData1 -Cluster Cluster1

Set-ClusterAffinityRule -Name WebData1 -Enabled 1 -Cluster Cluster1
```

To see the rule and how it's configured, use the **`Get-ClusterAffinityRule`** cmdlet to see the output:

```powershell
Get-ClusterAffinityRule -Name WebData1 -Cluster Cluster1

Name    RuleType    Groups        Enabled
----    --------    ------        -------
DC      SameNode    {SQL1, WEB1}     1
```

## Anti-affinity rule examples

Anti-affinity rules are "apart" rules that separate resources and place them on different machines, systems, or sites.

### Scenario 1
You have two VMs each running SQL Server on the same Azure Local multi-site system. Each VM utilizes a lot of memory, CPU, and storage resources. If the two end up on the same machine, this can cause performance issues with one or both as they compete for memory, CPU, and storage cycles. Using an anti-affinity rule with `DifferentNode` as the rule type, these VMs will always stay on different machines.  

The example commands would be:

```powershell
New-ClusterAffinityRule -Name SQL -Ruletype DifferentNode -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups SQL1,SQL2 –Name SQL -Cluster Cluster1

Set-ClusterAffinityRule -Name SQL -Enabled 1 -Cluster Cluster1
```

To see the rule and how it's configured, use the **`Get-ClusterAffinityRule`** cmdlet to see the output:

```powershell
Get-ClusterAffinityRule -Name SQL -Cluster Cluster1

Name    RuleType        Groups        Enabled
----    -----------     -------       -------
SQL     DifferentNode   {SQL1, SQL2}     1
```

<!-- ### Scenario 2

Let's say you have an Azure Local stretched system with two sites (fault domains). You have two domain controllers you wish to keep in separate sites. Using an anti-affinity rule with `DifferentFaultDomain` as a rule type, these domain controllers will always stay in different sites.  The example commands for this would be:

```powershell
New-ClusterAffinityRule -Name DC -Ruletype DifferentFaultDomain -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups DC1,DC2 –Name DC -Cluster Cluster1

Set-ClusterAffinityRule -Name DC -Enabled 1 -Cluster Cluster1
```

To see this rule and how it's configured, use the **`Get-ClusterAffinityRule`** cmdlet to see the output:

```powershell
Get-ClusterAffinityRule -Name DC -Cluster Cluster1

Name    RuleType                Groups        Enabled
----    --------                -------       -------
DC      DifferentFaultDomain    {DC1, DC2}       1
```
## Combined rule examples

Combining affinity and anti-affinity rules, you can easily configure various VM combinations across a multi-site system. In this scenario, each site has three VMs: SQL Server (SQL), Web Server (WEB), and domain controller (DC).  For each of the combinations, you can use affinity rules with `SameFaultDomain` to keep them all in the same site. You can also set the domain controllers for each site with anti-affinity rules and `DifferentFaultDomain` to keep the domain controller VMs in separate sites as shown below:

```powershell
New-ClusterAffinityRule -Name Site1Trio -Ruletype SameFaultDomain -Cluster Cluster1

New-ClusterAffinityRule -Name Site2Trio -Ruletype SameFaultDomain -Cluster Cluster1

New-ClusterAffinityRule -Name TrioApart -Ruletype DifferentFaultDomain -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups SQL1,WEB1,DC1 –Name Site1Trio -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups SQL2,WEB2,DC2 –Name Site2Trio -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups DC1,DC2 –Name TrioApart -Cluster Cluster1

Set-ClusterAffinityRule -Name Site1Trio -Enabled 1 -Cluster Cluster1

Set-ClusterAffinityRule -Name Site2Trio -Enabled 1 -Cluster Cluster1

Set-ClusterAffinityRule -Name TrioApart -Enabled 1 -Cluster Cluster1
```

To see the rules and how they're configured, use the **`Get-ClusterAffinityRule`** cmdlet without the `-Name` switch and you can see all rules created and their output.

```powershell
Get-ClusterAffinityRule -Cluster Cluster1

Name        RuleType               Groups            Enabled
----        --------               ------            -------
Site1Trio   SameFaultDomain        {SQL1, WEB1, DC1}    1
Site2Trio   SameFaultDomain        {SQL2, WEB2, DC2}    1
TrioApart   DifferentFaultDomain   {DC1, DC2}           1
```
-->

## Storage affinity rules

You can also keep a VM and its VHDX on a Cluster Shared Volume (CSV) on the same machine. Doing so would keep CSV redirection from occurring, which can slow down the starting or stopping of a VM. Taking into account the combined affinity and anti-affinity scenario previously, you can keep the SQL VM and the Cluster Shared Volume on the same machine. To do that, use the following commands:

```powershell
New-ClusterAffinityRule -Name SQL1CSV1 -Ruletype SameNode -Cluster Cluster1

New-ClusterAffinityRule -Name SQL2CSV2 -Ruletype SameNode -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups SQL1 –Name SQL1CSV1 -Cluster Cluster1

Add-ClusterGroupToAffinityRule -Groups SQL2 –Name SQL2CSV2 -Cluster Cluster1

Add-ClusterSharedVolumeToAffinityRule -ClusterSharedVolumes CSV1 -Name SQL1CSV1 -Cluster Cluster1

Add-ClusterSharedVolumeToAffinityRule -ClusterSharedVolumes CSV2 -Name SQL2CSV2 -Cluster Cluster1

Set-ClusterAffinityRule -Name SQL1CSV1 -Enabled 1 -Cluster Cluster1

Set-ClusterAffinityRule -Name SQL2CSV2 -Enabled 1 -Cluster Cluster1
```

To see these rules and how they're configured, use the **`Get-ClusterAffinityRule`** cmdlet without the `-Name` switch and view the output.

```powershell
Get-ClusterAffinityRule -Cluster Cluster1

Name        RuleType               Groups            Enabled
----        --------               ------            -------
Site1Trio   SameFaultDomain        {SQL1, WEB1, DC1}    1
Site2Trio   SameFaultDomain        {SQL2, WEB2, DC2}    1
TrioApart   DifferentFaultDomain   {DC1, DC2}           1
SQL1CSV1    SameNode               {SQL1, <CSV1-GUID>}  1
SQL2CSV2    SameNode               {SQL2, <CSV2-GUID>}  1
```

## Next steps

Learn how to manage your VMs. See [Manage VMs on Azure Local using Windows Admin Center](../manage/vm.md).
