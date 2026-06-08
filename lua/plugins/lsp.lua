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
    'Dan7h3x/signup.nvim',
    branch = 'main',
    opts = {},
  },
  {
    'kosayoda/nvim-lightbulb',
    opts = {
      autocmd = { enabled = true },
      sign = {
        enabled = true,
        text = "",
        lens_text = "",
      }
    }
  },
  {
    "aznhe21/actions-preview.nvim",
    opts = {
      telescope = {
        sorting_strategy = "ascending",
        layout_strategy = "vertical",
        layout_config = {
          width = 0.8,
          height = 0.9,
          prompt_position = "top",
          preview_cutoff = 20,
          preview_height = function(_, _, max_lines)
            return max_lines - 15
          end,
        },
      },
    }
  },
  {
    'j-hui/fidget.nvim',
    opts = {
      progress = {
        display = {
          render_limit = 8,
        },
      },
    },
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
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      vim.g.rustaceanvim = {
        capabilities = capabilities,
        tools = {
          autoSetHints = true,
          inlay_hints = {
            show_parameter_hints = true,
            parameter_hints_prefix = "in: ", -- "<- "
            other_hints_prefix = "out: "     -- "=> "
          }
        },
        server = {
          settings = {
            -- rust-analyzer language server configuration
            ['rust-analyzer'] = {
              assist = {
                importEnforceGranularity = true,
                importPrefix = "create"
              },
              cargo = { allFeatures = true },
              checkOnSave = {
                -- default: `cargo check`
                command = "clippy",
                allFeatures = true
              },
              inlayHints = {
                lifetimeElisionHints = {
                  enable = true,
                  useParameterNames = true
                }
              }
            }
          }
        }
      }
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
