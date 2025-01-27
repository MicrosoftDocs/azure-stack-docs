---
title: System requirements and support matrix for AKS enabled by Azure Arc on VMware (preview)
description: Learn about system requirements and the support matrix for AKS enabled by Azure Arc on VMware.
ms.date: 09/16/2024
ms.topic: conceptual
author: sethmanheim
ms.author: sethm
ms.reviewer: leslielin
ms.lastreviewed: 09/16/2024

ms.custom: references_regions

---

# System requirements and support matrix (preview)

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

This article describes the system requirements for setting up AKS enabled by Azure Arc on VMware, and the support matrix. For an overview of AKS Arc on VMware, [see the overview article](aks-vmware-overview.md).

## Arc-enabled VMware vSphere requirements

To use the AKS Arc on VMware preview, you must first onboard [Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/overview) by connecting vCenter to Azure through the [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview), with the Kubernetes Extension for AKS Arc operators installed. If you already completed this step, you can proceed with the AKS Arc on VMware requirements.

### Support matrix

The support matrix for Arc-enabled VMware vSphere is documented in the [Support matrix for Azure Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/support-matrix-for-arc-enabled-vmware-vsphere) requirements article.

### Plan deployment

For the prerequisites to onboard Arc-enabled VMware vSphere, see [Quickstart: Connect VMware vCenter Server to Azure Arc by using the helper script](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script).

### Required input

A typical onboarding process that uses the script takes 30 minutes. During this process, you are prompted for the details specified in [Inputs for the script to deploy Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script#inputs-for-the-script).

## AKS enabled by Azure Arc on VMware requirements

This section describes the requirements for deploying AKS enabled by Azure Arc on VMware.

### VMware vCenter requirements

Before you deploy AKS on VMware, you must set up a few things in VMware vCenter. After that, you deploy the AKS clusters in the same resource pool, VM folder, and datastore in which you deployed the Arc Resource Bridge.

#### Entitlement

You need a designated VMware administration user for the AKS clusters. This user should have the following permissions:

- This role can read all inventory, deploy, and update virtual machines (VMs) to all the resource pools (or clusters), networks, and virtual machine templates that you plan to use with AKS Arc on VMware.

#### Resource pool

In this preview release, the Arc Resource Bridge and the target clusters share a resource pool. To set this up, create a resource pool for the Arc Resource Bridge and the target cluster(s) with the following minimum specifications:

| Cluster type                  | Memory  | vCPUs | Storage  |
|-------------------------------|--------|-------|---------|
| Arc Resource Bridge           | 16 GB  | 4     | 100 GB  |
| Target cluster control plane  |  8 GB  | 4     | 100 GB  |
| Target cluster worker node    |  8 GB  | 4     | 100 GB  |

For information about supported VM size options, see the [AKS Arc on VMware scale requirements](aks-vmware-scale-requirements.md).

> [!NOTE]
> In the previous version of Arc Resource Bridge, there was a known issue in which the VM size was deployed with incorrect specifications. This issue was resolved in the Arc Resource Bridge version 1.1.0 and later releases. [See this article](/azure/azure-arc/resource-bridge/upgrade) to upgrade your Arc Resource Bridge. For more information, see the [Arc Resource Bridge release notes](https://github.com/Azure/ArcResourceBridge/releases). To understand the full context of this issue, see the [known issues in AKS enabled by Azure Arc on VMware](aks-vmware-known-issues.md).
> For more information about support size options, see the [AKS Arc on VMware scale requirements](aks-vmware-scale-requirements.md). For known issues, see [troubleshooting/known issues](aks-vmware-known-issues.md).

#### VM folder and VM templates

You should create a folder for VM templates, to store the Arc Resource Bridge and CBL Mariner Linux VM templates that are used to create AKS on VMware clusters.

## Supported Kubernetes version

In this preview release, you can only deploy the same Kubernetes version that the Arc Resource Bridge supports. You can find the Arc Resource Bridge version in the Azure portal under **Azure Arc > Management > Resource Bridge**. To determine the corresponding Kubernetes version, see [What's new with Azure Arc resource bridge](/azure/azure-arc/resource-bridge/release-notes).

## Custom location

If you choose to **Enable Kubernetes Service on VMware [preview]** when you **Connect vCenter to Azure** [from the Azure portal](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script), a custom location with the prefix **AKS-**, and a default namespace, are created for you to deploy AKS on VMware. If you enable the Azure Kubernetes Service on VMware using the [Azure CLI process](aks-vmware-install-kubernetes-extension.md), you can specify the name of the custom location of your choice with the default namespace.

> [!IMPORTANT]
> You must use the **default** namespace.

To view the custom location namespace, use the `az customlocation show` command:

```azurecli  
az customlocation show -g $customLocationResourceGroupName -n $customLocationName
```

If your custom location was not created with the **default** namespace, use the following command to delete the custom location and create a custom location with the default namespace. For more information about how to manage custom locations, see [Create and manage custom locations](/azure/azure-arc/kubernetes/custom-locations).

Delete the custom location:

```azurecli  
az customlocation delete -g $customLocationResourceGroupName -n $customLocationName
```

Create the custom location with the **default** namespace:

```azurecli  
az customlocation create -g $customLocationResourceGroupName -n $customLocationName --cluster-extension-ids $clusteraksExtensionId --host-resource-id $ArcApplianceResourceId --namespace "default"
```

## Azure requirements

You must connect to your Azure account:

```azurecli  
az login --use-device-code
```

For more information, see [Connect to Azure using the Azure CLI](/cli/azure/authenticate-azure-cli-interactively).

### AKS deployment checklist

| Parameter                     | Parameter details  |
|-------------------------------|--------------------|
| `$aad_Group_Id`                 | The ID of a group whose members manage the target cluster. This group should also have owner permissions on the resource group containing the custom location and target cluster.  |
| `$appliance_Name`               | Name of the Arc Resource Bridge created to connect vCenter with Azure.  |
| `$custom_Location`              | Custom location name or ID. If you choose to **Enable Kubernetes Service on VMware [Preview]** when you **Connect vCenter to Azure** from the Azure Portal per [this progress](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script), a custom location with the prefix "AKS-" and the default namespace is created for you to deploy AKS on VMware. If you **Enable Kubernetes Service on VMware [Preview]** by following the [Azure CLI process](aks-vmware-install-kubernetes-extension.md), you can specify the name of the custom location of your choice with the default namespace. IMPORTANT: The "default" namespace must be used.  |
| `$resource_Group`               | Resource Group name or ID for deploying the Arc Resource Bridge.  |
| `$network_name`                 | Name of the VMware network resource enabled in Azure.  |
| `$control_plane_ip`             | The control plane IP for your target cluster. This control plane IP must be reserved/excluded in DHCP and different from the Arc Resource Bridge IP address.  |

### Microsoft Entra permissions, role and access level

You must have sufficient permissions to register an application with your Microsoft Entra tenant. To check that you have sufficient permissions, follow these steps:

- Go to the Azure portal and select [Roles and administrators](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RolesAndAdministrators) under Microsoft Entra ID to check your role.
- If your role is **User**, you must make sure that non-administrators can register applications.
- To check if you can register applications, go to [User settings](https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/UserSettings) under the Microsoft Entra service to check if you have permission to register an application.

If the app registrations setting is set to **No**, only users with an administrator role can register these types of applications. To learn about the available administrator roles and the specific permissions in Microsoft Entra ID that are given to each role, see [Microsoft Entra built-in roles](/azure/active-directory/roles/permissions-reference#all-roles). If your account is assigned the **User** role, but the app registration setting is limited to admin users, ask your administrator either to assign you one of the administrator roles that can create and manage all aspects of app registrations, or to enable users to register apps.

If you don't have permissions to register an application and your admin can't give you these permissions, the easiest way to deploy AKS is to ask your Azure admin to create a service principal with the right permissions. Admins can check the following section to learn how to create a service principal.

### Azure resource group

You must have an Azure resource group in the supported regions before registration.

> [!WARNING]
> If your Azure resource group is not in a supported region, a deployment failure occurs.

#### Supported regions

You can use the AKS Arc on VMware preview in the following supported regions:

- East US
- Australia East
- India Central
- Southeast Asia
- West Europe
- Japan East
- Canada Central

> [!WARNING]
> The AKS Arc on VMware preview currently supports cluster creation exclusively within the specified Azure regions. If you attempt to deploy in a region outside of this list, a deployment failure occurs.

#### Data residency

AKS Arc on VMware doesn't store or process customer data outside the region in which the customer deploys the service instance.

## Next steps

- If you already connected vCenter to Azure Arc and want to add the AKS extension, see the [Quickstart: Deploy an AKS cluster using Azure CLI](aks-vmware-quickstart-deploy.md).
- If your vCenter is not connected to Azure Arc and you want to add the AKS extension, see the [Quickstart: Connect VMware vCenter Server to Azure Arc using the helper script](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script).
