---
title: Azure verification for VMs on Azure Local
description: Learn about the Azure verification for VMs feature on Azure Local.
author: sethmanheim
ms.author: sethm
ms.topic: overview
ms.custom:
  - devx-track-azurepowershell
ms.reviewer: jlei
ms.date: 07/08/2025
ms.lastreviewed: 03/05/2024
ms.service: azure-local
---

# Azure verification for VMs on Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

Microsoft Azure offers a range of differentiated workloads and capabilities that are designed to run only on Azure. Azure Local extends many of the same benefits you get from Azure, while running on the same familiar and high-performance on-premises or edge environments.

*Azure verification for VMs* makes it possible for supported Azure-exclusive workloads to work outside of the cloud. This feature, modeled after the [IMDS attestation](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows#attested-data) service in Azure, is a built-in platform attestation service that is enabled by default on Azure Local. It helps to provide guarantees for these VMs to operate in other Azure environments.

For more information about the previous version of this feature, version 22H2 or earlier, see [Azure Benefits on Azure Local](../manage/azure-benefits.md).

## Benefits available on Azure Local

Azure verification for VM enables you to use these benefits available only on Azure Local:

| Workload                                 | What it is                           | How to get benefits                                                                                                                                                                                                                                                                       |
|------------------------------------------|----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| Azure Machine Configuration | Azure Machine Configuration (formerly known as Azure Policy Guest Configuration) is provided by Azure Instance Metadata Service (IMDS). | IMDS requires you to enable [Legacy OS support](#legacy-os-support). |
| Extended Security Update (ESUs)          | Get security updates at no extra cost for end-of-support SQL and Windows Server VMs on Azure Local. <br/> For more information, see [Free Extended Security Updates (ESU) on Azure Local](../manage/azure-benefits-esu.md). | You must enable [Legacy OS support](#legacy-os-support) for older VMs running version Windows Server 2012 or earlier with [Latest Servicing Stack Updates](https://msrc.microsoft.com/update-guide/advisory/ADV990001).|
| Azure Virtual Desktop (AVD)                    | AVD session hosts can run only on Azure infrastructure. Activate your Windows multi-session VMs on Azure Local using Azure VM verification. <br/> Licensing requirements for AVD still apply. See [Azure Virtual Desktop pricing](/azure/virtual-desktop/azure-stack-hci-overview#pricing). | Activated automatically for VMs running version Windows 11 multi-session with 4B update released on April 9, 2024 (22H2: [KB5036893](https://support.microsoft.com/topic/april-9-2024-kb5036893-os-builds-22621-3447-and-22631-3447-a674a67b-85f5-4a40-8d74-5f8af8ead5bb), 21H2: [KB5036894](https://support.microsoft.com/topic/april-9-2024-kb5036894-os-build-22000-2899-165dd6e1-74be-45b7-84e3-0f2a25d375f3)) or later. You must enable [legacy OS support](#legacy-os-support) for VMs running version Windows 10 multi-session with 4B update released on April 9, 2024  [KB5036892](https://support.microsoft.com/topic/april-9-2024-kb5036892-os-builds-19044-4291-and-19045-4291-cb5d2d42-6b10-48f7-829a-be7d416a811b) or later. |
| Windows Server Datacenter: Azure Edition | Azure Edition VMs can run only on Azure infrastructure, including Azure Local. Activate your [Windows Server Azure Edition](/windows-server/get-started/azure-edition) VMs and use the latest Windows Server innovations and other exclusive features. <br/> Licensing requirements still apply. See ways to [license Windows Server VMs on Azure Local](../manage/vm-activate.md?tabs=azure-portal).         | Activated automatically for VMs running Windows Server Azure Edition 2022 with 4B update released on April 9, 2024 ([KB5036909](https://support.microsoft.com/topic/april-9-2024-kb5036909-os-build-20348-2402-36062ce9-f426-40c6-9fb9-ee5ab428da8c)) or later. |
| Azure Update Manager | Get [Azure Update Manager](/azure/update-manager/overview?branch=main&tabs=azure-arc-vms) at no cost. This service provides a SaaS solution to manage and govern software updates to VMs on Azure Local. | Available automatically for Azure Local VMs created through the Azure Arc resource bridge on Azure Local. With Software Assurance, you can attest your machine using Windows Server Azure benefits and licenses, and get AUM for free. For more information, see [Azure Update Manager frequently asked questions](/azure/update-manager/update-manager-faq#what-is-the-pricing-for-azure-update-manager). |
| Azure Machine Configuration         | Get [Azure Machine configuration](/azure/governance/machine-configuration) at no cost. This extension enables the auditing and configuration of OS settings as code for machines and VMs. | Arc agent version 1.39 or later. See [Latest agent release](/azure/azure-arc/servers/agent-release-notes). |

> [!NOTE]
> To ensure continued functionality, update your VMs on Azure Local to the latest cumulative update by June 17, 2024. This update is essential for VMs to continue using Azure benefits. See the [Azure Local blog post](https://techcommunity.microsoft.com/t5/azure-stack-blog/apply-critical-update-for-azure-stack-hci-vms-to-maintain-azure/ba-p/4115023) for more information.

## Manage Azure VM verification

Azure VM verification is automatically enabled by default in Azure Local. The following instructions outline the prerequisites for using this feature and steps for managing benefits (optional).

> [!NOTE]
> To enable Extended Security Updates (ESUs), you must do additional setup and turn on [legacy OS support](#legacy-os-support).

### Host prerequisites

- Make sure that you have access to Azure Local. All machines must be online, registered, and the system deployed. For more information, see [Register your machines with Arc](./deployment-arc-register-server-permissions.md) and see [Deploy via Azure portal](deploy-via-portal.md).
- [Install Hyper-V and RSAT-Hyper-V-Tools](/windows-server/virtualization/hyper-v/get-started/install-the-hyper-v-role-on-windows-server).
- (Optional) If you're using Windows Admin Center, you must install Cluster Manager extension (version 2.319.0) or later.

### VM prerequisites

- Make sure to update your VMs. See the [version requirements for workloads](#benefits-available-on-azure-local).

- Turn on Hyper-V Guest Service Interface. See the instructions for [Windows Admin Center](azure-verification.md?tabs=wac#troubleshoot-vms) or for [PowerShell](azure-verification.md?tabs=azure-ps#troubleshoot-vms-1).

You can manage Azure VM verification using Windows Admin Center or PowerShell, or view its status using Azure CLI or the Azure portal. The following sections describe each option.

### [Azure portal](#tab/azureportal)

1. In your Azure Local resource page, navigate to the **Configuration** tab.
2. Under the feature **Azure verification for VMs**, view the host attestation status.

   :::image type="content" source="media/azure-verification/cluster-status.png" alt-text="Screenshot showing system status on the portal." lightbox="media/azure-verification/cluster-status.png":::

### [Azure CLI](#tab/azurecli)

Azure CLI is available to install in Windows, macOS, and Linux environments. It can also be run in [Azure Cloud Shell](https://shell.azure.com/). This section describes how to use Bash in Azure Cloud Shell. For more information, see [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Azure CLI to check Azure VM verification following these steps:

1. Set up parameters from your subscription, resource group, and cluster name.

   ```azurecli
   subscription="00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
   resourceGroup="local-rg" # Replace with your resource group name
   clusterName="LocalCluster" # Replace with your cluster name

   az account set --subscription "${subscription}"
   ```

2. To view Azure VM verification status on a cluster, run the following command:

   ```azurecli
   az stack-hci cluster list \
   --resource-group "${resourceGroup}" \
   --query "[?name=='${clusterName}'].{Name:name, AzureBenefitsHostAttestation:reportedProperties.imdsAttestation}" \
   -o table
   ```

### [Windows Admin Center](#tab/wac)

### Check machine status of Azure VM verification

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down menu, navigate to the system that you want to activate, then under **Settings**, select **Azure verification for VMs**.

2. To check Azure VM verification machine status:
   - Cluster-level status: **Host status** appears as **On**.
   - Server-level status: Under the **Server** tab in the dashboard, check that the status for every machine shows as **Active** in the table.

     :::image type="content" source="media/azure-verification/windows-admin-center-server.png" alt-text="Screenshot showing machine status." lightbox="media/azure-verification/windows-admin-center-server.png":::

### Troubleshoot machines

- Under the **Server** tab, if one or more machines appear as **Expired**:
  - If the machine hasn't synced with Azure for more than 30 days, its status appears as **Expired** or **Inactive**. Select on **Sync with Azure** to schedule a manual sync.

### Manage benefits activated on VMs

1. To check what benefits are activated on VMs, navigate to the **VMs** tab.

2. The dashboard shows the number of VMs with:

   - **Active benefits**: These VMs have Azure-exclusive features activated via Azure VM verification.
   - **Inactive benefits**: These VMs have Azure-exclusive features that need further action before activation.
   - **Unknown**: We can't determine the eligible benefits for these VMs because Hyper-V data exchange is turned off. See the following troubleshooting section.
   - **No applicable benefits**: These VMs don't have Azure-exclusive features and hence don't require Azure VM verification.

3. The table displays the **Eligible benefit** that is applicable for each VM. See the [full list of benefits available on Azure Local](#benefits-available-on-azure-local).

   :::image type="content" source="media/azure-verification/virtual-machine-dashboard.png" alt-text="Screenshot showing virtual machine dashboard and status." lightbox="media/azure-verification/virtual-machine-dashboard.png":::

### Troubleshoot VMs

- Under the **VMs** tab, if one or more VMs appear as **Inactive benefits**:
  - If the action suggested is to **Install updates**, you might not have the minimum OS version required for the benefit. Update the VM to meet the [version requirements for workloads](#benefits-available-on-azure-local).
  - If the action suggested is to **Turn on Guest Service Interface**, select it and open the context pane to enable the [Hyper-V Guest Service Interface](/virtualization/hyper-v-on-windows/reference/integration-services#hyper-v-powershell-direct-service). This feature is required for VMs to communicate to the host via VMbus.
  - If the action suggested is regarding **legacy OS support**, see [troubleshooting for legacy OS support](#legacy-os-support).

- Under the **VMs** tab, if one or more VMs appear as **Unknown**:
  - If you want to determine the benefits available for these VMs, you can either do so manually by checking the [full list of benefits available on Azure Local](#benefits-available-on-azure-local), or Windows Admin Center can display this information. To access the information through Windows Admin Center, enable [Hyper-V data exchange (KVP)](/virtualization/hyper-v-on-windows/reference/integration-services#hyper-v-data-exchange-service-kvp) for your VMs by selecting the action labeled **Turn on Hyper-V data exchange**.

### [PowerShell](#tab/azure-ps)

### Check machine status of Azure VM verification

- When Azure VM verification setup is successful, you can view the host status. Check the system property **IMDS Attestation** by running the following command:

   ```powershell
   Get-AzureStackHCI
   ```

- Or, to view  Azure VM verification status for machines, run the following command:

   ```powershell
   Get-AzureStackHCIAttestation [[-ComputerName] <string>]
   ```

### Troubleshoot machines

- If Azure VM verification for one or more machines isn't yet synced and renewed with Azure, it might appear as **Expired** or **Inactive**. Schedule a manual sync:

  ```powershell
  Sync-AzureStackHCI
  ```

### Manage benefits activated on VMs

- To check access to Azure VM verification for VMs, run the following command:

   ```powershell
   Get-AzStackHCIVMAttestation
   ```

   > [!NOTE]
   > A VM that is supported for **v2** can communicate with the machine using VMBus. Conversely, a **v1** supported VM is configured with legacy OS support and can access Azure VM verification via REST. If a VM supports both **v1** and **v2**, the **v2** method (i.e. VMBus) is primarily used, but it can fall back to **v1** if **v2** encounters an issue.

### Troubleshoot VMs

- To set up access to Azure VM verification for VMs, you can enable the [Hyper-V Guest Service Interface](/virtualization/hyper-v-on-windows/reference/integration-services#hyper-v-powershell-direct-service).

  To check that Hyper-V Guest Service Interface is enabled, run:

  ```powershell
  Get-VMIntegrationService [[-VMName] <VMName>] -Name "Guest Service Interface"
  ```

- To turn on the Hyper-V Guest Service Interface:

  ```powershell
  Enable-VMIntegrationService [[-VMName] <VMName>] -Name "Guest Service Interface"
  ```

- To check that the VMs can access Azure VM verification on the host, run the following command on the host:

  ```powershell
  Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://127.0.0.1:42542/metadata/attested/document?api-version=2018-10-01" –usedefaultcredentials
  ```

---

## Legacy OS support

For older VMs that lack the necessary Hyper-V functionality ([Guest Service Interface](/virtualization/hyper-v-on-windows/reference/integration-services#hyper-v-powershell-direct-service)) to communicate directly with the host, you must configure traditional networking components for Azure VM verification. If you have these workloads, such as Extended Security Updates (ESUs), follow the instructions in this section to set up legacy OS support.

### [Azure portal](#tab/azureportal)

You can't view legacy OS support from the Azure portal at this time.
  
### [Azure CLI](#tab/azurecli)

Azure CLI is available to install in Windows, macOS, and Linux environments. It can also be run in [Azure Cloud Shell](https://shell.azure.com/). This section describes how to use Bash in Azure Cloud Shell. For more information, see the [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Azure CLI to check Azure VM verification by following these steps:

1. Set up parameters from your subscription, resource group, and cluster name:

   ```azurecli
   subscription="00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
   resourceGroup="local-rg" # Replace with your resource group name
   clusterName="LocalCluster" # Replace with your cluster name

   az account set --subscription "${subscription}"
   ```

2. To view legacy OS support status on a cluster, run the following command:

   ```azurecli
   az stack-hci cluster list \
   --resource-group "${resourceGroup}" \
   --query "[?name=='${clusterName}'].{Name:name, AzureBenefitsHostAttestation:reportedProperties.supportedCapabilities}" \
   -o table
   ```

### [Windows Admin Center](#tab/wac)

### 1. Turn on legacy OS support on the host

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down menu, navigate to the system that you want to activate, then under **Settings**, select **Azure verifications for VMs**.

2. In the section for **Legacy OS support**, select **Change status**. Select **On** in the context pane. This setting also enables networking access for all existing VMs. You must manually turn on legacy OS support for any new VMs that you create later.
  
3. Select **Change status** to confirm. It might take a few minutes for machines to reflect the changes.

4. When legacy OS support is successfully turned on:

   - Check that **Legacy OS support** appears as **On**.
   - Under the **Server** tab in the dashboard, check that legacy OS support for every machine shows as **On** in the table.

     :::image type="content" source="media/azure-verification/legacy-support.png" alt-text="Screenshot showing dashboard with legacy OS support information." lightbox="media/azure-verification/legacy-support.png":::

### 2. Enable access for new VMs

You must enable legacy OS networking for any new VMs that you create after the first setup. To manage access for VMs, navigate to the **VMs** tab. Any VM that requires legacy OS support access appear as **Inactive**. Select the action to **Set up legacy OS networking** for the selected VM, or for all existing VMs on the system.

:::image type="content" source="media/azure-verification/legacy-vm.png" alt-text="Screenshot showing legacy VM dashboard." lightbox="media/azure-verification/legacy-vm.png":::

> [!NOTE]
> To successfully enable legacy OS support on Generation 1 VMs, the VM must first be powered off to enable the NIC to be added.

### [PowerShell](#tab/azure-ps)

### 1. Turn on legacy OS support on the host

- Run the following command from an elevated PowerShell window on your Azure Local:

   ```powershell
   Enable-AzStackHCIAttestation
   ```

- Or, if you want to add all existing VMs on setup, you can run the following command:

   ```powershell
   Enable-AzStackHCIAttestation -AddVM
   ```

- Check that legacy OS support is turned on:

   ```powershell
   Get-AzureStackHCIAttestation [[-ComputerName] <string>]
   ```

#### Troubleshoot machines

- To turn off and reset legacy OS support on your system, run the following command:

  ```powershell
  Disable-AzStackHCIAttestation -RemoveVM
  ```

### 2. Enable access for VMs

- To configure networking access for selected VMs, run the following command on your Azure Local:

   ```powershell
   Add-AzStackHCIVMAttestation [-VMName]
   ```

- Or, to add all existing VMs, run the following command:

   ```powershell
   Add-AzStackHCIVMAttestation -AddAll
   ```

- Get list of VMs that have access to legacy OS support:

   ```powershell
   Get-AzStackHCIVMAttestation
   ```

  > [!NOTE]
  > To successfully enable legacy OS support on Generation 1 VMs, the VM must first be powered off to enable the NIC to be added.

#### Troubleshoot VMs

- To remove access to legacy OS support for selected VMs:

  ```powershell
  Remove-AzStackHCIVMAttestation -VMName <string>
  ```

  Or, to remove access for all existing VMs:

  ```powershell
  Remove-AzStackHCIVMAttestation -RemoveAll
  ```

- To check that the VMs can access legacy OS support on the host, run the following command on the VM:

  ```powershell
  Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri http://169.254.169.253:80/metadata/attested/document?api-version=2018-10-01
  ```

---

## FAQ

This section provides answers to some frequently asked questions about using Azure Benefits.

### What Azure-exclusive workloads can I enable with Azure VM verification?

See the [full list here](#benefits-available-on-azure-local).

### Does it cost anything to enable Azure VM verification?

No. Turning on Azure VM verification incurs no extra fees.

### Can I use Azure VM verification on environments other than Azure Local?

No. Azure VM verification is a feature built into Azure Local, and can only be used on Azure Local.

### If I just upgraded from 22H2, and I previously turned on the Azure Benefits feature, do I need to do anything new?

If you upgraded a system that previously had [Azure Benefits on Azure Local](../manage/azure-benefits.md) set up for your workloads, you don't need to do anything when you upgrade to Azure Local. When you upgrade, the feature remains enabled, and legacy OS support is turned on as well. However, if you want to use an improved way of doing VM-to-host communication through VM Bus, make sure that you have the required [host prerequisites](#host-prerequisites) and the [VM prerequisites](#vm-prerequisites).

### I just set up Azure VM verification on my system. How do I ensure that Azure VM verification stays active?

- In most cases, there's no user action required. Azure Local automatically renews Azure VM verification when it syncs with Azure.
- However, if the system disconnects for more than 30 days and Azure VM verification shows as **Expired**, you can manually sync using PowerShell and Windows Admin Center. For more information, see [syncing Azure Local](../faq.yml#what-happens-if-the-30-day-limit-is-exceeded).

### What happens when I deploy new VMs, or delete VMs?

- When you deploy new VMs that require Azure VM verification, they're automatically activated if they have the correct [VM prerequisites](#vm-prerequisites).

- However, for legacy VMs using legacy OS support, you can manually add new VMs to access Azure VM verification using Windows Admin Center or PowerShell, using the [preceding instructions](#legacy-os-support).
- You can still delete and migrate VMs as usual. The NIC **AZSHCI_GUEST-IMDS_DO_NOT_MODIFY** still exists on the VM after migration. To clean up the NIC before migration, you can remove VMs from Azure VM verification using Windows Admin Center or PowerShell using the preceding instructions for legacy OS support, or you can migrate first and manually delete NICs afterwards.

### What happens when I add or remove machines?

- When you add a machine, it's automatically activated if it has the correct [Host prerequisites](#host-prerequisites).
- If you're using legacy OS support, you might need to manually enable these machines. Run `Enable-AzStackHCIAttestation [[-ComputerName] <String>]` in PowerShell. You can still delete machines or remove them from the system as usual. The vSwitch **AZSHCI_HOST-IMDS_DO_NOT_MODIFY** still exists on the machine after removal from the system. You can leave it if you're planning to add the machine back to the system later, or you can remove it manually.

## Next steps

- [Extended security updates (ESU) on Azure Local](../manage/azure-benefits-esu.md).
- [Azure Local overview](../overview.md).
- [Azure Local FAQ](../faq.yml).
