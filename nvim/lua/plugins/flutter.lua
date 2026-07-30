return {
  {
    "nvim-flutter/flutter-tools.nvim",
    ft = "dart",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
      "saghen/blink.cmp",
    },
    config = function()
      require("flutter-tools").setup({
        ui = { border = "rounded", notification_style = "native" },
        decorations = {
          statusline = { app_version = true, device = true, project_config = true },
        },
        debugger = {
          enabled = true,
          exception_breakpoints = {},
        },
        widget_guides = { enabled = true },
        closing_tags = {
          highlight = "Comment",
          prefix = " // ",
          enabled = true,
        },
        dev_log = {
          enabled = true,
          notify_errors = true,
          open_cmd = "15split",
          focus_on_open = false,
        },
        outline = {
          open_cmd = "30vnew",
          auto_open = false,
        },
        lsp = {
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          color = { enabled = true, background = true, foreground = false, virtual_text = true },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "always",
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        },
      })
    end,
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>", desc = "Flutter emulators" },
      { "<leader>Fl", "<cmd>FlutterReload<cr>", desc = "Flutter hot reload" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>", desc = "Flutter hot restart" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>", desc = "Flutter outline" },
      { "<leader>Ft", "<cmd>FlutterLogToggle<cr>", desc = "Flutter logs" },
      { "<leader>Fp", "<cmd>FlutterPubGet<cr>", desc = "Flutter pub get" },
      { "<leader>FD", "<cmd>FlutterOpenDevTools<cr>", desc = "Flutter DevTools" },
    },
  },
}
