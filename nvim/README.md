# Rival Neovim

A cohesive Neovim 0.11 configuration built to feel like a fast IDE without
turning the config into a monolith. It includes a dashboard, sidebar explorer,
fuzzy finding, completion, LSPs, formatting, diagnostics, Git, debugging,
Flutter support, terminals, tutorials, and an optional AI workflow.

The leader and local leader are both `Space`. Press `Space` and pause to let
Which-key show the available groups.

## What is included

- Catppuccin UI with a custom dashboard, Lualine, Bufferline, notifications,
  smooth scrolling, scope guides, and a structural code outline.
- Snacks Explorer for the filesystem tree and Snacks Picker for files, grep,
  buffers, Git, diagnostics, help, commands, keymaps, and undo history.
- Blink completion with LSP, paths, snippets, buffers, signatures, command-line
  completion, and Neovim-Lua development support.
- Native Neovim 0.11 LSP configuration backed by Mason.
- One controlled format-on-save pipeline through none-ls. It never asks two
  LSP clients to format the same buffer.
- Treesitter highlighting, indentation, incremental selection, text objects,
  parameter swapping, structural folds, rainbow delimiters, and smart comments.
- Gitsigns, Diffview, Lazygit, Trouble, Todo Comments, Flash, Surround,
  Autopairs, color previews, tag closing, and tmux-aware window navigation.
- DAP debugging with UI, virtual values, Python/debugpy, C/C++/codelldb, and
  Go/Delve.
- Flutter tools with device selection, hot reload/restart, logs, outline,
  DevTools, closing tags, widget guides, Dart LSP, and debugging.
- A project-aware runner for Python, C, C++, JavaScript, TypeScript, shell, Go,
  Rust, Lua, Dart, and Flutter.

## Requirements

Required for the core experience:

- Neovim 0.11.x
- Git, Node/npm, Python 3, and ripgrep
- A Nerd Font in the terminal
- `fd` or `fdfind` for the explorer

Useful optional runtimes depend on what you edit: GCC/G++, Go, Rust/Cargo,
Lua, Dart/Flutter, `tsx` or Deno, and a working system clipboard provider.

This machine has `fd` and Lazygit installed in `~/.local/bin`. Make sure that
directory remains in `PATH`. Mason owns the editor's language servers,
formatters, linters, and debug adapters under `~/.local/share/nvim/mason`.

On first setup or after copying this config to another machine:

1. Start Neovim and run `:Lazy sync`.
2. Open `:Mason` and confirm the desired tools, or run
   `:MasonToolsUpdate` to install/update the formatter tool list.
3. Open a source file; Mason LSP installs any missing configured server in the
   background.
4. Run `:checkhealth`.

## Essential keys

### Files, search, and buffers

| Key | Action |
| --- | --- |
| `<leader>e` | Toggle filesystem explorer |
| `<leader><space>` | Smart file search |
| `<leader>ff` / `<leader>fg` | Find files / grep project text |
| `<leader>fb` / `<leader>,` | Pick an open buffer |
| `<leader>fr` | Recent files |
| `<leader>fc` | Search this Neovim config |
| `<leader>fh` / `<leader>fk` | Help pages / keymaps |
| `Shift-H` / `Shift-L` | Previous / next buffer |
| `<leader>bd` / `<leader>bo` | Delete buffer / other buffers |
| `<C-h/j/k/l>` | Move between Neovim or tmux panes |

### Code and diagnostics

These mappings appear on buffers with an attached LSP where appropriate.

| Key | Action |
| --- | --- |
| `gd` / `gD` | Definition / declaration |
| `grr` / `gri` | References / implementations |
| `K` | Hover documentation |
| `<leader>ca` / `<leader>cr` | Code action / rename |
| `<leader>cf` | Format now |
| `<leader>cs` / `<leader>cS` | Document / workspace symbols |
| `<leader>co` | Toggle code outline |
| `[d` / `]d` | Previous / next diagnostic |
| `[e` / `]e` | Previous / next error |
| `<leader>xx` / `<leader>xX` | Workspace / buffer Trouble view |
| `<leader>xt` | Todo list |

### Completion and editing

| Key | Action |
| --- | --- |
| `<C-Space>` | Open completion or documentation |
| `Tab` / `Shift-Tab` | Select completion or move through snippet fields |
| `s` / `S` | Flash jump / Treesitter jump |
| `gc` | Comment using Neovim's native operator |
| `<leader>cn` / `<leader>cp` | Swap next / previous parameter |
| `<C-S>` | Save from normal, insert, or visual mode |

### Run, debug, terminal, and Git

| Key | Action |
| --- | --- |
| `<leader>r` / `<leader>R` | Run current file/project / previous command |
| `:RunStop` | Stop the active runner job |
| `<leader>mp` | Toggle live Markdown preview on the right |
| `F5` / `F10` / `F11` / `F12` | Continue / step over / into / out |
| `<leader>db` / `<leader>du` | Breakpoint / debug UI |
| `<leader>dc` / `<leader>dt` | Start or continue / terminate debug session |
| `<C-/>` | Toggle terminal |
| `<leader>gg` | Lazygit |
| `<leader>gs` / `<leader>gd` | Git status picker / Diffview |
| `[c` / `]c` | Previous / next Git hunk |
| `<leader>hp` | Preview Git hunk |

### Flutter and extras

Flutter commands live under `<leader>F`: `Fr` run, `Fl` reload, `FR` restart,
`Fd` devices, `Fe` emulators, `Ft` logs, `Fo` outline, `FD` DevTools, and `Fq`
quit.

Other useful mappings include `<leader>z` for Zen mode, `<leader>.` for a
scratch buffer, `<leader>tt` for Rival Academy, and `<leader>u...` for UI
toggles.

## Rival Academy

`:Tutor1` is a 57-checkpoint interactive Neovim campaign rather than a static
cheat sheet. It starts with modes and movement, builds through Vim's editing
grammar, then teaches this config's Explorer, pickers, completion, LSP,
formatting, runner, Git, debugger, Flutter workflow, optional AI, maintenance,
and recovery. It also includes seven replayable daily circuits, a 30-day route,
and a searchable field manual.

Progress and edited exercises live under Neovim's state directory, so using and
saving the tutor never modifies this repository. Real IDE lessons use a
generated, disposable local Git project with actual Python, Lua, JavaScript,
shell, web, log, and data files.

`:Tutor2` is Rival Mastery, the month-two sequel. Its 36 checkpoints deepen
precision editing, Ex automation, workspace state, Lua configuration craft,
plugin reliability, LSP/DAP investigation, Git, performance, and reproducible
shipping. It adds seven replayable Mastery circuits and reuses the disposable
Academy project for every destructive drill.

| Command or key | Action |
| --- | --- |
| `:Tutor1` / `<leader>tt` | Resume the next uncleared mission |
| `:TutorMap` / `<leader>tm` | Choose an act |
| `:TutorStats` / `<leader>tp` | Show rank, progress, and XP |
| `:TutorCheck` / `<leader>tc` | Mark the current mission or daily clear |
| `:TutorRetry` / `<leader>tr` | Restore only the current Markdown arena |
| `:TutorDaily` / `<leader>td` | Open today's circuit |
| `:TutorArena` / `<leader>ta` | Open a real-file practice arena |
| `:TutorArenaReset!` | Restore the practice project |
| `:Tutor1Reset!` | Reset the whole campaign |
| `:Tutor2` / `<leader>T` | Resume the next Rival Mastery mission |
| `:Tutor2Map` / `<leader>tM` | Choose a Mastery section |
| `:Tutor2Stats` / `<leader>tP` | Show Mastery rank, progress, and XP |
| `:Tutor2Check` / `<leader>tC` | Mark a Mastery mission or circuit clear |
| `:Tutor2Daily` / `<leader>tD` | Open today's Mastery circuit |
| `:Tutor2Reset!` | Back up and reset the Mastery course |

Tutor1 teaches dependable everyday fluency; Tutor2 turns it into project-scale
speed, diagnosis, automation, and recovery. Reading either course is not the
same as practicing it: attempt every challenge, verify the result, and transfer
one technique into a real project that day.

## Languages and tools

Configured LSPs:

- Lua: `lua_ls`
- Python: `pyright` plus Ruff diagnostics/actions
- Rust: `rust_analyzer`
- Go: `gopls`
- C/C++: `clangd`
- JavaScript/TypeScript: `ts_ls` plus ESLint
- Web/data: HTML, CSS, Tailwind CSS, JSON, YAML
- Shell: `bashls`
- Markdown: `marksman`
- Dart/Flutter: Flutter Tools owns `dartls`

Formatting and diagnostics:

- Lua: StyLua
- Python: isort, then Black
- JavaScript, TypeScript, JSON, YAML, CSS, HTML, Markdown, and related formats:
  Prettier, preferring a project's `node_modules/.bin/prettier`
- Shell: shfmt and ShellCheck
- Markdown: markdownlint-cli2

Format-on-save is enabled by default. Use:

- `:Format` or `<leader>cf` to format immediately.
- `:FormatInfo` to see the chosen client and current state.
- `:FormatToggle` or `<leader>uf` to toggle globally.
- `:FormatToggle!` or `<leader>uF` to toggle only the current buffer.

Python formatting and debugging prefer `.venv/bin` or `venv/bin` in the
current file's project. JavaScript projects prefer their local Prettier and
TypeScript. An editor-local TypeScript 5.9 installation is kept as a fallback
because TypeScript 7 removed the legacy server entry point still required by
the current `typescript-language-server`.

## Config layout

```text
init.lua
lua/config/
  options.lua       editor defaults
  autocmds.lua      small, named event handlers
  keymaps.lua       core mappings
  languages.lua     single source of truth for servers, tools, parsers
  format.lua        one formatter selector and save hook
  runner.lua        project-aware execution
  tutor.lua         Rival Academy progress, retry, and practice arenas
  lazy.lua          plugin bootstrap and manager settings
lua/plugins/
  ui.lua            theme, dashboard, explorer, picker, status UI
  editor.lua        editing/navigation utilities
  completion.lua    Blink and Lua development completion
  treesitter.lua    parser and text-object configuration
  lsp.lua            Mason and native LSP configuration
  formatting.lua    none-ls sources
  git.lua           Gitsigns and Diffview
  debug.lua         DAP adapters and UI
  flutter.lua       Dart/Flutter workflow
  codecompanion.lua optional AI workflow
```

Add languages in `lua/config/languages.lua`, then place server-specific
settings in `lua/plugins/lsp.lua`. Add formatter sources only in
`lua/plugins/formatting.lua`; do not add a second format-on-save plugin.

## Maintenance and compatibility

- `:Lazy` manages plugins and the lockfile; use `:Lazy update` deliberately.
- `:Mason` shows installed external tools.
- `:TSUpdate` updates compatible Treesitter parsers.
- `:checkhealth snacks`, `:checkhealth vim.lsp`, and `:checkhealth` are useful
  focused checks.
- The Treesitter `master` branch and Aerial's `nvim-0.11` branch are pinned
  intentionally. Their newest branches target Neovim 0.12. Revisit both pins
  together when upgrading Neovim.

`lazy-lock.json` should be kept with this config so updates remain reproducible.

## Optional AI setup

CodeCompanion is configured to use GitHub Copilot. It remains dormant until an
AI command is used. Run `:Copilot setup` once and complete GitHub's browser
authentication; then use `<leader>ac` for chat, `<leader>ai` for inline work,
and `<leader>aa` for the action palette. Copilot inline suggestions can be
accepted with `Alt-L`; Blink keeps ownership of `Tab`.

AI commands will not work without a valid Copilot subscription/token, but the
rest of the editor is completely independent of it.
