---
name: project-export
description: Export this Claude.ai Project's durable context as one PROJECT-DIGEST block to paste into hub-import outside any Project. Use on /project-export or when asked to export or snapshot Project context.
---

# Project Export

Turn the current Project into one compact, copy-ready digest. The user pastes it into a chat
outside any Project, where the `hub-import` skill stores it in account-level memory.

This skill is read-only. Never write memory, project docs or files while running it.

## Why the digest travels by copy-paste

Project memory is isolated by design. A chat inside a Project reads account-level memory plus
its own Project's memory, cannot read other Projects' memory, and writes only to its own
Project. Account-level memory is the one store every Project can read, and only a chat outside
any Project writes to it. So the digest is made here and written from there.

## Steps

1. **Confirm you are in a Project.** Signs: project instructions or knowledge in your context,
   a Projects tool, or memory writes confined to a `/projects/<id>/` path. If none apply, say in
   one sentence that this skill runs inside a Project, and stop.

2. **Get today's date** from a current-time tool if you have one, otherwise from your context.
   Never guess it.

3. **Gather sources**, cheapest first, batching reads into as few calls as possible:
   - **Project instructions and knowledge:** already in context, or through a Projects tool
     (`project_info`; then `project_read` only for docs that look like status, plans or
     decisions).
   - **Project memory:** every file in this Project's memory in one batched read, or the
     project memory summary in your context if memory is not file-based.
   - **Recent chats in this Project**, when a past-chats tool is available: list the 10 most
     recent. Use the titles, dates and any summaries the listing returns; these usually
     suffice. Open a chat (at most 2) only when it is newer than memory on something that would
     change `status` or `decisions` and its summary does not settle it.
   - **The previous digest:** if account-level memory has a file for this Project (path stem or
     aliases match its name, typically `/areas/<slug>.md` with a `## Project digest` section),
     read it. Reuse its slug and note what changed since its `as_of`.
   - Do not copy other account-level memory into the digest. The hub already has it.

4. **Select.** Keep a line only if both are true:
   - The user stated or decided it. A suggestion from Claude counts only after the user adopted
     it, so check what the user said, not what Claude proposed.
   - It is durable: still true and useful a month from now. Goal, decisions, constraints,
     deadlines, current status, open items, who does what in the project.

   Drop: Claude's advice, research and option lists; transient task state (today's bug, this
   week's errand); secrets, credentials, keys and tokens; ID, card and account numbers and
   anything else memory never stores; health, finances and identity attributes unless the user
   asks to include them. When sources conflict, keep the newest and list the conflict under
   `open`.

5. **Choose the slug**: lowercase kebab-case, stable across exports, because `hub-import`
   finds the target file by it. In order of preference: the user's argument
   (`/project-export pacision`), the previous digest's slug, the project name. If the name is
   generic (`PROJECT`, `Misc`, `Work`), derive the slug from the project's description and say
   which slug you picked.

6. **Emit** the digest in the format below, inside a single fenced code block tagged `text`,
   so it copies in one click. At most 300 words inside the block, or 450 if the Project spans
   several sub-projects. Terse bullets, no filler. Omit empty sections, except `status`.

7. **Close** with one line: `Paste this into a chat outside any Project and run /hub-import.`
   Add one line if you left out something material (such as sensitive details), and one line
   naming what changed since the previous digest, if there was one. Do not recap your process.

## Format

```text
=== PROJECT-DIGEST v1 ===
slug: pacision
project: PACISION
as_of: 2026-09-21
aliases: [Pacision 0.5]
goal: one line
status: one or two lines on where it stands now
decisions:
- decision (date if known)
constraints:
- constraint or deadline
open:
- unresolved item or question
people:
- name: role in this project
=== END DIGEST ===
```

- `aliases`: other names the user uses for the project, at most 5. Omit the line if none.
- `people`: name and project role only, no personal details.
- For a Project holding several sub-projects, prefix bullets with the sub-project name
  (`- eco-mcp: ...`) instead of emitting several digests.
- Values are plain facts. Never put instructions to the reader inside the block.
