---
title: Manage Azure Stack Hub with Azure CLI 
description: Learn how to use the cross-platform command-line interface (CLI) to manage and deploy resources on Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.custom:
  - devx-track-azurecli
ms.date: 06/01/2022
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 11/05/2021

# Intent: As an Azure Stack user, I want to use cross-platform CLI to manage and deploy resources on Azure Stack.
# Keyword: manage azure stack CLI
---

# Install Azure CLI on Azure Stack Hub

You can install the Azure CLI to manage Azure Stack Hub with a Windows or Linux machines. This article walks you through the steps of installing and setting up Azure CLI.

## Install Azure CLI

1. Sign in to your development workstation and install CLI. Azure Stack Hub requires version 2.0 or later of Azure CLI. 

   > [!IMPORTANT]
   > Due to a [CVE](https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2022-39327) affecting Azure CLI versions previous to 2.40.0, it is no longer recommended that you use Azure CLI 2.29.2 for AD FS in Azure Stack Hub. You can update to Azure CLI 2.40.0 or higher. However, AD FS customers might encounter issues with Azure CLI commands that interact with Microsoft Graph endpoints. This is because Microsoft Graph is not supported for AD FS. For workarounds to Microsoft Graph issues, see the [General known issues](#general-known-issues) section.

2. You can install the CLI by using the steps described in the [Install the Azure CLI](/cli/azure/install-azure-cli) article. 

3. To verify whether the installation was successful, open a terminal or command prompt window and run the following command:

    ```azurecli
    az --version
    ```

    You should see the version of Azure CLI and other dependent libraries that are installed on your computer.

    ![Azure CLI on Azure Stack Hub Python location](media/azure-stack-version-profiles-azurecli2/cli-python-location.png)

4. Make a note of the CLI's Python location. 

## Add certificate

Export and then import the Azure Stack Hub certificate for disconnected integrated systems and for the ASDK. For connected integrated systems, the certificate is publicly signed and this step isn't necessary. For instructions, see [Setting up certificates for Azure CLI on Azure Stack Development Kit](../asdk/asdk-cli.md).

## Connect with Azure CLI

<a name='azure-ad-on-windows'></a>

### [Microsoft Entra ID on Windows](#tab/ad-win)

This section walks you through setting up CLI if you're using Microsoft Entra ID as your identity management service, and are using CLI on a Windows machine.

#### Connect to Azure Stack Hub

1. If you are using the ASDK, trust the Azure Stack Hub CA root certificate. For instruction, see [Trust the certificate](../asdk/asdk-cli.md#trust-the-certificate).

2. Register your Azure Stack Hub environment by running the `az cloud register` command.

3. Register your environment. Use the following parameters when running `az cloud register`:

      | Value | Example | Description |
      | --- | --- | --- |
      | Environment name | AzureStackUser | Use `AzureStackUser`  for the user environment. If you're operator, specify `AzureStackAdmin`. |
      | Resource Manager endpoint | `https://management.contoso.onmicrosoft.com` | The **ResourceManagerUrl** in the ASDK is: `https://management.local.azurestack.external/` The **ResourceManagerUrl** in integrated systems is: `https://management.<region>.<fqdn>/` If you have a question about the integrated system endpoint, contact your cloud operator. |
      | Storage endpoint | local.contoso.onmicrosoft.com | `local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
      | Keyvault suffix | .vault.contoso.onmicrosoft.com | `.vault.local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
      | Endpoint active directory graph resource ID | https://graph.windows.net/ | The Active Directory resource ID. |
    
      ```azurecli  
      az cloud register `
          -n <environmentname> `
          --endpoint-resource-manager "https://management.<region>.<fqdn>" `
          --suffix-storage-endpoint "<fqdn>" `
          --suffix-keyvault-dns ".vault.<fqdn>" 
      ```

    You can find a reference for the [register command](/cli/azure/cloud#az-cloud-register) in the Azure CLI reference documentation.


4. Set the active environment by using the following commands.

      ```azurecli
      az cloud set -n <environmentname>
      ```

5. Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

    ```azurecli
    az cloud update --profile 2020-09-01-hybrid
   ```
 
6. Sign in to your Azure Stack Hub environment by using the `az login` command.

    You can sign in to the Azure Stack Hub environment using your user credentials, or with a [service principal](../operator/give-app-access-to-resources.md) (SPN) provided to you by your cloud operator. 

   - Sign in as a *user*: 

     You can either specify the username and password directly within the `az login` command, or authenticate by using a browser. You must do the latter if your account has multifactor authentication enabled:

     ```azurecli
     az login -u "user@contoso.onmicrosoft.com" -p 'Password123!' --tenant contoso.onmicrosoft.com
     ```

     > [!NOTE]
     > If your user account has multifactor authentication enabled, use the `az login` command without providing the `-u` parameter. Running this command gives you a URL and a code that you must use to authenticate.

   - Sign in as a *service principal*: 
    
        Before you sign in, [create a service principal through the Azure portal](../operator/give-app-access-to-resources.md) or CLI and assign it a role. Now, sign in by using the following command:
    
        ```azurecli  
        az login `
          --tenant <Azure Active Directory Tenant name. `
                    For example: myazurestack.onmicrosoft.com> `
        --service-principal `
          -u <Application Id of the Service Principal> `
          -p <Key generated for the Service Principal>
        ```
    
7. Verify that your environment is set correctly and that your environment is the active cloud.

      ```azurecli
          az cloud list --output table
      ```

   You should see that your environment is listed and **IsActive** is `true`. For example:

   ```output  
   IsActive    Name               Profile
   ----------  -----------------  -----------------
   False       AzureCloud         2020-09-01-hybrid
   False       AzureChinaCloud    latest
   False       AzureUSGovernment  latest
   False       AzureGermanCloud   latest
   True        AzureStackUser     2020-09-01-hybrid
   ```

#### Test the connectivity

With everything set up, use CLI to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a VM. Use the following command to create a resource group named "MyResourceGroup":

```azurecli
az group create -n MyResourceGroup -l local
```

If the resource group is created successfully, the previous command outputs the following properties of the newly created resource:

```output
{
  "id": "/subscriptions/84edee99-XXXX-4f5c-b646-5cdab9759a03/resourceGroups/RGCL11",
  "location": "local",
  "name": "RGCLI1",
  " properties ": {
    "provisioningState": "Succeeded"
  },
  "tags ": null
}
```

### [AD FS on Windows](#tab/adfs-win)

This section walks you through setting up CLI if you're using Active Directory Federated Services (AD FS) as your identity management service, and are using CLI on a Windows machine.

#### Connect to Azure Stack Hub


1. If you are using the ASDK, trust the Azure Stack Hub CA root certificate. For instruction, see [Trust the certificate](../asdk/asdk-cli.md#trust-the-certificate).

2. Register your Azure Stack Hub environment by running the `az cloud register` command.

3. Register your environment. Use the following parameters when running `az cloud register`:

    | Value | Example | Description |
    | --- | --- | --- |
    | Environment name | AzureStackUser | Use `AzureStackUser`  for the user environment. If you're operator, specify `AzureStackAdmin`. |
    | Resource Manager endpoint | `https://management.local.azurestack.external` | The **ResourceManagerUrl** in the ASDK is: `https://management.local.azurestack.external/` The **ResourceManagerUrl** in integrated systems is: `https://management.<region>.<fqdn>/` If you have a question about the integrated system endpoint, contact your cloud operator. |
    | Storage endpoint | local.azurestack.external | `local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
    | Keyvault suffix | .vault.local.azurestack.external | `.vault.local.azurestack.external` is for the ASDK. For an  integrated system, use an endpoint for your system.  |
    | VM image alias doc endpoint- | https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json | URI of the document, which contains VM image aliases. For more info, see [Set up the virtual machine alias endpoint](../asdk/asdk-cli.md#set-up-the-virtual-machine-alias-endpoint). |

    ```azurecli  
    az cloud register -n <environmentname> --endpoint-resource-manager "https://management.local.azurestack.external" --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>
    ```

4. Set the active environment by using the following commands.

      ```azurecli
      az cloud set -n <environmentname>
      ```

5. Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

    ```azurecli
    az cloud update --profile 2020-09-01-hybrid
   ```

    >[!NOTE]  
    >If you're running a version of Azure Stack Hub before the 1808 build, you must use the API version profile **2017-03-09-profile** rather than the API version profile **2020-09-01-hybrid**. You also need to use a recent version of the Azure CLI.

6. Sign in to your Azure Stack Hub environment by using the `az login` command. You can sign in to the Azure Stack Hub environment either as a user or as a [service principal](../operator/give-app-access-to-resources.md).

   - Sign in as a *user*:

     You can either specify the username and password directly within the `az login` command, or authenticate by using a browser. You must do the latter if your account has multifactor authentication enabled:

     ```azurecli
     az cloud register  -n <environmentname>   --endpoint-resource-manager "https://management.local.azurestack.external"  --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>   --profile "2020-09-01-hybrid"
     ```

   - Sign in as a *service principal*:

     Prepare the .pem file to be used for service principal login.

     On the client machine where the principal was created, export the service principal certificate as a pfx with the private key located at `cert:\CurrentUser\My`. The cert name has the same name as the principal.

     Convert the pfx to pem (use the OpenSSL utility).

     Sign in to the CLI:
  
     ```azurecli  
     az login --service-principal \
      -u <Client ID from the Service Principal details> \
      -p <Client secret (password), or certificate's fully qualified name, such as, C:\certs\spn.pem>
      --tenant <Tenant ID> \
      --debug 
     ```

#### Test the connectivity

With everything set up, use CLI to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a VM. Use the following command to create a resource group named "MyResourceGroup":

```azurecli
az group create -n MyResourceGroup -l local
```

If the resource group is created successfully, the previous command outputs the following properties of the newly created resource:

```output
{
  "id": "/subscriptions/84edee99-XXXX-4f5c-b646-5cdab9759a03/resourceGroups/RGCL11",
  "location": "local",
  "name": "RGCLI1",
  " properties ": {
    "provisioningState": "Succeeded"
  },
  "tags ": null
}
```

<a name='azure-ad-on-linux'></a>

### [Microsoft Entra ID on Linux](#tab/ad-lin)

This section walks you through setting up CLI if you're using Microsoft Entra ID as your identity management service, and are using CLI on a Linux machine.

#### Connect to Azure Stack Hub

Use the following steps to connect to Azure Stack Hub:


1. If you are using the ASDK, trust the Azure Stack Hub CA root certificate. For instruction, see [Trust the certificate](../asdk/asdk-cli.md#trust-the-certificate).

2. Register your Azure Stack Hub environment by running the `az cloud register` command.

3. Register your environment. Use the following parameters when running `az cloud register`:

    | Value | Example | Description |
    | --- | --- | --- |
    | Environment name | AzureStackUser | Use `AzureStackUser`  for the user environment. If you're operator, specify `AzureStackAdmin`. |
    | Resource Manager endpoint | `https://management.local.azurestack.external` | The **ResourceManagerUrl** in the ASDK is: `https://management.local.azurestack.external/` The **ResourceManagerUrl** in integrated systems is: `https://management.<region>.<fqdn>/` If you have a question about the integrated system endpoint, contact your cloud operator. |
    | Storage endpoint | local.azurestack.external | `local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
    | Keyvault suffix | .vault.local.azurestack.external | `.vault.local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
    | VM image alias doc endpoint- | https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json | URI of the document, which contains VM image aliases. For more info, see [Set up the virtual machine alias endpoint](../asdk/asdk-cli.md#set-up-the-virtual-machine-alias-endpoint). |

    ```azurecli  
    az cloud register -n <environmentname> --endpoint-resource-manager "https://management.local.azurestack.external" --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>
    ```

4. Set the active environment. 

      ```azurecli
        az cloud set -n <environmentname>
      ```

5. Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

    ```azurecli
      az cloud update --profile 2020-09-01-hybrid
   ```

    >[!NOTE]  
    >If you're running a version of Azure Stack Hub before the 1808 build, you must use the API version profile **2017-03-09-profile** rather than the API version profile **2020-09-01-hybrid**. You also need to use a recent version of the Azure CLI.

6. Sign in to your Azure Stack Hub environment by using the `az login` command. You can sign in to the Azure Stack Hub environment either as a user or as a [service principal](/azure/active-directory/develop/app-objects-and-service-principals). 

   * Sign in as a *user*:

     You can either specify the username and password directly within the `az login` command, or authenticate by using a browser. You must do the latter if your account has multifactor authentication enabled:

     ```azurecli
     az login \
       -u <Active directory global administrator or user account. For example: username@<aadtenant>.onmicrosoft.com> \
       --tenant <Azure Active Directory Tenant name. For example: myazurestack.onmicrosoft.com>
     ```

     > [!NOTE]
     > If your user account has multifactor authentication enabled, you can use the `az login` command without providing the `-u` parameter. Running this command gives you a URL and a code that you must use to authenticate.
   
   * Sign in as a *service principal*
    
     Before you sign in, [create a service principal through the Azure portal](../operator/give-app-access-to-resources.md) or CLI and assign it a role. Now, sign in by using the following command:

     ```azurecli  
     az login \
       --tenant <Azure Active Directory Tenant name. For example: myazurestack.onmicrosoft.com> \
       --service-principal \
       -u <Application Id of the Service Principal> \
       -p <Key generated for the Service Principal>
     ```

#### Test the connectivity

With everything set up, use CLI to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a VM. Use the following command to create a resource group named "MyResourceGroup":

```azurecli
    az group create -n MyResourceGroup -l local
```

If the resource group is created successfully, the previous command outputs the following properties of the newly created resource:

```output
{
  "id": "/subscriptions/84edee99-XXXX-4f5c-b646-5cdab9759a03/resourceGroups/RGCL11",
  "location": "local",
  "name": "RGCLI1",
  " properties ": {
    "provisioningState": "Succeeded"
  },
  "tags ": null
}
```

### [AD FS Linux](#tab/adfs-lin)

This section walks you through setting up CLI if you're using Active Directory Federated Services (AD FS) as your management service, and are using CLI on a Linux machine.

#### Connect to Azure Stack Hub

Use the following steps to connect to Azure Stack Hub:

1. If you are using the ASDK, trust the Azure Stack Hub CA root certificate. For instruction, see [Trust the certificate](../asdk/asdk-cli.md#trust-the-certificate).

2. Register your Azure Stack Hub environment by running the `az cloud register` command.

3. Register your environment. Use the following parameters when running `az cloud register`.

    | Value | Example | Description |
    | --- | --- | --- |
    | Environment name | AzureStackUser | Use `AzureStackUser`  for the user environment. If you're operator, specify `AzureStackAdmin`. |
    | Resource Manager endpoint | `https://management.local.azurestack.external` | The **ResourceManagerUrl** in the ASDK is: `https://management.local.azurestack.external/` The **ResourceManagerUrl** in integrated systems is: `https://management.<region>.<fqdn>/` If you have a question about the integrated system endpoint, contact your cloud operator. |
    | Storage endpoint | local.azurestack.external | `local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
    | Keyvault suffix | .vault.local.azurestack.external | `.vault.local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
    | VM image alias doc endpoint- | https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json | URI of the document, which contains VM image aliases. For more info, see [Set up the virtual machine alias endpoint](../asdk/asdk-cli.md#set-up-the-virtual-machine-alias-endpoint). |

    ```azurecli  
    az cloud register -n <environmentname> --endpoint-resource-manager "https://management.local.azurestack.external" --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>
    ```

4. Set the active environment. 

      ```azurecli
        az cloud set -n <environmentname>
      ```

5. Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

    ```azurecli
      az cloud update --profile 2020-09-01-hybrid
   ```

    >[!NOTE]  
    >If you're running a version of Azure Stack Hub before the 1808 build, you must use the API version profile **2017-03-09-profile** rather than the API version profile **2020-09-01-hybrid**. You also need to use a recent version of the Azure CLI.

6. Sign in to your Azure Stack Hub environment by using the `az login` command. You can sign in to the Azure Stack Hub environment either as a user or as a [service principal](/azure/active-directory/develop/app-objects-and-service-principals). 

7. Sign in: 

   *  As a **user** using a web browser with a device code:  

   ```azurecli  
    az login --use-device-code
   ```

   > [!NOTE]  
   >Running the command gives you a URL and a code that you must use to authenticate.

   * As a service principal:
        
     Prepare the .pem file to be used for service principal login.

      * On the client machine where the principal was created, export the service principal certificate as a pfx with the private key located at `cert:\CurrentUser\My`. The cert name has the same name as the principal.
  
      * Convert the pfx to pem (use the OpenSSL utility).

     Sign in to the CLI:

      ```azurecli  
      az login --service-principal \
        -u <Client ID from the Service Principal details> \
        -p <Client secret (password), or certificate's fully qualified name, such as, C:\certs\spn.pem>
        --tenant <Tenant ID> \
        --debug 
      ```

#### Test the connectivity

With everything set up, use CLI to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a VM. Use the following command to create a resource group named "MyResourceGroup":

```azurecli
  az group create -n MyResourceGroup -l local
```

If the resource group is created successfully, the previous command outputs the following properties of the newly created resource:

```output
{
  "id": "/subscriptions/84edee99-XXXX-4f5c-b646-5cdab9759a03/resourceGroups/RGCL11",
  "location": "local",
  "name": "RGCLI1",
  " properties ": {
    "provisioningState": "Succeeded"
  },
  "tags ": null
}
```

### Known issues

There are known issues when using CLI in Azure Stack Hub:

 - The CLI interactive mode. For example, the `az interactive` command, isn't yet supported in Azure Stack Hub.
 - To get the list of VM images available in Azure Stack Hub, use the `az vm image list --all` command instead of the `az vm image list` command. Specifying the `--all` option ensures that the response returns only the images that are available in your Azure Stack Hub environment.
 - VM image aliases that are available in Azure may not be applicable to Azure Stack Hub. When using VM images, you must use the entire URN parameter (Canonical:UbuntuServer:14.04.3-LTS:1.0.0) instead of the image alias. This URN must match the image specifications as derived from the `az vm images list` command.

---

## General known issues

The general fix for most issues is to use the `az rest` command that uses the current Azure Stack context, to make a REST API call for the associated command with the issue. The workarounds in the following issues list can generally be adapted for other Azure CLI issues as long as these issues are caused by Azure CLI and not Azure Stack Hub resource providers or other Azure Stack Hub services.

### Microsoft Graph issues

These are the known Microsoft Graph issues for Azure CLI 2.40.0, or greater, for Azure Stack Hub. This primarily affects ADFS environments as it doesn't support Microsoft Graph.

- `az keyvault create` interacts with Microsoft Graph. The following is an example workaround for ADFS. Primarily, the workaround uses the Azure AD Graph to retrieve user information such as the `objectId` rather than the Microsoft Graph.

  ```powershell
  # First, sign into Azure CLI account you want to create the Key Vault from.
  # TODO: change the principal name to name of principal you want to create the key vault with.
  $principalNameLike = "CloudUser*"
  # TODO: change location to your preference.
  $location = "local"
  $aadGraph = az cloud show --query endpoints.activeDirectoryGraphResourceId --output tsv
  $tenantId = az account show --query tenantId --output tsv
  if ($aadGraph[-1] -ne '/')
  {
      $aadGraph += '/'
  }
  $userObject = az rest --method get --url "${aadGraph}${tenantId}/users?api-version=1.6" `
      | ConvertFrom-Json `
      | Select-Object -ExpandProperty value `
      | Where-Object {$_.userPrincipalName -like $principalNameLike}
  $body = '{
    "location": "' + $location + '",
    "properties": {
      "tenantId": "' + $tenantId + '",
      "sku": {
        "family": "A",
        "name": "standard"
      },
      "accessPolicies": [
        {
          "tenantId": "' + $tenantId + '",
          "objectId": "' + $userObject.objectId + '",
          "permissions": {
            "keys": [
              "get",
              "create",
              "delete",
              "list",
              "update",
              "import",
              "backup",
              "restore",
              "recover"
            ],
            "secrets": [
              "get",
              "list",
              "set",
              "delete",
              "backup",
              "restore",
              "recover"
            ],
            "certificates": [
              "get",
              "list",
              "delete",
              "create",
              "import",
              "update",
              "managecontacts",
              "getissuers",
              "listissuers",
              "setissuers",
              "deleteissuers",
              "manageissuers",
              "recover"
            ],
            "storage": [
              "get",
              "list",
              "delete",
              "set",
              "update",
              "regeneratekey",
              "setsas",
              "listsas",
              "getsas",
              "deletesas"
            ]
          }
        }
      ],
      "enabledForDeployment": true,
      "enabledForTemplateDeployment": true
    }
  }'
  $body | Out-File -FilePath (Join-Path -Path "." -ChildPath "body.json")
  $resourceGroupName = "testrg123"
  az group create -n $resourceGroupName -l $location
  $armEndpoint = az cloud show --query endpoints.resourceManager --output tsv
  if ($armEndpoint[-1] -ne '/')
  {
      $armEndpoint += '/'
  }
  $subscriptionId = az account show --query id --output tsv
  $keyVaultName = "testkv123"
  az rest --method put --url "${armEndpoint}subscriptions/${subscriptionId}/resourceGroups/${resourceGroupName}/providers/Microsoft.KeyVault/vaults/${keyVaultName}?api-version=2016-10-01" --body `@body.json
  # OPTIONAL: test access to the Key Vault.
  # az keyvault secret set --name MySecretName --vault-name $keyVaultName --value MySecret
  ```
  For more information about Key Vault REST API, [see the Key Vault REST API reference](/rest/api/keyvault/).

### Other issues

The following are issues not limited to specific versions or ranges of versions of Azure CLI.

- `az role assignment create` isn't currently supported by Azure CLI for Azure Stack Hub due to an old API issue. The following workaround is required for both Microsoft Entra ID or ADFS.
  ```powershell
  # First, sign into account with access to the resource that is being given access or a role to another user.
  # TODO: change the principal name to name of principal you want to assign the role to.
  $principalNameLike = "CloudUser*"
  # TODO: change role name to your preference.
  $roleName = "Owner"
  # TODO: change location to your preference.
  $location = "local"
  $aadGraph = az cloud show --query endpoints.activeDirectoryGraphResourceId --output tsv
  $tenantId = az account show --query tenantId --output tsv
  if ($aadGraph[-1] -ne '/')
  {
      $aadGraph += '/'
  }
  $userObject = az rest --method get --url "${aadGraph}${tenantId}/users?api-version=1.6" `
      | ConvertFrom-Json `
      | Select-Object -ExpandProperty value `
      | Where-Object {$_.userPrincipalName -like $principalNameLike}
  $roleDefinitionId = az role definition list --query "[?roleName=='${roleName}'].id" --output tsv
  $body = @{
      properties = @{
          roleDefinitionId = $roleDefinitionId
          principalId = $userObject.objectId
      }
  }
  $body | ConvertTo-Json | Out-File -FilePath (Join-Path -Path "." -ChildPath "body.json")
  $resourceGroupName = "testrg123"
  az group create -n $resourceGroupName -l $location
  $armEndpoint = az cloud show --query endpoints.resourceManager --output tsv
  if ($armEndpoint[-1] -ne '/')
  {
      $armEndpoint += '/'
  }
  $scope =  az group show --name $resourceGroupName --query id --output tsv
  $guid = (New-Guid).ToString()
  az rest --method put --url "${armEndpoint}${scope}/providers/Microsoft.Authorization/roleAssignments/${guid}?api-version=2015-07-01" --body `@body.json
  # OPTIONAL: test access to the resource group, or use the portal.
  # az login -u <assigned user name> -p <assigned user password> --tenant $tenantId
  # Test a resource creation command in the resource group:
  # az network dns zone create -g $resourceGroupName -n "www.mysite.com"
  ```
  For more information about role assignment REST API, [see the role assignments article](/rest/api/authorization/role-assignments).

## Next steps

- [Deploy templates with Azure CLI](azure-stack-deploy-template-command-line.md)
- [Enable Azure CLI for Azure Stack Hub users (Operator)](../operator/azure-stack-cli-admin.md)
- [Manage user permissions](azure-stack-manage-permissions.md)
