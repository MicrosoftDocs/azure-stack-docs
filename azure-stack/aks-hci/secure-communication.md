---
title: Secure communication between control plane nodes for  Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: Learn how to secure communication between in-cluster components.
author: mattbriggs
ms.topic: how-to
ms.date: 05/11/2022
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: aathipsa

# Intent: As an IT Pro, I want to learn how use certificates to secure communication between in-cluster components on my AKS on Azure Stack HCI and Windows Server deployment.
# Keyword: control plane nodes secure communication certificate revocation

---

# Secure communication with certificates  

Certificates are used to build secure communication between in-cluster components. Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server provides zero-touch, out-of-the-box provisioning, and management of certificates for built-in Kubernetes components. 

## Certificates and CAs

AKS on Azure Stack HCI and Windows Server generates and uses the following certificates and Certificate Authorities (CAs): 

**Cluster CA**:
  - The API server has a Cluster CA, which signs certificates for one-way communication from the API server to `kubelet`.
  - Each `kubelet` also creates a Certificate Signing Request (CSR), which is signed by the Cluster CA, for communication from the kubelet to the API server.
  - The etcd key value store has a certificate signed by the Cluster CA for communication from etcd to the API server. 

**etcd CA**:
- The etcd key value store has an etcd CA that signs certificates to authenticate and authorize data replication between etcd replicas in the cluster.

**Front Proxy CA**
- The Front Proxy CA secures communication between the API server and the extension API server.

### Certificate provisioning 

Certificate provisioning for kubelets is done using [TLS bootstrapping](https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet-tls-bootstrapping/). For all other certificates, use YAML-based key and certificate creation. 

- The certificates are stored at /etc/kubernetes/pki
- The keys are RSA 4096, EcdsaCurve: P384 

> [!NOTE]
> The root certificates are valid for 10 years. All other non-root certificates are short-lived and valid for four days.

### Certificate renewal and management

Non-root certificates are automatically renewed. All control plane certificates for Kubernetes are managed except for the following certificates:

- Kubelet server certificate 
- Kubeconfig client certificate 

As a best security practice, it's recommended that you use [Active Directory single sign-in](./ad-sso.md) for user authentication.

## Certificate revocation
Revocation should be a rare incident and applied at the time of certificate renewal. 

Once you have the serial number of the certificate you would like to revoke, use Kubernetes Custom Resource for defining and persisting revocation information. Each revocation object can consist of one or more revocation entries.  

To perform a revocation, use one of the following:
- Serial number 
- Group 
- DNS name 
- IP address  

A _notBefore_ time can be specified to revoke only certificates that are issued before a certain timestamp. If a _notBefore_ time is not specified, all existing and future certificates matching the revocation will be revoked. 

> [!NOTE]
> Revocation for `kubelet` server certificate is currently not available.

As long as the revocation was performed using a serial number, you can use the `Repair-AksHciClusterCerts` PowerShell command described below to get your cluster into a working state. If revocation was performed using other fields, make sure to specify _notBefore_ time so you can recover your cluster using the `Repair-AksHciClusterCerts` command. 

```Console
apiVersion: certificates.microsoft.com/v1 
kind: RenewRevocation 
metadata: 
  name: my-renew-revocation 
  namespace: kube-system 
spec: 
  description: My list of renew revocations 
  revocations: 
  - description: Revoked certificates by serial number 
    kind: serialnumber 
    notBefore: "2020-04-17T17:22:05Z" 
    serialNumber: 77fdf4b1033b387aaace6ce1c18710c2 
  - description: Revoked certificates by group 
    group: system:nodes 
    kind: Group 
  - description: Revoked certificates by DNS 
    dns: kubernetes.default.svc. 
    kind: DNS 
  - description: Revoked certificates by DNS Suffix 
    dns: .cluster.local 
    kind: DNS 
  - description: Revoked certificates by IP 
    ip: 170.63.128.124 
    kind: IP 
```

## Troubleshoot and maintenance

Refer to the following scripts and documentation for logging and monitoring:

- [Logging](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Logging)
- [Monitoring](https://github.com/microsoft/AKS-HCI-Apps/tree/main/Monitoring#certs-and-keys-monitoring)

### Renew certificates for worker nodes

For worker nodes, failed certificate renewals are logged by the *certificate-renewal-worker* pod. If the certificate renewal continues to fail on a worker node and the certificates expire, the node will be removed and a new worker node created in its place. 

Here's an example of viewing the logs for the pod with the prefix *certificate-renewal-worker*: 

```powershell
kubectl.exe --kubeconfig .\testcluster-kubeconfig -n=kube-system get pods 
```

```Output
NAME                                           READY   STATUS             RESTARTS   AGE 
… 
certificate-renewal-worker-6f68k               1/1     Running            0          6d 
```

To get the logs from the certificate renewal pod:

```powershell
kubectl.exe --kubeconfig .\testcluster-kubeconfig -n=kube-system logs certificate-renewal-worker-6f68k
```

### Renew certificates for control plane nodes

For control plane nodes, failed certificate renewals are logged by the certificate-renewal-controller pod. If certificates expire on a control plane node, it may eventually become unreachable by other nodes. If all control plane nodes enter this state, the cluster will become inoperable due to a TLS failure. You can confirm whether the cluster has entered this state by trying to access it using `kubectl`, and then verifying that the connection has failed if there's an error message related to expired x509 certificates. 

Here's an example of viewing the logs for the pod with the prefix *certificate-renewal-controller*:
```powershell
kubectl.exe --kubeconfig .\testcluster-kubeconfig -n=kube-system get pods 
```

```Output
NAME                                           READY   STATUS             RESTARTS   AGE 
… 
certificate-renewal-controller-2cdmz               1/1     Running            0          6d 
```

To get the logs from the certificate renewal pod:

```powershell
kubectl.exe --kubeconfig .\testcluster-kubeconfig -n=kube-system logs certificate-renewal-controller-2cdmz
```

Control plane nodes can’t be recreated like worker nodes, but you can use the **Repair-AksHciClusterCerts** module to help fix errors related to expired certificates. If the cluster begins to fail due to expired certificates, run the command as shown below: 

```powershell
Repair-AksHciClusterCerts -Name mytargetcluster 
```

If the cluster becomes unreachable via `kubectl`, you can find the logs in the `/var/log/pods` folder.

## Next steps

In this how-to guide, you learned how to provision and manage certificates. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).