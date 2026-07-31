# x-cmd default

This is the YFM convention for documents **x-cmd writes itself**. Foreign dialects the collector reads are covered in the other usecase files.

## Typical example

```markdown
---
tags: [design, front-matter]
description: A note on the XFM design — what is captured, what is left out.
hint:
  2026-07-31T14:30:00+08:00: Cut aliases from x-cmd default, replaced with hint.
  2026-07-31T10:00:00+08:00: Initial draft — three-field design.
---

# On XFM design

Body...
```

## The three fields

- **`tags`** — top-level list. For ontology indexing; the collector reads this and dispatches by source dialect to write tag entities. Slugs are `[a-z0-9-]`, no commas, no spaces.
- **`description`** — top-level string. One sentence a reader (human or agent) uses to decide whether to load or open the file. Not the same as the Agent Skills `description:` — that is a SKILL.md-only field required by the skill loader, governed by `skill0-writer`, not by yfm.
- **`hint:`** — top-level map, the file's own revision log. **Keys are ISO 8601 timestamps** (`YYYY-MM-DDTHH:mm:ss±HH:mm`, author's local offset). **Values are short descriptions of what changed at that point**. The latest entry sits at the top (newest first) by convention. In rare cases, a value may be a structure rather than a string, when one change has multiple parts worth recording (e.g., `action`, `reason`).

  ```yaml
  hint:
    2026-07-31T14:30:00+08:00: Cut aliases, added hint.
    2026-07-31T10:00:00+08:00: Initial draft.
  ```

  Why a map keyed by timestamp, not a list of `{date, body}` entries: the timestamp-as-key makes the change order obvious without parsing a list, and the per-file timeline reads as a single dictionary the collector can iterate. A list form (`changelog: [{date, body}]`) was the earlier design; it is now subsumed by `hint:`. Files that already have a `changelog:` block can keep it; the collector reads either.

  If a file has no history worth recording, omit the block entirely. Do not write `hint: {}`.

## Applicable scope

The x-cmd default applies to documents x-cmd writes in three contexts:

- `<project>/.x-cmd/story/` — design stories, dated by filename. May extend with `issue:` — see [usecase/story.md](story.md).
- GitHub issue bodies — may extend with `repo:`, `number:` — see [usecase/git-issue-pr-wiki-markdown-etc.md](git-issue-pr-wiki-markdown-etc.md).
- GitHub `README.md` — default fields only.

Outside these contexts, the yfm collector still reads whatever dialect the foreign document uses — Jekyll / Hugo / Obsidian / Hexo / etc. The x-cmd default is one dialect among many, and the only one whose shape we control.

## Selection criteria

A field is admitted to the x-cmd default if:

1. It has a concrete consumer (machine or human) that uses the field's value for a real purpose.
2. The field name does not impose a value type that the consumer cannot accept.

Examples of fields that pass: `tags` (consumer: collector for indexing; value: list of slug — index lookup is slug-shaped), `description` (consumer: first reader; value: sentence — first reading is sentence-shaped), `hint` (consumer: the file's own history, plus the collector; value: map of timestamp → string — revision log is map-shaped).

Examples of fields that fail: `aliases` (consumer: only Obsidian's wikilink autocomplete; for general x-cmd documents, no consumer), `cssclasses` (consumer: presentation layer, not ontology; out of scope), `title` (consumer: none — first heading is the title), `date` (consumer: filename for story files; otherwise none).

The reasoning for the full rejected list lives in the design story at [.x-cmd/story/260731.x-cmd-yfm-fields.md](../../../.x-cmd/story/260731.x-cmd-yfm-fields.md).

## What about `metadata.related`?

`metadata.related` appears on skill0's 28 SKILL.md files but is **not** part of the x-cmd default. It is a **skill0-writer convention** (sw-150) for cross-skill navigation, owned by the skill0-writer skill, not by yfm. SKILL.md files happen to use both the yfm default fields and the skill0-writer extension; general markdown articles should use only the yfm default.

---

Parent skill: [../SKILL.md](../SKILL.md)
