---
title: Troubleshoot CredSSP
description: Learn how to troubleshoot CredSSP
author: jasongerend
ms.topic: how-to
ms.date: 06/04/2021
ms.author: jgerend
ms.reviewer: JasonGerend
---

# Troubleshoot Arc-enabled virtual machines

If you experience issues with your Arc-enabled virtual machines (VMs), this article will help you with debugging and troubleshooting the issue. It also describes the limitations and known issues that currently exist.
 
> Applies to: Azure Stack HCI, versions 21H2

## Debugging

See the support topics for any errors and their remedial steps. If the error condition is not mentioned or you need additional help, contact Microsoft support.

Collect diagnostics information before contacting Microsoft support as they may ask for it.

You can get logs from the cluster using the `Get-ArcHCILogs` cmdlet. It will require the CloudServiceIP and the path containing HCI login configuration.

- The CloudServiceIP is the IP address of the cloud service agent that is running in the Arc Resource Bridge. This was provided at the time of provisioning the Arc Resource Bridge.
- You can find the login configuration file under the following path:
$csv_path\workingDir\kvatoken.tok. 
Please provide the absolute file path name.
- Optionally, you may provide parameter `-logDir` to provide path to the directory where generated logs will be saved. If not provided, the location defaults to the current working directory.

## Limitations and known issues

- All resource names should use lower case alphabets, numbers and hypens only. The resource names must be unique for an Azure Stack HCI cluster.
- Arc Resource Bridge provisioning through CLI should be performed on a local HCI server PowerShell. It can't be done in a remote PowerShell window from a machine that isn't a host of the Azure Stack HCI cluster. To connect on each node of the Azure Stack HCI cluster, use RDP connected with a domain user admin of the cluster.
- Enabling Azure Kubernetes and Arc-enabled Azure Stack HCI for VMs on the same Azure Stack HCI cluster requires the following deployment order:
      - First, the AKS management cluster.
      - And then, Arc Resource Bridge for Arc-enabled VMs.
If Arc Resource Bridge is already deployed, the AKS management cluster should not be deployed unless the Arc Resoure Bridge has been removed.

While deploying Arc Resource bridge when AKS management cluster is available on the cluster, you don't need to perform the following steps:
**new-MocNetworkSetting**, **set-MocConfig** and **install-Moc**.

Uninstallation of these features should also be done in the following order:
      - Uninstall Arc Resource Bridge.
      - Then, uninstall the AKS management cluster.
Uninstalling the AKS management cluster can impair Arc VM management capabilities. You can deploy a new Arc Resource Bridge again after cleanup, but it will not remember the VM entities that were created earlier.

- VMs provisioned from Windows Admin Center, PowerShell or other HyperV management tools will not be visible in portal for management.
- Updating Arc VMs on Azure Stack HCI must be done from Azure management plane only. Any modifications to these VMs from other management tools will not be updated in Azure portal.
- Arc VMs must be created in the same Azure subscription as the Custom location.
- An IT admininstrator will not be able to view or manage VMs from cluster resource page in Azure portal, if they are created in a subscription where the IT administrator does not have at least read-only access role.
- If the Arc for servers agents are installed on VMs provisioned through Azure portal, there will be two projections of the VMs on Azure Portal.
- Arc VM Management is currently not available for stretched cluster configurations on Azure Stack HCI.
    ```

## Next steps

[VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-enabled-virtual-machines.md)
[Azure Arc-enabled Azure Stack HCI FAQs](faqs-arc-enabled-vms.md)
