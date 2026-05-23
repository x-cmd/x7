---
name: work
description: Handle issue/PR/work items. Creates worktree branches for focused work. Use when user says "/work" with an issue/PR link, or wants to start focused work on a task.
---

# Work Handler

Start focused work on an issue, PR, or arbitrary task by creating an isolated worktree.

## Workflow

### 1. Parse Input

```
/work [issue_link or pr_link or natural description]
```

- **Issue/PR link** (GitHub, GitLab, etc.): Parse issue/PR number, fetch details
- **Arbitrary task**: Use user's description as branch name

### 2. Fetch Context (for links)

```bash
# For GitHub issues/PRs
gh issue view <number> --json title,body,labels,assignees
gh pr view <number> --json title,body,labels,files

# For GitLab issues
glab issue view <number>
glab mr view <number>
```

### 3. Create Worktree

```bash
# Extract issue/PR identifier for branch name
BRANCH_NAME="work/$(date +%Y%m%d)-$(echo "$TITLE" | slugify)"

# Create worktree
git worktree add -b "$BRANCH_NAME" . ".$x-cmd.root/v/.repo/../worktrees/$BRANCH_NAME"

# Or: Enter existing worktree if already created
```

### 4. Prepare Work Environment

- Checkout relevant files/dirs if needed
- Copy or link any necessary context
- Set up branch tracking

### 5. Report to User

```
Created worktree: $BRANCH_NAME
Location: $WORKTREE_PATH
Issue: $ISSUE_TITLE (#$NUMBER)
```

---

## External Web Page Flow

If `/work` is followed by a URL (not an issue/PR):

1. **Fetch content**: `WebFetch` the URL
2. **Summarize**: Present key points to user
3. **Discuss**: "How should we integrate this?" and wait for user input
4. **Apply**: User provides guidance → implement accordingly

## Branch Naming

```
work/YYYYMMDD-short-description
work/20260523-fix-login-bug
work/20260523-issue-123
```

## Exit

When work is done:
- `git commit` in worktree
- User can merge via PR or `git worktree remove`