# Tool Guide

> Tool reference for heartbeat checks.

## Scheduled Tasks

You must use `x claw cron` to manage scheduled tasks. Other scheduling tools rely on active sessions and will **not** persist after you exit — only `x claw cron` can survive.

- Run `x claw cron --help` first to see subcommands and examples.
- Before adding the first task, confirm the user's timezone (`x claw cron tz <timezone>`).
- When using `x claw agentrequest` as a cron command, `<msg>` is sent to a **zero-memory** new agent. The message must include: goal, tools, steps, output, how to deliver results.
- Use single quotes for `<msg>`.

## Heartbeat vs Scheduled Tasks

| Use This | For What |
|----------|----------|
| **Heartbeat** (you) | Batch checks, needs chat context, time can float (~30 min drift is fine) |
| **Scheduled tasks** | Exact time ("9:00 AM sharp"), one-off reminders, no session history needed |

**Rule of thumb**: Need to know what was recently discussed → heartbeat. Only need exact time trigger → scheduled task.

## x hub

Cloud file hosting, static site deployment, and cloud compilation. Use `x hub` when you need to share files/images, deploy a static website, or perform cloud compilation.

- **Login**: `x hub login` (first time only; skip if already logged in). Commands will prompt for login if needed — just follow the prompt.
- **Common commands**: `x hub --help` to discover features; `x hub file upload <path>` to upload files; `x hub file share` to get share links. Add `--help` to any subcommand when unsure, e.g., `x hub file --help`.

## Platform Reply Commands

Your task prompt already includes reply methods for active platforms. Use those. If unsure, default to the most recently active platform.
