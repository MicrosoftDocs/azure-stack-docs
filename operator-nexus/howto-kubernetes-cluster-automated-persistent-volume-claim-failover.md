---
title: Automated PVC failover on a Nexus Kubernetes cluster
description: How-to guide for deploying an opt-in controller that automatically fails over a stranded PersistentVolumeClaim when a Nexus Kubernetes node fails.
author: eak13
ms.author: ekarandjeff
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 10/02/2026
ms.custom: template-how-to
---

# Automated PVC failover on a Nexus Kubernetes cluster

On a Nexus Kubernetes (NAKS) cluster, a `ReadWriteOnce` (RWO) `PersistentVolumeClaim` (PVC) attaches to the single worker node where its consuming pod runs. When the underlying bare metal machine (BMM) fails or is taken out of service for an upgrade, that node transitions to `NotReady`. While Kubernetes reschedules the pod to a healthy node, the `PersistentVolume` remains attached to the failed node. 

Kubernetes doesn't automatically force-detach the volume, because it can't distinguish a permanently failed node from one that's temporarily unreachable. Force-detaching a volume that's still in use elsewhere risks data corruption.

As a result, the replacement pod remains in `ContainerCreating` with a `Multi-Attach error for volume` message until an operator manually force-deletes the stranded pod and deletes the stale `VolumeAttachment`.

This article explains how to deploy an **opt-in controller** that performs this remediation automatically, but only for volumes you explicitly opt in, and only after a delay that you control.

> [!CAUTION]
> This controller is an opt-in, customer-run reference solution. You choose to deploy it, you choose which volumes it acts on, and you accept the data-loss trade-offs described in [Understand the data-loss trade-off](#understand-the-data-loss-trade-off). By opting a volume in, you acknowledge that the platform can't guarantee against data loss for that volume.

## Prerequisites

Before proceeding with this article, ensure that you:

- Have a deployed Nexus Kubernetes cluster. Refer to the Nexus Kubernetes cluster [QuickStart guide](./quickstarts-kubernetes-cluster-deployment-bicep.md) for a comprehensive overview and the steps involved to create a Nexus Kubernetes cluster.
- Have appropriate access and permissions to run `kubectl` commands against the target Nexus Kubernetes cluster.
- Have permissions to create a namespace, `ServiceAccount`, `ClusterRole`, `ClusterRoleBinding`, and `Deployment` on the Nexus Kubernetes cluster.

## How the controller works

The controller runs as a single-replica `Deployment` pinned to a control-plane node. On a reconcile interval, it:

1. Lists PVCs that carry the opt-in label `nexus.microsoft.com/pvc-failover=enabled`.
1. For each opted-in PVC, evaluates whether all of the [failover conditions](#understand-the-failover-conditions) are met.
1. When they are, starts a per-PVC failover timer.
1. When the timer reaches the configured delay and the condition still holds, force-deletes the stranded pod and deletes the stale `VolumeAttachment` for every PVC that pod mounted, so the volumes can reattach to the rescheduled pod.

The controller uses only a Kubernetes `ServiceAccount` and role-based access control (RBAC). It doesn't require privileged mode, host access, `hostPID`, or `nsenter`. Its permissions are limited to `get`, `list`, and `watch` on nodes, pods, PVCs, PVs, and `VolumeAttachments`, and `delete` on pods and `VolumeAttachments` only.

## Understand the failover conditions

To act conservatively, the controller performs a failover only when **all** of the following conditions are true:

- **The volume is opted in.** The PVC carries the label `nexus.microsoft.com/pvc-failover=enabled`.
- **A replacement pod exists.** The PVC is referenced by a second, non-terminal pod that belongs to the *same workload* as the stranded pod (the rescheduled replacement). The controller matches the two pods by owner reference and ignores completed `Job` pods or unrelated workloads that happen to reference the same PVC.
- **The holding node is failed.** One of those pods is scheduled on a node whose `Ready` condition isn't `True` (`NotReady` or `Unknown`).
- **Every PVC on the stranded pod is opted in.** See [Understand the multi-PVC safety guard](#understand-the-multi-pvc-safety-guard).
- **The delay has elapsed.** The condition persists continuously for the PVC's configured delay (30 minutes by default).

If any condition isn't met, the controller waits and reevaluates on the next reconcile pass.

## Understand the multi-PVC safety guard

The failover action force-deletes the entire stranded pod, which affects every volume that pod mounts, not only the opted-in one. To honor the per-PVC opt-in model, the controller refuses to act on a pod that mounts a mix of opted-in and non-opted-in volumes.

> [!IMPORTANT]
> If a stranded pod mounts multiple PVCs and not all of them carry the opt-in label, the controller performs no remediation for that pod and logs a skip that names the non-opted-in PVCs. Manual intervention is required for that pod.

This behavior prevents the controller from disrupting the consumer of a volume that was never opted in. It also reflects a technical reality: the controller intentionally leaves the non-opted-in volume's `VolumeAttachment` in place, so the replacement pod would still be blocked on that volume regardless.

To fail over a workload whose pod mounts several PVCs, opt in **all** of that pod's PVCs.

## Opt a volume in

Failover is off by default. A PVC is considered only if it carries the opt-in label. You can also set an optional per-PVC delay.

```yaml
metadata:
  labels:
    nexus.microsoft.com/pvc-failover: "enabled"     # Required opt-in gate
  annotations:
    nexus.microsoft.com/pvc-failover-delay: "30m"   # Optional per-PVC delay (default 30m)
```

- **Label (required):** `nexus.microsoft.com/pvc-failover=enabled`. Without this label, the controller never acts on the volume.
- **Annotation (optional):** `nexus.microsoft.com/pvc-failover-delay`. How long the volume's node must remain `NotReady` before failover occurs. Accepts values such as `30m`, `300s`, `1h`, or a plain number of seconds. When absent, the controller's default delay (30 minutes) applies.

You can apply the opt-in label in any of the following ways.

### Opt in a standalone PVC

For a PVC that a `Deployment`, pod, or `Job` references by `claimName`, add the label directly to the PVC manifest so it's opted in from creation:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-app-data
  namespace: my-app
  labels:
    nexus.microsoft.com/pvc-failover: "enabled"
  annotations:
    nexus.microsoft.com/pvc-failover-delay: "10m"
spec:
  accessModes: ["ReadWriteOnce"]
  storageClassName: nexus-volume
  resources:
    requests:
      storage: 50Gi
```

### Opt in StatefulSet volumes

For a `StatefulSet`, add the label and annotation to `volumeClaimTemplates` so every replica's PVC opts in at creation:

```yaml
spec:
  volumeClaimTemplates:
    - metadata:
        name: data
        labels:
          nexus.microsoft.com/pvc-failover: "enabled"
        annotations:
          nexus.microsoft.com/pvc-failover-delay: "15m"
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: nexus-volume
        resources:
          requests:
            storage: 50Gi
```

> [!NOTE]
> A running `StatefulSet`'s `volumeClaimTemplates` is immutable. Editing it doesn't re-label PVCs that already exist; only PVCs created afterward inherit the change. Label existing PVCs directly, as shown in the next section.

### Opt in an existing PVC

Add the label (and, optionally, the delay annotation) to a PVC that already exists:

```bash
kubectl label pvc <pvc-name> -n <namespace> nexus.microsoft.com/pvc-failover=enabled
kubectl annotate pvc <pvc-name> -n <namespace> nexus.microsoft.com/pvc-failover-delay=10m
```

## Configure the controller

Set the controller's behavior through container environment variables on the `Deployment`.

| Environment variable | Default | Effect |
|---|---|---|
| `DRY_RUN` | `true` | Controls whether the controller performs real deletions. It's interpreted as a case-insensitive boolean (`true`/`false`, and also `1`/`0`, `yes`/`no`, `on`/`off`). Destructive actions run **only** when the value resolves to `false`. Any unset, blank, or unrecognized value (for example, a typo like `flase`) keeps dry-run **on** and logs a warning, so the controller never silently arms. The current arm state is also logged on every reconcile pass. |
| `RECONCILE_INTERVAL` | `30` | Seconds between reconcile passes. A lower value gives faster detection and countdown at the cost of more API calls. |
| `DEFAULT_FAILOVER_DELAY` | `30m` | Delay used when a PVC has no `nexus.microsoft.com/pvc-failover-delay` annotation. Accepts values such as `30m`, `300s`, or `1h`. |
| `LABEL_KEY` | `nexus.microsoft.com/pvc-failover` | The label key that the controller treats as the opt-in gate. |
| `LABEL_VALUE` | `enabled` | The label value required for opt-in. |
| `DELAY_ANNOTATION` | `nexus.microsoft.com/pvc-failover-delay` | The annotation key read for a per-PVC delay override. |
| `WATCH_NAMESPACE` | `""` (empty) | When empty, the controller watches all namespaces. Set it to a namespace name to scope the controller to only that namespace, which limits the blast radius. |
| `DETACH_ATTEMPTS` | `6` | Maximum number of times, within a single failover, that the controller retries deleting a stale `VolumeAttachment` on the failed node. Because the stranded pod is already deleted at this point, the detach can't be retried on a later pass, so it's retried in place. If every attempt fails, the controller logs an error asking an operator to remove the `VolumeAttachment` manually. |
| `DETACH_RETRY_WAIT` | `5` | Seconds to wait between the detach retries controlled by `DETACH_ATTEMPTS`. |

> [!NOTE]
> The controller's container image must include both a POSIX shell and `kubectl`. The provided manifest uses `mcr.microsoft.com/oss/v2/kubernetes/kubectl:v1.36.1-14`, which includes both and is suitable for air-gapped environments. Don't use a distroless `kubectl` image (no shell) or a base OS image (no `kubectl`), because either one prevents the controller from functioning.

## Deploy the controller

Create a file named `pvc-failover-controller.yaml` on a computer from which you can run `kubectl` against the target cluster. Copy the following controller manifest into the file:

```yml
# =============================================================================
# NAKS Automated PVC Failover Controller  (ART-589 / ADO Feature 2281205)
# =============================================================================
# Opt-in, customer-run controller that force-detaches a PersistentVolume from a
# dead (NotReady) NAKS node so a rescheduled pod can re-attach it.
#
#   * OPT-IN is required:  label a PVC with  nexus.microsoft.com/pvc-failover=enabled
#   * DELAY is per-PVC:     annotate a PVC   nexus.microsoft.com/pvc-failover-delay=30m
#   * NO host access:       uses a ServiceAccount + RBAC only (no privileged / nsenter)
#
# See howto-kubernetes-cluster-automated-persistent-volume-claim-failover.md for
# the full explanation, guard conditions, data-loss caveats, and the "observe
# safely first" (DRY_RUN) workflow.
#
# IMPORTANT: this manifest ships with DRY_RUN=true. It will only LOG the actions
# it *would* take until you flip DRY_RUN to "false" (see the Deployment env).
# =============================================================================
---
apiVersion: v1
kind: Namespace
metadata:
  name: nexus-pvc-failover
  labels:
    app.kubernetes.io/name: pvc-failover-controller
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pvc-failover-controller
  namespace: nexus-pvc-failover
  labels:
    app.kubernetes.io/name: pvc-failover-controller
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: pvc-failover-controller
  labels:
    app.kubernetes.io/name: pvc-failover-controller
rules:
  # Read cluster state to decide whether a failover is warranted.
  - apiGroups: [""]
    resources: ["nodes"]
    verbs: ["get", "list", "watch"]
  - apiGroups: [""]
    resources: ["persistentvolumeclaims", "persistentvolumes"]
    verbs: ["get", "list", "watch"]
  - apiGroups: ["storage.k8s.io"]
    resources: ["volumeattachments"]
    verbs: ["get", "list", "watch", "delete"]   # delete == force-detach
  # Force-delete the pod that is stranded on the dead node.
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch", "delete"]
  # Optional: emit Events for observability.
  - apiGroups: [""]
    resources: ["events"]
    verbs: ["create", "patch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: pvc-failover-controller
  labels:
    app.kubernetes.io/name: pvc-failover-controller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: pvc-failover-controller
subjects:
  - kind: ServiceAccount
    name: pvc-failover-controller
    namespace: nexus-pvc-failover
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pvc-failover-controller
  namespace: nexus-pvc-failover
  labels:
    app.kubernetes.io/name: pvc-failover-controller
spec:
  # Exactly ONE active instance. The controller must run OFF the failing node,
  # so it is pinned to a control-plane node; if that node dies, the default
  # unreachable/not-ready tolerations (300s) let it reschedule to another CP node.
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app.kubernetes.io/name: pvc-failover-controller
  template:
    metadata:
      labels:
        app.kubernetes.io/name: pvc-failover-controller
    spec:
      serviceAccountName: pvc-failover-controller
      # ---- Placement: control-plane node only -------------------------------
      nodeSelector:
        node-role.kubernetes.io/control-plane: ""
      tolerations:
        - key: node-role.kubernetes.io/control-plane
          operator: Exists
          effect: NoSchedule
        - key: node-role.kubernetes.io/master
          operator: Exists
          effect: NoSchedule
        # NOTE: we deliberately do NOT add a blanket `operator: Exists`
        # toleration, so the default 300s unreachable/not-ready eviction still
        # applies and this pod reschedules if its own CP node fails.
      securityContext:
        runAsNonRoot: false
        seccompProfile:
          type: RuntimeDefault
      containers:
        - name: controller
          # IMPORTANT: this container needs BOTH a POSIX shell AND `kubectl`.
          #   * mcr.microsoft.com/oss/kubernetes/kubectl (v1) -> distroless, NO shell.
          #   * mcr.microsoft.com/cbl-mariner/base/core       -> shell but NO kubectl
          #     (fine for the *test workload*, which needs no kubectl, NOT this controller).
          # Use an image with BOTH. Verified working on roy-dev03f (2026-09-02):
          #   mcr.microsoft.com/oss/v2/kubernetes/kubectl:v1.36.1-14  (MCR, airgap-friendly)
          # Other options: bitnami/kubectl:1.30 (needs Docker Hub egress); or bake kubectl
          # into a mariner/azurelinux base; or install at startup (needs a mirror), e.g.:
          #   command -v kubectl >/dev/null 2>&1 || tdnf install -y kubectl
          # Pin the kubectl version to (roughly) your cluster version.
          image: mcr.microsoft.com/oss/v2/kubernetes/kubectl:v1.36.1-14
          imagePullPolicy: IfNotPresent
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: false   # controller writes timer state to /tmp
            capabilities:
              drop: ["ALL"]
          env:
            # ---- Behaviour knobs (see README) --------------------------------
            - name: DRY_RUN                 # "true" = log-only; flip to "false" to ARM
              value: "true"
            - name: RECONCILE_INTERVAL      # seconds between reconcile passes
              value: "30"
            - name: DEFAULT_FAILOVER_DELAY  # used when a PVC has no delay annotation
              value: "30m"
            - name: LABEL_KEY               # required opt-in label key on the PVC
              value: "nexus.microsoft.com/pvc-failover"
            - name: LABEL_VALUE             # required opt-in label value
              value: "enabled"
            - name: DELAY_ANNOTATION        # optional per-PVC delay override key
              value: "nexus.microsoft.com/pvc-failover-delay"
            - name: WATCH_NAMESPACE         # "" = all namespaces; set to scope down
              value: ""
          command:
            - /bin/sh
            - -c
            - |
              set -u

              LABEL_KEY="${LABEL_KEY:-nexus.microsoft.com/pvc-failover}"
              LABEL_VALUE="${LABEL_VALUE:-enabled}"
              DELAY_ANNOTATION="${DELAY_ANNOTATION:-nexus.microsoft.com/pvc-failover-delay}"
              DEFAULT_FAILOVER_DELAY="${DEFAULT_FAILOVER_DELAY:-30m}"
              RECONCILE_INTERVAL="${RECONCILE_INTERVAL:-30}"
              WATCH_NAMESPACE="${WATCH_NAMESPACE:-}"
              # Once the stranded pod is deleted it will not be found by a later
              # pass, so a failed VolumeAttachment delete cannot be retried across
              # passes — it must be retried in-pass. These bound that retry.
              DETACH_ATTEMPTS="${DETACH_ATTEMPTS:-6}"
              DETACH_RETRY_WAIT="${DETACH_RETRY_WAIT:-5}"
              STATE_DIR="/tmp/pvc-failover-state"
              mkdir -p "$STATE_DIR"

              log() { echo "[$(date -u +'%Y-%m-%dT%H:%M:%SZ')] $*"; }

              # Normalize DRY_RUN to a strict boolean, case-insensitively. Destructive
              # actions run ONLY when this resolves to exactly "false". Unset, blank, or
              # any unrecognized value keeps dry-run ON (fail-safe) AND logs a warning,
              # so a typo can neither silently arm nor silently disarm the controller.
              # Use ${DRY_RUN-} (not :-true) so unset AND blank both fall through to the
              # "" arm and log the promised warning instead of silently picking dry-run.
              case "$(printf '%s' "${DRY_RUN-}" | tr '[:upper:]' '[:lower:]')" in
                false|0|no|off) DRY_RUN=false ;;
                true|1|yes|on)  DRY_RUN=true ;;
                "") log "WARNING: DRY_RUN is unset or blank, defaulting to dry-run (safe, no changes)."; DRY_RUN=true ;;
                *) log "WARNING: unrecognized DRY_RUN='${DRY_RUN}', defaulting to dry-run (safe, no changes)."; DRY_RUN=true ;;
              esac

              # One-line, unmistakable arm-state banner for the current pass.
              arm_state() {
                if [ "$DRY_RUN" = "false" ]; then echo "ARMED (DRY_RUN=false) — destructive actions WILL run"; else echo "DRY-RUN (DRY_RUN=true) — no changes will be made"; fi
              }

              # Convert a duration (30m / 300s / 1h / bare-seconds) to seconds.
              # $2 = fallback seconds when the value is empty or malformed.
              to_seconds() {
                v="$1"; d="$2"
                case "$v" in
                  "")        echo "$d" ;;
                  *h) n=${v%h}; case "$n" in ''|*[!0-9]*) echo "$d";; *) echo $((n*3600));; esac ;;
                  *m) n=${v%m}; case "$n" in ''|*[!0-9]*) echo "$d";; *) echo $((n*60));; esac ;;
                  *s) n=${v%s}; case "$n" in ''|*[!0-9]*) echo "$d";; *) echo "$n";; esac ;;
                  *[!0-9]*)  echo "$d" ;;
                  *)         echo "$v" ;;
                esac
              }

              # Ready status of a node: True / False / Unknown / ERROR.
              # A FAILED query (API/RBAC error, timeout) must NOT be conflated with a
              # real "node is gone" signal — otherwise a persistent lookup failure could
              # mark a healthy node as failed and force-delete a healthy pod. We return a
              # distinct "ERROR" on query failure; callers treat ERROR as "do not act".
              node_ready() {
                st=$(kubectl get node "$1" -o jsonpath='{range .status.conditions[?(@.type=="Ready")]}{.status}{end}' 2>/dev/null)
                rc=$?
                if [ "$rc" -ne 0 ]; then echo "ERROR"; return 0; fi
                # rc==0 but empty means the node object exists yet reports no Ready
                # condition (genuinely Unknown); a missing node object also yields rc!=0
                # above, so empty here is a real Unknown.
                [ -z "$st" ] && st="Unknown"
                echo "$st"
              }

              # Run a mutating kubectl command (or describe it under dry-run). Returns the
              # command's real exit code so callers can abort a partial failover.
              krun() {
                if [ "$DRY_RUN" = "false" ]; then
                  log "  EXEC: kubectl $*"
                  if kubectl "$@"; then return 0; else
                    rc=$?; log "    ERROR: 'kubectl $*' failed (rc=$rc)"; return "$rc"
                  fi
                else
                  log "  DRY_RUN would run: kubectl $*"
                  return 0
                fi
              }

              DEFAULT_DELAY_SECONDS=$(to_seconds "$DEFAULT_FAILOVER_DELAY" 1800)
              TMP="/tmp/pvc-failover-run"
              mkdir -p "$TMP"

              NODE_SELF="${HOSTNAME:-$(cat /proc/sys/kernel/hostname 2>/dev/null || echo unknown)}"
              log "PVC Failover Controller starting on ${NODE_SELF}"
              log "  opt-in label     : ${LABEL_KEY}=${LABEL_VALUE}"
              log "  delay annotation : ${DELAY_ANNOTATION}"
              log "  default delay    : ${DEFAULT_FAILOVER_DELAY} (${DEFAULT_DELAY_SECONDS}s)"
              log "  reconcile every  : ${RECONCILE_INTERVAL}s"
              log "  DRY_RUN          : ${DRY_RUN}   [$(arm_state)]"
              if [ -n "$WATCH_NAMESPACE" ]; then log "  namespace scope  : ${WATCH_NAMESPACE}"; else log "  namespace scope  : ALL"; fi

              while true; do
                log "---- reconcile pass start — $(arm_state) ----"
                ACTIVE_KEYS=" "

                if [ -n "$WATCH_NAMESPACE" ]; then
                  kubectl get pvc -n "$WATCH_NAMESPACE" -l "${LABEL_KEY}=${LABEL_VALUE}" \
                    -o jsonpath='{range .items[*]}{.metadata.namespace}{"|"}{.metadata.name}{"|"}{.spec.volumeName}{"\n"}{end}' \
                    > "$TMP/pvcs" 2>/dev/null || : > "$TMP/pvcs"
                else
                  kubectl get pvc --all-namespaces -l "${LABEL_KEY}=${LABEL_VALUE}" \
                    -o jsonpath='{range .items[*]}{.metadata.namespace}{"|"}{.metadata.name}{"|"}{.spec.volumeName}{"\n"}{end}' \
                    > "$TMP/pvcs" 2>/dev/null || : > "$TMP/pvcs"
                fi

                if [ ! -s "$TMP/pvcs" ]; then
                  log "No opted-in PVCs (label ${LABEL_KEY}=${LABEL_VALUE}). Nothing to do."
                else
                  PVC_COUNT=$(grep -c . "$TMP/pvcs" 2>/dev/null || echo 0)
                  log "Tracking ${PVC_COUNT} opted-in PVC(s) (label ${LABEL_KEY}=${LABEL_VALUE})."
                fi

                # ---- iterate opted-in PVCs (main shell; no pipe, so vars persist) ----
                while IFS='|' read -r NS PVC PV; do
                  [ -z "${NS:-}" ] && continue
                  [ -z "${PVC:-}" ] && continue
                  if [ -z "${PV:-}" ]; then
                    log "[$NS/$PVC] not bound to a PV yet, skipping."
                    continue
                  fi

                  # Pods in this namespace, with node / phase / owner-uid / claim list.
                  kubectl get pods -n "$NS" \
                    -o jsonpath='{range .items[*]}{.metadata.name}{"|"}{.spec.nodeName}{"|"}{.status.phase}{"|"}{.metadata.ownerReferences[0].uid}{"|"}{range .spec.volumes[*]}{.persistentVolumeClaim.claimName}{","}{end}{"\n"}{end}' \
                    > "$TMP/pods" 2>/dev/null || : > "$TMP/pods"

                  # First pass: identify the stranded pod (a pod that references our PVC and
                  # sits on a NotReady node). Capture its owner UID so we can require that
                  # any "replacement" belongs to the SAME workload.
                  OLD_POD=""; OLD_NODE=""; OLD_CLAIMS=""; OLD_OWNER=""; NODE_ERR=0
                  while IFS='|' read -r PNAME PNODE PPHASE POWNER PCLAIMS; do
                    [ -z "$PNAME" ] && continue
                    case ",$PCLAIMS" in *",$PVC,"*) : ;; *) continue ;; esac
                    if [ -n "$PNODE" ]; then
                      RS=$(node_ready "$PNODE")
                      if [ "$RS" = "ERROR" ]; then
                        NODE_ERR=1                      # node lookup failed — do NOT treat as dead
                      elif [ "$RS" != "True" ]; then
                        OLD_POD="$PNAME"; OLD_NODE="$PNODE"; OLD_CLAIMS="$PCLAIMS"; OLD_OWNER="$POWNER"
                      fi
                    fi
                  done < "$TMP/pods"

                  # Second pass: count a valid REPLACEMENT only if it is a DIFFERENT pod that
                  # (a) references the same PVC, (b) is NOT the stranded pod, (c) is in a
                  # non-terminal phase (not Succeeded/Failed — excludes completed Jobs), and
                  # (d) shares the stranded pod's owner UID (same workload). POWNER/PPHASE
                  # were previously parsed but unused; this closes that gap.
                  REPLACEMENT=0
                  if [ -n "$OLD_POD" ]; then
                    while IFS='|' read -r PNAME PNODE PPHASE POWNER PCLAIMS; do
                      [ -z "$PNAME" ] && continue
                      [ "$PNAME" = "$OLD_POD" ] && continue
                      case ",$PCLAIMS" in *",$PVC,"*) : ;; *) continue ;; esac
                      case "$PPHASE" in Succeeded|Failed) continue ;; esac
                      if [ -n "$OLD_OWNER" ] && [ "$POWNER" = "$OLD_OWNER" ]; then
                        REPLACEMENT=1
                      fi
                    done < "$TMP/pods"
                  fi

                  # ---- Guard conditions ------------------------------------------
                  #  (a) opted-in label present ....... (guaranteed by -l selector)
                  #  (b) a same-workload, non-terminal REPLACEMENT pod references the PVC
                  #  (c) the stranded pod sits on a NotReady node (not a lookup error)
                  if [ -z "$OLD_POD" ]; then
                    if [ "$NODE_ERR" -eq 1 ]; then
                      log "[$NS/$PVC] node Ready lookup failed this pass; taking no action (won't treat an API/RBAC error as a failed node)."
                    else
                      log "[$NS/$PVC] healthy: bound to PV '$PV', no pod on a NotReady node — no action."
                    fi
                    continue   # no stranded pod on a genuinely bad node
                  fi
                  if [ "$REPLACEMENT" -ne 1 ]; then
                    log "[$NS/$PVC] stranded pod '$OLD_POD' on NotReady node '$OLD_NODE', but no same-workload replacement pod references this PVC yet (need a rescheduled replacement). Waiting."
                    continue
                  fi

                  # ---- Multi-PVC safety guard (team decision, 2026-09-02) ----------
                  # Err on the side of caution: the remediation action force-deletes the
                  # WHOLE stranded pod, which affects every volume it mounts. If that pod
                  # also mounts any PVC that is NOT opted in, we must NOT remediate — we
                  # will not disrupt a pod carrying a non-consented volume (and we could
                  # not fully recover it anyway, since the opted-out volume's stale
                  # attachment is never cleaned). Require ALL of the pod's PVCs opted in.
                  NON_OPTED=""
                  for CLAIM in $(printf '%s' "$OLD_CLAIMS" | tr ',' ' '); do
                    [ -z "$CLAIM" ] && continue
                    CL=$(kubectl get pvc "$CLAIM" -n "$NS" \
                          -o go-template="{{index .metadata.labels \"${LABEL_KEY}\"}}" 2>/dev/null)
                    [ "$CL" = "$LABEL_VALUE" ] || NON_OPTED="${NON_OPTED} ${CLAIM}"
                  done
                  if [ -n "$NON_OPTED" ]; then
                    log "[$NS/$PVC] SKIP (multi-PVC safety): stranded pod '$OLD_POD' also mounts non-opted-in PVC(s):${NON_OPTED}. Refusing to remediate a pod that carries non-consented volume(s); manual intervention required."
                    rm -f "$STATE_DIR/${NS}__${PVC}__${OLD_NODE}" 2>/dev/null
                    continue
                  fi

                  KEY="${NS}__${PVC}__${OLD_NODE}"
                  ACTIVE_KEYS="${ACTIVE_KEYS}${KEY} "
                  SF="$STATE_DIR/$KEY"
                  NOW=$(date -u +%s)
                  if [ ! -f "$SF" ]; then
                    echo "$NOW" > "$SF"
                    log "[$NS/$PVC] STUCK: pod '$OLD_POD' on NotReady node '$OLD_NODE'; same-workload replacement pod is waiting. Failover timer started."
                  fi
                  FIRST=$(cat "$SF" 2>/dev/null || echo "$NOW")
                  ELAPSED=$(( NOW - FIRST ))

                  # Read the per-PVC delay override annotation. NOTE: jsonpath cannot
                  # address an annotation key containing dots (it treats each '.' as a
                  # path separator). go-template's `index` takes the key as a literal
                  # string, so it handles dotted keys correctly. Missing key -> "<no value>".
                  ANN=$(kubectl get pvc "$PVC" -n "$NS" \
                        -o go-template="{{index .metadata.annotations \"${DELAY_ANNOTATION}\"}}" 2>/dev/null)
                  case "$ANN" in
                    "<no value>"|"") ANN="" ;;
                  esac
                  DELAY=$(to_seconds "$ANN" "$DEFAULT_DELAY_SECONDS")

                  if [ "$ELAPSED" -lt "$DELAY" ]; then
                    log "[$NS/$PVC] waiting ${ELAPSED}s / ${DELAY}s before failover (node '$OLD_NODE' NotReady)."
                    continue
                  fi

                  log "[$NS/$PVC] delay reached (${ELAPSED}s >= ${DELAY}s). Failing over stranded pod '$OLD_POD' off node '$OLD_NODE'. [$(arm_state)]"

                  # 1) Force-delete the stranded pod so it stops "holding" its volumes.
                  #    If this fails, ABORT before detaching: deleting VolumeAttachments
                  #    while the pod still exists would let the attach/detach controller
                  #    re-create them, and would leave the workload in an inconsistent
                  #    partial state. Keep the timer so the next pass retries cleanly.
                  if ! krun delete pod "$OLD_POD" -n "$NS" --grace-period=0 --force; then
                    log "[$NS/$PVC] pod deletion failed; aborting failover for this pass and retaining timer for retry."
                    continue
                  fi

                  # 2) Delete the stale VolumeAttachment(s) on the dead node for EVERY PVC
                  #    this pod mounts — not just the current one. Deleting the whole pod
                  #    detaches all its volumes, and a multi-PVC pod's replacement can only
                  #    start once ALL of them are freed. The multi-PVC safety guard above
                  #    guarantees every claim on this pod is opted in, so cleaning them all
                  #    is consistent with the opt-in contract.
                  #
                  #    The stranded pod has already been deleted above, so a later
                  #    reconcile pass can no longer rediscover it (the pod-based scan keys
                  #    off OLD_POD, which would come back empty) — a failed detach therefore
                  #    CANNOT be retried on a future pass. Retry the whole detach sweep
                  #    in-pass, bounded by DETACH_ATTEMPTS, until every required
                  #    VolumeAttachment is gone. Each attempt re-lists VolumeAttachments so
                  #    we only act on what still exists.
                  DETACH_FAILED=1
                  ATTEMPT=1
                  while [ "$ATTEMPT" -le "$DETACH_ATTEMPTS" ]; do
                    # List current VolumeAttachments. Distinguish a genuine "no rows"
                    # result from an API error: on error we must NOT conclude the volume
                    # is already detached, or we would falsely log "failover complete"
                    # while the stale attachment is still in place. A failed list is
                    # treated as a failed attempt so the loop retries.
                    if kubectl get volumeattachments \
                         -o jsonpath='{range .items[*]}{.metadata.name}{"|"}{.spec.nodeName}{"|"}{.spec.source.persistentVolumeName}{"\n"}{end}' \
                         > "$TMP/va" 2>/dev/null; then
                      VA_LIST_OK=1
                    else
                      VA_LIST_OK=0; : > "$TMP/va"
                      log "[$NS/$PVC]   WARNING: could not list VolumeAttachments (API error?); cannot confirm detach — will retry (attempt ${ATTEMPT}/${DETACH_ATTEMPTS})."
                    fi
                    DETACH_FAILED=0
                    for CLAIM in $(printf '%s' "$OLD_CLAIMS" | tr ',' ' '); do
                      [ -z "$CLAIM" ] && continue
                      # Resolve the PVC's bound PV. An empty result means either an API
                      # error or an unbound/missing PVC; combined with a failed VA list,
                      # we cannot verify the detach, so mark the attempt failed and retry
                      # rather than assume success.
                      CPV=$(kubectl get pvc "$CLAIM" -n "$NS" -o jsonpath='{.spec.volumeName}' 2>/dev/null)
                      if [ "$VA_LIST_OK" -eq 0 ] || [ -z "$CPV" ]; then
                        DETACH_FAILED=1
                        log "[$NS/$PVC]   cannot verify detach for PVC '$CLAIM' (VolumeAttachment list ok=${VA_LIST_OK}, PV='${CPV:-<unresolved>}'); will retry."
                        continue
                      fi
                      FOUND_VA=0
                      while IFS='|' read -r VANAME VANODE VAPV; do
                        [ -z "$VANAME" ] && continue
                        if [ "$VANODE" = "$OLD_NODE" ] && [ "$VAPV" = "$CPV" ]; then
                          FOUND_VA=1
                          log "[$NS/$PVC]   detaching PVC '$CLAIM' (PV '$CPV') from '$OLD_NODE' (attempt ${ATTEMPT}/${DETACH_ATTEMPTS})."
                          krun delete volumeattachment "$VANAME" || DETACH_FAILED=1
                        fi
                      done < "$TMP/va"
                      # Only a SUCCESSFUL list with no matching row proves "already detached".
                      [ "$FOUND_VA" -eq 0 ] && log "[$NS/$PVC]   no VolumeAttachment for PVC '$CLAIM' (PV '$CPV') on node '$OLD_NODE' (already detached)."
                    done
                    [ "$DETACH_FAILED" -eq 0 ] && break
                    if [ "$ATTEMPT" -lt "$DETACH_ATTEMPTS" ]; then
                      log "[$NS/$PVC]   one or more VolumeAttachment deletions failed or could not be verified; retrying in ${DETACH_RETRY_WAIT}s (attempt ${ATTEMPT}/${DETACH_ATTEMPTS})."
                      sleep "$DETACH_RETRY_WAIT"
                    fi
                    ATTEMPT=$((ATTEMPT + 1))
                  done

                  if [ "$DETACH_FAILED" -eq 0 ]; then
                    # All required detaches succeeded (or were already gone): clear the timer.
                    rm -f "$SF"
                    log "[$NS/$PVC] failover complete for pod '$OLD_POD' (DRY_RUN=${DRY_RUN})."
                  else
                    # Exhausted in-pass retries. The stranded pod is already gone, so the
                    # controller cannot self-heal this on a later pass — flag for an operator.
                    rm -f "$SF"
                    log "[$NS/$PVC] ERROR: VolumeAttachment cleanup did not complete after ${DETACH_ATTEMPTS} attempts on node '$OLD_NODE' (deletions failed or could not be verified via the API). The stranded pod is already deleted, so this will NOT auto-retry — manually confirm and remove the stale VolumeAttachment(s) before the replacement pod can attach."
                  fi
                done < "$TMP/pvcs"

                # ---- prune timers for conditions that have cleared -----------------
                for f in "$STATE_DIR"/*; do
                  [ -e "$f" ] || continue
                  b="${f##*/}"
                  case "$ACTIVE_KEYS" in
                    *" $b "*) : ;;                 # still active, keep
                    *) rm -f "$f"; log "Cleared stale failover timer: $b" ;;
                  esac
                done

                log "---- reconcile pass complete; sleeping ${RECONCILE_INTERVAL}s ----"
                sleep "$RECONCILE_INTERVAL"
              done
          resources:
            requests:
              cpu: "50m"
              memory: "64Mi"
            limits:
              cpu: "200m"
              memory: "128Mi"
      terminationGracePeriodSeconds: 10
```

Apply the manifest:

```bash
kubectl apply -f pvc-failover-controller.yaml
kubectl -n nexus-pvc-failover rollout status deploy/pvc-failover-controller
```

This step creates the `nexus-pvc-failover` namespace, a `ServiceAccount`, a `ClusterRole` and binding, and the controller `Deployment`.

## Observe the controller before you arm it

The manifest ships with `DRY_RUN=true`, so the controller only logs the actions it would take. Watch its logs against an opted-in PVC and confirm that it targets the correct pod and `VolumeAttachment` before you allow it to make changes:

```bash
kubectl -n nexus-pvc-failover logs deploy/pvc-failover-controller -f
```

Example log output when a volume is healthy:

```output
Tracking 1 opted-in PVC(s) (label nexus.microsoft.com/pvc-failover=enabled).
[team-a/data-web-0] healthy: bound to PV 'pvc-...', 1 pod(s) reference it, none on a NotReady node — no action.
```

Example log output when the multi-PVC safety guard skips a pod:

```output
[team-a/data-web-0] SKIP (multi-PVC safety): stranded pod 'web-0' also mounts non-opted-in PVC(s): scratch-web-0. Refusing to remediate a pod that carries non-consented volume(s); manual intervention required.
```

## Arm the controller

When you're satisfied with the dry-run output, set `DRY_RUN` to `false` to allow the controller to perform failover actions:

```bash
kubectl -n nexus-pvc-failover set env deploy/pvc-failover-controller DRY_RUN=false
```

Example log output for an armed failover:

```output
[team-a/data-web-0] delay reached (131s >= 120s). Failing over stranded pod 'web-0' off node 'nodeX'.
  EXEC: kubectl delete pod web-0 -n team-a --grace-period=0 --force
  detaching PVC 'data-web-0' (PV 'pvc-...') from 'nodeX'.
  EXEC: kubectl delete volumeattachment csi-...
```

## Understand the data-loss trade-off

Force-detaching a volume is a decision that the failed node is permanently gone.

- If the node is genuinely failed, failover is safe and your data re-attaches intact.
- If the node is only temporarily unreachable (for example, a network partition) and the original pod is still running and writing, force-detaching and re-attaching the volume elsewhere can cause data corruption or split-brain.

The opt-in label is your explicit acknowledgment that, for that volume, you accept this risk. Choose the per-PVC delay accordingly: a longer delay reduces the chance of acting on a transient condition, at the cost of a longer outage. Opt in only volumes whose workloads can tolerate this trade-off.

## Remove the controller

To remove the controller, follow these steps:

```bash
kubectl delete -f pvc-failover-controller.yaml
```

To stop failing over a specific volume without removing the controller, remove its opt-in label.

```bash
kubectl label pvc <pvc-name> -n <namespace> nexus.microsoft.com/pvc-failover-
```

## Related content

- [Nexus Kubernetes cluster QuickStart guide](./quickstarts-kubernetes-cluster-deployment-bicep.md)
- [Kubernetes: persistent volumes and how VolumeAttachments work](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
