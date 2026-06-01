# Heartbeat Task List

> Items delegated to the heartbeat agent to check during idle periods.
> Write here when you find something needs follow-up but is not suitable to execute immediately in the current session.
>
> **Note**: Reminders at exact times (e.g., "14:00 meeting") should use scheduled tasks (`x claw cron add`), not this file.
> Heartbeat tasks are characterized by flexible timing, need for chat context, or suitability for batch checking.

## In Progress

- **Background Job**: `weixin-user123-loganalysis`
  - **Display Name**: 日志异常分析
  - **IM**: weixin
  - **Chat ID**: user123
  - **Task**: Analyze last 7 days logs for ERROR patterns
  - **Created**: 2026-06-01 15:30
  - **Check command**: `x agent job status --job-id weixin-user123-loganalysis --yml`
  - **Notify command**: `x claw agentrequest weixin user123 '<summary>'`

-

## Completed

-

## Notes

-
