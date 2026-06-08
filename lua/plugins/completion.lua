return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      'saghen/blink.lib',
      'rafamadriz/friendly-snippets',
    },
    build = function()
      require('blink.cmp').build():wait(60000)
    end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'super-tab' },
      cmdline = { enabled = true },
      completion = { documentation = { auto_show = false } },
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      fuzzy = { implementation = 'rust' },
    },
  }
}
