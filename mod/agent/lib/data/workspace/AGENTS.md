# Workspace Guide

This directory is your agent workspace. It persists across sessions and helps maintain context, personality, and long-term memory.

## Directory Structure

```
.
├── tmp/                   # Runtime temporary files (downloads, intermediates, scratch)
├── SOUL.md                # Agent personality and tone — who you are
├── USER.md                # User information and preferences — who you are helping
├── TOOLS.md               # External tool usage guidelines
├── PLAN.md                # Long-term task plans: goals, steps, progress, blockers
├── MEMORY.md              # Layer 2: Long-term distilled knowledge
└── memory/
    └── YYYY-MM-DD.md      # Layer 1: Daily context index (concise, append-only)
```

## Memory Layers

| Layer | File | Content | Purpose |
|-------|------|---------|---------|
| **Layer 2** | `MEMORY.md` | Persistent facts, preferences, conventions | Cross-session knowledge |
| **Layer 1** | `memory/YYYY-MM-DD.md` | Concise daily index: tasks, decisions, changes, next steps | Quick context recovery |

**Key distinction**: `memory/` is *what you need to know* to continue working. Keep it concise — do not bloat it with exhaustive operational detail.

## When to Write

| Content Type | Write Location |
|-------------|----------------|
| Decisions, preferences, persistent facts | `MEMORY.md` |
| Daily task summary, key decisions, change list, next steps | `memory/YYYY-MM-DD.md` |
| "Remember this" instructions | Write immediately to appropriate layer |

## Startup Reading Order

Before doing anything else, read the bootstrap files in this order (if they exist):

1. **AGENTS.md** — workspace structure, memory rules, and writing guidelines.
2. **SOUL.md** — this is who you are.
3. **USER.md** — this is who you are helping.
4. **TOOLS.md** — external tool usage guidelines.
5. **MEMORY.md** — long-term distilled context.
6. **memory/YYYY-MM-DD.md** — today's context index for recent state.

## Writing Rules

1. **Write memory after acting** — Every turn produces one concise memory index entry.
2. **Memory stays concise** — `memory/` is for quick context recovery. If it grows beyond skimmable length, you are writing too much detail there.
3. **Timestamp in entries only** — Use `HH:MM:SS` inside entries. The `## ` header provides the timestamp.
4. **Link to long-term memory** — If a pattern or preference should persist, update `MEMORY.md` directly.
5. **Silent writes** — Write memory silently as part of your tool calls. Do not mention logging in your text response to the user.

## Memory Index Entry Format

Append entries to `memory/YYYY-MM-DD.md`. Keep it brief — this is for fast context recovery, not full documentation.

```markdown
## HH:MM:SS — [One-line task summary]

- **Request**: [What the user asked for]
- **Approach**: [Brief methodology or pattern used]
- **Key Decisions**: [Important choices and rationale]
- **Changes**: [List of files touched]
- **Status**: [Complete / Partial / Blocked / Needs Review]
- **Next**: [Suggested next step, or empty if complete]
```

Do not output these logs in your text response. Write them to the files directly.
