---
name: scan
description: Quick greedy scan for the most critical violations. Use when user says "/scan" to quickly find the top 1-5 most severe issues — stops early, speed over completeness.
tools: Bash, Glob, Read
---

# Code Scanner (Greedy Quick Scan)

Quickly scan for the 1-5 most critical violations, then stop. Speed over completeness.

## Rule Format (YAML)

Slash commands use rule files in this format:

```yaml
P06-var-010:
  name: avoid-define-variable-like-path-shlvl-logname-home
  apply: all posix shell files
  desc:
  - 重点避免 path, home, user
  tldr:
  - wrong: local path;
    right: local path_list;
```

## Workflow

### 1. Parse Arguments

```
/scan [--ruleset <dir>] [target_root]
```

- `--ruleset <dir>`: specify ruleset directory (contains `*.yml` rule files)
- `target_root`: directory to scan (default: current directory)

### 2. Load Rules

```bash
# Find ruleset
x rule which      # or use -r flag

# List rule files
ls $ruleset_dir/*.yml

# Read all rule files
cat $ruleset_dir/*.yml
```

### 3. Greedy Scan (Stop at 1-5 Issues)

Strategy:
- **Do NOT** check every file against every rule
- Find the 1-5 most obvious, most severe violations
- Trust first instinct — if something looks wrong, report it immediately
- Speed matters more than completeness
- If nothing obviously wrong, output just the header row

### 4. Output TSV

```
root    target    ruleid    score    hint
/path   src/foo.sh  P06-var-010  10    变量命名不规范
```

- **score**: 0-80 (how severe the violation is)
- **hint**: brief explanation in Chinese
- If clean: output only header row

## Examples

```bash
# Scan current directory
x rule scan

# Scan with specific ruleset
x rule scan -r :po6

# Scan specific target
x rule scan ./src
```

## Key Differences from `/check`

| Aspect | `/scan` | `/check` |
|--------|---------|----------|
| Scope | 1-5 critical issues | All violations |
| Speed | Fast (stops early) | Thorough |
| Strategy | Greedy | Exhaust all rules |