local source_scrollbind = {}

local function toggle_preview()
  local preview = require("render-markdown.core.preview")
  local manager = require("render-markdown.core.manager")
  local current = vim.api.nvim_get_current_buf()
  local source = preview.get(current) or current
  local source_win = vim.fn.bufwinid(source)
  local was_open = preview.buffers[source] ~= nil

  if not was_open and source_win ~= -1 then
    source_scrollbind[source] = vim.wo[source_win].scrollbind
  end

  preview.open(source)

  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(source) then
      source_scrollbind[source] = nil
      return
    end

    source_win = vim.fn.bufwinid(source)
    local preview_buf = preview.buffers[source]
    if preview_buf then
      local preview_win = vim.fn.bufwinid(preview_buf)
      if source_win ~= -1 then
        vim.wo[source_win].scrollbind = true
      end
      if preview_win ~= -1 then
        vim.wo[preview_win].scrollbind = true
      end
    else
      if source_win ~= -1 then
        vim.wo[source_win].scrollbind = source_scrollbind[source] or false
      end
      source_scrollbind[source] = nil
      manager.set_buf(source, false)
    end
  end)
end

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      enabled = false,
      debounce = 80,
      overrides = {
        preview = {
          enabled = true,
          render_modes = true,
        },
      },
    },
    keys = {
      {
        "<leader>mp",
        toggle_preview,
        ft = "markdown",
        desc = "Toggle live Markdown preview",
      },
    },
  },
}
