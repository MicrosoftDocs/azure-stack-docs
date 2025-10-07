---
title: Guest attestation for Trusted launch for Azure Local VMs (preview)
description: Learn how guest attestation works for Trusted launch for Azure Local VMs (preview).
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 10/07/2025
---

# Guest attestation for Trusted launch for Azure Local VMs (preview)

Applies to: Azure Local 2509 and later

This article describes how to enable guest attestation for Trusted launch for Azure Local virtual machines (VMs) enabled by Azure Arc. Guest attestation, also called boot integrity verification, is a new feature you can preview starting with Azure Local version 2509. 

Guest attestation allows you to verify if the VM started in a well-known good state – specifically, verify integrity of the entire boot chain. This helps detect any unexpected changes to the boot chain (firmware, OS boot loader, and drivers) so you can take corrective actions if the boot chain is compromised. 

When you enable guest attestation, an Azure Arc extension called guest attestation extension is deployed on the VM. The guest attestation extension interacts with Azure services such as Microsoft Azure Attestation service to support boot integrity verification. 

## Prerequisites

1. Your Azure Local instance must be running version 2509 or later release. 

1. Register the `Microsoft.Attestation` resource provider with your subscription – see [Register your Azure Local machines with Azure Arc and assign permissions for deployment](../deploy/deployment-arc-register-server-permissions.md?abs=powershell#azure-prerequisites). This must be done before setting up a new Azure Local instance or updating an existing Azure Local instance. This only needs to be done once per subscription. 

## Enable guest attestation using Azure portal

You can enable guest attestation when you create a Trusted launch Azure Local VM via Azure portal.  

1. See [Create Azure Local virtual machines enabled by Azure Arc](create-arc-virtual-machines.md?&tabs=azureportal) for general instructions to create a Trusted launch Azure Local VM via Azure portal.

    > [!NOTE]
    > Specify a network interface when creating the VM. Trusted launch requires a network connection for attestation purposes. 

1. When creating the VM, choose security type as **Trusted launch**. 

1. Select **Configure security features** and choose **Integrity monitoring (preview)**. 

    :::image type="content" source="./media/trusted-launch-guest-attestation/create-vm.png" alt-text="Screenshot of security features section." lightbox="./media/trusted-launch-guest-attestation/create-vm.png":::

1. Once the virtual machine is created, you can view guest attestation status via the VM resource page:

    :::image type="content" source="./media/trusted-launch-guest-attestation/vm-properties.png" alt-text="Screenshot of the create virtual machine page." lightbox="./media/trusted-launch-guest-attestation/vm-properties.png":::

    | Guest attestation status | Meaning |
    | -- | -- |
    | Healthy | Secure boot is enabled, virtual TPM is enabled, and boot integrity verification was successful. |
    | Unhealthy | Secure boot isn't enabled, or virtual TPM isn't enabled, or boot integrity monitoring was not successful. |
    | Unknown | Status isn't available, likely due to transient network or communication issues. |

    The timestamp shows when guest attestation status was last verified. The status normally refreshes about every eight hours. If the VM is in a running state but the guest attestation status hasn't updated in over eight hours, this may be because the guest attestation extension stopped working or possibly the VM is compromised.

1. You can view the status of the guest attestation extension on the **Extensions** page: 

    :::image type="content" source="./media/trusted-launch-guest-attestation/vm-extensions.png" alt-text="Screenshot showing the VM extensions page." lightbox="./media/trusted-launch-guest-attestation/vm-extensions.png":::

    If the status of the guest attestation extension is reported as **Failed**, you can view the detailed error status:

    :::image type="content" source="./media/trusted-launch-guest-attestation/vm-error-details.png" alt-text="Screenshot showing the error details page." lightbox="./media/trusted-launch-guest-attestation/vm-error-details.png":::

## Enable guest attestation using Azure CLI

### Create a Trusted launch VM

See [Create Azure Local virtual machines enabled by Azure Arc](create-arc-virtual-machines.md?&tabs=azurecli) for general instructions to create a Trusted launch Azure Local VM via Azure CLI. 

### Install the Azure Arc guest attestation extension 

1.  Construct the extension settings as follows: 

    - Attestation service endpoint 
    - Relying party service endpoint 
    - Cluster id 
    - Azure Active Directory (AAD) tenant id 

    > [!NOTE]
    > Extension settings are case-sensitive. 

    Here's an example:

    ```azurecli
    # To connect to your Azure Local via Az CLI, see https://learn.microsoft.com/en-us/azure/azure-local/azure-arc-vm-management-prerequisites.md?#azure-command-line-interface-cli-requirements.

    # Login to Azure
    [host1]: PS C:\Users\HCIDeploymentUser> az login --use-device-code

    # Set your subscription
    [host 1]: PS C:\Users\HCIDeploymentUser> az account set --subscription "<subscription>"
    
    [host1]: PS C:\Users\HCIDeploymentUser> $cluster = (az stack-hci cluster show --subscription  "<subscription>" --resource-group "<resource group>" --name "<Azure Local instance name>") | ConvertFrom-Json

    [host1]: PS C:\Users\HCIDeploymentUser> $extensionSettings= '"{\"AttestationConfig\":{\"MaaSettings\":{\"maaEndpoint\": \"' + $cluster.isolatedVmAttestationConfiguration.attestationServiceEndpoint + '\",\"maaTenantName\": \"DUMMY_Tenant_NewConfig\"},\"AscSettings\":{\"ascReportingEndpoint\": \"' + $cluster.isolatedVmAttestationConfiguration.relyingPartyServiceEndpoint + '\",\"ascReportingFrequency\": \"4H\"},\"AzureStackSettings\":{\"clusterId\": \"'+$cluster.id+'\",\"clusterAadTenantId\": \"'+$cluster.aadTenantId+'\"},\"useCustomToken\": \"true\",\"disableAlerts\": \"false\",\"isAzureStack\": \"true\"}}"'
    ```

1.  Deploy the Azure Arc guest attestation extension as shown in this example: 

    ```azurecli
    # Check if "connectedmachine" extension is already installed. If it is installed, it should be in the extensions list in the output of the command below. 

    [host1]: PS C:\Users\HCIDeploymentUser> az version 

    { 

    "azure-cli": "2.60.0", 
    "azure-cli-core": "2.60.0", 
    "azure-cli-telemetry": "1.1.0", 
    "extensions": { 
      "aksarc": "1.2.20", 
      "arcappliance": "1.1.1", 
      "connectedk8s": "1.6.2", 
      "customlocation": "0.1.3", 
      "k8s-extension": "1.4.5", 
      "stack-hci-vm": "1.1.11" 
    } 
    } 

 
    # if "connectedmachine" extension is not already installed, add "connectedmachine" extension. 

    [host1]: PS C:\Users\HCIDeploymentUser> az extension add --name connectedmachine 

    az : WARNING: Default enabled including preview versions for extension installation now. Disabled in May 2024. Use '--allow-preview true' 

    to enable it specifically if needed. Use '--allow-preview false' to install stable version only. 

    + CategoryInfo          : NotSpecified: (WARNING: Defaul... version only. :String) [], RemoteException 

    + FullyQualifiedErrorId : NativeCommandError 

    WARNING: The installed extension 'connectedmachine' is in preview. 

 
    # Run the command below to install the Azure Arc guest attestation extension. 

    [host1]: PS C:\Users\HCIDeploymentUser> az connectedmachine extension create --subscription "<subscription>" --resource-group "<resource group>" --machine-name "<name of VM>" --location "<Azure region of your Azure Local instance>" --publisher "Microsoft.Azure.Security.WindowsAttestation" --type "GuestAttestation" --name "GuestAttestation" --settings $extensionSettings --enable-automatic-upgrade 

    { 

    "id": "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.HybridCompute/machines/myTVM/extensions/GuestAttestation", 

    "location": "eastus", 
    "name": "GuestAttestation", 
    "properties": { 

        "autoUpgradeMinorVersion": false, 
        "enableAutomaticUpgrade": true, 
        "instanceView": { 

        "name": "GuestAttestation", 

        "status": { 

            "code": "0", 

            "level": "Information", 

            "message": "Extension Message: Command: None, Status: has successfully completed. Details: [ Running Extension:GuestAttestation Operation:None ], Enable: Starting Enabling Step., Enable: Starting Client. Details: AszAttestationClient -a https://clustxxxxxxxxxx.eus2e.attest.azure.net -r https://dp.stackhci.azure.com/eastus/igvmAttestation/validxxxxx -l C:\\ProgramData\\GuestConfig\\extension_logs\\Microsoft.Azure.Security.WindowsAttestation.GuestAttestation -h C:\\Packages\\Plugins\\Microsoft.Azure.Security.WindowsAttestation.GuestAttestation\\1.0.1.30\\status\\HeartBeat.Json -s C:\\Packages\\Plugins\\Microsoft.Azure.Security.WindowsAttestation.GuestAttestation\\1.0.1.30\\status\\0.status -e events -v 1.0.1.30 -c /subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.AzureStackHCI/clusters/<cluster name> -d xxxxxxxx--a9d3-41ba-88c3-796a643e3edd, Enable: Client : AszAttestationClient Started Successfully" 

        }, 

        "type": "GuestAttestation", 
        "typeHandlerVersion": "1.0.1.30" 

        }, 

        "provisioningState": "Succeeded", 
        "publisher": "Microsoft.Azure.Security.WindowsAttestation", 
        "settings": { 

        "AttestationConfig": { 

            "AscSettings": { 

            "ascReportingEndpoint": "https://dp.stackhci.azure.com/eastus/igvmAttestation/validxxxxx", 

            "ascReportingFrequency": "4H" 

            }, 

            "AzureStackSettings": { 

            "clusterAadTenantId": "xxxxxxxx--a9d3-41ba-88c3-796a643e3edd", 

            "clusterId": "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.AzureStackHCI/clusters/<cluster name>" 

            }, 

            "MaaSettings": { 

            "maaEndpoint": "https://clustxxxxxxxxxxxxx.eus2e.attest.azure.net", 

            "maaTenantName": "My_Tenant_NewConfig" 

            }, 

            "disableAlerts": "false", 
            "isAzureStack": "true", 
            "useCustomToken": "true" 

        } 

        }, 

        "type": "GuestAttestation", 
        "typeHandlerVersion": "1.0.1.30" 

    }, 

    "resourceGroup": "<resource group name>", 
    "type": "Microsoft.HybridCompute/machines/extensions" 

    } 
    ```

### View guest attestation status 

You can view the guest attestation status using Azure CLI. The guest attestation status is listed by the following properties in the output:

- `"attestSecureBootEnabled": "Enabled",`
- `"attestationCertValidated": "Valid",`
- `"bootIntegrityValidated": "Valid",`
- `"errorMessage": null,`
- `"healthStatus": "Healthy",` 
- `"linuxKernelVersion": "0",` 
- `"provisioningState": "Succeeded",` 

Here’s the Az CLI command and sample output:

```azurecli
# To connect to your Azure Local via Az CLI, see https://learn.microsoft.com/en-us/azure/azure-local/azure-arc-vm-management-prerequisites.md?#azure-command-line-interface-cli-requirements.

# Login to Azure
PS C:\WINDOWS\system32>az login --use-device-code

# Set your subscription
[host 1]: PS C:\Users\HCIDeploymentUser> az account set --subscription "<subscription>"

# Get list of installed extensions 
PS C:\WINDOWS\system32>az version 
{ 

  "azure-cli": "2.61.0", 
  "azure-cli-core": "2.61.0", 
  "azure-cli-telemetry": "1.1.0", 
  "extensions": { 

    "azure-iot": "0.11.0", 
    "stack-hci-vm": "1.1.11" 
  } 

} 


# If “stack-hci-vm” extension version isn't “1.1.12” or above, install the latest version of the extension. 

PS C:\WINDOWS\system32>az extension remove --name stack-hci-vm 
PS C:\WINDOWS\system32>az extension add --name stack-hci-vm 
PS C:\WINDOWS\system32>az version 

{ 

  "azure-cli": "2.61.0", 
  "azure-cli-core": "2.61.0", 
  "azure-cli-telemetry": "1.1.0", 
  "extensions": { 

    "azure-iot": "0.11.0", 
    "stack-hci-vm": "1.1.14" 

  } 

} 

 
# Check guest attestation status. 

PS C:\WINDOWS\system32> az stack-hci-vm show --subscription "<subscription id>" --resource-group "<resource group name>" --name "<name of VM>" 

Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus 
{ 

  "attestationStatus": { 

    "id": "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.HybridCompute/machines/<vm name>/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default/AttestationStatus/default", 

    "name": "default", 
    "properties": { 

      "attestSecureBootEnabled": "Enabled", 
      "attestationCertValidated": "Valid", 
      "bootIntegrityValidated": "Valid", 
      "errorMessage": null, 
      "healthStatus": "Healthy", 
      "linuxKernelVersion": "0", 
      "provisioningState": "Succeeded", 
      "timestamp": "6/12/2024 8:49:33 PM" 
    }, 

    "resourceGroup": "<resource group name>", 
    "systemData": { 

      "createdAt": "2024-06-12T20:49:33.545606+00:00", 
      "createdBy": "1412d89f-b8a8-4111-b4fd-e82905cbd85d", 
      "createdByType": "Application", 
      "lastModifiedAt": "2024-06-12T20:49:33.545606+00:00", 
      "lastModifiedBy": "1412d89f-b8a8-4111-b4fd-e82905cbd85d", 
      "lastModifiedByType": "Application" 
    }, 

    "type": "microsoft.azurestackhci/virtualmachineinstances/attestationstatus" 
  }, 

  "virtualmachineinstance": { 

    "extendedLocation": { 

      "name": "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.ExtendedLocation/customLocations/cluster-customlocation", 

      "type": "CustomLocation" 

    }, 

    "id": "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.HybridCompute/machines/myTVM/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default", 

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

        "memoryMb": 2048, 
        "processors": 4, 
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
              "message": "Successfully established connection with mocguestagent", 
              "time": "2024-06-12T20:10:37+00:00" 

            }, 

            { 

              "code": "ProvisioningState/succeeded", 
              "displayStatus": "Connected", 
              "level": "Info", 
              "message": "New mocguestagent version detected 'v0.14.0-2-g5c6a4b32'", 
              "time": "2024-06-12T20:10:36+00:00" 

            } 

          ], 

          "vmConfigAgentVersion": "v0.14.0-2-g5c6a4b32" 

        } 

      }, 

      "isHydration": null, 
      "networkProfile": { 
        "networkInterfaces": [ 

          { 

            "id": "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.AzureStackHCI/networkinterfaces/my-nic-static", 

            "resourceGroup": "<resource group name>" 

          } 

        ] 

      }, 

      "osProfile": { 

        "adminPassword": null, 
        "adminUsername": "<admin username>", 
        "computerName": "<computer name>", 
        "linuxConfiguration": { 

          "disablePasswordAuthentication": null, 
          "provisionVmAgent": true, 
          "provisionVmConfigAgent": true, 
          "ssh": { 

            "publicKeys": null 
          } 

        }, 

        "windowsConfiguration": { 

          "enableAutomaticUpdates": null, 
          "provisionVmAgent": true, 
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

        "enableTpm": true, 
        "securityType": "TrustedLaunch", 
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

          "id": "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/microsoft.azurestackhci/marketplacegalleryimages/Win11EntMulti23H2", 

          "resourceGroup": "<resource group name>" 

        }, 

        "osDisk": { 

          "id": null, 
          "osType": "Windows" 
        }, 

        "vmConfigStoragePathId": "/subscriptions/<subscription id>/resourceGroups/<resource group name>/providers/Microsoft.AzureStackHCI/storagecontainers/UserStorage2-7d0fdc06e3ef4c9d808ceb31379d0916"      }, 

      "vmId": "85b8849e-2965-4c82-b7fa-637796d22199" 

    }, 

    "resourceGroup": "<resource group name>", 

    "systemData": { 

      "createdAt": "2024-06-12T20:03:18.171067+00:00", 
      "createdBy": "69be5a28-cb3c-4916-98c3-7e4ab37a83e0", 
      "createdByType": "Application", 
      "lastModifiedAt": "2024-06-12T20:11:55.649002+00:00", 
      "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05", 
      "lastModifiedByType": "Application" 
    }, 

    "type": "microsoft.azurestackhci/virtualmachineinstances" 

  } 

} 
```

## Guidance

1. Guest attestation support relies on and uses the Microsoft Azure Attestation service. When guest attestation is supported, the Azure Local instance is automatically set up with a Microsoft Azure Attestation service endpoint and an attestation policy. For guest attestation to work properly, outbound network access to the Microsoft Azure Attestation service is required. Make sure that relevant policies or network firewall rules for your Azure Local instance allow outbound network access to the Microsoft Azure Attestation service. 

    For example, when using Azure Policy to manage the security posture of your Azure Local instance, you shouldn't disallow resource type `Microsoft.Attestation/attestationProviders`. For more information, see [Disallow resource types in your cloud environment](/azure/governance/policy/tutorials/disallowed-resources). Specifically, the policy `Microsoft.Attestation/attestationProviders/publicNetworkAccess` must be enabled. 

2. There may be situations when you need to manually set up a Microsoft Azure Attestation service endpoint and an associated attestation policy for your Azure Local instance. For example, you may accidentally delete the attestation provider (and the associated attestation policy) from the resource group of your Azure Local instance. Another example, you want to update the attestation policy to use a different attestation root certificate that was provisioned into your Azure Local instance.

    In such situations, you can run the following to manually set up a Microsoft Azure Attestation service endpoint and an attestation policy for your Azure Local instance. The commands below must be run from one of the machines (nodes) in your Azure Local instance.
 
```azurecli
$ececlient = create-ececlusterserviceclient

# Create MAA Endpoint
$guid= Invoke-ActionPlanInstance -RolePath Cloud\Infrastructure\ArcIntegration -ActionType "CreateMAAEndpointCloud" -EceClient $ececlient

# Validate MAA Endpoint creation succeeded
Get-ActionPlanInstance -ActionPlanInstanceId $guid -ececlient:$ececlient

# Create MAA Policy
$guid= Invoke-ActionPlanInstance -RolePath Cloud\Infrastructure\ArcIntegration -ActionType "CreateMAAPolicyCloud" -EceClient $ececlient

# Validate MAA Policy creation succeeded
Get-ActionPlanInstance -ActionPlanInstanceId $guid -ececlient:$ececlient

# Sample expected output
# InstanceID: <guid>
# ActionPlanName:
# ActionTypeName: CreateMAAEndpointCloud
# RolePath: Cloud\Infrastructure\ArcIntegration
# ProgressAsXml: <xml-object>
# Status: Completed
# ...
```

## Next steps

- [Manage Trusted launch for Azure Local VM guest state protection key](trusted-launch-vm-import-key.md).