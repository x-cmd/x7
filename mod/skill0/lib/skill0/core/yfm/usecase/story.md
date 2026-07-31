# story

YFM convention for design story documents in `<project>/.x-cmd/story/`. Inherits the [x-cmd default](x-cmd-default.md) (the `tags` / `description` / `hint` triple), adds one project-local extension for tracking which issue the story relates to.

The file's revision history lives in the inherited `hint:` block — see [x-cmd default](x-cmd-default.md) for the timestamp-keyed format. Story files do not need a separate `changelog:` field; the `hint:` map covers it.

## Typical example

```markdown
---
tags: [yfm, design]
description: How the yfm skill settled on three fields, in chronological order.
issue: 142
hint:
  2026-07-31T14:30:00+08:00: Tightened field list; cut aliases, added hint.
  2026-07-31T10:00:00+08:00: Initial draft.
---

# x-cmd Default YFM — design story

Body...
```

## Base fields (inherited)

- `tags` — see [x-cmd default](x-cmd-default.md)
- `description` — see [x-cmd default](x-cmd-default.md)
- `hint:` — see [x-cmd default](x-cmd-default.md); for stories, this is the per-file revision history

## Extensions

### `issue:`

Reference to the related issue. Either a single number or a list of numbers. The collector maps this to an ontology relation linking the story entity to the issue entity.

- Single: `issue: 142`
- Multiple: `issue: [142, 158]`

If the story is not tied to a specific issue, omit the field. Do not write `issue: null` or `issue: 0`.

## Date format for `hint:` keys

`YYYY-MM-DDTHH:mm:ss±HH:mm` — ISO 8601 with a numeric offset (`+HH:mm` or `-HH:mm`). The offset is **per author**, not per project. A user in UTC+8 writes `+08:00`; a user in UTC-5 writes `-05:00`; a user in UTC writes `+00:00`.

Why numeric offset and not a named zone (`Asia/Shanghai`) or `Z`:

- Numeric offset is unambiguous to parse. Named zones require a timezone database to resolve; `Z` requires every author to convert manually.
- The project has authors in different timezones. A fixed project offset would force every author to convert on every write; a fixed `Z` would force every reader to mentally shift. Per-author offset is the least friction.
- The format is human-writable. An agent generating a `hint:` entry does not need a date library, only the string and the author's current offset.

**Consistency rule within one file:** a single `hint:` block should use one offset throughout. Mixing `+08:00` and `-05:00` in the same file is allowed only when each entry is genuinely the author's local time at the moment of writing; the collector does not require a single file-wide offset.

**Sort order: newest first.** The latest change sits at the top, so a reader skimming the file sees the most recent state first. The collector relies on this order when ingesting revision history.

## When to use

Use this usecase for files under `<project>/.x-cmd/story/` that document a design decision, retrospective, or investigation. Casual notes (single paragraph, no decision content) stay as plain markdown without YFM. The x-cmd default fields (`tags` / `description` / `hint:`) are enough for short stories — `issue:` earns its place only when the story is long-lived or has a clear related issue.

---

Parent skill: [../SKILL.md](../SKILL.md)
