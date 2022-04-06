---
title: Use the AKS on Azure Stack HCI Files Container Storage Interface (CSI) drivers
description: Learn how to use the AKS on Azure Stack HCI Files Container Storage Interface (CSI) drivers.
author: mattbriggs
ms.topic: how-to
ms.date: 04/16/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha
# Intent: As an IT Pro, I need to understand and learn about the benefits of using CSI drivers in my AKS on Azure Stack HCI deployment.
# Keyword: CSI drivers container storage
---

# Use the AKS on Azure Stack HCI Files Container Storage Interface (CSI) drivers

The AKS on Azure Stack HCI disk and file Container Storage Interface (CSI) drivers are [CSI specification](https://github.com/container-storage-interface/spec/blob/master/spec.md)-compliant drivers used by AKS on Azure Stack HCI.

The CSI is a standard for exposing arbitrary block and file storage systems to containerized workloads on Kubernetes. By adopting and using CSI, AKS on Azure Stack HCI can write, deploy, and iterate plug-ins to expose new storage systems or improve existing ones in Kubernetes without having to touch the core Kubernetes code and wait for its release cycles.

The CSI storage driver support on AKS on Azure Stack HCI allows you to use:

- AKS on Azure Stack HCI disks to create a Kubernetes *DataDisk* resource. These disks are mounted as *ReadWriteOnce*, so they're only available to a single pod at a time. To learn more, see [using disk Container Storage Interface (CSI) drivers](./container-storage-interface-disks.md). 

- AKS on Azure Stack HCI files to mount an SMB or NFS share to pods. These files are mounted as *ReadWriteMany*, so you can share data across multiple nodes and pods. They can also be mounted as *ReadWriteOnce* based on the PVC specification. This topic covers how to use the AKS on Azure Stack HCI files Container Storage Interface (CSI) drivers.

## Use AKS on Azure Stack HCI File persistent volumes using _ReadWriteMany_ CSI drivers

If multiple nodes need concurrent access to the same storage volume, you can use AKS on Azure Stack HCI File CSI drivers to mount SMB or NFS shares as *ReadWriteMany*. These drivers require that SMB or NFS shares are pre-provisioned.

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

3.  Create a storage class using `kubectl` to create a new SMB storage class with the following manifest:

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
