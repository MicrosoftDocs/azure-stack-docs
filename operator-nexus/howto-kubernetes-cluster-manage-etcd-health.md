---
title: ETCD best practices for Azure Operator Nexus Kubernetes clusters
description: Learn about ETCD best practices for maintaining healthy Nexus AKS clusters, including backups, compaction, defragmentation, and monitoring.
author: abailey011
ms.author: alexbailey
ms.service: operator-nexus
ms.topic: how-to
ms.date: 02/26/2026
ms.custom: template-how-to-pattern
---

# ETCD Best Practices for Nexus AKS Clusters

## Overview

This document provides guidance on ETCD best practices for Nexus AKS cluster owners. ETCD is the distributed key-value store that serves as the backing store for all Kubernetes cluster data. The health and performance of ETCD directly impacts the availability and reliability of your Kubernetes cluster.

**Important Note:** The practices outlined in this document are recommendations based on industry best practices. It is the responsibility of the cluster owner to implement these recommendations and maintain the health of their ETCD database. The specific implementation details should be determined by your organization based on your operational requirements and environment.

## Understanding ETCD in Kubernetes

ETCD stores all cluster state, including:
- Cluster configuration and metadata
- Pod specifications and status
- Service definitions
- ConfigMaps and Secrets
- Resource quotas and limits
- Custom Resource Definitions (CRDs) and their instances

Any degradation or failure of ETCD can result in cluster instability or complete cluster failure, making proper ETCD maintenance critical for cluster health.

## Best Practices

### 1. Regular ETCD Backups

#### What It Is
Regular backups involve taking periodic snapshots of the ETCD database to capture the complete state of your Kubernetes cluster at specific points in time.

#### Why It Is Important
ETCD backups are your last line of defense against data loss and cluster failure. They enable:
- **Disaster Recovery**: Restore your cluster to a known good state after catastrophic failures
- **Data Protection**: Protect against accidental deletions, misconfigurations, or corruption
- **Cluster Migration**: Facilitate cluster migrations or recreations
- **Compliance**: Meet organizational or regulatory requirements for data retention

#### Problems Without Regular Backups
If you don't maintain regular ETCD backups, you could face:
- **Irrecoverable Cluster Loss**: Complete loss of cluster state with no way to recover
- **Extended Downtime**: Inability to restore services quickly after failures
- **Data Loss**: Loss of critical configuration, application state, and operational data
- **Business Impact**: Significant business disruption requiring complete cluster rebuilding from scratch
- **Compliance Violations**: Failure to meet backup and disaster recovery requirements

#### Recommendations
In order to ensure effective ETCD backup practices, consider the following recommendations:
- Establish a backup schedule appropriate for your organization's Recovery Point Objective (RPO)
- Store backups in a secure, separate location from the cluster itself
- Implement backup retention policies aligned with your business requirements
- To ensure recoverability, regularly test backup restoration procedures
- To ensure consistency and reliability, automate backup processes

### 2. ETCD Defragmentation

#### What It Is
ETCD defragmentation is the process of reclaiming storage space by removing gaps left by deleted or modified keys in the ETCD database. Over time, as keys are updated or deleted, the database accumulates fragmentation, where storage space is allocated but not actively used.

#### Why It Is Important
Defragmentation is crucial for:
- **Performance Optimization**: Reduces database size and improves query performance
- **Storage Efficiency**: Reclaims disk space that would otherwise remain allocated but unused
- **Cluster Stability**: Prevents storage-related issues that can affect cluster operations
- **Resource Management**: Ensures efficient use of available storage resources

#### Problems Without Regular Defragmentation
Failing to defragment ETCD regularly can lead to:
- **Performance Degradation**: Slower API server responses and increased latency for cluster operations
- **Storage Exhaustion**: Running out of disk space even when the actual data size is small
- **Increased Backup Size**: Large backup files that consume more storage and take longer to create
- **Cluster Instability**: ETCD could become unresponsive or fail if storage becomes critically low
- **Operational Issues**: Difficulty performing cluster operations due to degraded ETCD performance

#### Recommendations
- Monitor ETCD fragmentation levels regularly
- Perform defragmentation during maintenance windows when fragmentation exceeds acceptable thresholds
- Consider the effect on cluster operations during defragmentation (brief unavailability per ETCD member)
- Defragment all ETCD cluster members sequentially, not simultaneously
- Validate cluster health after defragmentation operations

### 3. ETCD Health Monitoring

#### What It Is
ETCD health monitoring involves continuously tracking key metrics and health indicators of your ETCD cluster to detect and respond to issues proactively.

#### Why It Is Important
Proactive monitoring enables:
- **Early Issue Detection**: Identify problems before they affect cluster availability
- **Trend Analysis**: Understand usage patterns and plan for capacity needs
- **Performance Optimization**: Identify and address performance bottlenecks
- **Informed Decision Making**: Make data-driven decisions about maintenance and scaling
- **Reduced Downtime**: Minimize mean time to detection (MTTD) and mean time to resolution (MTTR)

#### Problems Without Adequate Monitoring
Without proper ETCD monitoring, you risk:
- **Undetected Failures**: Critical issues going unnoticed until they cause cluster outages
- **Reactive Operations**: Discovering problems only after users report issues
- **Cascading Failures**: Small issues escalating into major incidents
- **Poor Capacity Planning**: Running out of resources without advance warning
- **Increased Recovery Time**: Longer troubleshooting and remediation due to lack of historical data

#### Key Metrics to Monitor

**Database Size and Growth**
- Current database size
- Rate of growth over time
- Comparison against available storage capacity
- Alert thresholds for approaching storage limits

**Fragmentation Levels**
- Percentage of fragmentation (actual data size vs. allocated size)
- Trend over time
- Threshold alerts (such as >50% fragmentation)

**Performance Metrics**
- Request latency (apply, range, commit)
- Request rate and throughput
- Leader election frequency
- Network latency between ETCD members

**Cluster Health**
- Member availability and connectivity
- Leader status
- Consensus/quorum health
- Failed proposals and errors

**Resource Utilization**
- Disk I/O operations and throughput
- CPU and memory usage
- Network bandwidth utilization
- File descriptor usage

#### Recommendations
- Implement automated monitoring with alerting for critical thresholds
- To identify anomalies, establish baseline metrics
- Create runbooks for common ETCD issues and their remediation
- Integrate ETCD metrics into your existing monitoring and observability platforms

### 4. Database Size Management

#### What It Is
Database size management involves controlling the growth of the ETCD database through proper configuration, regular maintenance, and operational practices that prevent unbounded growth.

#### Why It Is Important
Proper size management ensures:
- **Predictable Performance**: Smaller, well-maintained databases perform more consistently
- **Resource Efficiency**: Optimal use of storage and memory resources
- **Operational Simplicity**: Easier backups, migrations, and maintenance operations
- **Cost Management**: Reduced storage costs and resource requirements
- **Cluster Stability**: Prevention of storage-related failures

#### Problems Without Size Management
Failure to manage database size can result in:
- **Performance Degradation**: Slow cluster operations as database grows unbounded
- **Storage Exhaustion**: Running out of disk space, potentially causing cluster failure
- **Backup Challenges**: Excessively large backups that are slow to create and difficult to manage
- **Memory Pressure**: ETCD requiring excessive memory to operate effectively
- **Operational Complexity**: Difficulty performing maintenance, migrations, or recovery operations
- **Increased Costs**: Higher storage and infrastructure costs

#### Recommendations
- Configure appropriate ETCD quota limits based on your cluster size and workload
- Implement automated cleanup of old revisions (ETCD history compaction)
- Avoid storing large objects in ETCD (use external storage for large data)
- Monitor the number and size of objects stored in ETCD
- Review and cleanup unused Kubernetes resources regularly (old secrets, configmaps, etc.)
- Configure appropriate retention policies for Kubernetes audit logs if stored in ETCD

### 5. ETCD Cluster Maintenance

#### What It Is
ETCD cluster maintenance encompasses regular operational activities to ensure the long-term health, security, and reliability of your ETCD infrastructure.

#### Why It Is Important
Regular maintenance provides:
- **Stability**: Prevention of issues through proactive maintenance
- **Performance**: Optimization of configuration and operations over time
- **Compliance**: Meeting security and operational standards
- **Risk Reduction**: Minimizing the likelihood of unexpected failures

#### Problems Without Regular Maintenance
Neglecting ETCD maintenance can lead to:
- **Security Vulnerabilities**: Exposure to known security issues and exploits
- **Unexpected Failures**: Accumulation of small issues leading to major incidents
- **Performance Issues**: Suboptimal configuration causing degraded performance
- **Compatibility Problems**: Difficulties upgrading Kubernetes or other components
- **Increased Technical Debt**: Deferred maintenance making future operations more complex and risky

#### Recommendations
- Perform regular health checks using automated tools
- Test disaster recovery procedures regularly (backup and restore)
- Document ETCD architecture, configuration, and operational procedures
- Conduct capacity planning and performance reviews
- Validate TLS certificates and credentials before expiration

## Monitoring Tools and Resources

Several tools and approaches can help you implement these best practices:

- **ETCD Metrics**: ETCD exposes Prometheus-compatible metrics that can be integrated into your monitoring platform.
- **Kubernetes Events**: Monitor Kubernetes events for ETCD-related warnings and errors.
- **Custom Monitoring**: Implement custom scripts or tools tailored to your operational requirements.

## Summary

ETCD health is fundamental to Kubernetes cluster stability and availability. By implementing these best practices - regular backups, periodic defragmentation, continuous monitoring, proactive size management, and consistent maintenance - you can significantly reduce the risk of ETCD-related incidents and ensure the long-term reliability of your Nexus AKS clusters.

**Remember**: The recommendations in this document are based on industry best practices. It's the responsibility of the cluster owner to implement, maintain, and customize these practices according to your specific operational requirements, risk tolerance, and organizational policies.
