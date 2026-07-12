return {
    {
        "oskarnurm/koda.nvim",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 999, -- make sure to load this before all the other start plugins
        config = function()
            -- require("koda").setup({ transparent = true })
            vim.cmd("colorscheme koda")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd([[colorscheme gruvbox]])
        end,
    },
    -- {
    --     'Everblush/nvim',
    --     name = 'everblush',
    --
    --     lazy = false,
    --     priority = 1000,
    --     config = function()
    --         vim.cmd('colorscheme everblush')
    --     end,
    -- },
    {
        "sainnhe/everforest",
        name = "everforest",
        lazy = false,
        priority = 1000,
        config = function()
            vim.g.everforest_background = "hard"
            vim.g.background = "hard"
            vim.cmd([[colorscheme everforest]])
        end,
    }, -- Lua

    {
        'olivercederborg/poimandres.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            -- require('poimandres').setup {
            -- leave this setup function empty for default config
            -- or refer to the configuration section
            -- for configuration options
            -- }
        end,

        -- optionally set the colorscheme within lazy config
        init = function()
            vim.cmd("colorscheme poimandres")
        end
    },
    -- { 'Everblush/nvim', opts, {}, name = 'everblush' },
    -- {
    --     "folke/tokyonight.nvim",
    --     lazy = false,
    --     priority = 1000,
    --     opts = {},
    -- },
    -- {
    --     "catppuccin/nvim",
    --     lazy = true,
    --     name = "catppuccin",
    --     opts = {
    --         integrations = {
    --             aerial = true,
    --             alpha = true,
    --             cmp = true,
    --             dashboard = true,
    --             flash = true,
    --             gitsigns = true,
    --             headlines = true,
    --             illuminate = true,
    --             indent_blankline = { enabled = true },
    --             leap = true,
    --             lsp_trouble = true,
    --             mason = true,
    --             markdown = true,
    --             mini = true,
    --             native_lsp = {
    --                 enabled = true,
    --                 underlines = {
    --                     errors = { "undercurl" },
    --                     hints = { "undercurl" },
    --                     warnings = { "undercurl" },
    --                     information = { "undercurl" },
    --                 },
    --             },
    --             navic = { enabled = true, custom_bg = "lualine" },
    --             neotest = true,
    --             neotree = true,
    --             noice = true,
    --             notify = true,
    --             semantic_tokens = true,
    --             telescope = true,
    --             treesitter = true,
    --             treesitter_context = true,
    --             which_key = true,
    --         },
    --     },
    -- }
}
