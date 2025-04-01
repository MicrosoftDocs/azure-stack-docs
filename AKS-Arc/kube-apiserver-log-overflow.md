---
title: Known issue with disk space exhaustion on the control plane VMs due to accumulation of kube-apiserver audit logs
description: Known issue with disk space exhaustion on the control plane VMs due to accumulation of kube-apiserver audit logs
ms.topic: troubleshooting
author: sethmanheim
ms.author: sethm
ms.date: 04/01/2025
ms.reviewer: abha

---

# Disk space exhaustion on the control plane VMs due to accumulation of kube-apiserver audit logs

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

## Symptoms

If you're running kubectl commands and facing issues, you may see errors like:

```output
kubectl get ns
Error from server (InternalError): an error on the server ("Internal Server Error: \"/api/v1/namespaces?limit=500\": unknown") has prevented the request from succeeding (get namespaces)
```

When you SSH into the control plane VM, you may notice that your control plane VM has run out of disk space, specifically on the /dev/sda2 partition. This is due to the accumulation of kube-apiserver audit logs in the /var/log/kube-apiserver directory, which can consume ~90GB of disk space.

```
clouduser@moc-laiwyj6tly6 [ /var/log/kube-apiserver ]$ df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        4.0M     0  4.0M   0% /dev
tmpfs           3.8G   84K  3.8G   1% /dev/shm
tmpfs           1.6G  179M  1.4G  12% /run
tmpfs           4.0M     0  4.0M   0% /sys/fs/cgroup
/dev/sda2        99G   99G     0 100% /
tmpfs           3.8G     0  3.8G   0% /tmp
tmpfs           769M     0  769M   0% /run/user/1002
clouduser@moc-laiwyj6tly6 [ /var/log/kube-apiserver ]$ sudo ls -l /var/log/kube-apiserver|wc -l
890
clouduser@moc-laiwyj6tly6 [ /var/log/kube-apiserver ]$ sudo du -h /var/log/kube-apiserver
87G     /var/log/kube-apiserver
```

The issue occurs because the `--audit-log-maxbackup value is set to 0`. This setting allows the audit logs to accumulate without any limit, eventually filling up the disk. 

## Mitigation

To resolve the issue temporarily, you will need to manually clean up the old audit logs. Follow the steps below:

- SSH into the control plane virtual machine (VM) of your AKSArc cluster.
- Remove the old audit logs from the /var/log/kube-apiserver folder.
- If you have multiple control plane nodes, you will need to repeat this process on each control plane VM.

[SSH into the control plane VM]() and navigate to the kube-apiserver logs directory:

```bash
cd /var/log/kube-apiserver
```

Remove the old audit log files:

```bash
rm audit-*.log
```

Exit the SSH session:

```bash
exit
```

## Next steps

[Known issues in AKS enabled by Azure Arc](aks-known-issues.md)
