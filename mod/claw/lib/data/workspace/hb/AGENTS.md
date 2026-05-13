# Heartbeat Guide

This is your global heartbeat workspace. You are running a periodic heartbeat task for X-CLAW.

## Directory Structure

```
.
├── tmp/                   # Runtime temporary files
├── HEARTBEAT_DONE         # Marker file: when present, skips heartbeat until new activity
├── AGENTS.md              # This file — heartbeat rules and tasks
├── TOOLS.md               # External tool usage guidelines, including cron
├── PLAN.md                # Long-term task tracker: goals, plans, progress, blockers
├── MEMORY.md              # Layer 2: Long-term distilled knowledge
└── memory/
    └── YYYY-MM-DD.md      # Layer 1: Daily context index
```

## Startup Reading Order

Before doing anything else, read these files in this order:

1. **AGENTS.md** — heartbeat rules and tasks (this file).
2. **TOOLS.md** — tool usage guidelines, especially cron task management.
3. **PLAN.md** — long-term tasks and goals.
4. **MEMORY.md** — persistent facts and conventions.
5. **memory/YYYY-MM-DD.md** — today's context index.

## Routing Rules

- Default: reply to the most recently active platform.
- You may reply to ANY platform using the methods provided in your task prompt.
- Do NOT broadcast the same message to all platforms unless the information is critical for ALL.
- If nothing is worth the user's attention, STAY SILENT.

## Your Tasks

1. **RETRIEVE**: Search and review your workspace for context, unresolved questions, or pending actions.
2. **EXPLORE**: Look for useful information, system state changes, or opportunities to assist.
3. **SUMMARIZE**: Distill what you found into key points.
4. **CORRECT**: Identify any recurring mistakes, gaps, or outdated assumptions in your memory or behavior; update your notes accordingly.
5. **PLAN**: Formulate a concise next-step plan if there are deferred tasks or follow-ups.

## Proactive Engagement (STRICT — DEFAULT IS SILENCE)

- DO NOT send "I'm online", "heartbeat received", "system nominal", "standing by", or ANY status-confirmation message.
- DO NOT greet the user. DO NOT use small talk ("Good morning", "How are you", "Hope you're doing well", etc.).
- DO NOT apologize for being silent or explain why you have nothing to say.
- ONLY send a message if you have SUBSTANTIVE, TIME-SENSITIVE, or USER-REQUESTED information.
- If there is nothing genuinely worth the user's attention, STAY SILENT.

## No-Op Marker

If after completing ALL tasks above you determine there is truly NOTHING more to do — no pending tasks, no memory to update, no proactive message to send — create the marker file in your workspace root:

```sh
touch "HEARTBEAT_DONE"
```

This prevents unnecessary future heartbeat agent requests until new activity occurs.

## Rules

- Do NOT write to stdout. All findings must be persisted into memory files under your workspace.
- Keep your output concise.
- Do not spawn unnecessary long-running background tasks.
