---
title: Troubleshoot Azure Arc VM management (preview)
description: Learn how to troubleshoot Azure Arc VM management (preview)
author: alkohli
ms.topic: how-to
ms.date: 10/31/2023
ms.author: alkohli
ms.reviewer: JasonGerend
---

# Troubleshoot Azure Arc VM management (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article provides guidance on how to collect logs and troubleshoot issues with Azure Arc virtual machines (VMs) in your Azure Stack HCI cluster. It also lists the limitations and known issues that currently exist with Azure Arc VM management.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Collect logs

You can collect logs to identify and troubleshoot issues with Arc VMs in your Azure Stack HCI system. Use these logs to gather key information before you contact Microsoft support for additional help.

Make sure you have the latest PowerShell module for log collection. To update the PowerShell module, run the following command:

```PowerShell
#Update the PowerShell module
Install-Module -Name ArcHci -Force -Confirm:$false -SkipPublisherCheck -AcceptLicense
```

To collect logs for Arc VMs in your Azure Stack HCI cluster, run the following command:

```PowerShell
$csv_path="<input-from-admin>"
$VMIP_1="<input-from-admin>"
az login --use-device-code
Get-ArcHCILogs -workDirectory $csv_path\ResourceBridge -kvaTokenPath $csv_path\ResourceBridge\kvatoken.tok -ip $VMIP_1
```

where:

- **$csv_path** is the full path of the cluster shared volume provided for creating Arc Resource Bridge.

- **$VMIP_1** is the IP address of the Arc Resource Bridge VM.

- Optionally, set the `-logDir` parameter to specify the path to the directory where the generated logs are stored. If you don't specify the path or the parameter, by default the logs are stored in your current working directory.

## Troubleshoot Azure Arc VMs

This section describes the errors related to Azure Arc VM management and their recommended resolutions.

### Permission denied error when you run the arcappliance prepare command

If your PowerShell session doesn't have write permissions in the folder from where you run the `az arcapplicance prepare` command, it fails with the following error:

**Error:** `Appliance prepare command failed with error:  [Errno 13] Permission denied: 'debug_infra.yaml'`

Here's an example output when your PowerShell session doesn't have permissions to write in the `C:\ClusterStorage` folder:

:::image type="content" source="./media/manage-azure-arc-vm/arc-appliance-prepare-error.png" alt-text="Screenshot of the arcappliance prepare error." lightbox="./media/manage-azure-arc-vm/arc-appliance-prepare-error.png" :::

**Resolution:** Go to your home directory and rerun the `az arcapplicance prepare` command.

### Azure CLI installation isn't recognized

If your environment fails to recognize Azure CLI after installing it, run the following code block to add the Azure CLI installation path to the environment path.

```PowerShell
        if ( -not( $env:PATH -like '*C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin*') ) {
            $env:PATH += "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
            Write-Host "Updated path $env:PATH"
        }
```

### KVA timeout error

Azure Arc Resource Bridge is a Kubernetes management cluster that is deployed in an Arc Resource Bridge VM directly on the on-premises infrastructure. While trying to deploy Azure Arc resource bridge, a "KVA timeout error" might appear if there's a networking problem that doesn't allow communication of the Arc Resource Bridge VM to the host, DNS, network or internet. This error is typically displayed for the following reasons:

- The Arc Resource Bridge VM ($VMIP) doesn't have DNS resolution.
- The Arc Resource Bridge VM ($VMIP) or $controlPlaneIP don't have internet access.
- The host isn't able to reach $controlPlaneIP or $VMIP.

To resolve this error, ensure that all IP addresses assigned to the Arc Resource Bridge VM can be resolved by DNS and have access to the internet, and that the host can successfully route to the IP addresses.

### Valid token required error

The expiration of the MOC token might result in a failure to create VMs, virtual hard disks, virtual NICs, or other entities. The error in ArcHCI logs could be "Valid token required" or a variation of that. To resolve this error, run the following command on any server in your Azure Stack HCI cluster:
```PowerShell
        rmdir $env:USERPROFILE\.wssd\python -Recurse -Force
        Repair-MOC
        Repair-MocOperatorToken
```


## Limitations and known issues

Here's a list of existing limitations and known issues with Azure Arc VM management:

- Resource name must be unique for an Azure Stack HCI cluster and must contain only alphabets, numbers, and hyphens.

- Arc Resource Bridge provisioning through command line must be performed on a local HCI server PowerShell. It can't be done in a remote PowerShell window from a machine that isn't a host of the Azure Stack HCI cluster. To connect on each node of the Azure Stack HCI cluster, use Remote Desktop Protocol (RDP) connected with a domain user admin of the cluster.

- You must deploy Azure Kubernetes and Arc VMs on the same Azure Stack HCI cluster in the following order:
    1. Deploy AKS management cluster
    1. Deploy Arc Resource Bridge for Arc VMs

        > [!NOTE]
        > If Arc Resource Bridge is already deployed, don't deploy the AKS management cluster unless the Arc Resource Bridge is removed.

- You must uninstall AKS management cluster and Arc Resource Bridge in the following order:
    1. Uninstall Arc Resource Bridge
    1. Uninstall AKS management cluster

        > [!NOTE]
        > Uninstalling the AKS management cluster can impair Arc VM management capabilities. You can deploy a new Arc Resource Bridge again after cleanup, but it won't remember the VM entities created previously.

- VMs provisioned from Windows Admin Center, PowerShell, or other Hyper-V management tools aren't visible in the Azure portal for management.

- You must update Arc VMs on Azure Stack HCI only from the Azure management plane. Any modifications to these VMs from other management tools aren't updated in the Azure portal.

- Arc VMs must be created in the same Azure subscription as the Custom location.

- An IT administrator can't view or manage VMs from cluster resource page in the Azure portal, if they are created in a subscription where the IT administrator doesn't have at least read-only access role.

- If the Arc for servers agents are installed on VMs provisioned through the Azure portal, there will be two projections of the VMs on the Azure portal.

- Arc VM management is currently not available for stretched cluster configurations on Azure Stack HCI.

- Support for Arc Resource Bridge and Arc VM Management is currently available only in English language.

- Using an Azure Arc Resource Bridge behind a proxy is supported. However, using Azure Arc VMs behind a network proxy isn't supported.

- Naming convention for Azure resources, such as logical networks, gallery images, custom location, Arc Resource Bridge must follow the guidelines listed in [Naming rules and restrictions for Azure resources](/azure/azure-resource-manager/management/resource-name-rules).

## Next steps

- [VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-vm-management-overview.md)
- [Azure Arc VM management FAQs](./azure-arc-vms-faq.yml)
