---
title: Manage including restart, start, stop or delete Arc VMs on Azure Stack HCI 
description: Learn how to manage Arc VMs. This includes operations such as start, stop, restart, view properties of Arc VMs running on Azure Stack HCI, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/13/2024
---

# Manage Arc VMs on Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage Arc virtual machines (VMs) running on Azure Stack HCI, version 23H2. The procedures to enable guest management, start, stop, restart, pause, save, or delete an Arc VM, are detailed.

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure you have access to an Azure Stack HCI cluster that is deployed and registered. During the deployment, an Arc Resource Bridge and a custom location are also created.

   Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. Make sure you have one or more Arc VMs running on this Azure Stack HCI cluster. For more information, see [Create Arc VMs on Azure Stack HCI](./create-arc-virtual-machines.md).

## Enable guest management

After you created a VM, you would want to enable guest management on that VM.

There are two agents that are important to understand in the context of guest management - a VM guest agent and an Azure Connected Machine agent. Every Arc VM created via Azure portal or Azure CLI is provisioned with a guest agent (also referred to as the `mocguestagent`) on it.

When you enable guest management on an Arc VM, the guest agent installs the [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview). The Azure Connected Machine agent enables you to manage Azure Arc VM extensions on your Azure Stack HCI VM.

Here are some key considerations for enabling guest management on a VM after provisioning it:

- Make sure that your Azure Stack HCI cluster is running 2311 or later.
- Enabling guest management after VM provisioning isn't supported for Windows Server 2012 and Windows Server 2012 R2.
- The steps to enable guest management differ based on whether a guest agent is running on your Arc VM.

### Verify if guest agent is running

1. To verify whether the guest agent is running on the Arc VM, connect to the Azure Stack HCI server.
1. Run the following command:

    ```azurecli
    az stack-hci-vm show --name "<VM name>" --resource-group "<Resource group name>"
    ```
    
    Here's a snippet of the sample output that indicates that the guest agent is running. Look for `statuses` under the `vmAgent` in the output.

    ```output
    "instanceView": {
      "vmAgent": {
        "statuses": [
          {
            "code": "ProvisioningState/succeeded",
            "displayStatus": "Connected",
            "level": "Info",
            "message": "Successfully established connection with mocguestagent",
            "time": "2024-01-13T00:57:39Z"
          },
          {
            "code": "ProvisioningState/succeeded",
            "displayStatus": "Connected",
            "level": "Info",
            "message": "New mocguestagent version detected 'v0.13.0-3-gd13b4794",
            "time": "2024-01-13T00:57:39Z"
          }
        ],
        "vmConfigAgentVersion": "v0.13.0-3-gd13b4794"
      }
    }
    ```
   
    The guest agent is running:
    - When `statuses` indicate `code` as `ProvisioningState/succeeded` and the `displayStatus` as `Connected`. 
    - If running an older version, the `statuses` would indicate `code` as `OK` and the `displayStatus` as `Active`

If your statuses do not match the above output, follow the steps in [Enable guest management when the guest agent is not running](#enable-guest-management-on-a-vm-when-guest-agent-is-not-running).

### Enable guest management on a VM with guest agent running

To enable guest management on an Arc VM that has guest agent running, run the following command:

```azurecli
az stack-hci-vm update --name "myhci-vm" --enable-agent true --resource-group "myhci-rg"
```
Guest management is enabled by setting the `enable-agent parameter` to `true`. Guest management should take a few minutes to get enabled.

Follow the steps to [verify that the guest management is enabled in the Azure portal](#verify-guest-management-is-enabled-in-the-azure-portal).

### Enable guest management on a VM when guest agent is not running

There are two scenarios when the guest agent is not running - when the statuses is connecting and when the statuses are blank. Each of these scenarios and the corresponding steps are described in the following sections.

#### Status displayed as connecting

Your status shows as connecting. Here's a sample output snippet indicating the requisite status.

```output
"instanceView": {
      "vmAgent": {
        "statuses": [
          {
            "code": "ProvisioningState/InProgress",
            "displayStatus": "Connecting",
            "level": "Info",
            "message": "Waiting for connection with mocguestagent",
            "time": "2024-01-19T01:41:15Z"
          }
        ]
      }
    },
```

The guest agent is not running when:
- The guest agent is not running when `statuses` indicate `code` as `ProvisioningState/InProgress` and the `displayStatus` as `Connecting`. 
- If running an older version, the `statuses` would indicate `code` as `OK`, the `displayStatus` as `Active`and `message` as `Successfully started HyperV listener`.


Follow these steps:

1. Connect to the VM using the OS specific steps. Run PowerShell as administrator.
1. Run one of the following commands to enable the guest agent on your VM based on the OS type:

    **Linux**:
  
      ```azurecli
      sudo -- sh -c 'mkdir /mociso && mount -L mocguestagentprov /mociso && bash /mociso/install.sh && umount /mociso && rm -df /mociso && eject LABEL=mocguestagentprov'
      ```
    **Windows**:
      ```azurecli
      $d=Get-Volume -FileSystemLabel mocguestagentprov;$p=Join-Path ($d.DriveLetter+':\') 'install.ps1';powershell $p
      ```
 
    Here's a sample output for a Linux VM that shows the guest agent is successfully installed.

    :::image type="content" source="./media/manage-arc-virtual-machines/guest-agent-installed-1.png" alt-text="Screenshot showing that the guest agent is successfully enabled on the VM." lightbox="./media/manage-arc-virtual-machines/guest-agent-installed-1.png":::

1. Connect to one of the Azure Stack HCI servers. Run the following command to enable guest management.

   ```azurecli
   az stack-hci-vm update --name "myhci-vm" --enable-agent true --resource-group "myhci-rg"
   ```

Follow the steps to [verify that the guest management is enabled in the Azure portal](#verify-guest-management-is-enabled-in-the-azure-portal).

#### Status displayed as null

Your status shows as null. This indicates the required *iso* for guest agent is missing. Here's a sample output snippet indicating the null status.

```output
"instanceView": {
      "vmAgent": {
        "statuses": []
      }
    },
```

Follow these steps:

1. Connect to Azure Stack HCI server.
1. Run the following command:

    ```azurecli
    az stack-hci-vm update --name "<VM Name>" --resource-group "<Resource group name>" --enable-vm-config-agent true
    ```
    The `enable-vm-config-agent` parameter mounts the required *iso* for the guest agent.

1. Wait a few minutes and rerun the `az stack-hci-vm show` command. When the status shows as `connecting`, follow the steps in [Status displayed as connecting](#status-displayed-as-connecting).

#### Verify guest management is enabled in the Azure portal

1. Go to the Azure portal. 
1. Navigate to **Your Azure Stack HCI cluster > Virtual machines** and then select the VM on which you enabled the guest management. 
1. In the **Overview** page, on the **Properties** tab in the right pane, go to **Configuration**. The **Guest management** should show as **Enabled (Connected)**.

   :::image type="content" source="./media/manage-arc-virtual-machines/verify-guest-management-enabled-1.png" alt-text="Screenshot showing how to Create a VM using Windows VM image." lightbox="./media/manage-arc-virtual-machines/verify-guest-management-enabled-1.png":::


## View VM properties

Follow these steps in the Azure portal of your Azure Stack HCI system to view VM properties.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select the name of the VM whose properties you wish to view.

   :::image type="content" source="./media/manage-arc-virtual-machines/view-virtual-machine-properties-1.png" alt-text="Screenshot of VM selected from the list of VMs." lightbox="./media/manage-arc-virtual-machines/view-virtual-machine-properties-1.png":::

1. On the **Overview** page, go to the right pane and then go to the **Properties** tab. You can view the properties of your VM.

   :::image type="content" source="./media/manage-arc-virtual-machines/view-virtual-machine-properties-2.png" alt-text="Screenshot of properties of the selected Arc VM." lightbox="./media/manage-arc-virtual-machines/view-virtual-machine-properties-2.png":::

## Start a VM

Follow these steps in the Azure portal of your Azure Stack HCI system to start a VM.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that isn't running and you wish to start.

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Start**, then select **Yes**.

1. Verify the VM has started.

   :::image type="content" source="./media/manage-arc-virtual-machines/start-virtual-machine.png" alt-text="Screenshot of select + start VM." lightbox="./media/manage-arc-virtual-machines/start-virtual-machine.png":::

## Stop a VM

Follow these steps in the Azure portal of your Azure Stack HCI system to stop a VM.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that is running and you wish to stop.

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Stop**, then select **Yes**.

1. Verify the VM has stopped.

   :::image type="content" source="./media/manage-arc-virtual-machines/stop-virtual-machine.png" alt-text="Screenshot of select + stop VM." lightbox="./media/manage-arc-virtual-machines/stop-virtual-machine.png":::

## Restart a VM

Follow these steps in the Azure portal of your Azure Stack HCI system to restart a VM.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that is stopped and you wish to restart.

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Restart**, then select **Yes**.

1. Verify the VM has restarted.

   :::image type="content" source="./media/manage-arc-virtual-machines/restart-virtual-machine.png" alt-text="Screenshot of select + restart VM." lightbox="./media/manage-arc-virtual-machines/restart-virtual-machine.png":::

## Pause a VM

Pausing the VMs is useful to save the compute resources when you are not using the VMs. Pausing a VM stops any CPU activity. You can only pause running VMs. Once paused, you can resume the VM later.

1. [Connect to the server node of your Azure Stack HCI system](./azure-arc-vm-management-prerequisites.md#connect-to-the-cluster-directly).
1. To pause the VM, run the following PowerShell cmdlet:

    ```azurecli
    #Set input parameters

    $rg = "<Resource group name>"
    $vmName = "<VM name>"

    #Pause the VM

    az stack-hci-vm pause --name $vmName --resource-group $rg
    ```

    The parameters used for this cmdlet are as follows:

    |Parameter  |Description  |
    |---------|---------|
    |`name`     |Name of the virtual machine.         |
    |`resource-group`    |Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.         |
    |`subscription`     |Name or ID of subscription. You can configure the default subscription using `az account set -s NAME_OR_ID`.         |

1. Check the VM status to verify that the VM is paused.
  
    ```azurecli
    #Check the VM status

    az stack-hci-vm show --name $vmName --resource-group $rg
    ```

1. Start the VM to resume the VM from the paused state. Verify that the VM is running.

    ```azurecli
    #Start the VM

    az stack-hci-vm start --name $vmName --resource-group $rg
    ```

    #### Example output

    <details>
    <summary>Expand this section to see an example output.</summary>

    ```output

    #Set parameters

    [v-host1]: PS C:\Users\HCIDeploymentUser> $rg = "<Resource group name>"    
    [v-host1]: PS C:\Users\HCIDeploymentUser> $vmName = "<VM name>"

    #Pause the VM

    [v-host1]: PS C:\Users\HCIDeploymentUser> az stack-hci-vm pause --name $vmName --resource-group $rg

    #Show the current state of the VM
    [v-host1]: PS C:\Users\HCIDeploymentUser> az stack-hci-vm show -g $rg --name $vmName
    {
      "attestationStatus": null,
      "virtualmachineinstance": {
        "extendedLocation": {
          "name": "/subscriptions/<Subscription ID>/resourcegroups/<Resource group name>/providers/Microsoft.ExtendedLocation/customLocations/s-cluster-customlocation",
          "type": "CustomLocation"
        },
        "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/testvm001/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default",
        "identity": null,
        "name": "default",
        "properties": {
          "guestAgentInstallStatus": null,
          "hardwareProfile": {
            "dynamicMemoryConfig": {
              "maximumMemoryMb": null,
              "minimumMemoryMb": null,
              "targetMemoryBuffer": null
            },
            "memoryMb": 2000,
            "processors": 2,
            "vmSize": "Custom"
          },
          "httpProxyConfig": null,
          "instanceView": {
            "vmAgent": {
              "statuses": [
                {
                  "code": "ProvisioningState/succeeded",
                  "displayStatus": "Connected",
                  "level": "Info",
                  "message": "Connection with mocguestagent was successfully reestablished",
                  "time": "2024-06-24T16:30:05+00:00"
                },
              ],
              "vmConfigAgentVersion": "v0.18.0-4-gd54376b0"
            }
          },
          "networkProfile": {
            "networkInterfaces": []
          },
          "osProfile": {
            "adminPassword": null,
            "adminUsername": "azureuser",
            "computerName": "testvm001",
            "linuxConfiguration": {
              "disablePasswordAuthentication": false,
              "provisionVmAgent": false,
              "provisionVmConfigAgent": true,
              "ssh": {
                "publicKeys": null
              }
            },
            "windowsConfiguration": {
              "enableAutomaticUpdates": null,
              "provisionVmAgent": false,
              "provisionVmConfigAgent": true,
              "ssh": {
                "publicKeys": null
              },
              "timeZone": null
            }
          },
          "provisioningState": "Succeeded",
          "resourceUid": null,
          "securityProfile": {
            "enableTpm": false,
            "securityType": null,
            "uefiSettings": {
              "secureBootEnabled": true
            }
          },
          "status": {
            "errorCode": "",
            "errorMessage": "",
            "powerState": "Paused",
            "provisioningStatus": null
          },
          "storageProfile": {
            "dataDisks": [],
            "imageReference": {
              "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.AzureStackHCI/galleryImages/WinImage-26tdJUIS",
              "resourceGroup": "<Resource group name>"
            },
            "osDisk": {
              "id": null,
              "osType": "Windows"
            },
            "vmConfigStoragePathId": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage2-guid"
          },
          "vmId": "<guid>"
        },
        "resourceGroup": "<Resource group name>",
        "systemData": {
          "createdAt": "2024-06-24T01:29:06.594266+00:00",
          "createdBy": "7d6ffe2f-dac5-4e74-9bf2-4830cf7f4668",
          "createdByType": "Application",
          "lastModifiedAt": "2024-06-24T16:41:27.166668+00:00",
          "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
          "lastModifiedByType": "Application"
        },
        "type": "microsoft.azurestackhci/virtualmachineinstances"
      }
    }

    #Start the VM after it was paused. 

    [v-host1]: PS C:\Users\HCIDeploymentUser> az stack-hci-vm start --name $vmName --resource-group $rg
    Inside _start_initial/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/testvm0012024-02-01-preview/https://management.azure.com/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/testvm001/providers/Microsoft.AzureStackHCI/virtualMachineInstances/d
    efault/start?api-version=2024-02-01-preview

    #Show the current state of the VM. The VM should be running.

    [v-host1]: PS C:\Users\HCIDeploymentUser> az stack-hci-vm show -g $rg --name $vmName
    {
      "attestationStatus": null,
      "virtualmachineinstance": {
        "extendedLocation": {
          "name": "/subscriptions/<Subscription ID>/resourcegroups/<Resource group name>/providers/Microsoft.ExtendedLocation/customLocations/s-cluster-customlocation",
          "type": "CustomLocation"
        },
        "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/testvm001/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default",
        "identity": null,
        "name": "default",
        "properties": {
          "guestAgentInstallStatus": null,
          "hardwareProfile": {
            "dynamicMemoryConfig": {
              "maximumMemoryMb": null,
              "minimumMemoryMb": null,
              "targetMemoryBuffer": null
            },
            "memoryMb": 2000,
            "processors": 2,
            "vmSize": "Custom"
          },
          "httpProxyConfig": null,
          "instanceView": {
            "vmAgent": {
              "statuses": [
                {
                  "code": "ProvisioningState/succeeded",
                  "displayStatus": "Connected",
                  "level": "Info",
                  "message": "Connection with mocguestagent was succesfully reestablished",
                  "time": "2024-06-24T17:25:19+00:00"
                }
              ],
              "vmConfigAgentVersion": "v0.18.0-4-gd54376b0"
            }
          },
          "networkProfile": {
            "networkInterfaces": []
          },
          "osProfile": {
            "adminPassword": null,
            "adminUsername": "azureuser",
            "computerName": "testvm001",
            "linuxConfiguration": {
              "disablePasswordAuthentication": false,
              "provisionVmAgent": false,
              "provisionVmConfigAgent": true,
              "ssh": {
                "publicKeys": null
              }
            },
            "windowsConfiguration": {
              "enableAutomaticUpdates": null,
              "provisionVmAgent": false,
              "provisionVmConfigAgent": true,
              "ssh": {
                "publicKeys": null
              },
              "timeZone": null
            }
          },
          "provisioningState": "Succeeded",
          "resourceUid": null,
          "securityProfile": {
            "enableTpm": false,
            "securityType": null,
            "uefiSettings": {
              "secureBootEnabled": true
            }
          },
          "status": {
            "errorCode": "",
            "errorMessage": "",
            "powerState": "Running",
            "provisioningStatus": null
          },
          "storageProfile": {
            "dataDisks": [],
            "imageReference": {
              "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.AzureStackHCI/galleryImages/WinImage-26tdJUIS",
              "resourceGroup": "<Resource group name>"
            },
            "osDisk": {
              "id": null,
              "osType": "Windows"
            },
            "vmConfigStoragePathId": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage2-guid"
          },
          "vmId": "<guid>"
        },
        "resourceGroup": "<Resource group name>",
        "systemData": {
          "createdAt": "2024-06-24T01:29:06.594266+00:00",
          "createdBy": "<guid>",
          "createdByType": "Application",
          "lastModifiedAt": "2024-06-24T17:28:13.206935+00:00",
          "lastModifiedBy": "<guid>",
          "lastModifiedByType": "Application"
        },
        "type": "microsoft.azurestackhci/virtualmachineinstances"
      }
    }

    ```

</details>

## Save a VM

Saving a VM stores the current state of the VM to the disk and stops the VM. Saving a VM frees up memory and CPU resources. You can only save running VMs.

1. [Connect to the server node of your Azure Stack HCI system](./azure-arc-vm-management-prerequisites.md#connect-to-the-cluster-directly).
1. To save the VM, run the following PowerShell cmdlet:

    ```azurecli
    #Set input parameters

    $rg = "<Resource group name>"
    $vmName = "<VM name>"
    
    #Save the VM

    az stack-hci-vm save --name $vmName --resource-group $rg
    ```

    The parameters used for this cmdlet are as follows:

    |Parameter  |Description  |
    |---------|---------|
    |`name`     |Name of the virtual machine.         |
    |`resource-group`    |Name of resource group. You can configure the default group using `az configure --defaults group=<name>`.         |
    |`subscription`     |Name or ID of subscription. You can configure the default subscription using `az account set -s <Subscription name or Subscription ID>`.         |

1. Check the VM status to verify that the VM is saved.
  
    ```azurecli
    #Check the VM status

    az stack-hci-vm show --name $vmName --resource-group $rg
    ```

1. Start the VM to resume the VM from the saved state. Verify that the VM is running.

    ```azurecli
    #Start the VM

    az stack-hci-vm start --name $vmName --resource-group $rg
    ```

    #### Example output

    <details>
    <summary>Expand this section to see an example output.</summary>

    ```output
    #Set parameters

    [v-host1]: PS C:\Users\HCIDeploymentUser> $rg = "<Resource group name>"    
    [v-host1]: PS C:\Users\HCIDeploymentUser> $vmName = "<VM name>"

    #Save the VM

    [v-host1]: PS C:\Users\HCIDeploymentUser> az stack-hci-vm save --name $vmName --resource-group $rg

    #Show the current state of the VM

    [v-host1]: PS C:\Users\HCIDeploymentUser> az stack-hci-vm show -g $rg --name $vmName
    {
      "attestationStatus": null,
      "virtualmachineinstance": {
        "extendedLocation": {
          "name": "/subscriptions/<Subscription ID>/resourcegroups/<Resource group name>/providers/Microsoft.ExtendedLocation/customLocations/s-cluster-customlocation",
          "type": "CustomLocation"
        },
        "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/testvm001/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default",
        "identity": null,
        "name": "default",
        "properties": {
          "guestAgentInstallStatus": null,
          "hardwareProfile": {
            "dynamicMemoryConfig": {
              "maximumMemoryMb": null,
              "minimumMemoryMb": null,
              "targetMemoryBuffer": null
            },
            "memoryMb": 2000,
            "processors": 2,
            "vmSize": "Custom"
          },
          "httpProxyConfig": null,
          "instanceView": {
            "vmAgent": {
              "statuses": [
                {
                  "code": "ProvisioningState/succeeded",
                  "displayStatus": "Connected",
                  "level": "Info",
                  "message": "Connection with mocguestagent was succesfully reestablished",
                  "time": "2024-06-24T17:25:19+00:00"
                },
              ],
              "vmConfigAgentVersion": "v0.18.0-4-gd54376b0"
            }
          },
          "networkProfile": {
            "networkInterfaces": []
          },
          "osProfile": {
            "adminPassword": null,
            "adminUsername": "azureuser",
            "computerName": "testvm001",
            "linuxConfiguration": {
              "disablePasswordAuthentication": false,
              "provisionVmAgent": false,
              "provisionVmConfigAgent": true,
              "ssh": {
                "publicKeys": null
              }
            },
            "windowsConfiguration": {
              "enableAutomaticUpdates": null,
              "provisionVmAgent": false,
              "provisionVmConfigAgent": true,
              "ssh": {
                "publicKeys": null
              },
              "timeZone": null
            }
          },
          "provisioningState": "Succeeded",
          "resourceUid": null,
          "securityProfile": {
            "enableTpm": false,
            "securityType": null,
            "uefiSettings": {
              "secureBootEnabled": true
            }
          },
          "status": {
            "errorCode": "",
            "errorMessage": "",
            "powerState": "Saved",
            "provisioningStatus": null
          },
          "storageProfile": {
            "dataDisks": [],
            "imageReference": {
              "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.AzureStackHCI/galleryImages/WinImage-26tdJUIS",
              "resourceGroup": "<Resource group name>"
            },
            "osDisk": {
              "id": null,
              "osType": "Windows"
            },
            "vmConfigStoragePathId": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage2-345d968fa1e74e99a9509ab7f3d259fd"
          },
          "vmId": "<guid>"
        },
        "resourceGroup": "<Resource group name>",
        "systemData": {
          "createdAt": "2024-06-24T01:29:06.594266+00:00",
          "createdBy": "<guid>",
          "createdByType": "Application",
          "lastModifiedAt": "2024-06-24T18:29:02.794305+00:00",
          "lastModifiedBy": "<guid>",
          "lastModifiedByType": "Application"
        },
        "type": "microsoft.azurestackhci/virtualmachineinstances"
      }
    }
    
    #Start the VM after it was saved

    [v-host1]: PS C:\Users\HCIDeploymentUser> az stack-hci-vm start --name $vmName --resource-group $rg
    Inside _start_initial/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/testvm0012024-02-01-previewhttps://management.azure.com/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/testvm001/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default/start?api-version=2024-02-01-preview

    #Show the current state of the VM. The VM should be running.

    [v-host1]: PS C:\Users\HCIDeploymentUser> az stack-hci-vm show -g $rg --name $vmName
    {
      "attestationStatus": null,
      "virtualmachineinstance": {
        "extendedLocation": {
          "name": "/subscriptions/<Subscription ID>/resourcegroups/<Resource group name>/providers/Microsoft.ExtendedLocation/customLocations/s-cluster-customlocation",
          "type": "CustomLocation"
        },
        "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.HybridCompute/machines/testvm001/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default",
        "identity": null,
        "name": "default",
        "properties": {
          "guestAgentInstallStatus": null,
          "hardwareProfile": {
            "dynamicMemoryConfig": {
              "maximumMemoryMb": null,
              "minimumMemoryMb": null,
              "targetMemoryBuffer": null
            },
            "memoryMb": 2000,
            "processors": 2,
            "vmSize": "Custom"
          },
          "httpProxyConfig": null,
          "instanceView": {
            "vmAgent": {
              "statuses": [
                {
                  "code": "ProvisioningState/succeeded",
                  "displayStatus": "Connected",
                  "level": "Info",
                  "message": "Connection with mocguestagent was succesfully reestablished",
                  "time": "2024-06-24T18:32:41+00:00"
                }
              ],
              "vmConfigAgentVersion": "v0.18.0-4-gd54376b0"
            }
          },
          "networkProfile": {
            "networkInterfaces": []
          },
          "osProfile": {
            "adminPassword": null,
            "adminUsername": "azureuser",
            "computerName": "testvm001",
            "linuxConfiguration": {
              "disablePasswordAuthentication": false,
              "provisionVmAgent": false,
              "provisionVmConfigAgent": true,
              "ssh": {
                "publicKeys": null
              }
            },
            "windowsConfiguration": {
              "enableAutomaticUpdates": null,
              "provisionVmAgent": false,
              "provisionVmConfigAgent": true,
              "ssh": {
                "publicKeys": null
              },
              "timeZone": null
            }
          },
          "provisioningState": "Succeeded",
          "resourceUid": null,
          "securityProfile": {
            "enableTpm": false,
            "securityType": null,
            "uefiSettings": {
              "secureBootEnabled": true
            }
          },
          "status": {
            "errorCode": "",
            "errorMessage": "",
            "powerState": "Running",
            "provisioningStatus": null
          },
          "storageProfile": {
            "dataDisks": [],
            "imageReference": {
              "id": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.AzureStackHCI/galleryImages/WinImage-26tdJUIS",
              "resourceGroup": "<Resource group name>"
            },
            "osDisk": {
              "id": null,
              "osType": "Windows"
            },
            "vmConfigStoragePathId": "/subscriptions/<Subscription ID>/resourceGroups/<Resource group name>/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage2-guid"
          },
          "vmId": "<guid>"
        },
        "resourceGroup": "<Resource group name>",
        "systemData": {
          "createdAt": "2024-06-24T01:29:06.594266+00:00",
          "createdBy": "<guid>",
          "createdByType": "Application",
          "lastModifiedAt": "2024-06-24T18:35:18.206280+00:00",
          "lastModifiedBy": "<guid>",
          "lastModifiedByType": "Application"
        },
        "type": "microsoft.azurestackhci/virtualmachineinstances"
      }
    }
    ```

</details>

## Delete a VM

Follow these steps in the Azure portal of your Azure Stack HCI system to remove a VM.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that you wish to remove from your system.

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Delete**, then select **Yes**. 

    You are now prompted to confirm the deletion. Select **Yes**. Verify the VM is removed.

    Note that when a VM is deleted, all the resources associated with the VM are not deleted. For example, the data disks or the network interfaces associated with the VM are not deleted. You need to locate and delete these resources separately.

    :::image type="content" source="./media/manage-arc-virtual-machines/delete-virtual-machine-warning.png" alt-text="Screenshot of warning when deleting VM." lightbox="./media/manage-arc-virtual-machines/delete-virtual-machine-warning.png":::

1. You can now go to the resource group where this VM was deployed. You can see that the VM is removed from the list of resources in the resource group. You may need to select the option to **Show hidden types** to view the resources associated with this VM that were not deleted.

    :::image type="content" source="./media/manage-arc-virtual-machines/locate-network-interfaces-data-disks-deleted-virtual-machine.png" alt-text="Screenshot of hidden types resources associated with a virtual machine." lightbox="./media/manage-arc-virtual-machines/locate-network-interfaces-data-disks-deleted-virtual-machine.png":::

  Locate the associated resources such as the network interfaces and data disks, and delete them.

## Change cores and memory

Follow these steps in the Azure portal of your Azure Stack HCI system to change cores and memory.

1. Go to your Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. From the list of VMs in the right pane, select and go to the VM whose cores and memory you want to modify.

1. Under **Settings**, select **Size**. Edit the **Virtual processor count** or **Memory (MB)** to change the cores and memory size for the VM. Only the memory size can be changed. The memory type can't be changed once a VM is created.

   :::image type="content" source="./media/manage-arc-virtual-machines/change-cores-memory.png" alt-text="Screenshot of Size page for a VM." lightbox="./media/manage-arc-virtual-machines/change-cores-memory.png":::

## Next steps

- [Manage Arc VM resources such as data disks and network interfaces](./manage-arc-virtual-machine-resources.md)