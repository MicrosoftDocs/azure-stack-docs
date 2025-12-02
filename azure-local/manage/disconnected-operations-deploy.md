---
title: Deploy Disconnected Operations for Azure Local (preview)
description: Learn how to deploy disconnected operations for Azure Local in your datacenter (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 10/16/2025
ai-usage: ai-assisted
---

# Deploy disconnected operations for Azure Local (preview)

::: moniker range=">=azloc-2506"

This article explains how to deploy disconnected operations for Azure Local in your datacenter. You learn how to determine the Azure Local topology, prepare the first machine, install the appliance, and create the Azure Local instance for improved resilience and control.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Key considerations

When deploying Azure Local with disconnected operations, consider the following key points:

- The network configuration and names entered in the portal should be consistent with your setup and the previously created switches.
- Virtual deployments aren't supported. Physical machines are required.
- A minimum of three machines is required to support disconnected operations. Up to eight machines are supported.
- The deployment of the Azure Local cluster can take several hours.
- The local control plane can experience periods of downtime during node reboots and updates.
- During the creation of the cluster, a thinly provisioned 2-TB infrastructure volume is created for disconnected operations. Don't tamper with or delete the infrastructure volumes created during the deployment process.
- When you create the Azure Local instance, the disconnected operations VM appliance is moved to cluster storage and converted to a clustered VM.

## Prerequisites

|Requirements                | Details      |
|----------------------------|--------------|
| Hardware                   | [Plan and understand the hardware](disconnected-operations-overview.md#preview-participation-criteria) |
| Identity                   | [Plan and understand the identity](disconnected-operations-identity.md) |
| Networking                 | [Plan and understand the networking](disconnected-operations-network.md) |
| Public key infrastructure  | [Plan and understand the public key infrastructure (PKI)](disconnected-operations-pki.md) |
| Set up                     | [Set up disconnected operations for Azure Local](disconnected-operations-set-up.md) |

For more information, see [Azure Local disconnected operations overview](disconnected-operations-overview.md).

For information on known issues identified with disconnected operations for Azure Local, see [Known issues for disconnected operations](disconnected-operations-known-issues.md).

## Checklist for deploying disconnected operations

Here's a checklist of things you need before you deploy Azure Local with disconnected operations:

- Network plan:
  - IP pool, Ingress IP, Fully Qualified Domain Name (FQDN), Domain name system (DNS), and Gateway (GW).
- DNS server to resolve IP to FQDN names.
- Local credentials for Azure Local machines.
- Active directory credentials for Azure Local deployment.
- [Active directory OU and networking requirements](../deploy/deployment-prerequisites.md).
- [Local credentials and AD credentials to meet minimum password complexity](../deploy/deployment-prerequisites.md).
- [Active directory prepared for Azure Local deployment](../deploy/deployment-prep-active-directory.md).
- Certificates to secure ingress endpoints (24 certificates) and the public key (root) used to create these certificates.
- Certificates to secure the management endpoint (two certificates).
- Credentials and parameters to integrate with identity provider:
  - Active Directory Federations Services (ADFS) application, credentials, server details, and certificate chain details for certificates used in identity configuration.
- Disconnected operations deployment files (manifest and appliance).
- The Azure Local composite ISO (follows release 2506 or later).
- Firmware/device drivers from OEM.

## Deployment sequence  

In this preview, you can deploy Azure Local with disconnected operations on non-premier hardware stock keeping units (SKUs). For more information, see [Azure Local Catalog](https://azurelocalsolutions.azure.microsoft.com/).

You deploy and configure Azure Local with disconnected operations in multiple steps. The following image shows the overall journey, including post-deployment.

:::image type="content" source="./media/disconnected-operations/deployment/deployment-journey.png" alt-text="Screenshot of the deployment flow for disconnected operations in Azure Local." lightbox=" ./media/disconnected-operations/deployment/deployment-journey.png":::

Here's a brief overview of the tools and processes used during the deployment. Access to Azure Local nodes (OS or host) might be required.

1. Use the existing tools and processes to install and configure the OS. Local admin access is required on all Azure Local nodes.
1. Run PowerShell and the Operations module on the first machine (sorted by node name like `seed node`). Local admin access is required.
1. Use the local Azure portal or Azure CLI. You don't need physical node access, but you do need Azure Role-Based Access Control (RBAC) with the **Owner role**.
1. Use the local Azure portal or Azure CLI. You don't need physical node access, but you do need Azure RBAC with the **Operator role**.

## Prepare Azure Local machines  

To prepare each machine for the disconnected operations appliance, follow these steps:

1. Download the Azure Local ISO (2506 and later).  

1. Install the OS and configure the node networking for each Azure Local machine you intend to use to form an instance. For more information, see [Install the Azure Stack HCI operating system](../deploy/deployment-install-os.md).  

1. On physical hardware, install firmware and drivers as instructed by your OEM.
1. Rename network adapters.

   Use the same adapter name on each node for the physical network. If the default names aren’t clear, rename the adapters to meaningful names. If the adapter names already match and you don't need to rename them, skip this step.

   Here's an example:

     ```powershell
      Rename-NetAdapter -Name "Mellanox #1" -NewName "ethernet"
      Rename-NetAdapter -Name "Mellanox #2" -NewName "ethernet 2" 
      # Other examples for naming e.g."storage port 0" 
     ```

1. Set up the virtual switches according to your planned network:  
   - [Network considerations for cloud deployments of Azure Local](../plan/cloud-deployment-network-considerations.md).
   - If your network plan groups all traffic (management, compute, and storage), create a virtual switch called `ConvergedSwitch(ManagementComputeStorage)` on each node.  

     ```powershell
      # Example
      $networkIntentName = 'ManagementComputeStorage'
      New-VMSwitch -Name "ConvergedSwitch($networkIntentName)" -NetAdapterName "ethernet","ethernet 2"  
     ```

   - If you use VLANs, make sure you set the network adapter VLAN.

     ```powershell
     Set-NetAdapter -Name "ethernet 1" -VlanID 10
     ```

1. [Rename each node](/powershell/module/microsoft.powershell.management/rename-computer?view=powershell-7.4&preserve-view=true) according to your environments naming conventions. For example, azlocal-n1, azlocal-n2, and azlocal-n3.  

1. Check and make sure you have sufficient disk space for disconnected operations deployment.

    Make sure you have at least 600 GB of free space on the drive you plan to use for deployment. If your drive has less space, use a data disk on each node and initialize it so each node has the same available data disks for deployment.

    Here’s how to initialize a disk on the nodes and format it for a D partition: 

    ```powershell
    $availableDrives = Get-PhysicalDisk | Where-Object { $_.MediaType -eq "SSD" -or $_.MediaType -eq "NVMe" } | where -Property CanPool -Match "True" | Sort-Object Size -Descending
    $driveGroup = $availableDrives | Group-Object Size | select -First 1
    $biggestDataDrives = $availableDrives | select -First $($driveGroup.Count)
    $firstDataDrive= ($biggestDataDrives | Sort-Object DeviceId | select -First 1).DeviceId
    Initialize-Disk -Number $firstDataDrive
    New-partition -disknumber $firstDataDrive -usemaximumsize | format-volume -filesystem NTFS -newfilesystemlabel Data
    Get-partition -disknumber $firstDataDrive -PartitionNumber 2 | Set-Partition -NewDriveLetter D
    ```

1. On each node, copy the root certificate public key. For more information, see [PKI for disconnected operations](disconnected-operations-pki.md). Modify the paths according to the location and method you use to export your public key for creating certificates.  

    ```powershell
    $applianceConfigBasePath = "C:\AzureLocalDisconnectedOperations\"
    $applianceRootCertFile = "C:\AzureLocalDisconnectedOperations\applianceRoot.cer"
    
    New-Item -ItemType Directory $applianceConfigBasePath
    Copy-Item \\fileserver\share\azurelocalcerts\publicroot.cer $applianceRootCertFile
 
1. Copy to the **APPData/Azure** Local folder and name it **azureLocalRootCert**. Use this information during the Arc appliance deployment.  

    ```powershell
    Copy-Item $applianceRootCertFile "$($env:APPDATA)\AzureLocal\AzureLocalRootCert.cer"
    ```

1. On each node, import the public key into the local store:

    ```powershell
    Import-Certificate -FilePath $applianceRootCertFile -CertStoreLocation Cert:\LocalMachine\Root -Confirm:$false
    ```

    > [!NOTE]
    > If you use a different root for the management certificate, repeat the process and import the key on each node.

1. [Install and configure the CLI](disconnected-operations-cli.md) with your local endpoint on each node.

1. Set the environment variable to support disconnected operations

    ```powershell
    [Environment]::SetEnvironmentVariable("DISCONNECTED_OPS_SUPPORT", $true, [System.EnvironmentVariableTarget]::Machine)
    ```

1. Find the first machine from the list of node names and specify it as the `seednode` you want to use in the cluster.

    ```powershell
    $seednode = @('azlocal-1', 'azlocal-2','azlocal-3')|Sort|select –first 1
    $seednode
    ```

    > [!NOTE]
    > Be sure to deploy disconnected operations on this node.

## Deploy disconnected operations

Disconnected operations must be deployed on the seed node. To make sure you do the following steps on the first machine, see [Prepare Azure Local machines](#prepare-azure-local-machines).

To prepare the first machine for the disconnected operations appliance, follow these steps:

1. Modify your path to correct location. 

    If you initialized a data disk or are using a different path than C: modify the `$applianceConfigBasePath`.

    Here's an example:

    ```powershell
    $applianceConfigBasePath = 'C:\AzureLocalDisconnectedOperations'
    ```

1. Copy the disconnected operations installation files (appliance zip, vhdx, and manifest) to the first machine. Save these files into the base folder you created earlier. 

    ```powershell  
    Copy-Item \\fileserver\share\azurelocalfiles\* $applianceConfigBasePath    
    ```  

1. Verify that you have these files in your base folder using the following command:

    - AzureLocal.DisconnectedOperations.zip
    - AzureLocal.DisconnectedOperations.manifest
    - ArcA_LocalData_A.vhdx
    - ArcA_SharedData_A.vhdx
    - OSAndDocker_A.vhdx

      ```powershell  
      Get-ChildItem $applianceConfigBasePath  
      ```  

1. Extract the zip file in the same folder:  

    ```powershell  
    Expand-Archive "$($applianceConfigBasePath)\AzureLocal.DisconnectedOperations.zip" -DestinationPath $applianceConfigBasePath  
    ```  

1. Verify that you have these files using the following command:

    - OperationsModule (PowerShell module for installation)
    - AzureLocal.DisconnectedOperations.manifest
    - AzureLocal.DisconnectedOperations.zip 
    - manifest.xml
    - IRVM.zip
    - ArcA_LocalData_A.vhdx
    - ArcA_SharedData_A.vhdx
    - OSAndDocker_A.vhdx
    - Storage.json

      ```powershell  
      Get-ChildItem $applianceConfigBasePath   
      ```  

      > [!NOTE]  
      > At this point, remove the `AzureLocal.DisconnectedOperations.zip` file to save some space.

1. Copy the certificates root directory. Save these files into the base folder you created earlier.  

    ```powershell  
    $certsPath = "$($applianceConfigBasePath)\certs"  
    Copy-Item \\fileserver\share\azurelocalcerts $certspath -recurse  
    ```

1. Verify the certificates, public key, and management endpoint. You should have two folders: `ManagementEndpointCerts` and `IngressEndpointsCerts` and at least 24 certificates.

    ```powershell  
    Get-ChildItem $certsPath 
    Get-ChildItem $certsPath -recurse -filter *.cer  
    ```  

1. Import the **Operations module**. Run the command as an administrator using PowerShell. Modify the path to match your folder structure.

    ```powershell  
    Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force    

    $mgmntCertFolderPath = "$certspath\ManagementEndpointCerts"  
    $ingressCertFolderPath = "$certspath\IngressEndpointsCerts"  
    ```

## Initialize the parameters

Populate the required parameters based on your deployment planning. Modify the examples to match your configuration.

1. Populate the management network configuration object.

    ```powershell  
    $CertPassword = "retracted"|ConvertTo-Securestring -AsPlainText -Force  
    $ManagementIngressIpAddress = "192.168.50.100"  
    $ManagementNICPrefixLength = 24  
    $mgmtNetworkConfigParams = @{  
        ManagementIpAddress = $ManagementIngressIpAddress  
        ManagementIpv4PrefixLength = $ManagementNICPrefixLength  
        TlsCertificatePath = "$mgmntCertFolderPath\ManagementEndpointSsl.pfx"  
        TlsCertificatePassword = $CertPassword  
        ClientCertificatePath = "$mgmntCertFolderPath\ManagementEndpointClientAuth.pfx"  
        ClientCertificatePassword = $CertPassword  
    }  
    $managementNetworkConfiguration = New-ApplianceManagementNetworkConfiguration @mgmtNetworkConfigParams  
    ```  

    > [!NOTE]  
    > The password for the certificates must be in the secure string format. For certificates pertaining to the management endpoint, see [PKI for disconnected operations](disconnected-operations-pki.md).

1. Populate the ingress network configuration object.

    ```powershell  
    $azureLocalDns = "192.168.200.150"  
    $NodeGw = "192.168.200.1"  
    $IngressIpAddress = "192.168.200.115"  
    $NICPrefixLength= 24  
    $ingressNetworkConfigurationParams = @{  
        DnsServer = $azureLocalDns  
        IngressNetworkGateway = $NodeGw  
        IngressIpAddress = $IngressIpAddress  
        IngressNetworkPrefixLength = $NICPrefixLength  
        ExternalDomainSuffix = "autonomous.cloud.private"
    }  
    $ingressNetworkConfiguration = New-ApplianceIngressNetworkConfiguration @ingressNetworkConfigurationParams  
    ```  

    For network configuration details, see [Networking for disconnected operations](disconnected-operations-network.md).

1. Populate the identity configuration object.

    ```powershell  
    $oidcCertChain = Get-CertificateChainFromEndpoint -requestUri 'https://adfs.azurestack.local/adfs'        
    # This can be ommitted if you don't have ldaps 
    $ldapsCertChain = Get-CertificateChainFromEndpoint -requestUri 'https://dc01.azurestack.local'
    # Ldaps default port (Non secure default = 3268)
    $ldapPort = 3269

    $ldapPassword = 'RETRACTED'|ConvertTo-SecureString -AsPlainText -Force
    # Populate params with ldaps enabled.
    $identityParams = @{  
        Authority = "https://adfs.azurestack.local/adfs"  
        ClientId = "<ClientId>"  
        RootOperatorUserPrincipalName = "operator@azurestack.local"  
        LdapServer = "adfs.azurestack.local"  
        LdapPort = $ldapPort 
        LdapCredential = New-Object PSCredential -ArgumentList @("ldap", $ldapPassword)  
        SyncGroupIdentifier = "<SynGroupIdentifier>"     
        OidcCertChainInfo = $oidcCertChain
        LdapsCertChainInfo = $ldapsCertChain             
    }  
    $identityConfiguration = New-ApplianceExternalIdentityConfiguration @identityParams  
    ```  

    > [!NOTE]  
    > `LdapsCertChainInfo` and `OidcCertChain` can be omitted completely for debugging or demo purposes. For information on how to get LdapsCertChainInfo and OidcCertChainInfo, see [PKI for disconnected operations](disconnected-operations-pki.md). In this preview release, there's an issue with the `Get-CertificateChainFromEndpoint` not being exported as intended. Use the steps in [Known issues for disconnected operations for Azure Local](disconnected-operations-known-issues.md) to mitigate this issue.

    

    For more information, see [Identity for disconnected operations](disconnected-operations-identity.md).  

1. Populate the external certificates configuration object.

    ```powershell  
    $ingressCertPassword = "retracted"|ConvertTo-Securestring -AsPlainText -Force  
    $certsParams = @{  
        certificatesFolder = $ingressCertFolderPath  
        certificatePassword = $ingressCertPassword  
    }  
    $CertificatesConfiguration = New-ApplianceCertificatesConfiguration @certsParams  
    ```  

    For more information, see [PKI for disconnected operations](disconnected-operations-pki.md).

1. Copy the appliance manifest file (Downloaded from Azure) to your configuration folder:

    ```powershell
    # Modify your source path accordingly 
    copy-item AzureLocal.DisconnectedOperations.Manifest.json $applianceConfigBasePath\AzureLocal.DisconnectedOperations.manifest.json
    ```  

## Install and configure the appliance  

To install and configure the appliance on the first machine, use the following command. Point the `AzureLocalInstallationFile` to a path that contains the **IRVM01.zip**.

```powershell
$networkIntentName = 'ManagementComputeStorage' 
$azureLocalInstallationFile = "$($applianceConfigBasePath)"  
$applianceManifestJsonPath = Join-Path $applianceConfigBasePath AzureLocal.DisconnectedOperations.manifest.json

$installAzureLocalParams = @{  
    Path = $azureLocalInstallationFile  
    IngressNetworkConfiguration = $ingressNetworkConfiguration  
    ManagementNetworkConfiguration = $managementNetworkConfiguration  
    IngressSwitchName = "ConvergedSwitch($networkIntentName)"  
    ManagementSwitchName = "ConvergedSwitch($networkIntentName)"  
    ApplianceManifestFile = $applianceManifestJsonPath  
    IdentityConfiguration = $identityConfiguration  
    CertificatesConfiguration = $CertificatesConfiguration      
    DisableCheckSum = $true  
    AutoScaleVMToHostHW = $false  
}  

Install-Appliance @installAzureLocalParams -disconnectMachineDeploy -Verbose  

# Note: If you're deploying the appliance with limited connectivity you can ommit the flag -disconnectMachineDeploy. 
```

> [!NOTE]
> Install the appliance on the first machine to ensure Azure Local deploys correctly. The setup takes a few hours and must finish successfully before you move on. Once it’s complete, you have a local control plane running in your datacenter.
>
> If the installation fails because of incorrect network, identity, or observability settings, update the configuration object and run the `Install-appliance` command again.
>
> You can also specify the -clean switch to start installation from scratch. This switch resets any existing installation state and starts from the beginning
>
> DisableChecksum = $true will skip validating the signature of the Appliance. Use this when deploying an air-gapped environment in this release. If checksum validation is enabled - the node needs to be able to reach and validate the Microsoft cert signing certificates used for signing this build.  

## Configure observability for diagnostics and support

We recommend that you configure observability to get system-generated logs for your first deployment. This doesn't apply if you're planning to run air-gapped, as system-generated logs and diagnostics require connectivity.

The Azure resources needed:

- A resource group in Azure used for the appliance.
- A Service Principal Name (SPN) with contributor rights on the resource group.

To configure observability, follow these steps:

1. On a computer with Azure CLI (or using the Azure Cloud Shell in Azure portal) create the SPN. Run the following script:

    ```powershell
    $resourcegroup = 'azure-disconnectedoperations'
    $appname = 'azlocalobsapp'
    az login
    $g = (az group create -n $resourcegroup -l eastus)|ConvertFrom-Json
    az ad sp create-for-rbac -n $appname --role Owner --scopes $g.id
    
    # get the subscription id
    $j = (az account list|ConvertFrom-Json)|Where-object { $_.IsDefault}
    
    # SubscriptionID:
    $j.id
    ```

    Here's an example output:

    ```json
    {
      "appId": "<AppId>",
      "displayName": "azlocalobsapp",
      "password": "<RETRACTED>",
      "tenant": "<RETRACTED>"
    }
    <subscriptionID>
    ```

1. Set the observability configuration. Modify to match your environment details:

    ```powershell
    $observabilityConfiguration = New-ApplianceObservabilityConfiguration -ResourceGroupName "azure-disconnectedoperations" `
      -TenantId "<TenantID>" `
      -Location "<Location>" `
      -SubscriptionId "<SubscriptionId>" `
      -ServicePrincipalId "<AppId>" `
      -ServicePrincipalSecret ("<Password>"|ConvertTo-SecureString -AsPlainText -Force)

    Set-ApplianceObservabilityConfiguration -ObservabilityConfiguration $observabilityConfiguration
    ```

1. Verify that observability is configured:

    ```powershell
    Get-ApplianceObservabilityConfiguration
    ```
### Fully disconnected (air-gapped) deployments

To enable Azure Local in a fully air-gapped (nodes without direct internet connection) deployment, do the following on each node:

- Configure the timeserver to use your domain controller. Modify the script and run it from PowerShell:

```powershell
w32tm /config /manualpeerlist:"dc.contoso.com" /syncfromflags:manual /reliable:yes /update
net stop w32time
net start w32time
w32tm /resync /rediscover
# Check your NTP settings
w32tm /query /peers
```

Download (or copy) the following certificates and import them into the local trust store:

- [MicCodSigPCA2011](https://www.microsoft.com/pkiops/certs/MicCodSigPCA2011_2011-07-08.crt)

- [DigiCertGlobalRootCA](https://cacerts.digicert.com/DigiCertGlobalRootCA.crt?utm_medium=organic&utm_source=msazure-visualstudio&referrer=https://msazure.visualstudio.com/&_gl=1*1c6vxin*_gcl_au*MTE2OTcyNDYyMy4xNzUyMTg0NDU5)

- [DigiCertGlobalRootG2](https://cacerts.digicert.com/DigiCertGlobalRootG2.crt?utm_medium=organic&utm_source=msazure-visualstudio&referrer=https://msazure.visualstudio.com/&_gl=1*1c6vxin*_gcl_au*MTE2OTcyNDYyMy4xNzUyMTg0NDU5)

Place them in a folder, for example, C:\AzureLocalDisconnectedOperations\Certs\

Import the certs by running the following:

```powershell
Import-Certificate -FilePath C:\AzureLocalDisconnectedOperations\Certs\MicCodSigPCA2011_2011-07-08.crt -CertStoreLocation Cert:\LocalMachine\Root -Confirm:$false
Import-Certificate -FilePath C:\AzureLocalDisconnectedOperations\Certs\DigiCertGlobalRootCA.cer Cert:\LocalMachine\Root -Confirm:$false
Import-Certificate -FilePath C:\AzureLocalDisconnectedOperations\Certs\DigiCertGlobalRootG2.cer -CertStoreLocation Cert:\LocalMachine\Root -Confirm:$false
```

## Create a subscription for Azure Local nodes (infrastructure)

Create a subscription for your Azure Local nodes and the Azure Local instance (cluster).

1. Sign in to the local Azure portal at https://portal.</FQDN>. Replace </FQDN> with your domain name.  
2. Go to **Subscriptions**.  
3. Select **+ Add**.  
4. For Subscription name, enter a name such as *Starter subscription*.  
5. Select the subscription owner who will have the Owner (RBAC) role on this subscription.  
6. For Location, leave the value set to Autonomous.  
7. Select **Create**, wait for the operation to finish, then refresh the browser to confirm the new subscription appears.

> [!NOTE]
> Alternatively, use Azure CLI or PowerShell to automate this process.

### Create resource group and service principal for the Azure Local instance

Use the operator account to create an SPN for Arc initialization of each Azure Local node. For bootstrap, the Owner role is required at the subscription level.

To create the SPN, follow these steps:

1. Configure CLI on your client machine and run this command:

    ```azurecli  
    $subscriptionName = 'Starter subscription'
    $resourcegroup = 'azurelocal-disconnected-operations'
    $appname = 'azlocalclusapp'      
    az cloud set -n 'azure.local'
    az login      
    az account set --subscription $subscriptionName
    $subscriptionId = az account show --query id --output tsv
    $g = (az group create -n $resourcegroup -l autonomous)|ConvertFrom-Json  
    az ad sp create-for-rbac -n $appname --role Owner --scopes "/subscriptions/$($subscriptionId)"  
    ```  

    Here's an example output:

    ```json  
    {  
      "appId": "<AppId>",  
      "displayName": "azlocalclusapp",  
      "password": "<RETRACTED>",  
      "tenant": "<RETRACTED>"  
    }  

1. Copy out the AppID and password for use in the next step.

    > [!NOTE]
    > Plan the subscription and resource group where you want to place your nodes and cluster. The resource move action isn't supported.
    >
    > The cluster resource created during deployment is used for workloads like VMs and Azure Kubernetes Services, so plan your role-based access controls accordingly.
    > 
    > Don't place the cluster resource in the operator subscription, unless you plan to restrict this to only operators with full access to other operations. You can create more subscriptions or place it in the starter subscription.

## Register required resource providers

Make sure you register the required resource providers before deployment. 

Here's an example of how to automate the resource providers registration from Azure CLI.

```azurecli  
    # Replace with the subscription you just created if you access to multiple subscriptions
    $subscriptionName = 'Starter subscription'
    az cloud set -n 'azure.local'
    az login          
    az account set --subscription $subscriptionName
    az provider register --namespace Microsoft.AzureStackHCI
    az provider register --namespace Microsoft.ExtendedLocation
    az provider register --namespace Microsoft.ResourceConnector
    az provider register --namespace Microsoft.EdgeArtifact
    az provider register --namespace Microsoft.KubernetesConfiguration
    az provider register --namespace Microsoft.HybridContainerService
```
Wait until all resource providers are in the state **Registered**. 

Here's a sample Azure CLI command to list all resource providers and their statuses.

```azurecli  
    az provider list -o table
```

> [!NOTE]
> You can also register or view resource provider statuses in the local portal. To do this, go to your **Subscription**, click the dropdown arrow for **Settings**, and select **Resource providers**.

## Deploy Azure Local

You now have a control plane deployed and configured, a subscription and resource group created for your Azure Local deployment, and (optionally) an SPN created to use for deployment automation.

Verify the deployment before creating local Azure resources.

1. Sign in with the root operator you defined during the deployment, or use a subscription owner account.
1. From a client with network access to your Ingress IP, open your browser and go to `https://portal.<FQDN>`. Replace `<FQDN>` with your domain name.
    - You're redirected to your identity provider to sign in.
1. Sign in to your identity provider with the credentials you configured during deployment.
    - You should see Azure portal running in your network.
1. Check that a subscription exists for your Azure Local infrastructure (for example, Starter subscription).
1. Check that required resource providers are registered in the subscription.
1. Check that a resource group exists for your Azure Local infrastructure (for example, azurelocal-disconnected-operations).

### Initialize each Azure Local node

To initialize each node, follow these steps. Modify where necessary to match your environment details:

1. Set the configuration variable. Define the resource group, cloud name, configuration path, application ID, client secret, and appliance FQDN.

    ```azurecli
    $resourcegroup = 'azurelocal-disconnected-operations' # Needs to match the cloud name your configured CLI with.
    $applianceCloudName = "azure.local"
    $applianceConfigBasePath = "C:\AzureLocalDisconnectedOperations\"
    $appId = 'guid'
    $clientSecret = 'retracted'
    $applianceFQDN = "autonomous.cloud.private"

1. Initialize each node.

    ```powershell
    Write-Host "az login to Disconnected operations cloud"    
    az cloud set -n $applianceCloudName --only-show-errors
    Write-Host "Login using service principal"    
    az login --service-principal --username $appId --password $clientSecret --tenant <TenantId>    
    # If you prefer interactive login..
    # Write-Host "Using device code login - complete the login from your browser"
    # az login --use-device-code

    Write-Host "Connected to Disconnected operations Cloud through az cli"
    ```

1. Get the access token, account ID, subscription ID, and tenant ID.

    ```powershell
    $applianceAccessToken = ((az account get-access-token) | ConvertFrom-Json).accessToken
    $applianceAccountId = $(New-Guid).Guid
    $applianceSubscriptionId = ((az account show) | ConvertFrom-Json).id
    $applianceTenantId = ((az account show) | ConvertFrom-Json).tenantId
    ```

1. Get the cloud configuration details.

    ```powershell
    $cloudConfig = (az cloud show --n $applianceCloudName | ConvertFrom-Json)
    ```

1. Set the environment parameters. Define the environment parameters using the retrieved cloud configuration.

    ```powershell
    $applianceEnvironmentParams = @{
    Name                                      = $applianceCloudName
    ActiveDirectoryAuthority                  = $cloudConfig.endpoints.activeDirectory
    ActiveDirectoryServiceEndpointResourceId  = $cloudConfig.endpoints.activeDirectoryResourceId
    GraphEndpoint                             = $cloudConfig.endpoints.activeDirectoryGraphResourceId
    MicrosoftGraphEndpointResourceId          = $cloudConfig.endpoints.microsoftGraphResourceId
    ResourceManagerEndpoint                   = $cloudConfig.endpoints.resourceManager
    StorageEndpoint                           = $cloudConfig.suffixes.storageEndpoint
    AzureKeyVaultDnsSuffix                    = $cloudConfig.suffixes.keyvaultDns
    ContainerRegistryEndpointSuffix           = $cloudConfig.suffixes.acrLoginServerEndpoint
    }
    Add-AzEnvironment @applianceEnvironmentParams -ErrorAction Stop | Out-Null
    Write-Host "Added azure.local Environment"
    ```

1. Set the configuration hash.

    ```powershell
    Write-Host "Setting azure.local configurations"
    $hash = @{
    AccountID        = $applianceAccountId
    ArmAccessToken   = $applianceAccessToken
    Cloud            = $applianceCloudName
    ErrorAction      = 'Stop'
    Region           = 'Autonomous'
    ResourceGroup    = $resourcegroup
    SubscriptionID   = $applianceSubscriptionId
    TenantID         = $applianceTenantId
    CloudFqdn        = $applianceFQDN
    }
    ```

1. Arc-enable each node and install extensions to prepare for cloud deployment and cluster creation. 

    ```powershell
    # Important: This must be run on the first machine (seed node) before running it on other nodes. 
    Invoke-AzStackHciArcInitialization @hash
    Write-Host -Subject 'ARC node configuration completed'
    ```
  
    > [!NOTE]  
    > Ensure that you run initialization on the first machine before moving on to other nodes.
    > 
    > Nodes appear in the local portal shortly after you run the steps, and the extensions appear on the nodes a few minutes after installation.  
    >
    > You can also use the [Configurator App](../deploy/deployment-arc-register-configurator-app.md?view=azloc-2506&preserve-view=true) to initialize each node.

## Pre-create Azure Keyvault

Because of a known Azure Key Vault issue that can cause long deployment delays, create the Azure Key Vault before you deploy Azure Local.

For a code example to pre-create the Key Vault, see [Known issues](./disconnected-operations-known-issues.md)

After you create the Key Vault, wait 20 minutes before you continue with the next portal deployment step.

## Create the Azure Local instance (cluster)

With the prerequisites completed, you can deploy Azure Local with a fully air-gapped local control plane.

Follow these steps to create an Azure Local instance (cluster):

1. Access the local portal from a browser of your choice.
1. Navigate to `portal.FQDN`. For example, `https://portal.autonomous.cloud.private`
1. Select your nodes and complete the deployment steps outlined in [Deploy Azure Local using the Azure portal](../deploy/deploy-via-portal.md).  

  > [!NOTE]
  > If you create Azure Key Vault during deployment, wait about 20 minutes for RBAC permissions to take effect.
  >
  > If you see a validation error, it’s a known issue. Permissions might still be propagating. Wait a bit, refresh your browser, and redeploy the cluster.

## Tasks after deploying disconnected operations

Here are some tasks you should perform after deploying Azure Local with disconnected operations:

1. **Back up the BitLocker keys (do not skip this step).**  During deployment your appliance is encrypted. Without the recovery keys for the volumes, you can't recover and restore the appliance. For more information, see [Understand security controls with disconnected operations on Azure Local](disconnected-operations-security.md).

1. **Assign extra operators.** You can assign one or more operators by navigating to **Operator subscriptions**. Assign the **contributor** role at the subscription level.

1. [Export the host guardian service certificates](disconnected-operations-security.md) and backup the folder you export them to on an external share/drive.

## Troubleshoot and reconfigure using management endpoint

To use the management endpoint for troubleshooting and reconfiguration, you need the management IP address used during deployment, along with the client certificate and password used to secure the endpoint.

From a client with network access to the management endpoint, import the **OperationsModule** and set the context (modify the script to match your configuration):

```powershell  
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force

$password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
$context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress "169.254.53.25"  
```  

After setting the context, you can use all the management cmdlets provided by the Operations module, like resetting identity configuration, checking health state, and more.

To get a full list of cmdlets provided, use the PowerShell `Get-Command -Module OperationsModule`. To get details around each cmdlet, use the `Get-Help <cmdletname>` command.

### Troubleshoot: System not configured

After you install the appliance, you might see this screen for a while. Let the configuration run for 2-3 hours. After you wait 2-3 hours, the screen goes away, and you see the regular Azure portal. If the screen doesn't go away and you can't access the local Azure portal, troubleshoot the issue.

:::image type="content" source="./media/disconnected-operations/deployment/system-not-configured.png" alt-text="Screenshot showing the system isn't configured page." lightbox=" ./media/disconnected-operations/deployment/system-not-configured.png":::

- To find logs from the **OperationsModule** on the first machine, go to `C:\ProgramData\Microsoft\AzureLocalDisconnectedOperations\Logs`.

- To view the health state of your appliance, use the management endpoint `Get-ApplianceHealthState` cmdlet. If you see this screen and the cmdlet reports no errors and all services report 100, open a support ticket from the Azure portal.

### Update appliance configuration and rerun installation after failure

If your install-appliance fails update the configuration and retry.

For example:

- If the IP address is already in use.
  - Modify the configuration object.
  
      Here is an example to modify the ingress IP address
  
      ```powershell
      # Set a new IP address
      $ingressNetworkConfiguration.IngressIpAddress = '192.168.0.115'
      ```

- If the install-appliance fails during installation.
  - set `$installAzureLocalParams` and rerun `Install-appliance` as described in [Install and configure the appliance](#install-and-configure-the-appliance).
  
- If the appliance deployment succeeded and you're updating network configuration, see `Get-Help Set-Appliance` for the settings you can update post-deployment.

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end

