---
title: Troubleshoot deployment validation issues in Azure Stack HCI, version 23H2 via Azure portal
description: Learn how to troubleshoot the deployment validation failures for Azure Stack HCI, version 23H2 when deployed via the Azure portal.
ms.topic: how-to
ms.author: alkohli
author: alkohli
ms.date: 08/21/2024
---


# Troubleshoot Azure portal deployment validation issues for Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article provides guidance on how to troubleshoot deployment validation issues experienced during the deployment of your Azure Stack HCI cluster via the Azure portal.

## Error - deployment vaildation failure 

When deploying Azure Stack HCI, version 23H2 via the Azure portal, you might encounter a deployment validation failure.
The "Azure Stack HCI Network - Check network requirements" validation task fail with the following error:

```
Could not complete the operation. 400: Resource creation validation failed. Details:
[{"Code":"AnswerFileValidationFailed","Message":"Errors in Value Validation:\r\nPhysicalNodesValidator
found error at deploymentdata.physicalnodes[0].ipv4address: The specified  for 
\u0027deploymentdata.physicalnodes[0].ipv4address\u0027 is not a valid IPv4 address.
Example: 192.168.0.1 or 192.168.0.1","Target":null,"Details":null}].
```

If you go to the **Networking** tab in Azure portal deployment, within the **Network Intent** configuration, you could see the following error:

```
The selected physical network adapter is not binded to the management virtual Switch.
```

## Cause

This issue occurs on deployments triggered after August 6th. The issue only happens if the deployment validation was triggered on the cluster and the validation result was a failure, with subsequent validation retries.

The issue occurs for the following reason:

- Validation on the device creates a VM switch for network related tests and is deleted at the end of tests.
- `DeviceManagementExtension` extension is not detecting the deletion of the VM switch.

## Recommended resolution

The multi-step resolution process includes the following steps:

- [Remove the lock from the seed node](#remove-the-lock-from-the-seed-node)
- [Remove the validation error](#remove-the-validation-error)
- [Clean up the Edge Device Azure Resource with incorrect VM switch information](#clean-up-the-edge-device-azure--resource-with-incorrect-vm-switch-information)
- [Refresh the cloud data](#refresh-the-cloud-edgedevices-data)
- [Redo the Azure portal](#redo-the-azure-portal)
- [Recreate the lock on the seed node resource](#recreate-the-lock-on-the-seed-node-resource)

### Remove the lock from the seed node

> [!NOTE]
> All the steps in this section need to be performed on the seed node.

Follow this multi-step process to mitigate this validation error:

1. To remove the lock, in the Azure portal, go to the object via the resource group or within Machines - Azure Arc.  
1. In the left-pane, go to **Settings > Locks**.  You should see a lock named **DoNotDelete**. This is the automatic resource lock that is created when the node is onboarded.
1. Select **Delete** against the lock.

If you attmept the steps in the next section without removing the lock, the **Delete** command fails with the following error:

```
Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/<subid>/resourceGroups/<rgname>/providers/Microsoft.HybridCompute/machines/<machinename>/providers/Microsoft.AzureStackHCI/edgeDevices/default
```

Here is the example output when run with the `--verbose` switch:

```Output
(ScopeLocked) The scope '/subscriptions/<subid>/resourceGroups/<rgname>/providers/Microsoft.HybridCompute/machines/<machinename>/providers/Microsoft.AzureStackHCI/edgeDevices/default' cannot perform delete operation because following scope(s) are locked: '/subscriptions/<subid>/resourceGroups/<rgname>/providers/Microsoft.HybridCompute/machines/<machinename>'. Please remove the lock and try again.
Code: ScopeLocked
Message: The scope '/subscriptions/<subid>/resourceGroups/<rgname>/providers/Microsoft.HybridCompute/machines/<machinename>/providers/Microsoft.AzureStackHCI/edgeDevices/default' cannot perform delete operation because following scope(s) are locked: '/subscriptions/<subid>/resourceGroups/<rgname>/providers/Microsoft.HybridCompute/machines/<machinename>'. Please remove the lock and try again.
```

### Remove the validation error

With the lock removed, follow these steps to remove the validation error.

1. Connect to the seed node. Run the following PowerShell command:

    ```powershell
    Get-VMSwitch
    ```

1. Check the output of the `Get-VMSwitch` command for any unexpected VM switches, for example, the switch that gets created during the Network Validation step and has a name similar to: `"ConvergedSwitch(compute_management)"`. The exact name of the switch depends on the chosen network intent configuration.

1. If a VM switch that you didn't intentionally create exists, remove the switch. Run the following PowerShell command:

    ```PowerShell
    Remove-VMSwitch -Name "<VM Switch Name>" -Force
    ```

    Make sure to use the VM switch name from the `Get-VMSwitch` command. If you didn't intentionally create a VM switch, the `Get-VMSwitch` command will have no results. The failure occurs because the Network Validation Step cleaned up the VM switch, but the `DeviceManagementExtension` didn't detect the cleanup.

1. Confirm the device cleanup and wait for the cleanup to complete.

### Clean up the Edge Device Azure Resource with incorrect VM switch information

After the VM switch on the device is removed, clean up the Edge Device ARM resource containing the incorrect VM switch information via the Azure CLI.

1. On a client that can access to Azure, verify install or install AZ CLI: [Install Azure CLI on Windows](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
   - You can verify install by running: `az`
   - If installed, this will output a `"Welcome to Azure CLI!"` message with available commands.

1. Sign in to Azure with az cli. Run the following command:
    
    ```AzureCLI
    az login --tenant <tenantGUID> --use-device-code
    ```  

    For more information, [Sign in interactively with Azure CLI](/cli/azure/authenticate-azure-cli-interactively)
   
1. To set a specific subscription, run the following command:

    ```azurecli
    az account set --subscription "<subGUID>"
    ```

    Replace the value in the above example command with the appropriate value for `<subGUID>`.
1. Output the data stored within the `edgeDevices` resource that has the incorrectly stored VM Switch information with the following command:

    ```azurecli
    az resource show --ids "/subscriptions/<subGUID>/resourceGroups/<resourceGROUPNAME>/providers/Microsoft.HybridCompute/machines/<machineNAME>/providers/Microsoft.AzureStackHCI/edgeDevices/default"
    ```

    Replace the values in the above example command with the appropriate values for:`<subGUID>`, `<resourceGROUPNAME>`, and `<machineNAME>`.
    
    Here is an example output:
    
    ```output
    az resource show --ids "/subscriptions/<Subscription ID>/resourceGroups/<Resource Group Name>/providers/Microsoft.HybridCompute/machines/ASRR1N26R15U33/providers/Microsoft.AzureStackHCI/edgeDevices/default"
    ```

    The output of this command will show quite a bit of detail about the <machineNAME> used in the command. Near the bottom of the output, you will see a section for `"switchDetails"`, which will more than likely show the following (which is the Validation VM Switch that was created and cleaned up on the device, but was not detected by the DeviceManagementExtension and updated cloud-side):
    `"switchName": "ConvergedSwitch(managementcompute)",`
    `"switchType": "External"`

1. After confirming the `show` command worked by outputting the `edgeDevices` data, and likely confirming the `"switchDetails"`, it is time to `delete` the resource from ARM so it can be refreshed appropriately from the device.

1. Delete the `edgeDevices` resource which has the incorrectly stored VM Switch information with the following command:
    `az resource delete --ids "/subscriptions/<subGUID>/resourceGroups/<resourceGROUPNAME>/providers/Microsoft.HybridCompute/machines/<machineNAME>/providers/Microsoft.AzureStackHCI/edgeDevices/default"`
    
    Replace the values (remember to remove the "<>" characters as well) in the above example command with the appropriate values for:
      `<subGUID>`
      `<resourceGROUPNAME>`
      `<machineNAME>`
    
    This is the same resource `--ids` from the `show`, so you can just leverage that same string. In fact, you could just "up arrow" in the console and replace `show` with `delete`.

    Here is an example output: 

    ```Output
    `az resource delete --ids "/subscriptions/d41eb627-825d-4419-a14d-c6ad485f4110/resourceGroups/EDGECI-REGISTRATION-rr1n26r1512-kXOKQuGV/providers/Microsoft.HybridCompute/machines/ASRR1N26R15U33/providers/Microsoft.AzureStackHCI/edgeDevices/default"
    ```
    - **Note:** Run just like this, there will be no output from this command, it will either work and return the command prompt, or present an error. It should not present an error, if it does, that will require additional troubleshooting.
1. Verify the deletion of the resource by running the `show` command again. Here is an example output:

    ```Output
    (ResourceNotFound) The resource 'Microsoft.HybridCompute/machines/<machineNAME>/providers/Microsoft.AzureStackHCI/edgeDevices/default' could not be found.
    Code: ResourceNotFound
    Message: The resource 'Microsoft.HybridCompute/machines/<machineNAME>/providers/Microsoft.AzureStackHCI/edgeDevices/default' could not be found.
    ```

### Refresh the cloud `edgeDevices` data

With the ARM resource and all the unintentional VM switches removed, refresh the cloud-side `edgeDevices` data again.

Follow these steps to refresh the cloud data:

1. Restart the `DeviceManagementService` on the seed node. Run the following PowerShell command:

   ```powershell
    Restart-Service DeviceManagementService
    ```

1. Wait a few minutes and then verify that the cloud `edgeDevices` data is updated and reflects the current state. Run the `show` command again and review the output. Make sure that the output no longer contains any unexpected VM switches, namely:

    `"switchName": "ConvergedSwitch(managementcompute)",`
    `"switchType": "External"`

### Redo the Azure portal

With device and cloud data now back in sync, you can go to the Azure portal and provide the deployment inputs. The previous step prevents any cached information from previous attempts. 

Follow these steps in the Azure portal:
  
1. On the **Basics** tab, provide your inputs (by selecting from the dropdowns once again) to the fields from the top.

1. Uncheck the nodes at the bottom of the page.

1. Revalidate the reselected nodes.

1. Confirm the information on the subsequent pages. You should see the following changes:
    - On the **Networking** page, you should no longer see the `The selected physical network adapter is not binded to the management virtual Switch` error that might have been seen previously.
    - On the **Validation** page at the end, if you are past the original issue, the `deploymentdata.physicalnodes[0].ipv4address is not a valid IPv4 address` error won't be displayed.

1. If no other validation issues occur, start the deployment.

### Recreate the lock on the seed node resource

After the mitigation is complete, we strongly recommend that you recreate the lock on the resource.

Follow these steps to recreate the lock:

1. In the Azure portal, go to the object via the resource group or within **Machines - Azure Arc**.  
1. Expand '**Settings** in the left column, then select  **Locks**.  
1. Select '**+ Add**' at the top of the page.
    1. For **Lock name**, enter **DoNotDelete**.
    1. For **Lock type**, select '**Delete**' from the drop-down.
1. Select **OK** to save the lock.