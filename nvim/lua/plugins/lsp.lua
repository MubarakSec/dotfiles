local languages = require("config.languages")

return {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = languages.tools,
      auto_update = false,
      run_on_start = true,
      start_delay = 1500,
      debounce_hours = 24,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
      "b0o/SchemaStore.nvim",
    },
    config = function()
      local icons = require("config.icons").diagnostics
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      local configs = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = "Replace" },
              diagnostics = { globals = { "vim" } },
              hint = { enable = true },
              runtime = { version = "LuaJIT" },
              telemetry = { enable = false },
              workspace = { checkThirdParty = false },
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "basic",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ruff = {
          on_attach = function(client)
            client.server_capabilities.hoverProvider = false
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--completion-style=detailed",
            "--header-insertion=never",
          },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              gofumpt = true,
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              semanticTokens = true,
              staticcheck = true,
              usePlaceholders = true,
            },
          },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              check = { command = "clippy" },
              procMacro = { enable = true },
            },
          },
        },
        ts_ls = {
          init_options = {
            hostInfo = "neovim",
            tsserver = {
              -- TypeScript 7 no longer ships the legacy tsserver.js expected
              -- by typescript-language-server 5.x. Prefer each project's
              -- TypeScript and keep a compatible editor-local fallback.
              fallbackPath = vim.fn.stdpath("data") .. "/typescript/node_modules/typescript/lib",
            },
          },
          settings = {
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all",
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
          },
        },
        eslint = {
          settings = { workingDirectories = { mode = "auto" } },
          on_attach = function(client)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
        },
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              schemaStore = { enable = false, url = "" },
              schemas = require("schemastore").yaml.schemas(),
              validate = true,
            },
          },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
            },
          },
        },
      }

      for server, config in pairs(configs) do
        vim.lsp.config(server, config)
      end

      require("mason-lspconfig").setup({
        ensure_installed = languages.servers,
        -- Restrict automatic enabling to our explicit server list. Some Mason
        -- tools (for example StyLua) also expose an LSP entry, but formatting
        -- for those tools is deliberately owned by none-ls below.
        automatic_enable = languages.servers,
      })

      vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        underline = true,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        float = {
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.Error,
            [vim.diagnostic.severity.WARN] = icons.Warn,
            [vim.diagnostic.severity.HINT] = icons.Hint,
            [vim.diagnostic.severity.INFO] = icons.Info,
          },
        },
      })

      local function lsp_map(bufnr, mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("rival_lsp_attach", { clear = true }),
        callback = function(event)
          local bufnr = event.buf
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if not client then
            return
          end

          vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

          lsp_map(bufnr, "n", "gd", function()
            Snacks.picker.lsp_definitions()
          end, "Goto definition")
          lsp_map(bufnr, "n", "gD", function()
            Snacks.picker.lsp_declarations()
          end, "Goto declaration")
          lsp_map(bufnr, "n", "grr", function()
            Snacks.picker.lsp_references()
          end, "References")
          lsp_map(bufnr, "n", "gri", function()
            Snacks.picker.lsp_implementations()
          end, "Goto implementation")
          lsp_map(bufnr, "n", "gy", function()
            Snacks.picker.lsp_type_definitions()
          end, "Goto type definition")
          lsp_map(bufnr, "n", "K", vim.lsp.buf.hover, "Hover documentation")
          lsp_map(bufnr, "i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
          lsp_map(bufnr, { "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          lsp_map(bufnr, "n", "<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          lsp_map(bufnr, "n", "<leader>cf", function()
            require("config.format").format({ force = true, notify = true })
          end, "Format buffer")
          lsp_map(bufnr, "n", "<leader>cS", function()
            Snacks.picker.lsp_workspace_symbols()
          end, "Workspace symbols")
          lsp_map(bufnr, "n", "<leader>cl", "<cmd>LspInfo<cr>", "LSP info")

          if client:supports_method("textDocument/documentHighlight") then
            local highlight_group = vim.api.nvim_create_augroup("rival_lsp_highlight_" .. bufnr, { clear = true })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              group = highlight_group,
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              group = highlight_group,
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("rival_lsp_detach_" .. bufnr, { clear = true }),
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.clear_references()
                pcall(vim.api.nvim_del_augroup_by_id, highlight_group)
              end,
            })
          end
        end,
      })

      vim.keymap.set("n", "[d", function()
        vim.diagnostic.jump({ count = -1, float = true })
      end, { desc = "Previous diagnostic" })
      vim.keymap.set("n", "]d", function()
        vim.diagnostic.jump({ count = 1, float = true })
      end, { desc = "Next diagnostic" })
      vim.keymap.set("n", "[e", function()
        vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, float = true })
      end, { desc = "Previous error" })
      vim.keymap.set("n", "]e", function()
        vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, float = true })
      end, { desc = "Next error" })
      vim.keymap.set("n", "<leader>xd", vim.diagnostic.open_float, { desc = "Line diagnostics" })
      vim.keymap.set("n", "<leader>fd", function()
        Snacks.picker.diagnostics()
      end, { desc = "Find diagnostics" })
      vim.keymap.set("n", "<leader>fD", function()
        Snacks.picker.diagnostics_buffer()
      end, { desc = "Buffer diagnostics" })
    end,
  },
}
