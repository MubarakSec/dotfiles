# Terminal Workflow Guide

Your terminal is powered by **Kitty + tmux + Starship + Bash** with a unified
**Purple Ops** theme. Everything is designed so you _stay at the keyboard_.

If a key has a meaning in tmux, Kitty, and Neovim at the same time (e.g.
`Ctrl+h`), tmux's `is_vim` detection sends it to Neovim when Neovim is focused,
otherwise tmux handles it. This means **navigation flows seamlessly** across
nvim splits and tmux panes.

---

## 1 — tmux: window & pane management

The multiplexer that owns your workspace.

```
Prefix          Ctrl+Space          (Ctrl+b also works)
```

### Windows (tabs)

```
Prefix c        Create window
Prefix ,        Rename window
Prefix &        Kill window
Prefix 0-9      Switch to window N
Prefix s        Choose session / window (tree)
Prefix w        Choose window (tree)
Prefix Tab      Last window
```

### Panes (splits)

```
Prefix |        Split right
Prefix -        Split below
Prefix h/j/k/l  Select pane ←↓↑→
Prefix H/J/K/L  Resize pane (5/3/3/5)
Prefix x        Kill pane
Prefix X        Kill window

Ctrl+h/j/k/l    Navigate across Neovim windows AND tmux panes
                (when Neovim is focused → moves in Neovim;
                 when at edge or not in Neovim → tmux moves)
```

### Quick-launch tools

Keymaps that open tools in dedicated windows:

```
Prefix y        Yazi (file manager)
Prefix g        Lazygit (git TUI)
Prefix m        Btop (system monitor)
Prefix f        Fuzzy open (find + open)
Prefix e        Toggle file explorer (in current pane)
Prefix ?        Open this help overview (glow rendered)
```

### Copy mode

```
Prefix [        Enter copy mode (vi keys)
  v             Begin selection
  y             Yank to Wayland clipboard
```

---

## 2 — Kitty: terminal emulator

The rendering layer. tmux owns the workspace; Kitty stays clean and fast.

### Font size

```
Ctrl+Shift+0    Reset to default (12.5pt — daily work)
Ctrl+Shift+R    Recording mode  (16pt — YouTube / sharing)
Ctrl+Shift+=    Increase 2pt
Ctrl+Shift+-    Decrease 2pt
```

### Visual

```
Background       #0b0812  (very dark purple)
Opacity          94%      (slight transparency — feels dimensional)
Cursor trail     3 frames (visible on video — guides the eye)
Tab bar          Hidden   (tmux owns session management)
Window padding   10px horizontal, 12px vertical
```

### Mouse

- Mouse hides after 2 seconds of inactivity
- URLs are clickable with curly underline
- Middle-click pastes selection

---

## 3 — Starship prompt

The prompt tells you where you are and what's happening.

```
user@host    (only shown on SSH — hidden on local)
purple path  (current directory)
git branch   (bold purple — branch name)
git status   (pink — modified/staged/etc.)

right side:
sudo lock    (shown when sudo is active)
exit code    (pink when last command failed)
duration     (shown for commands > 1.5s)
memory %     (shown when > 85%)
battery %    (shown on laptop)

prompt:
❯ (green — success)   ❯ (pink — error)
```

---

## 4 — Daily tools

These replace the standard Unix utilities with modern alternatives.

```
ls → eza        ls, ll, la, lt (icons + git status + tree)
cat → bat       b (syntax highlighting, line numbers, diffs)
cd → zoxide     z <fragment>  (jump anywhere, learns your habits)
find → fd       (hidden by default, .git excluded)
grep → rg       (smart-case, .gitignore-aware)

fzf             Fuzzy-find everything:
  Ctrl+T        Files under cursor / paste
  Ctrl+R        Shell history
  Alt+C         Directory jump

yazi            Terminal file manager (prefix y)
btop            System monitor (prefix m)
lazygit         Git TUI           (prefix g)
nvim            Editor
```

---

## 5 — Neovim essentials

Your editor is fully configured with lazy.nvim 42+ plugins.

### Leader key

```
Leader = Space
```

### Key groups (shown by which-key on leader press)

```
Space a     AI (CodeCompanion + Copilot)
Space b     Buffers (bufferline, delete, pin)
Space c     Code (LSP actions, rename, format, outline, symbols)
Space d     Debug (nvim-dap)
Space f     Find (Snacks picker — files, grep, buffers, help, etc.)
Space g     Git (lazygit, diffview, gitsigns hunks, branches, log)
Space h     Git hunks (stage, reset, blame, preview, diff)
Space q     Quit / session
Space r     Run current file (runner)
Space t     Rival Academy tutor
Space u     UI toggles (spell, wrap, line nums, diagnostics,
            inlay hints, indent guides, dim, autoformat,
            Arabic keyboard, RTL direction)
Space x     Diagnostics / trouble
Space z     Zen mode / zoom
```

### Formatting

```
:Format           Format current buffer
:FormatToggle     Toggle auto-format on save (global)
:FormatToggle!    Toggle auto-format on save (buffer only)
:FormatInfo       Show current formatter
```

### Arabic text support

```
Space u k     Toggle Arabic keyboard (type Arabic chars)
Space u d     Toggle RTL direction (for pure Arabic paragraphs)
```

Normal text direction (LTR) with `termbidi` handles mixed Arabic/English
correctly — punctuation stays on the right side.

---

## 6 — tmux session persistence

Your session is called `ops` and is visible in the bottom-left corner.
The bottom status bar shows:

```
󰆍 ops    1:bash  2:nvim   3:btop          󰉋 current/path
[SESSION] [--- windows ---]                  [current dir]
```

- `Prefix d` — detach (re-attach with `tmux attach -t ops`)
- `Prefix $` — rename session
- `Prefix s` — browse / switch sessions

---

## 7 — Tips & flow

1. **Open terminal** → Kitty starts tmux automatically (via `kitty-workspace`)
2. **Navigate** with `Ctrl+h/j/k/l` — move through nvim splits and tmux
   panes without thinking
3. **Quick file** → `Prefix f` to fuzzy-open from anywhere
4. **Quick git** → `Prefix g` for lazygit in a new window
5. **Quick edit** → back to nvim, `Space f f` to find files
6. **Format** → `Space c f` or just save (auto-format on)
7. **Debug** → `F5` to start, `F10`/`F11` step, `Space d b` breakpoints
8. **Record** → `Ctrl+Shift+R` for larger font, `Ctrl+Shift+0` to reset
