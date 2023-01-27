---
title: Validation tests in AKS hybrid
description: Learn how to validate your environment and configuration prior to installing AKS hybrid.
author: sethmanheim
ms.topic: troubleshooting
ms.date: 01/26/2023
ms.author: sethm 
ms.lastreviewed: 01/26/2023
ms.reviewer: waltero

---

# AKS hybrid pre-install validation tests

The following table lists the tests that are executed when you run the [Set-AksHciConfig](reference/ps/set-akshciconfig.md) and [Set-AksHciRegistration](reference/ps/set-akshciregistration.md) PowerShell cmdlets. The tests help to ensure that when you run the actual installation with [Install-AksHci](reference/ps/install-akshci.md), the installation process avoids many common environment and configuration issues. For a better understanding of the terms used in the tests, see the [AKS hybrid concepts article](kubernetes-concepts.md).

+----------------------+----------------------+----------------------+
| Test Name            | Description          | Troubleshooting      |
|                      |                      | Resources            |
+======================+======================+======================+
| [MOC](https://lear   | The test validates   | -   Ensure that      |
| n.microsoft.com/en-u | that the machine     |     there is         |
| s/azure/aks/hybrid/c | hosting MOC has      |     connectivity     |
| oncepts-node-network | internet             |     from the         |
| ing#microsoft-on-pre | connectivity to key  |     physical hosts   |
| mises-cloud-service) | Microsoft endpoints. |     to the internet  |
| Host Internet        |                      |                      |
| Connectivity         |                      | -   [Troubleshooting |
|                      |                      |     network issues   |
|                      |                      |     in Azure Stack   |
|                      |                      |                      |
|                      |                      |   HCI](https://techc |
|                      |                      | ommunity.microsoft.c |
|                      |                      | om/t5/networking-blo |
|                      |                      | g/introducing-networ |
|                      |                      | k-hud-for-azure-stac |
|                      |                      | k-hci/ba-p/3676097). |
|                      |                      |                      |
|                      |                      | -   [Blog post on    |
|                      |                      |     troubleshooting  |
|                      |                      |     network          |
|                      |                      |                      |
|                      |                      |  issues](https://tec |
|                      |                      | hcommunity.microsoft |
|                      |                      | .com/t5/itops-talk-b |
|                      |                      | log/how-to-troublesh |
|                      |                      | oot-windows-server-n |
|                      |                      | etwork-connectivity- |
|                      |                      | issues/ba-p/1500934) |
|                      |                      |     in Windows       |
|                      |                      |     Server.          |
|                      |                      |                      |
|                      |                      | -   [Firewall        |
|                      |                      |     requirements for |
|                      |                      |     Azure Stack      |
|                      |                      |     HCI](ht          |
|                      |                      | tps://learn.microsof |
|                      |                      | t.com/en-us/azure-st |
|                      |                      | ack/hci/concepts/fir |
|                      |                      | ewall-requirements). |
+----------------------+----------------------+----------------------+
| MOC Host Limits      | The test validates   | -   Ensure that the  |
|                      | that the machine     |     minimum          |
|                      | hosting MOC has the  |     requirements are |
|                      | minimum resources    |     met, see them    |
|                      | needed. Refer to the |     here: [AKS       |
|                      | published [hardware  |     Hybrid system    |
|                      | requ                 |     requ             |
|                      | irements](https://le | irements](https://le |
|                      | arn.microsoft.com/en | arn.microsoft.com/en |
|                      | -us/azure/aks/hybrid | -us/azure/aks/hybrid |
|                      | /system-requirements | /system-requirements |
|                      | ?tabs=allow-table#ha | ?tabs=allow-table#co |
|                      | rdware-requirements) | mpute-requirements). |
+----------------------+----------------------+----------------------+
| MOC Host Remoting    | The test validates   | -   Troubleshoot     |
|                      | that PowerShell      |     [CredSSP         |
|                      | remoting is enabled  |     issues           |
|                      | and working from the | ](https://learn.micr |
|                      | MOC hosting machine  | osoft.com/en-us/azur |
|                      | to other physical    | e-stack/hci/manage/t |
|                      | hosts~~nodes~~ in    | roubleshoot-credssp) |
|                      | the cluster          |                      |
|                      |                      | -   Troubleshoot     |
|                      |                      |     [PowerShell      |
|                      |                      |     Remoting         |
|                      |                      |     i                |
|                      |                      | ssues](https://learn |
|                      |                      | .microsoft.com/en-us |
|                      |                      | /powershell/module/m |
|                      |                      | icrosoft.powershell. |
|                      |                      | core/about/about_rem |
|                      |                      | ote_troubleshooting? |
|                      |                      | view=powershell-7.3) |
+----------------------+----------------------+----------------------+
| MOC Network          | Test validate that   | -   Ensure that the  |
| Configuration        | MOC Network          |     IP address of    |
|                      | Configuration is     |     the              |
|                      | correct. It verifies |     CloudServiceIP   |
|                      | that:                |     meets the        |
|                      |                      |     requirements in  |
|                      | -   Virtual Switch   |     the description. |
|                      |     exists           |                      |
|                      |                      | -                    |
|                      | -   The              |                      |
|                      |     CloudServiceIP   | -   [AKS hybrid      |
|                      |     can be used to   |     Network          |
|                      |     provide a static |     Concep           |
|                      |     IP address to be | ts](https://learn.mi |
|                      |     assigned to the  | crosoft.com/en-us/az |
|                      |     MOC CloudAgent   | ure/aks/hybrid/conce |
|                      |     service. This    | pts-node-networking) |
|                      |     value  should be |                      |
|                      |     provided using   | -   [AKS hybrid      |
|                      |     the standard     |     Network          |
|                      |     IPv4 format.     |     troubleshoot     |
|                      |     (Example:        | ing](https://learn.m |
|                      |     192.168.1.2).    | icrosoft.com/en-us/a |
|                      |     The              | zure/aks/hybrid/know |
|                      |     cloudServiceIP   | n-issues-networking) |
|                      |     address should   |                      |
|                      |     also be carved   | -   [Troubleshoot    |
|                      |     out of one of    |     network issues   |
|                      |     the              |     in Azure Stack   |
|                      |     ClusterAndClient |                      |
|                      |     networks in the  |    HCI](https://azur |
|                      |     underlying       | ehybridevents.z22.we |
|                      |     Failover         | b.core.windows.net/c |
|                      |     cluster.         | ontent/9.AzStackHCI- |
|                      |     You can run      | TroubleShooting.pdf) |
|                      |                      |                      |
|                      |   Get-ClusterNetwork |                      |
|                      |     command in an    |                      |
|                      |     elevated         |                      |
|                      |     powershell mode  |                      |
|                      |     to find the      |                      |
|                      |     network role.    |                      |
|                      |     You may want to  |                      |
|                      |     specify this to  |                      |
|                      |     ensure that      |                      |
|                      |     anything         |                      |
|                      |     important on the |                      |
|                      |     network is       |                      |
|                      |     always           |                      |
|                      |     accessible       |                      |
|                      |     because the IP   |                      |
|                      |     address will not |                      |
|                      |     change.          |                      |
|                      |                      |                      |
|                      | -   Should be able   |                      |
|                      |     to create and    |                      |
|                      |     start Failover   |                      |
|                      |     Cluster          |                      |
|                      |     resource.        |                      |
|                      |                      |                      |
|                      | -   Cloud service IP |                      |
|                      |     should not       |                      |
|                      |     overlap with VIP |                      |
|                      |     pool, or         |                      |
|                      |     k8snodepool IP   |                      |
|                      |     addresses        |                      |
|                      |     provided during  |                      |
|                      |     VNET             |                      |
|                      |     configuration.   |                      |
+----------------------+----------------------+----------------------+
| MOC SDN              | Validate that the    | -   If you are       |
| Configuration        | SDN configuration is |     providing SDN    |
|                      | correct, and the     |     parameters       |
|                      | Network Controller   |     please ensure    |
|                      | is available, it     |     that SDN is      |
|                      | checks:              |     available in the |
|                      |                      |     system           |
|                      | -   Network          |                      |
|                      |     Controller FQDN  | -   [AKS hybrid      |
|                      |     Or IP address    |     Network          |
|                      |     information is   |                      |
|                      |     reachable.       |  Concepts](https://m |
|                      |                      | icrosoft-my.sharepoi |
|                      | -   Network          | nt-df.com/:w:/p/walt |
|                      |     Controller Load  | ero/EQT6mzUaWI9Ll3O0 |
|                      |     Balancer Subnet  | Q_wjfasBAUPeilEX7WPo |
|                      |     Resource         | aYLZcu_LLg?e=Ui07Bx) |
|                      |     Reference is     |                      |
|                      |     provided.        | -   [Troubleshooting |
|                      |                      |     SDN              |
|                      | -   Network          | ](https://learn.micr |
|                      |     Controller L     | osoft.com/en-us/wind |
|                      |     netRef is        | ows-server/networkin |
|                      |     provided.        | g/sdn/troubleshoot/t |
|                      |                      | roubleshoot-software |
|                      |                      | -defined-networking) |
|                      |                      |                      |
|                      |                      | -   [Checklist for   |
|                      |                      |     troubleshooting  |
|                      |                      |     S                |
|                      |                      | DN](https://learn.mi |
|                      |                      | crosoft.com/en-us/tr |
|                      |                      | oubleshoot/windows-s |
|                      |                      | erver/software-defin |
|                      |                      | ed-networking/troubl |
|                      |                      | eshoot-sdn-guidance) |
+----------------------+----------------------+----------------------+
| MOC directories      | Validate MOC         | -   Ensure the User  |
|                      | directories. It      |     account has      |
|                      | checks for:          |     access to the    |
|                      |                      |     directories      |
|                      | -   Valid dir names  |     provided.        |
|                      |                      |                      |
|                      | -   Config directory | -   Verified that no |
|                      |     cannot contain   |     previous install |
|                      |     the Working      |     of MOC exists    |
|                      |     directory.       |                      |
|                      |                      | -   Verify that      |
|                      | -   Check if the     |     Config directory |
|                      |     working          |     cannot contain   |
|                      |     directory is in  |     the Working      |
|                      |     the Cluster      |     directory        |
|                      |     Shared Volume.   |                      |
|                      |                      |                      |
|                      | -   Check that the   |                      |
|                      |     directories are  |                      |
|                      |     not local.       |                      |
|                      |                      |                      |
|                      | -   check to ensure  |                      |
|                      |     working          |                      |
|                      |     directory is not |                      |
|                      |     System Drive or  |                      |
|                      |     Root.            |                      |
+----------------------+----------------------+----------------------+
| Failover Cluster     | Validate Failover    | -   Ensure that      |
| Health               | Cluster Health. It   |     there is a       |
|                      | checks that cluster  |     Failover setup,  |
|                      | nodes and cluster    |     review [Failover |
|                      | network are          |     Clustering       |
|                      | available.           | ](https://learn.micr |
|                      |                      | osoft.com/en-us/wind |
|                      |                      | ows-server/failover- |
|                      |                      | clustering/failover- |
|                      |                      | clustering-overview) |
|                      |                      |                      |
|                      |                      | -   [Run an HCI      |
|                      |                      |     cluster          |
|                      |                      |     validation       |
|                      |                      |     test](           |
|                      |                      | https://learn.micros |
|                      |                      | oft.com/en-us/azure- |
|                      |                      | stack/hci/manage/val |
|                      |                      | idate-qos#run-a-clus |
|                      |                      | ter-validation-test) |
|                      |                      |                      |
|                      |                      | -   [Troubleshooting |
|                      |                      |     the failover     |
|                      |                      |     cluster](htt     |
|                      |                      | ps://learn.microsoft |
|                      |                      | .com/en-us/windows-s |
|                      |                      | erver/failover-clust |
|                      |                      | ering/troubleshootin |
|                      |                      | g-using-wer-reports) |
+----------------------+----------------------+----------------------+
| Failover Cluster HCI | Validate Failover    | -   [Run an HCI      |
| Registration         | Cluster HCI          |     cluster          |
|                      | Registration. It     |     validation       |
|                      | checks for the       |     test](           |
|                      | presence of a        | https://learn.micros |
|                      | failover cluster.    | oft.com/en-us/azure- |
|                      |                      | stack/hci/manage/val |
|                      |                      | idate-qos#run-a-clus |
|                      |                      | ter-validation-test) |
|                      |                      |                      |
|                      |                      | -   [Troubleshooting |
|                      |                      |     the failover     |
|                      |                      |     cluster](htt     |
|                      |                      | ps://learn.microsoft |
|                      |                      | .com/en-us/windows-s |
|                      |                      | erver/failover-clust |
|                      |                      | ering/troubleshootin |
|                      |                      | g-using-wer-reports) |
+----------------------+----------------------+----------------------+
| AKS Management       | Validate AKS         | -   Review the       |
| Cluster              | Management cluster   |     [Active          |
| Configuration        | configuration and    |     Directory        |
|                      | corresponding host   |     requirements     |
|                      | machine              | ](https://learn.micr |
|                      | configuration to     | osoft.com/en-us/azur |
|                      | make sure host is    | e/aks/hybrid/system- |
|                      | ready to install it  | requirements?tabs=al |
|                      | successfully.        | low-table#active-dir |
|                      | Verifies:            | ectory-requirements) |
|                      |                      |                      |
|                      | -   AKS Management   | -   [AKS hybrid      |
|                      |     Image is present |     Network          |
|                      |                      |     troubleshooti    |
|                      | -   AKS hybrid       | ng](https://learn.mi |
|                      |     related binaries | crosoft.com/en-us/az |
|                      |     are present in   | ure/aks/hybrid/conce |
|                      |     all nodes        | pts-node-networking) |
|                      |                      |                      |
|                      | -   Necessary        | -   Ensure user has  |
|                      |     AzureStackHCI    |     the needed       |
|                      |     cloud roles are  |     permissions      |
|                      |     added            |                      |
|                      |                      | -   Ensure that IP   |
|                      | -   Verifies         |     formatting is    |
|                      |     AzureStackHCI    |     correct          |
|                      |     cloud location   |                      |
|                      |                      |                      |
|                      | -   Verifies         |                      |
|                      |     AzureStackHCI    |                      |
|                      |     cloud storage    |                      |
|                      |     container        |                      |
|                      |                      |                      |
|                      | -   Verifies         |                      |
|                      |     permissions to   |                      |
|                      |     create Azure     |                      |
|                      |     Resource         |                      |
|                      |                      |                      |
|                      | -   Verifies         |                      |
|                      |     AzureStackHCI    |                      |
|                      |     network and      |                      |
|                      |     loadbalancer     |                      |
|                      |     type             |                      |
|                      |                      |                      |
|                      | -   Verifies         |                      |
|                      |     Kube-Vip         |                      |
|                      |     configuration    |                      |
|                      |                      |                      |
|                      | -   Verifies         |                      |
|                      |     Vip-pool IPs     |                      |
|                      |                      |                      |
|                      | -   Verifies K8s     |                      |
|                      |     node pool IPs    |                      |
+----------------------+----------------------+----------------------+
| AKS Management       | Validates that the   | -   Ensure the host  |
| Cluster              | configuration allows |     has internet     |
| Configuration Proxy  | internet             |     connectivity     |
| connectivity         | connectivity to      |                      |
|                      | Microsoft end-points | -   Follow the       |
|                      | through a Proxy      |     [Proxy Settings  |
|                      | server or without.   |                      |
|                      |                      |    Guide](https://le |
|                      |                      | arn.microsoft.com/en |
|                      |                      | -us/azure/aks/hybrid |
|                      |                      | /set-proxy-settings) |
+----------------------+----------------------+----------------------+
