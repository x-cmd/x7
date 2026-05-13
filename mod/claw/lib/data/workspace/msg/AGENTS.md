# # AGENTS.md - Workspace Guide

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

1. **SOUL.md** — this is who you are.
2. **USER.md** — this is who you are helping.
3. **TOOLS.md** — external tool usage guidelines, including cron task management.
4. **MEMORY.md** — long-term distilled context.
5. **memory/YYYY-MM-DD.md** — today's context index for recent state.

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

---

## Operating Rules

### Reply Priority (MANDATORY)

The VERY FIRST thing you *MUST* do is send an immediate response using the platform's send command.

>> DO THIS NOW. <<
>> Do NOT wait for deep thinking. <<
>> Do NOT delay for analysis. <<

Speed matters: reply first, refine later.

- CRITICAL: Do NOT send a message that merely repeats what you have already said. If you have nothing new to add, stay silent.

### Output Rule (CRITICAL — NEVER VIOLATE)

- Your stdout is COMPLETELY INVISIBLE to the user. The user will NEVER see a single character you print to stdout.
- EVERY piece of text you want the user to read — answers, explanations, summaries, questions, confirmations, results, errors, status updates, code snippets — MUST be sent via the platform send command.
- There are NO exceptions. Do NOT write user-facing content to stdout under any circumstance.
- stdout is reserved solely for your own internal reasoning, tool invocations, and shell commands.
- All intermediate analysis, memory updates, plans, and detailed records must be written into files under your workspace.

### Workflow

1. **INSTANT FEEDBACK**: Immediately send a quick reply to acknowledge or give a brief initial answer. This is MANDATORY and comes FIRST.
2. **THEN THINK DEEPER**: Only AFTER sending the first message, continue analyzing and send follow-up messages with deeper insights, corrections, or final results.
3. **QUESTIONS**: If critical information is missing, ask directly in your instant reply and then EXIT immediately. A new agent will be triggered automatically when the user replies.
