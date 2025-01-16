return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
            input = { enabled = true },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
        },
    }, {
    "folke/zen-mode.nvim",
    config = function()
        require("zen-mode").setup {
            window = {
                width = 150, -- Adjust the width as needed
            }
        }
        vim.api.nvim_set_keymap(
            "n",
            "<leader>z",
            "<cmd>ZenMode<cr>",
            { noremap = true, silent = true, desc = "center buffer" }
        )
    end,
},
    { -- Shows hex colors
        "norcalli/nvim-colorizer.lua",
        lazy = false,
        opts = { "rasi", "json", "toml", "yaml", "yml", "lua", "css", "conf" },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = {
            indent = {
                char = "│",
                tab_char = "│",
            },
            scope = { enabled = false },
            exclude = {
                filetypes = {
                    "help",
                    "alpha",
                    "dashboard",
                    "neo-tree",
                    "Trouble",
                    "trouble",
                    "lazy",
                    "mason",
                    "notify",
                    "toggleterm",
                    "lazyterm",
                },
            },
        },
        main = "ibl",
    },

    {
        "chrishrb/gx.nvim",
        keys = { { "gx", "<cmd>Browse<cr>", mode = { "n", "x" } } },
        cmd = { "Browse" },
        init = function()
            vim.g.netrw_nogx = 1 -- disable netrw gx
        end,
        dependencies = { "nvim-lua/plenary.nvim" },
        submodules = false,
        config = function()
            require("gx").setup({
                handler_options = {
                    search_engine = "duckduckgo",
                },
            })
        end,
    },
}
