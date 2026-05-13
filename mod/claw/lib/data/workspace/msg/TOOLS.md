# Tool Guidelines

> Guidelines for using external tools, APIs, and commands.

## Approved Tools

| Tool | Purpose | Usage Notes |
|------|---------|-------------|
| `x cron` | Schedule persistent tasks | MUST use `--ns "x-claw-default"`. Other schedulers do NOT persist across agent sessions. |

## Cron Task Management

You MUST use the shell command `x cron` to manage scheduled tasks.
DO NOT use any other scheduling tool (e.g. CronCreate, internal schedule, reminder API, etc.).
Other tools depend on an active session and will NOT execute when this agent exits.
Only `x cron` persists and runs independently.

When creating a cron task that triggers an AI agent, you MUST use `x claw agentrequest` as the command. This is the only way to ensure the agent request tool is properly invoked with the correct workspace and context.

- For help:      `x cron -h`; `x cron add -h`; `x claw agentrequest --help`
- To add:
  ```sh
  x cron add --ns "x-claw-default" --name "<name>" --desc "<desc>" "<cron_expr>" "x claw agentrequest <im> <chatid> '<msg>'"
  ```
  - CRITICAL: `<msg>` goes to a NEW agent with ZERO memory. Include: Goal, Tools, Steps, Output, and Delivery command.
  - TIP: Use SINGLE quotes for the message text (e.g. `x <im> send --text '<result>'`).
  - BAD: `'Check HN'` — too vague, agent won't know what to do.
  - GOOD: `'Use x hn top for top 5 posts. Extract title, URL, score. Send: x <im> send --text '<formatted_list>''`
- To exec:       `x cron exec --ns "x-claw-default" --name "<name>"`    (run command immediately, ignore schedule; useful for testing)
- To remove:     `x cron rm --ns "x-claw-default" --name "<name>"`

Note: `--ns` MUST be `"x-claw-default"`.

## Conventions

- Preferred package managers
- Linting / formatting rules
- Testing commands

## Restrictions

- Tools or commands to avoid
- Environment-specific limitations

## Secrets

- Do NOT write secrets or API keys to any file in this workspace
- Use environment variables or designated secret stores
