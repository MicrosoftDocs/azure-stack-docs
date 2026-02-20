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

# NAKS Certificate Expiration and Upgrade Requirements

## Overview

Nexus Azure Kubernetes Service (NAKS) clusters rely on Transport Layer Security (TLS) certificates to secure communication between control plane components. These certificates have a validity period of **one year** from the time of cluster creation or last upgrade. If a NAKS cluster isn't upgraded within this timeframe, the certificates will expire, resulting in a complete cluster outage.

This document explains:
- The impact of certificate expiration on your NAKS cluster
- Why regular upgrades are critical for maintaining cluster health
- How to monitor certificate expiration dates
- Recovery procedures if certificates expire

**Critical Takeaway:** Regular NAKS cluster upgrades (at least once per year) automatically refresh all certificates and prevent expiration-related outages.

## Understanding NAKS Certificates

### What Certificates Are Used?

NAKS control plane components use TLS certificates to secure communication between:
- **etcd cluster members** (peer-to-peer communication)
- **kube-apiserver and etcd** (client-server communication)
- **kube-apiserver** (serving API requests)
- **kubelet and kube-apiserver** (node-to-control-plane communication)
- **Controller managers and schedulers** (control plane components)

These certificates are generated during cluster creation and are managed by the NAKS platform using `kubeadm`.

### Certificate Lifecycle

All NAKS control plane certificates are valid for **365 days** (one year). After this period:
- Certificates become invalid and are rejected during TLS handshakes
- Components can't establish secure connections
- The cluster becomes nonfunctional

### How Upgrades Refresh Certificates

When you perform a NAKS cluster upgrade:
1. The upgrade process automatically renews all control plane certificates
2. New certificates are generated with a fresh one-year validity period
3. All control plane components are restarted to use the new certificates
4. Certificate expiration risk is eliminated for another year

This automatic renewal happens transparently during every upgrade, whether it's a minor or patch version update.

## Impact of Certificate Expiration

When NAKS certificates expire, the cluster experiences cascading failures that result in a complete outage.

### Failure Sequence

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

### Example Error Messages

When certificates expire, you may see errors similar to:

```
tls: failed to verify certificate: x509: certificate has expired or is not yet valid
current time 2026-02-17T00:52:43Z is after 2026-02-13T19:10:43Z
```

```
remote error: tls: bad certificate
```

These errors indicate that TLS validation is rejecting expired certificates.

## Prevention: Regular Upgrades (Recommended Practice)

**The best way to avoid certificate expiration issues is to upgrade your NAKS cluster regularly.**

### Upgrade Frequency Recommendation

**Upgrade your NAKS cluster at least once every 365 days.**

We strongly recommend more frequent upgrades (quarterly or when new versions are released) to:
- Maintain a healthy certificate lifecycle
- Receive important security patches
- Benefit from bug fixes and performance improvements
- Stay within the supported NAKS version range
- Avoid multiple version jumps that may complicate upgrades

### Benefits of Regular Upgrades

Beyond certificate renewal, regular upgrades provide:

- **Security:** Patches for known vulnerabilities in Kubernetes and NAKS components
- **Stability:** Bug fixes that improve cluster reliability
- **Support:** Access to the latest support and troubleshooting resources
- **Features:** New capabilities and improvements in NAKS
- **Compliance:** Alignment with Azure Operator Nexus best practices

### Why Skipping Upgrades Is Risky

Clusters that aren't upgraded for over one year face multiple risks:
- **Certificate expiration** leading to complete outage
- **Unpatched security vulnerabilities** exposing the cluster to threats
- **Accumulation of bugs** that could have been fixed
- **Limited support options** as older versions become unsupported
- **Difficult recovery** requiring manual intervention

## Monitoring Certificate Expiration

### Checking Certificate Expiration Status

To check when your NAKS control plane certificates expire, SSH to a control plane node and run:

```bash
sudo kubeadm certs check-expiration
```

This command displays all control plane certificates and their expiration dates.

### Sample Output

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

### What to Look For

- **RESIDUAL TIME**: The time remaining before certificate expiration
- **Warning threshold**: If residual time is less than 90 days, plan an upgrade soon
- **Critical threshold**: If residual time is less than 30 days, upgrade immediately
- **Expired certificates**: If any certificate shows negative residual time or is past its expiration date, follow the recovery procedure below

### Automated Monitoring

Consider implementing automated monitoring that:
- Regularly checks certificate expiration dates
- Alerts administrators when certificates are within 90 days of expiration
- Triggers planning for cluster upgrades

## Recovery Procedure (When Certificates Have Expired)

**Warning:** This procedure should only be used if certificates have already expired and the cluster is experiencing an outage. If your certificates are still valid, perform a regular NAKS upgrade instead.

**Important Notes:**
- This is a manual, low-level procedure that requires direct access to control plane nodes
- It should be performed during a maintenance window
- Backup all critical data before proceeding
- This procedure must be performed on **each control plane node, one at a time**

### Prerequisites

- SSH access to all control plane nodes
- Root or sudo privileges on control plane nodes
- Basic knowledge of Kubernetes control plane components
- A maintenance window for cluster downtime

### Recovery Steps

Perform these steps on **one control plane node at a time**, starting with any control plane node, then moving to the next.

#### Step 1: SSH to the First Control plane Node

Connect to the first control plane node via SSH.

#### Step 2: Check Certificate Expiration

Verify the current state of certificates:

```bash
sudo kubeadm certs check-expiration
```

You should see expired certificates with negative residual time.

#### Step 3: Backup the PKI Directory

Create a backup of the existing certificates in case recovery is needed:

```bash
sudo cp -r /etc/kubernetes/pki /etc/kubernetes/pki.backup.$(date +%Y%m%d-%H%M%S)
```

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

# Wait for containers to stop (kubelet will terminate them)
sleep 20

# Move manifests back to the manifests directory
sudo mv /root/kube-apiserver.yaml /etc/kubernetes/manifests/
sudo mv /root/kube-controller-manager.yaml /etc/kubernetes/manifests/
sudo mv /root/kube-scheduler.yaml /etc/kubernetes/manifests/
sudo mv /root/etcd.yaml /etc/kubernetes/manifests/
```

Kubelet automatically detects the manifests and start new containers with the renewed certificates.

#### Step 7: Verify Control Plane Components

Wait 2-3 minutes for components to fully start, then verify they're running:

```bash
sudo crictl ps | grep -E 'kube-apiserver|etcd|kube-controller-manager|kube-scheduler'
```

You should see all four components running.

#### Step 8: Repeat on Remaining Control Plane Nodes

**Important:** Complete steps 1-7 on the next control plane node. Don't proceed to multiple nodes simultaneously. Wait for each node to fully recover before moving to the next.

For clusters with three control plane nodes:
1. Complete renewal on node 1 (done above)
2. Complete renewal on node 2
3. Complete renewal on node 3

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

Check etcd cluster health from a control plane node:

```bash
kubectl get pods -n kube-system -l component=etcd
```

### Post-Recovery Actions

After successfully recovering from certificate expiration:

1. **Verify certificate renewal:** Run `sudo kubeadm certs check-expiration` on all control plane nodes to confirm certificates are renewed

2. **Update monitoring:** If you don't have automated certificate monitoring, implement it now

3. **Plan regular upgrades:** Create a schedule to upgrade your NAKS cluster at least annually, preferably more frequently

4. **Document the incident:** Record what happened and how you recovered for future reference

5. **Review upgrade policies:** Ensure your organization has processes to prevent this situation from recurring

## Summary

Certificate expiration in NAKS clusters is a preventable issue that can cause complete cluster outages. By following these best practices, you can maintain a healthy, secure, and functional cluster:

- **Upgrade regularly:** Perform NAKS upgrades at least once per year, preferably quarterly
- **Monitor proactively:** Check certificate expiration dates and set up automated alerts
- **Understand the impact:** Know that certificate expiration causes cascading failures
- **Have a recovery plan:** Keep this document handy in case manual recovery is needed
- **Stay supported:** Keep your cluster within supported NAKS versions

Regular upgrades are the single most important action you can take to prevent certificate expiration and maintain a healthy NAKS cluster.

