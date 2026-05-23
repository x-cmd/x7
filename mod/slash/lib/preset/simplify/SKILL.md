---
name: simplify
description: Review code for reuse, readability, and simplicity. Use when user says "/simplify" to refactor complex code, extract abstractions, or clean up duplication.
---

# Code Simplifier

Analyze code for unnecessary complexity, duplication, and missed opportunities for reuse.

## Workflow

### 1. Gather Code Changes

```bash
# For review: diff against base
git diff main..HEAD --stat

# For specific file
cat path/to/file

# Check for related files with similar patterns
find . -name "*.py" -o -name "*.js" -o -name "*.go" | head -20
```

### 2. Analyze Quality Issues

### Readability
- Long functions (>50 lines) → split
- Deep nesting (>3 levels) → extract
- Unclear names → rename
- Magic numbers → constants

### Reuse
- Duplicated code blocks → extract to helper
- Similar patterns → abstract to common function
- Custom implementations → use standard library

### Complexity
- Over-engineering → simplify
- Premature optimization → defer
- Feature envy → move data closer to behavior
- shotgun surgery → consolidate changes

### 3. Generate Recommendations

```markdown
## Simplification Review

### Readability Issues
| File | Line | Issue | Suggestion |
|------|------|-------|-----------|
| auth.py | 45 | Function 80 lines | Split by responsibility |

### Duplication Found
```python
# auth.py:23 and user.py:67 are identical
# → Extract to auth_utils.py
```

### Complexity Concerns
- `RequestHandler` has 5 responsibilities → Consider single responsibility

### Suggested Refactors
1. Extract `validate_token()` from lines 23-45
2. Replace `for i in range(len(xs))` with `for x in xs`
3. Move `format_date()` to shared date_utils module
```

### 4. Apply Fixes

- Make edits **only** for clear wins
- Don't over-abstract
- Prefer explicit over clever
- Keep it simple: 3 similar lines is better than a premature abstraction

## Principles

| Avoid | Prefer |
|-------|--------|
| Complex one-liners | Clear multi-line |
| Premature abstraction | Wait for duplication |
| Clever shortcuts | Obvious approach |
| Deep nesting | Early returns |

## Red Flags

- `else` after `return`
- Comments explaining "why" that should be code
- Functions with >3 parameters
- Files >500 lines
- Classes with >10 methods