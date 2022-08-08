---
title: Evaluate AKS on Azure Stack HCI in Azure
description: Step in the evaluation guide showing what's necessary to deploy AKS on Azure Stack HCI in an Azure VM
author: sethmanheim
ms.topic: conceptual
ms.date: 08/04/2022
ms.author: sethm 
ms.lastreviewed: 08/04/2022 
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to deploy AKS on Azure Stack HCI in an Azure VM
# Keyword: Azure VM deployment
---

# Evaluate AKS on Azure Stack HCI in Azure

With the introduction of [nested virtualization support in Azure](https://azure.microsoft.com/blog/nested-virtualization-in-azure/ "Nested virtualization announcement blog post") in 2017, Microsoft opened the door to new and interesting scenarios. Nested virtualization in Azure is particularly useful for validating configurations that would require additional hardware in your environment, such as running Hyper-V hosts and clusters.

In this guide, you'll walk through the steps to stand up an AKS on Azure Stack HCI infrastructure. At a high level, this consists of the following tasks:

* Deploy an Azure VM, running Windows Server 2019 or 2022, to act as your main Hyper-V host - this will be automatically configured with the relevant roles and features needed for your evaluation
* On the Windows Server VM, deploy the AKS on Azure Stack HCI management cluster
* On the Windows Server VM, deploy the AKS on Azure Stack HCI target clusters, for running workloads

## Architecture

The following figure showcases the different layers and interconnections between the different components:

![Architecture diagram for AKS on Azure Stack HCI in Azure](/eval/media/nested_virt_arch_ga2.png "Architecture diagram for AKS on Azure Stack HCI in Azure")

The outer box represents the Azure Resource Group, which will contain all of the artifacts deployed in Azure, including the virtual machine itself, and accompaying network adapter, storage and so on. You'll deploy an Azure VM running Windows Server 2019 or 2022 Datacenter. Once deployed, you'll perform some host configuration, and then begin to deploy the other key components. Firstly, on the left hand side, you'll deploy the management cluster. This provides the the core orchestration mechanism and interface for deploying and managing one or more target clusters, which are shown on the right of the diagram. These target, or workload clusters contain worker nodes and are where application workloads run. These are managed by a management cluster. If you're interested in learning more about the building blocks of the Kubernetes infrastructure, you can [read more here](kubernetes-concepts.md).

> [!IMPORTANT]
> The steps outlined in this evaluation guide are **specific to running inside an Azure VM**, running a single Windows Server 2019 or 2022 OS, without a domain environment configured. If you plan to use these steps in an alternative environment, such as one nested/physical on-premises, or in a domain-joined environment, the steps may differ and certain procedures may not work. If that is the case, please see the [official documentation to deploy AKS on Azure Stack HCI](kubernetes-walkthrough-powershell.md).

## Get an Azure subscription

To evaluate AKS on Azure Stack HCI in Azure, you'll need an Azure subscription. If you already have one provided by your company, you can skip this step, but if not, you have a couple of options.

The first option would apply to Visual Studio subscribers, where you can use Azure at no extra charge. With your monthly Azure DevTest individual credit, Azure is your personal sandbox for dev/test. You can provision virtual machines, cloud services, and other Azure resources. Credit amounts vary by subscription level, but if you manage your AKS on Azure Stack HCI Host VM run-time efficiently, you can test the scenario well within your subscription limits.

The second option would be to sign up for a [free trial](https://azure.microsoft.com/free/ "Azure free trial link"), which gives you $200 credit for the first 30 days, and 12 months of popular services for free.

> [!NOTE]
> The free trial subscription provides $200 for your usage, however the largest individual VM you can create is capped at 4 vCPUs, which is **not** enough to run this sandbox environment. Once you have signed up for the free trial, you can [upgrade this to a pay as you go subscription](/azure/cost-management-billing/manage/upgrade-azure-subscription) and this will allow you to keep your remaining credit ($200 to start with) for the full 30 days from when you signed up. You will also be able to deploy VMs with greater than 4 vCPUs.

You can also use this same Azure subscription to integrate with Azure Arc, once the deployment is completed.

## Azure VM Size Considerations

Before you deploy the VM in Azure, it's important to choose a size that's appropriate for your needs for this evaluation, along with a preferred region. It's highly recommended to choose a VM size that has at least 64GB memory. This deployment, by default, recommends using a Standard_E16s_v4, which is a memory-optimized VM size, with 16 vCPUs, 128 GiB memory, and no temporary SSD storage. The OS drive will be the default 127 GiB in size and the Azure VM deployment will add an additional 8 data disks (32 GiB each by default), so you'll have around 256GiB to deploy AKS on Azure Stack HCI. You can also make this larger after deployment, if you wish.

This is just one VM size that we recommend - you can adjust accordingly to suit your needs, even after deployment. The point here is, think about how large an AKS on Azure Stack HCI infrastructure you'd like to deploy inside this Azure VM, and select an Azure VM size from there. Some potential examples would be:

### D-series VMs (General purpose) with at least 64GB memory

| Size | vCPU | Memory: GiB | Temp storage (SSD): GiB | Premium Storage |
|:--|---|---|---|---|
| Standard_D16s_v3  | 16  | 64 | 128 | Yes |
| Standard_D16_v4  | 16  | 64 | 0 | No |
| **Standard_D16s_v4**  | **16**  | **64**  | **0**  | **Yes** |
| Standard_D16d_v4 | 16 | 64  | 600 | No |
| Standard_D16ds_v4 | 16 | 64 | 600 | Yes |

For reference, the Standard_D16s_v4 VM size costs approximately US $0.77 per hour based on East US region, under a Visual Studio subscription.

### E-series VMs (Memory optimized - Recommended for AKS on Azure Stack HCI) with at least 64GB memory

| Size | vCPU | Memory: GiB | Temp storage (SSD): GiB | Premium Storage |
|:--|---|---|---|---|
| Standard_E8s_v3  | 8  | 64  | 128  | Yes  |
| Standard_E8_v4  | 8  | 64  | 0  | No |
| **Standard_E8s_v4**  | **8**  | **64**  | **0**  | **Yes** |
| Standard_E8d_v4 | 8 | 64  | 300  | No |
| Standard_E8ds_v4 | 8 | 64 | 300  | Yes |
| Standard_E16s_v3  | 16  | 128 | 256 | Yes |
| **Standard_E16s_v4**  | **16**  | **128**  | **0**  | **Yes** |
| Standard_E16d_v4 | 16 | 128  | 600 | No |
| Standard_E16ds_v4 | 16 | 128 | 600 | Yes |

For reference, the Standard_E8s_v4 VM size costs approximately US $0.50 per hour based on East US region, under a Visual Studio subscription.

Note the following considerations:

* A number of these VM sizes include temp storage, which offers high performance, but is not persistent through reboots, Azure host migrations and more. It's therefore advisable, that if you are going to be running the Azure VM for a period of time, but shutting down frequently, that you choose a VM size with no temp storage, and ensure your nested VMs are placed on the persistent data drive within the OS.
* It's strongly recommended that you choose a VM size that supports premium storage - when running nested virtual machines, increasing the number of available IOPS can have a significant impact on performance, hence choosing premium storage over Standard HDD or Standard SSD is strongly advised. Refer to the table above to make the most appropriate selection.
* Please ensure that whichever VM size you choose, it [supports nested virtualization](/azure/virtual-machines/acu) and is [available in your chosen region](https://azure.microsoft.com/global-infrastructure/services/?products=virtual-machines).

## Deploying the Azure VM

The following guidance provides two main options for deploying the Azure VM. In both cases, the deployment will be automated to the point of which you can proceed immediately to download the AKS on Azure Stack HCI software, and progress through your evaluation.

1. The first option is to perform a deployment via a [custom Azure Resource Manager template](#option-1---create-the-vm-with-an-azure-resource-manager-json-template). This option can be launched quickly, directly from the button within the documentation, and after completing a simple form, your VM will be deployed, and host configuration automated.
2. The second option is a [deployment of the ARM template using PowerShell](#option-2---create-the-vm-with-powershell). Again, your VM will be deployed, and host configuration automated.

### Deployment detail

As part of the deployment, the following steps will be **automated for you**:

1. A Windows Server 2019 or 2022 Datacenter VM is deployed in Azure.
2. 8 x 32GiB (by default) Azure Managed Disks are attached and provisioned with a Simple Storage Space for optimal nested VM performance.
3. The Hyper-V role and management tools, including Failover Clustering tools, are installed and configured.
4. An internal vSwitch is created and NAT-configured to enable outbound networking.
5. The DNS role and accompanying management tools are installed and DNS fully configured.
6. The DHCP role and accompanying management tools are installed and DHCP fully configured. DHCP Scope is enabled.
7. Windows Admin Center is installed and pre-installed extensions are updated.
8. The Microsoft Edge browser is installed.

This automated deployment should take about 13-15 minutes.

### Option 1 - Create the VM with an Azure Resource Manager JSON template

To keep things simple and graphical, we'll show you how to deploy your VM via an Azure Resource Manager template. To simplify things further, we'll use the following buttons.

First, the **Visualize** button will launch the ARMVIZ designer view, where you will see a graphic representing the core components of the deployment, including the VM, NIC, disk and more. If you want to open this in a new tab, **hold CTRL** when you click the button.

[![Visualize your template deployment](https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png)](http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Faks-hci%2Fmain%2Feval%2Fjson%2Fakshcihost.json "Visualize your template deployment")

Second, the **Deploy to Azure** button, when clicked, takes you directly to the Azure portal, and upon sign-in, provides you with a form to complete. If you want to open this in a new tab, hold CTRL when you click the button.

[![Deploy to Azure](https://aka.ms/deploytoazurebutton)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Faks-hci%2Fmain%2Feval%2Fjson%2Fakshcihost.json "Deploy to Azure")

Upon clicking the **Deploy to Azure** button, enter the details, which should look something similar to those shown below, and click **Purchase**.

![Custom template deployment in Azure](/eval/media/azure_vm_custom_template_new.png "Custom template deployment in Azure")

> [!NOTE]
> For customers with Software Assurance, Azure Hybrid Benefit for Windows Server allows you to use your on-premises Windows Server licenses and run Windows virtual machines on Azure at a reduced cost. By selecting **Yes** for the "Already have a Windows Server License", you confirm you have an eligible Windows Server license with Software Assurance or Windows Server subscription to apply this Azure Hybrid Benefit and have reviewed the [Azure hybrid benefit compliance](https://go.microsoft.com/fwlink/?LinkId=859786).

The custom template will be validated, and if all of your entries are correct, you can select **Create**. Within a few minutes, your VM is created.

![Custom template deployment in Azure completed](/eval/media/azure_vm_custom_template_completed.png "Custom template deployment in Azure completed")

If you chose to enable the auto-shutdown for the VM, and supplied a time and time zone, but want to also add a notification alert, select **Go to resource group**, and then perform the following steps:

1. In the **Resource group** overview blade, select the **AKSHCIHost001** virtual machine.
2. On the overview blade for your VM, scroll down on the left-hand navigation, and select **Auto-shutdown**.
3. Ensure the **Enabled** slider is still set to **On**, and that your **time** and **time zone** information is correct.
4. Select **Yes** to enable notifications, and enter a Webhook URL, or email address.
5. Select **Save**.

You'll be notified when the VM has been successfully shut down at the requested time.

With that completed, skip to [connecting to your Azure VM](#connect-to-your-azure-vm).

#### Deployment errors

If your Azure VM fails to deploy successfully, and the error relates to the **AKSHCIHost001/ConfigureAksHciHost** PowerShell DSC extension, see the [troubleshooting steps](#troubleshooting).

### Option 2 - Create the VM with PowerShell

For simplicity and speed, you can also use PowerShell on the local workstation to deploy the Windows Server VM to Azure using the ARM template described earlier. As an alternative, you can take the following commands, edit them, and run them directly in [PowerShell in Azure Cloud Shell](/azure/cloud-shell/quickstart-powershell). This guide assumes you're using the PowerShell console/ISE or Windows terminal locally on your workstation.

#### Update the Execution Policy

In this step, you'll update your PowerShell execution policy to **RemoteSigned**:

```powershell
# Get the Execution Policy on the system, and make note of it before making changes
Get-ExecutionPolicy
# Set the Execution Policy for this process only
if ((Get-ExecutionPolicy) -ne "RemoteSigned") { Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force }
```

#### Download the Azure PowerShell modules

To create a new VM in Azure, ensure you have the latest Azure PowerShell modules.

> [!WARNING]
> Having both the AzureRM and Az modules installed for PowerShell 5.1 on Windows at the same time is not supported. If you need to keep AzureRM available on your system, install the Az module for PowerShell 6.2.4 or later.

```powershell
# Install latest NuGet provider
Install-PackageProvider -Name NuGet -Force

# Check if the AzureRM PowerShell modules are installed - if so, present a warning
if ($PSVersionTable.PSEdition -eq 'Desktop' -and (Get-Module -Name AzureRM -ListAvailable)) {
    Write-Warning -Message ('Az module not installed. Having both the AzureRM and ' +
        'Az modules installed at the same time is not supported.')
} else {
    # If no AzureRM PowerShell modules are detected, install the Azure PowerShell modules
    Install-Module -Name Az -AllowClobber -Scope CurrentUser
}
```

By default, the PowerShell gallery is not configured as a trusted repository for **PowerShellGet**, so you may be prompted to allow installation from this source, and trust the repository. Answer **(Y) Yes** or **(A) Yes to All** to continue with the installation. The installation takes a few moments to complete, depending on your download speeds.

#### Sign into Azure

With the modules installed, you can sign into Azure. By using the `Login-AzAccount` cmdlet, you're presented with a sign-in screen for you to authenticate with Azure. Use the credentials that have access to the subscription where you'd like to deploy this VM.

```powershell
# Login to Azure
Login-AzAccount
```

When you've successfully logged in, you are presented with the default subscription and tenant associated with those credentials.

![Result of Login-AzAccount](/eval/media/Login-AzAccount.png "Result of Login-AzAccount")

If this is the subscription and tenant you want to use for this evaluation, you can move on to the next step. However, if you want to deploy the VM to an alternate subscription, run the following commands:

```powershell
# Optional - if you wish to switch to a different subscription
# First, get all available subscriptions as the currently logged in user
$context = Get-AzContext -ListAvailable
# Display those in a grid, select the chosen subscription, then press OK.
if (($context).count -gt 1) {
    $context | Out-GridView -OutputMode Single | Set-AzContext
}
```

With the sign-in successful, and the target subscription confirmed, you can move on to deploy the VM.

#### Deploy the VM with PowerShell

To keep things as streamlined as possible, deploy the VM that will host AKS on Azure Stack HCI, using PowerShell.

In the following script, change the VM name, along with other parameters. The public DNS name for this VM is generated by combining your VM name, with a random GUID to ensure it is unique, and the deployment completes without conflicts.

```powershell
# Adjust any parameters you wish to change

$rgName = "AKSHCILabRg"
$location = "East US" # To check available locations, run Get-AzureLocation #
$timeStamp = (Get-Date).ToString("MM-dd-HHmmss")
$deploymentName = ("AksHciDeploy_" + "$timeStamp")
$vmName = "AKSHCIHost001"
$vmSize = "Standard_E16s_v4"
$vmGeneration = "Generation 2" # Or Generation 1
$domainName = "akshci.local"
$dataDiskType = "StandardSSD_LRS"
$dataDiskSize = "32"
$adminUsername = "azureuser"
$adminPassword = ConvertTo-SecureString 'P@ssw0rd123!' -AsPlainText -Force
$enableDHCP = "Enabled" # Or Disabled #
$customRdpPort = "3389" # Between 0 and 65535 #
$autoShutdownStatus = "Enabled" # Or Disabled #
$autoShutdownTime = "00:00"
$autoShutdownTimeZone = (Get-TimeZone).Id # To list timezones, run [System.TimeZoneInfo]::GetSystemTimeZones() |ft -AutoSize
$existingWindowsServerLicense = "No" # See NOTE 2 below on Azure Hybrid Benefit


# Create Resource Group
New-AzResourceGroup -Name $rgName -Location  $location -Verbose

# Deploy ARM Template
New-AzResourceGroupDeployment -ResourceGroupName $rgName -Name $deploymentName `
    -TemplateUri "https://raw.githubusercontent.com/Azure/aks-hci/october_eval/eval/json/akshcihost.json" `
    -virtualMachineName $vmName `
    -virtualMachineSize $vmSize `
    -virtualMachineGeneration $vmGeneration `
    -domainName $domainName `
    -dataDiskType $dataDiskType `
    -dataDiskSize $dataDiskSize `
    -adminUsername $adminUsername `
    -adminPassword $adminPassword `
    -enableDHCP $enableDHCP `
    -customRdpPort $customRdpPort `
    -autoShutdownStatus $autoShutdownStatus `
    -autoShutdownTime $autoShutdownTime `
    -autoShutdownTimeZone $autoShutdownTimeZone `
    -alreadyHaveAWindowsServerLicense $existingWindowsServerLicense `
    -Verbose

# Get connection details of the newly created VM
Get-AzVM -ResourceGroupName $rgName -Name $vmName
$getIp = Get-AzPublicIpAddress -Name "AKSHCILabPubIp" -ResourceGroupName $rgName
$getIp | Select-Object Name,IpAddress,@{label='FQDN';expression={$_.DnsSettings.Fqdn}}
```

Note the following considerations:

* When running the script, if your VM size contains an 's', such as **Standard_E16s_v4**, it can use premium LRS storage. If it does not contain an 's', it can only deploy with a standard SSD. See the [previous table](#azure-vm-size-considerations) to determine the appropriate size for your deployment.

* For customers with Software Assurance, Azure Hybrid Benefit for Windows Server allows you to use your on-premises Windows Server licenses and run Windows virtual machines on Azure at a reduced cost. By removing the comment in the preceding script, for the `-LicenseType` parameter, you confirm you have an eligible Windows Server license with Software Assurance or Windows Server subscription to apply this Azure Hybrid Benefit and have reviewed the [Azure hybrid benefit compliance document](https://go.microsoft.com/fwlink/?LinkId=859786).

Once you've made your size and region selection, based on the information provided earlier, run the PowerShell script and wait about 10 minutes for your VM deployment to complete.

![Virtual machine successfully deployed with PowerShell](/eval/media/powershell_vm_deployed.png "Virtual machine successfully deployed with PowerShell")

With the VM successfully deployed, make a note of the fully qualified domain name, as you'll use that to connect to the VM.

#### OPTIONAL - Enable auto-shutdown notifications for your VM

If you chose to enable the auto-shutdown for the VM, and supplied a time and time zone, but also want to add a notification alert, perform the following steps:

1. Visit https://portal.azure.com/, and sign in with the same credentials you used previously.
2. Once signed in, using the search box on the dashboard, enter "akshci" and when the results are returned, select your **AKSHCIHost** virtual machine.

   ![Virtual machine located in Azure](/eval/media/azure_vm_search.png "Virtual machine located in Azure")

3. On the overview blade for your VM, scroll down in the left-hand navigation, and select **Auto-shutdown**.
4. Ensure the **Enabled** slider is still set to **On** and that your **time** and **time zone** information is correct.
5. Select **Yes** to enable notifications, and enter a Webhook URL, or email address.
6. Select **Save**.

You'll now be notified when the VM has been successfully shut down at the requested time.

![Enable VM auto-shutdown in Azure](/eval/media/auto_shutdown.png "Enable VM auto-shutdown in Azure")

#### Deployment errors

If your Azure VM fails to deploy successfully, and the error relates to the **AKSHCIHost001/ConfigureAksHciHost** PowerShell DSC extension, see the [troubleshooting steps](#troubleshooting).

## Access your Azure VM

With your Azure VM (AKSHCIHost001) successfully deployed and configured, you're ready to connect to the VM to start the deployment of the AKS on Azure Stack HCI and Windows Server infrastructure.

### Connect to your Azure VM

First, connect into the VM, with the easiest approach being via Remote Desktop. If you're not already signed into the [Azure portal](https://portal.azure.com), sign in with the same credentials you previously used. Once signed in, enter "azshci" in the search box on the dashboard, and in the search results select your **AKSHCIHost001** virtual machine.

![Virtual machine located in Azure](/eval/media/azure_vm_search.png "Virtual machine located in Azure")

In the **Overview** blade for your VM, at the top of the blade, select **Connect** from the drop-down options.

![Connect to a virtual machine in Azure](/eval/media/connect_to_vm.png "Connect to a virtual machine in Azure")

Select **RDP**. On the newly opened **Connect** blade, ensure that **Public IP** is selected. Also ensure that the RDP port matches what you provided at deployment time. By default, this should be **3389**. Then select **Download RDP File** and choose a suitable folder to store the .rdp file.

![Configure RDP settings for Azure VM](/eval/media/connect_to_vm_properties.png "Configure RDP settings for Azure VM")

Once downloaded, locate the .rdp file on your local machine, and double-click to open it. Click **Connect** and when prompted, enter the credentials you supplied when creating the VM earlier. Accept any certificate prompts, and within a few minutes you should be successfully logged into the Windows Server VM.

### Optional - update your Azure VM

Now that you're successfully connected to the VM, it's a good idea to ensure your OS is running the latest security updates and patches. VMs deployed from marketplace images in Azure should already contain most of the latest updates, however it's good to check for any additional updates, and apply them as necessary.

1. Open the **Start Menu** and search for **Update**.
2. In the **Updates** window, select **Check for updates**. If any are required, ensure they are downloaded and installed.
3. Restart if required, and when completed, re-connect your RDP session using the previous steps.

With the OS updated, and back online after any required reboot, you can deploy AKS on Azure Stack HCI and Windows Server.

## Troubleshooting

Occasionally, a transient or random deployment error can cause the Azure VM to show a failed deployment. This is typically caused by reboots and timeouts within the VM as part of the PowerShell DSC configuration process. In particular, this can occur when the Hyper-V role is enabled and the system reboots multiple times in quick succession. There may be some instances in which changes with the Chocolatey Package Manager cause deployment issues.

![Azure VM deployment error](/eval/media/vm_deployment_error.png "Azure VM deployment error")

If the error is related to the **AKSHCIHost001/ConfigureAksHciHost**, most likely the installation did complete successfully, but to double-check, you can perform these steps:

1. Follow the previous steps to [connect to your Azure VM](#connect-to-your-azure-vm).
2. When successfully connected, open a PowerShell console as administrator and run the following command to confirm the status of the last run:

   ```powershell
   # Check for last run
   Get-DscConfigurationStatus
   ```

   ![Result of Get-DscConfigurationStatus](/eval/media/get-dscconfigurationstatus.png "Screenshot of result of Get-DscConfigurationStatus")

3. As you can see, in this particular case, the PowerShell DSC configuration status appears to have been successful, however you might see a different result. You can re-apply the configuration by running the following commands:

   ```powershell
   cd "C:\Packages\Plugins\Microsoft.Powershell.DSC\*\DSCWork\akshcihost.0\AKSHCIHost"
   Start-DscConfiguration -Path . -Wait -Force -Verbose
   ```

4. You should see the DSC configuration reapplied without issues. If you then re-run the following PowerShell command, you should see success:

   ```powershell
   # Check for last run
   Get-DscConfigurationStatus
   ```

   ![Another result of Get-DscConfigurationStatus](/eval/media/get-dscconfigurationstatus2.png "Screenshot of applied result of Get-DscConfigurationStatus")

> [!NOTE]
> If this doesn't fix your issue, consider redeploying your Azure VM. If the issue persists, please raise an issue.

## Product improvements

If, while you work through this guide, you have an idea to make the product better, whether it's something in AKS on Azure Stack HCI, Windows Admin Center, or the Azure Arc integration and experience, let us know! We want to hear from you! [Head on over to our AKS on Azure Stack HCI GitHub page](https://github.com/Azure/aks-hci/issues "AKS on Azure Stack HCI GitHub"), where you can share your thoughts and ideas about making the technologies better.  If however, you have an issue that you'd like some help with, read on... 

## Raising issues

If you notice something is wrong with the evaluation guide, such as a step isn't working, or something just doesn't make sense - help us to make this guide better!  Raise an issue in GitHub, and we'll be sure to fix this as quickly as possible!

If however, you're having a problem with AKS on Azure Stack HCI outside of this evaluation guide, make sure you post to [our GitHub Issues page](https://github.com/Azure/aks-hci/issues "GitHub Issues"), where Microsoft experts and valuable members of the community will do their best to help you.## Next steps

## Next steps

In this step, you've successfully created and automatically configured your Azure VM, which will serve as the host for your AKS on Azure Stack HCI infrastructure. You have 2 choices on how to proceed, either a more graphical way, using Windows Admin Center or via PowerShell. Make your choice below:

* [Part 2a - Deploy your AKS-HCI infrastructure with Windows Admin Center (Choose 2a or 2b)](aks-hci-evalguide-2a.md)
* [Part 2b - Deploy your AKS-HCI infrastructure with PowerShell (Choose 2a or 2b)](aks-hci-evalguide-2b.md)
