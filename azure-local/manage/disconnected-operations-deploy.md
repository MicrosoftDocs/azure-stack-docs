---
title: Deploy Disconnected Operations for Azure Local 
description: Learn how to deploy disconnected operations for Azure Local in your datacenter 
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 02/23/2026
ms.reviewer: haraldfianbakken
ai-usage: ai-assisted
---

# Deploy disconnected operations for Azure Local and the management cluster

::: moniker range=">=azloc-2602"

This article explains how to deploy disconnected operations for Azure Local in your datacenter. This step is key to deploy and operate Azure Local without any outbound network connection. After you deploy the management cluster (control plane), you deploy your first Azure Local instance.

## Key considerations

When deploying disconnected operations and creating your management instance, consider the following key points:

- The network configuration and names you enter in the portal should be consistent with your setup and the previously created switches.
- Virtual deployments aren't supported. You must have physical machines.
- If you require VLAN on the control plane appliance you need to make sure to set that up using Set-VMNetworkAdapterIsolation -ManagementOS .
- You need at least three machines to support disconnected operations. You can use up to 16 machines for the management instance.
- The deployment of the Azure Local cluster can take several hours.
- The local control plane can experience periods of downtime during node reboots and updates.
- During the creation of the cluster, the process creates a thinly provisioned 2-TB infrastructure volume for disconnected operations. Don't tamper with or delete the infrastructure volumes created during the deployment process.
- When you create the Azure Local instance, the process moves the disconnected operations VM appliance to cluster storage and converts it to a clustered VM.

## Prerequisites

| Requirements | Details |
| ---------------------------- | -------------- |
| Hardware | [Plan and understand the hardware](disconnected-operations-overview.md#eligibility-criteria) |
| Identity | [Plan and understand the identity](disconnected-operations-identity.md) |
| Networking | [Plan and understand the networking](disconnected-operations-network.md) |
| Public key infrastructure | [Plan and understand the public key infrastructure (PKI)](disconnected-operations-pki.md) |
| Prepare Azure Local nodes | [Prepare Azure Local for disconnected operations](disconnected-operations-prepare-azure-local.md) |
| Acquire disconnected operations | [Acquire disconnected operations for Azure Local](disconnected-operations-acquire.md) |

For more information, see [Azure Local disconnected operations overview](disconnected-operations-overview.md).

For information on known issues with disconnected operations for Azure Local, see [Known issues for disconnected operations](disconnected-operations-known-issues.md).

## Checklist for deploying disconnected operations

Before you deploy Azure Local with disconnected operations, you need the following:

- Network plan:
  - IP pool, ingress IP, fully qualified domain name (FQDN), domain name system (DNS), and gateway (GW).
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
- The Azure Local composite ISO.
- Firmware/device drivers from OEM.

## Deployment sequence  

Deploy Azure Local with disconnected operations on non-premier hardware stock keeping units (SKUs). For more information, see [Azure Local Catalog](https://azurelocalsolutions.azure.microsoft.com/).

You deploy and configure Azure Local with disconnected operations in multiple steps. The following image shows the overall journey, including post-deployment.

:::image type="content" source="./media/disconnected-operations/deployment/deployment-journey.png" alt-text="Screenshot of the deployment flow for disconnected operations in Azure Local." lightbox=" ./media/disconnected-operations/deployment/deployment-journey.png":::

Here's a brief overview of the tools and processes you use during the deployment. You'll need access to Azure Local nodes (OS or host) for the first phases of the deployment.

1. Use the existing tools and processes to install and configure the OS. You need local admin access on all Azure Local nodes.
1. Run PowerShell and the Operations module on the first machine (sorted by node name like `seed node`). You must have local admin access.
1. Use the local Azure portal, Azure PowerShell, or Azure CLI. You don't need physical node access, but you do need Azure Role-Based Access Control (RBAC) with the **Owner role**.
1. Use the local Azure portal, Azure PowerShell, or Azure CLI. You don't need physical node access, but you do need Azure RBAC with the **Operator role**.

## Deploy disconnected operations (control plane)

Disconnected operations must be deployed on the first machine (seed node). Make sure you complete the following steps on every node in your management cluster. For more information, see [Prepare Azure Local machines](./disconnected-operations-prepare-azure-local.md#prepare-azure-local-machines).

To prepare the first machine for the disconnected operations appliance, follow these steps:

1. Modify your path to correct location. If you initialized a data disk or are using a different path than C: modify the `$applianceConfigBasePath`.

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
    # Omitted this step if you don't have LDAPS.

    $ldapsCertChain = Get-CertificateChainFromEndpoint -requestUri 'https://dc01.azurestack.local'
    
    # LDAPS default port (Non secure default = 3268)
    $ldapPort = 3269
    $ldapPassword = 'RETRACTED'|ConvertTo-SecureString -AsPlainText -Force
    
    # Populate params with LDAPS enabled.
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
    > - `LdapsCertChainInfo` and `OidcCertChain` can be omitted completely for debugging or demo purposes. For information on how to get LdapsCertChainInfo and OidcCertChainInfo, see [PKI for disconnected operations](disconnected-operations-pki.md).
    >
    > There's an issue with the `Get-CertificateChainFromEndpoint` not being exported as intended. Use the steps in [Known issues for disconnected operations for Azure Local](disconnected-operations-known-issues.md) to mitigate this issue.

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
}  

Install-Appliance @installAzureLocalParams -disconnectMachineDeploy -Verbose  

# Note: If you're deploying the appliance with limited connectivity, you can omit the flag -disconnectMachineDeploy.
```

> [!NOTE]
> Install the appliance on the first machine to ensure Azure Local deploys correctly. The setup takes a few hours and must finish successfully before you move on. Once it’s complete, you have a local control plane running in your datacenter.
>
> If the installation fails because of incorrect network, identity, or observability settings, update the configuration object and run the `Install-appliance` command again.
>
> You can also specify the -clean switch to start installation from scratch. This switch resets any existing installation state and starts from the beginning
>
> DisableChecksum = $true skips validating the signature of the Appliance. Use this when deploying an air-gapped environment. If checksum validation is enabled, the node needs to reach and validate the Microsoft cert signing certificates used for signing this build.  

## Configure observability for diagnostics and support

We recommend that you configure observability to get system-generated logs for your first deployment. This doesn't apply if you're planning to run air-gapped, as system-generated logs and diagnostics require connectivity.

The Azure resources needed:

- A resource group in Azure used for the appliance.
- A Service Principal Name (SPN) with contributor rights on the resource group.

To configure observability, follow these steps:

1. On a computer with Azure CLI (or using the Azure Cloud Shell in Azure portal) create the SPN. Run the following script:

    ```azurecli
    $resourcegroup = 'azure-disconnectedoperations'
    $appname = 'azlocalobsapp'
    az login
    $g = (az group create -n $resourcegroup -l eastus)|ConvertFrom-Json
    az ad sp create-for-rbac -n $appname --role Owner --scopes $g.id
    
    # Get the Subscription ID
    $j = (az account list | ConvertFrom-Json) | Where-object {$_.IsDefault}
    
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
      -ServicePrincipalSecret ("<Password>" | ConvertTo-SecureString -AsPlainText -Force)

    Set-ApplianceObservabilityConfiguration -ObservabilityConfiguration $observabilityConfiguration
    ```

1. Verify that observability is configured:

    ```powershell
    Get-ApplianceObservabilityConfiguration
    ```

## Configure Azure PowerShell

On each node, run the following to enable a custom cloud endpoint for Azure PowerShell. You'll use this later when bootstrapping the Azure Local node to the control plane.

```powershell
$applianceCloudName = "azure.local"
$applianceFQDN = "autonomous.cloud.private"

$AdminManagementEndPointUri = "https://armmanagement.$($applianceFQDN)/"
$DirectoryTenantId = "98b8267d-e97f-426e-8b3f-7956511fd63f"

#retrieve disconnected operations endpoints

$armMetadataEndpoint = $AdminManagementEndPointUri.ToString().TrimEnd('/') + "/metadata/endpoints?api-version=2015-01-01"

$endpoints = Invoke-RestMethod -Method Get -Uri $armMetadataEndpoint -ErrorAction Stop

$azEnvironment = Add-AzEnvironment `
-Name $applianceCloudName `
-ActiveDirectoryEndpoint ($endpoints.authentication.loginEndpoint.TrimEnd('/') + "/") `
-ActiveDirectoryServiceEndpointResourceId $endpoints.authentication.audiences[0] `
-ResourceManagerEndpoint $AdminManagementEndPointUri.ToString() `
-GalleryEndpoint $endpoints.galleryEndpoint `
-MicrosoftGraphEndpointResourceId $endpoints.graphEndpoint `
-MicrosoftGraphUrl $endpoints.graphEndpoint `
-AdTenant $DirectoryTenantId `
-GraphEndpoint $endpoints.graphEndpoint `
-GraphAudience $endpoints.graphEndpoint `
-EnableAdfsAuthentication:($endpoints.authentication.loginEndpoint.TrimEnd("/").EndsWith("/adfs",[System.StringComparison]::OrdinalIgnoreCase)) 


# Verify that you can connect to the ARM endpoint (example showing device authentication)
Connect-AzAccount -EnvironmentName $applianceCloudName -UseDeviceAuthentication
```

## Subscription placement for the dedicated management cluster

We require deploying a fully dedicated management cluster. The recommended practice is to place your management cluster in the operator subscription. This will help you restrict and isolate the control plane from workloads and you can restrict workloads from being created on the same cluster as other tenants. 

Keeping the control plane seperated from the workloads provides a clear seperation of concerns. 

Ensure you limit access to the operator subscription to only required personell.

## Register required resource providers

Make sure you register the required resource providers before deployment. For more information see [Registration](../includes/hci-registration-azure-prerequisites.md).

Here's an example of how to automate the resource providers registration from Azure PowerShell.

```powershell
$applianceCloudName = "azure.local"
$subscriptionName = "Operator subscription"

# Connect to the ARM endpointusing device authentication
Connect-AzAccount -EnvironmentName $applianceCloudName -UseDeviceAuthentication
Write-Host "Selecting a different subscription than the operator subscription.."
$subscription = Get-AzSubscription -SubscriptionName $subscriptionName

# Set the context to that subscription
Set-AzContext -SubscriptionId $subscription.Id

Register-AzResourceProvider -ProviderNamespace  "Microsoft.EdgeArtifact"
Register-AzResourceProvider -ProviderNamespace "Microsoft.HybridCompute" 
Register-AzResourceProvider -ProviderNamespace "Microsoft.GuestConfiguration" 
Register-AzResourceProvider -ProviderNamespace "Microsoft.HybridConnectivity" 
Register-AzResourceProvider -ProviderNamespace "Microsoft.AzureStackHCI" 
Register-AzResourceProvider -ProviderNamespace "Microsoft.Kubernetes" 
Register-AzResourceProvider -ProviderNamespace "Microsoft.KubernetesConfiguration" 
Register-AzResourceProvider -ProviderNamespace "Microsoft.ExtendedLocation" 
Register-AzResourceProvider -ProviderNamespace "Microsoft.ResourceConnector" 
Register-AzResourceProvider -ProviderNamespace "Microsoft.HybridContainerService"
# Not required on disconnected operations
# Register-AzResourceProvider -ProviderNamespace "Microsoft.Attestation"
# Register-AzResourceProvider -ProviderNamespace "Microsoft.Storage"
# Register-AzResourceProvider -ProviderNamespace "Microsoft.Insights"
```

Wait until all resource providers are in the state **Registered**.

Here's a sample Azure PowerShell command to list all resource providers and their statuses.

```powershell  
Get-AzResourceProvider | Format-Table
```

> [!NOTE]
> You can also register or view resource provider statuses in the local portal. To do this, go to your **Subscription**, click the dropdown arrow for **Settings**, and select **Resource providers**.

## Deploy Azure Local to form the management cluster

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

To initialize each node, run this PowerShell script. Modify the variables necessary to match your environment details:

1. Initialize each Azure Local node.

    ```powershell
    $resourcegroup = 'azurelocal-management-cluster' 
    $applianceCloudName = "azure.local"
    $applianceConfigBasePath = "C:\AzureLocalDisconnectedOperations\"
    $applianceFQDN = "autonomous.cloud.private"
    $subscriptionName = "Starter subscription"
    
    Connect-AzAccount -EnvironmentName $applianceCloudName -UseDeviceAuthentication
    Write-Host "Selecting a different subscription than the operator subscription.."
    $subscription = Get-AzSubscription -SubscriptionName $subscriptionName

    # Set the context to that subscription
    Set-AzContext -SubscriptionId $subscription.Id

    $armTokenResponse = Get-AzAccessToken -ResourceUrl "https://armmanagement.$($applianceFQDN)"

    # $ArmAccessToken = $armTokenResponse.Token
    # Convert token to string for use in initialization
    # Workaround needed for Az.Accounts 5.0.4
    $ArmAccessToken = [System.Net.NetworkCredential]::new("", $armTokenResponse.Token).Password

    # Bootstrap each node
    Invoke-AzStackHciArcInitialization -SubscriptionID $subscription.Id -TenantID $subscription.TenantId -ResourceGroup $resourceGroup -Cloud $applianceCloudName -Region "Autonomous" -CloudFqdn $applianceFQDN -ArmAccessToken $ArmAccessToken
    ```

> [!NOTE]
> Ensure that you run initialization on the first machine before moving on to other nodes.
>
> Nodes appear in the local portal shortly after you run the steps, and the extensions appear on the nodes a few minutes after installation.  
>
> You can also use the [Configurator App](../deploy/deployment-arc-register-configurator-app.md?view=azloc-2506&preserve-view=true) to initialize each node.

## Pre-create Azure Key Vault

Create the Azure Key Vault before you deploy Azure Local to avoid long deployment delays caused by a known issue.

For a code example, see [Known issues](./disconnected-operations-known-issues.md).

After you create the Key Vault, wait 5 minutes before you continue with the next portal deployment step. 

## Deploy the management cluster (first Azure Local instance)

With the control plane deployed and configured - you can complete the management cluster by deploying Azure Local using your local control plane.

Follow these steps to create an Azure Local instance (cluster):

1. Access the local portal from a browser of your choice.
1. Navigate to `portal.FQDN`. For example, `https://portal.autonomous.cloud.private`.
1. Select your nodes and complete the deployment steps outlined in [Deploy Azure Local using the Azure portal](../deploy/deploy-via-portal.md).  

> [!NOTE]
> If you create Azure Key Vault during deployment, wait about 5 minutes for RBAC permissions to take effect.
>
> If you see a validation error, it’s a known issue. Permissions might still be propagating. Wait a bit, refresh your browser, and redeploy the cluster.

## Tasks after deploying disconnected operations

Perform the following tasks after deploying Azure Local with disconnected operations:

1. **Back up the BitLocker keys (do not skip this step)**. During deployment, the appliance is encrypted. Without the recovery keys for the volumes, you can't recover and restore the appliance. For more information, see [Understand security controls with disconnected operations on Azure Local](disconnected-operations-security.md).

1. **Assign extra operators.** You can assign one or more operators by navigating to **Operator subscriptions**. Assign the **contributor** role at the subscription level.

1. [Export the host guardian service certificates](disconnected-operations-security.md) and back up the folder you export them to on an external share or drive.
1. [Register the management cluster](disconnected-operations-registration.md)

> [!NOTE]
> Do not skip these steps. Consider this as a deployment completion checklist. These steps are critical in order to be able to recover in case of disasters, receive support and to stay compliant.

## Appendix

### Troubleshoot and reconfigure by using management endpoint

To use the management endpoint for troubleshooting and reconfiguration, you need the management IP address used during deployment, along with the client certificate and password used to secure the endpoint.

From a client with network access to the management endpoint, import the **OperationsModule** and set the context (modify the script to match your configuration):

```powershell  
Import-Module "$applianceConfigBasePath\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force

$password = ConvertTo-SecureString 'RETRACTED' -AsPlainText -Force  
$context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "${env:localappdata}\AzureLocalOpModuleDev\certs\ManagementEndpoint\ManagementEndpointClientAuth.pfx" -ManagementEndpointClientCertificatePassword $password -ManagementEndpointIpAddress "169.254.53.25"  
```  

After setting the context, you can use all the management cmdlets provided by the Operations module, like resetting identity configuration, checking health state, and more.

To get a full list of cmdlets provided, use the PowerShell `Get-Command -Module OperationsModule`. To get details around each cmdlet, use the `Get-Help <cmdletname>` command.

### Troubleshooting deployments

#### System not configured

After you install the appliance, you might see this screen for a while. Let the configuration run for 2 to 3 hours. After you wait the 2 to 3 hours, the screen goes away, and you see the regular Azure portal. If the screen doesn't go away and you can't access the local Azure portal, troubleshoot the issue.

:::image type="content" source="./media/disconnected-operations/deployment/system-not-configured.png" alt-text="Screenshot showing the system isn't configured page." lightbox=" ./media/disconnected-operations/deployment/system-not-configured.png":::

- To find logs from the **OperationsModule** on the first machine, go to `C:\ProgramData\Microsoft\AzureLocalDisconnectedOperations\Logs`.

- To view the health state of your appliance, use the management endpoint `Get-ApplianceHealthState` cmdlet. If you see this screen and the cmdlet reports no errors and all services report 100, open a support ticket from the Azure portal.

#### Install-Appliance fails (due e.g. conflict)

Update appliance configuration and rerun installation after failure

For example:

- If the IP address is already in use, modify the configuration object.
  
  Here's an example to modify the ingress IP address
  
  ```powershell
  # Set a new IP address
  $ingressNetworkConfiguration.IngressIpAddress = '192.168.0.115'
  ```

- If `install-appliance` fails during installation, update `$installAzureLocalParams` and rerun `Install-appliance` as described in [Install and configure the appliance](#install-and-configure-the-appliance).
  
- If the appliance deployment succeeded and you're updating network configuration, see `Get-Help Set-Appliance` for the settings you can update post-deployment.

::: moniker-end

::: moniker range="<=azloc-2601"

---
title: Release Notes for Disconnected Operations for Azure Local
description: Read about the known issues and fixed issues for disconnected operations for Azure Local.
author: ronmiab
ms.topic: concept-article
ms.date: 02/23/2026
ms.author: robess
ms.reviewer: haraldfianbakken
ai-usage: ai-assisted
---

# What's new in disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article highlights what's new (features and improvements) and critical known issues with workarounds for disconnected operations in Azure Local. These release notes update continuously. We add critical issues and workarounds as they're identified. Review this information before you deploy disconnected operations with Azure Local.

## Features and improvements in 2602

- This release marks the general availability of disconnected operations for Azure Local 
- Added support for the Azure Local 2602 ISO and its associated capabilities.
- Several bug fixes for deployment stability and usability.
- Improved security and bug fixes.

## Features and improvements in 2601

- Added support for the Azure Local 2601 ISO and its associated capabilities.
- Added Zero Day Update (ZDU) capability for Azure Local.
- Updated Azure CLI versions and extensions
- Improved security and bug fixes.

## Features and improvements in 2512

- Added support for the Azure Local 2512 ISO and its associated capabilities.
- Added update capability for 2512.
- Added registration UX to the Azure portal.
- Improved security and bug fixes.

## Features and improvements in 2511

- Added support for the Azure Local 2511 ISO and its associated capabilities.
- Bundled update uploader in OperationsModule.
- Improved the log collection experience.
- Added deployment automation capability for operator account during bootstrap.
- Enabled full end-to-end deployment automation.
- Fixed empty groups not synchronizing for identity integration.
- RBAC update and refresh (AKS Arc).
- Added control plane awareness for Azure Local instance deployments.

## Features and improvements in 2509

- Added support for the Azure Local 2508 ISO and its associated capabilities.
- Added support for System Center Operations Manager 2025 and fixed a management pack failure on newer System Center Operations Manager versions; continuing support for System Center Operations Manager 2022.
- Enabled update scenario.
- Improved security.
- Improved observability.
- Enabled LDAPS and custom port configuration for LDAP binding.
- Fixed Portal and UX issues.
- Improved OperationsModule logging and error messages and added certificate validation and CSR generation.
- Added external certificate rotation in OperationsModule. For example, `Set-ApplianceExternalEndpointCertificates`.
- Enabled the use of a FQDN in the SAN of the management certificate.

## Known issues for disconnected operations for Azure Local

### Cloud deployment fails and transitions into a failed state

In Azure Local 2601, a known issue in disconnected operations for Azure Local may cause HIMDS services to stop functioning due to IRVM services taking longer than expected to start. This timing issue can result in the cloud deployment transitioning to a failed state, often accompanied by unclear or non-descriptive error messages.

**Workaround**:

Perform the following steps on all nodes:

1. Download and copy the attached [Zip file](https://aka.ms/aldo-fix2/1) to the `C:\AzureLocal` folder.
1. Extract the Zip file to the path: `C:\AzureLocal\HimdsWatchDog`.
1. Run the `Install-HIMDS-Watchdog.ps1` command.
1. Verify if the scheduled task is created by running:

   ```powershell
   `Get-ScheduledTask -TaskName HIMDS`.
   ```

1. After the cloud deployment is complete, delete the task on each node by running:

    ```powershell
   Unregister-ScheduledTask -TaskName HIMDSWatchdog
   ```

### Control plane deployment stuck and times out without completing

In rare cases, deployments may time out, and services might not reach 100% convergence, even after 8 hours.

**Mitigation:**

Redeploy the disconnected operations appliance. If the issue persists after 2–3 clean redeployments, collect logs and open a support ticket.

### SSL/TLS error using management endpoint (OperationsModule)

When you use a cmdlet that uses the management endpoint (for example, Get-ApplianceHealthState) you receive an error "threw and exception : The request was aborted: Could not create SSL/TLS secure channel.. Retrying"

**Mitigation:**

For 2511, do not use `Set-DisconnectedOperationsClientContext`. Instead use `$context = New-DisconnectedOperationsClientContext` and pass the `$context` to the respective cmdlets.

### Arc bootstrap fails on node (Invoke-AzStackHCIArcInitialization) on Original Equipment Manufacturer (OEM) provided images 

If you are running an OEM image, make sure that you are on the correct OS baseline.

Follow these steps:

1. Make sure that you are on a same supported version or an earlier version (for example, 2508 or earlier).
1. Disable zero-day update on each node:
  
   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\EdgeArcBootstrapSetup" -Name "MicrosoftOSImage" -Value 1
   ```
  
1. Upgrade to the Microsoft provided ISO for your disconnected operations version target. Choose upgrade and keep settings when reimaging the nodes using this approach.
    - Alternatively, run the following command to get the correct update:

      ```powershell
      # Define the solution version and local package path - review the correct versions.
      # Only do this if your OEM image is on a earlier version than the target version.
      
      $TargetSolutionVersion = "12.2511.1002.5"
      $localPlatformVersion = "12.2511.0.3038"
      $DownloadUpdateZipUrl = "https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/WindowsPlatform/$($localPlatformVersion)/Platform.$($localPlatformVersion).zip"
      $LocalPlatformPackagePath = "C:\Platform.$($localPlatformVersion).zip"

      # Download the DownloadUpdateZipUrl to LocalPlatformPackagePath (Alternative do this from browser and copy file over if you cannot run this on your nodes/disconnected scenarios)
      Invoke-WebRequest $DownloadUpdateZipUrl -Outfile $LocalPlatformPackagePath
      
      $updateConfig = @{
        "TargetSolutionVersion" = $TargetSolutionVersion
        "LocalPlatformPackagePath" = $LocalPlatformPackagePath
      }
      
      $configHash = @{
        "UpdateConfiguration" = $updateConfig
      }
      
      # Trigger zero-day update
      $tempConfigPath = "C:\temp.json"
      $configHash | ConvertTo-Json -Depth 3 | Out-File $tempConfigPath -Force
      Start-ArcBootstrap -ConfigFilePath $tempConfigPath
      
      # Continue with Invoke-AzStackHCIArcInitialization.
      ```

1. Review the [version compatibility](disconnected-operations-acquire.md#review-disconnected-operations-for-azure-local-compatible-versions) table.

### Cloud deployment validation fails during the portal experience

Solution Builder extension (SBE) validation fails when trying to reach an *aka.ms* link to download.

**Workaround**:

1. Run the cloud deployment (portal) flow until the validation fails in the UX.
1. Download a patched version of [ExtractOEMContent.ps1](https://aka.ms/aldo-fix1/1)
1. Download a patched version of [EN-US\ExtractOEMContent.Strings.psd1](https://aka.ms/aldo-fix1/2)
1. Modify the following file using your favorite editor `ExtractOEMContent.ps1`.
1. Replace line 899 in this file with the code snippet:

   ```powershell
   if (-not (Test-SBEXMLSignature -XmlPath $sbeDiscoveryManifestPath)) {
       throw ($localizedStrings.OEMManifestSignature -f $sbeDiscoveryManifestPath)
   }
   $packageHash = (Get-FileHash -Path $zipFile.FullName -Algorithm SHA256).Hash
   $manifestXML = New-Object -TypeName System.Xml.XmlDocument
   $manifestXML.PreserveWhitespace = $false
   $xmlTextReader = New-Object -TypeName System.Xml.XmlTextReader -ArgumentList $sbeDiscoveryManifestPath
   $manifestXML.Load($xmlTextReader)
   $xmlTextReader.Dispose()
   
   # Test that the zip file hash matches the package hash from the manifest
   $applicableUpdate = $manifestXML.SelectSingleNode("//ApplicableUpdate[UpdateInfo/PackageHash='$packageHash']")
   if ([System.String]::IsNullOrEmpty($applicableUpdate)) {
       throw "$($zipFile.FullName) hash of $packageHash does not match value in manifest at $sbeDiscoveryManifestPath"
   }
   $result = [PSCustomObject]@{
       Code = "Latest"
       Message = "Override for disconnected operations"
       Endpoint = "https://aka.ms/AzureStackSBEUpdate/Dell"
       ApplicableUpdate = $applicableUpdate.OuterXml
   }
   ```

1. Copy the newly modified file to C:\CloudDeployment\Setup\Common\ExtractOEMContent.ps1 on the first machine.
1. Copy the downloaded, unmodified file to C:\CloudDeployment\Setup\Common\En-US\ExtractOEMContent.Strings.psd1 on the first machine.
1. Resume cloud deployment.

### Cloud deployment (validation or deployment) gets stuck

During the validate or cloud deployment flow, the first machine (seed node) restarts, which causes the control plane appliance to restart. Sometimes this process takes longer than expected, causing HIMDS to stop because it can't connect to the HIS endpoint. This issue can cause the deployment flow to stop responding.

**Mitigation**:

1. Check if the HIMDS service is stopped:
  
   ```powershell
   Get-Service HIMDS
   ```

1. If the service is stopped, start it:

   ```powershell
   Start-Service HIMDS
   ```

1. Check the logs in the first mode at *C:\CloudDeployment\Logs*.
1. Review the appropriate log file:
   - Validate stage: Check the latest file with a name starting with *EnvironmentValidator*.
   - Deploy stage: Check the latest file with a name starting with *CloudDeployment*.
   - If the status in the file is different from what appears in the portal, follow the next steps to resync the deployment status with the portal.

### Deployment status out of sync from cluster to portal

The portal shows that cloud deployment is in progress even though it's already completed, or the deployment is taking longer than expected. This happens because the cloud deployment status isn't synced with the actual status.

If the portal and log file are out of sync, restart the LCM Controller service to reestablish the connection to relay by running `Restart-Service LCMController`.

**Mitigation on the first machine:**

1. Find the following files:
   - For the **Validate** stage: `C:\ECEStore\efb61d70-47ed-8f44-5d63-bed6adc0fb0f\559dd25c-9d86-dc72-4bea-b9f364d103f8`
   - For the **Deploy** stage: `C:\ECEStore\efb61d70-47ed-8f44-5d63-bed6adc0fb0f\086a22e3-ef1a-7b3a-dc9d-f407953b0f84`
1. Update the attribute **EndTimeUtc** located in the first line of the file to a future time based on the machine's current time. For example, \<Action Type="CloudDeployment" StartTimeUtc="2025-04-09T08:01:51.9513768Z" Status="Success" EndTimeUtc="2025-04-10T23:30:45.9821393Z">.
1. Save the file and close it.
1. LCM sends the notification to HCI RP within 5-10 minutes.
1. To view LCM Controller logs, use the following command:

   ```powershell
   Get-WinEvent -LogName "Microsoft.AzureStack.LCMController.EventSource/Admin" -MaxEvents 100 | Where-Object {$_.Message -like "*from edge common logger*"} | Select-Object TimeCreated, Message
   ```

> [!NOTE]
> This process works if HCI RP hasn't failed the deployment status due to a timeout (approximately 48 hours from the start of cloud deployment).

### Failed to deploy disconnected operations Appliance (Appliance.Operations failure)

Some special characters in the management TLS cert password, external certs password, or observability configuration secrets from the OperationsModule can cause the deployment to fail with an error output: *Appliance.Operations operation [options]*

 **Mitigation**:

 Do not use special characters like single or double quotes in the passwords.

### Resources disappear from portal

When you sign in to the portal with the same user account that worked before, resources are missing and don't appear.

**Mitigation**: Start your browser in incognito mode, or close your browser and clear all cookies. Then go back to your local portal and sign in again. Alternatively, restart IRVM01 on the seed node and wait until the services are back online and healthy.

### Memory consumption when there's less than 128 GB of memory per node

The disconnected operations appliance uses 78 GB of memory. If your node has less than 128 GB of memory, complete these steps after you deploy the appliance but before you deploy Azure Local instances.

**Mitigation**:

1. Shut down the IRVM01VM on the seed node.
1. Change the IRVM01 virtual machine memory setting to 64 GB.
1. Start the IRVM01 appliance.
1. Wait for convergence. Monitor `Get-ApplianceHealthState` until all services converge.
1. Deploy Azure Local instances.

### Deployment failure

In virtual environments, deployments can time out, and services might not reach 100% convergence, even after 8 hours.

**Mitigation:**

Redeploy the disconnected operations appliance a few times. If you're using a physical environment and the problem continues, collect logs and open a support ticket.

### Azure Local deployment with Azure Keyvault

Role-Based Access Control (RBAC) permissions on a newly created Azure Key Vault can take up to 20 minutes to propagate. If you create the Key Vault in the local portal and quickly try to finish the cloud deployment, you might encounter permission issues when validating the cluster.

**Mitigation**:

Wait 20 minutes after you create the Azure Key Vault to finish deploying the cluster, or create the Key Vault ahead of time. 

If you create the Key Vault ahead of time, make sure you assign:

- Managed identity for each node
- The Key Vault admin
- The user deploying to the cloud explicit roles on the Key Vault:
  - **Key Vault Secrets Officer** and **Key Vault Data Access Administrator**.

Here's an example script. Modify and use this script to create the Key Vault ahead of time:

```powershell
param($resourceGroupName = "aldo-disconnected", $keyVaultName = "aldo-kv", $subscriptionName = "Starter Subscription")

$location = "autonomous"

Write-Verbose "Sign in interactive with the user who does cloud deployment"
# Sign in to Azure CLI (use the user you run the portal deployment flow with)"
az login 
az account set --subscription $subscriptionName
$accountInfo = (az account show)|convertfrom-json

# Create the Resource Group
$rg = (az group create --name $resourceGroupName --location $location)|Convertfrom-json

# Create a Key Vault
$kv = (az keyvault create --name $keyVaultName --resource-group $resourceGroupName --location $location --enable-rbac-authorization $true)|Convertfrom-json

Write-Verbose "Assigning permissions to $($accountInfo.user.name) on the Key Vault"
# Assign the secrets officer role to the resource group (you can use KV explicit).
az role assignment create --assignee $accountInfo.user.name --role "Key Vault Secrets Officer" --scope $kv.Id
az role assignment create --assignee $accountInfo.user.name --role "Key Vault Data Access Administrator" --scope $kv.Id

$machines = (az connectedmachine list -g $resourceGroupName)|ConvertFrom-Json

# For now, a minimum of 3 machines for Azure Local disconnected operations are supported.
if($machines.Count -lt 3){
    Write-Error "No machines found in the resource group $resourceGroupName. Please check the resource group and try again. Please use the same resource group as where your Azure Local nodes are"
    return 1
}

Write-Verbose "Assigning permissions to MSIs $($machines.count) on the Key Vault"

$apps =(az ad sp list)|ConvertFrom-Json
$managedIds=$machines.displayname | foreach-object {
    $name = $_
    $apps|Where-Object {$_.ServicePrincipalType -eq 'ManagedIdentity' -and $_.displayname -match $name}
}

# Assign role to each of the managed IDs (Arc-VMs) in the RG 
$managedIds|foreach-object {    
    az role assignment create --role "Key Vault Administrator" --assignee $_.Id --scope $kv.id
}

Write-Verbose "Wait 20 min before running cloud deployment from portal"
```

### Azure Local VMs

#### Azure Resource Graph add or edit tags error

After you start, restart, or stop the Azure Local VM, the power action buttons are disabled and the status isn't reflected properly.

**Mitigation**:

Use Azure Command-Line Interface (CLI) to add or edit tags for the resource.

#### Start, restart, or delete buttons disabled after stopping VM

After you stop an Azure Local VM, the start, restart, and delete buttons in the Azure portal are disabled.

**Mitigation**:

Refresh your browser and the page.

#### Delete a VM resource

When you delete a VM from the portal, you might see these messages ***Delete associated resource failed*** and ***Failed to delete the associated resource 'name' of type 'Network interface'***.

**Mitigation**:

After you delete the VM, use CLI to delete the associated network interface. Run this command:

```azurecli
az stack-hci-vm network nic delete
```

### Azure Kubernetes Service (AKS) on Azure Local

#### AKS deployment fails in fully air-gapped scenarios

AKS deployments fails in fully air-gapped scenarios. No mitigation is available for this issue in the current releases.

#### Use an existing public key when creating AKS cluster

In this release, you can only use an existing public key when creating an AKS cluster.

**Mitigation**:

To create an SSH key, use the following command-line tool and paste the public key in the UI:

```powershell
ssh-keygen -t rsa 
(cat ~\.ssh\id_rsa.pub)|set-clipboard
```

#### Update or scale a node pool from the portal is disabled

Updating or scaling a node pool from the portal is unsupported in this preview release.

**Mitigation**:

Use CLI to update or scale a node pool.

```azurecli
az aksarc nodepool update
az aksarc nodepool scale
```

#### Scale limitation

In the current Azure Local disconnected operations scale envelope, running more than 20 workload clusters can affect control plane stability. Under sustained load, the disconnected operations control plane may become less responsive over time, which can impact manageability and reliability at higher cluster counts.

**Mitigation**:

Until the supported scale range is expanded, Microsoft recommends limiting the number of workload clusters to 20 or fewer to maintain stable and reliable disconnected operations.

#### Kubernetes cluster list empty under Azure Local (Kubernetes clusters)

When you navigate to Azure Local and click **Kubernetes clusters**, you might see an empty list of clusters.

**Mitigation**:

Navigate to **Kubernetes** > **Azure Arc** in the left menu or use the search bar. Your clusters should appear in the list.

#### Save Kubernetes service notification stuck

After you update to a newer version of Kubernetes, you might see a stuck notification that says, `Save Kubernetes service`.

**Mitigation**:

Navigate to the **Cluster View** page and refresh it. Check whether the state shows upgrading or completed. If the update completed successfully, you can ignore the notification.

#### Activity log shows authentication issue

Ignore the portal warning in this release.

#### Microsoft Entra authentication with Kubernetes RBAC fails

When attempting to create a Kubernetes cluster with Entra authentication, you encounter an error.

Only local accounts with Kubernetes RBAC are supported in this preview release.

#### Arc extensions

When navigating to extensions on an AKS cluster, the add button is disabled and there aren't any extensions listed.

Arc extensions are unsupported in this preview release.

#### AKS resource shows on portal after deletion

After successfully deleting an AKS cluster from portal, the resource continues to show.

**Mitigation**:

Use CLI to delete and clean up the cluster. Run this command:

```azurecli
az aksarc delete
```

#### Export Host Guardian Service certificates

This feature is unsupported in this preview release.

#### Restart a node or the control plane VM

After you restart a node or the control plane VM, the system might take up to an hour to become fully ready. If you notice issues with the local portal, missing resources, or failed deployments, check the appliance health using the **OperationsModule** to confirm that all services are fully converged.

### Subscriptions

#### Operator create subscription

After you create a new subscription as an operator, the subscription appears in the list as non-clickable and displays ***no access*** for the owner.

**Mitigation**:

Refresh your browser window.

#### Operator subscriptions view (timeout)

If you're signed in as an operator, you might see a timeout screen and be unable to view, list, or create subscriptions.

**Cause**:

This issue happens when a subscription owner is deleted or isn't synced from the source identity system to the local control plane. When you try to view subscriptions, the process fails because the owner's identity isn't available.

**Mitigation**:

If the portal doesn't work, use Azure CLI or REST API to create and list subscriptions. To assign a different owner, use the REST API and enter the `subscriptionOwnerId` parameter when you create the subscription.

### Azure CLI

#### Manage clouds

When you use the `az cloud` commands, such as `az cloud register`, `az cloud show`, or `az cloud set`, you might encounter issues if you use uppercase letters in the cloud name.

**Mitigation**:

Only use lowercase letters for cloud names in `az cloud` subcommands, such as `register`, `show`, or `set`.

#### Create subscriptions

Azure CLI doesn't support providing `subscriptionOwnerId` for new subscriptions. This makes the operator the default owner of newly created subscriptions without a way of changing the owner currently.

**Mitigation**:

Use `az rest` to create subscriptions with a different owner if required to automate directly with different owner

### Azure portal

#### Sign out fails

When you select **Signout**, the request doesn't work.

**Mitigation**:

Close your browser, then go to the Portal URL.

### Azure Resource Manager

#### Template specs

Template specs are unsupported in the preview release. Deployments that use ARM templates with template specs fail.

### Unsupported scenarios

The following scenarios are unsupported in the preview release.

- Arc-Enabled servers (remote or non Azure Local VMs)
- Arc-Enabled Kubernetes clusters (remote or non AKS clusters)

If you test these scenarios, these systems must trust your custom CA and you need to pass `-custom-ca-cert` when Arc-enabling them.

::: moniker-end

::: moniker range="<=azloc-2601"

This feature is available only in Azure Local 2602 or later.

::: moniker-end
