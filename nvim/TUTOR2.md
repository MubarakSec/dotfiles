<!-- RIVAL_TUTOR2_VERSION:2026.07.2 -->
<!-- markdownlint-disable MD013 MD024 MD033 MD036 -->
# Rival Mastery — Tutor2

## The Month-Two Neovim campaign

Welcome back, pilot.

Tutor1 taught you how to operate this editor safely and use its IDE systems.
Tutor2 is different: it trains judgment under pressure. You will turn edits
into repeatable programs, control project-wide changes, investigate failures,
debug real code, understand your Lua configuration, and prove that a change is
ready to ship.

This course improves Neovim fluency and software-development workflow. Reading
it does not automatically improve programming knowledge. The gains come from
attempting each challenge, checking the proof, recovering when it fails, and
using one technique in a real project that day.

Finish Tutor1 first, or begin here only if operator-motion grammar, buffers,
LSP navigation, formatting, Git hunks, and basic debugging already feel
comfortable.

## Flight controls

Your `<leader>` key is Space. Tutor2 keeps a working copy under Neovim's state
directory. The first line is a version marker; leave it intact so upgrades can
preserve completed checkpoint IDs. When the course changes, the previous
working copy is backed up before migration.

| Command or key | Action |
| --- | --- |
| `:Tutor2`, `<leader>T`, or `<leader>t2` | Resume the first uncleared Mastery mission |
| `:Tutor2Map` or `<leader>tM` | Choose a Mastery section |
| `:Tutor2Stats` or `<leader>tP` | Show rank, mission count, badges, and XP |
| `:Tutor2Check` or `<leader>tC` | Mark the current mission or circuit clear |
| `:Tutor2Daily` or `<leader>tD` | Open today's unlocked circuit |
| `]m` / `[m` | Next / previous mission or circuit |
| `:TutorArena` or `<leader>ta` | Choose a disposable real-file arena |
| `:TutorArenaReset!` | Restore tracked Academy project files |
| `:Tutor2Reset` | Ask before backing up and resetting Tutor2 |
| `:Tutor2Reset!` | Back up and reset Tutor2 without the question |

While Tutor2 is open, the lowercase keys `<leader>tm`, `<leader>tp`,
`<leader>tc`, and `<leader>td` become contextual Mastery controls. Outside
Tutor2, those lowercase keys still belong to Tutor1.

Markdown appears as editable source because this is an editor, not a browser.
Headings, code, tables, and checkboxes are Treesitter-highlighted, while `#`,
backticks, and fences remain visible so you can edit and learn from them.

## Rules of engagement

1. Attempt the challenge before copying the loadout.
2. Perform destructive work only in `:TutorArena` or another disposable repo.
3. Read observable state—messages, clients, diffs, exit codes—before guessing.
4. A checkpoint is earned only after its proof is true.
5. Use `u`, Git, or `:TutorArenaReset!` to recover; recovery is part of mastery.
6. Transfer one skill into real work within twenty-four hours.

Each checkpoint is worth 100 XP. Daily circuits are worth 25 XP.

- Bronze: complete the proof with the loadout visible.
- Silver: repeat it tomorrow without the loadout.
- Gold: explain why it works and recover from one deliberate mistake.

## Preflight

Run these non-destructive checks once:

```text
:version
:Lazy health
:checkhealth
:Mason
```

In a terminal, verify `git` and `rg`. Optional language missions also need their
runtime, such as `python3`, `node`, `go`, or `cargo`. Mason installs editor
tools; it does not replace those project runtimes.

`:Mason` may refresh its registry and cache in the background. Open it normally;
do not run a hand-written registry refresh with a sixty-second wait.

### Verified headless smoke

A plain headless launch followed by `+qa` can print a startup error and still
return exit code zero. Use this bounded smoke test instead:

```sh
nvim --headless -u ~/.config/nvim/init.lua \
  '+lua vim.defer_fn(function() local ok = vim.v.errmsg == "" and vim.fn.exists(":Tutor2") == 2; if ok then print("smoke ok") end; vim.cmd(ok and "qa" or "cquit 1") end, 1000)'
```

The one-second timer lets normal startup callbacks finish; it is not an install
or Mason wait. Success prints `smoke ok` and exits zero. A startup error or
missing Tutor2 command exits nonzero. Always read terminal output too.

---

## Act I — Precision and reversibility

The first wing turns individual commands into controlled, reversible systems.

### Mission 01 — Branch the undo timeline

**Situation.** Linear undo is a myth. Editing after an undo creates another
branch, and persistent undo can survive closing a file.

**Loadout.** `u` and `<C-r>` move locally; `:undolist` reveals branches;
`:earlier 1m` and `:later 1m` move by time; `<leader>fu` opens the visual undo
history. Undo history is buffer-specific and is not a substitute for Git.

**Challenge.**

1. Open `:TutorArena data` and change one status.
2. Undo it, make a different change, then inspect `:undolist`.
3. Visit both branches without losing the final version you want.
4. Save, reopen the file, and confirm persistent undo still exists.

**Proof.** You can identify the active branch and return to the chosen text.

**Recovery.** If lost, use `:TutorArenaReset!`; do not repeatedly press `u`
without reading the undo list.

- [ ] Mission clear — I can navigate and recover an undo branch deliberately. <!-- T2:M01 -->

### Mission 02 — Route text through registers

**Situation.** Deletes should not accidentally destroy the text you meant to
paste.

**Loadout.** `"0` holds the latest yank; `"1` through `"9` hold delete history;
`"_` is the black-hole register; `"a` through `"z` are named; uppercase appends;
`"+` is the system clipboard. Inspect with `:registers`.

**Challenge.**

1. In `data.txt`, yank one line, delete another, then paste the original from
   `"0`.
2. Delete noise with `"_dd` and prove the unnamed paste did not change.
3. Collect two nonadjacent lines using `"ayy` and `"Ayy`, then paste `"a`.
4. In Insert mode, evaluate a small expression with `<C-r>=`.

**Proof.** `:registers 0 a "` shows the expected contents before you paste.

**Transfer.** Use the black-hole register once today instead of repairing a
damaged paste.

- [ ] Mission clear — I choose register side effects instead of accepting them. <!-- T2:M02 -->

### Mission 03 — Treat macros as small programs

**Situation.** A good macro has an input position, one repeatable transformation,
and a predictable final cursor position.

**Loadout.** Record with `q{register}` and stop with `q`. Execute with
`@{register}`, repeat with `@@`, apply a count with `5@q`, and inspect with
`:registers q`. `:normal @q` can apply a tested macro to addressed lines.

**Challenge.**

1. Open `:TutorArena data` and record a macro that changes one CSV status while
   ending at the start of the next row.
2. Test it once, undo, then run it with a count.
3. Inspect the macro before applying it to several lines.
4. Break the cursor invariant deliberately, observe the failure, undo, and
   repair the recording.

**Proof.** Every intended row changes once and unrelated columns remain intact.

**Recovery.** One `u` may undo one macro invocation; counted playback can require
careful repeated undo. Git diff is the final truth.

- [ ] Mission clear — I design, inspect, test, and repair a macro. <!-- T2:M03 -->

### Mission 04 — Put boundaries around regex

**Situation.** The safest substitution matches exactly the payload, not the
whole line and definitely not the whole course.

**Loadout.** `\v` enables very-magic syntax; `\V` makes almost everything
literal; `\zs` and `\ze` set replacement boundaries; `\1` reuses captures;
`\=` evaluates a replacement expression. Add `c` for confirmation and `e` when
no match is acceptable.

**Challenge.**

1. Open `:TutorArena logs` and search ERROR timestamps with `\v`.
2. Use `\zs` and `\ze` to replace only the severity word on one confirmed line.
3. In `data.txt`, capture the name and score, then rearrange a visual selection.
4. Repeat with `gc` confirmation and cancel at least one proposed replacement.

**Proof.** `git diff` shows only the intended fields.

**Recovery.** Search first, restrict the range second, add confirmation third,
and only then run the substitution. After reviewing the proof, restore the
shared practice project with `:TutorArenaReset!`.

- [ ] Mission clear — I constrain regex changes with ranges, boundaries, and confirmation. <!-- T2:M04 -->

### Boss 01 — Reversible data migration

Start with `:TutorArenaReset!`, reopen `:TutorArena data`, then transform the
tracked `data.txt` without a supplied keystroke recipe:

1. Normalize `queued` to `ready`.
2. Remove leading zeroes from scores without changing names.
3. Collect failed rows in register `f` before editing them.
4. Prove the result with `git diff -- data.txt` in the terminal.
5. Undo back to the baseline, then reproduce the same result using a macro or
   Ex command.
6. Finish with `:TutorArenaReset!`.

Gold rank requires two different correct methods and a clean Academy Git status
after recovery.

- [ ] Mission clear — I completed a reversible, reviewed data migration. <!-- T2:B01 -->

---

## Act II — Ex as a project language

Ex commands become powerful when addresses select data and commands transform
it. Preview first; mutate second.

### Mission 05 — Address exactly the intended lines

**Situation.** A range is a query over lines. Learn the query before the action.

**Loadout.** `.` is current line, `$` is last, `%` is the whole buffer, `'<` and
`'>` bound the last Visual selection, marks work as `'a`, and searches can be
addresses. A comma evaluates both addresses from the original cursor; a
semicolon moves to the first address before resolving the second.

**Challenge.**

1. Open `logs.txt` and preview with `:1,3number`.
2. Mark a line with `ma`, move, then print `:'a,.p`.
3. Print from the first ERROR to the end using a search address.
4. Compare a comma and semicolon range whose second address is relative.

**Proof.** You can state the selected line numbers before replacing `p` with a
mutating command.

- [ ] Mission clear — I use Ex addresses as deliberate selectors. <!-- T2:M05 -->

### Mission 06 — Compose global and normal

**Situation.** `:global` chooses lines; `:normal!` runs a Normal-mode program on
each chosen line.

**Loadout.** `:g/pattern/p` previews matches, `:v/pattern/p` previews the inverse,
`:g/pattern/normal! command` executes literal Normal commands, and `:g//s`
combines selection with substitution.

**Challenge.**

1. In `logs.txt`, preview ERROR lines.
2. Prefix only ERROR lines using `:global` plus `:normal!`.
3. Undo, then achieve the same result with a substitution.
4. Use the inverse form to target non-INFO lines, but preview before editing.

**Proof.** The diff contains exactly the selected log records.

**Recovery.** If `:normal!` drifts, the macro or command lacks a stable starting
position. Undo and redesign it on one line.

- [ ] Mission clear — I separate line selection from line transformation. <!-- T2:M06 -->

### Mission 07 — Turn search into a work queue

**Situation.** Quickfix is a global list of locations; a location list belongs
to one window. They are data structures, not merely error windows.

**Loadout.** Search with `<leader>fg` and send results with `<C-q>`. Navigate
quickfix with `[q` and `]q`, inspect with `:copen` or `<leader>xQ`, and use
`:colder` / `:cnewer` for list history. Location-list equivalents include
`:lopen`, `:lnext`, and `<leader>xL`.

**Challenge.**

1. From the Academy root, grep `score` and send results to quickfix.
2. Visit three files without closing the list.
3. Run a second search, then recover the first list with `:colder`.
4. Explain when a window-local location list would be safer.

**Proof.** You can move between two search result sets without repeating either
search.

- [ ] Mission clear — I manage quickfix and location lists as persistent queues. <!-- T2:M07 -->

### Mission 08 — Apply a reviewed multi-file change

**Situation.** `:argdo`, `:bufdo`, `:cdo`, and `:cfdo` differ in what they visit.
The narrowest correct collection is safest.

**Loadout.** `:args` shows the argument list; `:bufdo` visits listed buffers;
`:cdo` visits every quickfix entry; `:cfdo` visits each represented file once.
A guarded workflow is:

```vim
:cfdo %s/old/new/gce | update
```

**Challenge.**

1. Grep `Rival Academy` in the disposable project and send matches to quickfix.
2. Inspect the list and remove any file that should not change.
3. Use `:cfdo` with confirmation to make a harmless temporary rename.
4. Review every file with `:DiffviewOpen`, then reset the arena.

**Proof.** You can explain why `:cfdo` was preferable to `:cdo` for this task.

- [ ] Mission clear — I perform multi-file edits from a reviewed location set. <!-- T2:M08 -->

### Boss 02 — Project refactor without collateral damage

In the Academy project, choose a repeated identifier across at least two files.
Build a quickfix list, remove false positives, refactor with confirmation,
format affected files, run what can be run, and review through Diffview.

Constraints:

- Do not use a whole-project blind substitution.
- Do not save a file you did not intend to change.
- End with `:TutorArenaReset!` and a clean Git status.

- [ ] Mission clear — I completed and reversed a verified multi-file refactor. <!-- T2:B02 -->

---

## Act III — Workspace state and comparison

Files, buffers, windows, tabs, working directories, sessions, and lists are
different layers. Mastery means knowing which layer you are changing.

### Mission 09 — Control buffers, windows, tabs, and cwd

**Loadout.** A buffer holds text, a window displays a buffer, and a tab page
holds a window layout. `:ls` and `<leader>fb` choose buffers; `<C-^>` returns to
the alternate file; `<leader>-` and `<leader>|` split; `<C-h/j/k/l>` move
between windows. `:lcd` is window-local, `:tcd` is tab-local, and `:cd` is
global.

**Challenge.**

1. Open three Academy files in two windows.
2. Show the same buffer in both windows, then change one window to another
   buffer.
3. Create a second tab with a different layout.
4. Set a tab-local Academy cwd and prove another tab is unaffected with `:pwd`.

**Proof.** You can close a window without deleting its buffer and delete a
buffer without describing it as a tab.

- [ ] Mission clear — I manipulate each workspace layer intentionally. <!-- T2:M09 -->

### Mission 10 — Know what sessions, views, and ShaDa preserve

**Situation.** No single persistence mechanism saves everything.

**Loadout.** `:mksession! /tmp/rival-mastery-session.vim` records layout and
references; `:source` restores it. `:mkview` / `:loadview` preserve a view.
ShaDa keeps selected history, marks, jumps, and registers. None of these should
be trusted to preserve unsaved text.

**Challenge.**

1. Arrange two Academy windows and create a session under `/tmp`.
2. Change layout, source the session, and list what returned.
3. Set a mark and command-history entry, restart later, and observe ShaDa.
4. Make an unsaved edit and explain which safety system must protect it.

**Proof.** Write one sentence distinguishing session, view, ShaDa, undo, and
Git.

- [ ] Mission clear — I choose the correct persistence layer. <!-- T2:M10 -->

### Mission 11 — Resolve differences directionally

**Situation.** In native diff, `do` obtains from the other window and `dp` puts
to the other window. Direction depends on the active window.

**Challenge.**

1. Open `:TutorArena git` and make a small unsaved edit.
2. Create a vertical scratch window containing a different version.
3. Run `:diffthis` in both windows.
4. Navigate with `[c` and `]c`; obtain one hunk and put another.
5. Exit with `:diffoff!` without writing the scratch buffer.

**Proof.** Before pressing `do` or `dp`, you can name the source and destination
windows.

**Transfer.** Compare Git states with `<leader>hd` and repository changes with
`<leader>gd`; Fugitive's `:Gdiff` is not installed here.

- [ ] Mission clear — I resolve diffs without guessing their direction. <!-- T2:M11 -->

### Mission 12 — Feed compiler output into quickfix

**Situation.** `:make` runs `makeprg` and parses output using `errorformat`.
This is the native bridge from a tool's text output to navigable locations.

**Challenge.**

1. Open `academy.py` and inspect `:setlocal makeprg? errorformat?`.
2. Install a buffer-local syntax-check pipeline. The first option runs Python;
   the second parses its multiline location:

   ```vim
   :lua vim.bo.makeprg = "python3 -m py_compile %"
   :lua vim.bo.errorformat = [=[%E  File "%f"\, line %l,%C    %m,%Z%p^,%C%m]=]
   ```

3. Add a deliberate syntax error, then run `:write | make`. Use `:copen` and
   `:cfirst` or `]q` to reach the exact source line.
4. Undo, run `:write | make` again, and confirm the new quickfix list is empty.
5. Restore both local options with `:setlocal makeprg< errorformat<`.

**Proof.** You moved from external output to the exact source location without
copying a line number.

**Recovery.** The configured `<leader>r` runner remains the normal run path;
this mission teaches the native mechanism beneath many build workflows.

- [ ] Mission clear — I can turn tool output into navigable editor data. <!-- T2:M12 -->

### Boss 03 — Restore an investigation workspace

Build an Academy investigation containing:

- two source windows and one quickfix or Trouble view;
- a tab-local Academy working directory;
- one unsaved change protected by undo or Git;
- a diff view;
- a session file under `/tmp`.

Close the layout, restore it, identify what did not return, and recover that
state using the correct mechanism. Finish without writing scratch data.

- [ ] Mission clear — I restored a complex workspace and explained every layer. <!-- T2:B03 -->

---

## Act IV — Lua configuration craft

These missions inspect the real configuration but make experimental mutations
only in memory or in the disposable Academy. Do not paste experiments into the
config until you can explain their lifetime and scope.

### Mission 13 — Trace the module graph

**Loadout.** `init.lua` calls `require`; Lua caches returned modules in
`package.loaded`; relative organization lives under `lua/`. Lazy plugin specs
describe installation and loading, while `lua/config/` owns core behavior.

**Challenge.**

1. Use `<leader>fc` to open `init.lua` read-only.
2. Follow `require("config.tutor")` to this engine and one plugin import to its
   spec.
3. Inspect `:lua print(vim.inspect(package.loaded["config.tutor"]))`.
4. Find where `<leader>r` is defined and where its implementation lives.

**Proof.** Draw the path from startup file to module to user command or mapping.

**Recovery.** Do not clear `package.loaded` for live config modules during this
exercise; restarting is the clean reload boundary.

- [ ] Mission clear — I can trace ownership through the Lua module graph. <!-- T2:M13 -->

### Mission 14 — Inspect option and mapping provenance

**Loadout.** Options can be global, local, or global-local. `:set option?` reads
effective state; `:setlocal` changes only the current buffer/window when
supported; `:verbose set option?` and `:verbose nmap key` reveal the last
setter. `:maparg()` returns structured mapping data.

**Challenge.**

1. In Tutor2 and an Academy code window, compare `:setlocal wrap? spell?`.
2. Run `:verbose nmap <leader>tc` inside and outside Tutor2.
3. In a buffer with an LSP, inspect the full mapping record:

   ```vim
   :lua print(vim.inspect(vim.fn.maparg("gd", "n", false, true)))
   ```

4. Explain why one mapping is buffer-local and another is global.

**Proof.** You can identify what set a surprising value without searching the
entire config first.

- [ ] Mission clear — I diagnose scope and provenance before editing configuration. <!-- T2:M14 -->

### Mission 15 — Build disposable maps and commands

**Loadout.** `vim.keymap.set(mode, lhs, rhs, opts)` should usually include a
description and intentional scope. User commands can define `nargs`, `bang`,
`range`, and completion.

**Challenge.**

1. In `academy.lua`, create a buffer-local `<leader>mx` mapping in memory that
   prints the current file name.
2. Inspect it with `:verbose nmap <leader>mx`.
3. Create a buffer-local `:MasteryCount` command that reports the line count.
4. Delete both and prove `:MasteryCount` no longer exists in that buffer.

**Hint card—open only after trying.** Run these from `academy.lua`:

```vim
:lua vim.keymap.set("n", "<leader>mx", function() print(vim.api.nvim_buf_get_name(0)) end, { buffer = 0, desc = "Print current file" })
:lua vim.api.nvim_buf_create_user_command(0, "MasteryCount", function() print(vim.api.nvim_buf_line_count(0)) end, { desc = "Count current buffer lines" })
:lua vim.keymap.del("n", "<leader>mx", { buffer = 0 })
:lua vim.api.nvim_buf_del_user_command(0, "MasteryCount")
```

**Proof.** The feature works only where intended and leaves no permanent config
change.

**Transfer.** Permanent core mappings belong in `lua/config/keymaps.lua`;
plugin-owned mappings belong with that plugin's spec.

- [ ] Mission clear — I create scoped, discoverable, removable editor commands. <!-- T2:M15 -->

### Mission 16 — Own the autocmd lifecycle

**Situation.** Autocommands need a named augroup, a narrow event/pattern or
buffer, and a cleanup story.

**Challenge.**

1. Create an augroup named `MasteryLab` with `clear = true`.
2. Add a buffer-local `BufWritePost` callback for `academy.lua` that sends a
   harmless notification.
3. Inspect it with `:autocmd MasteryLab` and trigger it once.
4. Delete the group and prove the callback no longer fires.

**Hint card—open only after trying.** In `academy.lua`, the complete disposable
lifecycle is:

```vim
:lua local g = vim.api.nvim_create_augroup("MasteryLab", { clear = true }); vim.api.nvim_create_autocmd("BufWritePost", { group = g, buffer = 0, callback = function() vim.notify("MasteryLab wrote " .. vim.fn.expand("%:t")) end })
:autocmd MasteryLab
:write
:lua vim.api.nvim_del_augroup_by_name("MasteryLab")
:write
```

The first write must notify; the second must stay silent.

**Proof.** Recreating the setup does not duplicate callbacks.

**Recovery.** If notifications repeat, clear the group by ID or name; do not
stack another autocmd to hide the symptom.

- [ ] Mission clear — I build autocmds that are scoped, idempotent, and removable. <!-- T2:M16 -->

### Boss 04 — Ship an in-memory mini feature

In an Academy Lua buffer, build a temporary feature that:

1. creates a buffer-local command with a description;
2. creates a key that calls it;
3. observes one buffer event through a named augroup;
4. reports structured state through `vim.notify`;
5. cleans up the command, mapping, and augroup.

Use `:verbose` and `:autocmd` as proof. Restart Neovim and verify nothing
persisted.

- [ ] Mission clear — I built, inspected, and removed a scoped Lua feature. <!-- T2:B04 -->

---

## Act V — Plugin reliability and syntax intelligence

Healthy lazy loading means most plugins are absent until a feature needs them.
Reliability comes from understanding triggers, lockfiles, health, and evidence.

### Mission 17 — Read lazy loading correctly

**Situation.** `5/40 loaded` on the dashboard means five plugins were needed at
startup, not that thirty-five failed to install.

**Loadout.** A spec can load on an event, command, key, or filetype. `:Lazy`
shows installed/loaded state; `:Lazy profile` shows timing; opening a language
file or invoking a key loads its consumers.

**Challenge.**

1. Start on the dashboard and record the loaded count.
2. Open Tutor2, an Academy Python file, Diffview, and DAP one at a time.
3. Observe which plugins appear and why.
4. Identify one plugin that should remain unloaded in a normal writing session.

**Proof.** Explain why forcing all plugins to startup would make the editor
worse, not healthier.

- [ ] Mission clear — I interpret lazy state through triggers rather than totals. <!-- T2:M17 -->

### Mission 18 — Treat the lockfile as a rollback contract

**Loadout.** `lazy-lock.json` pins plugin commits. `:Lazy log` shows upstream
history, `:Lazy update` deliberately advances versions and the lockfile, and
`:Lazy restore` installs whatever the *current* lockfile pins. Therefore a real
rollback is two steps: restore `lazy-lock.json` from Git or a known-good commit,
then run `:Lazy restore`. `:Lazy sync` reconciles install/update/cleanup.

**Challenge.**

1. Inspect the lockfile and the current Git status without updating.
2. Open `:Lazy log` for one plugin and identify what an update would change.
3. Write a safe update protocol: clean tree, update, health, verified smoke,
   diff, then commit—or restore the old lockfile and run `:Lazy restore`.
4. Explain why deleting the lockfile is not a first-line repair.

**Proof.** You can name the exact rollback path before running an update.

- [ ] Mission clear — I can update plugins without surrendering reproducibility. <!-- T2:M18 -->

### Mission 19 — Inspect Treesitter instead of assuming

**Loadout.** `:Inspect` reports highlight information and `:InspectTree` shows
the syntax tree. This config uses expression folds, so `zc` / `zo` operate
syntax folds; manual `zf` / `zd` are not the normal workflow. Text objects
include `if/af`, `ic/ac`, and `ia/aa` where the parser supports them.

**Challenge.**

1. Open `academy.py` and inspect a function node.
2. Grow selection with `<C-Space>` and shrink with Backspace.
3. Move with `[f` / `]f` and swap parameters with `<leader>cp` or
   `<leader>cn` where applicable.
4. Close and reopen a syntax fold.

**Proof.** You can distinguish an LSP symbol, a Treesitter node, and a text
object mapping.

- [ ] Mission clear — I verify syntax structure and use it as an editing target. <!-- T2:M19 -->

### Mission 20 — Triage a plugin failure from evidence

**Loadout.** Start with `<leader>nh`, `:messages`, `:checkhealth`,
`:Lazy health`, the plugin's local logs, and `:verbose` provenance. A clean
comparison uses `nvim --clean`; a config smoke test uses headless mode.

**Challenge.**

1. Choose one harmless health warning and identify its owning feature.
2. Determine whether it is required, optional, or irrelevant to your workflow.
3. Compare behavior under `nvim --clean` and this config.
4. State the smallest spec/module that could cause the difference.

**Proof.** Produce a five-line incident note: symptom, reproduction, evidence,
owner, next test.

**Recovery.** Random reinstalls destroy evidence. Do not use them as diagnosis.

- [ ] Mission clear — I reduce plugin failures to a minimal, evidence-backed owner. <!-- T2:M20 -->

### Boss 05 — Reliability incident

Run a complete non-mutating reliability audit:

1. `:Lazy health` and `:checkhealth`;
2. notification history and `:messages`;
3. one `:verbose` option or mapping trace;
4. the verified headless smoke command from Preflight in a terminal;
5. a written classification of each warning as actionable or optional.

Do not update, delete caches, or reinstall anything. Gold rank requires a
minimal reproduction plan for one actionable issue.

- [ ] Mission clear — I completed a non-destructive reliability investigation. <!-- T2:B05 -->

---

## Act VI — Language intelligence and debugging

An IDE feature works only when its full chain works: filetype, project root,
executable, server or adapter configuration, attached client, and capability.

### Mission 21 — Trace the LSP attachment chain

**Challenge.**

1. Open `:TutorArena lsp`.
2. Check `:set filetype?`, `:pwd`, and the nearest Git root.
3. Inspect `:LspInfo` and list clients with
   `:lua print(vim.inspect(vim.lsp.get_clients({bufnr=0})))`.
4. Identify Pyright's role, Ruff's role, and none-ls's role.
5. Confirm the executable path through Mason or `:echo exepath("pyright-langserver")`.

**Proof.** Starting from a missing `gd`, you can test every link in order
without reinstalling first.

- [ ] Mission clear — I can trace an LSP feature from buffer to capability. <!-- T2:M21 -->

### Mission 22 — Prefer semantic refactors to textual guesses

**Loadout.** `gd`, `grr`, `gri`, `gy`, and `K` ask the attached server about
code meaning. `<leader>cr` requests rename; `<leader>ca` requests code actions;
`<leader>cS` searches workspace symbols.

**Challenge.**

1. Open `academy.py` and navigate from a call to its definition and back with
   `<C-o>`.
2. Inspect references before renaming `mission_report`.
3. Rename semantically, then review every workspace edit with Git diff.
4. Undo or reset, and compare this with a textual substitution.

**Proof.** Comments or unrelated strings are not changed unless the server
intentionally included them.

- [ ] Mission clear — I select semantic refactoring when code meaning matters. <!-- T2:M22 -->

### Mission 23 — Enforce one owner per operation

**Situation.** Multiple clients can attach without all of them owning
formatting. This config centralizes selection so Pyright, Ruff, none-ls, and
other servers do not race.

**Challenge.**

1. Run `:TutorArenaReset!`, open `:TutorArena format`, and inspect clients.
2. Run `<leader>cf` once; observe isort then Black behavior.
3. Run `:FormatInfo`. Toggle the global state twice with `<leader>uf`, checking
   after each change so its original value is restored.
4. Toggle the buffer state once with `<leader>uF`, inspect it, then restore
   inheritance with `:lua vim.b.autoformat = nil`.
5. Open `diagnostics.py` and identify each diagnostic source in a float.
6. Explain why adding another `BufWritePre vim.lsp.buf.format` autocmd would be
   harmful.

**Proof.** One explicit formatting action produces a stable result and a second
run makes no diff.

**Recovery.** Finish with `:TutorArenaReset!` and `:FormatInfo`; the project is
clean and format-on-save matches the state you recorded.

- [ ] Mission clear — I can identify and preserve formatting and diagnostic ownership. <!-- T2:M23 -->

### Mission 24 — Debug state, not just lines

**Loadout.** `<leader>db` toggles a breakpoint, `<leader>dB` adds a condition,
`F5` continues, `F10` steps over, `F11` steps in, `F12` steps out.
`<leader>du` toggles UI, `<leader>dw` inspects, `<leader>dr` opens the REPL, and
`<leader>dt` terminates.

**Challenge.**

1. Run `:TutorArenaReset!`, open `:TutorArena debug`, and predict the output.
2. Break inside the loop and inspect `score` and `total`.
3. Use a conditional breakpoint that stops on one score.
4. Prove why subtraction causes the failed result.
5. Fix, rerun, terminate cleanly, then use `:TutorArenaReset!`.

**Proof.** Your explanation cites observed variable state, not only the changed
operator.

- [ ] Mission clear — I use the debugger to test a causal hypothesis. <!-- T2:M24 -->

### Boss 06 — From report to proof

Run `:TutorArenaReset!`, then open `:TutorArena final`. Without a supplied fix:

1. reproduce the behavior with `<leader>r`;
2. navigate definitions and references semantically;
3. inspect diagnostics and TODOs;
4. form a hypothesis about the qualification boundary;
5. prove it in DAP;
6. implement the smallest fix;
7. format, rerun, and review the Git diff.

Expected qualifying missions at a minimum of 100 should include `Foundry` and
`Shipwright`. Reset with `:TutorArenaReset!` only after you can explain the bug.

- [ ] Mission clear — I moved from symptom through evidence to a verified fix. <!-- T2:B06 -->

---

## Act VII — Automation, Git, performance, and shipping

The final act makes your workflow reproducible outside a single editing
session.

### Mission 25 — Understand the runner and asynchronous jobs

**Loadout.** `<leader>r` / `:RunCurrent` runs the current language or project,
`<leader>R` / `:RunLast` repeats it, and `:RunStop` terminates it. The config's
runner uses `vim.fn.jobstart(..., { term = true, on_exit = ... })`. Its terminal
buffer streams output without freezing Neovim, and exit-time UI work is
scheduled before the notification.

**Challenge.**

1. Run `academy.py`, then `academy.lua` or `academy.js`.
2. Repeat the last command without reopening its configuration.
3. Open `:TutorArena shell`, insert `sleep 10` before `printf`, save, run it,
   and stop it with `:RunStop`; finish with `:TutorArenaReset!`.
4. Read `lua/config/runner.lua` and trace builder selection, the terminal buffer,
   the job ID, and `on_exit`.
5. Explain why `on_exit` uses `vim.schedule` before changing editor state or
   notifying.

**Proof.** You can distinguish process start, streamed output, exit code, and
editor notification.

- [ ] Mission clear — I can operate and reason about an asynchronous runner. <!-- T2:M25 -->

### Mission 26 — Control the Git index by hunk

**Situation.** Git has three pictures: HEAD, index, and working tree. A hunk
operation moves only part of a picture.

**Challenge.**

1. Run `:TutorArenaReset!`, open `:TutorArena git`, and make two separate edits.
2. Navigate with `[c` / `]c` and preview with `<leader>hp`.
3. Stage one hunk with `<leader>hs`; inspect `<leader>gs` or terminal
   `git diff --cached`.
4. Undo staging with `<leader>hu` and review with `<leader>gd`.
5. Use `<leader>hb` for one-line blame and `<leader>hB` only when you want the
   persistent toggle.

**Proof.** You can show a change in the index while another remains only in the
working tree. Finish with `:TutorArenaReset!`.

- [ ] Mission clear — I review and move Git state at hunk granularity. <!-- T2:M26 -->

### Mission 27 — Measure startup before optimizing it

**Loadout.** The dashboard loaded count measures demand, not health.
`:Lazy profile` shows plugin timing; terminal
`nvim --startuptime /tmp/nvim-startup.log` records startup phases; big-file
handling intentionally reduces expensive features.

**Challenge.**

1. Capture one startup log and identify the three largest entries.
2. Compare a dashboard start with opening a Python file.
3. Determine whether a slow item is startup-critical or lazily triggered.
4. State one proposed optimization and the measurement that would validate it.

**Proof.** Do not change the config unless the measurement predicts a meaningful
user-visible improvement.

- [ ] Mission clear — I optimize from measurements rather than plugin counts. <!-- T2:M27 -->

### Mission 28 — Reproduce editor behavior in isolation

**Loadout.** `nvim --clean` skips user configuration. `-u path` chooses a
specific init file. `--headless` enables smoke tests without a UI.
`NVIM_APPNAME` creates a complete profile: it changes config, data, state, and
cache names. That profile needs its own config directory and normally its own
plugin installation. A new app name plus only `-u ~/.config/nvim/init.lua`
does not put this config's `lua/` modules on `runtimepath`.

**Challenge.**

1. Compare `nvim --clean` with normal Neovim.
2. Run the verified smoke command from Preflight and read both its output and
   exit status.
3. Isolate only disposable state and cache while reusing the installed config
   and plugins:

   ```sh
   sandbox="$(mktemp -d)"
   XDG_STATE_HOME="$sandbox/state" XDG_CACHE_HOME="$sandbox/cache" \
     nvim --headless -u ~/.config/nvim/init.lua \
     '+lua vim.defer_fn(function() local ok = vim.v.errmsg == "" and vim.fn.exists(":Tutor2") == 2; vim.cmd(ok and "qa" or "cquit 1") end, 1000)'
   ```

4. Explain why this keeps production state/cache untouched but still uses the
   existing plugin data directory.
5. Design a full `NVIM_APPNAME` installation on paper. Do not run it unless you
   intend to copy a config and possibly download a separate plugin set.

**Proof.** You can reproduce whether a symptom belongs to Neovim, this config,
a plugin, or a project.

- [ ] Mission clear — I can build a clean, repeatable editor experiment. <!-- T2:M28 -->

### Boss 07 — Release drill

Start with `:TutorArenaReset!`. Using only the disposable Academy repository:

1. make a small code change;
2. format it through the configured owner;
3. run it and capture success;
4. inspect diagnostics;
5. stage only the intended hunk;
6. review working-tree and staged diffs separately;
7. run the verified headless config smoke test;
8. write a commit message, but committing is optional and pushing is forbidden
   for this drill.

Finish with a clean reset.

- [ ] Mission clear — I completed a reproducible editor-to-release drill. <!-- T2:B07 -->

---

## Final trial

### Final Boss — Operate without the script

Choose a real, small issue in a disposable project or fork. Complete the loop
without following a numbered keystroke recipe:

1. write a reproduction and expected result;
2. discover relevant files with pickers and quickfix;
3. navigate code semantically;
4. inspect diagnostics and attached clients;
5. form and test a hypothesis with logs or DAP;
6. make the smallest coherent edit;
7. format, run, and check diagnostics;
8. review hunks, index, and final diff;
9. run the verified headless smoke check;
10. write a short proof: symptom, cause, change, verification, residual risk.

Scoring:

- Bronze: the change works.
- Silver: the diff is minimal and the proof is reproducible.
- Gold: you can reset, reproduce the issue, and solve it again without this
  page.

- [ ] Mission clear — I independently shipped an evidence-backed change. <!-- T2:FINAL -->

---

## Replayable Mastery circuits

`:Tutor2Daily` chooses from circuits unlocked by mission progress. Keep them
short: ten to twenty minutes. Clear a circuit only after every item is done.

### Circuit A — Precision

1. Use a named register and the black-hole register.
2. Perform one bounded confirmed substitution.
3. Record and test a macro on two rows.
4. Inspect the resulting diff, then undo it.

- [ ] Daily clear — Precision circuit complete. <!-- T2:DA -->

### Circuit B — Ex queue

1. Build a quickfix list from project grep.
2. Move between two list histories.
3. Preview an Ex range.
4. Apply one confirmed `:cfdo` edit and reset it.

- [ ] Daily clear — Ex queue circuit complete. <!-- T2:DB -->

### Circuit C — Workspace

1. Arrange two buffers in two windows.
2. Set and verify a tab-local cwd.
3. Navigate one diff hunk directionally.
4. Restore a session or explain what it cannot preserve.

- [ ] Daily clear — Workspace circuit complete. <!-- T2:DC -->

### Circuit D — Lua craft

1. Trace one mapping with `:verbose`.
2. Create one buffer-local temporary mapping.
3. Create and trigger one named augroup.
4. Remove both and prove cleanup.

- [ ] Daily clear — Lua craft circuit complete. <!-- T2:DD -->

### Circuit E — Reliability

1. Read notification history and `:messages`.
2. Inspect Lazy profile without updating.
3. Run one focused health check.
4. Classify every warning you saw.

- [ ] Daily clear — Reliability circuit complete. <!-- T2:DE -->

### Circuit F — Code intelligence

1. Trace attached LSP clients.
2. Navigate definition and references.
3. Inspect a diagnostic source.
4. Break, step, inspect, and terminate one debug session.
5. Restore any changed Academy file.

- [ ] Daily clear — Intelligence circuit complete. <!-- T2:DF -->

### Circuit G — Ship

1. Reproduce a small issue.
2. Make and format one minimal fix.
3. Run and inspect diagnostics.
4. Stage one hunk, review it, then reset.
5. Run the verified headless config smoke check.

- [ ] Daily clear — Shipping circuit complete. <!-- T2:DG -->

---

## Twenty-eight-day Mastery route

Use this month-two route if a campaign map feels too open-ended. Most days ask
for one deep checkpoint or two closely related drills, followed by retrieval.

| Day | Work |
| --- | --- |
| 1 | Mission 01 |
| 2 | Mission 02 |
| 3 | Mission 03 |
| 4 | Mission 04, then Circuit A |
| 5 | Boss 01 |
| 6 | Missions 05–06 |
| 7 | Missions 07–08, then Circuit B |
| 8 | Boss 02 |
| 9 | Missions 09–10 |
| 10 | Missions 11–12, then Circuit C |
| 11 | Boss 03 |
| 12 | Missions 13–14 |
| 13 | Missions 15–16, then Circuit D |
| 14 | Boss 04 |
| 15 | Missions 17–18 |
| 16 | Missions 19–20, then Circuit E |
| 17 | Boss 05 |
| 18 | Missions 21–22 |
| 19 | Missions 23–24, then Circuit F |
| 20 | Boss 06 |
| 21 | Mission 25 |
| 22 | Mission 26 |
| 23 | Mission 27 |
| 24 | Mission 28 |
| 25 | Boss 07, then Circuit G |
| 26 | Final Boss: reproduce and plan |
| 27 | Final Boss: fix and verify |
| 28 | Reset, repeat the Final Boss, and graduate |

Do not compress the route merely to finish sooner. Sleep and retrieval are part
of learning. If yesterday's technique is not available without looking, replay
its circuit before adding more.

## Mastery field manual

### Precision editing

| Goal | Tool |
| --- | --- |
| Preserve yank across deletes | `"0` |
| Delete without changing paste | `"_d{motion}` |
| Append to named register | `"A{operator}` |
| Inspect registers | `:registers` |
| Record / run / repeat macro | `qa...q` / `@a` / `@@` |
| Inspect undo branches | `:undolist` / `<leader>fu` |
| Previous / next change | `g;` / `g,` |
| Back / forward jump | `<C-o>` / `<C-i>` |
| Treesitter function object | `if` / `af` |
| Syntax selection grow / shrink | `<C-Space>` / Backspace |

### Project queues and workspace

| Goal | Tool |
| --- | --- |
| Grep project | `<leader>fg` |
| Send picker results to quickfix | `<C-q>` |
| Previous / next quickfix | `[q` / `]q` |
| Quickfix through Trouble | `<leader>xQ` |
| Location list through Trouble | `<leader>xL` |
| Previous quickfix history | `:colder` |
| File-once quickfix command | `:cfdo command` |
| Buffer picker | `<leader>fb` |
| Split below / right | `<leader>-` / `<leader>\|` |
| Window movement | `<C-h/j/k/l>` |
| Tab-local cwd | `:tcd path` |

### Code intelligence

| Goal | Key |
| --- | --- |
| Definition / declaration | `gd` / `gD` |
| References / implementation | `grr` / `gri` |
| Type definition / hover | `gy` / `K` |
| Rename / action | `<leader>cr` / `<leader>ca` |
| Workspace symbols | `<leader>cS` |
| Previous / next error | `[e` / `]e` |
| Workspace / buffer diagnostics | `<leader>xx` / `<leader>xX` |
| Format now | `<leader>cf` |
| Toggle format globally / buffer | `<leader>uf` / `<leader>uF` |
| Code outline | `<leader>co` |

### Debug, run, and Git

| Goal | Key |
| --- | --- |
| Run / rerun / stop | `<leader>r` / `<leader>R` / `:RunStop` |
| Breakpoint / conditional | `<leader>db` / `<leader>dB` |
| Continue / over / in / out | `F5` / `F10` / `F11` / `F12` |
| DAP UI / hover / REPL / stop | `<leader>du` / `dw` / `dr` / `dt` |
| Previous / next Git hunk | `[c` / `]c` |
| Stage / reset / undo-stage hunk | `<leader>hs` / `hr` / `hu` |
| Preview hunk | `<leader>hp` |
| One-line / toggled blame | `<leader>hb` / `<leader>hB` |
| Diff working changes | `<leader>gd` |
| File history | `<leader>gH` |

### Diagnostic ladder

When something fails, climb this ladder in order:

1. Read the exact notification; open `<leader>nh` and `:messages`.
2. Confirm buffer state: `:set filetype?`, `:pwd`, modified flag, executable.
3. Confirm ownership: `:verbose`, `:LspInfo`, attached clients, Lazy state.
4. Reproduce with the smallest file and exact steps.
5. Compare with `nvim --clean` or a headless config launch.
6. Change one variable.
7. Retest and record the result.

### Recovery ladder

Use the narrowest recovery:

1. `<Esc>` returns to Normal mode; terminal mode uses `<Esc><Esc>`.
2. `u` / `<C-r>` recover local edits.
3. A named register or persistent undo recovers prior text/state.
4. Gitsigns resets one hunk; Git restores tracked files.
5. `:TutorArenaReset!` restores the disposable Academy baseline.
6. After an update, restore the old `lazy-lock.json` from Git or a known-good
   commit, then run `:Lazy restore` to reinstall those pinned commits.
7. A Git revert or known-good commit handles shared history.

Never jump to cache deletion, plugin reinstall, or force reset while a narrower
recovery still exists.

## Graduation

Tutor1 plus Tutor2 can make you substantially better at Neovim and at moving
through a professional coding workflow. It cannot replace building software,
reading code, learning a language, testing ideas, and receiving review.

The graduation habit is simple:

1. practice for twenty to thirty focused minutes;
2. close the tutor;
3. use one technique in a real project;
4. write down where it helped or failed;
5. replay the matching circuit tomorrow.

When the keys disappear from conscious thought and your attention stays on the
problem, the course has done its job.
