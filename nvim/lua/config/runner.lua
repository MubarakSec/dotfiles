local runner = {
  buf = nil,
  job = nil,
  running = false,
  last = nil,
}

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Run" })
end

local function executable(name)
  local path = vim.fn.exepath(name)
  if path ~= "" then
    return path
  end
  notify(("Could not find '%s' in PATH"):format(name), vim.log.levels.ERROR)
  return nil
end

local function root(file, markers)
  return vim.fs.root(file, markers) or vim.fs.dirname(file)
end

local function python_command(file)
  local cwd = root(file, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" })
  for _, candidate in ipairs({ cwd .. "/.venv/bin/python", cwd .. "/venv/bin/python" }) do
    if vim.fn.executable(candidate) == 1 then
      return { candidate, file }, cwd
    end
  end

  local python = executable("python3")
  return python and { python, file } or nil, cwd
end

local function compiled_command(file, compiler, standard)
  local executable_path = executable(compiler)
  if not executable_path then
    return nil
  end

  local name = vim.fn.fnamemodify(file, ":t:r"):gsub("[^%w_.-]", "_")
  local hash = vim.fn.sha256(file):sub(1, 8)
  local output = vim.fn.stdpath("cache") .. "/nvim-run-" .. name .. "-" .. hash
  local command = table.concat({
    vim.fn.shellescape(executable_path),
    "-std=" .. standard,
    "-Wall",
    "-Wextra",
    "-g",
    vim.fn.shellescape(file),
    "-o",
    vim.fn.shellescape(output),
    "&&",
    vim.fn.shellescape(output),
  }, " ")

  return { "sh", "-c", command }, vim.fs.dirname(file)
end

local function typescript_command(file)
  local runtime = vim.fn.exepath("tsx")
  if runtime ~= "" then
    return { runtime, file }, root(file, { "package.json", "tsconfig.json", ".git" })
  end
  runtime = vim.fn.exepath("deno")
  if runtime ~= "" then
    return { runtime, "run", file }, root(file, { "deno.json", "deno.jsonc", ".git" })
  end
  notify("TypeScript execution needs 'tsx' or 'deno'", vim.log.levels.WARN)
end

local builders = {
  python = python_command,
  c = function(file)
    return compiled_command(file, "gcc", "c17")
  end,
  cpp = function(file)
    return compiled_command(file, "g++", "c++20")
  end,
  javascript = function(file)
    local node = executable("node")
    return node and { node, file } or nil, root(file, { "package.json", ".git" })
  end,
  javascriptreact = function(file)
    local node = executable("node")
    return node and { node, file } or nil, root(file, { "package.json", ".git" })
  end,
  typescript = typescript_command,
  typescriptreact = typescript_command,
  sh = function(file)
    local shell = executable("bash")
    return shell and { shell, file } or nil, vim.fs.dirname(file)
  end,
  go = function(file)
    local go = executable("go")
    return go and { go, "run", file } or nil, root(file, { "go.work", "go.mod", ".git" })
  end,
  rust = function(file)
    local cargo_root = vim.fs.root(file, { "Cargo.toml" })
    if cargo_root then
      local cargo = executable("cargo")
      return cargo and { cargo, "run" } or nil, cargo_root
    end

    local rustc = executable("rustc")
    if not rustc then
      return nil
    end
    local output = vim.fn.stdpath("cache") .. "/nvim-run-" .. vim.fn.fnamemodify(file, ":t:r")
    local command = table.concat({
      vim.fn.shellescape(rustc),
      vim.fn.shellescape(file),
      "-o",
      vim.fn.shellescape(output),
      "&&",
      vim.fn.shellescape(output),
    }, " ")
    return { "sh", "-c", command }, vim.fs.dirname(file)
  end,
  lua = function(file)
    local lua = executable("lua")
    return lua and { lua, file } or nil, vim.fs.dirname(file)
  end,
}

local function show_runner()
  if not (runner.buf and vim.api.nvim_buf_is_valid(runner.buf)) then
    return false
  end

  local windows = vim.fn.win_findbuf(runner.buf)
  if #windows > 0 then
    vim.api.nvim_set_current_win(windows[1])
  else
    vim.cmd("botright 15split")
    vim.api.nvim_win_set_buf(0, runner.buf)
  end

  if runner.running then
    vim.cmd("startinsert")
  end
  return true
end

local function clear_finished_runner()
  if runner.running then
    return
  end
  if runner.buf and vim.api.nvim_buf_is_valid(runner.buf) then
    vim.api.nvim_buf_delete(runner.buf, { force = true })
  end
  runner.buf = nil
  runner.job = nil
end

local function start(command, cwd)
  clear_finished_runner()
  vim.cmd("botright 15new")

  runner.buf = vim.api.nvim_get_current_buf()
  runner.running = true
  runner.last = { command = command, cwd = cwd }
  vim.bo[runner.buf].buflisted = false
  vim.bo[runner.buf].filetype = "runner"

  local job
  job = vim.fn.jobstart(command, {
    term = true,
    cwd = cwd,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if runner.job == job then
          runner.running = false
          runner.job = nil
          local level = exit_code == 0 and vim.log.levels.INFO or vim.log.levels.WARN
          notify("Program exited with code " .. exit_code, level)
        end
      end)
    end,
  })

  if job <= 0 then
    runner.running = false
    notify("Could not start the program", vim.log.levels.ERROR)
    return
  end

  runner.job = job
  vim.cmd("startinsert")
end

local function run_current_buffer()
  if runner.running then
    show_runner()
    notify("A program is already running; use :RunStop before starting another")
    return
  end

  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    notify("Save this file before running it", vim.log.levels.WARN)
    return
  end

  local saved, save_error = pcall(vim.cmd, "silent update")
  if not saved then
    notify("Could not save the file: " .. tostring(save_error), vim.log.levels.ERROR)
    return
  end

  if vim.bo.filetype == "dart" then
    if vim.fs.root(file, { "pubspec.yaml" }) then
      vim.cmd("FlutterRun")
      return
    end
    local dart = executable("dart")
    if dart then
      start({ dart, "run", file }, vim.fs.dirname(file))
    end
    return
  end

  local builder = builders[vim.bo.filetype]
  if not builder then
    notify("No runner for filetype: " .. (vim.bo.filetype ~= "" and vim.bo.filetype or "unknown"), vim.log.levels.WARN)
    return
  end

  local command, cwd = builder(file)
  if command then
    start(command, cwd)
  end
end

local function run_last()
  if runner.running then
    show_runner()
    return
  end
  if not runner.last then
    notify("Nothing has been run yet", vim.log.levels.WARN)
    return
  end
  start(runner.last.command, runner.last.cwd)
end

local function stop()
  if not runner.running or not runner.job then
    notify("No program is running")
    return
  end
  vim.fn.jobstop(runner.job)
end

vim.api.nvim_create_user_command("RunCurrent", run_current_buffer, { desc = "Run the current file or project" })
vim.api.nvim_create_user_command("RunLast", run_last, { desc = "Run the previous command" })
vim.api.nvim_create_user_command("RunStop", stop, { desc = "Stop the running program" })

vim.keymap.set("n", "<leader>r", run_current_buffer, { desc = "Run current file or project" })
vim.keymap.set("n", "<leader>R", run_last, { desc = "Run previous command" })
