---
title: Create Kubernetes clusters using Bicep
description: Learn how to create Kubernetes clusters in Azure Stack HCI using Bicep.
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 07/26/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: haojiehang
ms.lastreviewed: 07/24/2024

---

# Create Kubernetes clusters using Bicep

This article describes how to create Kubernetes clusters in Azure Stack HCI using Bicep. The workflow is as follows:

1. Create an SSH key pair
1. Create a Kubernetes cluster in Azure Stack HCI 23H2 using Bicep. By default, the cluster is Azure Arc-connected.
1. Validate the deployment and connect to the cluster.

## Before you begin

Before you begin, make sure you have the following prerequisites:

1. Get the following details from your on-premises infrastructure administrator:

   - Azure subscription ID: the Azure subscription ID that uses Azure Stack HCI for deployment and registration.
   - Custom location name or ID: the Azure Resource Manager ID of the custom location. The custom location is configured during the Azure Stack HCI cluster deployment. Your infrastructure admin should give you the Resource Manager ID of the custom location. This parameter is required in order to create Kubernetes clusters. You can also get the Resource Manager ID using `az customlocation show --name "<custom location name>" --resource-group <azure resource group> --query "id" -o tsv`, if the infrastructure admin provides a custom location name and resource group name.
   - Logical network name or ID: the Azure Resource Manager ID of the Azure Stack HCI logical network that was created following these steps. Your admin should give you the ID of the logical network. This parameter is required in order to create Kubernetes clusters. You can also get the Azure Resource Manager ID using `az stack-hci-vm network lnet show --name "<lnet name>" --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group in which the logical network was created.

1. Make sure you have the [latest version of Azure CLI](/cli/azure/install-azure-cli) on your development machine. You can also upgrade your Azure CLI version using `az upgrade`.
1. Download and install **kubectl** on your development machine. The Kubernetes command-line tool, **kubectl**, enables you to run commands against Kubernetes clusters. You can use **kubectl** to deploy applications, inspect and manage cluster resources, and view logs.

## Create an SSH key pair

To create an SSH key pair (same as Azure AKS), use the following procedure:

1. [Open a Cloud Shell session](https://shell.azure.com) in your browser.
1. Create an SSH key pair using the `az sshkey create` Azure CLI command or the `ssh-keygen` command:

   ```azurecli
   # Create an SSH key pair using Azure CLI
   az sshkey create --name "mySSHKey" --resource-group "myResourceGroup"
   ```

   Or, create an SSH key pair using `ssh-keygen`:

   ```bash  
   ssh-keygen -t rsa -b 4096
   ```

For more information about creating SSH keys, see [Create and manage SSH keys for authentication in Azure](/azure/virtual-machines/linux/create-ssh-keys-detailed).

## Update and review the Bicep scripts

This section shows the Bicep parameter and template files. These files are also available in an [Azure Quickstart template](https://github.com/Azure/azure-quickstart-templates).

### Bicep parameter file: aksarc.bicepparam

```bicep
using 'main.bicep'
param aksClusterName = 'aksarc-bicep-new'
param aksControlPlaneIP = 'x.x.x.x'
param sshPublicKey = 'ssh_public_key'
param hciLogicalNetworkName = 'lnet_name'
param hciCustomLocationName = 'cl_name'
param aksNodePoolOSType = 'Linux'
param aksNodePoolNodeCount = 1
```

### Bicep template file: main.bicep

```bicep
@description('The name of AKS Arc cluster resource')
param aksClusterName string
param location string = 'eastus'

// Default to 1 node CP
@description('The name of AKS Arc cluster control plane IP, provide this parameter during deployment')
param aksControlPlaneIP string
param aksControlPlaneNodeSize string = 'Standard_A4_v2'
param aksControlPlaneNodeCount int = 1

// Default to 1 node NP
param aksNodePoolName string = 'nodepool1'
param aksNodePoolNodeSize string = 'Standard_A4_v2'
param aksNodePoolNodeCount int = 1
@allowed(['Linux', 'Windows'])
param aksNodePoolOSType string = 'Linux'

@description('SSH public key used for cluster creation, provide this parameter during deployment')
param sshPublicKey string

// Build LNet ID from LNet name
@description('The name of LNet resource, provide this parameter during deployment')
param hciLogicalNetworkName string
resource logicalNetwork 'Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview' existing = {
  name: hciLogicalNetworkName
}

// Build custom location ID from custom location name
@description('The name of custom location resource, provide this parameter during deployment')
param hciCustomLocationName string
var customLocationId = resourceId('Microsoft.ExtendedLocation/customLocations', hciCustomLocationName) 

// Create the connected cluster. This is the Arc representation of the AKS cluster, used to create a Managed Identity for the provisioned cluster.
resource connectedCluster 'Microsoft.Kubernetes/ConnectedClusters@2024-01-01' = {
  location: location
  name: aksClusterName
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'ProvisionedCluster'
  properties: {
    agentPublicKeyCertificate: ''
    aadProfile: {
      enableAzureRBAC: false
    }
  }
}

// Create the provisioned cluster instance. This is the actual AKS cluster and provisioned on your HCI cluster via the Arc Resource Bridge.
resource provisionedClusterInstance 'Microsoft.HybridContainerService/provisionedClusterInstances@2024-01-01' = {
  name: 'default'
  scope: connectedCluster
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocationId
  }
  properties: {
    linuxProfile: {
      ssh: {
        publicKeys: [
          {
            keyData: sshPublicKey
          }
        ]
      }
    }
    controlPlane: {
      count: aksControlPlaneNodeCount
      controlPlaneEndpoint: {
        hostIP: aksControlPlaneIP
      }
      vmSize: aksControlPlaneNodeSize
    }
    networkProfile: {
      loadBalancerProfile: {
        count: 0
      }
      networkPolicy: 'calico'
    }
    agentPoolProfiles: [
      {
        name: aksNodePoolName
        count: aksNodePoolNodeCount
        vmSize: aksNodePoolNodeSize
        osType: aksNodePoolOSType
      }
    ]
    cloudProviderProfile: {
      infraNetworkProfile: {
        vnetSubnetIds: [
          logicalNetwork.id
        ]
      }
    }
    storageProfile: {
      nfsCsiDriver: {
        enabled: true
      }
      smbCsiDriver: {
        enabled: true
      }
    }
  }
}
```

The **Microsoft.HybridContainerService/provisionedClusterInstances** resource is defined in the Bicep file. If you want to explore more properties, [see the API reference](/azure/templates/microsoft.hybridcontainerservice/provisionedclusterinstances?pivots=deployment-language-bicep).

## Deploy the Bicep file

1. Save the Bicep file as **main.bicep** to your local computer.
1. Update the parameters defined in **aksarc.bicepparam** and save it to your local computer.
1. Deploy the Bicep file using Azure CLI:

   ```azurecli
   az deployment group create --name BicepDeployment --resource-group myResourceGroupName --template-file main.bicep –-parameters aksarc.bicepparam
   ```

## Validate the Bicep deployment and connect to the cluster

You can now connect to your Kubernetes cluster by running the `az connectedk8s proxy` command from your development machine. You can also use **kubectl** to see the node and pod status. Follow the same steps as described in [Connect to the Kubernetes cluster](aks-create-clusters-cli.md#connect-to-the-kubernetes-cluster).

## Next steps

[Create Kubernetes clusters using Azure CLI](aks-create-clusters-cli.md)
