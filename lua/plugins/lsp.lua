return {
  {
    'mason-org/mason-lspconfig.nvim',
    opts = {
      ensure_installed = { 'rust_analyzer', 'pyright', 'lua_ls' },
      automatic_installation = true,
      automatic_enable = true,
    },
    dependencies = {
      {
        'mason-org/mason.nvim',
        opts = {
          registries = {
            "github:mason-org/mason-registry",
            "github:Crashdummyy/mason-registry",
          },
        }
      },
      { 'neovim/nvim-lspconfig' },
    },
    init = function()
      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function()
          local mode = vim.api.nvim_get_mode().mode
          if vim.bo.modified == true and mode == 'n' then
            vim.cmd('lua vim.lsp.buf.format { async = true }')
          else
          end
        end
      })

      vim.lsp.config('lua_ls', {
        settings = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              workspace = {
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        },
      })

      vim.lsp.config('*', {
        on_attach = function(client, bufnr)
          if client:supports_method("workspace/diagnostic", bufnr) then
            vim.lsp.buf.workspace_diagnostics({ client_id = client.id })
          end
        end
      })

      vim.lsp.inlay_hint.enable(true);
    end
  },
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    init = function()
      vim.filetype.add({
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      })

      vim.treesitter.language.register('razor', 'razor')
      vim.treesitter.language.register('cs', 'c_sharp')

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'razor' },
        callback = function() vim.treesitter.start() end,
      })
    end,
    config = function()
      local roslyn = require("roslyn")
      roslyn.setup({})

      vim.lsp.config("roslyn", {
        settings = {
          ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
          },
          ["csharp|formatting"] = {
            dotnet_organize_imports_on_format = true,
          },
        },
      })
    end
  },
  {
    'felpafel/inlay-hint.nvim',
    event = 'LspAttach',
    config = function()
      require('inlay-hint').setup({
        virt_text_pos = 'inline',
      })
    end,
  },
}
