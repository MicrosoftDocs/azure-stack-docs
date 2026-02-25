---
title: Rotate NAKS certificates in Azure Operator Nexus
description: Learn how to monitor and rotate NAKS cluster certificates to prevent expiration-related outages in Azure Operator Nexus
author: rickbartra91
ms.author: rickbartra
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 02/20/2026
ms.custom: template-how-to-pattern
---

# NAKS certificate expiration and upgrade requirements

This article provides guidance on managing certificate lifecycles in Nexus Azure Kubernetes Service (NAKS) clusters to prevent expiration-related outages.

## Overview

Nexus Azure Kubernetes Service (NAKS) clusters rely on Transport Layer Security (TLS) certificates to secure communication between control plane components. These certificates have a validity period of **one year** from the time of cluster creation or last upgrade. If a NAKS cluster isn't upgraded within this timeframe, the certificates expire, resulting in a complete cluster outage.

This document explains:
- The impact of certificate expiration on your NAKS cluster
- Why regular upgrades are critical for maintaining cluster health
- How to monitor certificate expiration dates
- Recovery procedures if certificates expire

**Critical Takeaway:** Regular NAKS cluster upgrades (at least once per year) automatically refresh all certificates and prevent expiration-related outages.

## Understanding NAKS certificates

### What certificates are used?

NAKS control plane components use TLS certificates to secure communication between:
* **etcd cluster members** (peer-to-peer communication)
* **kube-apiserver and etcd** (client-server communication)
* **kube-apiserver** (serving API requests)
* **kubelet and kube-apiserver** (node-to-control-plane communication)
* **Controller managers and schedulers** (control plane components)

These certificates are generated during cluster creation and are managed by NAKS.

### Certificate lifecycle

All NAKS control plane certificates are valid for **365 days** (one year). After this period:
- Certificates become invalid and are rejected during TLS handshakes
- Components can't establish secure connections
- The cluster becomes nonfunctional

### How upgrades refresh certificates

When you perform a NAKS cluster upgrade:
* The upgrade process automatically renews all control plane certificates
* New certificates are generated with a fresh one-year validity period
* All control plane components are restarted to use the new certificates
* Certificate expiration risk is eliminated for another year

This automatic renewal happens transparently during every upgrade, whether it's a minor or patch version update.

## Impact of certificate expiration

When NAKS certificates expire, the cluster experiences cascading failures that result in a complete outage.

### Failure sequence

1. **etcd peer communication fails**
   - etcd nodes can't validate each other's certificates
   - TLS handshakes fail with errors like: `x509: certificate has expired or is not yet valid`
   - Raft consensus protocol breaks down

2. **etcd cluster becomes unhealthy**
   - Without peer communication, etcd can't maintain quorum
   - etcd members enter an unhealthy state
   - Data replication stops
   - Eventually, etcd becomes inoperable

3. **kube-apiserver loses connectivity to etcd**
   - kube-apiserver can't authenticate to etcd using expired certificates
   - API server can't read or write cluster state
   - All Kubernetes API operations fail

4. **Complete cluster outage**
   - `kubectl` commands fail
   - Workloads continue running but can't be managed or updated
   - New pods can't be scheduled
   - Services can't be created or modified
   - The cluster is effectively frozen

### Example error messages

When certificates expire, you may see errors similar to:

```
tls: failed to verify certificate: x509: certificate has expired or is not yet valid
current time 2026-02-17T00:52:43Z is after 2026-02-13T19:10:43Z
```

```
remote error: tls: bad certificate
```

These errors indicate that TLS validation is rejecting expired certificates.

## Prevention: regular upgrades (recommended practice)

**The best way to avoid certificate expiration issues is to upgrade your NAKS cluster regularly.**

### Upgrade frequency recommendation

**Upgrade your NAKS cluster at least once every 365 days.**

Regular upgrades provide multiple benefits:
- **Certificate renewal:** Automatically refreshes certificates, preventing expiration-related outages
- **Security:** Patches for known vulnerabilities in Kubernetes and NAKS components
- **Stability:** Bug fixes that improve cluster reliability
- **Support:** Ensures your cluster remains within supported NAKS versions with access to the latest troubleshooting resources
- **Simplified maintenance:** Avoids multiple version jumps that complicate upgrades

Clusters that skip upgrades for over one year risk complete outages, unpatched vulnerabilities, and difficult recovery requiring manual intervention.

## Monitoring certificate expiration

### Checking certificate expiration status

To check when your NAKS control plane certificates expire, SSH to a control plane node and run:

```bash
sudo kubeadm certs check-expiration
```

This command displays all control plane certificates and their expiration dates.

### Sample output

```
CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Feb 13, 2026 19:10 UTC   364d            ca                      no
apiserver                  Feb 13, 2026 19:10 UTC   364d            ca                      no
apiserver-etcd-client      Feb 13, 2026 19:10 UTC   364d            etcd-ca                 no
apiserver-kubelet-client   Feb 13, 2026 19:10 UTC   364d            ca                      no
controller-manager.conf    Feb 13, 2026 19:10 UTC   364d            ca                      no
etcd-healthcheck-client    Feb 13, 2026 19:10 UTC   364d            etcd-ca                 no
etcd-peer                  Feb 13, 2026 19:10 UTC   364d            etcd-ca                 no
etcd-server                Feb 13, 2026 19:10 UTC   364d            etcd-ca                 no
front-proxy-client         Feb 13, 2026 19:10 UTC   364d            front-proxy-ca          no
scheduler.conf             Feb 13, 2026 19:10 UTC   364d            ca                      no

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      Feb 11, 2035 19:10 UTC   9y              no
etcd-ca                 Feb 11, 2035 19:10 UTC   9y              no
front-proxy-ca          Feb 11, 2035 19:10 UTC   9y              no
```

### What to look for

- **RESIDUAL TIME**: The time remaining before certificate expiration
- **Warning threshold**: If residual time is less than 90 days, plan an upgrade soon
- **Critical threshold**: If residual time is less than 30 days, upgrade immediately
- **Expired certificates**: If any certificate shows negative residual time or is past its expiration date, follow the recovery procedure below

### Automated monitoring

Consider implementing automated monitoring that:
- Regularly checks certificate expiration dates
- Alerts administrators when certificates are within 90 days of expiration
- Triggers planning for cluster upgrades

## Recovery procedure (when certificates have expired)

> [!WARNING]
> This procedure should only be used if certificates have already expired and the cluster is experiencing an outage. If your certificates are still valid, perform a regular NAKS upgrade instead.

> [!NOTE]
> Important Notes:
> - This is a manual, low-level procedure that requires direct access to control plane nodes
> - It should be performed during a maintenance window
> - Backup all critical data before proceeding
> - This procedure must be performed on **each control plane node, one at a time**

### Prerequisites

- SSH access to all control plane nodes
- Root or sudo privileges on control plane nodes
- Basic knowledge of Kubernetes control plane components
- A maintenance window for cluster downtime

### Recovery steps

Perform these steps on **one control plane node at a time**, starting with any control plane node, then moving to the next.

#### Step 1: SSH to the First Control plane Node

Connect to the first control plane node via SSH.

#### Step 2: Check Certificate Expiration

Verify the current state of certificates:

```bash
sudo kubeadm certs check-expiration
```

You should see expired certificates with negative residual time, or certificates that show as `invalid`.

#### Step 3: Backup the PKI Directory

Create a backup of the existing certificates in case recovery is needed:

```bash
sudo cp -r /etc/kubernetes/pki /etc/kubernetes/pki.backup.$(date +%Y%m%d-%H%M%S)
```

> [!NOTE]
> This backup protects the entire PKI directory, which includes not only the expired certificates but also the Certificate Authority (CA) certificates and private keys. While expired certificates themselves can't restore cluster functionality, this backup serves as a safety net if the certificate renewal process encounters errors or corrupts critical CA files. If the renewal fails or causes issues, you can restore from this backup and retry the procedure or contact support for assistance.

Verify the backup was created:

```bash
ls -la /etc/kubernetes/pki.backup*
```

#### Step 4: Renew All Certificates

Renew all control plane certificates:

```bash
sudo kubeadm certs renew all
```

This command generates new certificates with fresh validity periods.

Verify that the certificates have been renewed successfully:

```bash
sudo kubeadm certs check-expiration
```

All certificates should now show approximately 364 days (one year) of residual time. If you see any certificates that still show expired or invalid status, don't proceed - investigate the renewal output for errors or contact support for assistance.

#### Step 5: Restart kubelet

Restart the kubelet service to pick up the new certificates:

```bash
sudo systemctl restart kubelet
```

#### Step 6: Force Static Pod Restart

The control plane components run as static pods and need to be restarted to use the new certificates. This is done by temporarily moving their manifests:

```bash
# Move manifests out of the manifests directory
sudo mv /etc/kubernetes/manifests/kube-apiserver.yaml /root/
sudo mv /etc/kubernetes/manifests/kube-controller-manager.yaml /root/
sudo mv /etc/kubernetes/manifests/kube-scheduler.yaml /root/
sudo mv /etc/kubernetes/manifests/etcd.yaml /root/
sudo mv /etc/kubernetes/manifests/kube-vip.yaml /root/

# Wait for containers to stop (kubelet will terminate them)
sleep 20

# Move manifests back to the manifests directory
sudo mv /root/kube-apiserver.yaml /etc/kubernetes/manifests/
sudo mv /root/kube-controller-manager.yaml /etc/kubernetes/manifests/
sudo mv /root/kube-scheduler.yaml /etc/kubernetes/manifests/
sudo mv /root/etcd.yaml /etc/kubernetes/manifests/
sudo mv /root/kube-vip.yaml /etc/kubernetes/manifests/
```

Kubelet automatically detects the manifests and start new containers with the renewed certificates.

#### Step 7: Verify Control Plane Components

Wait 2-3 minutes for components to fully start, then verify they're running:

```bash
sudo crictl ps | grep -E 'kube-apiserver|etcd|kube-controller-manager|kube-scheduler|kube-vip'
```

You should see all five components running.

> [!NOTE]
> **Optional: Clean up the backup**
>
> Now that you've confirmed the control plane components are running successfully with the renewed certificates, you can optionally remove the PKI backup created in Step 3:

```bash
sudo rm -rf /etc/kubernetes/pki.backup*
```

However, if you prefer extra caution, you may choose to keep the backup until all control plane nodes have been successfully renewed and the cluster is fully operational (after Step 9).

#### Step 8: Repeat on Remaining Control Plane Nodes

> [!IMPORTANT]
> Complete steps 1-7 on the next control plane node. Don't proceed to multiple nodes simultaneously. Wait for each node to fully recover before moving to the next.

Repeat steps 1-7 on each remaining control plane node until all nodes have been renewed.

#### Step 9: Verify Cluster Functionality

After renewing certificates on all control plane nodes, verify the cluster is operational:

```bash
kubectl get nodes
```

All nodes should be in `Ready` state.

Check control plane pods:

```bash
kubectl get pods -n kube-system
```

All control plane pods should be in `Running` state.

### Post-recovery actions

After successfully recovering from certificate expiration:

1. **Update monitoring:** If you don't have automated certificate monitoring, implement it now

2. **Plan regular upgrades:** Create a schedule to upgrade your NAKS cluster at least annually, preferably more frequently

3. **Document the incident:** Record what happened and how you recovered for future reference

4. **Review upgrade policies:** Ensure your organization has processes to prevent this situation from recurring

## Summary

Certificate expiration in NAKS clusters is a preventable issue that can cause complete cluster outages. By following these best practices, you can maintain a healthy, secure, and functional cluster:

- **Upgrade regularly:** Perform NAKS upgrades at least once per year, preferably quarterly
- **Monitor proactively:** Check certificate expiration dates and set up automated alerts
- **Understand the impact:** Know that certificate expiration causes cascading failures
- **Have a recovery plan:** Keep this document handy in case manual recovery is needed
- **Stay supported:** Keep your cluster within supported NAKS versions

Regular upgrades are the single most important action you can take to prevent certificate expiration and maintain a healthy NAKS cluster.

