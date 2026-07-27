---
title:  Deploy an Azure Local cluster via Azure Resource Manager deployment template for confidential VMs (preview)
description: Learn how to deploy a confidential virtual machine (CVM) ready Azure Local cluster by using an Azure Resource Manager deployment template (preview).
author: sipastak
ms.author: sipastak
ms.date: 07/14/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: hyperconverged
---

# Deploy an Azure Local cluster via Azure Resource Manager deployment template for confidential VMs (preview)

::: moniker range=">=azloc-2607"

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to deploy a confidential virtual machine (CVM) ready Azure Local cluster by using an [Azure Resource Manager template deployment for Azure Local](../deploy/deployment-azure-resource-manager-template.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that you meet the following requirements:

- **Validated hardware.** CVM deployment is validated on two Lenovo server configurations that use an AMD Genoa Gen 4 CPU. The following configurations are listed in the Azure Local catalog:

  - ThinkAgile MX455 V3 Edge PR
  - ThinkSystem SR665 V3 Validated Node

  Other Gen 4 systems might work but aren't currently supported.

- **BIOS and UEFI settings.** Apply the BIOS and UEFI settings that enable AMD SEV-SNP functionality on the Lenovo server. To apply the BIOS and UEFI settings, see [Configuring UEFI settings](https://github.com/Azure-Samples/AzureLocal/blob/main/confidential-virtual-machines/CVM_Configuring_UEFI_settings_June20-2026.pdf).

## Deploy the CVM-ready cluster

Prepare the Azure resources by using the same steps as the [Azure Resource Manager template deployment for Azure Local](../deploy/deployment-azure-resource-manager-template.md). You can currently deploy a CVM-ready Azure Local cluster only through the CLI.

To configure the cluster to enable deployment of a CVM, you must include an additional parameter, `confidentialVmIntent`, in the Azure Resource Manager deployment specification. If you don't specify this parameter, CVM creation fails. Setting this parameter might slightly reduce CPU performance for some workloads, on both CVMs and standard VMs.

Include the `confidentialVmIntent` parameter in the ARM template and set it in the ARM template parameter file. Use the `2026-04-01-preview` API version where applicable.

```json
"confidentialVmIntent": {
    "defaultValue": "Disable",
    "type": "string",
    "metadata": {
        "description" : "Customer Intent to update the ConfidentialVm intent on the cluster or edgeDevice, can be Enable or Disable"
    }
},
```

To deploy the cluster:

1. Continue with the deployment steps in [Azure Resource Manager template deployment for Azure Local](../deploy/deployment-azure-resource-manager-template.md). When prompted, select the **create-cluster-CVM-Intent** quickstart template from the dropdown. This template includes the **confidentialVmIntent** field.

    :::image type="content" source="media/confidential-vm-deploy-cluster-via-arm-template/create-cluster-quickstart.png" alt-text="Screenshot of the create cluster quickstart selection in the Azure portal." border="true" lightbox="media/confidential-vm-deploy-cluster-via-arm-template/create-cluster-quickstart.png":::

1. Edit the template with the pertinent values, set **confidentialVmIntent** to **Enable**, and then load the file.
1. Verify that the parameter file has **confidentialVmIntent** set to **Enable**. Alternatively, verify the value in the Azure portal.
1. Select **Review + create** to deploy the cluster.
1. Check the resource JSON to confirm that both `ConfidentialVmIntent` and `ConfidentialVmStatus` in `ConfidentialVmProperties` are enabled.
1. Continue with the remaining steps in [Azure Resource Manager template deployment for Azure Local](../deploy/deployment-azure-resource-manager-template.md).

## Verify cluster deployment

Use the REST API to check whether the cluster deployed successfully with CVM intent. Check the status details for `"ConfidentialVmStatus": "Enabled"`.

```azurecli
az rest --method get --url https://management.azure.com/subscriptions/$subscription/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/clusters/$($clustername)?api-version=2026-04-01-preview
```

Verify the intent you passed to the cluster deployment by checking the properties. Find the property description on the cluster page in the Azure portal.

```json
"ConfidentialVmProperties":{
    "ConfidentialVmIntent": "Enable",
    "ConfidentialVmStatus": "Enabled"
}
```

## Verify the CVM status on individual nodes

Use the REST API to check the CVM status on each node.

```azurecli
az rest --method get --url "https://management.azure.com/subscriptions/$subscription/resourceGroups/$resourceGroup/providers/Microsoft.HybridCompute/machines/$machineName1/providers/Microsoft.AzureStackHCI/edgeDevices/default?api-version=2026-03-01-preview"
```

```json
"reportedProperties":{
    "ConfidentialVmProfile": {
        "igvmStatus":"Enabled",
        "StatusDetails": [
```

When you set the Microsoft Azure Attestation resource details, all nodes report `"igvmStatus": "Enabled"`, and the cluster resource has CVM capability enabled, the cluster deployed successfully.

## Troubleshoot CVM-ready cluster deployment

In addition to the deployment issues described earlier, you might encounter issues specific to CVM cluster deployment. If CVM isn't enabled, first verify that all required BIOS settings are configured correctly and reboot the affected node before continuing with troubleshooting.

If `"ConfidentialVmStatus"` is `PartiallyEnabled` or `Disabled` and `"ConfidentialVmIntent"` is `Enabled`, identify the faulty nodes by going to each individual node using the REST API:

```
az rest --method get --url https://management.azure.com/subscriptions/$subscription/resourceGroups/$resourceGroup/providers/Microsoft.HybridCompute/machines/$machineName1/providers/Microsoft.AzureStackHCI/edgeDevices/default?api-version=2026-03-01-preview%22
```

A node that isn't deployed correctly returns:

```json
"reportedProperties":{
    "ConfidentialVmProfile": {
        "igvmStatus":"Disabled",
        "StatusDetails": [
```

## Day N CVM enablement deployment

Use this Day N scenario to enable CVM intent on a cluster that meets all the CVM prerequisites but didn't have CVM intent enabled during deployment.

1. Enable CVM intent on the cluster by running this command:

    ```powershell
    $subscriptionId = "<subscription-id>"
    $resourceGroup = "<resource-group-name>"
    $clusterName = "<cluster-name>"
    
    $path = "/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/Clusters/$clusterName/jobs/ConfigureCVM?api-version=2026-04-01-preview"  
    
    $body = @{ 
        properties = @{ 
            jobType            = "ConfigureCVM" 
            deploymentMode     = "Deploy" 
            confidentialVmIntent = "Enable" 
        } 
    } | ConvertTo-Json 
    
    Invoke-AzRestMethod -Method PUT -Path $path -Payload $body
    ```

1. Go to your cluster and check the activity logs to confirm that the script is running in the background.

1. After the job succeeds, return to your deployment VM (DVM) terminal and run this command:

    ```azurecli
    az rest --method get --url https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.AzureStackHCI/clusters/$($clusterName)?api-version=2026-04-01-preview
    ```

1. Confirm that `ConfidentialVmIntent` is now set to `Enable` on the cluster.

## Next steps

- [Create and deploy an integrity-protected VM image](confidential-vm-create-deploy-integrity-protected-vm-image.md)

::: moniker-end

::: moniker range="<=azloc-2606"

This feature is available only in Azure Local 2607 or later.

::: moniker-end

