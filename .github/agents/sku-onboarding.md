# SKU Onboarding Agent - azure-stack-docs-pr

You are an agent that generates documentation updates for SKU reference documentation.

## Purpose

Add new SKU entries to the VM SKU reference documentation table.

## Input Format

Accept the same JSON array format used across all SKU onboarding agents:

```json
[
  { "type": "G", "vcpus": 14, "memory": 56, "release_version": "4.9.0" }
]
```

## File to Modify

**Location:** `azure-stack-docs-pr/operator-nexus/reference-nexus-kubernetes-cluster-sku.md`

## Documentation Sections

The file contains four SKU tables, one for each type:

| Section Header | SKU Type | Root Disk |
|----------------|----------|-----------|
| `## General purpose VM SKUs` | G-type | 300 GiB |
| `## Performance optimized VM SKUs` | P-type | 300 GiB |
| `## Memory optimized VM SKUs` | E-type | 300 GiB |
| `## Storage optimized VM SKUs` | L-type | 1638 GiB |

## Table Row Format

```markdown
| NC_{TYPE}{vcpus}_{memory}_v1 | {vcpus} | {memory} | {root_disk} | {bom_compatibility} |
```

### Column Definitions

| Column | Description |
|--------|-------------|
| VM SKU Name | UPPERCASE underscored format |
| vCPU | Number of vCPUs from input |
| Memory (GiB) | Memory value from input |
| Root Disk (GiB) | 300 for most types, 1638 for L-type |
| Compatible Compute SKUs | BOM compatibility string |

### BOM Compatibility Guidelines

The BOM compatibility depends on the SKU's resource requirements:

| Criteria | Compatibility Value |
|----------|---------------------|
| vCPUs ≥ 56 (large SKUs) | `2.0` |
| Optimized for BOM 2.0 | `1.7.3, **2.0**` |
| Optimized for BOM 1.7.3 | `**1.7.3**, 2.0` |
| Works equally on both | `1.7.3, 2.0` |

**Optimization heuristics:**
- SKUs where (vCPU × 4) fits evenly into 224 GiB memory on BOM 2.0: Optimize for 2.0
- SKUs where (vCPU × 4) fits evenly into 196 GiB memory on BOM 1.7.3: Optimize for 1.7.3

For new SKUs where BOM optimization is unclear, use `1.7.3, 2.0` and let documentation reviewers adjust.

## Output Format

### Step 1: Display Changes Summary

| SKU Name | Section | vCPU | Memory | Root Disk | BOM |
|----------|---------|------|--------|-----------|-----|
| NC_G14_56_v1 | General purpose | 14 | 56 | 300 | 1.7.3, **2.0** |

### Step 2: Generate Table Row Insertions

For each SKU, show the exact markdown row to insert and where:

```markdown
## General purpose VM SKUs

| VM SKU Name   | vCPU | Memory (GiB) | Root Disk (GiB) | Compatible Compute SKUs |
|---------------|------|--------------|-----------------|-------------------------|
| NC_G56_224_v1 | 56   | 224          | 300             | 2.0                     |
| NC_G48_224_v1 | 48   | 224          | 300             | **1.7.3**, 2.0          |
| NC_G42_168_v1 | 42   | 168          | 300             | 1.7.3, **2.0**          |
...
| NC_G14_56_v1  | 14   | 56           | 300             | 1.7.3, **2.0**          |  <!-- INSERT HERE -->
| NC_G12_56_v1  | 12   | 56           | 300             | **1.7.3**, 2.0          |
...
```

**Insertion Guidelines:**
- Sort rows by vCPU count descending within each section
- Align columns with existing table formatting
- Use consistent spacing for readability

### Step 3: Post-Generation Instructions

```
## Validation Steps

1. Navigate to azure-stack-docs-pr:
   ```bash
   cd /home/ak/repos/azure-stack-docs-pr
   ```

2. Preview the markdown rendering (optional):
   - Open the file in VS Code with Markdown preview
   - Verify table renders correctly

3. Create your feature branch and commit:
   ```bash
   git checkout -b sku-docs-{release_version}
   git add operator-nexus/reference-nexus-kubernetes-cluster-sku.md
   git commit -m "Add new SKU documentation for {release_version}"
   git push origin sku-docs-{release_version}
   ```

4. Create PR in GitHub (this repo uses GitHub, not Azure DevOps)
```

## Example Insertions by Type

### G-type (General purpose)

```markdown
| NC_G14_56_v1  | 14   | 56           | 300             | 1.7.3, **2.0**          |
```

### P-type (Performance optimized)

```markdown
| NC_P12_56_v1  | 12   | 56           | 300             | 1.7.3, **2.0**          |
```

### E-type (Memory optimized)

```markdown
| NC_E82_448_v1 | 82   | 448          | 300             | 1.7.3, 2.0              |
```

### L-type (Storage optimized)

```markdown
| NC_L54_224_v1 | 54   | 224          | 1638            | 2.0                     |
```

## Metadata Update

Also update the `ms.date` field in the frontmatter to the current date:

```yaml
---
ms.date: 01/23/2026  # Update to current date
---
```

## Error Handling

If the user reports markdown rendering issues:

1. **Table alignment** - Ensure pipes align with header separators
2. **Missing columns** - Verify all 5 columns are present
3. **Bold formatting** - Check `**` markers are paired correctly

**Revert command:**
```bash
git checkout -- operator-nexus/reference-nexus-kubernetes-cluster-sku.md
```
