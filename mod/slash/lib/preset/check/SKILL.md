---
name: check
description: Comprehensive check against all rules. Use when user says "/check" to verify code against project rules, with detailed TSV output of all violations.
tools: Bash, Glob, Read
---

# Project Health Checker (Rule-Based)

Comprehensive check that evaluates code against all applicable rules, reporting every violation found.

## Rule Format (YAML)

```yaml
P06-var-010:
  name: avoid-define-variable-like-path-shlvl-logname-home
  apply: all posix shell files
  desc:
  - 千万不要用定义 path, user, home 等这种系统级变量
  tldr:
  - wrong: local path;
    right: local path_list;
```

## Workflow

### 1. Parse Arguments

```
/check [--ruleset <dir>] [target_root]
```

### 2. Load Rules

```bash
# Find and read all rule files
x rule which      # locate ruleset
ls $ruleset_dir/*.yml
cat $ruleset_dir/*.yml
```

### 3. Check All Files Against All Rules

For each file under `target_root`:
1. Determine which rules apply (based on `apply` field)
2. Check each applicable rule
3. Record violations

### 4. Output TSV

```
root    target    ruleid    score    hint
/path   src/foo.sh  P06-var-010  10    变量命名不规范
/path   src/config.sh  P06-concept-010  10    术语使用不当
```

- **score**: 0-80
  - 0-10: Complete violation
  - 11-50: Significant issues
  - 51-80: Minor issues (still reported)
- Only rows where rule is violated (score < 81)
- If all files pass all rules: output just header row

## Examples

```bash
# Check current directory
x rule check

# Check with specific ruleset
x rule check -r :po6

# Check specific target
x rule check ./src
```

## Rule `apply` Field

Determines which files a rule applies to:

| Apply Value | Files Matched |
|-------------|--------------|
| `all posix shell files` | `*.sh` files |
| `all shell files` | `*.sh`, `*.bash`, `*.zsh` |
| `all yaml files` | `*.yml`, `*.yaml` |
| `all json files` | `*.json` |
| `all source files` | source code files |
| `all files` | any file |