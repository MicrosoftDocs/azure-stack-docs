---
title: Azure Benefits on Azure Stack HCI (22H2 and earlier)
description: Learn about the Azure Benefits feature on Azure Stack HCI version 22H2 and earlier.
author: sethmanheim
ms.author: sethm
ms.topic: overview
ms.custom:
  - devx-track-azurepowershell
ms.reviewer: jlei
ms.date: 11/28/2023
ms.lastreviewed: 11/13/2023
---

# Azure Benefits on Azure Stack HCI (22H2 and earlier)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

> [!NOTE]
> This article is for Azure Stack HCI version 22H2 and earlier only. For version 23H2 and later, see the documentation for [Azure verification for VMs](../deploy/azure-verification.md).

Microsoft Azure offers a range of differentiated workloads and capabilities that are designed to run only on Azure. Azure Stack HCI extends many of the same benefits you get from Azure, while running on the same familiar and high-performance on-premises or edge environments.

*Azure Benefits* makes it possible for supported Azure-exclusive workloads to work outside of the cloud. You can enable Azure Benefits on Azure Stack HCI at no extra cost. If you have Windows Server workloads, we recommend turning it on. 

Take a few minutes to watch the introductory video on Azure Benefits:

> [!VIDEO https://www.youtube.com/embed/s3CE9ob3hDo]

## Azure Benefits available on Azure Stack HCI

Turning on Azure Benefits enables you to use these Azure-exclusive workloads on Azure Stack HCI:

| Workload                                 | Versions supported                           | What it is                                                                                                                                                                                                                                                                       |
|------------------------------------------|----------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Windows Server Datacenter: Azure Edition | 2022 edition or later                        | An Azure-only guest operating system that includes all the latest Windows Server innovations and other exclusive features. <br/> Learn more: [Automanage for Windows Server](/azure/automanage/automanage-windows-server-services-overview)                                      |
| Extended Security Update (ESUs)          | October 12th, 2021 security updates or later | A program that allows customers to continue to get security updates for End-of-Support SQL Server and Windows Server VMs, now free when running on Azure Stack HCI. <br/> For more information, see [Extended security updates (ESU) on Azure Stack HCI](azure-benefits-esu.md). |
| Azure Policy guest configuration         | Arc agent version 1.13 or later              | A feature that can audit or configure OS settings as code, for both host and   guest machines. <br/> Learn more: [Understand the guest configuration feature of Azure Policy](/azure/governance/policy/concepts/guest-configuration)                                             |
| Azure Virtual Desktop                    | For multi-session editions only. Windows 10 Enterprise multi-session or later. | A service that enables you to deploy Azure Virtual Desktop session hosts on your Azure Stack HCI infrastructure. <br/> For more information, see the [Azure Virtual Desktop for Azure Stack HCI overview](/azure/virtual-desktop/azure-stack-hci-overview). |

## How it works

This section is optional reading, and explains more about how Azure Benefits on HCI works "under the hood."

Azure Benefits relies on a built-in platform attestation service on Azure Stack HCI, and helps to provide assurance that VMs are indeed running on Azure environments.

This service is modeled after the same [IMDS Attestation](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows#attested-data) service that runs in Azure, in order to enable some of the same workloads and benefits available to customers in Azure. Azure Benefits returns an almost identical payload. The main difference is that it runs on-premises, and therefore guarantees that VMs are running on Azure Stack HCI instead of Azure.

:::image type="content" source="media/azure-benefits/cluster.png" alt-text="Architecture":::

Turning on Azure Benefits starts the service running on your Azure Stack HCI cluster:

1. On every server, HciSvc obtains a certificate from Azure, and securely stores it within an enclave on the server.

   > [!NOTE]
   > Certificates are renewed every time the Azure Stack HCI cluster syncs with Azure, and each renewal is valid for 30 days. As long as you maintain the usual 30 day connectivity requirements for Azure Stack HCI, no user action is required.

2. HciSvc exposes a private and non-routable REST endpoint, accessible only to VMs on the same server. To enable this endpoint, an internal vSwitch is configured on the Azure Stack HCI host (named *AZSHCI_HOST-IMDS_DO_NOT_MODIFY*). VMs then must have a NIC configured and attached to the same vSwitch (*AZSHCI_GUEST-IMDS_DO_NOT_MODIFY*).

   > [!NOTE]
   > Modifying or deleting this switch and NIC prevents Azure Benefits from working properly. If errors occur, disable Azure Benefits using Windows Admin Center or the PowerShell instructions that follow, and then try again.

3. Consumer workloads (for example, Windows Server Azure Edition guests) request attestation. HciSvc then signs the response with an Azure certificate.

   > [!NOTE]
   > You must manually enable access for each VM that needs Azure Benefits.

## Enable Azure Benefits

Before you begin, you'll need the following prerequisites:

- An Azure Stack HCI cluster:
  - [Install updates](../manage/update-cluster.md): Version 21H2, with at least the December 14, 2021 security update KB5008223 or later.
  - [Register Azure Stack HCI](../deploy/register-with-azure.md?tab=windows-admin-center#register-a-cluster): All servers must be online and registered to Azure.
  - [Install Hyper-V and RSAT-Hyper-V-Tools](/windows-server/virtualization/hyper-v/get-started/install-the-hyper-v-role-on-windows-server).

- If you are using Windows Admin Center:
  - Windows Admin Center (version 2103 or later) with Cluster Manager extension (version 2.41.0 or later).

You can enable Azure Benefits on Azure Stack HCI using Windows Admin Center, PowerShell, Azure CLI, or Azure portal. The following sections describe each option.

> [!NOTE]
> To successfully enable Azure Benefits on Generation 1 VMs, the VM must first be powered off to enable the NIC to be added.

## Manage Azure Benefits

## [Windows Admin Center](#tab/wac)

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down menu, navigate to the cluster that you want to activate, then under **Settings**, select **Azure Benefits**.

2. In the **Azure Benefits** pane, select **Turn on**. By default, the checkbox to turn on for all existing VMs is selected. You can deselect it and manually add VMs later.

3. Select **Turn on** again to confirm setup. It may take a few minutes for servers to reflect the changes.

4. When Azure Benefits setup is successful, the page updates to show the Azure Benefits dashboard. To check Azure Benefits for the host:
   1. Check that **Azure Benefits cluster status** appears as **On**.
   2. Under the **Cluster** tab in the dashboard, check that Azure Benefits for every server shows as **Active** in the table.

5. To check access to Azure Benefits for VMs: Check the status for VMs with Azure Benefits turned on. It's recommended that all of your existing VMs have Azure Benefits turned on; for example, 3 out of 3 VMs.

:::image type="content" source="media/azure-benefits/manage-benefits.gif" alt-text="Screenshot of Azure Benefits in Windows Admin Center.":::

## [Azure PowerShell](#tab/azure-ps)

1. To set up Azure Benefits, run the following command from an elevated PowerShell window on your Azure Stack HCI cluster:

   ```powershell
   Enable-AzStackHCIAttestation
   ```

   Or, if you want to add all existing VMs on setup, you can run the following command:

   ```powershell
   Enable-AzStackHCIAttestation -AddVM
   ```

2. When Azure Benefits setup is successful, you can view the Azure Benefits status. Check the cluster property **IMDS Attestation** by running the following command:

   ```powershell
   Get-AzureStackHCI
   ```

   Or, to view Azure Benefits status for servers, run the following command:

   ```powershell
   Get-AzureStackHCIAttestation [[-ComputerName] <string>]
   ```

3. To check access to Azure Benefits for VMs, run the following command:

   ```powershell
   Get-AzStackHCIVMAttestation
   ```

## [Azure portal](#tab/azureportal)
1. In your Azure Stack HCI cluster resource page, navigate to the **Configuration** tab.
2. Under the feature **Enable Azure Benefits**, view the host attestation status:

   :::image type="content" source="media/azure-benefits/attestation-status.png" alt-text="Screenshot of Azure Benefit Attestation status.":::

## [Azure CLI](#tab/azurecli)

Azure CLI is available to install in Windows, macOS and Linux environments. It can also be run in [Azure Cloud Shell](https://shell.azure.com/). This document details how to use Bash in Azure Cloud Shell. For more information, refer [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Azure CLI to configure Azure Benefits following these steps:

1. Set up parameters from your subscription, resource group, and cluster name
    ```azurecli
    subscription="00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
    resourceGroup="hcicluster-rg" # Replace with your resource group name
    clusterName="HCICluster" # Replace with your cluster name

    az account set --subscription "${subscription}"
    ```

1. To view Azure Benefits status on a cluster, run the following command:
    ```azurecli    
    az stack-hci cluster list \
    --resource-group "${resourceGroup}" \
    --query "[?name=='${clusterName}'].{Name:name, AzureBenefitsHostAttestation:reportedProperties.imdsAttestation}" \
    -o table
    ```

---

### Manage access to Azure Benefits for your VMs - Windows Admin Center

To turn on Azure Benefits for VMs, select the **VMs** tab, then select the VM(s) in the top table **VMs without Azure Benefits**, and then select **Turn on Azure Benefits for VMs.**

:::image type="content" source="media/azure-benefits/manage-benefits-2.gif" alt-text="Screenshot of Azure Benefits for VMs.":::

### Manage access to Azure Benefits for your VMs - Azure PowerShell

- To turn on benefits for selected VMs, run the following command on your Azure Stack HCI cluster:

   ```powershell
   Add-AzStackHCIVMAttestation [-VMName]
   ```

  Or, to add all existing VMs, run the following command:

   ```powershell
   Add-AzStackHCIVMAttestation -AddAll
   ```
- Optionally, to check that the VMs can access Azure Benefits on the host, run the following command on the VM:

  ```powershell
  Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.253:80/metadata/attested/document?api-version=2018-10-01"
  ```

### Troubleshoot via Windows Admin Center

- To turn off and reset Azure Benefits on your cluster:
  - On the **Cluster** tab, select **Turn off Azure Benefits**.
- To remove access to Azure Benefits for VMs:
  - On the **VM** tab, select the VM(s) in the top table **VMs without Azure Benefits**, and then select **Turn on Azure Benefits for VMs**.
- Under the **Cluster** tab, one or more servers appear as **Expired**:
  - If Azure Benefits for one or more servers has not synced with Azure for more than 30 days, it appears as **Expired** or **Inactive**. Select **Sync with Azure** to schedule a manual sync.
- Under the **VM** tab, host server benefits appear as **Unknown** or **Inactive**:
  - You will not be able to add or remove Azure Benefits for VMs on these host servers. Go to the **Cluster** tab to fix Azure Benefits for host servers with errors, then try and manage VMs again.

### Troubleshoot via PowerShell

- To turn off and reset Azure Benefits on your cluster, run the following command:

  ```powershell
  Disable-AzStackHCIAttestation -RemoveVM
  ```

- To remove access to Azure Benefits for selected VMs:

  ```powershell
  Remove-AzStackHCIVMAttestation -VMName <string>
  ```

  Or, to remove access for all existing VMs:

  ```powershell
  Remove-AzStackHCIVMAttestation -RemoveAll
  ```

- If Azure Benefits for one or more servers is not yet synced and renewed with Azure, it may appear as **Expired** or **Inactive**. Schedule a manual sync:

  ```powershell
  Sync-AzureStackHCI
  ```

- If a server is newly added and has not yet been set up with Azure Benefits, it may appear as **Inactive**. To add the new server, run setup again:

  ```powershell
  Enable-AzStackHCIAttestation
  ```

## FAQ

This FAQ provides answers to some questions about using Azure Benefits.

### What Azure-exclusive workloads can I enable with Azure Benefits?

See the [full list here](#azure-benefits-available-on-azure-stack-hci).

### Does it cost anything to turn on Azure Benefits?

No, turning on Azure Benefits incurs no extra fees.

### Can I use Azure Benefits on environments other than Azure Stack HCI?

No, Azure Benefits is a feature built into the Azure Stack HCI OS, and can only be used on Azure Stack HCI.

### I have just set up Azure Benefits on my cluster. How do I ensure that Azure Benefits stays active?

- In most cases, there is no user action required. Azure Stack HCI automatically renews Azure Benefits when it syncs with Azure.
- However, if the cluster disconnects for more than 30 days and Azure Benefits shows as **Expired**, you can manually sync using PowerShell and Windows Admin Center. For more information, see [syncing Azure Stack HCI](../faq.yml#what-happens-if-the-30-day-limit-is-exceeded).

### What happens when I deploy new VMs, or delete VMs?

- When you deploy new VMs that require Azure Benefits, you can manually add new VMs to access Azure Benefits using Windows Admin Center or PowerShell, using the preceding instructions.
- You can still delete and migrate VMs as usual. The NIC **AZSHCI_GUEST-IMDS_DO_NOT_MODIFY** will still exist on the VM after migration. To clean up the NIC before migration, you can remove VMs from Azure Benefits using Windows Admin Center or PowerShell using the preceding instructions, or you can migrate first and manually delete NICs afterwards.

### What happens when I add or remove servers?

- When you add a server, you can navigate to the **Azure Benefits** page in Windows Admin Center, and a banner will appear with a link to **Enable inactive server**.
- Or, you can run `Enable-AzStackHCIAttestation [[-ComputerName] <String>]` in PowerShell.
- You can still delete servers or remove them from the cluster as usual. The vSwitch **AZSHCI_HOST-IMDS_DO_NOT_MODIFY** will still exist on the server after removal from the cluster. You can leave it if you are planning to add the server back to the cluster later, or you can remove it manually.

## Next steps

- [Extended security updates (ESU) on Azure Stack HCI](azure-benefits-esu.md)
- [Azure Stack HCI overview](../overview.md)
- [Azure Stack HCI FAQ](../faq.yml)
