---
title: Use Container Storage Interface (CSI) file drivers in AKS hybrid
description: Learn how to use Container Storage Interface (CSI) drivers to manage files in AKS hybrid.
author: sethmanheim
ms.topic: how-to
ms.date: 10/24/2022
ms.author: sethm 
ms.lastreviewed: 01/14/2022
ms.reviewer: abha

# Intent: As an IT Pro, I want to learn how to use Container Storage Interface (CSI) drivers in AKS hybrid.
# Keyword: container storage interface drivers, CSI drivers

---

# Use Container Storage Interface (CSI) file drivers in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to use Container Storage Interface (CSI) drivers for files to mount Server Message Block (SMB) or NFS shares when multiple nodes need concurrent access to the same storage volume in AKS hybrid.<!--New lead, to describe the scope of the article and distinguish this article from "Use the AKS hybrid disk Container Storage Interface (CSI) drivers." Current intros, identical, will run under "Overview" title.-->

[!INCLUDE [aks-hybrid-description](includes/aks-hybrid-description.md)]

## Overview of CSI in AKS hybrid

[!INCLUDE [csi-in-aks-hybrid-overview](includes/csi-in-aks-hybrid-overview.md)]

<!--REPLACES THIS TEXT: The disk and file Container Storage Interface (CSI) drivers in AKS hybrid are [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md)-compliant. 

The CSI is a standard for exposing arbitrary block and file storage systems to containerized workloads on Kubernetes. By adopting and using CSI, AKS hybrid can write, deploy, and iterate plug-ins to expose new storage systems or improve existing ones in Kubernetes without having to touch the core Kubernetes code and wait for its release cycles.

The CSI storage driver support in AKS hybrid allows you to use:

- AKS hybrid disks to create a Kubernetes *DataDisk* resource. These disks are mounted as *ReadWriteOnce*, so they're only available to a single pod at a time. To learn more, see [using disk Container Storage Interface (CSI) drivers](./container-storage-interface-disks.md). 

- AKS hybrid files to mount an SMB or NFS share to pods. These files are mounted as *ReadWriteMany*, so you can share data across multiple nodes and pods. They can also be mounted as *ReadWriteOnce* based on the PVC specification. This topic covers how to use the AKS hybrid files Container Storage Interface (CSI) drivers.-->

## Use files persistent volumes using _ReadWriteMany_ CSI drivers

If multiple nodes need concurrent access to the same storage volumes in AKS hybrid, you can use CSI drivers for files to mount SMB or NFS shares as *ReadWriteMany*. The SMB or NFS shares must be provisioned in advance.

### Use SMB drivers

1. Deploy the driver using the following [Install-AksHciCsiSmb](./reference/ps/install-akshcicsismb.md) PowerShell command: 

   ```powershell
   Install-AksHciCsiSmb -clusterName mycluster
   ```

2. Create Kubernetes secrets to store the credentials required to access SMB shares by running the following command:

   ```console
   kubectl create secret generic smbcreds --from-literal username=USERNAME --from-literal password="PASSWORD"
   add --from-literal domain=DOMAIN-NAME for domain support
   ```

3. Create a storage class using `kubectl` to create a new SMB storage class with the following manifest:

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
         createSubDir: "false"  # optional: create a sub dir for new volume
      reclaimPolicy: Retain  # only Retain is supported
      volumeBindingMode: Immediate
      mountOptions:
        - dir_mode=0777
        - file_mode=0777
        - uid=1001
        - gid=1001
      ```  

### Use NFS drivers

1. Deploy the driver using the following [Install-AksHciCsiNfs](./reference/ps/install-akshcicsinfs.md) PowerShell command:

   ```powershell
   Install-AksHciCsiNfs -clusterName mycluster
   ```

2. Create an NFS storage class using the following manifest:

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

Use the following PowerShell commands to uninstall either the SMB or NFS drivers:

```powershell
Uninstall-AksHciCsiSMB -clusterName <clustername>
Uninstall-AksHciCsiNFS -clusterName <clustername>
```

## Next steps

[Use the disk Container Storage Interface drivers](./container-storage-interface-disks.md)