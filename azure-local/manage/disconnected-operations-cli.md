---
title: Use Azure Command-Line Interface (CLI) for disconnected operations on Azure Local (preview)
description:  Learn how to use the Azure Command-Line Interface (CLI) for disconnected operations on Azure Local (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 10/16/2025
ai-usage: ai-assisted
---

# Use Azure Command-Line Interface for disconnected operations on Azure Local (preview)

::: moniker range=">=azloc-2506"

This article explains how to install and configure the Azure Command-Line Interface (CLI) and its extensions for disconnected operations on Azure Local. It provides an overview of CLI, supported versions, installation steps, and how to set up the CLI for disconnected operations.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About Azure CLI

**CLI** is a versatile, cross-platform command line interface that lets you create and manage Azure resources for Azure Local disconnected operations. For more information, see [What is Azure CLI](/cli/azure/what-is-azure-cli).

## Supported versions for CLI and extension

In this preview, the supported version of Azure CLI for Azure Local disconnected operations is 2.71.0. For more information, see [Azure CLI release notes](/cli/azure/release-notes-azure-cli). To find your installed version and see if you need to update, run `az version`:  

```azurecli  
az version  
```

For more information, see [Azure CLI commands](/cli/azure/reference-index?view=azure-cli-latest#az_version&preserve-view=true).

## Install Azure CLI

To install the 32-bit version of CLI, follow these steps:

1. [Download version 2.71.0](https://azcliprod.blob.core.windows.net/msi/azure-cli-2.71.0.msi).
2. [Install the CLI](/cli/azure/install-azure-cli) locally on Linux, macOS, or Windows computers.


> [!NOTE]  
> Use the 64-bit Azure CLI on client machines. For Azure Local nodes, install the 32-bit CLI to avoid deployment failures.

## Configure certificates for Azure CLI

To use CLI, you must trust the certificate authority (CA) root certificate on your machine.

For disconnected operations:

1. Learn about public key infrastructure (PKI) for Azure Local with disconnected operations (preview).
1. Set up the certificate trust for Azure CLI via PowerShell.

Python trust options (choose one):

- Option 1: Use the OS trust store (recommended). Install a Python module that allows Python use the OS trust store.

    Run this Windows example in PowerShell to install the pip-system-certs module in the Python environment bundled with Azure CLI. Replace the sample paths with the actual path on your system.

    ```powershell
    & "C:\Program Files (x86)\Microsoft SDKs\Azure\CLI2\python.exe" -m pip install pip-system-certs
    ```
    
    If your client doesn't have the root cert imported, use this command to import it.
  
    ```powershell
    $applianceRootCertFile = "C:\AzureLocalDisconnectedOperations\applianceRoot.cer"
    Import-Certificate -FilePath $applianceRootCertFile -CertStoreLocation Cert:\LocalMachine\Root -Confirm:$false
    ```

- Option 2: Update the PEM file used by the Azure CLI installation.

    Here's an example PowerShell script you can run:

    ```powershell
    # Define the helper method
    function UpdatePythonCertStore
    {
        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $false)]
            [ValidateScript({Test-Path $_})]
            [string]
            $ApplianceRootCertPath = "$env:APPDATA\Appliance\applianceRoot.cer"
        )
    
        Write-Verbose "[START] Updating CLI cert store with Appliance root cert at $ApplianceRootCertPath"
        $cerFile = $ApplianceRootCertPath
        Write-Verbose "Updating Python cert store with $cerFile"
    
        # C:\Program Files\Microsoft SDKs\Azure\CLI2
        $azCli2Path = Split-Path -Path (Split-Path -Path (Get-Command -Name az).Source -Parent) -Parent
        $pythonCertStore = "${azCli2Path}\Lib\site-packages\certifi\cacert.pem"
    
         Write-Verbose "Python cert store location $pythonCertStore"
    
        $root = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new()
    
        if(Test-Path $cerFile)
        {
            $root.Import($cerFile)
            Write-Verbose "$(Get-Date) Extracting required information from the cert file"
            $md5Hash    = (Get-FileHash -Path $cerFile -Algorithm MD5).Hash.ToLower()
            $sha1Hash   = (Get-FileHash -Path $cerFile -Algorithm SHA1).Hash.ToLower()
            $sha256Hash = (Get-FileHash -Path $cerFile -Algorithm SHA256).Hash.ToLower()
            $issuerEntry  = [string]::Format("# Issuer: {0}", $root.Issuer)
            $subjectEntry = [string]::Format("# Subject: {0}", $root.Subject)
            $labelEntry   = [string]::Format("# Label: {0}", $root.Subject.Split('=')[-1])
            $serialEntry  = [string]::Format("# Serial: {0}", $root.GetSerialNumberString().ToLower())
            $md5Entry     = [string]::Format("# MD5 Fingerprint: {0}", $md5Hash)
            $sha1Entry    = [string]::Format("# SHA1 Fingerprint: {0}", $sha1Hash)
            $sha256Entry  = [string]::Format("# SHA256 Fingerprint: {0}", $sha256Hash)
            $certText = (Get-Content -Path $cerFile -Raw).ToString().Replace("`r`n","`n")
            $rootCertEntry = "`n" + $issuerEntry + "`n" + $subjectEntry + "`n" + $labelEntry + "`n" + `
                                $serialEntry + "`n" + $md5Entry + "`n" + $sha1Entry + "`n" + $sha256Entry + "`n" + $certText
            Write-Verbose "Adding the certificate content to Python Cert store"
            Add-Content $pythonCertStore $rootCertEntry
            Write-Verbose "Python Cert store was updated to allow the Azure Stack CA root certificate"
        }
        else
        {
            $errorMessage = "$cerFile required to update CLI was not found."
            Write-Verbose "ERROR: $errorMessage"
            throw "UpdatePythonCertStore: $errorMessage"
        }
    
        Write-Verbose "[END] Updating CLI cert store"
    }
    
    # Run the helper method in PowerShell:
    UpdatePythonCertStore -ApplianceRootCertPath C:\AzureLocalDisconnectedOperations\applianceRoot.cer
    ```
    
## Set up Azure CLI for disconnected operations

To set up Azure CLI for disconnected operations on Azure Local, follow these steps:

1. Run the `Get-ApplianceAzCliCloudConfig` function to generate the JSON file that contains the required cloud endpoints.

    Here's an example script:

    ```PowerShell
    function Get-ApplianceAzCliCloudConfig
    {
        [CmdletBinding()]
        [OutputType([String])]
        param (
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $fqdn,
        [Parameter(Position = 1, Mandatory = $false)]
        [string]
        $exportToFile
        )
    
    $cloudConfig = @"
    {
        "suffixes":  {
                        "keyvaultDns":  ".vault.autonomous.cloud.private",
                        "storageEndpoint":  "autonomous.cloud.private",
                        "acrLoginServerEndpoint":  ".edgeacr.autonomous.cloud.private"
                    },
        "endpoints":  {
                        "activeDirectory":  "https://login.autonomous.cloud.private/adfs",
                        "activeDirectoryGraphResourceId":  "https://graph.autonomous.cloud.private",
                        "resourceManager":  "https://armmanagement.autonomous.cloud.private",
                        "microsoftGraphResourceId":  "https://graph.autonomous.cloud.private",
                        "activeDirectoryResourceId":  "https://armmanagement.autonomous.cloud.private"
                    }
    }
    "@ -replace "autonomous.cloud.private", $fqdn

    if ($exportToFile)
    {
        $cloudConfig | Set-Content -Path "$exportToFile"
    }
    return $cloudConfig
    }
    ```

    Use this helper method to get the endpoints and create a cloudConfig file for CLI:

    ```azurecli
    az config set core.enable_broker_on_windows=false
    az config set core.instance_discovery=false
    $fqdn = "autonomous.cloud.private"
    $cloudConfigJson = Get-ApplianceAzCliCloudConfig -fqdn $fqdn

    # Write the content to a file cloudConfig.json
    $cloudConfigJson | Out-File -FilePath cloudConfig.json
    ```

    Here's an example of content in the cloudconfig.json file:

    ```json
    { 
        "suffixes":  {
                      "keyvaultDns":  ".vault.autonomous.cloud.private",
                      "storageEndpoint":  "autonomous.cloud.private",
                      "acrLoginServerEndpoint":  ".edgeacr.autonomous.cloud.private"
                  },
         "endpoints":  {
                       "activeDirectory":  "https://login.autonomous.cloud.private/adfs",
                       "activeDirectoryGraphResourceId":  "https://graph.autonomous.cloud.private",
                       "resourceManager":  "https://armmanagement.autonomous.cloud.private",
                       "microsoftGraphResourceId":  "https://graph.autonomous.cloud.private",
                       "activeDirectoryResourceId":  "https://armmanagement.autonomous.cloud.private"
                   }
    }
    ```

3. Register the cloud configuration with CLI using the cloudConfig.json file.
    ```azurecli
    az cloud register -n 'azure.local' --cloud-config '@cloudconfig.json'
    az cloud set -n azure.local
    ```

## Extensions for Azure CLI

CLI extensions are Python wheels that aren't shipped with CLI but run as CLI commands. Extensions let you access experimental and prerelease commands and create your own CLI interfaces. The first time you use an extension, you get a prompt to install it.

To get a list of available extensions, run this command:

```azurecli
az extension list-available --output table  
```  

Learn more in [How to install and manage Azure CLI extensions](/cli/azure/azure-cli-extensions-overview).

To install a specific version of an extension, run this command:

```azurecli
az extension add --name anextension --version 1.0.0
```

The following table lists the CLI extensions supported on Azure Local disconnected operations, the maximum extension version supported, and installation information.

| Disconnected operations services | Extensions | Maximum extension version supported | Installation information |  
|----------------------------------|------------|------------------------------------|--------------------------|  
| Arc-enabled servers              | az connectedmachine | 1.1.0 | [az connectedmachine](/cli/azure/connectedmachine?view=azure-cli-latest&preserve-view=true)  |
| Azure Arc-enabled Kubernetes clusters  | az connectedk8s <br></br> az k8s-extension <br></br> az k8s-configuration <br></br> az customlocation | connectedk8s: 1.6.2 <br></br> k8s-extension: 1.4.5 <br></br> k8sconfiguration: 2.0.0 <br></br> customlocation: 0.1.4 | [az connectedk8s](/cli/azure/connectedk8s?view=azure-cli-latest&preserve-view=true) <br></br> [az k8s-extension](/cli/azure/k8s-extension?view=azure-cli-latest&preserve-view=true) <br></br> [az k8s-configuration flux](/cli/azure/k8s-configuration/flux?view=azure-cli-latest&preserve-view=true) <br></br> [az customlocation](/cli/azure/customlocation?view=azure-cli-latest&preserve-view=true)  |
| Azure Local VMs enabled by Azure Arc    | az arcappliance <br></br> az k8s-extension <br></br> az customlocation <br></br> az stack-hci-vm | arcappliance: 1.5.0 <br></br> k8s-extension: 1.4.5 <br></br> customlocation: 0.1.4 <br></br> stack-hci-vm: 1.10.4 | [Enable Azure VM extensions using CLI](/azure/azure-arc/servers/manage-vm-extensions-cli) <br></br> [Troubleshoot Arc-enabled servers VM extension issues](/azure/azure-arc/servers/troubleshoot-vm-extensions)  |
| AKS Arc on Azure Local | az arcappliance <br></br> az k8s-extension <br></br> az customlocation <br></br> az stack-hci-vm <br></br> az aksarc | arcappliance: 1.5.0 <br></br> k8s-extension: 1.4.5 <br></br> customlocation: 0.1.4 <br></br> stack-hci-vm: 1.10.4 <br></br> aksarc: 1.2.23 | [Create Kubernetes clusters using Azure CLI](/azure/aks/aksarc/aks-create-clusters-cli) |
| Azure Local Resource Provider          | Arcappliance <br></br> k8s-extension <br></br> customlocation <br></br> stack-hci-vm <br></br> connectedk8s <br></br> stack-hci | arcappliance: 1.5.0 <br></br> k8s-extension: 1.4.5 <br></br> customlocation: 0.1.4 <br></br> stack-hci-vm: 1.10.4 <br></br> connectedk8s: 1.6.2 <br></br> stack-hci: 1.1.0 | [How to install and manage Azure CLI extensions](/cli/azure/azure-cli-extensions-overview) |
| Azure Container Registry | Built-in      |    |  |
| Azure Policy | Built-in      |    | [Quickstart: Create a policy assignment to identify noncompliant resources using Azure CLI](/azure/governance/policy/assign-policy-azurecli) |
| Azure Key Vault | Built-in      |    | [Quickstart: Create a key vault using Azure CLI](/azure/key-vault/general/quick-create-cli) |

## Troubleshoot Azure CLI

To troubleshoot Azure CLI, run CLI commands with the --debug parameter to get detailed logs and a stack trace. If the client doesn't trust your root CA, requests to private cloud endpoints can fail with SSL or connection errors.

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end

