---
title: Azure Benefits on Azure Stack HCI
description: This topic explains the Azure Benefits feature on Azure Stack HCI.
author: jelei
ms.author: jelei
ms.topic: conceptual
ms.date: 12/13/2021
---

# Azure Benefits on Azure Stack HCI

>Applies to Azure Stack HCI, version 21H2 and later

Microsoft Azure offers a range of different workloads and capabilities. The goal with Azure Stack HCI is to extend many of the same benefits you get from Azure, while running on the same familiar and high-performance on-premises or edge environments.

*Azure Benefits*, a recommended but optional feature in Azure Stack HCI, makes it possible for supported Azure-exclusive workloads to work outside of the cloud. Customers can enable Azure Benefits on Azure Stack HCI at no additional cost.

## Supported workloads with Azure Benefits

Turning on Azure Benefits enables you to use these Azure-exclusive workloads on Azure Stack HCI:

|     Workload                                      |     Versions supported                                |     What it is |                                                                                                                                                                    |
|---------------------------------------------------|-------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     Windows Server Datacenter: Azure Edition    |     2022 edition or later                           |     An Azure-only guest operating system that includes all the latest Windows Server innovations and additional exclusive features. <br/> Learn more: [Automanage for Windows Server](/azure/automanage/automanage-windows-server-services-overview)|                                                                                                     |
|     Extended Security Update (ESUs)             |     October 12th, 2021 security updates or later    |     A program that allows customers to continue to get security updates for End-of-Support SQL Server and Windows Server VMs, now free when running on Azure Stack HCI. <br/> Learn more: [Extended Security Updates for SQL Server and Windows Server 2008 and 2008 R2](https://www.microsoft.com/windows-server/extended-security-updates)   |
|     Azure Policy guest configuration            |     Arc agent version 1.13 or later                 |     A feature that can audit or configure OS settings as code, for both host and   guest machines. <br/> Learn more: [Understand the guest configuration feature of Azure Policy](/azure/governance/policy/concepts/guest-configuration) |

## Technical concepts

Azure Benefits is a built-in platform attestation service on Azure Stack HCI, and helps to provide guarantees that VMs are indeed running on Azure environments.

This is modeled after the same [IMDS Attestation](/azure/virtual-machines/windows/instance-metadata-service?tabs=windows#attested-data) service that runs in Azure, in order to enable some of the same workloads and benefits available to customers in Azure. Azure Benefits returns an almost identical payload; the main difference is that because it is running on Azure Stack HCI, it guarantees that the VM is in Azure Stack HCI.

:::image type="content" source="media/azure-benefits/cluster.png" alt-text="Architecture":::

Turning on Azure Benefits starts the service running on your Azure Stack HCI cluster:

- On every server, HciSvc obtains a certificate from Azure, and securely stores it within an enclave on the server.

   > [!NOTE]
   > Certificates are renewed every time the Azure Stack HCI cluster syncs with Azure, and each renewal is valid for 30 days. As long as you maintain the usual 30 day connectivity requirements for Azure Stack HCI, no user action is required.

- HciSvc exposes a private and non-routable REST endpoint, accessible only to VMs on the same server. To enable this endpoint, an internal vSwitch is configured on the AzureStack HCI host (named **AZSHCI_HOST-IMDS_DO_NOT_MODIFY**). VMs then must have a NIC configured and attached to the same vSwitch (**AZSHCI_GUEST-IMDS_DO_NOT_MODIFY**).

   > [!NOTE]
   > Modifying or deleting this switch and NIC prevents Azure Benefits from working properly. If errors occur, disable Azure Benefits using Windows Admin Center or the PowerShell instructions that follow, and then try again.

- Consumer workloads (for example, Windows Server Azure Edition guests) requests attestation. HciSvc then signs the response with an Azure certificate.

   > [!NOTE]
   > You can manually enable access for each VM that needs Azure Benefits.

## Enable Azure Benefits

Before you begin, you need the following prerequisites:

- An Azure Stack HCI cluster:
  - [Install updates](../manage/update-cluster.md): Version 21H2, with at least the December 14, 2021 security update KB5008210 or later.
  - [Register Azure Stack HCI](../deploy/register-with-azure.md#register-a-cluster-using-windows-admin-center): All servers must be online and registered to Azure.
  - [Install Hyper-V and RSAT-Hyper-V-Tools](/windows-server/virtualization/hyper-v/get-started/install-the-hyper-v-role-on-windows-server).

- If you are using Windows Admin Center:
  - Windows Admin Center (version 2103 or later) with Cluster Manager extension (version 2.41.0 or later).

### Turn on Azure Benefits using Windows Admin Center

#### Manage Azure Benefits for your cluster - Windows Admin Center

1. In Windows Admin Center, select Cluster Manager from the top drop-down arrow, navigate to the cluster that you want to activate,
then under Settings, select **Azure Benefits**.

2. In the **Azure benefits** pane, select **Turn on** and then select **Turn on** again. It may take a few minutes for servers to reflect the changes.

3. When Azure Benefits setup is successful, the page updates to show the Azure Benefits dashboard.
   1. Check that cluster-wide Azure Benefits is turned on: **Azure benefits cluster status** appears as **On**.
   2. For each server, check that: Under the **Cluster** tab in the dashboard, check that Azure Benefits for every server shows as **Active** in the table.

##### Troubleshooting - Windows Admin Center

- To turn off Azure Benefits for the cluster, under the **Cluster** tab, click **Turn off Azure Benefits**.
- If Azure Benefits for one or more servers is not yet synced with Azure, it may appear as **Expired** or **Inactive**. Click **Sync with Azure** to schedule a manual sync.
- If a node is newly added and has not yet been set up with Azure Benefits, it may appear as **Inactive**. To add the new node, run setup again.

#### Manage access to Azure Benefits for your VMs

- By default, the checkbox to **Turn on for all existing VMs** is selected during initial Azure Benefits setup. You can add all VMs now, or deselect during setup and manually add VMs later.
- When Azure Benefits setup is successful, the page updates to show the Azure Benefits dashboard.
  - Check the status for **VMs with Azure Benefits turned on**. It's recommended that all of your existing VMs have Azure Benefits turned on; for example, **3 out of 3 VMs**.
- To turn on Azure Benefits for VMs, click the **VMs** tab, select the VM(s) in the top table **VMs without Azure Benefits,** and then click **Turn on Azure Benefits for VMs.**

##### Troubleshooting

- To turn off Azure Benefits for VMs, under the **VMs** tab, select the VM(s) in the bottom table **VMs with Azure Benefits,** then click **Turn off Azure Benefits for VMs.**
- If the host server benefits show up as **Unknown** or **Inactive**, you will see an error when managing Azure benefits for VMs on these host servers. Go to the **Cluster** tab to fix Azure Benefits for erroring host servers, then try and manage VMs again.

### Turn on Azure Benefits using PowerShell

#### Manage Azure Benefits for your cluster - PowerShell

- From an elevated PowerShell window on your Azure Stack HCI cluster, run the following command:

  ```powershell
  Enable-AzStackHCIAttestation
  ```

- If you want to add all existing VMs on setup, you can run the following command:

  ```powershell
  Enable-AzStackHCIAttestation -AddVM
  ```

- To view Azure Benefits status for your cluster under the property **IMDS Attestation**, run the following command:

  ```powershell
  Get-AzureStackHCI
  ```

- To view Azure Benefits status for servers, run the following command:

  ```powershell
  Get-AzureStackHCIAttestation [[-ComputerName] <string>]
  ```

##### Troubleshooting - PowerShell

- To turn off and reset Azure benefits on your cluster, run the following command:

  ```powershell
  Disable-AzStackHCIAttestation -RemoveVM
  ```

- If Azure Benefits for one or more servers is not yet synced and renewed with Azure, it may appear as **Expired** or **Inactive**. Schedule a manual sync:

  ```powershell
  Sync-AzureStackHCI
  ```

- If a node is newly added and has not yet been set up with Azure Benefits, it may appear as **Inactive**. To add the new node, run setup again:

  ```powershell
  Enable-AzStackHCIAttestation
  ```

#### Manage access to host Azure benefits for your VMs

- To turn on benefits for selected VMs, run the following command on your Azure Stack HCI cluster:

  ```powershell
  Add-AzStackHCIVMAttestation [-VMName]
  ```

- To add all existing VMs, run the following command:

  ```powershell
  Add-AzStackHCIAttestation -AddAll
  ```

- To remove access to Azure Benefits for selected VMs:

  ```powershell
  Remove-AzStackHCIVMAttestation [-VMName]
  ```

- To remove access for all existing VMs:

  ```powershell
  Remove-AzStackHCIVMAttestation -RemoveAll
  ```

- To view Azure Benefits access for your VMs:

  ```powershell
  Get-AzStackHCIVMAttestation
  ```

### View only using portal

1. In your Azure Stack HCI cluster resource page, navigate to the **Configuration** tab.
2. Under the feature **Enable Azure benefits**, view the host attestation status:

   :::image type="content" source="media/azure-benefits/attestation-status.png" alt-text="Attestation status":::

## FAQ

This FAQ provides answers to some questions about using Azure Benefits.

### What Azure-exclusive workloads can I enable with Azure Benefits?

See the [full list here](#supported-workloads-with-azure-benefits).

### Does it cost anything to turn on Azure Benefits?

No, turning on Azure Benefits comes with no additional fees.

### Can I use Azure Benefits on environments other than Azure Stack HCI?

No, Azure Benefits is a feature built into the Azure Stack HCI OS, and can only be used on Azure Stack HCI.

### I have just set up Azure Benefits on my cluster. How do I ensure that Azure Benefits stays active?

- In most cases, there is no user action required. Azure Stack HCI automatically renews Azure Benefits during its syncs with Azure. In general, Azure Stack HCI needs to sync with Azure at least once every 30 days, so that not only Azure Benefits, but other services can continue to work.
- However, if the cluster disconnects for more than 30 days and Azure Benefits shows as **Expired**, you can manually sync using PowerShell and Windows Admin Center. For more information, see [syncing Azure Stack HCI](../faq.yml#what-happens-if-the-30-day-limit-is-exceeded).

### What happens when I deploy new VMs, or delete VMs?

- When you deploy new VMs that require Azure Benefits, you can manually add new VMs to access Azure Benefits using Windows Admin Center or PowerShell, using the preceding instructions.
- You can still delete and migrate VMs as usual. The NIC **AZSHCI_GUEST-IMDS_DO_NOT_MODIFY* will still exist on the VM after migration. To clean up the NIC before migration, you can remove VMs from Azure Benefits using Windows Admin Center or PowerShell using the preceding instructions, or you can migrate first and manually delete NICs afterwards.

### What happens when I add or remove servers?

When you add a server, you can either:

- Navigate to the **Azure Benefits** page in Windows Admin Center, and a banner will appear with a link to **Enable inactive server**.
- Or, you can run `Enable-AzStackHCIAttestation [[-ComputerName] <String>]` in PowerShell.
- You can still delete servers or remove them from the cluster as usual. The vSwitch **AZSHCI_HOST-IMDS_DO_NOT_MODIFY** will still exist on the server after removal from the cluster. You can leave it if you are planning to add the server back to the cluster later, or you can remove it manually.
