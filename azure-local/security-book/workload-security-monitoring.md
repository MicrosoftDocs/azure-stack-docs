---
title:  Azure Local security book continuous monitoring
description: Continuous monitoring for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/27/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Continuous monitoring

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

:::image type="content" source="./media/workload-security/security-diagram-workload-security.png" alt-text="Diagram illustrating workload security layer." lightbox="./media/workload-security/security-diagram-workload-security.png":::

You can enable Microsoft Defender for Cloud for your virtual machines running on Azure Local hosts. This enables you to continuously monitor their security posture and take corrective actions. With Azure Local, all virtual machines are automatically Arc-enabled. Microsoft Defender for Cloud protects virtual machines by installing the [Azure Monitor agent](/azure/azure-monitor/agents/azure-monitor-agent-overview) inside the virtual machine and correlating events that the agent collects into recommendations (hardening tasks) that you can perform to make your workloads secure. The hardening tasks are based on security best practices that include managing and enforcing security policies. You can then track the results and manage compliance and governance over time through Defender for Cloud monitoring while reducing the attack surface across all your resources.  
 
Microsoft Defender for Cloud also detects real-time threats such as malware and responds quickly by raising security alerts and providing recommendations to remediate attacks. Security alerts are categorized and assigned severity levels to indicate proper responses. Security alerts can be correlated to identify attack patterns and to integrate with Security Information and Event Management (SIEM), Security Orchestration Automated Response (SOAR), and IT Service Management (ITSM) solutions. This allows you to respond to threats quickly and limit the risk to your resources. 
 
You can also use Microsoft Defender for Cloud to protect your workloads such as [Azure Arc-enabled SQL Server](/sql/sql-server/azure-arc/overview) and [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-enable?tabs=aks-deploy-portal). 
 
[Microsoft Sentinel](https://www.microsoft.com/security/business/siem-and-xdr/microsoft-sentinel/) is a comprehensive security information and event management (SIEM) solution for proactive threat detection, investigation, and response. You can aggregate security data and correlate alerts from virtually any source and modernize your security operations center (SOC) with Microsoft Sentinel. Security alerts from Microsoft Defender for Cloud can be streamed to Microsoft Sentinel, so you can investigate and respond to incidents. 
 
## Related content

- [Trusted launch for Azure Local VMs enabled by Azure Arc](workload-security-trusted-launch.md)
