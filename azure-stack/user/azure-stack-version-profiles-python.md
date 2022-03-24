---
title: Use API version profiles with Python in Azure Stack Hub 
description: Learn how to use API version profiles with Python in Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 11/4/2021
ms.author: sethm
ms.reviewer: weshi1
ms.lastreviewed: 3/24/2022

# Intent: As an Azure Stack user, I want to use API version profiles with Python in Azure Stack so I can benefit from the use of profiles.
# Keyword: azure stack api profiles python

---


# Use API version profiles with Python in Azure Stack Hub
The Python SDK supports API version profiles to target different cloud platforms, such as Azure Stack Hub and global Azure. Use API profiles in creating solutions for a hybrid cloud.

The instructions in this article require a Microsoft Azure subscription. If you don't have one, you can get a [free trial account](https://go.microsoft.com/fwlink/?LinkId=330212).

## Python and API version profiles

The Python SDK supports the following API profiles:

- **latest**  
    This profile targets the most recent API versions for all service providers in the Azure platform.
- **2020_09_01_hybrid**  
    This profile targets the latest API versions for all the resource providers in the Azure Stack Hub platform for versions 2102 or later.
- **2019_03_01_hybrid**  
    This profile targets the latest API versions for all the resource providers in the Azure Stack Hub platform for versions 1904 or later.

   For more info on API profiles and Azure Stack Hub, see [Manage API version profiles in Azure Stack Hub](azure-stack-version-profiles.md).

## Install the Azure Python SDK

1. [Install Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).
1. [Install Python SDK](/python/azure/python-sdk-azure-install?view=azure-python&preserve-view=true).

## Profiles
To use a previous version, simply substitute the `date` in `v<date>_hybrid`. E.g., for 2008 version, the profile is `2019_03_01`, and the string would become `v2019_03_01_hybrid`. Note that sometimes the SDK team changes the name of the packages, so simply replacing the date of a string with a different date might not work. See table below for association of profiles and Azure Stack versions.

| Azure Stack Version | Profile |
|---------------------|---------|
|2108|2020_09_01|
|2102|2020_09_01|
|2008|2019_03_01|

For more information about Azure Stack Hub and API profiles, see the [Summary of API profiles](azure-stack-version-profiles.md).

See [Python SDK profiles](https://docs.microsoft.com/en-us/python/api/azure-common/azure.profiles.knownprofiles?view=azure-python).

## Subscription

If you do not already have a subscription, create a subscription and save the subscription Id to be used later. For information about how to create a subscription, see this [document](../operator/azure-stack-subscribe-plan-provision-vm.md).

## Service Principal

A service principal and its associated environment information should be created and saved somewhere. Service principal with `owner` role is recommended, but depending on the sample, a `contributor` role may suffice. Refer to the values in the [sample repository](https://github.com/Azure-Samples/Hybrid-Python-Samples#setup-secret-service-principal) for the required values. You may read these values in any format supported by the SDK language such as from a JSON file (which our samples use). Depending on the sample being run, not all of these values may be used. See the [sample repository](https://github.com/Azure-Samples/Hybrid-Python-Samples) for updated sample code or further information.

## Tenant Id

To find the directory or tenant Id for your Azure Stack Hub, follow the instructions [in this article](https://docs.microsoft.com/en-us/azure-stack/user/authenticate-azure-stack-hub?view=azs-2108#get-the-tenant-id).

## Register Resource Providers

Register required resource providers by following this [document](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-providers-and-types). These resource providers will be required depending on the samples you want to run. For example, if you want to run VM sample, the `Microsoft.Compute` resource provider registration is required.

## Azure Stack Resource Manager Endpoint

Azure Resource Manager (ARM) is a management framework that enables administrators to deploy, manage, and monitor Azure resources. Azure Resource Manager can handle these tasks as a group, rather than individually, in a single operation. You can get the metadata info from the Resource Manager endpoint. The endpoint returns a JSON file with the info required to run your code.

Consider the following:

- The **ResourceManagerEndpointUrl** in the Azure Stack Development Kit (ASDK) is: `https://management.local.azurestack.external/`.

- The **ResourceManagerEndpointUrl** in integrated systems is: `https://management.region.<fqdn>/`, where `<fqdn>` is your fully qualified domain name.
- To retrieve the metadata required: `<ResourceManagerUrl>/metadata/endpoints?api-version=1.0`

Sample JSON:

```json
{
   "galleryEndpoint": "https://portal.local.azurestack.external:30015/",
   "graphEndpoint": "https://graph.windows.net/",
   "portal Endpoint": "https://portal.local.azurestack.external/",
   "authentication": 
      {
         "loginEndpoint": "https://login.windows.net/",
         "audiences": ["https://management.yourtenant.onmicrosoft.com/3cc5febd-e4b7-4a85-a2ed-1d730e2f5928"]
      }
}
```

## Trust the Azure Stack Hub CA root certificate

If you are using the ASDK, you must explicitly trust the CA root certificate on your remote machine. You do not need to trust the CA root certificate with Azure Stack Hub integrated systems.

#### Windows

1. Find the Python certificate store location on your machine. The location may vary, depending on where you installed Python. Open a command prompt or an elevated PowerShell prompt, and type the following command:

    ```PowerShell  
      python -c "import certifi; print(certifi.where())"
    ```

    Make a note of the certificate store location; for example, **~/lib/python3.5/site-packages/certifi/cacert.pem**. Your particular path depends on your operating system and the version of Python that you have installed.

1. Trust the Azure Stack Hub CA root certificate by appending it to the existing Python certificate:

    ```powershell
    $pemFile = "<Fully qualified path to the PEM certificate; for ex: C:\Users\user1\Downloads\root.pem>"

    $root = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    $root.Import($pemFile)

    Write-Host "Extracting required information from the cert file"
    $md5Hash    = (Get-FileHash -Path $pemFile -Algorithm MD5).Hash.ToLower()
    $sha1Hash   = (Get-FileHash -Path $pemFile -Algorithm SHA1).Hash.ToLower()
    $sha256Hash = (Get-FileHash -Path $pemFile -Algorithm SHA256).Hash.ToLower()

    $issuerEntry  = [string]::Format("# Issuer: {0}", $root.Issuer)
    $subjectEntry = [string]::Format("# Subject: {0}", $root.Subject)
    $labelEntry   = [string]::Format("# Label: {0}", $root.Subject.Split('=')[-1])
    $serialEntry  = [string]::Format("# Serial: {0}", $root.GetSerialNumberString().ToLower())
    $md5Entry     = [string]::Format("# MD5 Fingerprint: {0}", $md5Hash)
    $sha1Entry    = [string]::Format("# SHA1 Fingerprint: {0}", $sha1Hash)
    $sha256Entry  = [string]::Format("# SHA256 Fingerprint: {0}", $sha256Hash)
    $certText = (Get-Content -Path $pemFile -Raw).ToString().Replace("`r`n","`n")

    $rootCertEntry = "`n" + $issuerEntry + "`n" + $subjectEntry + "`n" + $labelEntry + "`n" + `
    $serialEntry + "`n" + $md5Entry + "`n" + $sha1Entry + "`n" + $sha256Entry + "`n" + $certText

    Write-Host "Adding the certificate content to Python Cert store"
    Add-Content "${env:ProgramFiles(x86)}\Python35\Lib\site-packages\certifi\cacert.pem" $rootCertEntry

    Write-Host "Python Cert store was updated to allow the Azure Stack Hub CA root certificate"
    ```

> [!NOTE]  
> If you are using **virtualenv** for developing with Python SDK as mentioned in the following [Run the Python sample](#run-the-python-sample) section, you must add the previous certificate to your virtual environment certificate store. The path might look similar to: `..\mytestenv\Lib\site-packages\certifi\cacert.pem`.

## Samples

See the [sample repository](https://github.com/Azure-Samples/Hybrid-Python-Samples) for update-to-date sample code. The root `README.md` describes general requirements, and each sub-directory contains a specific sample with its own `README.md` on how to run that sample.

## Next steps

- [Azure Python developer center](https://azure.microsoft.com/develop/python/)
- [Azure Virtual Machines documentation](https://azure.microsoft.com/services/virtual-machines/)
- [Learning Path for Virtual Machines](/learn/paths/deploy-a-website-with-azure-virtual-machines/)
