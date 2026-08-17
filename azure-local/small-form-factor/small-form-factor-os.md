---
title: Manage the operating system on a small form factor deployment of Azure Local (preview)
description: Learn how to reset and install the operating system on a provisioned machine (preview).
author: rcheeran
ms.topic: how-to
ms.date: 08/04/2026
ms.author: rcheeran
ms.service: azure-local
ms.subservice: small-form-factor
---

# Operating system management for small form factor deployments of Azure Local (preview)

This article describes how to reset and reinstall the operating system on a small form factor deployment of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Reset OS

Reset the operating system to return the machine to a known-good state after configuration problems, operating system issues, or an unsuccessful deployment. Resetting removes the installed operating system and returns the machine to the maintenance environment. The network and security configuration is preserved.

> [!WARNING]
> Resetting the operating system removes local data from the installed operating system. Back up any data that you need before you continue.

1. In the Azure portal, go to the provisioned machine resource. From the left navigation, select **Operating system**.

      :::image type="content" source="media/small-form-factor-reset-os-option.png" alt-text="Screenshot showing the reset OS option on the Operating System page." border="true" lightbox="media/small-form-factor-reset-os-option.png":::

1. Select **Reset operating system**, and then select **Reset**.

1. The reset operation downloads the maintenance environment, restarts the machine, and removes the installed operating system.

1. On the **Operating system** page, monitor the reset operation.

      :::image type="content" source="media/small-form-factor-reset-inprogress.png" alt-text="Screenshot showing the reset operation in progress on the Operating System page." border="true" lightbox="media/small-form-factor-reset-inprogress.png":::

1. When the reset operation completes, the machine is running the maintenance environment. To reinstall the operating system, continue with the next section.

## Install OS

After the provisioned machine enters the maintenance environment, install the operating system to start with a clean configuration.

1. In the Azure portal, go to the provisioned machine resource. From the left navigation, select **Operating system**. Verify that the page indicates the machine is in the maintenance environment.

      :::image type="content" source="media/small-form-factor-install-os.png" alt-text="Screenshot showing the Install OS option on the Operating System page." border="true" lightbox="media/small-form-factor-install-os.png":::

1. Select **Install OS**.

1. Select the target OS image.

      :::image type="content" source="media/small-form-factor-install-os-page.png" alt-text="Screenshot showing the Install OS page with operating system image, network configuration, and SSH public key settings." border="true" lightbox="media/small-form-factor-install-os-page.png":::

1. The installation operation downloads and installs the selected OS image. To monitor its status, select **View details** on the **Operating system** page.

1. The network and security settings from the previous OS installation are applied to the new OS installation.

1. When the OS installation completes, the machine is ready for your workloads.

## Next steps

- [Run containerized workloads](small-form-factor-containerized-workloads.md).
