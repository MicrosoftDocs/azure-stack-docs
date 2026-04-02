---
title: Troubleshoot Simplified Machine Provisioning for Azure Local (preview)
description: Learn how to troubleshoot simplified machine provisioning for Azure Local (preview).
ms.author: alkohli
author: alkohli
ms.reviewer: alkohli
ms.topic: how-to
ms.date: 04/01/2026
ms.subservice: hyperconverged
---

# Troubleshoot simplified machine provisioning for hyperconverged deployments of Azure Local (preview)

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

This article describes how to troubleshoot simplified machine provisioning. You can use the following methods to troubleshoot:

- Run diagnostic tests.
- Collect a support package.
- Collect logs from your Azure subscription.

## Run diagnostic tests from the Configurator app

To diagnose and troubleshoot any device issues related to hardware, time server, and network, you can run the diagnostics tests. Follow these steps to run the diagnostic tests from the app:

1. Select the help icon in the top-right corner of the app to open **Support + troubleshooting**.

1. Select **Run diagnostic tests**. The diagnostic tests check the health of the server hardware, time server, and the network connectivity. The tests also check the status of the Azure Arc agent and the extensions.

1. After the tests are completed, the results are displayed. Resolve the issues and retry the operation.

## Collect a support package from the app

A log package is composed of all the relevant logs that can help Microsoft Support troubleshoot any device issues. You can generate a log package via the local web UI. Follow these steps to collect a support package from the app:

1. Select the help icon in the top-right corner of the app to open **Support + troubleshooting**.

1. Select **Create** to begin support package collection. The package collection could take several minutes.

1. After the support package is created, select **Download**. A zipped package is downloaded on your local system. You can unzip the package and view the system log files.

## Collect logs from your Azure subscription

If you can't access the machine using the Configurator app, you can get the app logs from the server. Access the logs by connecting with PowerShell.

The logs are stored in the following locations:

| Target operating system | Log files |
|--|--|
| Azure Stack HCI | `C:\Windows\System32\Bootstrap\Logs` |
| Maintenance environment | `/var/log/bootstrap`<br>`/var/log/provisioningextension`<br>`/var/log/trident-full.log`<br>`/var/log/messages`<br>`/var/log/bootstraprestservice` |

## USB boot loop issue with maintenance environment

**Problem:** The USB boot enters an infinite USB boot sequence if the BIOS Settings `Boot USB Devices First` is set on the machine.

**Cause:**

When the BIOS setting `Boot USB Devices First` is enabled on the machine, the system enters an infinite USB boot cycle. This setting overrides the configured boot order and always prioritizes booting from any connected USB device. As a result, even after the maintenance environment is successfully installed, subsequent reboots continue to boot from the USB media instead of the internal disk.

This behavior causes a continuous boot loop in which the device repeatedly:

1. Boots from the USB device.
1. Reinstalls the maintenance environment.
1. Reboots.

From the customer’s perspective, the device appears to be in an infinite cycle of installation and reboot, which occurs approximately every 10 minutes.

**Recommendation:**

You only need to boot from a USB device once to install the maintenance environment. After that, you should configure the machine to boot from the internal disk. For more information, see [Prepare machines](simplified-machine-provisioning.md#step-2-prepare-machines). For instructions on accessing the boot menu or changing the boot order for your machine, check the documentation that came with your machine or go to the manufacturer's website.

## Operating system image drop down is empty

**Problem:** In Azure portal, select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. In the **Provision new machines** page, the **Operating system** > **Image** drop down is empty.

:::image type="content" source="media/simplified-machine-provisioning/troubleshooting-initial-creation-failure-1.png" alt-text="Screenshot 1 showing an empty Image Url drop down." border="false" lightbox="media/simplified-machine-provisioning/troubleshooting-initial-creation-failure-1.png":::

**Cause:** The resource provider registration for `Microsoft.AzureStackHCI` is missing.

**Recommendation:** Register the resource provider as described in the [prerequisites](simplified-machine-provisioning.md#azure-prerequisites).

## When you provision new machines, ARM template validation fails

**Problem:** In Azure portal, select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. In the **Provision new machines** page, when you select **Create**, you see the error messages `Arm template validation failed` and `Deployment template validation failed: 'The value for the template parameter 'hciRPServiceprincipalID' at line '1' and column '10174' is not provided. Please see https://aka.ms/arm-create-parameter-file for usage details.'. (Code: InvalidTemplate)`

:::image type="content" source="media/simplified-machine-provisioning/troubleshooting-initial-creation-failure-2.png" alt-text="Screenshot showing a failed ARM template validation." border="false" lightbox="media/simplified-machine-provisioning/troubleshooting-initial-creation-failure-2.png":::

**Cause:** This issue can happen if you're using Azure Stack HCI for the first time in this subscription.

**Recommendation:**

1. Delete the provisioned machine. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Provisioned machines**. Select the machine and then select **Delete**.

1. Wait 15 minutes.

1. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. Upload the voucher and provision the machine again. For more information, see [Provision machines from Azure](simplified-machine-provisioning.md#step-3-provision-machines-from-azure).

## When you provision new machines, you receive an internal server error

**Problem:** In Azure portal, select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. In the **Provision new machines** page, when you select **Create**, you see the error messages `The resource write operation failed to complete successfully, because it reached terminal provisioning state 'Failed'.` and `Failed to verify creation of MoboBroker resource. (Code: InternalServerError)`

:::image type="content" source="media/simplified-machine-provisioning/troubleshooting-initial-creation-failure-3.png" alt-text="Screenshot showing an internal server error on site default." border="false" lightbox="media/simplified-machine-provisioning/troubleshooting-initial-creation-failure-3.png":::

**Causes:** Your administrator has set up an [Azure Policy](/azure/governance/policy/overview) that includes one or more of the following requirements:

- Resource groups must be created in a specific region. In this preview release, only the `eastus` region supports simplified machine provisioning.

- Resource groups must be created using a specific naming convention.

- Resources must have [Azure Resource Manager tags](/azure/azure-resource-manager/management/tag-resources). Simplified machine provisioning doesn't currently support this requirement.

**Recommendations:**

1. In Azure portal, browse to the resource group where you're trying to provision new machines and select **Monitor** > **Activity log**. You can use the activity log to investigate the provisioning error and determine which Azure Policy is restricting resource creation. For more information, see [Activity log in Azure Monitor](/azure/azure-monitor/platform/activity-log).

1. Add an [Azure Policy exemption](/azure/governance/policy/concepts/exemption-structure) for the policy that conflicts with simplified machine provisioning.

1. If the error is due to the name of the Managed Resource Group (MRG), you can resolve it by setting the MRG name during the provisioning. After you select the site, select **Configure** and then set the MRG name to adhere to the customer's Azure Policy. In this preview release, only the `eastus` region supports MRGs.

1. Delete the provisioned machine. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Provisioned machines**. Select the machine and then select **Delete**.

1. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. Upload the voucher and provision the machine again. For more information, see [Provision machines from Azure](simplified-machine-provisioning.md#step-3-provision-machines-from-azure).

## Provisioned machine creation fails with the error message "StorageAccountForbidden"

This error has the following possible causes.

**Cause:** Your administrator has set up an [Azure Policy](/azure/governance/policy/overview) that includes one or more of the following requirements:

- Resource groups must be created in a specific region. In this preview release, only the `eastus` region supports simplified machine provisioning.

- Resource groups must be created using a specific naming convention.

- Resources must have [Azure Resource Manager tags](/azure/azure-resource-manager/management/tag-resources). Simplified machine provisioning doesn't currently support this requirement.

**Recommendation:**

1. In Azure portal, browse to the resource group where you're trying to provision new machines and select **Monitor** > **Activity log**. You can use the activity log to investigate the provisioning error and determine which Azure Policy is restricting resource creation. For more information, see [Activity log in Azure Monitor](/azure/azure-monitor/platform/activity-log).

1. Add an [Azure Policy exemption](/azure/governance/policy/concepts/exemption-structure) for the policy that conflicts with simplified machine provisioning.

1. Delete the provisioned machine. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Provisioned machines**. Select the machine and then select **Delete**.

1. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. Upload the voucher and provision the machine again. For more information, see [Provision machines from Azure](simplified-machine-provisioning.md#step-3-provision-machines-from-azure).

**Cause:** You didn't register the `Microsoft.Storage` resource provider.

**Recommendation:**

1. Register the resource provider as described in the [prerequisites](simplified-machine-provisioning.md#azure-prerequisites).

1. Delete the provisioned machine. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Provisioned machines**. Select the machine and then select **Delete**.

1. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. Upload the voucher and provision the machine again. For more information, see [Provision machines from Azure](simplified-machine-provisioning.md#step-3-provision-machines-from-azure).

## Provisioned machine creation fails with the error message "DeviceOnboardingConflict"

**Cause:** You didn't register the `Microsoft.DeviceOnboarding/AzureLocalZTP` feature or the `Microsoft.DeviceOnboarding` resource provider.

**Recommendation:**

1. Register the `Microsoft.DeviceOnboarding/AzureLocalZTP` feature and required resource providers as described in the [prerequisites](simplified-machine-provisioning.md#azure-prerequisites).

1. Delete the provisioned machine. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Provisioned machines**. Select the machine and then select **Delete**.

1. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. Upload the voucher and provision the machine again. For more information, see [Provision machines from Azure](./simplified-machine-provisioning.md#step-3-provision-machines-from-azure).

## Provisioned machine creation fails with the error message "UpdateArcSettingDataFailed"

**Cause:** You didn't register the `Microsoft.HybridCompute` resource provider.

**Recommendation:**

1. Register the resource provider as described in the [prerequisites](simplified-machine-provisioning.md#azure-prerequisites).

1. Delete the provisioned machine. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Provisioned machines**. Select the machine and then select **Delete**.

1. Select **Azure Arc** > **Operations** > **Machine provisioning (preview)** > **Get started** > **Provision**. Upload the voucher and provision the machine again. For more information, see [Provision machines from Azure](simplified-machine-provisioning.md#step-3-provision-machines-from-azure).

## Reattempt a failed OS provisioning

**Problem:** If the OS installation fails, the deployments page shows the error messages `Your deployment failed` and `The resource write operation failed to complete successfully, because it reached terminal provisioning state 'Failed'.` Simplified machine provisioning currently doesn't support automatic retries from the service in case the OS installation fails.

**Recommendation:**

To retry OS provisioning:

1. Browse to [Azure Cloud shell](https://shell.azure.com).

1. Azure prompts you to choose Bash or PowerShell if you haven’t selected a default yet. It might also prompt you to create or select a storage account to persist your Cloud Shell files.

1. Create and run the following Bash script. Replace the `<PLACEHOLDERS>` with your values.

    ```bash
    #!/bin/bash
    set -e

    # Script to retry OS provisioning on an edge machine by resubmitting the ProvisionOS job
    # Performs a reput with osProfile and userDetails

    # Input parameters
    SUBSCRIPTION_ID=<subscription-id> 
    RESOURCE_GROUP=<resource-group>
    PROVISIONED_MACHINE_NAME=edge-machine-name>

    # Validate inputs
    if [ -z "$SUBSCRIPTION_ID" ] || [ -z "$RESOURCE_GROUP" ] || [ -z "$PROVISIONED_MACHINE_NAME" ]; then
        echo "Usage: $0 <subscription-id> <resource-group> <edge-machine-name>"
        exit 1
    fi

    echo "Subscription ID: $SUBSCRIPTION_ID"
    echo "Resource Group: $RESOURCE_GROUP"
    echo "Edge Machine Name: $PROVISIONED_MACHINE_NAME"

    # Set the subscription
    echo "Setting subscription..."
    az account set --subscription "$SUBSCRIPTION_ID"

    # Construct the ProvisionOS job endpoint
    PROVISION_OS_URL="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.AzureStackHCI/edgeMachines/$PROVISIONED_MACHINE_NAME/jobs/ProvisionOs"
    EDGE_MACHINE_URL="/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.AzureStackHCI/edgeMachines/$PROVISIONED_MACHINE_NAME"
    API_VERSION="2025-12-01-preview"

    echo "Getting edge machine configuration..."
    # GET the edge machine to extract userDetails
    EDGE_MACHINE_CONFIG=$(az rest \
        --method GET \
        --url "https://management.azure.com${EDGE_MACHINE_URL}?api-version=${API_VERSION}" \
        --output json)

    echo "Edge machine configuration retrieved"

    # Extract userDetails and osProfile from edge machine
    USER_DETAILS=$(echo "$EDGE_MACHINE_CONFIG" | jq '.properties.provisioningDetails.userDetails')
    OS_PROFILE=$(echo "$EDGE_MACHINE_CONFIG" | jq '.properties.provisioningDetails.osProfile')
    SITE_RESOURCE_ID=$(echo "$EDGE_MACHINE_CONFIG" | jq -r '.properties.siteDetails.siteResourceId')

    if [ "$USER_DETAILS" == "null" ] || [ "$OS_PROFILE" == "null" ]; then
        echo "Error: Could not extract userDetails or osProfile from the edge machine configuration"
        echo "Edge machine config: $EDGE_MACHINE_CONFIG"
        exit 1
    fi

    # Hardcode target and jobType
    TARGET="HCI"
    JOB_TYPE="ProvisionOs"

    echo "Extracted osProfile and userDetails from edge machine; using hardcoded target: $TARGET and jobType: $JOB_TYPE"

    # Create the PUT body with osProfile, userDetails, target, and jobType
    PUT_BODY=$(jq -n \
        --argjson osProfile "$OS_PROFILE" \
        --argjson userDetails "$USER_DETAILS" \
        --arg target "$TARGET" \
        --arg jobType "$JOB_TYPE" \
        '{
            properties: {
                jobType: $jobType,
                provisioningRequest: {
                    osProfile: $osProfile,
                    userDetails: $userDetails,
                    target: $target
                }
            }
        }')

    echo "Performing reput to retry OS provisioning..."
    # PUT the configuration back to trigger a retry
    az rest \
        --method PUT \
        --url "https://management.azure.com${PROVISION_OS_URL}?api-version=${API_VERSION}" \
        --body "$PUT_BODY" \
        --output json

    echo "ProvisionOS retry submitted successfully"
    ```

1. It takes up to 30 minutes for the retry to complete.

