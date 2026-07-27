---
title: Guest Attestation for Confidential VMs on Azure Local (Preview)
description: Learn how guest attestation works for confidential VMs (CVMs) on Azure Local, how to run the attestation sample client, and how to set up secure key release.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.service: azure-local
ms.date: 07/27/2026
ms.custom:
  - devx-track-azurecli
ms.subservice: hyperconverged
---

# Guest attestation for confidential VMs on Azure Local (preview)

::: moniker range=">=azloc-2607"

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how guest attestation works for confidential VMs (CVMs) on Azure Local. It walks through two workflows: running the attestation sample client, and setting up secure key release (SKR).

Guest attestation helps you confirm that your CVM environment is secured by a genuine hardware-backed Trusted Execution Environment (TEE), with security features enabled for isolation and integrity.

Use guest attestation to:

- Make sure that the CVM runs on the expected hardware platform.
- Get evidence for a relying party that the CVM runs on confidential hardware.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## How guest attestation works

Guest attestation involves the following components and services:

- The workload.
- The guest attestation library.
- Hardware for reporting, such as AMD SEV-SNP.
- The Microsoft Azure Attestation (MAA) service.
- A JSON Web Token (JWT) response.

Two common attestation scenarios exist:

- **Attestation request from inside the workload**. The workload integrates with the attestation library and requests an MAA token from inside the CVM. The workload checks that the CVM runs on the correct hardware platform before it sets up the sensitive workload. For steps, see the **Run the Attestation Sample Client** tab in the following section.

    :::image type="content" source="./media/guest-attestation-cvm/attestation-request.png" alt-text="Diagram that shows an attestation request made from inside the workload to the Microsoft Azure Attestation service." lightbox="./media/guest-attestation-cvm/attestation-request.png":::

- **Secure Key Release**. The CVM must prove that it runs on a confidential platform before a relying party engages with it. For example, the CVM might request secrets from a secret management service, or a client might require proof that the CVM runs on a confidential platform before it sends personal data for processing. The CVM presents an attestation token to the relying party, which confirms the token's authenticity and then releases the secrets or keys. If the CVM doesn't meet the SKR claim policy, the relying party doesn't release the keys, and the workload can't access the secured data. For steps, see the **Secure Key Release** tab in the following section.

## Find your cluster's attestation (MAA) endpoint

Both attestation scenarios require the Microsoft Azure Attestation (MAA) endpoint associated with your Azure Local cluster. Retrieve it from the cluster resource before you continue:

```powershell
# Get the MAA endpoint URL
$Cluster = (az stack-hci cluster show --resource-group $ResourceGroup --name <cluster name>) | ConvertFrom-Json
$Endpoint = $Cluster.isolatedVmAttestationConfiguration.attestationServiceEndpoint
$Endpoint   # for example, https://<provider-name>.<region>.attest.azure.net
```

Use this value as the `-a` argument when you run `AttestationClient` or `AzureAttestSKR`, and as the authority in a Secure Key Release policy.

## Run guest attestation

# [Run the Attestation Sample Client](#tab/attestation-client)

This section describes how to build an attestation sample workflow by using the OS integrity build scripts to create an integrity-protected VHDX image.

### Prerequisites

- A WSL 2 distribution (Ubuntu 24.04) to build the attestation client library.
- `git` installed in your WSL 2 distribution.
- An existing integrity-protected VM image workflow and a confidential VM to test against.
- `sudo` access on the CVM to run the attestation client.

### Build the attestation client library

In this section, you build binaries to include in the integrity-protected image.

1. Open bash in your WSL 2 distribution (Ubuntu 24.04).

   ```bash
   wsl -d "Ubuntu-24.04"
   ```

1. Go to your home directory. Building on an NTFS filesystem might cause problems.

   ```bash
   cd ~
   ```

1. Clone the `confidential-computing-cvm-guest-attestation` repository.

   ```bash
   git clone https://github.com/Azure/confidential-computing-cvm-guest-attestation
   ```

1. Go to the `confidential-computing-cvm-guest-attestation` directory.

   ```bash
   cd confidential-computing-cvm-guest-attestation
   ```

1. Build the source code and install prerequisites.

   ```bash
   ./azurelocal/build-azure-local.sh -p
   ```

   When prompted, enable the insiders-fast software repository.

1. Find the finished build artifacts in the `output` directory. You use these artifacts in later sections.

   :::image type="content" source="./media/guest-attestation-cvm/build-artifacts-output-directory.png" alt-text="Screenshot of the build artifacts in the output directory." lightbox="./media/guest-attestation-cvm/build-artifacts-output-directory.png":::

   > [!TIP]
   > Use `realpath` to determine the absolute path of a file (for example, `realpath ./output/AttestationClient`). This command can help when you copy build artifacts in later sections.
   >
   > To view the output directory structure, install the `tree` program by running `sudo apt install tree`, and then run `tree ./output/`. This step is optional.

### Build the CVM image and deploy it

To build the integrity-protected VM image and deploy it to your cluster, see [create and deploy an integrity-protected VM image](confidential-vm-create-deploy-integrity-protected-vm-image.md). The article covers the process from downloading the build scripts through generating the SSH key pair.

### Add packages to the image

1. Create the `packages` directory.

   ```bash
   mkdir "packages"
   ```

1. Copy `azguestattestation1_1.0.5_amd64.deb` (from the build output) to the `packages` folder.

1. Using the binaries you built earlier, create the `rootfs-workload` directory.

   ```bash
   mkdir -p "rootfs-workload/usr/local/bin"
   ```

1. Copy the `AttestationClient` binary to `rootfs-workload/usr/local/bin`.

1. Copy the `curl-ca-bundle.crt` certificate file to `rootfs-workload/usr/local/bin`.

### Review the working directory

After you complete the preceding steps, your working directory should look like this:

```
YourLocalScriptDirectory/
├── ...                            # Other content (already included)
├── keys/                          # Added in "Generate the SSH key pair"
│   ├── cvmkey
│   └── cvmkey.pub
├── packages/                      # Added in "Add packages to the image"
│   └── azguestattestation1_1.0.5_amd64.deb
└── rootfs-workload/               # Added in "Add packages to the image"
    └── usr/
        └── local/
            └── bin/
                ├── AttestationClient
                └── curl-ca-bundle.crt
```

The `rootfs-workload/` directory replicates the filesystem layout of the target virtual machine. Any files you place here are included in the read-only root filesystem at the corresponding path. For example, adding `rootfs-workload/usr/local/bin/AttestationClient` results in `/usr/local/bin/AttestationClient` on the virtual machine.

### Run the build script

#### Option 1: Use PowerShell

1. Confirm that you're in the `OSIntegrity` working directory.
1. Run the following command:

   ```powershell
   .\build-docker.ps1 `
       -Username admin `
       -Image myvm.vhdx `
       -SshKey ./keys/cvmkey.pub `
       -PackageDir ./packages/ `
       -RootfsOverlay ./rootfs-workload `
       -Packages "edge-cc-base-attestation-sdk" `
       -InsidersFast `
       -WSLDistro Ubuntu-24.04 `
       -DockerRebuild `
       -PasswordlessSudo
   ```

   The build script uses Unix-style forward slashes (`/`) for path arguments because it runs inside WSL 2 or Docker.

#### Option 2: Use Bash (WSL)

1. Confirm that you're in the `OSIntegrity` working directory.
1. Run the following command:

   ```bash
   ./docker-build.sh \
       --username admin \
       --image myvm.vhdx \
       --ssh-key ./keys/cvmkey.pub \
       --package-dir ./packages \
       --packages "edge-cc-base-attestation-sdk" \
       --rootfs-overlay ./rootfs-workload \
       --insiders-fast \
       --passwordless-sudo
   ```

### Review the output

Your working directory now includes new `build` and `out` folders:

```
OSIntegrity/
├── build/
│   ├── uki.efi                # Unified Kernel Image (UKI)
│   ├── rootfs.squashfs        # Compressed rootfs
│   ├── rootfs.hash            # dm-verity hash tree
│   ├── build.log              # Full build log
│   └── ...
└── out/
    ├── calculated_pcrs.txt    # Expected TPM PCR 4 and PCR 11 values
    └── myvm.vhdx              # Your VHDX image
```

> [!NOTE]
> You need `calculated_pcrs.txt` later. It contains the expected TPM PCR values required for setting up attestation policies.

### Run the attestation sample client

After you connect to the CVM, get an attestation token (JWT) that contains claims you can inspect.

1. Get the JWT. Use the [MAA endpoint](#find-your-clusters-attestation-maa-endpoint) you retrieved for your cluster.

   ```bash
   sudo AttestationClient -o token -a https://<your cluster MAA endpoint>.attest.azure.net; echo
   ```

   The final `echo` statement only improves output readability - it doesn't affect the result.

1. Copy the JWT (it starts with `ey`).
1. Go to [jwt.ms](https://jwt.ms).
1. Paste in the JWT.
1. Verify that `x-ms-attestation-type` (in `x-ms-isolation-tee`) is `sevsnp`.
1. Verify that `edge-compliant-cvm` is `true`.
1. Verify that `tpm-persisted` is `false`.
1. Verify that `pcr4` (in `x-ms-azurevm-attested-pcr-values`) has the same SHA-256 (base64) value as in `calculated_pcrs.txt`.
1. Verify that `pcr11` (in `x-ms-azurevm-attested-pcr-values`) has the same SHA-256 (base64) value as in `calculated_pcrs.txt`.
1. Review and share your results.

# [Secure Key Release](#tab/secure-key-release)

This section describes how to set up an Azure Key Vault (AKV) for Secure Key Release (SKR) on Azure Local, and how to build the SKR sample application that exercises it. SKR releases an exportable key from Key Vault to a workload only after the platform is cryptographically attested against a key release policy.

On Azure Local, the host performs key release: the Evidence SDK (`edge-cc-base-attestation-sdk`) handles attestation and Key Vault authentication by using the Azure Local cluster identity, so the guest CVM doesn't need IMDS or service principal credentials.

:::image type="content" source="./media/guest-attestation-cvm/confidential-vm-handshake.png" alt-text="Diagram that shows the handshake between a confidential VM and the relying party during secure key release." lightbox="./media/guest-attestation-cvm/confidential-vm-handshake.png":::

> [!NOTE]
> Use a new Key Vault dedicated to secure key release operations only. The Azure Local cluster identity is granted only the `Microsoft.KeyVault/vaults/keys/release/action` permission on that vault. This permission allows it to release keys that are marked as exportable and protected by a suitable SKR policy - it doesn't allow the identity to list or get keys.

### Prerequisites

- An Azure Local cluster that's registered with Azure (`RegistrationStatus : Registered`).
- The Azure CLI (`az`) signed in to the subscription that contains the cluster, with permission to create Key Vaults, custom role definitions, and role assignments.
- A WSL 2 distribution (Ubuntu 24.04) to build the sample application.

### Build the SKR sample application

In this section, you build the binaries to include in the integrity-protected image. The build process creates the `AzureAttestSKR` sample application, which you use to perform secure key release.

1. Open bash in your WSL 2 distribution (Ubuntu 24.04).

   ```bash
   wsl -d "Ubuntu-24.04"
   ```

1. Go to your home directory. Building on an NTFS filesystem might cause problems.

   ```bash
   cd ~
   ```

1. Clone the `confidential-computing-cvm-guest-attestation` repository.

   ```bash
   git clone https://github.com/Azure/confidential-computing-cvm-guest-attestation
   ```

1. Go to the `confidential-computing-cvm-guest-attestation` directory.

   ```bash
   cd confidential-computing-cvm-guest-attestation
   ```

1. Build the source code and install prerequisites.

   ```bash
   ./azurelocal/build-azure-local.sh -p
   ```

   When prompted, enable the insiders-fast software repository.

1. Find the finished build artifacts in the `output` directory. You use these artifacts in later sections. For the SKR sample application, look for the `AzureAttestSKR` app:

   ```bash
   realpath ./output/AzureAttestSKR
   ```

   This information can help when you copy build artifacts in later sections.

   > [!TIP]
   > To view the output directory structure, install the `tree` program by running `sudo apt install tree`, and then run `tree ./output/`. This step is optional.

### Build the CVM image and deploy it

Build the integrity-protected VM image and deploy it to your cluster by following the same steps used to [create and deploy an integrity-protected VM image](confidential-vm-create-deploy-integrity-protected-vm-image.md). You must include `AzureAttestSKR` in the rootfs overlay of your built image.

### Create an Azure Key Vault for SKR

Secure key release requires a Premium Key Vault, which supports HSM-protected, exportable keys with an attached release policy. Create a dedicated vault for SKR operations only.

Set up variables for the commands that follow:

```powershell
$SubscriptionId = "<your-subscription-id>"
$ResourceGroup  = "<your-resource-group>"
$Location       = "<azure-region>"           # for example, eastus
$VaultName      = "<your-skr-vault-name>"    # globally unique
```

Create the Premium vault:

```azurecli
az keyvault create `
  --name "$VaultName" `
  --subscription "$SubscriptionId" `
  --resource-group "$ResourceGroup" `
  --location "$Location" `
  --sku premium `
  --enable-rbac-authorization true `
  --enable-purge-protection true
```

- Use `--sku premium` because the vault must store HSM-protected, exportable keys for SKR.
- `--enable-rbac-authorization true` puts the vault in the Azure RBAC permission model, which you need to grant the cluster identity the granular release-only permission used later.
- Set `--enable-purge-protection true` to protect against accidental or malicious deletion of keys.

### Assign permissions on the AKV

Grant the Azure Local cluster identity permission to release keys from the vault. Specifically, grant the single data action `Microsoft.KeyVault/vaults/keys/release/action`. The built-in **Key Vault Crypto Service Release User** role grants exactly this one permission, so it doesn't permit other key operations, such as get or list. Assign that built-in role to the cluster identity.

#### Find the Azure Local cluster identity

On a cluster node, run `Get-AzureStackHci` and note the `AzureResourceUri` of the cluster:

```powershell
PS C:\> Get-AzureStackHci

ClusterStatus      : Clustered
RegistrationStatus : Registered
AzureResourceName  : ra2607-cl
AzureResourceUri   : /Subscriptions/4c69a9b0-.../resourceGroups/EDGECI-REGISTRATION-.../providers/Microsoft.AzureStackHCI/clusters/ra2607-cl
ConnectionStatus   : Connected
...
```

The cluster resource has a system-assigned managed identity. Using the `AzureResourceUri` from the preceding output, retrieve the identity's principal (object) ID:

```azurecli
$ClusterResourceUri = "<AzureResourceUri from Get-AzureStackHci>"

$PrincipalId = az resource show `
  --ids "$ClusterResourceUri" `
  --query "identity.principalId" -o tsv

$PrincipalId
```

The equivalent in Azure PowerShell is `(Get-AzResource -ResourceId "<AzureResourceUri>").Identity.PrincipalId`.

#### Assign the role to the cluster identity

Assign the built-in **Key Vault Crypto Service Release User** role to the cluster identity, scoped to the SKR vault:

```azurecli
$VaultScope = "/subscriptions/$SubscriptionId/resourceGroups/$ResourceGroup/providers/Microsoft.KeyVault/vaults/$VaultName"

az role assignment create `
  --assignee-object-id "$PrincipalId" `
  --assignee-principal-type ServicePrincipal `
  --role "Key Vault Crypto Service Release User" `
  --scope "$VaultScope"
```

The cluster identity can now release keys that meet the policy from this vault, but it can't get or list keys.

### Create a key and assign a policy to it

Create an exportable key in the SKR vault and attach the Edge CVM release policy. This policy ensures the key is released only to a genuine, non-debuggable AMD SEV-SNP confidential VM that presents the Edge Compliant CVM claim (`x-ms-policy.edge-compliant-cvm = true`).

Use the [MAA endpoint](#find-your-clusters-attestation-maa-endpoint) you retrieved for your cluster as the authority in the release policy in the next step, and as the `-a` argument when you run `AzureAttestSKR`.

#### Create the policy file

Save the following as `cvm-skr-policy.json`. Replace the authority with the `$Endpoint` value from the preceding step, and replace the PCR values with the values in `calculated_pcrs.txt` that you calculated earlier when you built the CVM image.

```json
{
  "version": "1.0.0",
  "anyOf": [
    {
      "authority": "https://<provider-name>.<region>.attest.azure.net",
      "allOf": [
        {
          "claim": "x-ms-isolation-tee.x-ms-sevsnpvm-is-debuggable",
          "equals": "false"
        },
        {
          "claim": "x-ms-isolation-tee.x-ms-attestation-type",
          "equals": "sevsnpvm"
        },
        {
          "claim": "x-ms-policy.edge-compliant-cvm",
          "equals": "true"
        },
        {
          "claim": "x-ms-azurevm-attested-pcr-values.pcr4",
          "equals": "<PCR4 from calculated_pcrs.txt>"
        },
        {
          "claim": "x-ms-azurevm-attested-pcr-values.pcr11",
          "equals": "<PCR11 from calculated_pcrs.txt>"
        }
      ]
    }
  ]
}
```

> [!IMPORTANT]
> `authority` must be the MAA endpoint associated with the Azure Local cluster (the attestation provider in the cluster resource group), as captured in `$Endpoint`. Pass the same value as the `-a` argument when you run `AzureAttestSKR`.

#### Create the exportable key with the policy attached

```azurecli
$KeyName = "<your-key-name>"

az keyvault key create `
  --vault-name "$VaultName" `
  --name "$KeyName" `
  --kty RSA-HSM `
  --size 3072 `
  --exportable true `
  --policy "@cvm-skr-policy.json"
```

- `--exportable true` together with `--policy` marks the key for secure key release — an exportable key must have a release policy attached.
- `--kty RSA-HSM` creates an HSM-protected key in the Premium vault.

#### Retrieve the key version URI

The `AzureAttestSKR` sample application needs the full versioned key identifier. Retrieve it with:

```azurecli
az keyvault key show `
  --vault-name "$VaultName" `
  --name "$KeyName" `
  --query "key.kid" -o tsv
```

### Run the SKR sample

Run the sample application from within the confidential VM to perform a secure key release. The `-r` flag attests the platform and releases the key itself, instead of wrapping or unwrapping a symmetric key:

```bash
sudo ./AzureAttestSKR \
  -a "https://<provider-name>.<region>.attest.azure.net" \
  -k "https://<your-skr-vault-name>.vault.azure.net/keys/<your-key-name>/<version_GUID>" \
  -r
```

On success, the sample writes the released key material to stdout. Use the attestation endpoint captured earlier for the `-a` argument. On Azure Local, omit the credentials source (`-c`) because the host performs key release by using the Azure Local cluster identity.

---

## Related content

- [Create and connect to an Azure Local confidential VM (preview)](create-connect-confidential-vm.md)
- [Guest attestation for Trusted launch for Azure Local VMs (preview)](trusted-launch-guest-attestation.md)
- [What is Trusted launch for Azure Local VMs?](trusted-launch-vm-overview.md)

::: moniker-end

::: moniker range="<=azloc-2606"

This feature is available only in Azure Local 2607 or later.

::: moniker-end
