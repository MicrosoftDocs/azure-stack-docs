---
title: Workload security for Azure Local security book
description: Learn about workload security for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 08/11/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Workload security for the Azure Local security book

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

## Trusted launch for Azure Local VMs enabled by Azure Arc

Trusted launch for Azure Local VMs enabled by Azure Arc supports secure boot, virtual Trusted Platform Module (vTPM), and vTPM state transfer when a VM migrates or fails over within a system. You can choose Trusted launch as a security type when creating Azure Local VMs via Azure portal or Azure CLI. For more information, see [Trusted launch for Azure Local VMs enabled by Azure Arc](../manage/trusted-launch-vm-overview.md).
 
With standard VMs, vTPM state is not preserved when a VM migrates or fails over to another machine. This limits functionality and availability of applications that rely on the vTPM and its state. With Trusted launch, vTPM state is automatically moved along with the VM, when a VM migrates or fails over to another machine within a system. This allows applications that rely on the vTPM state to continue to function normally even as the VM migrates or fails over. Applications use TPM in a variety of ways. In general, any application that relies on the TPM will benefit from Trusted launch capabilities. For more information, read the blog post [Trusted launch for Azure Local VMs](https://techcommunity.microsoft.com/blog/microsoft-security-blog/trusted-launch-for-azure-arc-vms-on-azure-stack-hci/3978051). 

## Continuous monitoring

You can enable Microsoft Defender for Cloud for your virtual machines running on Azure Local hosts. This enables you to continuously monitor their security posture and take corrective actions. With Azure Local, all virtual machines are automatically Arc-enabled. Microsoft Defender for Cloud protects virtual machines by installing the [Azure Monitor agent](/azure/azure-monitor/agents/azure-monitor-agent-overview) inside the virtual machine and correlating events that the agent collects into recommendations (hardening tasks) that you can perform to make your workloads secure. The hardening tasks are based on security best practices that include managing and enforcing security policies. You can then track the results and manage compliance and governance over time through Defender for Cloud monitoring while reducing the attack surface across all your resources.  
 
Microsoft Defender for Cloud also detects real-time threats such as malware and responds quickly by raising security alerts and providing recommendations to remediate attacks. Security alerts are categorized and assigned severity levels to indicate proper responses. Security alerts can be correlated to identify attack patterns and to integrate with Security Information and Event Management (SIEM), Security Orchestration Automated Response (SOAR), and IT Service Management (ITSM) solutions. This allows you to respond to threats quickly and limit the risk to your resources. 
 
You can also use Microsoft Defender for Cloud to protect your workloads such as [Azure Arc-enabled SQL Server](/sql/sql-server/azure-arc/overview) and [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-enable?tabs=aks-deploy-portal). 
 
[Microsoft Sentinel](https://www.microsoft.com/security/business/siem-and-xdr/microsoft-sentinel/) is a comprehensive security information and event management (SIEM) solution for proactive threat detection, investigation, and response. You can aggregate security data and correlate alerts from virtually any source and modernize your security operations center (SOC) with Microsoft Sentinel. Security alerts from Microsoft Defender for Cloud can be streamed to Microsoft Sentinel, so you can investigate and respond to incidents. 


## Related content

[Silicon assisted security](silicon-assisted-security.md)
