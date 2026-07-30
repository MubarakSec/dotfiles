local M = {}

local config_dir = vim.fn.stdpath("config")
local state_dir = vim.fn.stdpath("state") .. "/rival-academy"
local template_path = config_dir .. "/TUTOR.md"
local tutor_path = state_dir .. "/TUTOR.md"
local mastery_template_path = config_dir .. "/TUTOR2.md"
local mastery_path = state_dir .. "/TUTOR2.md"
local arena_dir = state_dir .. "/academy"
local intro_seen_path = state_dir .. "/intro-seen"
local mastery_intro_seen_path = state_dir .. "/mastery-intro-seen"

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Rival Academy" })
end

local function read_lines(path)
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    notify("Could not read " .. path, vim.log.levels.ERROR)
    return nil
  end
  return lines
end

local function write_lines(path, lines)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  local ok, error_message = pcall(vim.fn.writefile, lines, path)
  if not ok then
    notify("Could not write " .. path .. ":\n" .. error_message, vim.log.levels.ERROR)
    return false
  end
  return true
end

local function timestamped_backup(name)
  local stem = state_dir .. "/backups/" .. name .. "-" .. os.date("!%Y%m%dT%H%M%SZ")
  local path = stem .. ".md"
  local suffix = 1
  while vim.fn.filereadable(path) == 1 do
    path = ("%s-%d.md"):format(stem, suffix)
    suffix = suffix + 1
  end
  return path
end

local function preserve_checkboxes(pristine, working)
  local checked = {}
  local checked_ids = {}
  for _, line in ipairs(working) do
    local label = line:match("^%- %[[xX]%] (.+)$")
    if label then
      checked[label] = true
      local id = line:match("<!%-%- ([%w:_%-]+) %-%->")
      if id then
        checked_ids[id] = true
      end
    end
  end

  for index, line in ipairs(pristine) do
    local label = line:match("^%- %[ %] (.+)$")
    local id = line:match("<!%-%- ([%w:_%-]+) %-%->")
    if label and (checked[label] or (id and checked_ids[id])) then
      pristine[index] = line:gsub("^%- %[ %]", "- [x]", 1)
    end
  end
  return pristine
end

local function ensure_tutor(force)
  local exists = vim.fn.filereadable(tutor_path) == 1
  if force or not exists then
    local lines = read_lines(template_path)
    return lines ~= nil and write_lines(tutor_path, lines), not exists
  end

  local working = read_lines(tutor_path)
  local pristine = read_lines(template_path)
  if not working or not pristine then
    return false, false
  end
  if working[1] == pristine[1] then
    return true, false
  end

  local bufnr = vim.fn.bufnr(tutor_path)
  if bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified then
    notify(
      "A newer course is available. Save or discard current Tutor edits, then reopen :Tutor1 to migrate.",
      vim.log.levels.WARN
    )
    return true, false
  end

  if not write_lines(tutor_path, preserve_checkboxes(pristine, working)) then
    return false, false
  end
  if bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("silent edit!")
    end)
  end
  notify("Rival Academy updated; cleared checkpoints were preserved.")
  return true, false
end

local function ensure_mastery(force)
  local exists = vim.fn.filereadable(mastery_path) == 1
  if force or not exists then
    local lines = read_lines(mastery_template_path)
    if not lines or not lines[1] or not lines[1]:match("^<!%-%- RIVAL_TUTOR2_VERSION:") then
      notify("Tutor2 master copy has no version marker; refusing an unsafe install.", vim.log.levels.ERROR)
      return false, not exists
    end
    return lines ~= nil and write_lines(mastery_path, lines), not exists
  end

  local working = read_lines(mastery_path)
  local pristine = read_lines(mastery_template_path)
  if not working or not pristine then
    return false, false
  end
  if not pristine[1] or not pristine[1]:match("^<!%-%- RIVAL_TUTOR2_VERSION:") then
    notify("Tutor2 master copy has no version marker; refusing an unsafe migration.", vim.log.levels.ERROR)
    return false, false
  end
  if working[1] == pristine[1] then
    return true, false
  end

  local bufnr = vim.fn.bufnr(mastery_path)
  if bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified then
    notify(
      "A newer Tutor2 is available. Save or discard current edits, then reopen :Tutor2 to migrate.",
      vim.log.levels.WARN
    )
    return true, false
  end

  local backup_path = timestamped_backup("TUTOR2")
  if not write_lines(backup_path, working) then
    return false, false
  end
  if not write_lines(mastery_path, preserve_checkboxes(pristine, working)) then
    return false, false
  end
  if bufnr > 0 and vim.api.nvim_buf_is_loaded(bufnr) then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("silent edit!")
    end)
  end
  notify("Tutor2 upgraded to the Mastery Wing. Previous work was backed up at " .. backup_path)
  return true, false
end

local function tutor_buffer()
  local wanted = vim.fs.normalize(tutor_path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr)) == wanted then
      return bufnr
    end
  end
end

local function mastery_buffer()
  local wanted = vim.fs.normalize(mastery_path)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr)) == wanted then
      return bufnr
    end
  end
end

local function working_lines(bufnr, path)
  if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
    return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  end
  return read_lines(path)
end

local function center_line(line)
  if line and line > 0 then
    pcall(vim.api.nvim_win_set_cursor, 0, { line, 0 })
    vim.cmd("normal! zz")
  end
end

local function mission_jump(direction)
  local flags = direction < 0 and "bW" or "W"
  local line = vim.fn.search([[^### \%(Mission\|Boss\|Final Boss\|Circuit\)]], flags)
  if line == 0 then
    notify(direction < 0 and "You are at the first mission." or "You reached the end of the campaign.")
    return
  end
  center_line(line)
end

local function configure_tutor_buffer(bufnr, course_name)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end

  vim.b[bufnr].autoformat = false
  vim.bo[bufnr].buflisted = true
  vim.bo[bufnr].modifiable = true
  vim.bo[bufnr].textwidth = 0

  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.wo[winid].conceallevel = 0
    vim.wo[winid].spell = false
    vim.wo[winid].wrap = true
  end

  course_name = course_name or "Academy"
  vim.keymap.set("n", "]m", function()
    mission_jump(1)
  end, { buffer = bufnr, desc = "Next " .. course_name .. " mission" })
  vim.keymap.set("n", "[m", function()
    mission_jump(-1)
  end, { buffer = bufnr, desc = "Previous " .. course_name .. " mission" })
end

local function configure_mastery_buffer(bufnr)
  configure_tutor_buffer(bufnr, "Mastery")
  vim.keymap.set("n", "<leader>tm", "<cmd>Tutor2Map<cr>", {
    buffer = bufnr,
    desc = "Mastery section map",
  })
  vim.keymap.set("n", "<leader>tp", "<cmd>Tutor2Stats<cr>", {
    buffer = bufnr,
    desc = "Mastery Wing progress",
  })
  vim.keymap.set("n", "<leader>tc", "<cmd>Tutor2Check<cr>", {
    buffer = bufnr,
    desc = "Clear Mastery checkpoint",
  })
  vim.keymap.set("n", "<leader>td", "<cmd>Tutor2Daily<cr>", {
    buffer = bufnr,
    desc = "Mastery daily circuit",
  })
end

local function is_mission_heading(line)
  return line:match("^### Mission ") or line:match("^### Boss ") or line:match("^### Final Boss ")
end

local function is_trackable_heading(line)
  return is_mission_heading(line) or line:match("^### Circuit ")
end

local function first_uncleared(lines)
  for index, line in ipairs(lines) do
    if line:match("^%- %[ %] Mission clear") then
      for heading = index, 1, -1 do
        if is_mission_heading(lines[heading]) then
          return heading
        end
      end
      return index
    end
  end
end

local function open_tutor(opts)
  opts = opts or {}
  local ready = ensure_tutor(false)
  if not ready then
    return
  end

  vim.cmd.edit(vim.fn.fnameescape(tutor_path))
  configure_tutor_buffer(vim.api.nvim_get_current_buf())

  if opts.line then
    center_line(opts.line)
  elseif opts.resume and vim.fn.filereadable(intro_seen_path) == 1 then
    center_line(first_uncleared(vim.api.nvim_buf_get_lines(0, 0, -1, false)) or 1)
  else
    center_line(1)
    if opts.resume then
      write_lines(intro_seen_path, { "Rival Academy introduction seen" })
    end
  end
end

local function open_mastery(opts)
  opts = opts or {}
  local ready = ensure_mastery(false)
  if not ready then
    return
  end

  local bufnr = mastery_buffer()
  if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
    vim.api.nvim_win_set_buf(0, bufnr)
  else
    vim.cmd.edit(vim.fn.fnameescape(mastery_path))
    bufnr = vim.api.nvim_get_current_buf()
  end
  configure_mastery_buffer(bufnr)

  if opts.line then
    center_line(opts.line)
    if vim.fn.filereadable(mastery_intro_seen_path) == 0 then
      write_lines(mastery_intro_seen_path, { "Mastery Wing introduction seen" })
    end
  elseif opts.resume and vim.fn.filereadable(mastery_intro_seen_path) == 1 then
    center_line(first_uncleared(vim.api.nvim_buf_get_lines(0, 0, -1, false)) or 1)
  else
    center_line(1)
    if opts.resume then
      write_lines(mastery_intro_seen_path, { "Mastery Wing introduction seen" })
    end
  end
end

local ranks = {
  { 1.00, "Rival" },
  { 0.85, "Shipwright" },
  { 0.70, "IDE Pilot" },
  { 0.55, "Refactorer" },
  { 0.40, "Operator" },
  { 0.20, "Navigator" },
  { 0.00, "Apprentice" },
}

local function progress(lines)
  local cleared, total, daily_cleared, daily_total = 0, 0, 0, 0
  for _, line in ipairs(lines) do
    if line:match("^%- %[[ xX]%] Mission clear") then
      total = total + 1
      if line:match("^%- %[[xX]%]") then
        cleared = cleared + 1
      end
    elseif line:match("^%- %[[ xX]%] Daily clear") then
      daily_total = daily_total + 1
      if line:match("^%- %[[xX]%]") then
        daily_cleared = daily_cleared + 1
      end
    end
  end

  local ratio = total == 0 and 0 or cleared / total
  local rank = ranks[#ranks][2]
  for _, entry in ipairs(ranks) do
    if ratio >= entry[1] then
      rank = entry[2]
      break
    end
  end

  return {
    cleared = cleared,
    daily_cleared = daily_cleared,
    daily_total = daily_total,
    total = total,
    ratio = ratio,
    rank = rank,
    xp = cleared * 100 + daily_cleared * 25,
  }
end

local function show_progress()
  if not ensure_tutor(false) then
    return
  end
  local bufnr = tutor_buffer()
  local lines = bufnr and vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    or read_lines(tutor_path)
  if not lines then
    return
  end
  local stats = progress(lines)
  notify(
    ("%s — %d/%d missions, %d%%, %d XP\nDaily badges: %d/%d"):format(
      stats.rank,
      stats.cleared,
      stats.total,
      math.floor(stats.ratio * 100 + 0.5),
      stats.xp,
      stats.daily_cleared,
      stats.daily_total
    )
  )
end

local function show_mastery_progress()
  if not ensure_mastery(false) then
    return
  end
  local bufnr = mastery_buffer()
  local lines = working_lines(bufnr, mastery_path)
  if not lines then
    return
  end
  local stats = progress(lines)
  notify(
    ("Mastery Wing — %s\n%d/%d missions, %d%%, %d XP\nDaily badges: %d/%d"):format(
      stats.rank,
      stats.cleared,
      stats.total,
      math.floor(stats.ratio * 100 + 0.5),
      stats.xp,
      stats.daily_cleared,
      stats.daily_total
    )
  )
end

local function current_section(lines, cursor_line)
  local start_line
  for line = cursor_line, 1, -1 do
    if lines[line]:match("^## ") then
      return nil
    end
    if is_trackable_heading(lines[line]) then
      start_line = line
      break
    end
  end
  if not start_line then
    return nil
  end

  local end_line = #lines
  for line = start_line + 1, #lines do
    if lines[line]:match("^### ") or lines[line]:match("^## ") then
      end_line = line - 1
      break
    end
  end
  return start_line, end_line
end

local function clear_current_mission()
  if vim.fs.normalize(vim.api.nvim_buf_get_name(0)) ~= vim.fs.normalize(tutor_path) then
    open_tutor({ resume = true })
  end
  if vim.fs.normalize(vim.api.nvim_buf_get_name(0)) ~= vim.fs.normalize(tutor_path) then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local start_line, end_line = current_section(lines, vim.api.nvim_win_get_cursor(0)[1])
  if not start_line then
    notify("Put the cursor inside a mission first.", vim.log.levels.WARN)
    return
  end

  for line = start_line, end_line do
    if lines[line]:match("^%- %[[xX]%] %a+ clear") then
      notify("This checkpoint is already clear. Use ]m for the next one.")
      return
    end
    if lines[line]:match("^%- %[ %] %a+ clear") then
      local replacement = lines[line]:gsub("^%- %[ %]", "- [x]", 1)
      vim.api.nvim_buf_set_lines(bufnr, line - 1, line, false, { replacement })
      vim.cmd("silent write")
      center_line(line)
      show_progress()
      return
    end
  end

  notify("This section has no mission checkpoint.", vim.log.levels.WARN)
end

local function clear_mastery_mission()
  if vim.fs.normalize(vim.api.nvim_buf_get_name(0)) ~= vim.fs.normalize(mastery_path) then
    open_mastery({ resume = true })
  end
  if vim.fs.normalize(vim.api.nvim_buf_get_name(0)) ~= vim.fs.normalize(mastery_path) then
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local start_line, end_line = current_section(lines, vim.api.nvim_win_get_cursor(0)[1])
  if not start_line then
    notify("Put the cursor inside a Mastery Wing mission first.", vim.log.levels.WARN)
    return
  end

  for line = start_line, end_line do
    if lines[line]:match("^%- %[[xX]%] %a+ clear") then
      notify("This Mastery checkpoint is already clear. Use ]m for the next one.")
      return
    end
    if lines[line]:match("^%- %[ %] %a+ clear") then
      local replacement = lines[line]:gsub("^%- %[ %]", "- [x]", 1)
      vim.api.nvim_buf_set_lines(bufnr, line - 1, line, false, { replacement })
      vim.cmd("silent write")
      center_line(line)
      show_mastery_progress()
      return
    end
  end

  notify("This section has no Mastery checkpoint.", vim.log.levels.WARN)
end

local function chapter_map()
  if not ensure_tutor(false) then
    return
  end
  local lines = read_lines(tutor_path)
  if not lines then
    return
  end

  local chapters = {}
  for line, text in ipairs(lines) do
    if text:match("^## ") then
      chapters[#chapters + 1] = {
        line = line,
        label = text:gsub("^## ", ""),
      }
    end
  end

  vim.ui.select(chapters, {
    prompt = "Rival Academy campaign map",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice then
      open_tutor({ line = choice.line })
    end
  end)
end

local function mastery_map()
  if not ensure_mastery(false) then
    return
  end
  local lines = working_lines(mastery_buffer(), mastery_path)
  if not lines then
    return
  end

  local chapters = {}
  for line, value in ipairs(lines) do
    if value:match("^## ") then
      chapters[#chapters + 1] = {
        line = line,
        label = value:gsub("^## ", ""),
      }
    end
  end

  vim.ui.select(chapters, {
    prompt = "Mastery Wing section map",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice then
      open_mastery({ line = choice.line })
    end
  end)
end

local function daily_circuit()
  if not ensure_tutor(false) then
    return
  end
  local lines = read_lines(tutor_path)
  if not lines then
    return
  end

  local unlocks = {
    A = 0,
    B = 21,
    C = 29,
    D = 29,
    E = 36,
    F = 47,
    G = 49,
  }
  local stats = progress(lines)
  local circuits = {}
  for line, text in ipairs(lines) do
    local id = text:match("^### Circuit ([A-Z])")
    if id and stats.cleared >= (unlocks[id] or math.huge) then
      circuits[#circuits + 1] = { line = line, label = text:gsub("^### ", "") }
    end
  end
  if #circuits == 0 then
    notify("No daily circuits were found.", vim.log.levels.ERROR)
    return
  end

  local day = tonumber(os.date("%j")) or 1
  local choice = circuits[((day - 1) % #circuits) + 1]
  open_tutor({ line = choice.line })
  notify(("Today's run: %s\n%d circuit%s unlocked"):format(choice.label, #circuits, #circuits == 1 and "" or "s"))
end

local function mastery_daily_circuit()
  if not ensure_mastery(false) then
    return
  end
  local lines = working_lines(mastery_buffer(), mastery_path)
  if not lines then
    return
  end

  local unlocks = {
    A = 0,
    B = 5,
    C = 10,
    D = 15,
    E = 20,
    F = 25,
    G = 32,
  }
  local stats = progress(lines)
  local circuits = {}
  for line, value in ipairs(lines) do
    local id = value:match("^### Circuit ([A-Z])")
    if id and stats.cleared >= (unlocks[id] or math.huge) then
      circuits[#circuits + 1] = { line = line, label = value:gsub("^### ", "") }
    end
  end
  if #circuits == 0 then
    notify("No Mastery circuits were found.", vim.log.levels.ERROR)
    return
  end

  local day = tonumber(os.date("%j")) or 1
  local choice = circuits[((day - 1) % #circuits) + 1]
  open_mastery({ line = choice.line })
  notify(
    ("Today's Mastery run: %s\n%d circuit%s unlocked"):format(choice.label, #circuits, #circuits == 1 and "" or "s")
  )
end

local function find_arena(lines, cursor_line)
  local begin_line, arena_id
  for line = cursor_line, 1, -1 do
    local found = lines[line]:match("^<!%-%- ARENA:([^:]+):BEGIN %-%->$")
    if found then
      begin_line, arena_id = line, found
      break
    end
  end
  if not begin_line then
    return nil
  end

  for line = begin_line + 1, #lines do
    if lines[line] == ("<!-- ARENA:%s:END -->"):format(arena_id) then
      if line >= cursor_line then
        return arena_id, begin_line, line
      end
      return nil
    end
  end
end

local function retry_current_arena()
  if vim.fs.normalize(vim.api.nvim_buf_get_name(0)) ~= vim.fs.normalize(tutor_path) then
    notify("Open :Tutor1 and put the cursor inside a Markdown arena first.", vim.log.levels.WARN)
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local working = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local arena_id, begin_line, end_line = find_arena(working, vim.api.nvim_win_get_cursor(0)[1])
  if not arena_id then
    notify("No retryable arena surrounds the cursor.", vim.log.levels.WARN)
    return
  end

  local pristine = read_lines(template_path)
  if not pristine then
    return
  end

  local template_begin, template_end
  for line, text in ipairs(pristine) do
    if text == ("<!-- ARENA:%s:BEGIN -->"):format(arena_id) then
      template_begin = line
    elseif template_begin and text == ("<!-- ARENA:%s:END -->"):format(arena_id) then
      template_end = line
      break
    end
  end
  if not template_begin or not template_end then
    notify("The master copy has no arena named " .. arena_id, vim.log.levels.ERROR)
    return
  end

  local replacement = {}
  for line = template_begin + 1, template_end - 1 do
    replacement[#replacement + 1] = pristine[line]
  end
  vim.api.nvim_buf_set_lines(bufnr, begin_line, end_line - 1, false, replacement)
  vim.cmd("silent write")
  center_line(begin_line)
  notify("Arena restored. Progress outside this exercise was preserved.")
end

local arena_files = {
  ["README.md"] = [=[# Rival Academy Practice Project

This repository is generated locally by `:TutorArena`. It is safe to edit,
stage, reset, break, and repair. The real Neovim configuration is elsewhere.

Useful files:

- `academy.py` — clean Python navigation and runner practice
- `diagnostics.py` — deliberate type errors for LSP practice
- `formatter.py` — deliberately ugly imports and spacing
- `bug_hunt.py` — a logical bug for debugger practice
- `final_boss.py` — a fresh capstone bug and TODO
- `git_training.py` — make separate edits and stage hunks
- `academy.lua`, `academy.js`, and `script.sh` — other runner/LSP arenas
- `data.txt` and `logs.txt` — substitution, macro, and quickfix arenas
- `web/` — HTML, CSS, JavaScript, tags, and Prettier

Reset every tracked file with `:TutorArenaReset!`.
]=],
  [".gitignore"] = [=[__pycache__/
*.pyc
.venv/
node_modules/
]=],
  ["pyproject.toml"] = [=[[tool.black]
line-length = 88

[tool.isort]
profile = "black"

[tool.ruff]
line-length = 88
]=],
  ["academy.py"] = [=[from dataclasses import dataclass


@dataclass
class Pilot:
    name: str
    score: int = 0

    def award(self, points: int) -> None:
        self.score += points


def total_score(scores: list[int]) -> int:
    return sum(scores)


def mission_report(pilot: Pilot) -> str:
    return f"{pilot.name} earned {pilot.score} XP"


def main() -> None:
    pilot = Pilot("Nova")
    pilot.award(total_score([100, 75, 125]))
    print(mission_report(pilot))


if __name__ == "__main__":
    main()
]=],
  ["diagnostics.py"] = [=[def badge(player: str, points: int) -> str:
    return f"{player}: {points} XP"


player_name: str = 404
earned_points: int = "250"
print(badge(player_name, earned_points))
]=],
  ["formatter.py"] = [=[import sys
import os
from collections import defaultdict


def mission_report( player : str,points:list[int])->str:
 return f"{player}: {sum(points)} XP"


print(mission_report("Nova",[100,75,125]))
]=],
  ["bug_hunt.py"] = [=[def unlocked_rank(scores: list[int], target: int) -> bool:
    total = 0
    for score in scores:
        total -= score
    return total >= target


def main() -> None:
    scores = [100, 75, 125]
    print(f"Rival unlocked: {unlocked_rank(scores, 300)}")


if __name__ == "__main__":
    main()
]=],
  ["final_boss.py"] = [=[from dataclasses import dataclass


@dataclass(frozen=True)
class Mission:
    name: str
    score: int


def qualifying_missions(missions: list[Mission], minimum: int) -> list[Mission]:
    # TODO: verify the qualification rule before launch
    qualified = []
    for mission in missions:
        if mission.score <= minimum:
            qualified.append(mission)
    return qualified


def main() -> None:
    missions = [
        Mission("Warmup", 50),
        Mission("Foundry", 100),
        Mission("Shipwright", 150),
    ]
    qualified = qualifying_missions(missions, 100)
    print([mission.name for mission in qualified])


if __name__ == "__main__":
    main()
]=],
  ["git_training.py"] = [=[MISSION_NAME = "First Flight"


def mission_title(name: str) -> str:
    return f"Mission: {name}"


def reward(base: int, bonus: int) -> int:
    return base + bonus


BASE_REWARD = 100
BONUS_REWARD = 25


print(mission_title(MISSION_NAME))
print(f"Reward: {reward(BASE_REWARD, BONUS_REWARD)} XP")
]=],
  ["academy.lua"] = [=[local Pilot = {}
Pilot.__index = Pilot

function Pilot.new(name)
  return setmetatable({ name = name, score = 0 }, Pilot)
end

function Pilot:award(points)
  self.score = self.score + points
end

local nova = Pilot.new("Nova")
nova:award(300)
print(("%s earned %d XP"):format(nova.name, nova.score))
]=],
  ["academy.js"] = [=[class Pilot {
  constructor(name) {
    this.name = name;
    this.score = 0;
  }

  award(points) {
    this.score += points;
  }
}

const nova = new Pilot("Nova");
nova.award(300);
console.log(`${nova.name} earned ${nova.score} XP`);
]=],
  ["script.sh"] = [=[#!/usr/bin/env bash
set -euo pipefail

player="${1:-Nova}"
printf '%s earned %d XP\n' "$player" 300
]=],
  ["data.txt"] = [=[alpha,queued,100
bravo,failed,075
charlie,queued,125
delta,ready,050
echo,failed,090
foxtrot,queued,110
]=],
  ["logs.txt"] = [=[2026-07-15 INFO  api boot complete
2026-07-15 WARN  cache nearing limit
2026-07-15 ERROR payment timeout
2026-07-15 INFO  retry scheduled
2026-07-15 ERROR worker unavailable
2026-07-15 INFO  shutdown complete
]=],
  ["web/index.html"] = [=[<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Rival Academy</title>
    <link rel="stylesheet" href="style.css" />
  </head>
  <body>
    <main class="card">
      <h1>Rival Academy</h1>
      <button id="award">Award XP</button>
      <output id="score">0 XP</output>
    </main>
    <script src="app.js"></script>
  </body>
</html>
]=],
  ["web/app.js"] = [=[let score = 0;
const output = document.querySelector("#score");

document.querySelector("#award").addEventListener("click", () => {
  score += 25;
  output.textContent = `${score} XP`;
});
]=],
  ["web/style.css"] = [=[:root {
  color-scheme: dark;
  font-family: system-ui, sans-serif;
}

body {
  display: grid;
  min-height: 100vh;
  margin: 0;
  place-items: center;
  background: #11111b;
  color: #cdd6f4;
}

.card {
  padding: 2rem;
  border: 1px solid #45475a;
  border-radius: 1rem;
  background: #1e1e2e;
}
]=],
}

local arena_choices = {
  python = "academy.py",
  lsp = "diagnostics.py",
  format = "formatter.py",
  debug = "bug_hunt.py",
  final = "final_boss.py",
  git = "git_training.py",
  lua = "academy.lua",
  javascript = "academy.js",
  shell = "script.sh",
  data = "data.txt",
  logs = "logs.txt",
  html = "web/index.html",
  css = "web/style.css",
  readme = "README.md",
}

local function run_git(args)
  if not vim.system then
    return nil
  end
  local command = { "git" }
  vim.list_extend(command, args)
  return vim.system(command, { cwd = arena_dir, text = true }):wait(3000)
end

local function ensure_arena()
  vim.fn.mkdir(arena_dir, "p")
  for path, content in pairs(arena_files) do
    local full_path = arena_dir .. "/" .. path
    if vim.fn.filereadable(full_path) == 0 then
      vim.fn.mkdir(vim.fs.dirname(full_path), "p")
      write_lines(full_path, vim.split(content, "\n", { plain = true }))
      if path == "script.sh" then
        vim.fn.setfperm(full_path, "rwxr-xr-x")
      end
    end
  end

  if vim.fn.isdirectory(arena_dir .. "/.git") == 0 and vim.fn.executable("git") == 1 then
    local initialized = run_git({ "init", "--initial-branch=main" })
    if initialized and initialized.code == 0 then
      run_git({ "config", "user.name", "Rival Academy" })
      run_git({ "config", "user.email", "academy@local.invalid" })
      run_git({ "add", "." })
      run_git({ "commit", "-m", "Academy baseline" })
    end
  end

  if vim.fn.isdirectory(arena_dir .. "/.git") == 1 then
    local baseline = run_git({ "rev-parse", "--verify", "refs/rival-academy/baseline" })
    if not baseline or baseline.code ~= 0 then
      local root = run_git({ "rev-list", "--max-parents=0", "HEAD" })
      local commit = root and root.stdout and vim.trim(root.stdout) or ""
      if commit ~= "" then
        run_git({ "update-ref", "refs/rival-academy/baseline", commit })
      end
    end
  end
end

local function open_arena(target)
  ensure_arena()
  local function open_choice(choice)
    if not choice then
      return
    end
    local relative = arena_choices[choice] or choice
    local full_path = arena_dir .. "/" .. relative
    if vim.fn.filereadable(full_path) == 0 then
      notify("Unknown arena: " .. choice, vim.log.levels.ERROR)
      return
    end
    vim.cmd.tabedit(vim.fn.fnameescape(full_path))
    vim.cmd.tcd(vim.fn.fnameescape(arena_dir))
    notify("Academy project: " .. arena_dir)
  end

  if target and target ~= "" then
    open_choice(target)
    return
  end

  local choices = vim.tbl_keys(arena_choices)
  table.sort(choices)
  vim.ui.select(choices, { prompt = "Choose a practice arena" }, open_choice)
end

local function reset_arena(force)
  ensure_arena()
  if not force then
    local answer = vim.fn.confirm(
      "Restore every tracked Academy file to its generated baseline?\n"
        .. "Saved and unsaved changes to tracked files will be discarded.\n"
        .. "Untracked files are kept.",
      "&Restore\n&Cancel",
      2
    )
    if answer ~= 1 then
      return
    end
  end

  local result = run_git({ "reset", "--hard", "refs/rival-academy/baseline" })
  if not result or result.code ~= 0 then
    notify("Arena reset failed. Open :TutorArena readme for its location.", vim.log.levels.ERROR)
    return
  end

  local tracked = {}
  local tracked_result = run_git({ "ls-files" })
  if tracked_result and tracked_result.code == 0 then
    for relative in vim.gsplit(tracked_result.stdout or "", "\n", { plain = true, trimempty = true }) do
      tracked[vim.fs.normalize(arena_dir .. "/" .. relative)] = true
    end
  end

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    local name = vim.fs.normalize(vim.api.nvim_buf_get_name(bufnr))
    if tracked[name] then
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("silent edit!")
      end)
    end
  end
  notify("Academy project restored to its baseline.")
end

local function reset_tutor(force)
  if not force then
    local answer = vim.fn.confirm(
      "Erase every Tutor1 checkbox and edited Markdown arena?\nThe code Academy is not changed.",
      "&Reset\n&Cancel",
      2
    )
    if answer ~= 1 then
      return
    end
  end
  if not ensure_tutor(true) then
    return
  end

  local bufnr = tutor_buffer()
  if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("silent edit!")
    end)
    configure_tutor_buffer(bufnr)
  end
  vim.fn.delete(intro_seen_path)
  if vim.fs.normalize(vim.api.nvim_buf_get_name(0)) == vim.fs.normalize(tutor_path) then
    center_line(1)
    write_lines(intro_seen_path, { "Rival Academy introduction seen" })
  end
  notify("Tutor1 reset to a pristine campaign.")
end

local function reset_mastery(force)
  if not force then
    local answer = vim.fn.confirm(
      "Erase every Tutor2 checkpoint and course edit?\nThe shared code Academy is not changed.",
      "&Reset\n&Cancel",
      2
    )
    if answer ~= 1 then
      return
    end
  end

  local bufnr = mastery_buffer()
  local working = bufnr and vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    or (vim.fn.filereadable(mastery_path) == 1 and read_lines(mastery_path) or nil)
  local backup_path
  if working then
    backup_path = timestamped_backup("TUTOR2-reset")
    if not write_lines(backup_path, working) then
      return
    end
  end

  if not ensure_mastery(true) then
    return
  end
  if bufnr and vim.api.nvim_buf_is_loaded(bufnr) then
    vim.api.nvim_buf_call(bufnr, function()
      vim.cmd("silent edit!")
    end)
    configure_mastery_buffer(bufnr)
  end
  vim.fn.delete(mastery_intro_seen_path)
  if vim.fs.normalize(vim.api.nvim_buf_get_name(0)) == vim.fs.normalize(mastery_path) then
    center_line(1)
    write_lines(mastery_intro_seen_path, { "Mastery Wing introduction seen" })
  end
  notify("Tutor2 reset to a pristine Mastery Wing." .. (backup_path and " Backup: " .. backup_path or ""))
end

local function make_mastery_tutor()
  vim.api.nvim_create_user_command("Tutor2", function()
    open_mastery({ resume = true })
  end, { desc = "Resume Rival Mastery" })
  vim.api.nvim_create_user_command("Tutor2Map", mastery_map, { desc = "Open the Mastery Wing section map" })
  vim.api.nvim_create_user_command("Tutor2Stats", show_mastery_progress, { desc = "Show Mastery Wing progress" })
  vim.api.nvim_create_user_command("Tutor2Daily", mastery_daily_circuit, { desc = "Open today's Mastery circuit" })
  vim.api.nvim_create_user_command("Tutor2Check", clear_mastery_mission, {
    desc = "Mark the current Mastery checkpoint clear",
  })
  vim.api.nvim_create_user_command("Tutor2Reset", function(args)
    reset_mastery(args.bang)
  end, { bang = true, desc = "Reset Rival Mastery progress" })
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile", "BufWinEnter" }, {
  group = vim.api.nvim_create_augroup("rival_academy_buffer", { clear = true }),
  callback = function(event)
    local path = vim.fs.normalize(vim.api.nvim_buf_get_name(event.buf))
    if path == vim.fs.normalize(tutor_path) then
      configure_tutor_buffer(event.buf)
    elseif path == vim.fs.normalize(mastery_path) then
      configure_mastery_buffer(event.buf)
    end
  end,
})

vim.api.nvim_create_user_command("Tutor1", function()
  open_tutor({ resume = true })
end, { desc = "Resume Rival Academy" })
vim.api.nvim_create_user_command("Tutor1Reset", function(args)
  reset_tutor(args.bang)
end, { bang = true, desc = "Reset Rival Academy progress" })
vim.api.nvim_create_user_command("TutorMap", chapter_map, { desc = "Open the Rival Academy campaign map" })
vim.api.nvim_create_user_command("TutorStats", show_progress, { desc = "Show Rival Academy progress" })
vim.api.nvim_create_user_command("TutorDaily", daily_circuit, { desc = "Open today's Rival Academy circuit" })
vim.api.nvim_create_user_command("TutorCheck", clear_current_mission, {
  desc = "Mark the current Academy checkpoint clear",
})
vim.api.nvim_create_user_command("TutorRetry", retry_current_arena, { desc = "Restore the current Markdown arena" })
vim.api.nvim_create_user_command("TutorArena", function(args)
  open_arena(args.args)
end, {
  nargs = "?",
  complete = function()
    local choices = vim.tbl_keys(arena_choices)
    table.sort(choices)
    return choices
  end,
  desc = "Open a real Rival Academy practice file",
})
vim.api.nvim_create_user_command("TutorArenaReset", function(args)
  reset_arena(args.bang)
end, { bang = true, desc = "Reset the Rival Academy practice project" })

make_mastery_tutor()

vim.api.nvim_create_user_command("TutorTerminal", function()
  local path = vim.fn.stdpath("config") .. "/TUTOR_TERMINAL.md"
  if vim.fn.filereadable(path) == 0 then
    vim.notify("TUTOR_TERMINAL.md not found", vim.log.levels.ERROR)
    return
  end
  vim.cmd.tabedit(path)
  vim.bo.filetype = "markdown"
  vim.wo.wrap = true
  vim.wo.spell = false
  vim.bo.bufhidden = "wipe"
  vim.b.autoformat = false
end, { desc = "Open terminal workflow guide" })

vim.keymap.set("n", "<leader>t", "<cmd>Tutor1<cr>", { desc = "Resume Rival Academy" })
vim.keymap.set("n", "<leader>tt", "<cmd>Tutor1<cr>", { desc = "Resume Rival Academy" })
vim.keymap.set("n", "<leader>tm", "<cmd>TutorMap<cr>", { desc = "Academy campaign map" })
vim.keymap.set("n", "<leader>tp", "<cmd>TutorStats<cr>", { desc = "Academy progress" })
vim.keymap.set("n", "<leader>td", "<cmd>TutorDaily<cr>", { desc = "Academy daily circuit" })
vim.keymap.set("n", "<leader>tc", "<cmd>TutorCheck<cr>", { desc = "Clear Academy checkpoint" })
vim.keymap.set("n", "<leader>tr", "<cmd>TutorRetry<cr>", { desc = "Retry current arena" })
vim.keymap.set("n", "<leader>ta", "<cmd>TutorArena<cr>", { desc = "Open code arena" })
vim.keymap.set("n", "<leader>T", "<cmd>Tutor2<cr>", { desc = "Resume Rival Mastery" })
vim.keymap.set("n", "<leader>t1", "<cmd>Tutor1<cr>", { desc = "Resume Rival Academy" })
vim.keymap.set("n", "<leader>t2", "<cmd>Tutor2<cr>", { desc = "Resume Rival Mastery" })
vim.keymap.set("n", "<leader>tM", "<cmd>Tutor2Map<cr>", { desc = "Mastery section map" })
vim.keymap.set("n", "<leader>tP", "<cmd>Tutor2Stats<cr>", { desc = "Mastery Wing progress" })
vim.keymap.set("n", "<leader>tD", "<cmd>Tutor2Daily<cr>", { desc = "Mastery daily circuit" })
vim.keymap.set("n", "<leader>tC", "<cmd>Tutor2Check<cr>", { desc = "Clear Mastery checkpoint" })
vim.keymap.set("n", "<leader>tw", "<cmd>TutorTerminal<cr>", { desc = "Terminal workflow guide" })

M.paths = {
  arena = arena_dir,
  mastery = mastery_path,
  mastery_template = mastery_template_path,
  template = template_path,
  tutor = tutor_path,
}

return M
