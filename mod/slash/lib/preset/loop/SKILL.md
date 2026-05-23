---
name: loop
description: Schedule a recurring task with result notification. Use when user says "/loop <interval> <prompt>" to set up recurring monitoring and notifications.
---

# Loop Runner

Schedule a recurring monitoring task with configurable result storage and notification.

## Workflow

### 1. Parse Arguments

```
/loop <interval> <prompt>
```

**Interval patterns**:
| Pattern | Meaning |
|---------|---------|
| `Nm` (N ≤ 59) | every N minutes → `*/N * * * *` |
| `Nm` (N ≥ 60) | round to hours → `0 */H * * *` |
| `Nh` (N ≤ 23) | every N hours → `0 */N * * *` |
| `Nd` | every N days → `0 0 */N * *` |
| `Ns` | treated as `ceil(N/60)m` |

**If interval doesn't divide cleanly** (e.g. `7m`, `90m`): pick nearest clean interval and tell user what was rounded to.

### 2. Clarify Intent & Method

**Ask user**:
1. **What to monitor**: Parse the prompt (e.g., "检测最新的 hn 新闻")
2. **How to execute**: Determine the method(s) to fulfill the prompt:
   - `x hn top` — Hacker News top stories
   - `x hn new` — HN new stories
   - `x agent request ...` — general LLM queries
   - Other x-cmd modules
3. **Where to store results**: Must clarify before creating cron

### 3. Ask About Notification (Required)

**Before creating the cron job**, ask user:

```
Loop 创建成功。
- 执行命令: x hn top
- 间隔: 每小时

结果存到哪里？如何通知你？
1. Memory (默认) — 存入 memory，稍后查看
2. Mailbox — 收到新消息时通知（尚未实现）
3. 微信群组 — 发送到微信群
4. 其他方式 — 请说明
```

**Notification options**:
| Option | Description |
|--------|-------------|
| Memory | Store in memory file, check later |
| Mailbox | Notification when new results (not yet implemented) |
| WeChat Group | Send to WeChat group |
| Other | User specifies |

### 4. Create Cron Job

```bash
JOB_NAME="loop-$(date +%Y%m%d%H%M%S)"

x cron add \
    --name "$JOB_NAME" \
    --desc "<description>" \
    "<cron-expression>" \
    "<full-command>"
```

**The command** should:
1. Execute the monitoring task
2. Store results to the designated location
3. Send notification (if configured)

### 5. Confirm to User

Show:
- Job name + cron expression
- Human-readable cadence
- What will be monitored
- Where results will be stored/notified
- How to cancel: `x cron rm <name>`

### 6. Execute Immediately

**Don't wait for first cron fire** — run the command now as well.

## Examples

```bash
/loop 1h "检测最新的 hn 新闻"
# → 解析意图: 获取最新 HN 新闻
# → 选择方法: x hn top
# → 询问通知方式后创建 cron
```

## Cancel

```bash
x cron rm <job-name>
# or list jobs first
x cron ls
```

## Memory Storage (Default)

Results are stored in memory file:

```markdown
---
name: loop-hn-news
description: Hourly HN news check
last_run: 2026-05-23 15:00:00
---

## Results (2026-05-23 15:00:00)

[HN Top Stories]

## Results (2026-05-23 14:00:00)

[Previous HN Top Stories]
```