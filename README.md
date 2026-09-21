# tributary

Two Claude skills that roll the context of many Claude.ai Projects up into one place: your
account-level memory, which every Project and every chat can read.

```
Project A ─┐
Project B ─┼─ /project-export ──► digest ──(paste)──► /hub-import ──► account memory
Project C ─┘   (inside Project)                     (chat outside     /areas/<slug>.md
                                                      any Project)          │
                                                                            ▼
                                                        readable from every Project and chat
```

## Why

Claude.ai keeps Project memory isolated on purpose. A chat inside a Project reads
account-level memory plus that Project's own memory. It cannot read other Projects' memory,
and it can write only inside its own Project. Account-level memory is the one store every
Project reads, and only a chat outside any Project writes to it.

So the hop has to happen in two steps: export inside the Project, import outside it. There is
no public API for Project memory, so the step in between is a paste.

## Skills

| Skill | Run it | What it does |
|---|---|---|
| `project-export` | inside a Project | Reads project instructions, knowledge, memory and recent chats. Emits one `PROJECT-DIGEST v1` block of at most 300 words, keeping only what you stated or decided and only what is durable. Read-only. |
| `hub-import` | in a chat outside any Project | Parses one or more digests and writes each to `/areas/<slug>.md` as a managed `## Project digest` section. Re-imports replace that section whole, so files do not grow, and lines outside the section are left alone. Refuses to overwrite a newer digest with an older one. |

## Install

Skills need **Settings > Capabilities > Code execution and file creation** turned on.

**Upload the zips.** Download `project-export.zip` and `hub-import.zip` from the latest
release, or build them with `./scripts/package.sh`. Then go to **Customize > Skills > +** and
upload each zip.

**Or add the repo as a plugin marketplace.** Go to **Customize > Plugins > Add > Add
marketplace > Add from a repository** and enter `tyler-void/tributary`. Updates then come from the
repo. The skills may show up namespaced (`tributary:project-export`).

## Use

1. In a Project, run `/project-export`. Pass a slug to pin the file name, for example
   `/project-export pacision`.
2. Copy the block.
3. Open a chat outside any Project, paste the block, and run `/hub-import`. You can paste
   several digests at once.

Re-export whenever a Project moves on. The slug stays stable, so the same file gets updated.

## Digest format (v1)

```text
=== PROJECT-DIGEST v1 ===
slug: pacision
project: PACISION
as_of: 2026-09-21
aliases: [Pacision 0.5]
goal: one line
status: one or two lines
decisions:
- decision (date)
constraints:
- constraint or deadline
open:
- unresolved item
people:
- name: role in this project
=== END DIGEST ===
```

Required fields: `slug`, `project`, `as_of`, `status`. Empty sections are omitted.

## Limits

- **Manual hop.** Both ends are skills, but the paste in between is yours.
- **Account memory is shared by everything.** Keep one short digest per Project. Detail
  belongs in the Project itself.
- **Privacy.** The export drops secrets, ID and account numbers, and, unless you ask, health,
  finances and identity attributes. The import still applies your memory's own privacy rules.
- **Memory without file tools.** If your memory has no file-based tools, `hub-import` falls
  back to text you paste into Settings > Memory. That path is lossy and additive.

## License

MIT
