---
name: security-review
description: Security audit for code changes. Use when user says "/security-review" to review pending changes for vulnerabilities, or when adding/modifying authentication, authorization, cryptography, or input handling.
---

# Security Reviewer

Analyze code changes for security vulnerabilities following OWASP Top 10 and common security patterns.

## Workflow

### 1. Gather Context

```bash
# Get diff of changes
git diff main..HEAD
git diff --staged

# List new/modified files
git diff --name-only main..HEAD

# Check for dependency changes
cat package.json  # or pyproject.toml, go.mod, etc.
```

### 2. Identify Risk Areas

Scan for common vulnerability patterns:

| Pattern | Risk |
|---------|------|
| User input without validation | Injection attacks |
| `eval()`, `exec()`, `shell_exec()` | Command injection |
| SQL concatenation | SQL injection |
| `innerHTML`, `dangerouslySetInnerHTML` | XSS |
| `crypto.*` without TLS | Weak cryptography |
| Hardcoded secrets, API keys | Secret exposure |
| File operations with user paths | Path traversal |
| Auth without rate limiting | Brute force |

### 3. Security Checklist

- [ ] **Injection**: All user inputs validated/sanitized?
- [ ] **Authentication**: Proper auth flow, session management?
- [ ] **Authorization**: Access control checks before actions?
- [ ] **Cryptography**: No weak algs (MD5, SHA1 for passwords)?
- [ ] **Secrets**: No hardcoded credentials in code?
- [ ] **Input Validation**: All external data validated?
- [ ] **Output Encoding**: XSS prevented in rendered output?
- [ ] **Rate Limiting**: APIs protected against abuse?
- [ ] **Logging**: Sensitive data not logged?

### 4. Generate Report

```markdown
## Security Review

### Scope
Files: N | Lines changed: +N/-N

### Findings

#### 🔴 Critical
[Description, location, exploit scenario, recommendation]

#### 🟠 High
[...]

#### 🟡 Medium
[...]

#### 🟢 Info
[...]

### Summary
Total: N | Critical: N | High: N | Medium: N

## Recommendations
1. [Priority fix]
2. [Next steps]
```

### 5. Common Fixes

```markdown
# SQL Injection → Use parameterized queries
- Bad:  WHERE id = '$user_input'
+ Good: WHERE id = $1  [with prepared statements]

# XSS → Escape output
- Bad:  element.innerHTML = userInput
+ Good: element.textContent = userInput

# Secrets → Use environment variables
- Bad:  const apiKey = "sk-123456..."
+ Good: const apiKey = process.env.API_KEY
```