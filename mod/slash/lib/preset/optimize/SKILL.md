---
name: optimize
description: Review code for efficiency and performance. Use when user says "/optimify" to identify bottlenecks, suggest algorithmic improvements, or fix performance issues.
---

# Performance Optimizer

Analyze code for efficiency issues, bottlenecks, and optimization opportunities.

## Workflow

### 1. Profile First

```bash
# Identify hotspots
/usr/bin/time -v ./script.sh        # Linux
 Instruments.app / script.sh        # macOS

# For Python
python -m cProfile -s cumtime script.py

# For Node.js
node --prof script.js
node --prof-process
```

### 2. Identify Bottlenecks

| Type | Symptoms | Common Causes |
|------|----------|---------------|
| CPU | High %CPU, slow computation | O(n²) loops, inefficient algos |
| Memory | Growing RSS, OOM | Memory leaks, unbounded caches |
| I/O | Low CPU, high wait | Sync I/O, not batched |
| Network | Slow requests | No caching, sequential calls |
| Database | Slow queries | Missing indexes, N+1 queries |

### 3. Analyze Code

```bash
# Check algorithmic complexity
# - Nested loops over collections?
# - Repeated expensive operations?
# - Unnecessary array/ object copies?

# Check for:
# - O(n²) algorithms that could be O(n log n)
# - Sync I/O that could be async
# - N+1 query patterns
# - Missing database indexes
# - Unbounded memory growth
```

### 4. Optimization Strategies

```markdown
## Performance Review

### Bottlenecks Found

#### 🔴 Database Query (N+1)
**File**: `db.py:45`
**Issue**: Fetching users one by one in loop
**Impact**: 1000 users = 1001 queries
**Fix**: Batch query or eager load

#### 🟠 Inefficient Loop
**File**: `processor.py:23`
**Issue**: O(n²) nested loop for matching
**Fix**: Use hash lookup → O(n)

#### 🟡 Missing Cache
**File**: `api.py:67`
**Issue**: Repeated expensive computation
**Fix**: Cache with TTL

### Recommendations (Priority Order)
1. Add index on `users.created_at`
2. Replace nested loop with hash join
3. Cache /api/config response for 60s
```

### 5. Common Fixes

| Before | After | Speedup |
|--------|-------|---------|
| `O(n²)` nested loop | Hash lookup | n→1 |
| Sync I/O loop | Parallel async | n×threads |
| N+1 queries | Batch query | n→1 |
| No cache | LRU cache | avg case |

## Profiling Tips

1. **Measure first**: Don't optimize without data
2. **Amdahl's Law**: Focus on the 20% that takes 80%
3. **Profile, don't guess**: Use `perf`, `valgrind`, language profilers
4. **Verify**: Measure after each change

## Red Flags

- Nested loops over large datasets
- `SELECT *` in loops
- `JSON.parse`/`JSON.stringify` in hot paths
- Creating objects/arrays in tight loops
- Unbounded file reads into memory