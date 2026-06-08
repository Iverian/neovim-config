return {
  {
    'mfussenegger/nvim-dap',
    lazy = false,
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        dependencies = { 'nvim-neotest/nvim-nio' },
        opts = {},
      },
      {
        'jay-babu/mason-nvim-dap.nvim',
        deps = { 'mason-org/mason.nvim' },
        opts = {
          automatic_installation = true,
          handlers = {},
          ensure_installed = {
            'debugpy',
            'codelldb',
          },
        },
      },
    },
    opts = {},
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F1>',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
      },
      {
        '<F2>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
      },
      {
        '<F3>',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
      },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = '[B]reakpoint Toggle',
      },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = '[B]reakpoint Set',
      },
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: See last session result.',
      },
    },
  },
  {
    'NicholasMata/nvim-dap-cs',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      local dap_cs = require 'dap-cs'
      local registry = require "mason-registry"
      local package_name = "netcoredbg"

      if registry.is_installed(package_name) then
        local package = registry.get_package(package_name)
        local install_path = package:get_install_path()
        dap_cs.setup({
          netcoredbg = {
            path = install_path .. "/netcoredbg",
          }
        })
      else
        dap_cs.setup {}
      end
    end
  },
}
