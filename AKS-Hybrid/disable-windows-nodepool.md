---
title: Disable Windows nodepool feature 
description: Learn how to update your Azure Local configuration and disable Windows nodepool feature
ms.topic: how-to
ms.date: 11/18/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: abha
ms.lastreviewed: 11/18/2024

---

# Disable Windows nodepool feature on Azure Local
[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

When you install Azure Local, three virtual hard disks (VHD) - Azure Linux, Windows Server 2019 and Windows Server 2022 are automatically downloaded. VHDs are needed to deploy AKS on Azure Local because they serve as the base operating system images for the Kubernetes nodes within your AKS cluster. For a mixed-OS environment (both Windows and Linux nodes), a Windows Server 2019 or Windows Server 2022 VHD is necessary for provisioning a Windows Server 2019, or 2022 nodepool. The Linux nodepool uses the Azure Linux VHD that's been optimized for running Kubernetes. In environments where only Linux containers are being used, however, the Windows VHD is unnecessary, and disabling the Windows nodepool feature helps avoid downloading and storing this large file, saving bandwidth and storage space.

This how-to guide walks you through how to disable the Windows nodepool feature for Azure Kubernetes Service (AKS) on Azure Local. Disabling this feature prevents the automatic download of Windows Virtual Hard Disks (VHDs), which are approximately 20GB in size and required for creating Windows-based nodepools. By doing so, enterprises with limited internet bandwidth can avoid unnecessary downloads, especially if their workloads are exclusively using Linux containers. This feature helps optimize bandwidth usage and simplifies resource management for environments where Windows nodes are not needed.


## Before you begin

Before you begin, make sure you have the following:
- **Azure Local deployed**: This how-to is only applicable if you already have Azure Local deployed. The commands in this document cannot be run before Azure Local has been deployed. We currently do not offer the ability to make this change before the initial Azure Local deployment.
- **Custom Location ID** - Azure Resource Manager ID of the custom location. The custom location is configured during the Azure Local deployment. If you're on Azure portal, go to the Overview > Server page in the Azure Stack HCI system resource. You should see a custom location for your cluster.
- **Azure resource group** - The Azure resource group where Azure Local has been deployed.
- Azure RBAC permissions to update Azure Stack HCI configuration. Make sure you have the following roles. To learn more, visit [required permissions for deployment](/hci/deploy/deployment-arc-register-server-permissions?tabs=powershell#assign-required-permissions-for-deployment)
     - Azure Stack HCI Administrator
     - Reader

## Set environment variables
To help simplify configuration, the steps below define environment variables that are referenced in this how-to article. Remember to replace the values shown with your own values.

Set the custom location and the resource group values in environment variables.
```azcli
$customlocationID = <The custom location ARM ID for Azure Local>
$resourceGroup = <The Azure resource group where Azure Local has been deployed>
```

Next, run the below command to obtain the clusterName parameter. Its the name of the Arc Resource Bridge that's been deployed on Azure Local.
```
az customlocation show -n $customlocationID -g $resourceGroup --query hostResourceId
```
Expected output:

```output
/subscriptions/f3dwer-00000-4383-2345-00000/resourceGroups/SanJose/providers/Microsoft.ResourceConnector/appliances/sanjose-arcbridge
```

In the above output, "sanjose-arcbridge" is the name of the Arc resource bridge that's been deployed on the Azure local cluster. This name will be different for your deployment.

```azcli
$clusterName = <Name of Arc resource bridge deployed on the Azure Local cluster>
```
Next, you need to obtain the name of the AKS Arc extension that's been deployed to the custom location. To get this, run the following command to list the extensions installed on the custom location.
```azcli
az customlocation show -n $customlocationID -g $resourceGroup --query clusterExtensionIds -o tsv
```
Expected output:

```output
/subscriptions/fbaf508b-cb61-4383-9cda-a42bfa0c7bc9/resourceGroups/SanJose/providers/Microsoft.ResourceConnector/appliances/sanjose-arcbridge/providers/Microsoft.KubernetesConfiguration/extensions/hybridaksextension
/subscriptions/fbaf508b-cb61-4383-9cda-a42bfa0c7bc9/resourceGroups/SanJose/providers/Microsoft.ResourceConnector/appliances/sanjose-arcbridge/providers/Microsoft.KubernetesConfiguration/extensions/vmss-hci
```
You should have two extensions installed on your custom location - AKS Arc and Arc VM management. Copy the extension name for AKS into an environment variable. In my output, the extension name is `hybridaksextension`. It maybe different from what you see.

```azcli
$extensionName = <Name of AKS Arc extension that's been deployed on the custom location>
```

Once you have the extension name, create variables for the following parameters.

```azcli
$extensionVersion = "$(az k8s-extension show -n $extensionName  -g $resourceGroup -c $clusterName --cluster-type appliances --query version -o tsv)"
$releaseTrain = "$(az k8s-extension show -n $extensionName -g $resourceGroup -c $clusterName --cluster-type appliances --query releaseTrain -o tsv)"
```

## Update the AKS Arc extension to disable Windows nodepool feature 

Once you've set the environment variables, you can run the following command from an Azure Shell session to update the AKS Arc k8s extension. This will disable the Windows nodepool feature and delete any associated VHDs.

```azcli
az k8s-extension update --resource-group $resourceGroup --cluster-name $clusterName --cluster-type appliances --name $extensionName --version $extensionVersion --release-train $releaseTrain --config disable-windows-nodepool=true --yes 
```

## Validate if Windows nodepool feature has been disabled

You can check if the configuration settings have been applied by running `az k8s-extension show`, as described below. 

```azcli
az k8s-extension show --name $extensionName --resource-group $resourceGroup --cluster-name $clusterName --cluster-type appliances --query configurationSettings 
```

Expected output:

```
...
"disable-windows-nodepool": "true",
...
```

Next, check if Windows nodepools have been disabled by running the following command.

```
az aksarc get-versions --resource-group $resourceGroup --custom-location $customlocationID
```

The output for `osType=Windows` should say that `"Windows nodepool feature is disabled"` and the `ready` state should be `false`, for each Kubernetes version option.

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
You will have to delete Windows node pool manually before you disable the feature. If there are existing Windows node pools, you will not be able to disable the feature. 

### What happens to downloaded Windows VHDs if I disable Windows node pools? 
The Windows VHDs that have previously been downloaded are automatically deleted if Windows nodepools is disabled. You can verify if Windows VHDs have been removed from the Azure Local storage paths. Note that deletion can take some time. Wait for 30 minutes before checking. You will need to check all the storage paths since Windows VHDs are assigned to storage paths in round robin fashion based on available storage capacity.

## Next steps

- [What's new in AKS on Azure Stack HCI](aks-overview.md)
- [Create AKS clusters](aks-create-clusters-cli.md)
