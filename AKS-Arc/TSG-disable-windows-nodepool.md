---
title: TSG to disable the Windows nodepool feature 
description: TSG to disable the Windows nodepool feature prior to 2509 release
ms.topic: how-to
ms.date: 09/25/2025
author: rcheeran
ms.author: rcheeran 
ms.reviewer: sethm
ms.lastreviewed: 09/25/2025

---

# Disable the Windows nodepool feature on Azure Local versions lesser than 2509

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

> [!IMPORTANT]
>The Windows node pool feature disabled by default in Azure Local release 2509 and later. Use this TSG only if you are using an Azure Local version lesser than 2509. For versions 2509 and above refer to this [document](./howto-enable-windows-node-pools.md).

This how-to article walks you through how to disable the Windows nodepool feature for Azure Kubernetes Service (AKS) on Azure Local versions 2508 and earlier. Disabling this feature prevents the automatic download of Windows Virtual Hard Disks (VHDs), which are approximately 20 GB in size and required for creating Windows-based nodepools. By doing so, enterprises with limited internet bandwidth can avoid unnecessary downloads, especially if their workloads are exclusively using Linux containers. This helps optimize bandwidth usage and simplifies resource management for environments where Windows nodes aren't needed.

## Before you begin

Before you begin, make sure you have the following prerequisites in place:

- **Azure Local deployed**. This article is only applicable if you already deployed Azure Local, release 2411. You can't run the commands in this article before you deploy Azure Local release 2411. We currently don't support the ability to make this change before the initial Azure Local release 2411 deployment.
- **Azure RBAC permissions to update Azure Local configuration**. Make sure you have the following roles. For more information, see [required permissions for deployment](/azure/azure-local/deploy/deployment-arc-register-server-permissions?tabs=powershell#assign-required-permissions-for-deployment):
  - Azure Local Administrator
  - Reader
- **Custom Location**. Name of the custom location. The custom location is configured during the Azure Local deployment. If you're in the Azure portal, go to the **Overview > Server** page in the Azure Local system resource. You should see a custom location for your cluster.
- **Azure resource group**. The Azure resource group in which Azure Local is deployed.

## Recommended option: disable Windows nodepool from an Azure CloudShell session

To help simplify configuration, the following steps define environment variables that are referenced in this article. Remember to replace the values shown with your own values.

Set the custom location and the resource group values in environment variables:

```azurecli
$customlocationName = <The custom location name for Azure Local>
$resourceGroup = <The Azure resource group in which Azure Local is deployed>
```

Next, run the following command to obtain the `clusterName` parameter. This parameter is the name of the Arc Resource Bridge that you deployed on Azure Local:

```azurecli
az customlocation show -n $customlocationName -g $resourceGroup --query hostResourceId
```

Expected output:

```output
/subscriptions/f3dwer-00000-4383-2345-00000/resourceGroups/SanJose/providers/Microsoft.ResourceConnector/appliances/sanjose-arcbridge
```

In this output, `sanjose-arcbridge` is the name of the Arc resource bridge you deployed on the Azure local cluster. This name is different for your deployment.

```azurecli
$clusterName = <Name of Arc resource bridge deployed on the Azure Local cluster>
```

Next, obtain the name of the AKS Arc extension you deployed to the custom location. To get this name, run the following command to list the extensions installed on the custom location:

```azurecli
az customlocation show -n $customlocationID -g $resourceGroup --query clusterExtensionIds -o tsv
```

Expected output:

```output
/subscriptions/fbaf508b-cb61-4383-9cda-a42bfa0c7bc9/resourceGroups/SanJose/providers/Microsoft.ResourceConnector/appliances/sanjose-arcbridge/providers/Microsoft.KubernetesConfiguration/extensions/hybridaksextension
/subscriptions/fbaf508b-cb61-4383-9cda-a42bfa0c7bc9/resourceGroups/SanJose/providers/Microsoft.ResourceConnector/appliances/sanjose-arcbridge/providers/Microsoft.KubernetesConfiguration/extensions/vmss-hci
```

You should have two extensions installed on your custom location: AKS Arc and Arc VM management. Copy the extension name for AKS into an environment variable. In the example output, the extension name is `hybridaksextension`. It might be different from what you see:

```azurecli
$extensionName = <Name of AKS Arc extension you deployed on the custom location>
```

After you have the extension name, create variables for the following parameters, and then disable the Windows nodepool feature:

```azurecli
$extensionVersion = "$(az k8s-extension show -n $extensionName  -g $resourceGroup -c $clusterName --cluster-type appliances --query version -o tsv)"
$releaseTrain = "$(az k8s-extension show -n $extensionName -g $resourceGroup -c $clusterName --cluster-type appliances --query releaseTrain -o tsv)"
az k8s-extension update --resource-group $resourceGroup --cluster-name $clusterName --cluster-type appliances --name $extensionName --version $extensionVersion --release-train $releaseTrain --config disable-windows-nodepool=true --yes
```

## Alternate option: disable Windows nodepool after connecting to an Azure Local physical node via Remote Desktop

If for some reason you're not able to use Azure CloudShell or a machine with connectivity to Azure in order to disable Windows nodepool, you can disable Windows nodepool after connecting to any one of the Azure Local physical nodes with Remote Desktop. You must first sign in to Azure.

```powershell
az login --use-device-code --tenant <Azure tenant ID>
 
az account set -s <subscription ID>
 
$res=get-archcimgmt
 
az k8s-extension update --resource-group $res.HybridaksExtension.resourceGroup --cluster-name $res.ResourceBridge.name --cluster-type appliances --name $res.HybridaksExtension.name --version $res.HybridaksExtension.version --release-train  $res.HybridaksExtension.releaseTrain --config disable-windows-nodepool=true --yes 
```

### Validate if the Windows nodepool feature is disabled

You can check if the configuration settings were applied by running `az k8s-extension show`, as follows:

```azurecli
az k8s-extension show --name $extensionName --resource-group $resourceGroup --cluster-name $clusterName --cluster-type appliances --query configurationSettings 
```

Expected output:

```output
...
"disable-windows-nodepool": "true",
...
```

Next, check if Windows nodepools were disabled by running the following command:

```azurecli
az aksarc get-versions --resource-group $resourceGroup --custom-location $customlocationName
```

The output for `osType=Windows` should say "Windows nodepool feature is disabled" and the `ready` state should be `false`, for each Kubernetes version option:

```output
...
"1.27.7": {
            "readiness": [
              {
                "errorMessage": null,
                "osSku": "CBLMariner",
                "osType": "Linux",
                "ready": true
              },
              {
                "errorMessage": "Windows nodepool feature is disabled",
                "osSku": "Windows2019",
                "osType": "Windows",
                "ready": false
              },
              {
                "errorMessage": "Windows nodepool feature is disabled",
                "osSku": "Windows2022",
                "osType": "Windows",
                "ready": false
              }
            ],
...
```

## FAQ

### What happens if I try disabling Windows nodepool and Windows node pools exist on atleast 1 AKS cluster on the Azure local deployment?

You must delete the Windows nodepool manually before you disable the feature. If there are existing Windows nodepools, you can't disable the feature.

### What happens to downloaded Windows VHDs if I disable Windows node pools?

The Windows VHDs that were previously downloaded are automatically deleted if the Windows nodepools feature is disabled. You can verify if Windows VHDs were removed from the Azure Local storage paths. Deletion can take some time. Wait 30 minutes before checking. You must check all the storage paths, because Windows VHDs are assigned to storage paths in round-robin fashion, based on available storage capacity.

## Next steps

- [Enable or Disable Windows node pools on versions 2509 and above](./howto-enable-windows-node-pools.md)
- [Troubleshoot and known issues](./aks-troubleshoot.md)
