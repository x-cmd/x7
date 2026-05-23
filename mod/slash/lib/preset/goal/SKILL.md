---
name: goal
description: Set and track project goals. Use when user says "/goal" to define objectives, track milestones, or align on project direction.
---

# Goal Tracker

Define, track, and review project goals and milestones.

## Workflow

### 1. Parse Goal Input

Accepts:
- Natural language description: "Ship feature X by end of month"
- Structured format: "goal: description, deadline: YYYY-MM-DD"
- Update format: "/goal update #1 - completed"

### 2. Store Goal

```bash
# Store in local goal file or project management tool
# Example: ~/.goals/current_project.md

# Format
- id: 1
  description: Ship user authentication
  deadline: 2026-05-30
  status: in_progress
  created: 2026-05-23
```

### 3. Track Progress

| Command | Action |
|---------|--------|
| `/goal` | List active goals |
| `/goal #1` | Show goal #1 details |
| `/goal update #1` | Update goal status |
| `/goal done #1` | Mark as completed |
| `/goal delete #1` | Remove goal |

### 4. Report Status

```markdown
## Active Goals

### #1: Ship user authentication
- **Status**: In Progress
- **Deadline**: 2026-05-30 (7 days left)
- **Progress**: 60%
- **Milestones**:
  - [x] Database schema
  - [x] Login endpoint
  - [ ] Registration flow
  - [ ] Password reset

### #2: Fix login bug
- **Status**: Blocked
- **Blocking**: Waiting on DB credentials
```

## Integration

For GitHub integration:
```bash
# Link goal to issue
gh issue comment <issue> --body "Tracked in goal #1"
```

For team visibility:
```bash
# Share goal summary
cat ~/.goals/project.md
```