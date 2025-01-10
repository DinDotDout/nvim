return {
    {
        "folke/zen-mode.nvim",
        config = function()
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
