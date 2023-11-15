---
title: Deploy Azure Stack HCI using PowerShell (preview) 
description: Learn how to deploy Azure Stack HCI using PowerShell cmdlets (preview).
author: alkohli
ms.topic: how-to
ms.date: 07/25/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Deploy Azure Stack HCI using PowerShell (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

In this article, learn how to deploy Azure Stack HCI using PowerShell. Before you begin the deployment, make sure to first install the operating system.

This deployment method uses an existing configuration file that you have modified for your environment.

There are two methods for authenticating your cluster: using a service principal name (SPN) or using multi-factor authentication (MFA).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you have done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.
- [Set up the first server](deployment-tool-set-up-first-server.md) in your Azure Stack HCI cluster.

## Create the configuration file

[!INCLUDE [configuration file](../../includes/hci-deployment-tool-configuration-file.md)]

## Prepare the configuration file

1. [Connect and sign in to the first server](deployment-tool-set-up-first-server.md#connect-to-the-first-server) in your Azure Stack HCI cluster as local administrator.

1. Review the [configuration file that you created previously](#create-the-configuration-file) to ensure the provided values match your environment details before you copy it to the first server.

1. Copy the configuration file to the first server by using the following command:

    ```powershell
    Copy-Item -path <Path for your source file> -destination C:\setup\config.json
    ```

## Get information for the required parameters

The following parameters are required to run the deployment tool. Consult your network administrator as needed for this information.

|Parameter|Description|
|----|----|
|`JSONFilePath`|Enter the path to your config file. For example, *C:\setup\config.json*.|
|`AzureStackLCMUserCredential`|Specify the Active Directory account username. The username cannot be *Administrator*.|
|`LocalAdminCredential`|Specify the local administrator credentials.|
|`RegistrationCloudName`|Specify the cloud against which you'll authenticate your cluster. In this release, only the `AzureCloud` corresponding to global Azure is supported.|
|`RegistrationRegion`|(Optional) Specify the region that should be used when registering the system with Azure Arc.|
|`RegistrationResourceGroupName`|(Optional) Specify the resource group that will be used to hold the resource objects for the system.|
|`RegistrationResourceName`|(Optional) Specify the name used for the resource object of the Arc resource name for the cluster.|
|`RegistrationSubscriptionID`|Specify the ID for the subscription used to authenticate the cluster to Azure.|
|`RegistrationSPCredential`|Specify the credentials including the App ID and the secret for the Service Principal used to authenticate the cluster to Azure.|
|`RegistrationAccountCredential`|(Optional for MFA) Specify a credential object which is used to authenticate the Azure subscription. This is an alternative to using a service principal for authentication.|
|`RegistrationArcServerResourceGroupName`|(Optional for MFA) Specify a dedicated resource group for the Arc for server objects. This allows separate resource groups between Arc for Servers and Azure Stack HCI clusters.|
|`WitnessStorageKey`|Specify the access key for the Azure Storage account used for cloud witness for your Azure Stack HCI cluster.|

## Run the deployment tool using a service principal

If you are using a service principal name to authenticate your cluster, use the following steps to deploy Azure Stack HCI via PowerShell.

For more information on creating a service principal, see [Create an Azure service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps) and [Create a Microsoft Entra application and service principal that can access resources](/azure/active-directory/develop/howto-create-service-principal-portal).

1. Connect to the first server in your Azure Stack HCI cluster using Remote Desktop Protocol (RDP).

1. Use option 15 in Server Configuration tool (SConfig) to exit to command line.

1. In the PowerShell window, change the directory to *C:\clouddeployment\setup*.

1. Set the following parameters:

    ```powershell
    $AzureStackLCMUserCred=Get-Credential
    $LocalAdminCred=Get-Credential
    $SubscriptionID="<Your subscription ID>"
    $CloudName="AzureCloud"   
    $SPNAppID = "<Your App ID>"
    $SPNSecret= "<Your SPN Secret>"
    $SPNsecStringPassword = ConvertTo-SecureString $SPNSecret -AsPlainText -Force
    $SPNCred = New-Object System.Management.Automation.PSCredential ($SPNAppID, $SPNsecStringPassword)
    $AzureStorAcctAccessKey = ConvertTo-SecureString '<Azure Storage account access key in plain text>' -AsPlainText -Force
    ```

1. Specify the path to your configuration file and run the following command to start the deployment:

    ```powershell
    .\Invoke-CloudDeployment -JSONFilePath <path_to_config_file.json> -AzureStackLCMUserCredential  $AzureStackLCMUserCred  -LocalAdminCredential -$LocalAdminCred -RegistrationSPCredential $SPNCred -RegistrationCloudName $CloudName -RegistrationSubscriptionID $SubscriptionID -WitnessStorageKey $AzureStorAcctAccessKey
    ```

## Run the deployment tool using MFA

If you are using multi-factor authentication (MFA) to authenticate your cluster, complete the following steps to deploy Azure Stack HCI using PowerShell. This method requires a second server in your cluster that has a browser to complete authentication.

1. Connect to the first server in your Azure Stack HCI cluster using Remote Desktop Protocol (RDP).

1. Use option 15 in Server Configuration tool (SConfig) to exit to command line.

1. In the PowerShell window, change the directory to *C:\clouddeployment\setup*.

1. Run the following to import the registration module and configure authentication:

    ```powershell
    $SubscriptionID="<your_subscription_ID>"
    Set-AuthenticationToken -RegistrationCloudName AzureCloud -RegistrationSubscriptionID $SubscriptionID
    ```

1. From a second server in your cluster that has a browser installed, open the browser and navigate to  [https://microsoft.com/devicelogin](https://microsoft.com/devicelogin).  

1. Copy the authentication code that is displayed and complete the authentication request.

1. On the first server, start the deployment using PowerShell and run the following command:

    ```powershell
    $DomainCred=Get-Credential
    $LocalCred=Get-Credential
    $AzureStorAcctAccessKey = ConvertTo-SecureString '<Azure_Storage_account_access_key_for_cluster_witness_in_plain_text>' -AsPlainText -Force
    Invoke-CloudDeployment -JSONFilePath <path_to_config_file.json> -AzureStackLCMUserCredential $DomainCred -LocalAdminCredential $LocalCred -WitnessStorageKey $AzureStorAcctAccessKey
    ```

## Reference: Configuration file settings

[!INCLUDE [configuration file reference](../../includes/hci-deployment-tool-configuration-file-reference.md)]

## Next steps

- [Validate deployment](deployment-tool-validate.md).
- If needed, [troubleshoot deployment](deployment-tool-troubleshoot.md).
