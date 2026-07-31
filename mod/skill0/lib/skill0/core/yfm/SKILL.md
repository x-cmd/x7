---
name: yfm
description: |
  YAML front matter (YFM) for any markdown article. x-cmd's own default is three top-level fields — `tags`, `description`, `hint`. Foreign dialects (Agent Skills, Obsidian, Jekyll, Hugo) live in usecase/ for the collector; the x-cmd default borrows the Agent Skills frontmatter shape — see their spec at <https://agentskills.io/specification> for the authoritative layout.

metadata:
  related: "skill0-writer,ontology-database"
---


# yfm — skill0

## Default to YFM

Add front matter to any markdown an agent, search index, or ontology pipeline may scan. **Skip only when something states otherwise**: a stricter spec governs the file, or markdown lint rejects it — read the lint error, then check `.markdownlint.*` / `remark-*` / `.mdlrc`.

Within skill0, only `SKILL.md` carries YFM — see [skill0-writer](../skill0-writer/SKILL.md).

## The x-cmd default: three fields

- **`tags`** — top-level list
- **`description`** — top-level string
- **`hint:`** — top-level map, the file's own revision log. ISO 8601 timestamps as keys, short change-descriptions as values.

```yaml
---
tags: [design, front-matter]
description: A note on the XFM design — what is captured, what is left out.
hint:
  2026-07-31T14:30:00+08:00: Replaced changelog: with hint: in the story usecase.
  2026-07-31T10:00:00+08:00: Initial draft.
---
```

That's it. The full convention — semantics, what is deliberately *not* included — is in [usecase/x-cmd-default.md](usecase/x-cmd-default.md).

## x-cmd writing conventions

The default is inherited; some document types extend it with project-local fields:

- [story](usecase/story.md) — files under `<project>/.x-cmd/story/`. Adds `issue:` (cross-link). The file's revision history uses the inherited `hint:`.

For per-surface guidance on issues, PRs, wiki, READMEs, and other markdown surfaces, see [usecase/git-issue-pr-wiki-markdown-etc.md](usecase/git-issue-pr-wiki-markdown-etc.md).

## Reading foreign front matter

The yfm collector ingests many dialects. They are not the x-cmd default; the x-cmd default is what x-cmd writes. For the **authoritative YFM spec** the x-cmd default borrows its shape from, see the Agent Skills specification at <https://agentskills.io/specification>. Per-dialect keys, types, separators and traps:

- [Agent Skills](usecase/agentskills.md) — `metadata:` is a string→string map; top level is a closed set
- [Obsidian](usecase/obsidian.md) — `tags` / `aliases` / `cssclasses` reserved keys
- [Jekyll](usecase/jekyll.md) — list or **space**-separated string
- [Hugo](usecase/hugo.md) — TOML possible; site-configured taxonomy

## Design rationale

The full reasoning — why these three, why `aliases` was cut, what `hint:` is for, the selection criteria — is in the story: [.x-cmd/story/260731.x-cmd-yfm-fields.md](../../../.x-cmd/story/260731.x-cmd-yfm-fields.md). The previous design (which used `aliases` as the third field) is captured in [.x-cmd/story/260731.x-cmd-yfm-default.md](../../../.x-cmd/story/260731.x-cmd-yfm-default.md) for historical reference.

## Rules

- MUST use the three-field x-cmd default for x-cmd's own documents (story files, issues, READMEs).
- MUST NOT extend the default with private fields like `x-foo:` or `*-meta:` — adopt, do not invent.
- MUST dispatch by dialect when reading foreign YFM.

## Related

- [skill0-writer](../skill0-writer/SKILL.md) — SKILL.md-specific extensions (e.g. `metadata.related`) are governed by sw-150, not yfm
- [ontology-database](../ontology-database/SKILL.md) — ingests `tags` into ondb

