---
title: Azure Operator Nexus PKI implementation
description: Learn how Azure Operator Nexus uses public key infrastructure to protect platform control plane, services, and operator-facing interfaces.
author: lb4368
ms.author: lborgmeyer
ms.service: azure-operator-nexus
ms.topic: conceptual
ms.date: 09/30/2025
ms.custom: template-concept
---

# Azure Operator Nexus PKI implementation

Azure Operator Nexus deploys an in-cluster public key infrastructure (PKI) on every cluster. Each cluster maintains a self-signed certificate authority (CA) hierarchy that never leaves the site, ensuring that cryptographic trust is isolated per deployment.  This isolation minimizes the impact of any compromise.

## PKI architecture overview

- **Per-cluster trust boundary**: Each Azure Operator Nexus instance provisions an independent root CA. There's no shared CA across clusters, and certificates are never reused between sites.
- **Self-contained issuance**: Certificate issuance and renewal are performed locally inside the Kubernetes control plane. Certificates aren't requested from external or centralized PKI services.
- **Purpose-specific issuers**: Dedicated intermediate issuers sign certificates for distinct workloads (human-operated consoles versus internal services) to minimize privilege scope.

This architecture allows customers to operate in disconnected or semi-connected environments while retaining the benefits of TLS authentication, encryption in transit, and cryptographic auditability.

## Certificate management with cert-manager

Azure Operator Nexus relies on [cert-manager](https://cert-manager.io/) to automate certificate lifecycles:

1. **Issuer objects** are defined for each certificate purpose (interface access, internal services, and other specialized workloads).
2. **Certificate resources** request leaf certificates from the appropriate issuer, including Subject Alternative Names (SANs) required by platform components.
3. **Renewal automation** is driven by cert-manager, which renews leaf certificates before expiration and rotates them transparently across the platform.
4. **Secret distribution** to pods and services is handled through Kubernetes secrets and projected volumes, ensuring workloads always present valid certificates.

Because all issuance is in-cluster, operators retain full control over the trust fabric without depending on external connectivity or services.

## Issuer hierarchy

Two primary issuers are deployed per cluster to align with the different trust requirements of human-operated interfaces and service workloads.

### Interface issuer

- **Purpose**: Signs TLS certificates used by resource interfaces, including bare metal machine BMC/iDRAC and storage appliance management endpoints.
- **Scope**: Only certificates for management endpoints.
- **Rotation**: cert-manager renews interface certificates before expiration, ensuring access remains encrypted without manual intervention.

### Infra issuer

- **Purpose**: Issues certificates for platform microservices and service-to-service APIs.
- **Scope**: Internal webhook services and other platform workloads.
- **Rotation**: Certificates are automatically rotated in coordination with workload rolling updates to maintain uninterrupted service availability.

## Certificate usage scenarios

| Scenario | Issuer | Example consumers | Trust objective |
|----------|--------|-------------------|-----------------|
| Out-of-band management access | Interface | iDRAC consoles, storage appliance dashboards, break-glass interfaces | Provide encrypted and authenticated human access paths |
| Platform control plane traffic | Infra | admission webhooks, platform microservices | Ensure encrypted service-to-service communication and mutual authentication |

## Viewing CA certificates and hashes

Operators often need to verify that TLS endpoints present the expected CA certificate and fingerprint. Azure Operator Nexus exposes this information through both the Azure portal and Azure CLI.

> [!NOTE]
> Viewing CA certificate metadata requires the Azure Operator Nexus 2025-09-01 API version or later.

### Bare metal machine resources

1. **Azure portal**:
   1. Navigate to **Azure Operator Nexus \> Bare metal machines**.
   2. Open the target bare metal machine resource.
   3. Select **JSON View**.
   4. Select 2025-09-01 or later API version/
   5. Review the CA certificate **value** and the **SHA-256 hash** of the issuer that signed the active TLS certificate.

2. **Azure CLI**:
   ```azurecli
   az networkcloud baremetalmachine show \
     --subscription <subscription>
     --resource-group <cluster-managed-resource-group> \
     --name <bareMetalMachineName> \
     --query "caCertificate" \
     --output tsv
   ```
   This command returns the PEM-encoded CA certificate that issued the current TLS certificate and its SHA-256 hash (fingerprint) for quick comparison against trusted values.

### Storage appliance resources

1. **Azure portal**:
   1. Navigate to **Azure Operator Nexus \> Storage appliances**.
   2. Open the target storage appliance resource.
   3. Select **JSON View**.
   4. Select 2025-09-01 or later API version/
   5. Review the CA certificate **value** and the **SHA-256 hash** of the issuer that signed the active TLS certificate.

2. **Azure CLI**:
   ```azurecli
   az networkcloud storageappliance show \
     --subscription <subscription>
     --resource-group <cluster-managed-resource-group> \
     --name <storageApplianceName> \
     --query "caCertificate" \
     --output tsv
   ```
