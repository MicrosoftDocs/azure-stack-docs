---
title: Troubleshoot Azure Arc VM management (preview)
description: Learn how to troubleshoot Azure Arc VM management (preview)
author: ManikaDhiman
ms.topic: how-to
ms.date: 03/24/2022
ms.author: v-mandhiman
ms.reviewer: JasonGerend
---

# Troubleshoot Azure Arc VM management (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article provides guidance on how to debug issues that you might encounter when using Azure Arc virtual machines (VMs). It also describes the limitations and known issues that currently exist.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Troubleshoot and debug

See the support topics for any errors and their remedial steps. If the error condition is not mentioned or you need additional help, contact Microsoft support.

Collect diagnostics information before contacting Microsoft support as they may ask for it.

For issues related to Arc VM management, you can generate logs from the cluster using the following command:

> [!NOTE]
> Make sure that you have the latest PowerShell module for log collection.
>```PowerShell
> #Update the PowerShell module
> Install-Module -Name ArcHci -Force -Confirm:$false -SkipPublisherCheck -AcceptLicense
>```

```PowerShell
$csv_path="<input-from-admin>"
$VMIP="<input-from-admin>"
Get-ArcHCILogs -workDirectory $csv_path\ResourceBridge -kvaTokenPath $csv_path\ResourceBridge\kvatoken.tok -ip $VMIP
```

**$csv_path** is the full path of the cluster shared volume provided for creating Arc Resource Bridge.

**$VMIP** is the IP address of the Arc Resource Bridge virtual machine.

Optionally, you can provide the `-logDir` parameter, to provide the path to the directory in which generated logs will be saved. If you don't provide either the path or parameter, the location defaults to the current working directory.

## Permission denied error when running the arcappliance prepare command

If your PowerShell session doesn't have write permissions in the folder from where you run the `az arcapplicance prepare` command, it fails with the following error:

**Error:** `Appliance prepare command failed with error:  [Errno 13] Permission denied: 'debug_infra.yaml'`

Here's an example output when your PowerShell session doesn't have permissions to write in the `C:\ClusterStorage` folder:

:::image type="content" source="./media/manage-azure-arc-vm/arc-appliance-prepare-error.png" alt-text="Screenshot of the arcappliance prepare error." lightbox="./media/manage-azure-arc-vm/arc-appliance-prepare-error.png" :::

**Resolution:** Go to your home directory and rerun the `az arcapplicance prepare` command.

## KVA timeout error

Azure Arc Resource Bridge is a Kubernetes management cluster that is deployed in an Arc Resource Bridge VM directly on the on-premises infrastructure. While trying to deploy Azure Arc resource bridge, a "KVA timeout error" may appear if there's a networking problem that doesn't allow communication of the Arc Resource Bridge VM to the host, DNS, network or internet. This error is typically displayed for the following reasons:

- The Arc Resource Bridge VM ($VMIP) doesn't have DNS resolution.
- The Arc Resource Bridge VM ($VMIP) or $controlPlaneIP don't have internet access.
- The host isn't able to reach $controlPlaneIP or $VMIP.

To resolve this error, ensure that all IP addresses assigned to the Arc Resource Bridge VM can be resolved by DNS and have access to the internet, and that the host can successfully route to the IP addresses.
 
## Limitations and known issues

- Resource name must be unique for an Azure Stack HCI cluster and must contain only alphabets, numbers, and hyphens.
- Arc Resource Bridge provisioning through command line must be performed on a local HCI server PowerShell. It can't be done in a remote PowerShell window from a machine that isn't a host of the Azure Stack HCI cluster. To connect on each node of the Azure Stack HCI cluster, use Remote Desktop Protocol (RDP) connected with a domain user admin of the cluster.
- Azure Kubernetes and Arc VMs on the same Azure Stack HCI cluster must be enabled in the following deployment order:

    1. Deploy AKS management cluster
    1. Deploy Arc Resource Bridge for Arc VMs

    > [!NOTE]
    > If Arc Resource Bridge is already deployed, you should not deploy the AKS management cluster unless the Arc Resource Bridge is removed.


- You must uninstall these in the following order:

    1. Uninstall Arc Resource Bridge
    1. Uninstall the AKS management cluster

    > [!NOTE]
    > Uninstalling the AKS management cluster can impair Arc VM management capabilities. You can deploy a new Arc Resource Bridge again after cleanup, but it will not remember the VM entities that were created earlier.

- If your environment fails to recognize Azure CLI after installing it, please run the following code block to add the Azure CLI installation path to the environment path.

```PowerShell
        if ( -not( $env:PATH -like '*C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin*') ) {
            $env:PATH += "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
            Write-Host "Updated path $env:PATH"
        }
```
- VMs provisioned from Windows Admin Center, PowerShell, or other Hyper-V management tools are not visible in the Azure portal for management.
- You must update Arc VMs on Azure Stack HCI only from the Azure management plane. Any modifications to these VMs from other management tools are not updated in the Azure portal.
- Arc VMs must be created in the same Azure subscription as the Custom location.
- An IT administrator can't view or manage VMs from cluster resource page in the Azure portal, if they are created in a subscription where the IT administrator does not have at least read-only access role.
- If the Arc for servers agents are installed on VMs provisioned through the Azure portal, there will be two projections of the VMs on the Azure portal.
- Arc VM management is currently not available for stretched cluster configurations on Azure Stack HCI.
- Support for Arc Resource Bridge & Arc VM Management is currently available only in English language.
- Adding a server to an HCI cluster does not install Arc components automatically.
- Naming convention for Azure resources such as virtual networks, gallery images, custom location, Arc Resource Bridge etc. should follow [these guidelines](/azure/azure-resource-manager/management/resource-name-rules).

## Next steps

- [VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-vm-management-overview.md)
- [Azure Arc VM management FAQs](faqs-arc-enabled-vms.md)
