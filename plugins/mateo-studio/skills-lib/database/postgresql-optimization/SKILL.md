---
name: postgresql-optimization
description: "PostgreSQL database optimization workflow for query tuning, indexing strategies, performance analysis, and production database management."
category: granular-workflow-bundle
risk: safe
source: personal
date_added: "2026-02-27"
---

# PostgreSQL Optimization Workflow

## Overview

Specialized workflow for PostgreSQL database optimization including query tuning, indexing strategies, performance analysis, vacuum management, and production database administration.

## When to Use This Workflow

Use this workflow when:
- Optimizing slow PostgreSQL queries
- Designing indexing strategies
- Analyzing database performance
- Tuning PostgreSQL configuration
- Managing production databases

## Workflow Phases

### Phase 1: Performance Assessment
1. Check database version
2. Review configuration
3. Analyze slow queries
4. Check resource usage
5. Identify bottlenecks

### Phase 2: Query Analysis
1. Run EXPLAIN ANALYZE
2. Identify scan types
3. Check join strategies
4. Analyze execution time
5. Find optimization opportunities

### Phase 3: Indexing Strategy
1. Identify missing indexes
2. Create B-tree indexes
3. Add composite indexes
4. Consider partial indexes
5. Review index usage

### Phase 4: Query Optimization
1. Rewrite inefficient queries
2. Optimize joins
3. Add CTEs where helpful
4. Implement pagination
5. Test improvements

### Phase 5: Configuration Tuning
1. Tune shared_buffers
2. Configure work_mem
3. Set effective_cache_size
4. Adjust checkpoint settings
5. Configure autovacuum

### Phase 6: Maintenance
1. Schedule VACUUM
2. Run ANALYZE
3. Check table bloat
4. Monitor autovacuum
5. Review statistics

## Optimization Checklist

- [ ] Slow queries identified
- [ ] Indexes optimized
- [ ] Configuration tuned
- [ ] Maintenance scheduled
- [ ] Monitoring active
- [ ] Performance improved
