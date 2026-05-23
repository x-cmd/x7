---
name: assess
description: Multi-phase project assessment with scoring and summary. Use when user says "/assess" to evaluate project health across multiple dimensions, generate a comprehensive report.
tools: Bash, Glob, Read
---

# Project Assessor (Multi-Phase)

Comprehensive assessment with multiple phases: target discovery, rule scoring, and summary generation.

## Workflow

### Phase 1: Discover Targets

Generate `target.tsv` — maps each file to applicable rules.

**Input**: All rule files + all source files
**Output**: `target.tsv` (target → rule-to-check mapping)

```
root    target    rule-to-check
./     src/auth.sh    P06-var-010 P06-var-020
./     src/config.sh  P06-concept-010
./     docs/readme.md P06-concept-010
```

Rules apply based on their `apply` field.

### Phase 2: Score Each Pair

Generate `result/<rule-id>.tsv` files.

**Input**: `target.tsv` + all rule files + all source files
**Output**: `result/*.tsv` (one per rule)

```
target    score    hint
src/auth.sh  90    变量命名不规范
src/config.sh  100
```

**Scoring (0-100)**:
- 100: Full compliance
- 81-99: Minor issues
- 51-80: Marginal, improvement needed
- 11-50: Significant violations
- 0-10: Complete disregard

### Phase 3: Summary

Aggregate all result files into a summary report.

**Output**:
```markdown
## Assessment Summary

### Overall Score: 85/100

### Rules Breakdown
| Rule | Score | Issues |
|------|-------|--------|
| P06-var-010 | 90 | 2 files need fixing |
| P06-concept-010 | 75 | terminology issues |

### Top Violations
1. src/auth.sh:23 — variable naming
2. src/utils.sh:45 — shellcheck warnings

### Recommendations
- Fix variable naming in auth.sh
- Update terminology in docs/
```

## Standalone Assessment (No Ruleset)

When no ruleset is available, use general heuristics:

### Dimensions to Check

| Dimension | What to Check |
|-----------|---------------|
| **Code Health** | Tests passing? Lint clean? |
| **Dependencies** | Outdated? Vulnerable? |
| **Documentation** | README current? |
| **Security** | Secrets exposed? Input validated? |
| **Complexity** | Files too large? Deep nesting? |
| **CI/CD** | Pipelines green? |

### General Assessment Output

```markdown
## Project Assessment

### Overview
- Last commit: [date]
- Commits ahead: N
- Open PRs: N

### Overall Score: [N]/100
[N] criteria met, [N] needs attention, [N] critical

### Status by Dimension
#### ✅ Health
- Tests: 47/50 passing
- Lint: Clean

#### ⚠️ Attention
- 3 packages outdated
- README 6 months old

#### ❌ Blockers
- SQL injection in db.py:45
- Missing DATABASE_URL
```

### Risk Summary Table

| Risk | Severity | Location | Mitigation |
|------|----------|----------|------------|
| SQL injection | High | db.py:45 | Use parameterized queries |
| Outdated JWT lib | Medium | package.json | Upgrade to v3.0 |

## Report Location

Assessment reports stored at:
```
~/.x-cmd.root/v/.repo/data/rule/assess/<timestamp>-<pid>/
  target.tsv
  result/
    *.tsv
  summary.md
```