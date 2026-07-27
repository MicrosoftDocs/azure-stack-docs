---
title: Create and Connect to an Azure Local Confidential VM (Preview)
description: Learn how to create a confidential VM (CVM) on Azure Local by using the Azure portal or Azure CLI, and how to connect to the VM to verify attestation.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.date: 07/27/2026
ms.custom:
  - devx-track-azurecli
ms.subservice: hyperconverged
---

# Create and connect to an Azure Local confidential VM (preview)

::: moniker range=">=azloc-2607"

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create a confidential VM (CVM) on Azure Local by using the Azure portal or the Azure CLI, and how to connect to the CVM after it's deployed. Confidential VMs use an integrity-protected VM image and stronger isolation guarantees than a standard VM.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

- An Azure Local cluster deployed with the `confidentialVmIntent` parameter set to `Enable` in the ARM deployment template (API version `2026-04-01-preview`).
- The Azure Stack HCI VM extension, version 1.12.0 or later.
- A prepared integrity-protected VHDX image uploaded to the cluster.

## Create a confidential VM

# [Azure portal](#tab/azureportal)

Use the Azure portal to create a CVM interactively, with guided prompts for security and image settings.

1. In the Azure portal, go to your Azure Local cluster and select **Virtual machines** > **+ Create VM**. The **Basics** tab opens.

    :::image type="content" source="./media/create-connect-confidential-vm/basics-tab.png" alt-text="Screenshot of the Basics tab in the Create an Azure Arc virtual machine wizard." lightbox="./media/create-connect-confidential-vm/basics-tab.png":::

1. Under **Security type**, select **Confidential virtual machines**. This option appears only if the target custom location supports CVM.

    :::image type="content" source="./media/create-connect-confidential-vm/instance-details.png" alt-text="Screenshot of the Instance details pane." lightbox="./media/create-connect-confidential-vm/instance-details.png":::

1. Configure the security features.

     <!-- TODO: PM to confirm the name of the tool/process used to generate these images, then replace the generic phrasing below. -->
     > [!IMPORTANT]
     > Integrity-protected images that you generate yourself aren't signed images. If you use one of these images, you must uncheck **Enable Secure boot**.

   - **Enable Secure boot** is selected by default.

   - **Enable vTPM** is on by default, and you can't change it.

    :::image type="content" source="./media/create-connect-confidential-vm/enable-secure-boot.png" alt-text="Screenshot of the Enable secure boot security feature." lightbox="./media/create-connect-confidential-vm/enable-secure-boot.png":::

1. Select the VM image. You can run any supported virtual machine disk image. However, if the disk image wasn't specifically designed for confidential VMs, the VM doesn't benefit from the extra OS-level hardening and protections.

   > [!NOTE]
   > Your image should appear in the downloaded customer-managed images.

    :::image type="content" source="./media/create-connect-confidential-vm/download-customer-image.png" alt-text="Screenshot of the downloaded customer-managed images option." lightbox="./media/create-connect-confidential-vm/download-customer-image.png":::

    :::image type="content" source="./media/create-connect-confidential-vm/customer-image.png" alt-text="Screenshot of a chosen customer managed image." lightbox="./media/create-connect-confidential-vm/customer-image.png":::

1. Configure disk encryption and security settings. **Attach GPU** is disabled and **Guest management** is unchecked by default. Allow users to opt in by selecting the checkbox, if needed.

    > [!IMPORTANT]
    > If you're using an integrity-protected CVM image, don't opt in to **Guest management**. Guest management doesn't work with integrity-protected CVM images.

1. Configure the administrator account. To securely provision a root user for your CVM, create the CVM image as described in the CVM image creation guide.

    :::image type="content" source="./media/create-connect-confidential-vm/root-user.png" alt-text="Screenshot of setting up a root user for your confidential virtual machine." lightbox="./media/create-connect-confidential-vm/root-user.png":::

1. Make sure you add a network interface in the **Networking** tab while creating an Azure Arc virtual machine.

    > [!NOTE]
    > After the initial boot of a CVM, you can't add network interfaces if you're using an integrity-protected CVM image.

1. Select **Review + create**. Verify all settings, and then select **Create** to deploy the confidential VM.

    :::image type="content" source="./media/create-connect-confidential-vm/create-vm.png" alt-text="Screenshot of the review and create your virtual machine pane." lightbox="./media/create-connect-confidential-vm/create-vm.png":::


### Verify deployment (Azure portal)

Go to your cluster > **Virtual machines** and verify that your CVM is running and shows **Security properties** on the **Overview** tab. Confirm that the CVM properties show `ConfidentialVmStatus: [Enabled]` in the cluster JSON view (using API version `2026-04-01-preview`).

> [!NOTE]
> Use attestation to verify the deployment status of your CVM. Attestation is the only reliable way to confirm a CVM's security state.

:::image type="content" source="./media/create-connect-confidential-vm/verify-deployment.png" alt-text="Screenshot of your completed CVM deployment." lightbox="./media/create-connect-confidential-vm/verify-deployment.png":::


# [Azure CLI](#tab/azurecli)

Use the Azure CLI to create a CVM programmatically, with explicit values for each CVM-specific security flag.

### Step 1: Create the network interface

Create the network interface as described in [Create network interfaces for Azure Local VMs enabled by Azure Arc](create-network-interfaces.md), following the same guidelines as for a standard VM.

### Step 2: Create the virtual machine

Set the following variables, and then create the virtual machine. The highlighted parameters are the ones you need to set up a CVM.

```azurecli
$Subscription = '...'   # Your Azure subscription ID.
$ResourceGroup = '...'  # The resource group containing your Azure Local instance.
$CustomLocation = '...' # The custom location ID associated with your Azure Local instance.
$Location = '...'       # The Azure region of your resource group, for example "eastus".
$NicName = '...'        # The name of an existing network interface on your Azure Local instance.
$AliasTag = '...'       # Your alias, used to tag the VM for tracking ownership.
$VmName = '...' # Use this format: ldn-<alias>-vm-01 (for example, ldn-johndoe-vm-01).
$ImageName = '...' # The name of the integrity-protected image uploaded to the cluster.

az stack-hci-vm create --subscription $Subscription --resource-group $ResourceGroup --custom-location $CustomLocation --location $Location --hardware-profile vm-size="Custom" processors=4 memory-mb=2048 --computer-name $VmName --name $VmName --image $ImageName --enable-agent false --enable-vtpm true --enable-vm-config-agent false --enable-secure-boot false --security-type "ConfidentialVM" --nics $NicName --tags "IsConfidentialVM=True CreatedBy=$AliasTag" --admin-username "admin" --admin-password "NOT_USED" --osdisk-encryption-type "NonPersistedTPM"
```

The following table explains why each highlighted parameter matters:

| Parameter | Reason |
|---|---|
| `--enable-agent false` and `--enable-vm-config-agent false` | Both parameters must be `false` because they enable guest management. If you set them to `true`, using the integrity scripts can lead to failures and timeouts. |
| `--enable-vtpm true` | Required for attestation. |
| `--enable-secure-boot false` | Required because you're using your own locally created image. Validation is done through PCR 4 and PCR 11. |
| `--security-type "ConfidentialVM"` | Sets the VM's security type to `Confidential virtual machine`. |
| `--osdisk-encryption-type "NonPersistedTPM"` | Ensures the VM is a stateless CVM. |

### Step 3: Verify deployment (Azure CLI)

Go to your cluster > **Virtual machines**. Verify that your VM is running.

:::image type="content" source="./media/create-connect-confidential-vm/vm-status-run.png" alt-text="Screenshot of your virtual machine in a running status." lightbox="./media/create-connect-confidential-vm/vm-status-run.png":::

---

## Connect to the confidential VM

There's no guest management on a confidential VM, and the Hyper-V Connect console is blocked because of the CVM security type. Instead, connect directly to the CVM's IP address (you must be on the same network) by using the username, SSH key, or password that you configured when you built the OS disk image.

### Connect using SSH

Open PowerShell. You don't need administrator access. Then, connect to the virtual machine:

```powershell
$KeyPath = '...'     # Example: C:\Users\johndoe\.ssh\cvmkey
$IpAddress = '...'   # The CVM's IP address on your local network
$UserName = '...'    # The username specified during image build

ssh -i $KeyPath "$UserName@$IpAddress"
```

### Get the attestation endpoint

Get the Microsoft Azure Attestation (MAA) endpoint URL:

```powershell
$cluster = (az stack-hci cluster show --resource-group $ResourceGroup --name <cluster name>) | ConvertFrom-Json
$endpoint = $cluster.isolatedVmAttestationConfiguration.attestationServiceEndpoint
```

## Related content

- [Create Azure Local virtual machines enabled by Azure Arc](create-arc-virtual-machines.md)
- [What is Trusted launch for Azure Local VMs?](trusted-launch-vm-overview.md)
- [Connect to an Azure Local VM using SSH, RDP over SSH, or VM Connect (preview)](connect-arc-vm-using-ssh.md)

::: moniker-end

::: moniker range="<=azloc-2606"

This feature is available only in Azure Local 2607 or later.

::: moniker-end

