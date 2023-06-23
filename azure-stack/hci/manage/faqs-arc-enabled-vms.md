---
title: Azure Arc VM management FAQs (preview)
description: Find answers to the frequently asked questions (FAQs) about Azure Arc VM management (preview).
author: alkohli
ms.topic: reference
ms.date: 05/24/2023
ms.author: alkohli
ms.reviewer: ksurjan
---

# Azure Arc VM management FAQs (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article answers some frequently asked questions (FAQs) about Azure Arc VMs running on Azure Stack HCI clusters.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Can Azure Kubernetes Service on Azure Stack HCI and Windows Server and Azure Arc Resource Bridge co-exist on the same Azure Stack HCI cluster?

Yes. Azure Kubernetes Service on Azure Stack HCI and Windows Server and VM provisioning from the Azure portal can be deployed on the same Arc-enabled Azure Stack HCI cluster. This requires deploying the AKS-HCI management cluster first and then Arc Resource Bridge. In this configuration, uninstalling Azure Kubernetes Service from Azure Stack HCI cluster will also remove Arc Resource Bridge.

## Can I use SDN for Azure Stack HCI VMs created from the Azure portal?
  
SDN is currently not supported for VMs created from the Azure portal.

## My environment doesn't support DNS or Active Directory updates, how can I successfully deploy Arc Resource Bridge?

If you can't enable dynamic DNS updates in your DNS environment, you must pre-create records in the Active Directory and the DNS. You can create a generic cluster service in Active Directory with the name `ca-cloudagent` (or a name of your choice), but don't exceed 32 characters in length. You also need to create an associated DNS record pointing to the FQDN of the generic cluster service with the provided `cloudservicecidr` address. More details on the steps in this process can be found in the [Failover Clustering article](/windows-server/failover-clustering/prestage-cluster-adds). Use the Active Directory object in the following command to complete the installation.
   ```PowerShell
   Set-MocConfig -workingDir $csv_path\ResourceBridge  -vnet $vnet -imageDir $csv_path\imageStore -skipHostLimitChecks -cloudConfigLocation $csv_path\cloudStore -catalog aks-hci-stable-catalogs-ext -ring stable -clusterRoleName "ca-cloudagent" -CloudServiceIP $CloudServiceIP
   ```
If you hit an error “This typically indicates an issue happened while registering the resource name as a computer object with the  domain controller and/or the DNS server. Please check the domain controller and DNS logs for related error messages.” while running “Install-Moc”, please also follow the instructions above.

## Is there a fee to use Arc management for VMs on Azure Stack HCI cluster?

VM management for Azure Stack HCI from the Azure control plane doesn't have any additional fees. Some VM extensions may have a fee.

## Can I use the same name for gallery image projections and will the existing VMs use the new image?

Two images with the same name will result in errors at the time of creating them. This is true for other resources as well, such as virtual networks, virtual hard disks etc. An updated image won't change existing VMs that were using it. A copy of the VM image is created at the time VM creation.

## How can I delete a gallery image?

Gallery images and all other entities can be removed from CLI or from the Azure portal. [See examples here](uninstall-arc-resource-bridge.md).

## If I delete a gallery image would all the VMs also get deleted which are deployed?

Deleting a gallery image doesn't affect the VMs that were created using that gallery image. The VMs won't be able to show the image name in the VM details.

## If I reinstall the Arc Resource Bridge will the VMs also be redeployed?

If an Arc Resource Bridge is deleted, then management through the Azure control plane (portal, Az CLI etc.) will be unavailable. The VMs will remain on the cluster and are only manageable through on-premises tools (Windows Admin Center, PowerShell etc.).

Re-deploying an Arc Resource Bridge won't enable Arc management of existing VMs. However, all new VMs created using the new Resource Bridge can be managed from the Azure control plane.

## What should I do if the deployment of Arc Resource Bridge didn't succeed?

See the [Troubleshoot and debug](troubleshoot-arc-enabled-vms.md) article for common errors. If you're redeploying Arc Resource Bridge, make sure to clean up the previous deployment completely by following the [Uninstall procedure](uninstall-arc-resource-bridge.md).

## What should I do if I unregister and re-register an Azure Stack HCI cluster after Arc VM Management is deployed?

If you unregister and re-register your Azure Stack HCI cluster after deploying Arc VM Management, you need to update the Kubernetes extension by using the following command:

```azurecli
az k8s-extension update --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --configuration-settings HCIClusterID=$hciClusterId
```

## Next steps

- [VM provisioning through Azure portal on Azure Stack HCI (preview)](azure-arc-vm-management-overview.md).
