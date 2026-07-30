return {
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        python = function(bufnr)
          if require("conform").get_formatter_info("ruff_format", bufnr).available then
            return { "ruff_format" }
          end
          return { "isort", "black" }
        end,
        sh = { "shfmt" },
      },
      formatters = {
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
        stylua = { prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" } },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      require("config.format").setup()
    end,
    keys = {
      {
        "<leader>cf",
        function()
          require("config.format").format({ force = true, notify = true })
        end,
        desc = "Format buffer",
      },
      {
        "<leader>uf",
        function()
          require("config.format").toggle()
        end,
        desc = "Toggle autoformat",
      },
      {
        "<leader>uF",
        function()
          require("config.format").toggle(vim.api.nvim_get_current_buf())
        end,
        desc = "Toggle buffer autoformat",
      },
    },
  },
}
