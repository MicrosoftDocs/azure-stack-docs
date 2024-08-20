---
author: chjoy@microsoft.com
foundinbuild: Deployments after August 6th, 2024
fixedinbuild: Targeted within 2-weeks of August 14th, 2024
engineeringid: 532173261
---

# Background
A new portal validation method which calculates the ipv4Address of the host machine was rolled out 1st week of August 2024. From the PG: "If some switch is configured for the device, we find the corresponding Virtual NIC whose MAC Address matches that of the MAC Address of the Management NIC. In these customer cases, a switch was found but that switch was not configured to any Virtual NIC, hence the missing ipv4 address, because the switch was incorrectly configured for the customer device."

## Error message

The "Azure Stack HCI Network - Check network requirements" validation task fail with the following error:

```
Could not complete the operation. 400: Resource creation validation failed. Details:
[{"Code":"AnswerFileValidationFailed","Message":"Errors in Value Validation:\r\nPhysicalNodesValidator
found error at deploymentdata.physicalnodes[0].ipv4address: The specified  for 
\u0027deploymentdata.physicalnodes[0].ipv4address\u0027 is not a valid IPv4 address.
Example: 192.168.0.1 or 192.168.0.1","Target":null,"Details":null}].
```

If you go to the **Networking** tab in Azure portal deployment, within the **Network Intent** configuration, the following error could be seen:

`The selected physical network adapter is no binded to the management virtual Switch.`

## Cause

This issue occurs on deployments triggered after August 6th. The issue only happens if the deployment validation was triggered on the cluster and the validation result was a failure, with subsequent validation retries.

The mismatch occurs for the following reason:
- Validation on the device creates a VM Switch for network related tests and is deleted at the end of tests.
- DeviceManagementExtension extension is not detecting this deletion of the VM Switch.

## Recommended resolution



### Remove the lock from the seed node

> All steps below only need to be performed for the seed node.

Follow this multi-step process to mitigate this validation error:

1. To remove the lock, in the Azure portal, go to the object via the resource group or within Machines - Azure Arc.  
1. In the left-pane, go to **Settings > Locks**.  You should see a lock named **DoNotDelete**. This is the automatic resource lock that is created when the node is onboarded.
1. Select **Delete** against the lock.

If you attmept the steps in the next section without removing the lock, the Delete command will fail with the following error:

```Output
Some resources failed to be deleted (run with `--verbose` for more information):
/subscriptions/<subid>/resourceGroups/<rgname>/providers/Microsoft.HybridCompute/machines/<machinename>/providers/Microsoft.AzureStackHCI/edgeDevices/default
```

Running the `--verbose` switch provides the following additional output:

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

1. Check the output of the `Get-VMSwitch` command for any unexpected VM Switches, for example, the switch that gets created during the Network Validation step and has a name similar to: `"ConvergedSwitch(compute_management)"`. The name of the switch depends on the chosen network intent configuration.

1. If a VM switch that you didn't intentionally create (like the one named above) exists, remove the switch. Run the following PowerShell command:

    ```PowerShell
    Remove-VMSwitch -Name "<VM Switch Name>" -Force
    ```
    Make sure to use the VM switch name from the `Get-VMSwitch` command. If you didn't intentionally create a VM switch, the Get-VMSwitch command will have no results.
   - **Note 2:** If the customer did not intentionally create a VM Switch, it is likely that the output of the `Get-VMSwitch` command will have no results, this is due to the fact that the Network Validation Step cleaned this VM Switch up, and it is the DeviceManagementExtension that did not detect the cleanup, leaving the Deployment Validation in this fail state.

1. Confirm the device cleanup and wait for the cleanup to complete.

### Clean up the Edge Device Azure  Resource with incorrect VM Switch information

After the VM switch on the device is removed, clean up the Edge Device ARM resource containing the incorrect VM switch information. This ARM side cleanup can be done via AZ CLI.

1. On a machine that the customer uses with access to Azure, verify install or install AZ CLI: [Install Azure CLI on Windows](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
   - You can verify install by running: `az`
   - If installed, this will output a `"Welcome to Azure CLI!"` message with available commands.
   - Note: Though I have not tested it, from what I can tell, az cli can be leveraged from Azure Cloud Shell if the customer has that configured and is comfortable with it.
1. Login to Azure with az cli, leverage the following command: `az login`
   - This command has a lot of options available depending on how/where the customer would like to authenticate
   - The command I used to verify these steps internally included the following parameters:
     `az login --tenant <tenantGUID> --use-device-code`
   - The available options are documented here: [Sign in interactively with Azure CLI](https://learn.microsoft.com/en-us/cli/azure/authenticate-azure-cli-interactively)
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
    - **MY INTERNAL REPRO EXAMPLE** command was as follows: `az resource show --ids "/subscriptions/d41eb627-825d-4419-a14d-c6ad485f4110/resourceGroups/EDGECI-REGISTRATION-rr1n26r1512-kXOKQuGV/providers/Microsoft.HybridCompute/machines/ASRR1N26R15U33/providers/Microsoft.AzureStackHCI/edgeDevices/default"`
    - **Note:** The output of this command will show quite a bit of detail about the <machineNAME> used in the command. Near the bottom of the output, you will see a section for `"switchDetails"`, which will more than likely show the following (which is the Validation VM Switch that was created and cleaned up on the device, but was not detected by the DeviceManagementExtension and updated cloud-side):
    `"switchName": "ConvergedSwitch(managementcompute)",`
    `"switchType": "External"`
1. After confirming the `show` command worked by outputting the `edgeDevices` data, and likely confirming the `"switchDetails"`, it is time to `delete` the resource from ARM so it can be refreshed appropriately from the device.
1. Delete the `edgeDevices` resource which has the incorrectly stored VM Switch information with the following command:
    `az resource delete --ids "/subscriptions/<subGUID>/resourceGroups/<resourceGROUPNAME>/providers/Microsoft.HybridCompute/machines/<machineNAME>/providers/Microsoft.AzureStackHCI/edgeDevices/default"`
    - **NOTICE:** Replace the values (remember to remove the "<>" characters as well) in the above example command with the appropriate values for:
      `<subGUID>`
      `<resourceGROUPNAME>`
      `<machineNAME>`
    - **Note:** This is the same resource `--ids` from the `show`, so you can just leverage that same string. In fact, you could just "up arrow" in the console and replace `show` with `delete`.
    - **MY INTERNAL REPRO EXAMPLE** command was as follows: `az resource delete --ids "/subscriptions/d41eb627-825d-4419-a14d-c6ad485f4110/resourceGroups/EDGECI-REGISTRATION-rr1n26r1512-kXOKQuGV/providers/Microsoft.HybridCompute/machines/ASRR1N26R15U33/providers/Microsoft.AzureStackHCI/edgeDevices/default"`
    - **Note:** Run just like this, there will be no output from this command, it will either work and return the command prompt, or present an error. It should not present an error, if it does, that will require additional troubleshooting.
1. Verify the deletion of the resource by running the `show` command again. If all goes as planned, this will output something like:
```
(ResourceNotFound) The resource 'Microsoft.HybridCompute/machines/<machineNAME>/providers/Microsoft.AzureStackHCI/edgeDevices/default' could not be found.
Code: ResourceNotFound
Message: The resource 'Microsoft.HybridCompute/machines/<machineNAME>/providers/Microsoft.AzureStackHCI/edgeDevices/default' could not be found.
```

### Refresh the cloud `edgeDevices` data

With the ARM resource and all the unintentional VM switches removed, refresh the cloud-side `edgeDevices` data again. Follow these steps to refresh the cloud data:

1. Restart the `DeviceManagementService` on the seed node. Run the following PowerShell command:

   ```powershell
    Restart-Service DeviceManagementService
    ```

1. Wait a few minutes and then verify that the cloud `edgeDevices` data is updated and reflects the current state. Run the `show` command again and review the output. Make sure that the output no longer contains any unexpected VM switches, namely:

    `"switchName": "ConvergedSwitch(managementcompute)",`
    `"switchType": "External"`

### Redo the Azure portal

With device and cloud-side data now back in sync, you can go to the Azure portal and navigate to Basics tab in the deployment UX. This should prevent any cached information from previous attempts. Follow these steps in the Azure portal:
  
1. On the **Basics** tab, provide your inputs (by selecting from the dropdowns once again) to the fields from the top.

1. Uncheck the nodes at the bottom of the page.

1. Revalidate the reselected nodes.

1. Confirm the information on the subsequent pages. 
    - **Note:** When you get to the Network page, you should no longer see the `"The selected physical network adapter is no binded to the management virtual Switch"` error that might have been seen previously.
    - When you get to the Validation page at the end, you should know if you are past the original issue, as the `"deploymentdata.physicalnodes[0].ipv4address is not a valid IPv4 address"` error should no longer immediately pop.
1. If no other/different validation issues occur, the Deployment should be ready to kick off and run.


> :ledger: **NOTE**
>
> Once the mitigation has been completed, it is **HIGHLY** recommended to recreate the lock on the resource.  Steps for this are included after the mitigation steps.

Once mitigation is successful, you should recreate the lock on the seed node resource.  To do this, navigate to the object via the resource group or within 'Machines - Azure Arc'.  Expand 'Settings' in the left column, then click on 'Locks'.  Click '**+ Add**' at the top of the page.  

For 'Lock name', enter '**DoNotDelete**'.  
For 'Lock type', select '**Delete**' from the drop-down.

Click 'OK' to save the lock.