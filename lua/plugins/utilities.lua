return {
    {
        "preservim/vim-pencil",
        keys = { { "<leader>n", "<cmd>TogglePencil<CR>", desc = "Pencil mode" } },
    },

    { -- Centers current buffer
        "shortcuts/no-neck-pain.nvim",
        opts = {
            width = 150,
            buffers = {
                -- colors = {
                -- blend = 0.1,
                -- },
            },
        },
        keys = { { "<leader>z", "<cmd>NoNeckPain<CR>", desc = "Center buffer" } },
    },

    { -- Shows hex colors
        "norcalli/nvim-colorizer.lua",
        lazy = false,
        opts = { "rasi", "json", "toml", "yaml", "yml", "lua", "css", "conf" },
    },

    {
        "echasnovski/mini.indentscope",
        opts = {
            symbol = "│",
            -- symbol = "╎",
            options = { try_as_border = true },
        },
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
}
