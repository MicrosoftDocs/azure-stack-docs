---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 02/01/2023
ms.reviewer: alkohli
---

> [!NOTE]
> You need to install and set up the deployment tool only on the first server in the cluster. The deployment tool is included in the Azure Stack HCI Supplemental Package.

1. In the deployment UX, select the **first server listed for the cluster to act as a staging server** during deployment.

1. Sign in to the staging server using local administrative credentials.

1. Copy content from the *Cloud* folder you downloaded previously to any drive other than the C:\ drive.

1. Run PowerShell as administrator.

1. Run the following command to install the deployment tool:

   ```PowerShell
    .\BootstrapCloudDeploymentTool.ps1 
    ```

    This step takes several minutes to complete.

    > [!NOTE]
    > If you manually extracted deployment content from the ZIP file previously, you must run `BootstrapCloudDeployment-Internal.ps1` instead.

To deploy Azure Stack HCI using PowerShell, the following parameters are required to set up and run the deployment tool properly:

|Parameter|Description|
|----|----|
|`JSONFilePath`|Enter the path to your config file. For example, *C:\setup\config.json*.|
|`DeploymentUserCredential`|Specify the Active Directory account username. The username cannot be *Administrator*.|
|`LocalAdminCredential`|Specify the local administrator credentials.|
|`RegistrationCloudName`|Specify the cloud against which you'll authenticate your cluster. In this release, only the `AzureCloud` corresponding to public Azure is supported.|
|`RegistrationRegion`|(Optional) Specify the region that should be used when registering the system with Azure Arc.|
|`RegistrationResourceGroupName`|(Optional) Specify the resource group that will be used to hold the resource objects for the system.|
|`RegistrationResourceName`|(Optional) Specify the name used for the resource object of the Arc resource name for the cluster.|
|`RegistrationSubscriptionID`|Specify the ID for the subscription used to authenticate the cluster to Azure.|
|`RegistrationSPCredential`|Specify the credentials including the App ID and the secret for the Service Principal used to authenticate the cluster to Azure.|

> [!NOTE]
> You must configure the Active Directory permission for the Service Principal following guidance given in [Assign permissions from Azure portal](register-with-azure.md#assign-permissions-from-azure-portal).
