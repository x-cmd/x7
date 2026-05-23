---
name: review
description: Review pull requests. Use when user says "/review" with a PR link or wants to review pending changes.
---

# PR Reviewer

Review pull requests with focused analysis of changes, context, and recommendations.

## Workflow

### 1. Parse PR Link

Accepts:
- `https://github.com/owner/repo/pull/123`
- `gh pr view <number>` for current repo
- Short forms like `#123` or `owner/repo#123`

### 2. Fetch PR Details

```bash
# GitHub PR
gh pr view <pr> --json title,body,state,base,head,files,additions,deletions,changedFiles

# Get diff
gh pr diff <pr>

# List comments
gh api repos/:owner/:repo/pulls/:pr/comments
```

### 3. Analyze Changes

- **Files changed**: Identify key files
- **Code review**: Read diff line by line
- **Security check**: Look for secrets, SQL injection, XSS, etc.
- **Design review**: Evaluate architecture decisions

### 4. Generate Review

Structure output:

```markdown
## PR Summary
- Title: ...
- Author: ...
- Files: N | Additions: +N | Deletions: -N

## Changes Overview
[High-level description]

## Detailed Review
### Approved ✓
[Positive feedback]

### Suggestions
[Improvement recommendations]

### Concerns
[Issues that need addressing]

## Recommendation
[Approve / Request Changes / Comment]
```

### 5. Post Review (optional)

```bash
# Post review comments
gh pr comment <pr> --body "$(cat review.md)"

# Or approve/request changes
gh pr review <pr> --approve
gh pr review <pr> --request-changes
```

## Local PRs

For local branches not yet PR'd:

```bash
git log main..HEAD --oneline
git diff main..HEAD --stat
```