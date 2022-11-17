---
title: Arc-connected AKS on Windows
description: Connect your AKS on Windows clusters to Arc
author: rcheeran
ms.author: rcheeran
ms.topic: how-to
ms.date: 11/07/2022
ms.custom: template-how-to
---

# Connect your AKS on Windows cluster to Arc

This section shows how to connect your AKS-IoT cluster to [Azure Arc](/azure/azure-arc/kubernetes/overview) so that you can monitor the health of your cluster on the Azure portal.

> [!IMPORTANT]
> If you do not have a cluster installed, create a [single node cluster](aks-lite-howto-single-node-deployment.md) and follow the steps to deploy.

## Prerequisites

You need an Azure subscription with either the `Owner` role or a combination of `Contributor` and `User Access Administrator` roles. You can check your access level by navigating to your subscription, clicking on **Access control (IAM)** on the left-hand side of the Azure portal, and then clicking on **View my access**. Read the [official Azure documentation](/azure/azure-resource-manager/management/manage-resource-groups-portal) for more information about managing resource groups.

Execute the following steps on your primary machine.

>[!IMPORTANT]
> If you are connecting a multi-node cluster to Arc, enable the Arc connection to the cluster before scaling out to additional nodes.

>[!NOTE]
> If you are using PowerShell 7 with the new API to connect to Arc, [see this article](./aks-lite-howto-more-configs.md) for the instructions.

## 1. Configure your Azure environment

In your GitHub repo, open the **aide-userconfig.json** file from the **tools** folder.

```shell
notepad.exe aide-userconfig.json
```

There, add the parameters under **Azure**, with the appropriate information.

```json
"Azure": {
    "SubscriptionName":"Visual Studio Enterprise Subscription",
    "SubscriptionId": "",
    "TenantId":"",
    "ResourceGroupName": "aksiotpreview-rg",
    "ServicePrincipalName" : "aksiot-sp",
    "Location" : "EastUS",
    "ClusterName": "",
    "Auth": {
        "spId" : "",
        "password" : ""
    }
}
```

>[!NOTE]
> For the `Location` field above, choose the location closest to your deployment.

>[!NOTE]
> If you want to use an existing service principal instead of creating a new one, specify your service principal ID and password under `Auth`. Read more about configuring the JSON parameters in the README file from the GitHub repo.

To set up your Azure subscription and create the necessary resource group and service principal, use the **AksEdgeAzureSetup.ps1** script from the GitHub repo. This script will prompt you to log in with your credentials for setting up your Azure subscription.

```powershell
# prompts for interactive login for serviceprincipal creation with minimal privileges
..\tools\AksEdgeAzureSetup\AksEdgeAzureSetup.ps1 .\aide-userconfig.json
```

If you need to create the service principal with **Contributor** role at the resource group level, you can add the `-spContributorRole` switch.

```powershell
# creates service principal with Contributor role at resource group level
..\tools\AksEdgeAzureSetup\AksEdgeAzureSetup.ps1 .\aide-userconfig.json -spContributorRole
```

To reset an already existing service principal, use `-spCredReset`. You should use reset carefully.

```powershell
# resets the existing service principal
..\tools\AksEdgeAzureSetup\AksEdgeAzureSetup.ps1 .\aide-userconfig.json -spCredReset
```

Once the JSON has been updated, run `Read-AideUserConfig` to read the updated JSON configuration. You can verify the values using `Get-AideUserConfig`. Alternatively, you can reopen **AksEdgePrompt.cmd** to use the updated JSON configuration.

```powershell
Read-AideUserConfig
Get-AideUserConfig
```

> [!IMPORTANT]
> Any time you modify **aide-userconfig.json** (or **aksiot-userconfig.json**), run `Read-AideUserConfig` to reload, or close and re-open **AksEdgePrompt.cmd**.

| Attribute | Value type      |  Description |
| :------------ |:-----------|:--------|
|`SubscriptionName` | string | The name of your Azure subscription. You can find this on the Azure portal.|
|`ResourceGroupName` | string | The name of the Azure resource group to host your Azure resources for AKS edge.|
|`ServicePrincipalName` | string | The name of the Azure Service Principal to use as credentials. AKS uses this Service Principal to connect your cluster to Arc.|
|`Location` | string | The location in which to create your resource group. Leave this as `EastUS`. |
|`ClusterName` | string | The name of the cluster for the Arc Connection. The default is `hostname-distribution` (`abc-k8s` or `abc-k3s`). |

## 2. Connect your cluster to Arc

> [!IMPORTANT]
> If you already have Azure CLI installed, run `az upgrade` to ensure your **azure-cli** and extensions are up-to-date.

```cmd
az upgrade
```

```json
{
  "azure-cli": "2.39.0",
  "azure-cli-core": "2.39.0",
  "extensions": {
    "connectedk8s": "1.3.1",
    "connectedmachine": "0.5.1",
    "customlocation": "0.1.3",
    "k8s-extension": "1.3.3"
  }
}
```

1. Run `Initialize-ArcIot`. This installs Azure CLI (if not already installed), signs in to Azure with the given credentials, and validates the Azure configuration (resource providers and resource group status).

   ```powershell
   Initialize-ArcIot
   ```

2. Run `Connect-ArcIotK8s` to connect the cluster to Arc. This signs in using your service principal, enables the cluster-connect features to view your cluster's Kubernetes resources in Arc, and generates a bearer token named **servicetoken.txt** in the **tools** folder.

   ```powershell
   Connect-ArcIotK8s
   ```

   This step can take a while and PowerShell may be stuck on "Establishing Azure Connected Kubernetes for `your cluster name`", but if you navigate to your resource group on the Azure portal, you should see your cluster as a resource. When the PowerShell command is finished running, click on your cluster.

   ![Screenshot showing the cluster in azure portal](media/aks-lite/cluster-in-az-portal.png)

## 3. View cluster resources

1. On the left panel, select the **Namespaces** blade under **Kubernetes resources (preview)**.

   ![Kubernetes resources preview.](media/aks-lite/kubernetes-resources-preview.png)

2. To view your Kubernetes resources, you need a bearer token.

   ![Screenshot showing the bearer token required page.](media/aks-lite/bearer-token-required.png)

3. Go to your **../tools/servicetoken.txt** file, copy the full string, and paste it into the Azure portal.

   ![Screenshot showing where to paste token in portal.](media/aks-lite/bearer-token-in-portal.png)

4. Now you can look at resources on your cluster. This is the **Workloads** blade, showing the same as `kubectl get pods --all-namespaces`:

   ![all pods shown in arc](media/aks-lite/all-pods-in-arc.png)

## Disconnect from Arc

Run `Disconnect-ArcIotK8s` to disconnect your cluster from Azure Arc. For a complete clean-up, delete the service principal and resource group you created for this example.

```powershell
Disconnect-ArcIotK8s
```

## Next steps

- Try other Arc-enabled services as described [here](aks-lite-howto-enable-arc-services.md)
- [Overview](aks-lite-overview.md)
- [Uninstall AKS cluster](aks-lite-howto-uninstall.md)
