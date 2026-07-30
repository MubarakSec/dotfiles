local M = {}

vim.g.autoformat = true

local function enabled(bufnr)
  if vim.b[bufnr].autoformat ~= nil then
    return vim.b[bufnr].autoformat
  end
  return vim.g.autoformat ~= false
end

function M.format(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()

  if not opts.force and not enabled(bufnr) then
    return
  end

  local ok = pcall(require("conform").format, {
    bufnr = bufnr,
    async = opts.async == true,
    timeout_ms = opts.timeout_ms or 3000,
    lsp_fallback = true,
  })
  if not ok and opts.notify then
    vim.notify("No formatter is available for this buffer", vim.log.levels.WARN, { title = "Format" })
  end
end

function M.toggle(bufnr)
  if bufnr then
    local value = not enabled(bufnr)
    vim.b[bufnr].autoformat = value
    vim.notify("Format on save " .. (value and "enabled" or "disabled") .. " for this buffer")
    return
  end

  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Format on save " .. (vim.g.autoformat and "enabled" or "disabled") .. " globally")
end

function M.info()
  local bufnr = vim.api.nvim_get_current_buf()
  local scope = vim.b[bufnr].autoformat == nil and "global" or "buffer"
  local state = enabled(bufnr) and "enabled" or "disabled"
  local formatters = require("conform").list_formatters(bufnr)
  local names = vim.tbl_map(function(f)
    return f.name
  end, formatters)
  vim.notify(
    ("Format on save: %s (%s)\nFormatters: %s"):format(state, scope, #names > 0 and table.concat(names, ", ") or "none"),
    nil,
    { title = "Format" }
  )
end

function M.setup()
  vim.api.nvim_create_user_command("Format", function()
    M.format({ force = true, notify = true })
  end, { desc = "Format the current buffer" })

  vim.api.nvim_create_user_command("FormatInfo", M.info, { desc = "Show formatter status" })
  vim.api.nvim_create_user_command("FormatToggle", function(args)
    M.toggle(args.bang and vim.api.nvim_get_current_buf() or nil)
  end, { bang = true, desc = "Toggle format on save (! for buffer)" })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("rival_format_on_save", { clear = true }),
    callback = function(event)
      M.format({ bufnr = event.buf })
    end,
  })
end

return M
