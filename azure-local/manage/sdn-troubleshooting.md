---
title: Troubleshoot Azure Local SDN enabled by Azure Arc
description: Troubleshoot and resolve common Azure Local SDN network controller deployment errors, VM connectivity issues, and NSG configuration problems. Learn how to fix DNS, downtime, and network policy errors.
author: alkohli
contributors:
ms.topic: concept-article
ms.date: 09/05/2025
ms.author: alkohli
ms.reviewer: alkohli
---


# Troubleshoot Software-Defined Networking enabled by Azure Arc on Azure Local Virtual Machines

::: moniker range=">=azloc-2506"

This article provides troubleshooting steps for common issues encountered when you deploy and manage Software-Defined Networking (SDN) enabled by Azure Arc on your Azure Local VMs. The article covers errors during the action plan deployment, VM connectivity issues, and network security group (NSG) configurations.

## Action plan to deploy the Network Controller fails  
  
**Error**: Arc-managed SDN running Network Controller in Failover Cluster is only supported in 24H2 OS or above.

**Root cause**: For SDN enabled by Azure Arc, running Network Controller in Failover Cluster is only supported in OS build version 26100.xxxx or later.  
  
**Resolution**: Make sure that you're running OS version 26100.xxxx or later on your Azure Local instance. For more information, see [Create network security groups](../manage/create-network-security-groups.md#prerequisites).


## SDN enabled by Azure Arc action plan fails due to DNS resolution errors

**Error**: Unable to create and delete NC Logical Network. Exception: The remote name couldn't be resolved.

**Root cause**: This error message occurs when the Dynamic DNS is disabled on the DNS server. The DNS environment isn't Active Directory integrated and an A record wasn't created manually for your DNS.

Here's an example of the complete error message:

```output

FullStepIndex: 1.1.0.5.1
RolePath: Cloud\Fabric\NC
Interface: VerifyNCAPI
StackTrace:
CloudEngine.Actions.InterfaceInvocationFailedException: Type 'VerifyNCAPI' of Role 'NC' raised an exception: Unable to create and delete NC Logical Network. Exception: The remote name could not be resolved: 'ro0108-nc.ro0108.masd.stbtest.microsoft.com'

Command Arguments
------- ---------
Validate-NCAPI
{Parameters=CloudEngine.Configurations.EceInterfaceParameters, ErrorAction=Stop, Verbose=...
{}

\<ScriptBlock\> {CloudEngine.Configurations.EceInterfaceParameters, NC,
VerifyNCAPI, C:\NugetStore\Microsoft
Invoke-EceInterfaceInternal {CloudDeploymentModulePath=C:\NugetStore\Microsoft.AzureStack.Solution.Deploy.CloudDeploy\<ScriptBlock\> {CloudEngine.Configurations.EceInterfaceParameters, 9e6d5f77-cbaa-48d3-83a0-6299de493ddd.
```

**Remediation steps**

Follow these steps to resolve this issue:

1. Create the A DNS Record for \$sdnPrefix-NC, pointing towards the fifth IP address in the IP address range when configuring the [Network settings during the deployment of your Azure Local instance](../deploy/deploy-via-portal.md#specify-network-settings).

2. Run the action plan again using the cmdlet `Add-ECEFeature`.

## DNS conflict for NC fully qualified domain name

**Error**: DNS conflict for NC fully qualified domain name.

Here's an example of the complete error message:

```output
FullStepIndex: 1.1.0.2.0
RolePath: Cloud\Fabric\NC
Interface: ValidateSDNPrefixNoDNSConflict
StackTrace:
CloudEngine.Actions.InterfaceInvocationFailedException: Type 'ValidateSDNPrefixNoDNSConflict' of Role 'NC' raised an exception: DNS conflict found for NC fully qualified domain name 'ro0108-NC.ro0108.masd.stbtest.microsoft.com'. Expected to resolve to the reserved IP '100.101.172.230', but resolved to IP '10.10.10.10'. Please update the conflicting DNS record or choose a different SDN prefix.
```

**Remediation steps**

1. Ensure the A DNS Record for `\$sdnPrefix-NC` points towards the fifth IP address in the IP address range when configuring the [Network settings during the deployment of your Azure Local instance](../deploy/deploy-via-portal.md).

## Error while creating an NSG or default network access policy

**Error**: You could receive the following error while creating an NSG or a default network access policy.

```output

The moc-operator network security group service returned an error while reconciling: AddOrUpdateNetworkSecurityGroup not implemented for non-NC provider: Not Implemented: Failed
(Code: Failed)
```

**Remediation steps**: Make sure to run the network controller action plan to deploy SDN enabled by Azure Arc. For more information, [Enable SDN integration](../deploy/enable-sdn-integration.md).
  
## Next steps

- Review the [FAQs about Azure Local SDN enabled by Azure Arc](../concepts/sdn-frequently-asked-questions.yml).

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available in Azure Local 2506 or later with OS build 26100.xxxx.

::: moniker-end