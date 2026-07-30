<!-- RIVAL_TUTOR_VERSION:2026.07 -->
<!-- markdownlint-disable MD024 -->
# Rival Academy

## A living Neovim campaign, from first movement to shipping code

Welcome, pilot.

This is not a page you are supposed to read and forget. It is a campaign you
play inside the editor. You will move through small missions, break disposable
files, recover from mistakes, fight a boss at the end of every act, and return
for short daily circuits.

The course is written for this exact Neovim configuration. Its field manual at
the end covers the keys and workflows you need for normal work, so you should
not have to leave the course just to discover how your editor is wired.

The goal is not to memorize hundreds of keys. The goal is to learn a small
language:

> operator + count + motion or text object

Once that grammar clicks, editing stops feeling like a collection of shortcuts.

## Start here — how the Academy works

Your `<leader>` key is `Space`. When this course prints `<leader>ff`, press
`Space`, then `f`, then `f`. Angle brackets name special keys:

- `<C-r>` means hold Control and press `r`.
- `<A-j>` means hold Alt and press `j`.
- `<S-Tab>` means Shift-Tab.
- `<CR>` means Enter.
- `<Esc>` means Escape.

Use these Academy commands:

| Command or key | What it does |
| --- | --- |
| `:Tutor1` or `<leader>tt` | Resume at the first uncleared mission |
| `:TutorMap` or `<leader>tm` | Pick an act from the campaign map |
| `:TutorStats` or `<leader>tp` | Show rank, cleared missions, and XP |
| `:TutorCheck` or `<leader>tc` | Mark the current mission or daily clear |
| `]m` / `[m` | Next / previous mission while Tutor1 is open |
| `:TutorRetry` or `<leader>tr` | Restore the surrounding Markdown arena |
| `:TutorDaily` or `<leader>td` | Open today’s replayable circuit |
| `:TutorArena` or `<leader>ta` | Choose a real code practice file |
| `:TutorArena python` | Open a named real-file arena directly |
| `:TutorArenaReset!` | Restore the disposable code project |
| `:Tutor1Reset!` | Erase all course checkmarks and Markdown edits |

`<leader>t` still opens Tutor1, but it is also the beginning of several Tutor
mappings, so Neovim may wait up to 300 ms to see whether another key follows.
`:Tutor1` and `<leader>tt` are unambiguous.

Your progress is not stored in this Git repository. `:Tutor1` creates a working
copy under Neovim’s state directory. Saving, checking missions, and wrecking an
exercise will not dirty your Neovim config. The master copy stays pristine.

Real IDE features need real files. Python LSP cannot attach to Python text
inside a Markdown fence, and a debugger cannot run it. `:TutorArena` creates a
local Git repository containing `.py`, `.lua`, `.js`, `.sh`, HTML, CSS, logs,
and data. Each arena opens in a tab whose local working directory is the
Academy project, so Explorer, grep, Git, and terminals stay scoped there. It is
deliberately safe to edit, stage, reset, and break.

If you prefer a calendar over a campaign map, search `/The 30-day route` now
and follow one row per day.

### Preflight — make sure the ship has engines

The Academy teaches editor workflows, but language runtimes and external tools
still have to exist on the machine. Run this once; missing optional tools only
affect their matching wings.

| Check | What healthy looks like |
| --- | --- |
| `:version` | Neovim 0.11.x |
| `:Lazy` | Plugins loaded without errors |
| `:Mason` | Desired LSPs, formatters, linters, and DAP adapters installed |
| `:checkhealth` | No unexpected errors in features you use |
| `:checkhealth vim.provider` | Clipboard and provider status explained |
| terminal `git --version` | Git available for projects and Academy |
| terminal `rg --version` | ripgrep available for project search |
| terminal `fd --version` | `fd` available; some systems call it `fdfind` |
| terminal `python3 --version` | Python runner/debugger wing available |
| terminal `node --version` | JavaScript and web tooling available |

Use a Nerd Font in your terminal for the configured icons. Mason installs
editor tooling; it does not replace project runtimes such as Python, Node, Go,
Rust, Dart, Flutter, GCC, or system Lua.

### The scoring system

Every mission clear is worth 100 XP. The first clear of each daily circuit is a
25 XP badge; run `:TutorCheck` from its section just as you would in a mission.
Campaign rank depends on core missions, while `:TutorStats` reports both.
Medals are self-awarded:

- Bronze — reach the correct result.
- Silver — use the mission’s intended technique.
- Gold — finish the remix without reading its exact recipe.

There is no punishment for mistakes or missed days. `u`, retry, and starting
again are part of the craft. Ranks are:

`Apprentice → Navigator → Operator → Refactorer → IDE Pilot → Shipwright → Rival`

### The three safety ropes

When anything feels strange:

1. Press `<Esc>` once or twice to return to Normal mode.
2. Press `u` to undo; use `<C-r>` to redo.
3. Use `:TutorRetry` inside a Markdown arena or `:TutorArenaReset!` in the code
   project.

Never practice destructive Git commands in your real project until you
understand them. The Academy repository exists so curiosity is cheap.

## Prologue — The Safe Room

### Mission 01 — Know where you are

The editor has modes because the same keys can express movement, editing, and
text. That sounds odd for five minutes and becomes the source of its speed.

**Win condition:** enter text, select it, run a command, and always find Normal
mode again.

#### Loadout

- `i` — enter Insert mode before the cursor.
- `v` — enter characterwise Visual mode.
- `:` — open command-line mode.
- `<Esc>` — return toward Normal mode.

Look at the left side of the statusline. It tells you the current mode.

<!-- ARENA:m01-modes:BEGIN -->
mode beacon: repair this sentence
<!-- ARENA:m01-modes:END -->

1. Put the cursor on `repair`, press `i`, type `carefully`, add a space, then
   press `<Esc>`.
2. Press `v`, then `l` once to preview a selection moving right, then `<Esc>`.
   Movement is taught properly in Mission 04.
3. Type `:version`, press `<CR>`, glance at the output, then press `<CR>` again.
4. Press `i`, type `home`, and use `<Esc>` to return home to Normal mode.

Normal mode is the editor’s home, not a punishment. Insert mode writes text;
Normal mode shapes it.

**Recovery:** if keys begin inserting characters unexpectedly, press `<Esc>`.
If `q` appears in the statusline as recording, press `q` once to stop the macro.

**Recall:** why does pressing `i` enter Insert mode instead of inserting the
letter `i` while you are in Normal mode?

- [ ] Mission clear — I can identify Normal, Insert, Visual, and command-line modes.

### Mission 02 — Save, leave, and come back alive

Unsaved work should never feel mysterious.

**Win condition:** save intentionally, understand modified buffers, and know the
safe ways out.

#### Loadout

- `<C-s>` — save the current file from Normal, Insert, Visual, or Select mode.
- `:w` — write; `:q` — quit a window; `:wq` — write and quit.
- `:q!` — abandon unsaved changes in the current buffer.
- `:qa` / `:qa!` — quit all, with or without abandoning changes.

This config has `confirm` enabled. If a command would lose edits, Neovim often
offers to save rather than throwing your work away.

<!-- ARENA:m02-save:BEGIN -->
save beacon: change ORANGE to green, then save this file
<!-- ARENA:m02-save:END -->

Change `ORANGE`, press `<Esc>`, then `<C-s>`. A clean buffer has no modified
marker. `:update` is what the mapping uses, so an unchanged file is not written
again.

Try `:pwd` to print the working directory and `:file` to show the current file.
Do not run `:q!` now unless you are happy to discard all unsaved Tutor changes.

#### Recovery

- `:messages` shows notifications that disappeared.
- `:Tutor1` reopens the course.
- `:TutorRetry` restores the exercise above if your cursor is inside it.

**Recall:** which command writes only when the buffer changed? `:update`.
`<C-s>` is this config’s convenient mapping for it.

- [ ] Mission clear — I can save, quit safely, and deliberately abandon changes.

### Mission 03 — Time travel without fear

Fast editors are useful only when experimentation is reversible.

**Win condition:** make several edits, move backward and forward through them,
and inspect persistent undo history.

#### Loadout

- `u` — undo the latest change.
- `<C-r>` — redo.
- `U` — undo every change made to the current line.
- `<leader>fu` — open the visual undo-history picker.

<!-- ARENA:m03-undo:BEGIN -->
stage one
stage two
stage three
<!-- ARENA:m03-undo:END -->

Change each `stage` to `round` as three separate edits. Press `u` three times,
then `<C-r>` twice. Open `<leader>fu`; move through history with `<C-j>` and
`<C-k>`, preview states, and press `<Esc>` to cancel.

Undo history is persistent because `undofile` is enabled. Close and reopen a
saved file tomorrow and its undo story is still available.

`g-` and `g+` move through undo states chronologically. They become valuable
when you undo, make a different edit, and create a branch.

**Recovery:** `:TutorRetry` restores the three lines without touching your
mission progress.

**Recall:** undo changes the text; `<C-o>` later in the course changes only your
location. Do not confuse them.

- [ ] Mission clear — I can undo, redo, and inspect an undo tree.

### Boss 00 — The emergency drill

The alarm panel is confident that everything is fine. It is wrong.

#### Win condition

1. Enter Insert mode and type `temporary`.
2. Return to Normal mode.
3. Undo the insertion, redo it, then undo it again.
4. Start a `/temporary` search, cancel with `<Esc>`, and save.
5. Open `<leader>fk`, type `Tutor`, inspect the registered mappings, and close.

`<leader>fk` is your searchable keymap memory. Press `Space` and pause whenever
you forget which leader group exists; Which-key will reveal it.

**Gold challenge:** complete the drill without clicking and without using an
arrow key. This is an optional fluency exercise, not a law—the mouse and arrows
are enabled for accessibility and convenience.

- [ ] Mission clear — I can recover from modes, edits, searches, and forgotten keys.

## Act I — The Navigation Grid

### Mission 04 — Home-row movement and counts

Movement keys live under your right hand:

- `h` left, `j` down, `k` up, `l` right.
- A count comes first: `5j`, `3l`, `12k`.
- Relative line numbers show the count to nearby lines.

**Win condition:** land on every beacon with counts instead of repeated taps.

<!-- ARENA:m04-grid:BEGIN -->
start . . . . east
.     .     .     .
.     .     .     .
.     .     .     .
south . . . . goal
<!-- ARENA:m04-grid:END -->

Put the cursor on the `s` in `start`. Use a count with `l` to move most of the
way toward `east`; horizontal counts come from what you see. Then use the
relative line number as the exact count for `j` to reach the last row.

`<leader>uL` toggles relative numbers if you ever want absolute-only numbering.
This configuration keeps both absolute current-line and relative neighbor
numbers on by default.

**Combo:** counts work with much more than movement. `3x`, `4dd`, and `2>` all
reuse the same idea.

**Recovery:** `u` reverses edits, but movement needs no recovery.

- [ ] Mission clear — I use counts when a destination is several cells away.

### Mission 05 — Words and WORDS

Code is rarely navigated one character at a time.

#### Loadout

- `w` next word start; `e` word end; `b` previous word start; `ge` previous end.
- Uppercase `W`, `E`, and `B` treat punctuation as part of one whitespace-
  separated WORD.

<!-- ARENA:m05-words:BEGIN -->
api.client.fetch(user_id, retry_count)
/var/log/rival-academy/session.json
alpha-beta gamma_delta "quoted value"
<!-- ARENA:m05-words:END -->

Move across the first line with `w`, then retry with `W`. On punctuation-heavy
text, `W` makes larger jumps. Use `e` to land on an end and `b` to return.

Useful contrast:

- `dw` deletes toward the next word start.
- `de` deletes through the current word end.
- `diw` later deletes the entire inner word regardless of cursor position.

**Gold challenge:** move from `api` to `retry_count` in as few purposeful jumps
as possible, then return.

**Recall:** lowercase means syntax-like words; uppercase means chunks separated
by whitespace.

- [ ] Mission clear — I choose word or WORD movement based on punctuation.

### Mission 06 — Lines, files, and paragraphs

#### Loadout

- `0` first column; `^` first nonblank; `$` line end; `g_` last nonblank.
- `gg` first line; `G` last line; `42G` line 42.
- `{` / `}` previous / next blank-line paragraph.
- `M` middle visible line; `zz`, `zt`, `zb` center/top/bottom the current line.
- `<C-d>` / `<C-u>` half-page down/up.

`H` and `L` normally mean top and bottom of the screen, but this config remaps
them to previous and next buffer. Use `zt` and `zb` when screen placement is
what you mean.

<!-- ARENA:m06-lines:BEGIN -->
    first_nonblank = true
middle = "keep moving"
last_value = 42

second paragraph begins here
and ends here

final paragraph
<!-- ARENA:m06-lines:END -->

Land on the first nonblank character with `^`, the end with `$`, then the next
paragraph with `}`. Jump to the bottom with `G`, top with `gg`, and recenter
with `zz`.

`<C-e>` and `<C-y>` scroll the view one line while keeping the cursor as still
as possible. `scrolloff=8` normally keeps breathing room around your cursor.

**Recall:** `0` means physical column zero; `^` skips indentation.

- [ ] Mission clear — I can navigate a line, a document, and the viewport.

### Mission 07 — Character hunting and matched pairs

#### Loadout

- `f{char}` land on the next character; `t{char}` stop just before it.
- `F` and `T` search backward.
- `;` repeat the character search; `,` repeat in the opposite direction.
- `%` jumps between matching brackets, braces, parentheses, and some language
  constructs.

<!-- ARENA:m07-find:BEGIN -->
deploy(region, retries, timeout, owner)
payload = { status = "queued", attempts = [1, 2, 3] }
<!-- ARENA:m07-find:END -->

On the first line, press `fr` to reach the first `r`, then `;` to repeat. Use
`t,` to stop before a comma. On the second line, place the cursor on `{` and
press `%`, then try the square brackets.

Character hunts compose with operators:

- `dt,` deletes until the comma but keeps it.
- `df,` deletes through the comma.
- `ct)` changes until the closing parenthesis.

**Gold challenge:** change only `timeout` using a character hunt plus `ciw`.

- [ ] Mission clear — I use f/t, repeat them, and jump matched pairs.

### Mission 08 — Search as movement

#### Loadout

- `/pattern` search forward; `?pattern` search backward.
- `n` repeats in the same direction; `N` reverses direction.
- `*` searches the word under the cursor forward; `#` backward.
- `<Esc>` in Normal mode clears search highlighting in this config.

Search ignores case unless you type an uppercase letter because `ignorecase`
and `smartcase` are enabled. `/pilot` matches `Pilot`; `/Pilot` does not match
lowercase `pilot`.

<!-- ARENA:m08-search:BEGIN -->
pilot Nova is ready
pilot Echo is waiting
Pilot Orion is offline
pilot Vega is ready
<!-- ARENA:m08-search:END -->

Search `/ready`, use `n` and `N`, then place the cursor on `pilot` and try `*`.
Press `<Esc>` to clear the bright matches without changing the search history.

Useful regex pieces:

- `\V` makes the rest very nomagic—mostly literal.
- `\<word\>` matches a whole word.
- `\c` forces ignore-case; `\C` forces exact case.
- `\v` enables “very magic” syntax with fewer backslashes.

Example: `/\v(pilot|Pilot) (Nova|Vega)`.

**Recovery:** if the pattern is invalid, press `<Esc>` and start again.

- [ ] Mission clear — I navigate search results and understand smart case.

### Mission 09 — Flash and location history

Built-in search is ideal when you know text. Flash is ideal when you can see a
destination.

#### Loadout

- `s`, type one or more visible characters, then press the label at the target.
- `S` opens Treesitter-aware structural Flash.
- `<C-o>` goes to an older jump; `<C-i>` goes to a newer jump.

Normal `s` and `S` traditionally substitute a character or line, but Flash owns
them here. Use `cl` for “change one character” and `cc` for “change line.”

<!-- ARENA:m09-flash:BEGIN -->
gateway_alpha   queue_delta   worker_nova
cache_orion     queue_echo    worker_vega
gateway_bravo   queue_foxtrot worker_luna
<!-- ARENA:m09-flash:END -->

Press `s`, type `wo`, and choose a label over one of the worker names. Jump
elsewhere, then use `<C-o>` and `<C-i>` to travel through the jump list.

Flash also enhances labels during `/` searches. In operator-pending mode,
`d` then `r` uses remote Flash: the operation can target text elsewhere without
leaving your original location.

**Gold challenge:** use `s` to visit all three `gateway` entries, returning
through the jump list afterward.

- [ ] Mission clear — I can jump visually and return through location history.

### Boss 01 — Cross the grid

The operations board contains one failing worker. Reach facts, not coordinates.

<!-- ARENA:boss01-grid:BEGIN -->
region=west  service=api     state=healthy retries=0
region=east  service=cache   state=healthy retries=1
region=north service=worker  state=failing retries=4
region=south service=queue   state=healthy retries=0
<!-- ARENA:boss01-grid:END -->

#### Win condition

1. Start anywhere above the arena.
2. Reach `failing` with search or Flash.
3. Reach `retries=4` with `f`/`t` or a word motion.
4. Return to your earlier position with `<C-o>`.
5. Center the result with `zz`.

**Gold challenge:** do it without `h`, `j`, `k`, `l`, mouse, or arrows.

- [ ] Mission clear — I navigate by meaning, not by repeated single steps.

## Act II — The Editing Foundry

### Mission 10 — Six doors into Insert mode

#### Loadout

- `i` before cursor; `a` after cursor.
- `I` first nonblank; `A` line end.
- `o` new line below; `O` new line above.

<!-- ARENA:m10-insert:BEGIN -->
    mission = "navigation"
reward = 100
<!-- ARENA:m10-insert:END -->

Add `local` and a trailing space at the first nonblank position with `I`.
Append a space followed by `-- cleared` with `A`. Create a new line between the
two using `o` or `O`.

`gi` returns to the last Insert position. `gI` inserts at physical column zero.

Autopairs closes quotes and brackets after you open them. In HTML/JSX, Autotag
also closes and renames tags. These are assistance, not new modes.

**Recall:** `a` is “append after”; `A` is “append at line end.”

- [ ] Mission clear — I enter Insert mode at the location I actually need.

### Mission 11 — Vim’s editing sentence

Most editing is a sentence:

> operator + optional count + motion

#### Operators

- `d` delete, `c` change and enter Insert, `y` yank (copy).
- Doubling applies to a line: `dd`, `cc`, `yy`.
- `D` is `d$`; `C` is `c$`; `Y` behaves like `yy`.

<!-- ARENA:m11-grammar:BEGIN -->
remove temporary cache entry
change staging to production
copy this entire line
<!-- ARENA:m11-grammar:END -->

1. On `temporary`, use `daw` after Mission 12 if you know it, or `dw` now.
2. On `staging`, use `cw`, type `production`, then `<Esc>`.
3. Use `yy` on the third line and `p` to paste a copy below.
4. Undo the pasted line if you do not want it.

Grammar scales:

- `d3w` and `3dw` both delete three word motions.
- `2dd` deletes two lines.
- `c}` changes through the paragraph.
- `y$` copies to line end.

**Recovery:** changing deletes into a register before inserting. `<Esc>u`
returns the old text.

- [ ] Mission clear — I can form delete, change, and yank commands.

### Mission 12 — The inside job: text objects

Motions travel. Text objects describe a thing under or around the cursor.

#### Loadout

- `iw` inner word; `aw` a word including surrounding whitespace.
- `i"` / `a"` inside / around quotes.
- `i(`, `i[`, `i{` and their `a` variants.
- `it` / `at` inside / around an HTML-like tag.

<!-- ARENA:m12-objects:BEGIN -->
channel = "nightly"
flag = temporary enabled
call(alpha, beta, gamma)
<!-- ARENA:m12-objects:END -->

Put the cursor anywhere inside `nightly`, press `ci"`, type `production`, then
`<Esc>`. On `temporary`, compare `diw` with undo then `daw`. The `a` version
usually removes the unwanted space too.

On `beta`, try `ciw`. Inside the parentheses, `di(` would remove all arguments
but leave the pair; `da(` would remove the parentheses as well.

Text objects work with Visual mode too: `vi"` selects quote contents.

**Gold challenge:** repair both first lines without moving onto either edge.

- [ ] Mission clear — I target semantic objects instead of carefully selecting characters.

### Mission 13 — Small repairs, joins, case, and indent

#### Loadout

- `x` delete under cursor; `X` delete before it.
- `r{char}` replace one character; `R` enter overwrite mode.
- `J` join the next line with a space; `gJ` join without adding one.
- `~` toggle one character’s case; `gU{motion}` uppercase; `gu{motion}` lowercase.
- `>>` / `<<` indent / unindent a line; `=` uses filetype indentation.

<!-- ARENA:m13-repairs:BEGIN -->
statuz = "READY"
message = "split"
          .. " badly"
    over_indented = true
<!-- ARENA:m13-repairs:END -->

Replace the `z` in `statuz` with `s` using `rs`. Lowercase `READY` with
`gui"`. Join the two message lines. Correct indentation with `<<` or `==`.

Because Flash owns Normal `s` and `S`, use `cl` to change one character and
`cc` to change a line when replacement is more than one keystroke.

**Combo:** `gUw` uppercases through a word motion; `gUiw` uppercases the exact
word under the cursor.

- [ ] Mission clear — I make precise repairs without retreating to backspace.

### Mission 14 — Visual, linewise, and blockwise work

#### Loadout

- `v` characterwise; `V` whole lines; `<C-v>` rectangular block.
- `o` swaps the active end of a selection.
- `gv` reselects the previous Visual area.
- `<` / `>` indent and remain selected in this config.

<!-- ARENA:m14-visual:BEGIN -->
alpha   enabled
bravo   enabled
charlie enabled
delta   enabled
<!-- ARENA:m14-visual:END -->

1. Use `V` to select two rows and `>` twice; `<` can bring them back.
2. Put the cursor on the first `a` in `alpha`.
3. Press `<C-v>`, move down three lines, then `I# <Esc>` to insert at the start
   of every selected row. Neovim applies the insertion when you leave Insert.
4. Undo, then use a block over the first column and `~` to toggle case.

`virtualedit=block` lets block selections extend through short lines.

**Recovery:** if the rectangle is wrong, `<Esc>` then `gv` returns it for
adjustment. `u` restores the text.

- [ ] Mission clear — I use the Visual shape that matches the edit.

### Mission 15 — Paste without collateral damage

#### Loadout

- `p` paste after/below; `P` before/above.
- `"0p` pastes the most recent yank even after a delete.
- `"_d{motion}` deletes to the black-hole register and preserves your paste.
- In Visual mode, `P` replaces the selection without overwriting the unnamed
  register in modern Neovim.

This config sets `clipboard=unnamedplus`, so normal yanks and pastes use the
system clipboard when a clipboard provider is available.

<!-- ARENA:m15-paste:BEGIN -->
SOURCE_VALUE
delete_this
target: ______
<!-- ARENA:m15-paste:END -->

Yank `SOURCE_VALUE` with `yiw`. Delete `delete_this`, then notice ordinary `p`
would paste the deletion. Use `"0p` to retrieve the yank. Try the exercise again
using `"_diw` for the deletion.

Inspect registers with `:registers`. The preview includes:

- `"` unnamed, `0` latest yank, `1` newest linewise delete.
- `a` through `z` named storage.
- `+` system clipboard, `_` black hole.

**Gold challenge:** replace the underscores with the source while keeping
`SOURCE_VALUE` available for another paste.

- [ ] Mission clear — I control what gets pasted instead of hoping.

### Mission 16 — Named registers and appendable memory

#### Loadout

- `"ayy` yank a line into register `a`; `"ap` paste it.
- `"Ayy` appends another yank to register `a`.
- `:registers a` inspects only that register.
- In Insert mode, `<C-r>a` inserts register `a`.

<!-- ARENA:m16-registers:BEGIN -->
first clue: operator
second clue: text object
third clue: motion
report:
<!-- ARENA:m16-registers:END -->

Yank the first clue into `a`. Append the second and third with uppercase `A`.
Move after `report:` and paste register `a`.

Other useful registers:

- `"%` current filename.
- `":` most recent Ex command.
- `"/` latest search pattern.
- `".` latest inserted text.
- `"=` expression register; try Insert `<C-r>=2+2<CR>`.

**Recovery:** registers are memory, not history. If you overwrite one, undo does
not restore the register; repeat the yank or use a different named register.

- [ ] Mission clear — I deliberately store, append, inspect, and insert registers.

### Mission 17 — Surrounds, comments, and moving lines

#### Loadout

- `ys{motion}{delimiter}` add a surround: `ysiw"` wraps a word.
- `ds"` delete quotes; `cs"'` change double quotes to single.
- `yss)` surrounds a whole line.
- `gc{motion}` comment a motion; `gcc` toggles the current line.
- `<A-j>` / `<A-k>` move a line or Visual selection.

<!-- ARENA:m17-surround:BEGIN -->
deployment
"old quotes"
move me below the comment target
comment target
<!-- ARENA:m17-surround:END -->

Wrap `deployment` with `ysiw"`. Change the second line to single quotes with
`cs"'`, then remove them with `ds'`. Toggle a comment on the last line with
`gcc`. Move the third line down with `<A-j>`.

Visual `S` is not the surround mapping here because Flash owns `S`. Normal
`ys...`, `ds`, and `cs` are the reliable path. Visual `gS` exists but uses a
line-style surround.

Autopairs, Autotag, Rainbow Delimiters, Colorizer, and context-aware comments
run automatically where their filetypes apply.

- [ ] Mission clear — I can surround, comment, and reorder without manual punctuation.

### Mission 18 — Structural code with Treesitter

Treesitter understands syntax nodes rather than character patterns.

#### Loadout

- Normal `<C-Space>` begins a structural selection.
- Visual `<C-Space>` grows it; Visual `<BS>` shrinks it.
- `if` / `af` function, `ic` / `ac` class, `ia` / `aa` parameter.
- `]f` / `[f`, `]C` / `[C`, `]a` / `[a` move between structures.
- `<leader>cn` / `<leader>cp` swap next / previous parameter.

Open `:TutorArena python`. Put the cursor inside `mission_report` and grow a
selection several times with `<C-Space>`. Shrink with `<BS>`. Try `vif`, then
`<Esc>`. Next open `:TutorArena lsp`; on the two arguments passed to `badge`,
swap parameters with `<leader>cn` or `<leader>cp`, then undo.

These mappings need an installed parser that exposes the matching node. They
are not expected to work on arbitrary plain text.

`<C-Space>` is context-sensitive: it is Treesitter selection in Normal/Visual
mode and completion/documentation in Insert mode.

**Gold challenge:** copy an entire function using `yaf` and paste it below,
then undo.

- [ ] Mission clear — I select, move through, and edit syntax structures.

### Boss 02 — Repair the launch manifest

<!-- ARENA:boss02-foundry:BEGIN -->
environment = "stagng"
temporary feature = enabled
owners = (nova,echo,vega)
launch = false
<!-- ARENA:boss02-foundry:END -->

#### Win condition

1. Repair `stagng` with one-character replacement.
2. Remove `temporary` and its extra space with a text object.
3. Change `echo` to `orion` without landing on a comma.
4. Surround `nova` with quotes.
5. Toggle the last line as a comment.
6. Repeat one suitable edit with `.` if you can.

**Recovery:** `:TutorRetry` restores only this manifest.

- [ ] Mission clear — I combine grammar, objects, registers, and plugin editing.

## Act III — The Time Machine and Command Forge

### Mission 19 — Design edits for the dot command

`.` repeats the last change, including text typed during that change. The best
Vim edits are often chosen because they are repeatable.

<!-- ARENA:m19-dot:BEGIN -->
status=pending
status=pending
status=pending
status=pending
<!-- ARENA:m19-dot:END -->

On the first `pending`, use `ciwready<Esc>`. Move to the next occurrence with
`n` after searching, or `j` then `w`, and press `.`. Repeat.

Contrast:

- Many backspaces and cursor moves create a messy repeat.
- One `ciw...<Esc>` creates a clean repeatable unit.
- `@:` repeats the last Ex command; `&` repeats the last substitution on a
  line; `:&&` repeats it with flags.

**Gold challenge:** change all four values using one initial edit and three dots.

- [ ] Mission clear — I construct a change once and replay it with dot.

### Mission 20 — Counts are a multiplier

Counts can appear before an operator or its motion.

<!-- ARENA:m20-counts:BEGIN -->
one two three four five six seven
alpha
bravo
charlie
delta
echo
<!-- ARENA:m20-counts:END -->

Try and undo each:

- `3dw` — three word motions.
- `d3w` — the same composition.
- `2dd` — two lines.
- `3>>` — indent three lines.
- `4j` — move four lines.

A count on both sides multiplies: `2d3w` applies a three-word deletion twice,
effectively six motions. Powerful, rarely necessary, easy to remember from the
grammar.

`5.` repeats the last change five times where possible.

**Recall:** counts do not make a command “faster”; they make your intention
atomic and repeatable.

- [ ] Mission clear — I combine counts with motions, operators, and repetition.

### Mission 21 — Marks, jumps, and changes

Marks are named places. Jump and change lists are automatic travel history.

#### Loadout

- `ma` set local mark `a`.
- `` `a `` return to exact line and column; `'a` returns to its first nonblank.
- `mA` creates a global mark that can jump across files.
- `<C-o>` / `<C-i>` older / newer jump.
- `g;` / `g,` older / newer change position.
- `` `. `` latest change; `` `" `` last position when the file closed.

Open `:TutorArena python`. Set `ma` in `Pilot.award`, jump to the bottom with
`G`, and return with `` `a ``. Make changes in two distant functions and walk
them with `g;` and `g,`.

Use `:marks` to list marks and `:jumps` to inspect the jump list.

**Distinction:** a jump is a large navigation event; a change entry records
where text changed. Undo affects content, not either travel list.

- [ ] Mission clear — I bookmark locations and retrace jumps and edits.

### Mission 22 — Record a macro, not a mystery

A macro records Normal-mode keystrokes into a register.

#### Loadout

- `qa` start recording into `a`; `q` stop.
- `@a` play register `a`; `@@` repeat the latest played macro.
- `5@a` play it five times.
- `:registers a` lets you inspect what was recorded.

<!-- ARENA:m22-macro:BEGIN -->
nova,100
echo,075
vega,125
luna,050
<!-- ARENA:m22-macro:END -->

Goal: turn each row into `nova = 100 XP`.

One possible macro:

1. On the first line, `qa`.
2. `f,cl = <Esc>` changes the comma into a spaced equals.
3. `A XP<Esc>j0` appends and prepares the next line.
4. `q` stops.
5. Run `3@a`.

Your exact recording may differ. Record on the first row, test once, then use a
count only after it works.

**Recovery:** press `q` if recording is accidental. Undo macro playback once
per change, or retry the arena.

- [ ] Mission clear — I can record, inspect, test, and count macro playback.

### Mission 23 — Ranges and substitutions

Ex commands can target an explicit range.

#### Range language

- `.` current line; `$` last line; `%` entire file.
- `3,8` lines 3 through 8.
- `.,+3` current through three lines below.
- Visual selection becomes `'<,'>` automatically after pressing `:`.

#### Substitute grammar

`:[range]s/pattern/replacement/[flags]`

- `g` every match on each addressed line.
- `c` ask for confirmation.
- `i` ignore case; `I` case-sensitive.
- `&` reuse flags.

<!-- ARENA:m23-substitute:BEGIN -->
env=dev; owner=dev; note=leave-other-text
env=dev; owner=nova; note=dev
env=prod; owner=dev; note=keep
<!-- ARENA:m23-substitute:END -->

Select only these three lines with `V`, then run:

`:'<,'>s/\<dev\>/stage/gc`

Answer `y`, `n`, `a` (all), `q`, or `l` (last then quit) at prompts. Because
the range is the selection, instructions elsewhere are safe.

Capture groups in very-magic mode:

`:%s/\v(\w+)=(\w+)/\1: \2/g`

Do not run that over Tutor1; use `:TutorArena data` for broad experiments.

**Recovery:** `u` reverts one substitute command as one undo step.

- [ ] Mission clear — I use bounded ranges, confirmation, and substitutions safely.

### Mission 24 — Global and Normal as a tiny language

`:global` selects matching lines, then runs a command on each.

- `:g/pattern/command` matching lines.
- `:v/pattern/command` nonmatching lines.
- `:g/pattern/d` delete matches.
- `:g/pattern/normal! A text` run Normal keys on each match.

Open `:TutorArena logs`. The file is disposable and tracked in the Academy Git
repository.

Try:

1. `:g/ERROR/p` to print error lines without editing.
2. `:v/ERROR/p` to print everything else.
3. `:g/ERROR/normal! A  INVESTIGATE` to append only to error lines.
4. Undo once to restore all appended text.

Use `:TutorArenaReset!` whenever you want the baseline back.

Why `normal!`? The bang ignores mappings, so recorded Normal commands mean
native Vim keys. That prevents a custom mapping from changing the batch.

**Safety:** print with `p` before you delete with `d`.

- [ ] Mission clear — I filter lines and apply Normal edits as a batch.

### Mission 25 — Command and search history

The command line is editable history, not a one-shot prompt.

#### Loadout

- `q:` opens the command-line history window.
- `q/` opens search history.
- In those windows, edit a line and press `<CR>` to execute it.
- Normal `@:` repeats the latest Ex command.
- Command-line `<Up>` / `<Down>` browse matching history.

Run `:set number?`, `:set wrap?`, and `:pwd`. Open `q:`, move among them, edit
one harmless query, and press `<CR>`.

Useful command-line editing:

- `<C-r><C-w>` inserts the word under the cursor.
- `<C-r>%` inserts the current filename.
- `<C-f>` opens the command-line window from `:`.
- `<C-c>` or `<Esc>` cancels.

Search history works the same way with `q/`. The latest pattern also lives in
register `/`.

- [ ] Mission clear — I reuse and edit command/search history instead of retyping.

### Boss 03 — Clean the incident feed

Open `:TutorArena data`.

#### Win condition

1. Search for `failed`.
2. Change only whole-word `queued` to `ready`.
3. Use a macro or `:global ... normal!` to append `,reviewed` to failed rows.
4. Gather failed rows in register `a`: clear it with `:let @a=''`, then use
   `:g/failed/yank A` to append every matching line.
5. Inspect your undo history.
6. Restore with `:TutorArenaReset!`.

**Gold challenge:** print the target lines before changing them and finish with
no accidental changes to other statuses.

- [ ] Mission clear — I combine search, ranges, repetition, and safe recovery.

## Act IV — The Project Cockpit

### Mission 26 — Files, buffers, windows, and tabs

These are different objects:

- A **file** is data on disk.
- A **buffer** is Neovim’s in-memory view of a file or temporary content.
- A **window** is a viewport showing one buffer.
- A **tab page** is a layout of windows, not a browser-style file container.

Open `:TutorArena python`, then `:TutorArena lua`. They become two buffers, each
opened in a new tab by the Academy command.

Useful native commands:

- `:ls` list buffers; `:buffer {name}` switch.
- `:edit path` edit a file in the current window.
- `:split` / `:vsplit` create windows.
- `:tabnew`, `gt`, `gT` create/next/previous tab page.
- `<C-w>q` close a window; `:bdelete` removes a buffer.

This config’s safer buffer controls are taught in Mission 29.

**Recall:** closing a window does not necessarily unload its buffer.

- [ ] Mission clear — I can explain the editor’s file/buffer/window/tab model.

### Mission 27 — Dashboard and smart pickers

The dashboard appears when Neovim starts without a file:

- `f` files, `g` grep, `r` recent, `e` explorer.
- `n` new file, `c` config, `l` Lazy, `q` quit.

From anywhere:

- `<leader><space>` smart file search.
- `<leader>ff` files; `<leader>fg` project text.
- `<leader>fG` grep open buffers; `<leader>fr` recent.
- `<leader>fc` config files; `<leader>fb` or `<leader>,` buffers.
- `<leader>fh` help, `<leader>fk` keymaps, `<leader>fC` commands.

Inside a Snacks picker:

- Type to filter; `<C-j>` / `<C-k>` or arrows move.
- `<CR>` opens; `<Esc>` cancels.
- `<C-s>` horizontal split, `<C-v>` vertical split, `<C-t>` tab.
- `<Tab>` / `<S-Tab>` multi-select and move; `<C-a>` select all.
- `<C-q>` sends selections to quickfix.
- `<A-h>` hidden, `<A-i>` ignored, `<A-p>` preview, `<A-m>` maximize.
- `<C-b>` / `<C-f>` scroll preview; `/` switches input/list focus.
- `?` displays that picker’s local key guide.

Picker-local mappings override global ones: `<C-s>` opens a split there; it
does not save.

**Drill:** open `<leader>fc`, find `tutor.lua`, preview it, then open in a
vertical split with `<C-v>`. Close the split with `<C-w>q`.

- [ ] Mission clear — I find files, text, commands, and keys through pickers.

### Mission 28 — The filesystem Explorer

`<leader>e` toggles Snacks Explorer.

Inside Explorer:

- `<CR>` or `l` opens a file or directory; `h` closes a directory.
- `<BS>` goes to the parent; `Z` closes all expanded directories.
- `a` adds a file; end the name with `/` to make a directory.
- `r` rename; `d` delete; `c` copy; `m` move.
- `y` then `p` yanks paths and pastes/copies.
- `H` hidden files; `I` Git-ignored files; `P` preview; `u` refresh.
- `.` sets/focuses the directory; `<C-c>` changes the tab-local directory.
- `<leader>/` greps the selected directory; `<C-t>` opens a terminal there.
- `[g` / `]g` Git changes.
- `[d` / `]d`, `[e` / `]e`, `[w` / `]w` diagnostics by severity.

Open the Academy first with `:TutorArena readme`, then `<leader>e`. Create
`scratch.txt`, rename it to `notes.txt`, and delete it. Do not practice deletion
in a real project yet.

Explorer-local diagnostic keys take priority while focus is in the Explorer.
Press `?` whenever a local panel behaves differently.

**Recovery:** Academy files tracked by Git can be restored with
`:TutorArenaReset!`; an untracked file deleted through trash may be recoverable
through the system trash.

- [ ] Mission clear — I navigate and safely manipulate a project tree.

### Mission 29 — Buffers, splits, and pane control

#### Buffers

- `H` / `L` or `[b` / `]b` previous / next buffer.
- `<leader>,` or `<leader>fb` buffer picker.
- `<leader>bd` safely delete current buffer; `<leader>bo` delete others.
- `<leader>bp` pin; `<leader>bP` delete unpinned.
- `<leader>br` / `<leader>bl` delete buffers right / left.
- `<leader>bB` pick a visible Bufferline label.

#### Windows

- `<leader>-` split below; `<leader>|` split right.
- `<C-h/j/k/l>` move across Neovim and tmux panes.
- `<C-Up/Down>` change height; `<C-Left/Right>` width.
- `<C-w>=` equalize; `<C-w>o` keep only this window.
- `<leader>Z` zoom current window without destroying the layout.

Open three Academy files. Put them in splits, navigate every pane, resize, zoom,
then unzoom. Delete a buffer with `<leader>bd` and notice the window can remain
while another buffer replaces it.

**Recovery:** if an unsaved buffer blocks deletion, save or explicitly confirm
the discard. Hidden buffers are allowed, so switching does not lose edits.

- [ ] Mission clear — I arrange work without confusing buffers and windows.

### Mission 30 — Quickfix, location lists, diagnostics, and Trouble

A quickfix list is a project-wide set of locations. A location list belongs to
one window.

Create quickfix results:

1. Open `<leader>fg`, search `Academy`.
2. Select results with `<Tab>` or leave the current result.
3. Press `<C-q>` to send them to quickfix.

Then:

- `:copen` shows quickfix; `[q` / `]q` navigate; `:cclose` closes.
- `<leader>xQ` shows quickfix through Trouble.
- `:lopen`, `:lclose`, and `<leader>xL` are the location-list equivalents.
- `:cdo command` applies an Ex command to every quickfix entry.
- `:cfdo command` applies once per file in quickfix.

Trouble views:

- `<leader>xx` workspace diagnostics.
- `<leader>xX` current-buffer diagnostics.
- `<leader>cs` document symbols.
- `<CR>` jump, `o` jump and close, `p` preview, `q` close, `?` guide.
- `<C-s>` / `<C-v>` open split / vertical split.

**Safety:** never run `:cdo` edits until you inspect the list and understand the
range. Build the list, navigate it, then act.

- [ ] Mission clear — I turn many locations into a navigable work queue.

### Mission 31 — Terminal, runner output, scratch, and focus

#### Loadout

- `<C-/>` toggles a Snacks terminal from Normal or terminal mode.
- Terminal `<Esc><Esc>` returns to Normal mode.
- `<leader>.` opens a persistent contextual scratch.
- `<leader>S` selects an existing scratch.
- `<leader>z` Zen; `<leader>Z` zoom.
- `<leader>nh` notification history; `<leader>un` dismiss notifications.

Toggle a terminal. Run `pwd` and `git status`. Press `<Esc><Esc>` before using
Normal-mode window mappings. `<C-/>` hides the terminal again.

Some terminal emulators do not encode `<C-/>` consistently. `:terminal` is the
fallback; `:close` closes its window after leaving terminal mode.

Try a Lua scratch: set its filetype to Lua with `:set ft=lua`, type
`print(vim.version().major)`, and use the scratch’s `<CR>` execution mapping if
available.

UI toggles:

- `<leader>us` spell, `<leader>uw` wrap.
- `<leader>uL` relative numbers, `<leader>ul` line numbers.
- `<leader>ud` diagnostics, `<leader>uh` inlay hints.
- `<leader>ug` indent guides, `<leader>uD` dimming.

- [ ] Mission clear — I can enter, leave, and organize terminal and scratch work.

### Boss 04 — Investigate an unfamiliar repository

Use only the disposable project:

1. `:TutorArena readme`.
2. Open Explorer and identify every language.
3. Find all uses of `score` with project grep.
4. Send results to quickfix and visit each one.
5. Open `academy.py` and `academy.js` in a vertical split.
6. Open a terminal at the project root and run `git status`.
7. Return to Tutor1 through the buffer picker.

**Gold challenge:** keep the layout clean, end with no more than three useful
buffers, and never type a full path.

- [ ] Mission clear — I can inspect a multi-file project without losing context.

## Act V — The IDE Core

### Mission 32 — Completion and snippets

Open `:TutorArena python`, enter Insert mode inside `main`, and type a few
letters of `mission_report`.

Blink completion:

- `<C-Space>` show completion or toggle documentation.
- `<Tab>` / `<S-Tab>` next / previous item or snippet field.
- `<CR>` accept the selected completion.
- `<C-e>` hide the menu.

Sources are LSP, filesystem paths, snippets, buffer words, and enhanced Neovim
Lua knowledge. Documentation appears after about 250 ms, ghost text previews a
choice, and accepted function calls may receive brackets.

Insert `<C-k>` requests LSP signature help when a server is attached. It is
different from Normal `<C-k>`, which moves to the pane above.

Friendly Snippets supplies common language templates. Type a likely prefix such
as `def`, inspect source labels in the menu, accept, and use Tab through fields.
Available snippet prefixes depend on filetype.

**Recovery:** `<C-e>` dismisses a noisy menu; `u` reverses an accepted item.

- [ ] Mission clear — I filter, inspect, accept, cancel, and traverse completion.

### Mission 33 — LSP navigation: ask the code

Open `:TutorArena python`. Wait for LSP indicators, then run `:LspInfo` if you
want to verify `pyright` and `ruff`.

Buffer-local LSP keys:

- `gd` definition; `gD` declaration.
- `grr` references; `gri` implementations.
- `gy` type definition.
- `K` hover documentation.
- `<leader>cS` workspace symbols.

Put the cursor on `Pilot` in `main` and press `gd`. Use `<C-o>` to return.
Inspect references with `grr`; press `<CR>` on a picker result and return again.
Hover over `total_score`.

Not every server supports every request. Declarations and implementations may
legitimately return no results.

Navigation through pickers creates jumps, so the built-in jump list remains
your reliable “back” button.

- [ ] Mission clear — I navigate definitions, references, types, and history.

### Mission 34 — Rename, actions, and symbols

#### Loadout

- `<leader>cr` LSP rename across the project.
- `<leader>ca` context-sensitive code action in Normal or Visual mode.
- `<leader>cs` document symbols in Trouble.
- `<leader>co` Aerial outline; `<leader>cO` outline navigator.

Open `:TutorArena python`. Put the cursor on `total_score` and invoke
`<leader>cr`. Rename it to `sum_scores` and inspect every preview/change. A
plain `u` only affects the current buffer, so do not trust it to reverse a
multi-file workspace edit; review Git diff and use `:TutorArenaReset!` here.

Open document symbols and Aerial. In Trouble/Aerial:

- `<CR>` jumps; `q` closes.
- `<C-s>` / `<C-v>` open in splits.
- `p` previews in Trouble; `?` shows local mappings.

Code actions depend on language and cursor context. A clean file may correctly
offer none. Use `diagnostics.py` in the next mission for richer context.

**Recovery:** a project rename affects multiple files only when the server
finds references. Inspect Git diff before keeping it.

- [ ] Mission clear — I perform semantic refactors and navigate code structure.

### Mission 35 — Diagnostics are a queue, not decoration

Open `:TutorArena lsp`. The file intentionally assigns integers and strings to
the wrong declared types.

#### Loadout

- `[d` / `]d` previous / next diagnostic with a float.
- `[e` / `]e` previous / next error only.
- `<leader>xd` line diagnostic float.
- `<leader>fd` all diagnostics picker; `<leader>fD` buffer diagnostics.
- `<leader>xx` workspace Trouble; `<leader>xX` current buffer.

Fix the file so:

- `player_name` is a string such as `"Nova"`.
- `earned_points` is the integer `250`.
- the final call has matching argument types.

Watch diagnostics disappear. Save and rerun `:LspInfo` if nothing attaches.
`<leader>ud` can hide diagnostics globally; make sure you did not leave them
disabled.

Ruff supplies Python diagnostics and code actions but is intentionally prevented
from competing for hover or formatting. Pyright owns type analysis.

**Gold challenge:** reach zero errors using diagnostic navigation rather than
reading the whole file top to bottom.

- [ ] Mission clear — I can locate, inspect, and clear diagnostics.

### Mission 36 — Formatting and linting, one owner at a time

Open `:TutorArena format`. It contains ugly spacing and unsorted imports.

#### Loadout

- `:Format` or `<leader>cf` format now.
- `:FormatInfo` show enabled state and selected formatter client.
- `:FormatToggle` / `<leader>uf` global save-format toggle.
- `:FormatToggle!` / `<leader>uF` current-buffer toggle.

Save the file or format explicitly. Python runs isort and Black through
none-ls. The centralized selector chooses one formatting client so multiple
LSPs do not race and rewrite the same buffer.

Configured pipeline:

- Lua — StyLua.
- Python — isort, then Black, preferring project `.venv/bin`.
- JS/TS/JSON/YAML/CSS/HTML/Markdown and related formats — Prettier, preferring
  local `node_modules/.bin/prettier`.
- Shell — shfmt; ShellCheck diagnostics.
- Markdown — Prettier plus markdownlint-cli2 diagnostics.
- Supported native LSP formatter — fallback when none-ls has no source.

This Tutor buffer has a local override that disables autoformat so lesson
arenas do not move under your cursor.

**Recall:** linting reports a problem; formatting changes layout. They can come
from the same none-ls client but remain different operations.

- [ ] Mission clear — I inspect and control a single predictable format pipeline.

### Mission 37 — Structure, folds, TODOs, and outlines

Open `:TutorArena python`.

#### Folds

- `zc` close, `zo` open, `za` toggle under cursor.
- `zM` close all, `zR` open all.
- `zj` / `zk` next / previous fold.

Folds are generated from Treesitter expressions and start open. Use `zM`, move
among folded functions, then `zR`.

#### TODO navigation

- `]t` / `[t` next / previous TODO-like comment.
- `<leader>ft` TODO picker; `<leader>xt` TODO Trouble list.
- Useful labels include `TODO`, `FIX`, `HACK`, `WARN`, `PERF`, `NOTE`, `TEST`.

Add a harmless `# TODO: practice only` comment, navigate to it, then remove it.

Aerial (`<leader>co`) gives a persistent structural outline. Trouble symbols
(`<leader>cs`) gives a searchable list. Workspace symbols (`<leader>cS`) asks
the LSP across the project.

- [ ] Mission clear — I fold structure and navigate symbols and TODOs.

### Mission 38 — Run the thing

Open `:TutorArena python` and press `<leader>r`.

The project-aware runner:

- `<leader>r` / `:RunCurrent` save and run current file/project.
- `<leader>R` / `:RunLast` rerun the previous command.
- `:RunStop` stops an active program.
- Output opens in a 15-line terminal; `<Esc><Esc>` returns to Normal mode.
- Only one runner job is active at a time; pressing run while active reveals it.

Expected Python output: `Nova earned 300 XP`.

Supported behavior:

- Python uses project `.venv`, then `venv`, then `python3`.
- C/C++ compiles with warnings and debug symbols into Neovim’s cache.
- JavaScript uses Node; TypeScript needs `tsx` or Deno.
- Shell uses Bash; Go uses `go run`; Rust prefers `cargo run`.
- Lua uses system Lua, so Neovim-specific `vim` globals will not work there.
- Dart uses `dart run`, but a directory with `pubspec.yaml` routes to Flutter.

**Recovery:** if a runtime is missing, the notification names it. Read
`:messages`; install the runtime outside Mason because Mason manages editor
tools, not every language runtime.

- [ ] Mission clear — I run, rerun, read output, and stop project jobs.

### Mission 39 — The LSP triage ritual

When IDE behavior is missing, check evidence in this order:

1. `:set filetype?` — is the buffer recognized?
2. `:LspInfo` — is a client attached, and what root did it choose?
3. `:Mason` — is the external server installed?
4. `:messages` — did startup or attachment report an error?
5. `:checkhealth vim.lsp` — does Neovim see a broader problem?
6. `:FormatInfo` — for formatting, which client is selected?
7. `:verbose map gd` — where did a mapping come from?

LSP roots use `.git` by default, so loose files outside a project may not attach
as expected. The Academy contains `.git` intentionally.

Configured servers:

- Bash `bashls`; C/C++ `clangd`; CSS `cssls`.
- JavaScript/TypeScript `ts_ls` plus ESLint; Tailwind `tailwindcss`.
- Go `gopls`; Rust `rust_analyzer`.
- HTML `html`; JSON `jsonls`; YAML `yamlls`.
- Lua `lua_ls`; Markdown `marksman`.
- Python `pyright` plus Ruff.
- Dart `dartls`, owned by Flutter Tools.

There is no configured Java, SQL, or JavaScript debugger merely because a
Treesitter parser or runner exists.

- [ ] Mission clear — I diagnose missing editor intelligence systematically.

### Boss 05 — Code Doctor

1. `:TutorArena lsp`.
2. Confirm attached clients.
3. Navigate every diagnostic.
4. Fix the two bad assignments.
5. Rename `badge` to `rank_badge` through LSP.
6. Format and save.
7. Run the file and inspect output.
8. Open document symbols and jump to the function.
9. Inspect Git diff, but do not reset yet.

**Gold challenge:** use no raw line-number jumps and leave zero diagnostics.

- [ ] Mission clear — I complete an LSP-to-run coding loop.

## Act VI — Shipping Code

### Mission 40 — Git is three pictures

Think of:

1. `HEAD` — the last commit.
2. Index — what is staged for the next commit.
3. Working tree — current files.

Gitsigns shows working-tree hunks in the sign column. Open
`:TutorArena git`, change the mission title and reward on separate lines.

#### Hunk navigation and inspection

- `]c` / `[c` next / previous hunk.
- `<leader>hp` preview; `<leader>hi` inline preview.
- `<leader>hb` blame this line; `<leader>hB` toggle ongoing line blame.
- `<leader>hd` diff against index; `<leader>hD` against previous commit.
- Visual/operator `ih` is a Git-hunk text object.

#### State-changing hunk actions

- `<leader>hs` stage hunk; Visual version stages selected lines.
- `<leader>hu` undo staged hunk.
- `<leader>hr` reset hunk from index.
- `<leader>hS` stage whole buffer.
- `<leader>hR` reset whole buffer.

Reset discards working changes. Stage records intent in the index. Preview
before either.

- [ ] Mission clear — I understand HEAD, index, working tree, and hunks.

### Mission 41 — Git status, history, Diffview, and Lazygit

#### Snacks Git

- `<leader>gs` status; `<leader>gb` branches.
- `<leader>gl` repository log; `<leader>gL` history for current line.
- `<leader>gS` stash picker.
- `<leader>gB` open file or Visual lines on the remote when one exists.
- `<leader>gg` Lazygit.

#### Diffview

- `<leader>gd` opens working-tree Diffview.
- `<leader>gH` opens current-file history.
- `:DiffviewClose` closes it.
- In its file panel: `j/k`, `<CR>`, `-` or `s` stage/unstage.
- `S` stage all; `U` unstage all; `X` restore; `g?` local guide.
- `<Tab>` / `<S-Tab>` next / previous file.

Diffview owns local mappings such as `<leader>e` and some `<leader>c...` keys
while its buffers are active. Press `g?` rather than assuming a global mapping.

Make two Academy changes, stage only one hunk, inspect status and Diffview, then
undo staging and restore with `:TutorArenaReset!`.

Lazygit is a full terminal UI. Use its `?` for context-sensitive keys and `q`
to move back/quit. Do not push the Academy; it has no remote.

- [ ] Mission clear — I inspect history and stage only intentional changes.

### Mission 42 — Debugger fundamentals

Open `:TutorArena debug`. The result says `False`, but 100 + 75 + 125 should
reach 300. This is a logical bug, so the type checker may be perfectly happy.

#### Loadout

- `<leader>db` toggle breakpoint.
- `F5` or `<leader>dc` launch/continue.
- `F10` / `<leader>do` step over.
- `F11` / `<leader>di` step into.
- `F12` / `<leader>dO` step out.
- `<leader>dt` terminate.

Put a breakpoint on `total -= score`, launch, and step through the loop. Watch
`total`. Repair the operator, terminate, run again, and expect:

`Rival unlocked: True`

DAP UI opens on launch and closes on termination. It shows scopes, stacks,
breakpoints, watches, REPL, console, and virtual values.

Python debugging prefers `.venv`, then `venv`, an active virtual environment,
then system Python 3.

- [ ] Mission clear — I reproduce a logical bug and prove the fix in the debugger.

### Mission 43 — Debugger control and inspection

#### Advanced controls

- `<leader>dB` conditional breakpoint.
- `<leader>dC` run to cursor.
- `<leader>dp` pause.
- `<leader>dl` rerun the last DAP configuration.
- `<leader>dr` toggle REPL.
- `<leader>du` toggle DAP UI.
- `<leader>dw` inspect the value under cursor or Visual selection.

Set a condition such as `score == 125` on the loop line. Launch, inspect
`score`, add `total` to watches in DAP UI, then run to the return line.

DAP UI local basics:

- `<CR>` expand; `e` edit; `d` remove.
- `r` sends a REPL action; `t` toggles.
- `q` or `<Esc>` closes floating elements.

Adapter boundaries:

- Python uses debugpy.
- C/C++ (and compatible compiled targets) use codelldb and ask for an already
  built executable—F5 does not compile it.
- Go uses Delve with project/test choices.
- Flutter integrates its DAP runner.
- JavaScript/TypeScript debugging is not configured.

- [ ] Mission clear — I use conditions, watches, REPL, run-to-cursor, and
  adapter context.

### Mission 44 — The complete Git loop

Inside `:TutorArena git`:

1. Change `First Flight` to `Night Flight`.
2. Change bonus `25` to `50`.
3. Run the file and verify `150 XP`.
4. Preview each hunk.
5. Stage only the title hunk.
6. Open `<leader>gs` and distinguish staged from unstaged.
7. Undo the staged hunk, then restore the project.

At a real project’s terminal, the corresponding explicit commands are:

    git status
    git diff
    git diff --staged
    git add -p
    git commit -m "Describe one coherent change"
    git push

Never commit generated secrets, `.env`, tokens, or private keys. Review
`git diff --staged` immediately before every commit.

- [ ] Mission clear — I run, inspect, selectively stage, and review a change.

### Boss 06 — Find, fix, prove, ship

Use the Academy only:

1. Run `:TutorArenaReset!`, then open `:TutorArena debug`.
2. Find `total -= score` with project grep.
3. Open the file from the picker in a split.
4. Set a breakpoint and demonstrate the wrong value.
5. Fix it using a precise operator/text-object edit.
6. Format, run, and see `True`.
7. Preview and stage the hunk.
8. Inspect Diffview.
9. Undo staging and reset the Academy.

**Gold challenge:** return to the Tutor through buffer history and explain each
state transition aloud: working tree, index, HEAD.

- [ ] Mission clear — I can move from symptom to verified, reviewable fix.

## Act VII — Specialist Wings and Maintenance

### Mission 45 — Flutter flight deck

Use this wing inside a real Flutter project and Dart buffer. Skip it for now if
Flutter is not installed; skipping an optional runtime is not a failed mission.

Mappings under `<leader>F`:

- `Fr` run, `Fd` devices, `Fe` emulators.
- `Fl` hot reload, `FR` hot restart, `Fq` quit.
- `Fo` widget outline, `Ft` logs.
- `Fp` pub get, `FD` DevTools.

Automatic behavior:

- Dart LSP, completion, hints, color previews, closing tags, and widget guides.
- Rename updates imports.
- Saving Dart quietly hot reloads when a session is active.
- Saving `pubspec.yaml` triggers pub get after Flutter Tools loads.
- Debugging uses Flutter’s DAP integration.

Useful commands without mappings include `:FlutterDebug`, `:FlutterAttach`,
`:FlutterInspectWidget`, `:FlutterVisualDebug`, `:FlutterLspRestart`,
`:FlutterReanalyze`, `:FlutterPubUpgrade`, and `:FlutterLogClear`.

**Drill:** choose a device, run, change visible text, save, hot reload, inspect
logs, open outline and DevTools, then quit.

Code actions such as widget refactors are cursor- and server-dependent; invoke
`<leader>ca` and inspect what Dart actually offers.

- [ ] Mission clear — I understand the Flutter run/reload/debug loop, or
  consciously skipped it.

### Mission 46 — Language wings

Choose the wing you work in today.

#### Python

- Pyright types and navigation; Ruff diagnostics/actions.
- isort then Black; debugpy; `.venv` preferred.
- Arena: `python`, `lsp`, `format`, `debug`.

#### Web

- `ts_ls`, ESLint, HTML/CSS, Tailwind, SchemaStore for JSON/YAML.
- Prettier prefers project-local installation.
- Autotag and Colorizer work automatically.
- Runner supports Node and TypeScript through `tsx` or Deno; no JS DAP.
- Arena: `javascript`, `html`, `css`.

#### Systems

- clangd for C/C++; gopls for Go; rust-analyzer for Rust.
- Runner compiles C17/C++20, uses `go run`, and prefers Cargo.
- codelldb needs a built binary; Delve handles Go.

#### Lua / Neovim

- lua_ls plus LazyDev understands the `vim` API.
- StyLua formats.
- The standalone Lua runner cannot execute code that depends on Neovim’s
  `vim` global; use `:lua` or a scratch for that.

#### Shell

- bashls, shfmt, ShellCheck, and Bash runner.
- Arena: `shell`.

Open a matching arena, verify filetype/LSP, format, run if supported, inspect
one symbol, and return.

- [ ] Mission clear — I know which tools own my main language workflow.

### Mission 47 — Optional AI, with a review boundary

This editor configures GitHub Copilot for inline suggestions and CodeCompanion.
GitHub SSH access does not authenticate Copilot.

Setup:

- `:Copilot setup` browser authentication.
- `:Copilot status` verify it.
- A valid Copilot subscription/token is required.

Mappings:

- Insert `<A-l>` accept full inline suggestion.
- `<A-]>` / `<A-[>` next / previous suggestion.
- `<C-]>` dismiss; `<A-\>` request.
- `<A-Right>` accept next word; `<A-C-Right>` accept next line.
- `<leader>aa` action palette.
- `<leader>ac` toggle chat.
- `<leader>ai` inline request.
- Visual `<leader>ap` add selection to chat.

Alt-key delivery depends on the terminal. If a mapping does not arrive, inspect
it with `<leader>fk` and test your terminal.

Inside CodeCompanion chat, common controls include `<CR>` or `<C-s>` send,
`<C-c>` close, `q` stop, `gr` regenerate, `gx` clear, `ga` adapter/model,
`[[` / `]]` messages, and `?` actions. `/file`, `/buffer`, and `/symbols` add
context.

Never send secrets, tokens, private customer data, or code you are not allowed
to share. Treat AI output as an untrusted patch: read it, run tests, inspect
diagnostics, and review Git diff.

- [ ] Mission clear — I can use or decline AI without surrendering review.

### Mission 48 — Maintain Rival without making it fragile

Configuration layout:

    init.lua
    lua/config/options.lua       editor behavior
    lua/config/autocmds.lua      event handlers
    lua/config/keymaps.lua       core mappings
    lua/config/languages.lua     servers, tools, parsers
    lua/config/format.lua        formatter ownership and save hook
    lua/config/runner.lua        project-aware execution
    lua/config/tutor.lua         Rival Academy engine
    lua/config/lazy.lua          plugin bootstrap
    lua/plugins/                feature modules
    lazy-lock.json               reproducible plugin revisions

Routine maintenance:

- `:Lazy` inspect plugins; `:Lazy sync` reconcile install/update/clean.
- Use `:Lazy update` deliberately and review `lazy-lock.json`.
- `:Mason` inspect external editor tools.
- `:MasonToolsUpdate` update the configured formatter/linter tool list.
- `:TSUpdate` update Treesitter parsers.
- `:checkhealth`, `:checkhealth snacks`, `:checkhealth vim.lsp`.
- `:checkhealth codecompanion` if using AI.

Do not run `:MasonToolsClean` casually: the tracked tool list is only the
formatter/linter subset, while LSP and DAP packages are managed elsewhere.

Treesitter is pinned to its `master` branch and Aerial to `nvim-0.11` because
this config targets Neovim 0.11. Revisit both together when moving to 0.12.

Safe config workflow:

1. `<leader>fc` find the file.
2. Make one coherent change.
3. Restart Neovim by default. Source a module only when it is explicitly
   designed to rerun without duplicating commands or event handlers.
4. From a shell, run `nvim --headless -u ~/.config/nvim/init.lua '+qa'`.
5. Review Git diff and commit the lockfile when plugin revisions changed.

- [ ] Mission clear — I can update tools while preserving a reproducible config.

### Mission 49 — Recovery and diagnosis field test

Match symptom to evidence:

| Symptom | First checks |
| --- | --- |
| Keys insert text | `<Esc>`, statusline mode |
| `q` shows recording | Press `q` |
| Search remains bright | Normal `<Esc>` |
| Cannot save | `:messages`, permissions, `:file`, `:pwd` |
| Cannot quit | Save, choose confirm, or intentionally `:q!` |
| Mapping surprises you | `:verbose map {key}`, `<leader>fk` |
| LSP absent | filetype, `:LspInfo`, root, `:Mason`, messages |
| Format absent | `:FormatInfo`, executable, local/global toggle |
| Diagnostics absent | `<leader>ud`, `:LspInfo`, Trouble filter |
| Completion absent | Insert mode, `<C-Space>`, LSP attachment |
| Runner absent | named file, filetype, runtime in `PATH`, messages |
| Debug launch fails | adapter/runtime, correct filetype, configuration |
| Terminal keys type text | `<Esc><Esc>` before Normal mappings |
| Plugin failed | `:Lazy`, `:messages`, `:checkhealth` |
| UI message vanished | `<leader>nh` |
| External file changed | `:checktime` or reopen |

Power queries:

- `:set option?` prints a value; `:verbose set option?` says where it changed.
- `:verbose map gd` explains a Normal mapping.
- `:autocmd` lists event handlers; `:scriptnames` loaded scripts.
- `:messages` is the first crash log.
- Start externally with `nvim --clean` to compare against no config.
- Open a line from shell with `nvim +42 file.py`, not `file.py:42`.

**Drill:** use `:verbose map <leader>cf`, `:set clipboard?`, `:LspInfo`, and
`:FormatInfo` in a real source buffer. Explain each result.

- [ ] Mission clear — I diagnose from observable state instead of random reinstalling.

## Finale — Ship Rival

### Final Boss — Ship Rival

There is no exact recipe on the first pass.

1. Open `:TutorArena final`.
2. Find the TODO through the TODO picker and project search.
3. Navigate to a definition and return through the jump list.
4. Run once: the wrong result includes `Warmup` and excludes `Shipwright`.
5. Prove the qualification decision with a breakpoint and value inspection.
6. Fix it using a repeatable, precise edit.
7. Rename `qualifying_missions` through LSP.
8. Remove the resolved TODO, format, and run. The expected names are
   `Foundry` and `Shipwright`.
9. Inspect diagnostics and document symbols.
10. Review Git hunks and stage only the intended repair.
11. Inspect Diffview.
12. Undo staging and restore the Academy baseline.
13. Return here and run `:TutorStats`.

If stuck, reveal one hint at a time:

1. A qualifying score must be at least the minimum.
2. Break inside the loop and watch `mission.score` beside `minimum`.
3. The comparison direction should be `>=`.

#### Rival oath

> I navigate by intent, edit with grammar, verify with tools, and review before
> I ship.

- [ ] Mission clear — I completed the full editor-to-ship loop.

## Endless mode — Daily circuits

Run `:TutorDaily`. The day of the year selects among circuits unlocked by your
cleared missions. Navigation unlocks immediately; editing, command, workspace,
Git, and debugger circuits appear only after their matching acts. They are
short enough to repeat. Use Academy arenas so the campaign remains clean.

Choose a time box:

- 5 minutes — do numbered steps 1–2.
- 10 minutes — continue through step 4.
- 20 minutes — finish every step and the boss remix when one is shown.

Do not reset a streak for missed days. Skill is built by returning.

### Circuit A — Navigation sprint

1. Open `:TutorArena logs`.
2. Apprentice round: enter Insert, add `practice`, return with `<Esc>`, undo,
   redo, undo, and save. This round is available from day one.
3. After Mission 08, visit every `ERROR` with `/`, `n`, `N`, and `*`.
4. After Mission 09, Flash to each timestamp and return through `<C-o>`.
5. After Mission 21, optionally set a mark on the first error and return.

After Mission 09, boss remix: Flash to `worker`, then `shutdown`, using no
`hjkl` or arrows.

- [ ] Daily clear — Navigation circuit complete.

### Circuit B — Editing grammar

1. Open `:TutorArena data`.
2. Change one status with `ciw`.
3. Delete a CSV field with `dt,` or `df,` and observe the difference.
4. Yank one row, delete another to black hole, then paste the yank.
5. Undo all changes and repeat with fewer keystrokes.

Boss remix: open `:TutorArena python`, change the quotes around `Nova`, toggle a
comment on `pilot.award(...)`, move that line with `<A-j>`, then undo.

- [ ] Daily clear — Editing circuit complete.

### Circuit C — Search and command forge

1. Open `:TutorArena logs`.
2. Print matching error lines with `:g/ERROR/p`.
3. Append a tag with `:g/ERROR/normal! A  REVIEW`.
4. Undo once.
5. Select a bounded range and run a confirming substitution.

Boss remix: open `q:` and rerun a harmless transformed command.

- [ ] Daily clear — Command circuit complete.

### Circuit D — Registers and repetition

1. Open `:TutorArena data`.
2. Build register `a` from two nonadjacent rows.
3. Paste it at the end.
4. Record one CSV transformation into register `q`.
5. Test once, then replay with a count.
6. Inspect both registers and restore the project.

- [ ] Daily clear — Repetition circuit complete.

### Circuit E — Project pilot

1. Open `:TutorArena readme`.
2. Find all Python files without Explorer.
3. Grep `score`, send results to quickfix, navigate them.
4. Open two results in splits.
5. Use Explorer to preview a third file without opening it.
6. Close everything except the useful buffer.

- [ ] Daily clear — Workspace circuit complete.

### Circuit F — IDE and Git

1. Open `:TutorArena lsp`; clear diagnostics.
2. Rename one symbol and format.
3. Run the file.
4. Preview every Git hunk.
5. Stage one, inspect status, undo stage, reset.

- [ ] Daily clear — IDE/Git circuit complete.

### Circuit G — Bug hunt

1. Reset and open `:TutorArena debug`.
2. Predict the result before running.
3. Prove the state in DAP.
4. Repair, format, and run.
5. Inspect Git diff and restore.

Gold remix: finish using only one raw `j` or `k` movement.

- [ ] Daily clear — Full-loop circuit complete.

## The 30-day route

This schedule uses retrieval and spacing. Move slower if a day is fun enough to
repeat.

| Day | Focus | Finish line |
| --- | --- | --- |
| 1 | Prologue | Modes, save, undo feel safe |
| 2 | Missions 04–06 | Counts, words, document movement |
| 3 | Missions 07–09 | Find, search, Flash, jump back |
| 4 | Boss 01 + Circuit A | Navigate by intent |
| 5 | Missions 10–12 | Insert doors and editing grammar |
| 6 | Missions 13–15 | Repair, Visual, paste |
| 7 | Missions 16–18 | Registers, surround, structure |
| 8 | Boss 02 + Circuit B | Repair a manifest |
| 9 | Missions 19–20 | Dot and counts |
| 10 | Missions 21–22 | Marks, history, macros |
| 11 | Missions 23–25 | Substitute, global, history |
| 12 | Boss 03 + Circuit C | Clean real data safely |
| 13 | Missions 26–27 | Editor model and pickers |
| 14 | Missions 28–29 | Explorer, buffers, splits |
| 15 | Missions 30–31 | Lists, terminal, scratch |
| 16 | Boss 04 + Circuit E | Investigate a repository |
| 17 | Missions 32–33 | Completion and LSP navigation |
| 18 | Missions 34–35 | Refactor and diagnostics |
| 19 | Missions 36–37 | Format, folds, symbols |
| 20 | Missions 38–39 | Runner and LSP triage |
| 21 | Boss 05 + Circuit E | Complete a code and workspace loop |
| 22 | Missions 40–41 | Git hunks and views |
| 23 | Missions 42–43 | Debugger |
| 24 | Mission 44 + Boss 06 + Circuit F | Selective shipping |
| 25 | Mission 45 | Flutter wing or review circuit |
| 26 | Mission 46 | Your language wing |
| 27 | Mission 47 | AI boundaries or skip |
| 28 | Missions 48–49 | Maintenance and recovery |
| 29 | Final Boss | Ship Rival |
| 30 | Random daily + Field Manual | Build your own workflow |

After day 30, run a circuit and one weak mission. Review difficult skills after
roughly 1, 3, 7, 14, and 30 days.

## Field Manual — what do I press when?

This is the fast reference. Search inside it with `/phrase`.

### Emergency and modes

| Need | Key or command | Note |
| --- | --- | --- |
| Return toward Normal | `<Esc>` | Repeat if uncertain |
| Leave terminal input | `<Esc><Esc>` | Then Normal mappings work |
| Stop accidental recording | `q` | Recording indicator disappears |
| Undo / redo | `u` / `<C-r>` | Content history |
| Visual undo history | `<leader>fu` | Preview old states |
| Save | `<C-s>` or `:w` | Mapping uses `:update` |
| Quit window | `:q` | Confirms around modified work |
| Save and quit | `:wq` or `ZZ` | `ZZ` is Normal mode |
| Discard and quit | `:q!` or `ZQ` | Deliberately destructive |
| Quit all | `<leader>qq` or `:qa` | Add `!` to discard |
| Clear search highlight | Normal `<Esc>` | Does not clear search history |
| See missed messages | `:messages` | Notification history: `<leader>nh` |
| Open command picker | `<leader>fC` | Search registered commands |
| Open keymap picker | `<leader>fk` | Search descriptions |

Modes: `n` Normal, `i` Insert, `v` character Visual, `V` line Visual,
`<C-v>` block Visual, `R` Replace, `:` command line, terminal input mode.

### Motion

| Key | Action |
| --- | --- |
| `h j k l` | Left, down, up, right |
| `{count}{motion}` | Repeat a motion, such as `7j` |
| `w e b ge` | Next start, end, previous start, previous end |
| `W E B gE` | Whitespace-separated WORD variants |
| `0 ^ $ g_` | Column zero, first nonblank, end, last nonblank |
| `gg G {count}G` | First line, last line, exact line |
| `{ }` | Previous / next paragraph |
| `( )` | Previous / next sentence |
| `f/F{c}` | Find character forward/backward |
| `t/T{c}` | Until character forward/backward |
| `; ,` | Repeat/reverse latest character find |
| `%` | Matching pair/construct |
| `/ ?` | Search forward/backward |
| `n N` | Same/opposite search direction |
| `* #` | Word under cursor forward/backward |
| `s` | Flash jump |
| `S` | Treesitter Flash |
| `<C-d> <C-u>` | Half-page down/up |
| `<C-f> <C-b>` | Full-page down/up |
| `<C-e> <C-y>` | Scroll view down/up one |
| `zz zt zb` | Put cursor line center/top/bottom |
| `M` | Middle visible line |
| `<C-o> <C-i>` | Older/newer jump |
| `g; g,` | Older/newer change position |

`H` and `L` are previous/next buffer in this config, not screen top/bottom.

### Insert and direct edits

| Key | Action |
| --- | --- |
| `i a I A` | Insert before/after, first nonblank/end |
| `o O` | New line below/above |
| `gi` | Return to latest Insert position |
| `x X` | Delete under/before cursor |
| `r{c}` | Replace one character |
| `R` | Overwrite mode |
| `J gJ` | Join with/without inserted spacing |
| `~` | Toggle case |
| `gu{motion}` / `gU{motion}` | Lowercase / uppercase |
| `>> << ==` | Indent, unindent, reindent line |
| `<A-j> <A-k>` | Move line/selection down/up |

Normal `s` and `S` are Flash mappings; use `cl` and `cc` for native substitute
character/line behavior.

### Operators and grammar

| Operator | Meaning | Line form | To line end |
| --- | --- | --- | --- |
| `d` | Delete | `dd` | `D` |
| `c` | Change, then Insert | `cc` | `C` |
| `y` | Yank/copy | `yy` or `Y` | `y$` |
| `>` / `<` | Shift indent | `>>` / `<<` | With a motion |
| `=` | Reindent | `==` | With a motion |
| `g~` | Toggle case | `g~~` | With a motion |
| `gu` / `gU` | Lower/upper | `guu` / `gUU` | With a motion |
| `gc` | Toggle comment | `gcc` | With a motion |

Examples: `d3w`, `ci"`, `yap`, `gUiw`, `gc}`, `>af`.

### Text objects

Prefix with an operator or `v`.

| Object | Inner / around |
| --- | --- |
| Word / WORD | `iw aw` / `iW aW` |
| Sentence | `is as` |
| Paragraph | `ip ap` |
| Quotes | `i" a"` / `i' a'` / `` i` a` `` |
| Parentheses | `i( a(` or `ib ab` |
| Braces | `i{ a{` or `iB aB` |
| Brackets | `i[ a[` |
| Angle brackets | `i< a<` |
| Tag | `it at` |
| Treesitter function | `if af` |
| Treesitter class | `ic ac` |
| Treesitter parameter | `ia aa` |
| Git hunk | `ih` in Visual/operator mode |

### Visual mode

| Key | Action |
| --- | --- |
| `v V <C-v>` | Character, line, block |
| `o` | Swap active endpoint |
| `gv` | Reselect previous area |
| `< >` | Indent and keep selection |
| `I text <Esc>` | Block insert at left edge |
| `A text <Esc>` | Block append |
| `P` | Replace selection while preserving paste |
| `<C-Space>` | Grow Treesitter selection |
| `<BS>` | Shrink Treesitter selection |

### Paste and registers

| Key/register | Meaning |
| --- | --- |
| `p P` | Paste after/below or before/above |
| `"` | Unnamed register |
| `0` | Latest yank |
| `1`–`9` | Delete history |
| `a`–`z` | Named register |
| `A`–`Z` | Append to named register |
| `_` | Black hole |
| `+` / `*` | System clipboard selections |
| `%` | Current filename |
| `:` | Latest Ex command |
| `/` | Latest search |
| `.` | Latest inserted text |
| `=` | Expression register |
| `:registers` | Inspect registers |
| `"{reg}{command}` | Use a register, such as `"0p` |
| Insert `<C-r>{reg}` | Insert register contents |

### Repeat, marks, and history

| Key | Action |
| --- | --- |
| `.` | Repeat latest change |
| `@:` | Repeat latest Ex command |
| `&` | Repeat latest substitution on current line |
| `qa ... q` | Record macro in `a` |
| `@a @@ 5@a` | Play, replay, counted play |
| `ma` | Set local mark |
| `mA` | Set global mark |
| `` `a `` / `'a` | Exact / linewise mark jump |
| `` `. `` | Latest change position |
| `` `" `` | Position when file last closed |
| `:marks` / `:jumps` | Inspect navigation memory |
| `q:` / `q/` | Command / search history window |

### Ex commands

| Command | Action |
| --- | --- |
| `:w`, `:update` | Write always / only if modified |
| `:edit file` | Edit in current window |
| `:enew` or `<leader>fn` | New unnamed buffer |
| `:ls`, `:buffer name`, `:bdelete` | List, switch, delete buffer |
| `:split`, `:vsplit`, `:close`, `:only` | Manage windows |
| `:tabnew`, `:tabclose`, `gt`, `gT` | Manage tab pages |
| `:pwd`, `:cd path`, `:lcd path`, `:tcd path` | Working directories |
| `:set option?` | Query an option |
| `:verbose set option?` | Query value and source |
| `:verbose map key` | Explain mapping source |
| `:messages` | Message history |
| `:checktime` | Detect external file changes |
| `:oldfiles` | Recent-file list |
| `:sort`, `:sort u` | Sort, sort unique |
| `:read !command` | Insert shell output below |
| `:%!command` | Filter entire buffer through shell; dangerous |

Ranges: `.` current, `$` last, `%` all, `1,5`, `.,+3`, `'<,'>` Visual.

Substitute: `:[range]s/old/new/gc`.

Global: `:g/pattern/command`; inverse `:v/pattern/command`. Print before delete.

### Files and search

| Key | Action |
| --- | --- |
| `<leader><space>` | Smart file search |
| `<leader>ff` | Files |
| `<leader>fg` | Project grep |
| `<leader>fG` | Grep open buffers |
| `<leader>fb` / `<leader>,` | Buffer picker |
| `<leader>fr` | Recent files |
| `<leader>fc` | Neovim config files |
| `<leader>fh` | Help pages picker |
| `<leader>fk` | Keymaps picker |
| `<leader>fC` | Commands picker |
| `<leader>fu` | Undo picker |
| `<leader>e` | Explorer |
| `<leader>ft` | TODO picker |
| `<leader>fd` / `<leader>fD` | All / buffer diagnostics |

Picker: type, `<C-j/k>`, `<CR>`, `<Esc>`, `<C-s/v/t>`, `<Tab>`, `<C-q>`, `?`.

### Explorer

| Key | Action |
| --- | --- |
| `<CR>` / `l`, `h`, `<BS>` | Open, close, parent |
| `a r d` | Add, rename, delete |
| `c m` | Copy, move |
| `y` then `p` | Copy path selection |
| `H I` | Hidden / ignored files |
| `P u Z` | Preview, refresh, close all |
| `.` / `<C-c>` | Focus dir / change tab cwd |
| `<leader>/` | Grep selected directory |
| `<C-t>` | Terminal in directory |
| `[g ]g` | Git changes |
| `[d ]d`, `[e ]e`, `[w ]w` | Diagnostics, errors, warnings |

### Buffers, windows, UI

| Key | Action |
| --- | --- |
| `H L` or `[b ]b` | Previous / next buffer |
| `<leader>bd` / `<leader>bo` | Delete current / others |
| `<leader>bp` / `<leader>bP` | Pin / delete unpinned |
| `<leader>br` / `<leader>bl` | Delete buffers right / left |
| `<leader>bB` | Pick visible buffer |
| `<leader>-` / `<leader>\|` | Split below / right |
| `<C-h/j/k/l>` | Move Neovim/tmux pane |
| `<C-Arrows>` | Resize split |
| `<leader>z` / `<leader>Z` | Zen / zoom |
| `<leader>.` / `<leader>S` | Scratch / choose scratch |
| `<C-/>` | Toggle terminal |
| `<leader>nh` / `<leader>un` | Notification history / dismiss |
| `<leader>us` / `<leader>uw` | Spell / wrap |
| `<leader>uL` / `<leader>ul` | Relative / absolute line numbers |
| `<leader>ud` / `<leader>uh` | Diagnostics / inlay hints |
| `<leader>ug` / `<leader>uD` | Indent guides / dim |

### Comments, surrounds, Treesitter

| Key | Action |
| --- | --- |
| `gcc`, `gc{motion}` | Comment line/motion |
| `ys{motion}{char}` | Add surround |
| `yss{char}` | Surround line |
| `ds{char}` | Delete surround |
| `cs{old}{new}` | Change surround |
| `<C-Space>`, then again | Start/grow structural selection |
| Visual `<BS>` | Shrink structural selection |
| `]f [f` | Next/previous function |
| `]C [C` | Next/previous class |
| `]a [a` | Next/previous parameter |
| `<leader>cn` / `<leader>cp` | Swap next/previous parameter |
| `zc zo za zM zR` | Close/open/toggle/all folds |
| `[t ]t` | Previous/next TODO |

### Completion and LSP

| Key | Action |
| --- | --- |
| Insert `<C-Space>` | Show completion/docs |
| `<Tab>` / `<S-Tab>` | Select item or snippet field |
| `<CR>` / `<C-e>` | Accept / hide |
| Insert `<C-k>` | Signature help |
| `gd` / `gD` | Definition / declaration |
| `grr` / `gri` | References / implementations |
| `gy` | Type definition |
| `K` | Hover |
| `<leader>ca` / `<leader>cr` | Code action / rename |
| `<leader>cS` | Workspace symbols |
| `<leader>cs` | Document symbols |
| `<leader>co` / `<leader>cO` | Aerial / navigator |
| `<leader>cl` | LSP info |
| `[d ]d` / `[e ]e` | Diagnostics / errors |
| `<leader>xd` | Diagnostic float |
| `<leader>xx` / `<leader>xX` | Workspace / buffer Trouble |
| `<leader>xQ` / `<leader>xL` | Quickfix / location Trouble |

LSP keys are buffer-local and appear only after attachment where appropriate.

### Format and run

| Key or command | Action |
| --- | --- |
| `<leader>cf` / `:Format` | Format now |
| `:FormatInfo` | Selected formatter and state |
| `<leader>uf` / `:FormatToggle` | Global autoformat toggle |
| `<leader>uF` / `:FormatToggle!` | Current-buffer toggle |
| `<leader>r` / `:RunCurrent` | Run current source |
| `<leader>R` / `:RunLast` | Repeat runner command |
| `:RunStop` | Stop active runner |

### Git

| Key | Action |
| --- | --- |
| `[c ]c` | Previous/next hunk |
| `<leader>hp` / `<leader>hi` | Preview / inline preview |
| `<leader>hs` / `<leader>hu` | Stage hunk / undo stage |
| `<leader>hr` | Reset hunk |
| `<leader>hS` / `<leader>hR` | Stage / reset buffer |
| `<leader>hb` / `<leader>hB` | Blame line / toggle blame |
| `<leader>hd` / `<leader>hD` | Diff index / previous commit |
| `<leader>gs` / `<leader>gb` | Status / branches |
| `<leader>gl` / `<leader>gL` | Log / line log |
| `<leader>gS` | Stashes |
| `<leader>gB` | Open remote browser |
| `<leader>gg` | Lazygit |
| `<leader>gd` / `<leader>gH` | Diffview / file history |

### Debugging

| Key | Action |
| --- | --- |
| `F5` / `<leader>dc` | Launch or continue |
| `F10` / `<leader>do` | Step over |
| `F11` / `<leader>di` | Step into |
| `F12` / `<leader>dO` | Step out |
| `<leader>db` / `<leader>dB` | Breakpoint / conditional |
| `<leader>dC` | Run to cursor |
| `<leader>dl` | Run last DAP configuration |
| `<leader>dp` | Pause |
| `<leader>dr` | REPL |
| `<leader>dt` | Terminate |
| `<leader>du` | Debug UI |
| `<leader>dw` | Inspect value |

### Flutter

| Key | Action |
| --- | --- |
| `<leader>Fr` | Run |
| `<leader>Fd` / `<leader>Fe` | Devices / emulators |
| `<leader>Fl` / `<leader>FR` | Reload / restart |
| `<leader>Fq` | Quit |
| `<leader>Fo` / `<leader>Ft` | Outline / logs |
| `<leader>Fp` / `<leader>FD` | Pub get / DevTools |

### Academy

| Command/key | Action |
| --- | --- |
| `:Tutor1`, `<leader>tt` | Resume |
| `:TutorMap`, `<leader>tm` | Campaign map |
| `:TutorStats`, `<leader>tp` | Progress |
| `:TutorCheck`, `<leader>tc` | Clear mission or daily checkpoint |
| `]m` / `[m` | Next / previous mission |
| `:TutorRetry`, `<leader>tr` | Restore current Markdown arena |
| `:TutorDaily`, `<leader>td` | Daily circuit |
| `:TutorArena`, `<leader>ta` | Choose real arena |
| `:TutorArenaReset!` | Reset code project |
| `:Tutor1Reset!` | Reset entire campaign |

## Graduation

You do not graduate by knowing every row in the field manual.

You graduate when:

- a movement expresses where you mean to go;
- an operator and object express what you mean to change;
- undo makes experiments cheap;
- LSP, diagnostics, formatting, runner, Git, and DAP provide evidence;
- and you review the actual diff before calling work finished.

Run `:TutorStats`. If missions remain, the next one is waiting. If all are
clear, run `:TutorDaily` tomorrow and build a faster, calmer version of the
workflow you already own.
