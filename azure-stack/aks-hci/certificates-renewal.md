---
title: Certificate renewal and token refresh.
description: Learn about Certificate renewal and token refresh.
author: mattbriggs
ms.topic: article
ms.date: 05/31/2022
ms.author: mabrigg 
ms.lastreviewed: 05/31/2022
ms.reviewer: rbaziwane

# Intent: As an IT pro, I want to XXX so that XXX.
# Keyword: 

---

# Certificate renewal and token refresh

The Cloud agent in AKS on Azure Stack HCI is the service that is responsible for the underlying orchestration of other services. There are several services that communicate with the cloud agent, including:

-   Mocctl - This is an admin service with ultimate access to the cloudagent. If mocctl loses access to the cluster, we cannot access cloudagent for any repair.

-   Node agent -

-   Kva - Kubernetes Virtual Appliance, sometimes called the management cluster

-   KMS pod -

-   Cloud operator

-   Other (CAPH, Certificate Manager, CSI)

## Communicate with the cloud agent service

To communicate with the cloud agent service, each service requires an identity to be associated with it. This identity defines the Role Based Access Control (RBAC) rules associated with the service. Each identity consists of two entities:

-   A Token - Used for initial authentication, which returns a certificate

-   A Certificate - The certificate obtained from the above login process is used for authentication in any communication.

Each entity is valid for a specific period e.g., 60 days, at the end of which it expires. For continued access to the cloud agent service, each service requires the certificate to be renewed and the token refreshed.

Currently, not all services in AKS-HCI automatically renew their respective certificates or rotate their tokens. Services that automatically renew the certificate or rotate the tokens are currently doing the auto rotation and auto renewal. For services that do not have the capability to renew the certificate automatically, there is need to re-login using a token to continue access as shown in the table. Sometimes these services do not have a valid token and hence require manual refresh of the token.

AKS-HCI uses monthly upgrades to rotate any tokens that cannot be auto rotated. During this process, we ensure that token validity is set to 60 days (about 2 months) from the date that a customer upgraded. We have noticed a growing number of customers who are unable to perform upgrades (hence manually refresh tokens) within this 60-day window. The most observable impact has been failure to perform cluster operations when the customer eventually attempts to access the cluster.

We have early feedback from customers that they need better experience of managing certificates and tokens in AKS-HCI. Some of the improvements that are being investigated include:

-   Increasing default token validity to 90 days (about 3 months).

-   Enabling token rotation outside the upgrade workflow

-   Providing flexibility to set and view token validity period

## Next steps

[link](content.md)