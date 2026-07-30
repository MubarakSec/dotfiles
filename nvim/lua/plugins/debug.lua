return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = { "mason-org/mason.nvim" },
        opts = {
          ensure_installed = { "python", "codelldb", "delve" },
          handlers = {},
        },
      },
      { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
      { "theHamsta/nvim-dap-virtual-text", opts = {} },
    },
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug continue",
      },
      {
        "<F10>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug step over",
      },
      {
        "<F11>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug step into",
      },
      {
        "<F12>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug step out",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle breakpoint",
      },
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Run / continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to cursor",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "Step over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "Step out",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run last",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle({ reset = true })
        end,
        desc = "Toggle debug UI",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Debug hover",
        mode = { "n", "x" },
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local icons = require("config.icons").dap

      for name, icon in pairs({
        DapBreakpoint = icons.breakpoint,
        DapBreakpointCondition = icons.breakpoint_condition,
        DapBreakpointRejected = icons.breakpoint_rejected,
        DapLogPoint = icons.log_point,
        DapStopped = icons.stopped,
      }) do
        vim.fn.sign_define(
          name,
          { text = icon, texthl = name, linehl = name == "DapStopped" and "Visual" or "", numhl = "" }
        )
      end

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        controls = {
          icons = {
            pause = "",
            play = "",
            step_into = "󰆹",
            step_over = "󰆷",
            step_out = "󰆸",
            step_back = "",
            run_last = "󰑮",
            terminate = "󰅖",
            disconnect = "󰅛",
          },
        },
      })

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      local function python_path()
        local file = vim.api.nvim_buf_get_name(0)
        local project = file ~= ""
            and vim.fs.root(file, {
              "pyproject.toml",
              "setup.py",
              "setup.cfg",
              "requirements.txt",
              ".git",
            })
          or nil
        project = project or (file ~= "" and vim.fs.dirname(file)) or vim.fn.getcwd()

        for _, path in ipairs({ project .. "/.venv/bin/python", project .. "/venv/bin/python" }) do
          if vim.fn.executable(path) == 1 then
            return path
          end
        end
        if vim.env.VIRTUAL_ENV and vim.fn.executable(vim.env.VIRTUAL_ENV .. "/bin/python") == 1 then
          return vim.env.VIRTUAL_ENV .. "/bin/python"
        end
        return vim.fn.exepath("python3")
      end

      for _, configuration in ipairs(dap.configurations.python or {}) do
        configuration.pythonPath = python_path
      end
    end,
  },
}
