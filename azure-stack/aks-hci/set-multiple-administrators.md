---
title: Set up multiple administrators on Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn how to set up multiple administrators and register additional users with the Microsoft on Cloud (MOC) service on AKS on Azure Stack HCI.
author: scooley
ms.topic: how-to
ms.date: 11/16/2021
ms.author: scooley
---

# Set up multiple administrators

For various reasons, AKS on Azure Stack HCI is currently tightly coupled to the user who installed the service with no awareness of other local users or AD users with administrative rights. We are working on resolving this issue, but you can use the steps in this topic to register additional users with the Microsoft on Cloud (MOC) service under AKS on Azure Stack HCI. This will allow multiple people to perform administrative tasks.

## Create a new MOC user

Run the following commands as the user who installed AKS on Azure Stack HCI. This user needs to be on the same account that deployed the management cluster. Let's refer to this user as `admin1` for the remainder of this topic.

You should consider how long you would like the new admin (`admin2`) to have administrative rights. There isn't a way to extend permissions, but you can always repeat these instructions to create a new user. Use the `-ValidityDays` parameter to set the length of time.

The `identityName` parameter (set to `admin2` below) can be anything since it isn't used anywhere outside of MOC. However, there can't be duplicates of the same name.

``` PowerShell
$loginFile = ".\login.yaml" # location of generated login file for new identity

New-MocIdentity -name "admin2" -validityDays 60 -location MocLocation -outfile $loginFile # create new identity with chosen name

# Assign required roles to new identity

New-MocRoleAssignment -identityName "admin2" -roleName "GalleryImageContributor" -location MocLocation

New-MocRoleAssignment -identityName "admin2" -roleName "SecretReader" -location MocLocation

New-MocRoleAssignment -identityName "admin2" -roleName "NodeReader" -location MocLocation
```

`Admin1` can now share the login.yaml file with `admin2`.

## Set up the new administrator

To log in with the new MOC identity, `admin2` runs the `login.yaml` file received from `admin 1` and then stores it locally. This login command needs to be run only once.

``` PowerShell
$loginFile = “.\login.yaml”

mocctl.exe security login --loginpath $loginFile --identity  # login to new identity
```

That's it! `Admin1` and `admin2` now both have administrative rights.

## Next steps

- [Container networking concepts](./concepts-container-networking.md)
