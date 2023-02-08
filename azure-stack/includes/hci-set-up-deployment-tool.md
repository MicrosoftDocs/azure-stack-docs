---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 02/01/2023
ms.reviewer: alkohli
---

1. Run PowerShell as administrator.

1. Run the following command to install the deployment tool:

   ```PowerShell
    .\BootstrapCloudDeploymentTool.ps1 
    ```

    This step takes several minutes to complete.

    > [!NOTE]
    > If you manually extracted deployment content from the ZIP file previously, you must run `BootstrapCloudDeployment-Internal.ps1` instead.

Follow these next steps only if you plan to deploy Azure Stack HCI via PowerShell:

1. Change the directory to *C:\clouddeployment\setup*.

1. Set the following parameters:

    ```powershell
    $DeploymentUserCred=Get-Credential
    $LocalAdminCred=Get-Credential
    $SubscriptionID="<Your subscription ID>"
    $CloudName="AzureCloud"   
    $SPNAppID = "<Your App ID>"
    $SPNSecret= "<Your SPN Secret>"
    $SPNsecStringPassword = ConvertTo-SecureString $SPNSecret -AsPlainText -Force
    $SPNCred = New-Object System.Management.Automation.PSCredential ($SPNAppID, $SPNsecStringPassword)
    ```

1. Specify the path to your configuration file and run the following to start the deployment:

    ```powershell
    .\Invoke-CloudDeployment -JSONFilePath <path_to_config_file.json> -DeploymentUserCredential  $DeploymentUserCred  -LocalAdminCredential -$LocalAdminCred -RegistrationSPCredential $SPNCred -RegistrationCloudName $CloudName -RegistrationSubscriptionID $SubscriptionID
    ```

### Set up parameters

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
