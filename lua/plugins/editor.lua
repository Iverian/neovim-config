return {
  -- keybinding on non-english keyboard layout
  {
    'Wansmer/langmapper.nvim',
    lazy = false,
    priority = 1, -- High priority is needed if you will use `autoremap()`
    config = function()
      require('langmapper').setup {}
    end,
  },
  -- when opening neovim from internal terminal use current instance instead of spawning a new one
  {
    "willothy/flatten.nvim",
    opts = {},
    lazy = false,
    priority = 1001,
  },
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons', -- optional, but recommended
    },
    lazy = false,                    -- neo-tree will lazily load itself
    opts = {
      filesystem = {
        window = {
          mappings = {
            ['\\'] = 'close_window',
          },
        },
      },
    },
  },
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('onedark').setup {
        style = 'darker',
      }
      require('onedark').load()
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      theme = 'onedark',
    },
  },
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        theme = 'hyper',
        config = {
          week_header = {
            enable = true,
          },
          packages = {
            enable = false,
          },
          shortcut = {
            { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
          },
          project = {
            enable = true,
            limit = 8,
            icon = '',
            label = '',
          },
          mru = {
            enable = false
          },
          footer = {},
        }
      }
    end,
    dependencies = {
      { 'nvim-tree/nvim-web-devicons' }
    }
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = "ibl",
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      exclude = {
        filetypes = {
          "dashboard",
          "help",
          "lazy",
          "notify",
        },
      },
    },
  },
  {
    'windwp/nvim-autopairs',
    opts = {},
  },
  {
    'romgrk/barbar.nvim',
    opts = {},
    init = function() vim.g.barbar_auto_setup = false end,
    dependencies = {
      'lewis6991/gitsigns.nvim',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'tiagovla/scope.nvim',
    dependencies = {
      'romgrk/barbar.nvim',
    },
    opts = {
      hooks = {
        pre_tab_leave = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabLeavePre' })
        end,
        post_tab_enter = function()
          vim.api.nvim_exec_autocmds('User', { pattern = 'ScopeTabEnterPost' })
        end,
      },
    },
  },
  {
    'rcarriga/nvim-notify',
    config = function()
      local notify = require "notify"
      notify.setup {
        render = "compact",
        merge_duplicates = true,
      }
      vim.notify = notify
    end,
  },
  {
    'numToStr/Comment.nvim',
    opts = {},
  },
  {
    'nvim-telescope/telescope.nvim',
    run = ':TSUpdate',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'desdic/telescope-rooter.nvim',
      'nvim-tree/nvim-web-devicons',
      'tiagovla/scope.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
      },
    },
    config = function()
      local telescope = require 'telescope'

      telescope.setup {
        defaults = {
          file_ignore_patterns = { "%__virtual.cs$" },
        },
      }

      telescope.load_extension "scope"
    end,
  },
  {
    'https://codeberg.org/LukasPietzschmann/telescope-tabs',
    config = function()
      require('telescope').load_extension 'telescope-tabs'
      require('telescope-tabs').setup {}
    end,
    dependencies = { 'nvim-telescope/telescope.nvim' },
  },
  {
    'LintaoAmons/cd-project.nvim',
    lazy = false,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      projects_config_filepath = vim.fs.normalize(vim.fn.stdpath 'config' .. '/cd-project.nvim.json'),
      project_dir_pattern = { '.git', '.gitignore', 'Cargo.toml', 'package.json', 'go.mod', 'pyproject.toml' },
      choice_format = 'both',
      projects_picker = 'telescope',
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "sindrets/diffview.nvim",        -- optional
      "m00qek/baleia.nvim",            -- optional
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = "Neogit",
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {},
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {
      auto_close = true,
      focus = true,
      auto_jump = true,
    }, -- for default options, refer to the configuration section for custom setup.
  },
  {
    'folke/which-key.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons'
    },
    lazy = false,
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
    config = function()
      local wk = require 'which-key'

      wk.setup {
        plugins = {
          marks = true,
          registers = true,
          spelling = {
            enabled = true,
            suggestions = 20,
          },
          presets = {
            operators = true,
            motions = true,
            text_objects = true,
            windows = true,
            nav = true,
            z = true,
            g = true,
          },
        },
      }

      wk.add {
        { 'K',          '<cmd>lua vim.lsp.buf.hover()<cr>',                       desc = 'Hover' },
        { '<D-k>',      '<cmd>lua vim.lsp.buf.signature_help()<cr>',              desc = 'Signature Help' },
        { '<D-.>',      '<cmd>lua require("actions-preview").code_actions()<cr>', desc = '[C]ode Action' },
        { '<D-r>',      '<cmd>lua vim.lsp.buf.rename()<cr>',                      desc = "[R]ename" },
        { '<D-d>',      '<cmd>Telescope lsp_definitions<cr>',                     desc = 'Goto [D]efinitions' },
        { '<leader>s',  '<cmd>Telescope current_buffer_fuzzy_find<cr>',           desc = '[S]earch' },
        { '<leader>h',  '<cmd>Telescope help_tags<cr>',                           desc = '[H]elp' },
        { '<leader>q',  '<cmd>Trouble diagnostics toggle<cr>',                    desc = 'Open [Q]uickfix diagnostics' },
        { '<leader>e',  '<cmd>Neotree reveal toggle position=float<cr>',          desc = '[E]xplorer' },
        { '<leader>g',  '<cmd>Neogit kind=floating<cr>',                          desc = '[G]it UI' },
        { '<leader>ts', '<cmd>Telescope telescope-tabs list_tabs<cr>',            desc = '[T]abs' },
        { '<leader>ts', '<cmd>Telescope telescope-tabs list_tabs<cr>',            desc = '[S]elect' },
        { '<leader>to', '<cmd>tabnew<cr>',                                        desc = '[O]pen' },
        { '<leader>to', '<cmd>tabclose<cr>',                                      desc = '[C]lose' },
        { '<leader>tp', '<cmd>tabnext<cr>',                                       desc = '[N]ext' },
        { '<leader>tp', '<cmd>tabprevious<cr>',                                   desc = '[P]revious' },
        { '<leader>d',  group = '[D]ebug' },
        { '<leader>b',  group = '[B]uffer' },
        { '<leader>bs', '<cmd>Telescope scope buffers<cr>',                       desc = '[S]elect' },
        { '<leader>bt', '<cmd>Telescope telescope-tabs list_tabs<cr>',            desc = '[T]abs' },
        { '<leader>bd', '<cmd>BufferClose<cr>',                                   desc = '[D]elete' },
        { '<leader>bn', '<cmd>bnext<cr>',                                         desc = '[N]ext' },
        { '<leader>bp', '<cmd>bprevious<cr>',                                     desc = '[P]revious' },
        { '<leader>bc', '<cmd>BufferCloseAllButCurrent<cr>',                      desc = '[C]lear' },
        { '<leader>f',  group = '[F]ile' },
        { '<leader>ff', '<cmd>Telescope find_files<cr>',                          desc = '[F]ind' },
        { '<leader>fg', '<cmd>Telescope git_files<cr>',                           desc = '[G]it' },
        { '<leader>ft', '<cmd>Telescope live_grep<cr>',                           desc = '[T]ext' },
        { '<leader>fn', '<cmd>enew<cr>',                                          desc = '[N]ew' },
        { '<leader>fr', '<cmd>Telescope oldfiles<cr>',                            desc = '[R]ecent' },
        { '<leader>l',  group = '[L]SP' },
        { '<leader>lR', '<cmd>lua vim.lsp.buf.rename()<cr>',                      desc = '[R]ename' },
        { '<leader>la', '<cmd>lua require("actions-preview").code_actions()<cr>', desc = '[C]ode Action' },
        { '<leader>ld', '<cmd>Telescope lsp_definitions<cr>',                     desc = '[D]efinitions' },
        { '<leader>lf', '<cmd>lua vim.lsp.buf.format { async = true }<cr>',       desc = '[F]ormat' },
        { '<leader>lh', '<cmd>lua vim.lsp.buf.hover()<cr>',                       desc = '[H]over' },
        { '<leader>lr', '<cmd>Telescope lsp_references<cr>',                      desc = '[R]eferences' },
        { '<leader>ls', '<cmd>Trouble lsp_document_symbols toggle<cr>',           desc = '[S]ymbols' },
        { '<leader>p',  group = '[P]roject' },
        { '<leader>po', '<cmd>CdProject<cr>',                                     desc = '[O]pen' },
        { '<leader>pa', '<cmd>CdProjectSearchAndAdd<cr>',                         desc = '[A]dd' },
      }
    end,
  }
}
