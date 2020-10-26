---
title: Manage Azure Stack Hub with Azure CLI 
description: Learn how to use the cross-platform command-line interface (CLI) to manage and deploy resources on Azure Stack Hub.
author: mattbriggs

ms.topic: article
ms.date: 10/26/2020
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 10/26/2020

# Intent: As an Azure Stack user, I want to use cross-platform CLI to manage and deploy resources on Azure Stack.
# Keyword: manage azure stack CLI

---

# Install Azure CLI on Azure Stack Hub

## Install Azure CLI

1. Sign in to your development workstation and install CLI. Azure Stack Hub requires version 2.0 or later of Azure CLI. 

2. You can install the CLI by using the steps described in the [Install the Azure CLI](/cli/azure/install-azure-cli) article. 

3. To verify whether the installation was successful, open a terminal or command prompt window and run the following command:

    ```shell
    az --version
    ```

    You should see the version of Azure CLI and other dependent libraries that are installed on your computer.

    ![Azure CLI on Azure Stack Hub Python location](media/azure-stack-version-profiles-azurecli2/cli-python-location.png)

2. Make a note of the CLI's Python location. If you're running the ASDK, you need to use this location to add your certificate. For instructions on setting up certificates for installing the CLI on the ASDK, see [Setting up certificates for Azure CLI on Azure Stack Development Kit](../asdk/asdk-cli.md).

## Set up Azure CLI

### [Azure AD on Windows](#tab/ad-win)

This section walks you through setting up CLI if you're using Azure AD as your identity management service, and are using CLI on a Windows machine.

#### Connect to Azure Stack Hub

1. If you are using the ASDK, trust the Azure Stack Hub CA root certificate. For instruction, see [Trust the certificate](../asdk/asdk-cli.md#trust-the-certificate).

2. Register your Azure Stack Hub environment by running the `az cloud register` command.

3. Register your environment. Use the following parameters when running `az cloud register`:

    | Value | Example | Description |
    | --- | --- | --- |
    | Environment name | AzureStackUser | Use `AzureStackUser`  for the user environment. If you're operator, specify `AzureStackAdmin`. |
    | Resource Manager endpoint | `https://management.local.azurestack.external` | The **ResourceManagerUrl** in the ASDK is: `https://management.local.azurestack.external/` The **ResourceManagerUrl** in integrated systems is: `https://management.<region>.<fqdn>/` If you have a question about the integrated system endpoint, contact your cloud operator. |
    | Storage endpoint | local.azurestack.external | `local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
    | Keyvault suffix | .vault.local.azurestack.external | `.vault.local.azurestack.external` is for the ASDK. For an integrated system, use an endpoint for your system.  |
    | VM image alias doc endpoint- | https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json | URI of the document, which contains VM image aliases. For more info, see [Set up the VM aliases endpoint](../asdk/asdk-cli.md#set-up-the-virtual-machine-aliases-endpoint). |

    ```azurecli  
    az cloud register -n <environmentname> --endpoint-resource-manager "https://management.local.azurestack.external" --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>
    ```

4. Set the active environment by using the following commands.

      ```azurecli
      az cloud set -n <environmentname>
      ```

5. Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

    ```azurecli
    az cloud update --profile 2019-03-01-hybrid
   ```

    >[!NOTE]  
    >If you're running a version of Azure Stack Hub before the 1808 build, you must use the API version profile **2017-03-09-profile** rather than the API version profile **2019-03-01-hybrid**. You also need to use a recent version of the Azure CLI.
 
6. Sign in to your Azure Stack Hub environment by using the `az login` command. Sign in to the Azure Stack Hub environment either as a user or as a [service principal](/azure/active-directory/develop/app-objects-and-service-principals). 

   - Sign in as a *user*: 

     You can either specify the username and password directly within the `az login` command, or authenticate by using a browser. You must do the latter if your account has multi-factor authentication enabled:

     ```azurecli
     az login -u <Active directory global administrator or user account. For example: username@<aadtenant>.onmicrosoft.com> --tenant <Azure Active Directory Tenant name. For example: myazurestack.onmicrosoft.com>
     ```

     > [!NOTE]
     > If your user account has multi-factor authentication enabled, use the `az login` command without providing the `-u` parameter. Running this command gives you a URL and a code that you must use to authenticate.

   - Sign in as a *service principal*: 
    
     Before you sign in, [create a service principal through the Azure portal](../operator/azure-stack-create-service-principals.md?view=azs-2002) or CLI and assign it a role. Now, sign in by using the following command:

     ```azurecli  
     az login --tenant <Azure Active Directory Tenant name. For example: myazurestack.onmicrosoft.com> --service-principal -u <Application Id of the Service Principal> -p <Key generated for the Service Principal>
     ```

#### Test the connectivity

With everything set up, use CLI to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a VM. Use the following command to create a resource group named "MyResourceGroup":

```azurecli
az group create -n MyResourceGroup -l local
```

If the resource group is created successfully, the previous command outputs the following properties of the newly created resource:

![Resource group create output](media/azure-stack-connect-cli/image1.png)

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
    | VM image alias doc endpoint- | https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json | URI of the document, which contains VM image aliases. For more info, see [Set up the VM aliases endpoint](../asdk/asdk-cli.md#set-up-the-virtual-machine-aliases-endpoint). |

    ```azurecli  
    az cloud register -n <environmentname> --endpoint-resource-manager "https://management.local.azurestack.external" --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>
    ```

4. Set the active environment by using the following commands.

      ```azurecli
      az cloud set -n <environmentname>
      ```

5. Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

    ```azurecli
    az cloud update --profile 2019-03-01-hybrid
   ```

    >[!NOTE]  
    >If you're running a version of Azure Stack Hub before the 1808 build, you must use the API version profile **2017-03-09-profile** rather than the API version profile **2019-03-01-hybrid**. You also need to use a recent version of the Azure CLI.

6. Sign in to your Azure Stack Hub environment by using the `az login` command. You can sign in to the Azure Stack Hub environment either as a user or as a [service principal](/azure/active-directory/develop/app-objects-and-service-principals). 

   - Sign in as a *user*:

     You can either specify the username and password directly within the `az login` command, or authenticate by using a browser. You must do the latter if your account has multi-factor authentication enabled:

     ```azurecli
     az cloud register  -n <environmentname>   --endpoint-resource-manager "https://management.local.azurestack.external"  --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>   --profile "2019-03-01-hybrid"
     ```

     > [!NOTE]
     > If your user account has multi-factor authentication enabled, use the `az login` command without providing the `-u` parameter. Running this command gives you a URL and a code that you must use to authenticate.

   - Sign in as a *service principal*: 
    
     Prepare the .pem file to be used for service principal login.

     On the client machine where the principal was created, export the service principal certificate as a pfx with the private key located at `cert:\CurrentUser\My`. The cert name has the same name as the principal.

     Convert the pfx to pem (use the OpenSSL utility).

     Sign in to the CLI:
  
     ```azurecli  
     az login --service-principal \
      -u <Client ID from the Service Principal details> \
      -p <Certificate's fully qualified name, such as, C:\certs\spn.pem>
      --tenant <Tenant ID> \
      --debug 
     ```

#### Test the connectivity

With everything set up, use CLI to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a VM. Use the following command to create a resource group named "MyResourceGroup":

```azurecli
az group create -n MyResourceGroup -l local
```

If the resource group is created successfully, the previous command outputs the following properties of the newly created resource:

![Resource group create output](media/azure-stack-connect-cli/image1.png)

### [Azure AD on Linux](#tab/ad-lin)

This section walks you through setting up CLI if you're using Azure AD as your identity management service, and are using CLI on a Linux machine.

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
    | VM image alias doc endpoint- | https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json | URI of the document, which contains VM image aliases. For more info, see [Set up the VM aliases endpoint](../asdk/asdk-cli.md#set-up-the-virtual-machine-aliases-endpoint). |

    ```azurecli  
    az cloud register -n <environmentname> --endpoint-resource-manager "https://management.local.azurestack.external" --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>
    ```

4. Set the active environment. 

      ```azurecli
        az cloud set -n <environmentname>
      ```

5. Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

    ```azurecli
      az cloud update --profile 2019-03-01-hybrid
   ```

    >[!NOTE]  
    >If you're running a version of Azure Stack Hub before the 1808 build, you must use the API version profile **2017-03-09-profile** rather than the API version profile **2019-03-01-hybrid**. You also need to use a recent version of the Azure CLI.

6. Sign in to your Azure Stack Hub environment by using the `az login` command. You can sign in to the Azure Stack Hub environment either as a user or as a [service principal](/azure/active-directory/develop/app-objects-and-service-principals). 

   * Sign in as a *user*:

     You can either specify the username and password directly within the `az login` command, or authenticate by using a browser. You must do the latter if your account has multi-factor authentication enabled:

     ```azurecli
     az login \
       -u <Active directory global administrator or user account. For example: username@<aadtenant>.onmicrosoft.com> \
       --tenant <Azure Active Directory Tenant name. For example: myazurestack.onmicrosoft.com>
     ```

     > [!NOTE]
     > If your user account has multi-factor authentication enabled, you can use the `az login` command without providing the `-u` parameter. Running this command gives you a URL and a code that you must use to authenticate.
   
   * Sign in as a *service principal*
    
     Before you sign in, [create a service principal through the Azure portal](../operator/azure-stack-create-service-principals.md?view=azs-2002) or CLI and assign it a role. Now, sign in by using the following command:

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

![Resource group create output](media/azure-stack-connect-cli/image1.png)

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
    | VM image alias doc endpoint- | https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json | URI of the document, which contains VM image aliases. For more info, see [Set up the VM aliases endpoint](../asdk/asdk-cli.md#set-up-the-virtual-machine-aliases-endpoint). |

    ```azurecli  
    az cloud register -n <environmentname> --endpoint-resource-manager "https://management.local.azurestack.external" --suffix-storage-endpoint "local.azurestack.external" --suffix-keyvault-dns ".vault.local.azurestack.external" --endpoint-vm-image-alias-doc <URI of the document which contains VM image aliases>
    ```

4. Set the active environment. 

      ```azurecli
        az cloud set -n <environmentname>
      ```

5. Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

    ```azurecli
      az cloud update --profile 2019-03-01-hybrid
   ```

    >[!NOTE]  
    >If you're running a version of Azure Stack Hub before the 1808 build, you must use the API version profile **2017-03-09-profile** rather than the API version profile **2019-03-01-hybrid**. You also need to use a recent version of the Azure CLI.

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
        -p <Certificate's fully qualified name, such as, C:\certs\spn.pem>
        --tenant <Tenant ID> \
        --debug 
      ```

#### Test the connectivity

With everything set up, use CLI to create resources within Azure Stack Hub. For example, you can create a resource group for an app and add a VM. Use the following command to create a resource group named "MyResourceGroup":

```azurecli
  az group create -n MyResourceGroup -l local
```

If the resource group is created successfully, the previous command outputs the following properties of the newly created resource:

![Resource group create output](media/azure-stack-connect-cli/image1.png)

### Known issues

There are known issues when using CLI in Azure Stack Hub:

 - The CLI interactive mode. For example, the `az interactive` command, isn't yet supported in Azure Stack Hub.
 - To get the list of VM images available in Azure Stack Hub, use the `az vm image list --all` command instead of the `az vm image list` command. Specifying the `--all` option ensures that the response returns only the images that are available in your Azure Stack Hub environment.
 - VM image aliases that are available in Azure may not be applicable to Azure Stack Hub. When using VM images, you must use the entire URN parameter (Canonical:UbuntuServer:14.04.3-LTS:1.0.0) instead of the image alias. This URN must match the image specifications as derived from the `az vm images list` command.

---

## Next steps

- [Deploy templates with Azure CLI](azure-stack-deploy-template-command-line.md)
- [Enable Azure CLI for Azure Stack Hub users (Operator)](../operator/azure-stack-cli-admin.md)
- [Manage user permissions](azure-stack-manage-permissions.md) 
