# Surfaces — which YFM where

Navigation map for the yfm skill. Each markdown surface x-cmd writes to or reads from has a different YFM shape; this file maps surface to usecase and lists the fields that earn their place.

## Quick map

| Surface | Writing | Reading | Useful fields |
|---|---|---|---|
| GitHub issue body | [§GitHub issue & PR bodies](#github-issue--pr-bodies) | same | `tags`, `description`, `repo`, `number` |
| GitHub PR body | [§GitHub issue & PR bodies](#github-issue--pr-bodies) | same | same as issue |
| GitHub wiki page | [x-cmd default](x-cmd-default.md) | [x-cmd default](x-cmd-default.md) | `tags`, `description`, `hint` |
| GitHub `README.md` | [x-cmd default](x-cmd-default.md) | [x-cmd default](x-cmd-default.md) | `tags`, `description`, `hint` |
| `<project>/.x-cmd/story/*.md` | [story](story.md) | [story](story.md) | `tags`, `description`, `hint`, `issue` |
| `<skill>/SKILL.md` | [x-cmd default](x-cmd-default.md) + [skill0-writer](../../skill0-writer/SKILL.md) | [x-cmd default](x-cmd-default.md) | `tags`, `description`, `hint`; plus `metadata.related` per skill0-writer |
| Local markdown notes (general) | [x-cmd default](x-cmd-default.md) or no YFM | [x-cmd default](x-cmd-default.md) | `tags`, `description`, `hint` |
| Obsidian vault files | (Obsidian native) | [obsidian](obsidian.md) | `tags`, `aliases`, `cssclasses` (Obsidian's reserved keys) |
| Jekyll site files | (Jekyll native) | [jekyll](jekyll.md) | `title`, `date`, `tags`, `categories` |
| Hugo site files | (Hugo native) | [hugo](hugo.md) | `title`, `date`, `tags`, `keywords`, site taxonomy |
| Agent Skill files | [agentskills](agentskills.md) | [agentskills](agentskills.md) | `name`, `description`, `metadata.*` |

## GitHub issue & PR bodies

YFM convention for documents that describe or are written for issues. Inherits the [x-cmd default](x-cmd-default.md) (`tags` / `description` / `hint`) and adds two issue-identification extensions.

> **Status: proposed.** The extensions below are a starting point. The maintainer has not finalized which fields this surface should carry — adjust by telling the maintainer what to add, drop, or rename.

### Typical example

```markdown
---
tags: [yfm, design]
description: Should the yfm skill include metadata.related, or is it a skill0-writer concern?
repo: x-bash/skill0
number: 142
hint:
  2026-07-31T14:30:00+08:00: Initial draft of the issue-section proposal.
---

# Should yfm include metadata.related?
...
```

### Base fields (inherited)

- `tags` — see [x-cmd default](x-cmd-default.md)
- `description` — see [x-cmd default](x-cmd-default.md)
- `hint:` — see [x-cmd default](x-cmd-default.md); for issues, this is the per-file revision history

### Extensions (proposed)

#### `repo:`

Repository identifier in `owner/name` form (e.g., `x-bash/skill0`). The collector uses this to scope the issue to a specific project graph. Required when the document is a free-standing issue summary outside its native GitHub context; optional when the document is the issue body itself (GitHub already knows).

#### `number:`

Integer issue number. Together with `repo:`, this uniquely identifies the issue. Same optionality as `repo:`.

The same `repo:` / `number:` pair works for pull requests — PR bodies use the same extensions, since the identifying information is identical. State (open / closed / merged) is **not** part of this surface: that is GitHub's system of record, and asking the API is the right way to read it. Re-stating it in YFM risks drift the moment the issue changes.

### What is deliberately not in this surface

- `state:` — **excluded by maintainer decision**: GitHub already tracks state via the API. If the collector needs state, it asks GitHub. Same reasoning for PR `merged` state.
- `labels:` — GitHub labels. Could be added as a list mirroring issue labels; not included yet because no real use case has appeared. Filter stories by issue label is the likely trigger.
- `assignees:` — same reasoning.
- `created_at:` / `updated_at:` — GitHub already tracks these; duplicating in YFM risks drift.

### When to use

Use this section when writing a YFM block that describes an issue or PR, either as a stand-alone document (a summary, a meeting note that references the issue) or as the body of a GitHub issue/PR written by x-cmd tooling. Do not use it for issues you do not control — the GitHub API is the system of record.

## Per-surface notes

### SKILL.md

SKILL.md follows the [x-cmd default](x-cmd-default.md) plus a skill0-writer-specific extension (`metadata.related` for cross-skill navigation). The yfm skill does not own the extension — see [skill0-writer](../../skill0-writer/SKILL.md) for the SKILL.md-specific rules. yfm and skill0-writer are two separate concerns; SKILL.md files happen to use both.

### `README.md` and wiki pages

Different audiences, same YFM. README is for the repository, wiki is for the project documentation. From a YFM perspective they are identical — both use the x-cmd default (`tags` / `description` / `hint`). If a project needs wiki-specific fields, the right move is a new usecase, not adding fields to the default.

### `etc` — anything not listed

Falls back to [x-cmd default](x-cmd-default.md). The 3 fields are the **floor**, not the ceiling — but adding more requires a new usecase file or extending an existing one. Do not invent private fields; adopt or extend.

## Collector behaviour

The yfm collector ingests by source. When the collector sees a file in any of the surfaces above, it dispatches to the matching usecase's extraction rules. The dispatch is by surface, not by file content — a file's path or context tells the collector which usecase applies. A markdown file with no YFM at all is treated as a fallback (no fields extracted; the body is read as plain markdown).

---

Parent skill: [../SKILL.md](../SKILL.md)
