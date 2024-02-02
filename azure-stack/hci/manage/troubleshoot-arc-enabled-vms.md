---
title: Troubleshoot Azure Arc VM management
description: Learn how to troubleshoot Azure Arc VM management
author: alkohli
ms.topic: how-to
ms.date: 01/30/2024
ms.author: alkohli
ms.reviewer: vlakshmanan
---

# Troubleshoot Azure Arc VM management

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article provides guidance on how to collect logs and troubleshoot issues with Azure Arc virtual machines (VMs) in your Azure Stack HCI cluster. It also lists the limitations and known issues that currently exist with Azure Arc VM management.


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

### Failure when trying to enable guest management

When trying to run the command to enable guest management, you see the following error:

**Error:** `Deployment failed. Correlation ID: 5d0c4921-78e0-4493-af16-dffee5cbf9d8. VM Spec validation failed for guest agent provisioning: Invalid managed identity. A system-assigned managed identity must be enabled in parent resource: Invalid Configuration`

The above failure is because the managed identity was not created for this VM. System-assigned Managed Identity is required to enable guest management.

**Resolution:**  

Follow these steps to verify that the Managed Identity is not created for this VM and then enable System-assigned Managed Identity.

1. In the Azure portal, go to the VM. Browse to the **Overview** page. On the **Properties** tab, under **Configuration**, the **Guest management** should show as **Disabled**. Select the **JSON View** from the top right corner.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-1.png" alt-text="Screenshot of how to get to JSON view." lightbox="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-1.png":::

1. Under `Identity` parameter, the `type` should show as `None`.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-2.png" alt-text="Screenshot of JSON view indicating the Managed Identity is absent." lightbox="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-2.png":::

1. To create managed identity, connect to the Azure Stack HCI server via RDP. Run the following command:
    
    ```azurecli
    az extension add --name connectedmachine
    ```

1. Verify that the connected machine CLI extension is installed on the cluster. Here's a sample output with the extension successfully installed. The `connectedmachine` indicates that version 0.7.0 is installed.
    
    ```output
    [v-hostl]: PS C:\Clusterstorage\lnfrastructure_l\ArcHci> az version
    {
    "azure-cli": "2.53.0",
    "azure-cli-core": "2.53.0",
    "azure-cli-telemetry": "1.1.0",
    "extensions": {
        "akshybrid": "0.1.1",
        "arcappliance"^ "1.0.2”,
        "connectedk8s": "1.5.4",
        "connectedmachine": "0.7.0",
        "customlocation": "0.1.3",
        "hybridaks": "0.2.4",
        "k8s-extension": "1.4.5",
        "stack-hci-vm": “0.1.8"
        }
    }
    [v-hostl]: PS C:\ClusterStorage\Infrastructure_l\ArcHci>
        ```
1. Run the following command to assign a system managed identity to the VM.

    ```azurecli
    az connectedmachine update --ids "<ARM ID for the VM>" --set identity.type="SystemAssigned"
    ```

1. Go to the Azure portal and browse to the **Overview** page. The **JSON View** should indicate that the system managed identity is now assigned to the VM.

    :::image type="content" source="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-3.png" alt-text="Screenshot of JSON view when Managed Identity is enabled." lightbox="./media/troubleshoot-arc-enabled-vms/managed-identity-missing-3.png":::  


### Azure CLI installation isn't recognized

If your environment fails to recognize Azure CLI after installing it, run the following code block to add the Azure CLI installation path to the environment path.

```PowerShell
        if ( -not( $env:PATH -like '*C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin*') ) {
            $env:PATH += "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\wbin;"
            Write-Host "Updated path $env:PATH"
        }
```


<!--## Limitations and known issues

Here's a list of existing limitations and known issues with Azure Arc VM management:

- Resource name must be unique for an Azure Stack HCI cluster and must contain only alphabets, numbers, and hyphens.

- VMs provisioned from Windows Admin Center, PowerShell, or other Hyper-V management tools aren't visible in the Azure portal for management.

- You must update Arc VMs on Azure Stack HCI only from the Azure management plane. Any modifications to these VMs from other management tools aren't updated in the Azure portal.

- Arc VMs must be created in the same Azure subscription as the Custom location.

- An IT administrator can't view or manage VMs from cluster resource page in the Azure portal, if they are created in a subscription where the IT administrator doesn't have at least read-only access role.

- If the Arc for servers agents are installed on VMs provisioned through the Azure portal, there will be two projections of the VMs on the Azure portal.

- Arc VM management is currently not available for stretched cluster configurations on Azure Stack HCI.

- Support for Arc Resource Bridge and Arc VM Management is currently available only in English language.

- Azure Arc Linux VMs aren't supported behind a network proxy.

- Naming convention for Azure resources, such as logical networks, gallery images, custom location, Arc Resource Bridge must follow the guidelines listed in [Naming rules and restrictions for Azure resources](/azure/azure-resource-manager/management/resource-name-rules).-->

## Next steps

- [Azure Arc VM management FAQs](./azure-arc-vms-faq.yml)
