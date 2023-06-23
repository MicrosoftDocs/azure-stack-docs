---
title: Deploy AKS infrastructure using PowerShell
description: Quickstart - Deploy AKS hybrid on an Azure Virtual Machine using PowerShell to evaluate Azure Kubernetes Service hybrid deployment options.
author: sethmanheim
ms.topic: quickstart
ms.custom:
  - devx-track-azurepowershell
ms.date: 12/16/2022
ms.author: sethm 
ms.lastreviewed: 08/29/2022 
ms.reviewer: oadeniji
#Keyword: Azure Virtual Machine deployment, Evaluate AKS hybrid in Azure
---

# Deploy AKS infrastructure using PowerShell

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

With your Windows Server Hyper-V host up and running, you can now deploy Azure Kubernetes Service (AKS) for your evaluation of AKS hybrid. You'll use PowerShell to deploy the AKS management cluster on your Windows Server Hyper-V host. Then you'll deploy a target cluster on which you can test deployment of a workload.

> [!NOTE]
> If you prefer to use Windows Admin Center, see [Deploy AKS infrastructure using Windows Admin Center](aks-hci-evaluation-guide-2a.md).

## Architecture

The following image showcases the different layers and interconnections between the different components:

:::image type="content" source="media/aks-hci-evaluation-guide/nested-virt.png" alt-text="Architecture of AKS on Azure Stack HCI in Azure":::

You've already deployed the outer box, which represents the Azure Resource Group. Inside here, you've deployed the virtual machine itself, and accompanying network adapter, storage, and so on. You've also completed some host configuration.

In this section, you'll first deploy the management cluster. This cluster provides the core orchestration mechanism and interface for deploying and managing one or more target clusters, shown on the diagram's right side. These target clusters, or *workload clusters*, contain worker nodes and are where application workloads run. These nodes are managed by a management cluster. For more information about the building blocks of the Kubernetes infrastructure, see [Kubernetes cluster architecture](kubernetes-concepts.md).

## Prepare environment

Before you deploy AKS on Azure Stack HCI, you need to prepare your host by downloading the latest PowerShell packages and modules. You'll also clean up any existing artifacts to ensure you're starting clean.

First, install the required PowerShell packages and modules:

1. Run the following PowerShell command as administrator, accepting any prompts:

   ```powershell
   Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
   Install-PackageProvider -Name NuGet -Force 
   Install-Module -Name PowershellGet -Force
   Exit
   ```

2. Open a new PowerShell console as administrator, and run the following cmdlet to install the required PowerShell module and dependencies:

   ```powershell
   Install-Module -Name AksHci -Repository PSGallery -AcceptLicense -Force
   ```

3. When complete, if you haven't already, make sure you close all PowerShell windows.

## Optional - enable/disable DHCP

Static IP configurations are supported for deployment of the management cluster and workload clusters. When you deployed your Azure Virtual Machine, DHCP was installed and configured automatically. However, you could choose to enable or disable DHCP on your Windows Server host OS. If you want to adjust DHCP now, make changes to the following **$dhcpState** and run the following PowerShell command as administrator:

```powershell
# Check current DHCP state for Active/Inactive
Get-DhcpServerv4Scope -ScopeId 192.168.0.0
# Adjust DHCP state if required
$dhcpState = "Active" # Or Inactive
Set-DhcpServerv4Scope -ScopeId 192.168.0.0 -State $dhcpState -Verbose
```

## Enable Azure integration

Before you download and deploy AKS on Azure Stack HCI, a set of steps is required to prepare your Azure environment for integration. These steps can be performed using Azure CLI, but for the purposes of this guide, you will be using PowerShell.

Now, because you're deploying this evaluation infrastructure in Azure, the system assumes you already have a valid Azure subscription. To confirm, in order to integrate AKS on Azure Stack HCI with an Azure subscription, you will need the following prerequisites:

- An Azure subscription with either a user account or service principal that provides the required privileges:
  - A user account with the built-in **Owner** role, or
  - A Service Principal with either the built-in **Kubernetes Cluster - Azure Arc Onboarding** (Minimum), built-in **Contributer** role, or built-in **Owner** role.

### Optional - Create a Service Principal

If you need to create a new Service Principal, the following script creates a new one, with the built-in **Kubernetes Cluster - Azure Arc Onboarding** role and the scope set at the subscription level:

```powershell
# Sign in to Azure
Connect-AzAccount

# Optional - if you wish to switch to a different subscription
# First, get all available subscriptions as the currently logged in user
$subList = Get-AzSubscription
# Display those in a grid, select the chosen subscription, then press OK.
if (($subList).count -gt 1) {
    $subList | Out-GridView -OutputMode Single | Set-AzContext
}

# Retrieve the current subscription ID
$sub = (Get-AzContext).Subscription.Id

# Create a unique name for the Service Principal
$date = (Get-Date).ToString("MMddyy-HHmmss")
$spName = "AksHci-SP-$date"

# Create the Service Principal

$sp = New-AzADServicePrincipal -DisplayName $spName `
    -Role 'Kubernetes Cluster - Azure Arc Onboarding' `
    -Scope "/subscriptions/$sub"

# Retrieve the password for the Service Principal

$secret = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR(
    [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($sp.Secret)
)

Write-Host "Application ID: $($sp.ApplicationId)"
Write-Host "App Secret: $secret"
```

Output from the script includes the **Application ID** and the **secret** for use when deploying AKS on Azure Stack HCI. Make a note of those, and store the note safely.

With that created, in the Azure portal, under **Subscriptions**, **Access Control**, and then **Role Assignments**, you should see your new Service Principal.

:::image type="content" source="media/aks-hci-evaluation-guide/service-principal.png" alt-text="Screenshot of service principal shown in Azure":::

### Register the resource provider to your subscription

Ahead of the registration process, you must enable the appropriate resource provider in Azure for AKS on Azure Stack HCI integration. To do that, run the following PowerShell script:

```powershell
# Login to Azure
Connect-AzAccount

# Optional - if you wish to switch to a different subscription
# First, get all available subscriptions as the currently logged in user
$subList = Get-AzSubscription
# Display those in a grid, select the chosen subscription, then press OK.
if (($subList).count -gt 1) {
    $subList | Out-GridView -OutputMode Single | Set-AzContext
}

Register-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Register-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
```

This registration process can take up to 10 minutes. To verify the registration, run the following PowerShell commands:

```powershell
Get-AzResourceProvider -ProviderNamespace Microsoft.Kubernetes
Get-AzResourceProvider -ProviderNamespace Microsoft.KubernetesConfiguration
```

:::image type="content" source="media/aks-hci-evaluation-guide/rp-enable.png" alt-text="Resource provider enabled Azure results":::

With those steps completed, you're ready to deploy the AKS management cluster to your Windows Server Hyper-V host.

## Deploy AKS on Azure Stack HCI management cluster

You're now ready to deploy the AKS on an Azure Stack HCI management cluster to your Windows Server Hyper-V host.

1. Open PowerShell as administrator and run the following command to import the new modules and list their functions. If you receive an error while running these commands, ensure you closed all PowerShell windows earlier and run them in a fresh administrative PowerShell console.

   ```powershell
   Import-Module AksHci
   Get-Command -Module AksHci
   ```

   :::image type="content" source="media/aks-hci-evaluation-guide/get-module-functions.png" alt-text="Output of Get-Command":::

   As you can see, the module provides a number of functions - retrieving information, installing and deploying AKS and Kubernetes clusters, updating and scaling, and doing cleanup. We'll explore a number of these functions as we move through the steps.

2. Next, it's important to validate your single node to ensure it meets all the requirements to install AKS on Azure Stack HCI. Run the following command in your administrator PowerShell window:

   ```powershell
   Initialize-AksHciNode
   ```

   PowerShell remoting and WinRM will be configured, if they haven't been already, and the relevant roles and features are validated. Deployment of the Azure Virtual Machine automatically installed Hyper-V and the RSAT clustering PowerShell tools, so you should be able to proceed. If anything is missing, the process installs/configures the missing components, which might require you to reboot your Azure Virtual Machine.

   Next, you'll configure your deployment by defining the configuration settings for the AKS management cluster.

3. In your PowerShell window, run the following commands to create some folders that will be used during the deployment process:

   ```powershell
   New-Item -Path "V:\" -Name "AKS-HCI" -ItemType "directory" -Force
   New-Item -Path "V:\AKS-HCI\" -Name "Images" -ItemType "directory" -Force
   New-Item -Path "V:\AKS-HCI\" -Name "WorkingDir" -ItemType "directory" -Force
   New-Item -Path "V:\AKS-HCI\" -Name "Config" -ItemType "directory" -Force
   ```

4. With these folders created, you're almost ready to create your configuration settings. Before doing so, create a networking configuration for the AKS deployment on Azure Stack HCI to use. See the following two options, and choose the one that matches your host configuration.

   1. **Use DHCP-issued IP addresses**: run the following PowerShell command:

      ```powershell
      $vnet = New-AksHciNetworkSetting -name "mgmtvnet" -vSwitchName "InternalNAT" `
          -vipPoolStart "192.168.0.150" -vipPoolEnd "192.168.0.250"
      ```

   1. **Use static IP addresses**: run the following PowerShell command:

      ```powershell
      $vnet = New-AksHciNetworkSetting -name "mgmtvnet" -vSwitchName "InternalNAT" -gateway "192.168.0.1" -dnsservers "192.168.0.1" `
          -ipaddressprefix "192.168.0.0/16" -k8snodeippoolstart "192.168.0.3" -k8snodeippoolend "192.168.0.149" `
          -vipPoolStart "192.168.0.150" -vipPoolEnd "192.168.0.250"
      ```

5. With the networking configuration defined, you can now finalize the configuration of your AKS deployment on Azure Stack HCI.

   ```powershell
   Set-AksHciConfig -vnet $vnet -imageDir "V:\AKS-HCI\Images" -workingDir "V:\AKS-HCI\WorkingDir" `
      -cloudConfigLocation "V:\AKS-HCI\Config" -Verbose
   ```

   This command takes a few moments to complete, but once done, you should see confirmation that the configuration has been saved.

   For information about some of the other parameters that you can use when defining your configuration, see [Explore the AKS hybrid environment](/azure-stack/aks-hci/kubernetes-walkthrough-powershell#step-3-configure-your-deployment).

   If you make a mistake, run **Set-AksHciConfig** without any parameters, and that will reset your configuration.

6. With the configuration files finalized, finalize the registration configuration. From your administrative PowerShell window, run the following commands:

   ```powershell
   # Login to Azure
   Connect-AzAccount

   # Optional - if you wish to switch to a different subscription
   # First, get all available subscriptions as the currently logged in user
   $subList = Get-AzSubscription
   # Display those in a grid, select the chosen subscription, then press OK.
   if (($subList).count -gt 1) {
       $subList | Out-GridView -OutputMode Single | Set-AzContext
   }

   # Retrieve the subscription and tenant ID
   $sub = (Get-AzContext).Subscription.Id
   $tenant = (Get-AzContext).Tenant.Id

   # First create a resource group in Azure that will contain the registration artifacts
   $rg = (New-AzResourceGroup -Name AksHciAzureEval -Location "East US" -Force).ResourceGroupName
   ```

7. Then, run **Set-AksHciRegistration**, and this will vary depending on the type of login you prefer:

   ```powershell
   # For an Interactive Login with a user account:
   Set-AksHciRegistration -SubscriptionId $sub -ResourceGroupName $rg

   # For a device login or if you are running in a headless shell, again with a user account:
   Set-AksHciRegistration -SubscriptionId $sub -ResourceGroupName $rg -UseDeviceAuthentication

   # To use your Service Principal, first enter your Service Principal credentials (app ID, secret) then set the registration
   $cred = Get-Credential
   Set-AksHciRegistration -SubscriptionId $sub -ResourceGroupName $rg -TenantId $tenant -Credential $cred
   ```

   After you've configured your deployment, you're now ready to start the installation process, which installs the AKS on Azure Stack HCI management cluster.

8. From your PowerShell window, run the following command:

   ```powershell
   Install-AksHci
   ```

   This will take a few minutes, so allow the process to finish.

### Updates and cleanup

For more information about updating, redeploying, or uninstalling AKS on Azure Stack HCI, [see the quickstart here](kubernetes-walkthrough-powershell.md).

## Create a Kubernetes cluster (target cluster)

With the management cluster deployed successfully, you're ready to deploy Kubernetes clusters that can host your workloads. We'll then briefly walk through how to scale your Kubernetes cluster and upgrade the Kubernetes version of your cluster.

1. Open PowerShell as administrator, and run the following cmdlet to check the available versions of Kubernetes that are currently available:

   ```powershell
   # Show available Kubernetes versions
   Get-AksHciKubernetesVersion
   ```

   In the output, you'll see a number of available versions across both Windows and Linux:

   :::image type="content" source="media/aks-hci-evaluation-guide/get-akshcikubernetesversion.png" alt-text="Output of Get-AksHciKubernetesVersion":::

2. You can then run the following command to create and deploy a new Kubernetes cluster:

   ```powershell
   New-AksHciCluster -name akshciclus001 -nodePoolName linuxnodepool -controlPlaneNodeCount 1 -nodeCount 1 -osType linux
   ```

   This command deploys a new Kubernetes cluster named **akshciclus001** with the following attributes:

   * A single control plane node (VM)
   * A single load balancer VM
   * A single node pool called **linuxnodepool**, containing a single Linux worker node (VM)

This is fine for evaluation purposes. There are a number of optional parameters that you can add:

* **-kubernetesVersion**: by default, the deployment will use the latest, but you can specify a version.
* **-controlPlaneVmSize**: size of the control plane VM. Default is Standard_A2_v2.
* **-loadBalancerVmSize**: size of your load balancer VM. Default is Standard_A2_V2.
* **-nodeVmSize**: size of your worker node VM. Default is Standard_K8S3_v1.

For more parameters that you can use with **New-AksHciCluster**, see the [cmdlet documentation](/azure-stack/aks-hci/reference/ps/new-akshcicluster). To get a list of available VM sizes, run **Get-AksHciVmSize**.

### Node pools, taints, and max pod counts

A *node pool* is a group of nodes, or virtual machines that run your applications, within a Kubernetes cluster that have the same configuration, giving you more granular control over your clusters. You can deploy multiple Windows node pools and multiple Linux node pools of different sizes, within the same Kubernetes cluster.

Another configuration option for a node pool is to apply *taints*. A taint allows you to prevent pods from being placed on specific nodes based on characteristics that you specify. You can specify a taint for a node pool when the cluster and node pool are created. [Learn more about taints](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

This guide doesn't require you to specify a taint. If you do want to explore the commands for adding a taint to a node pool, see [Create and manage multiple node pools for a cluster in AKS](use-node-pools.md#specify-a-taint-for-a-node-pool).

In addition to taints, we have recently added support for configuring the maximum number of pods that can run on a node, with the `-nodeMaxPodCount` parameter. You can specify this parameter when creating a cluster, or when creating a new node pool, and the number has to be greater than 50.

The deployment of this Kubernetes workload cluster should take a few minutes, and once complete, should present information about the deployment; however, you can verify the details by running the following command:

```powershell
Get-AksHciCluster
```

For more information about the node pool, use the command **Get-AksHciNodePool** with the specified cluster name:

```powershell
Get-AksHciNodePool -clusterName akshciclus001
```

### Continue deployment

1. Scale your Kubernetes cluster to add a Windows Node Pool and worker node. This process triggers the download and extraction of a Windows container host image, which takes a few minutes.

   ```powershell
   New-AksHciNodePool -clusterName akshciclus001 -name windowsnodepool -count 1 -osType Windows -osSku Windows2022
   ```

2. Next, scale your Kubernetes cluster to have 2 Linux worker nodes:

   ```powershell
   Set-AksHciNodePool -clusterName akshciclus001 -name linuxnodepool -count 2
   ```

   With your cluster scaled out, you can check the node pool status by running:

   ```powershell
   Get-AksHciNodePool -clusterName akshciclus001
   ```

   You can also scale your control plane nodes for this particular cluster; however, it has to be scaled independently from the worker nodes themselves. You can scale the control plane nodes using the following command. Before you run this command, make sure you have an extra 16GB memory left of your AKSHCIHost001 OS. If your host was deployed with 64GB RAM, you may not have enough capacity to deploy two control plane VMs.

   ```powershell
   Set-AksHciCluster –Name akshciclus001 -controlPlaneNodeCount 3
   ```

   > [!NOTE]
   > The control plane node count should be an odd number, such as 1, 3, 5, etc.

3. Once these steps have been completed, you can verify the details by running the following cmdlet:

   ```powershell
   Get-AksHciCluster
   ```

   To access this **akshciclus001** cluster using **kubectl** (which was installed on your host as part of the installation process), you'll first need the **kubeconfig** file.

4. To retrieve the **kubeconfig** file for the **akshciclus001** cluster, run the following command from your administrative PowerShell session, and accept the prompt:

   ```powershell
   Get-AksHciCredential -name akshciclus001 -Confirm:$false
   dir $env:USERPROFILE\.kube
   ```

   The default output of this command is to create the **kubeconfig** file in the **%USERPROFILE%\\.kube.** folder, and will name the file **config**. This **config** file will overwrite the previous kubeconfig file retrieved previously. You can also specify a custom location by using `-configPath c:\myfiles\kubeconfig`.

## Integrate with Azure Arc

With your target cluster deployed and scaled, you can quickly and easily integrate this cluster with Azure Arc.

When an AKS cluster is attached to Azure Arc, it gets an Azure Resource Manager representation. Clusters are attached to standard Azure subscriptions, are located in a resource group, and can receive tags just like any other Azure resource. Also, because AKS is Arc-enabled, Kubernetes representation enables you to extend the following capabilities to your Kubernetes cluster:

* Management services: configurations (GitOps), Azure Monitor for containers, Azure Policy (Gatekeeper)
* Data Services: SQL Managed Instance, PostgreSQL Hyperscale
* Application services: App Service, Functions, Event Grid, Logic Apps, API Management

To connect a Kubernetes cluster to Azure, the cluster administrator needs to deploy agents. These agents run in a Kubernetes namespace named `azure-arc` and are standard Kubernetes deployments. The agents are responsible for connectivity to Azure, collecting Azure Arc logs and metrics, and enabling above-mentioned scenarios on the cluster.

AKS supports industry-standard SSL to secure data in transit. Also, data is stored encrypted at rest in an Azure Cosmos DB database to help ensure data confidentiality.

### Enable Azure Arc integration

In order to integrate your target cluster with Azure Arc, run the following commands:

```powershell
# Sign in to Azure
Connect-AzAccount

# Integrate your target cluster with Azure Arc
Enable-AksHciArcConnection -name "akshciclus001"
```

> [!NOTE]
> This example connects your target cluster to Azure Arc using the subscription ID and resource group passed in the **Set-AksHciRegistration** cmdlet when deploying AKS on Azure Stack HCI. If you want to use alternative settings, see [Enable-AksHciArcConnection](/azure-stack/aks-hci/reference/ps/enable-akshciarcconnection).

### Verify connected cluster

You can view your Kubernetes cluster resource on the [Azure portal](https://portal.azure.com/). In the portal, navigate to the resource group and the Azure Arc-enabled Kubernetes resource that's based on the resource and resource group you used earlier with the [Enable-AksHciArcConnection](/azure-stack/aks-hci/reference/ps/enable-akshciarcconnection) PowerShell cmdlet.

> [!NOTE]
> After connecting to the cluster, it can take between five to ten minutes for the cluster metadata (cluster version, agent version, number of nodes) to surface on the overview page of the Kubernetes resource in the Azure portal.

For more information about integrating with Azure Arc, see [Connect an AKS cluster to Azure Arc](connect-to-arc.md).

## Next steps

In this step, you've successfully deployed the AKS management cluster, deployed and scaled a Kubernetes cluster, and integrated with Azure Arc. You can now move forward to the next stage, in which you can deploy a sample application.

- [Part 3 - Explore the AKS hybrid environment](aks-hci-evaluation-guide-3.md).
