return {
  {
    "github/copilot.vim",
    cmd = "Copilot",
    init = function()
      vim.g.copilot_no_tab_map = true
    end,
    keys = {
      {
        "<M-l>",
        'copilot#Accept("\\<CR>")',
        mode = "i",
        expr = true,
        replace_keycodes = false,
        desc = "Accept Copilot suggestion",
      },
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionChat", "CodeCompanionCmd" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      strategies = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
      },
      display = {
        chat = { window = { border = "rounded" } },
        action_palette = { provider = "default" },
      },
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", desc = "AI actions", mode = { "n", "x" } },
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI chat" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "AI inline", mode = { "n", "x" } },
      { "<leader>ap", "<cmd>CodeCompanionChat Add<cr>", desc = "Add selection to chat", mode = "x" },
    },
  },
}
