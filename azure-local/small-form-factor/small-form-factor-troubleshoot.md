---
title: Troubleshoot management and connectivity
description: Learn how to troubleshoot management and connectivity issues for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 10/28/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Troubleshoot management and connectivity

This article describes how to troubleshoot management and connectivity issues for small form factor deployments of Azure Local.

For USB installation issues, see [Troubleshoot USB installation](small-form-factor-troubleshoot-usb-installation.md).

For VM setup issues, see [Troubleshoot VM setup](small-form-factor-troubleshoot-vm-setup.md).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Collect a support package from the app

A log package is composed of all the relevant logs that can help Microsoft Support troubleshoot any device issues. You can generate a log package via the local web UI. Follow these steps to collect a support package from the app:

1. Select the help icon in the top-right corner of the app to open **Support + troubleshooting**.

1. Select **Create** to begin support package collection. The package collection could take several minutes.

1. After the support package is created, select **Download**. A zipped package is downloaded on your local system. You can unzip the package and view the system log files.

## SSH login prompts for a password when using a `.pem` file

**Problem**:

When connecting to a provisioned machine over SSH using a `.pem` file, the connection prompts for a password instead of signing in automatically.

For example:

```bash
ssh -i mykey.pem clouduser@<ip-address>
```

Instead of connecting successfully, SSH prompts:

```text
clouduser@<ip-address>'s password:
```

**Cause**:

The `clouduser` account doesn't have a password configured.

If SSH prompts for a password, it means the `.pem` key authentication failed and SSH is falling back to password authentication.

The most common causes are:

- The wrong `.pem` file is being used. For example, using:
  - A `.pem` file downloaded for a different device.
  - The wrong .pem file is being used for the target device.
- The `.pem` file permissions weren't restricted with `chmod 600`.

If the file permissions are too open, SSH rejects the key for security reasons.

**Recommendation**:

1. Verify that you're using the correct `.pem` file downloaded from the Azure portal for the specific device you're connecting to.

1. Confirm that the key file permissions are configured correctly.
    1. On Linux, restrict the key permissions with:

    ```bash
    chmod 600 <your-key>.pem
    ```

    1. On Windows, you can restrict the key permissions using:

    ```powershell
    icacls <your-key>.pem /inheritance:r
    icacls <your-key>.pem /grant:r "%username%":R
    ```

1. Then retry the SSH connection.

1. If the issue persists, run the Azure Arc SSH command with verbose logging enabled to view detailed authentication errors:

    ```bash
    az ssh arc --verbose
    ```

1. Review the verbose output for key authentication failures, permission issues, or mismatched key errors.

## Reattempt failed Azure Linux OS provisioning

**Problem**:

OS provisioning fails for a small form factor deployment, leaving the Edge machine in a **Transitioning** state and preventing the deployment from progressing. This problem commonly occurs during the **InstallExtensions** phase when the **LinuxEdgeObservability** extension fails to install on either the Edge machine or the target Arc machine. As a result, the overall deployment is marked as failed and no further provisioning operations are performed.

Typical symptoms include:

- Deployment status shows **Failed**.
- Edge machine remains in **Transitioning** state.
- ProvisionOS operations can't continue.
- Extension installation failures are reported, often referencing **LinuxEdgeObservability**.
- Standard recovery guidance recommends restarting deployment from the beginning.

**Cause**:

This problem occurs when extension installation fails during the target OS provisioning workflow. The provisioning service marks the Edge Machine as failed while still in the **Transitioning** state and doesn't continue with subsequent deployment steps. In earlier releases, recovery options were limited and often required a complete redeployment.

**Recommendation**:

When the failure occurs during target OS provisioning, try manually resubmitting the ProvisionOS job before performing a full redeployment.

- To resubmit the ProvisionOS job, download and run the [`troubleshoot-os-provisioning-failure.sh`](https://github.com/Azure-Samples/AzureLocal/blob/main/small-form-factor/troubleshoot-os-provisioning-failure.sh) script. Replace the `<subscription-id>`, `<resource-group>`, and `<edge-machine-name>` placeholders in the input parameters section with your actual values.

**Known limitations**:

- This recovery mechanism is intended for target OS provisioning failures.
- Failures occurring during ROE extension installation might still require more disruptive recovery actions, including redeployment.
- Retry and rollback capabilities aren't currently available for every provisioning stage.
