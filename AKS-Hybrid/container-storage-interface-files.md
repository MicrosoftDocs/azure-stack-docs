---
title: Use Container Storage Interface (CSI) file drivers in AKS enabled by Azure Arc
description: Learn how to use Container Storage Interface (CSI) drivers to manage files in AKS Arc.
author: sethmanheim
ms.topic: how-to
ms.date: 08/20/2024
ms.author: sethm 
ms.lastreviewed: 01/14/2022
ms.reviewer: abha

# Intent: As an IT Pro, I want to learn how to use Container Storage Interface (CSI) drivers in AKS Arc.
# Keyword: container storage interface drivers, CSI drivers

---

# Use Container Storage Interface (CSI) file drivers in AKS enabled by Azure Arc

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)], AKS on Azure Stack HCI 23H2

This article describes how to use Container Storage Interface (CSI) drivers for files to mount a Server Message Block (SMB) or NFS shares when multiple nodes need concurrent access to the same storage volume in AKS enabled by Azure Arc.

## Overview of CSI in AKS Arc

[!INCLUDE [csi-in-aks-hybrid-overview](includes/csi-in-aks-hybrid-overview.md)]

## Use files persistent volumes using ReadWriteMany CSI drivers

If multiple nodes need concurrent access to the same storage volumes in AKS Arc, you can use CSI drivers for files to mount SMB or NFS shares as **ReadWriteMany**. You must provision the SMB or NFS shares in advance.

### Use SMB drivers

### [AKS on Azure Stack HCI 23H2](#tab/23H2)

1. Make sure the SMB driver is deployed. The SMB CSI driver is installed by default when you create a Kubernetes cluster using the Azure portal or the `az aksarc create` command. If you create a Kubernetes cluster by using `--disable-smb-driver`, you must enable the SMB driver on this cluster using the `az aksarc update` command:

   ```azurecli
   az aksarc update -n $aksclustername -g $resource_group --enable-smb-driver
   ```

### [AKS on Azure Stack HCI 22H2 and Windows Server](#tab/22H2)

1. Make sure the SMB driver is deployed. Deploy the driver using the following [Install-AksHciCsiSmb](./reference/ps/install-akshcicsismb.md) PowerShell command:

   ```powershell
   Install-AksHciCsiSmb -clusterName mycluster
   ```

---

1. Create Kubernetes secrets to store the credentials required to access SMB shares by running the following command:

   ```console
   kubectl create secret generic smbcreds --from-literal username=$username --from-literal password=$password --from-literal domain=$domain
   ```

1. Create a storage class using `kubectl` to create a new SMB storage class with the following manifest:

   ```yaml
   apiVersion: storage.k8s.io/v1
   kind: StorageClass
   metadata:
     name: smb-csi
   provisioner: smb.csi.akshci.com
   parameters:
      source: \\smb-server\share
      csi.storage.k8s.io/node-stage-secret-name: "smbcreds"
      csi.storage.k8s.io/node-stage-secret-namespace: "default"
   reclaimPolicy: Retain  # only Retain is supported
   volumeBindingMode: Immediate
   mountOptions:
     - dir_mode=0777
     - file_mode=0777
     - uid=1001
     - gid=1001
   ```  

### Use NFS drivers

### [AKS on Azure Stack HCI 23H2](#tab/23H2)

1. Make sure the NFS driver is deployed. The NFS CSI driver is installed by default when you create a Kubernetes cluster using the Azure portal or the `az aksarc create` command. If you create a Kubernetes cluster by using `--disable-nfs-driver`, you must enable the the NFS driver on this cluster using the `az aksarc update` command:

   ```azurecli
   az aksarc update -n $aksclustername -g $resource_group --enable-nfs-driver
   ```

### [AKS on Azure Stack HCI 22H2 and Windows Server](#tab/22H2)

1. Deploy the driver using the following [Install-AksHciCsiSmb](./reference/ps/install-akshcicsismb.md) PowerShell command:

   ```powershell
   Install-AksHciCsiNfs -clusterName mycluster
   ```

---

1. Create an NFS storage class using the following manifest:

      ```yaml
      apiVersion: storage.k8s.io/v1
      kind: StorageClass
      metadata:
        name: nfs-csi
      provisioner: nfs.csi.akshci.com
      parameters:
        server: nfs-server.default.svc.cluster.local # NFS server endpoint
        share: / # NFS share path
      reclaimPolicy: Retain
      volumeBindingMode: Immediate
      mountOptions:
        - hard
        - nfsvers=4.1
      ```

### To uninstall SMB or NFS drivers

### [AKS on Azure Stack HCI 23H2](#tab/23H2)

Use the following Azure CLI commands to uninstall either the SMB or NFS drivers:

```azurecli
az aksarc update -n $aksclustername -g $resource_group --disable-smb-driver
az aksarc update -n $aksclustername -g $resource_group --disable-nfs-driver
```

### [AKS on Azure Stack HCI 22H2 and Windows Server](#tab/22H2)

Use the following PowerShell commands to uninstall either the SMB or NFS drivers:

```powershell
Uninstall-AksHciCsiSMB -clusterName <clustername>
Uninstall-AksHciCsiNFS -clusterName <clustername>
```

---

## Next steps

- [Use the disk Container Storage Interface drivers](./container-storage-interface-disks.md)
