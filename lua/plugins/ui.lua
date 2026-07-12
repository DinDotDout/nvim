return {
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = { progress = { enabled = false } }, -- leave this to fidget
            views = {
                notify = { merge = true },
                mini = {
                    position = {
                        row = 1, -- Notifications top right
                    },
                },
                -- cmdline_popup = {
                --     position = {
                --         row = 1, -- Top of the screen
                --     },
                -- },
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            -- "rcarriga/nvim-notify", -- too invasive for now
        },
        keys = {
            { "<leader>ue", mode = "n", "<cmd>Noice errors<cr>", { desc = "Noice errors" } },
            { "<leader>uc", mode = "n", "<cmd>Noice dismiss<cr>", { desc = "Noice dismiss notifications" } },
        },
    },
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            -- -@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            local lualine_require = require("lualine_require")
            lualine_require.require = require
            vim.o.laststatus = vim.g.lualine_laststatus

            return {
                options = {
                    theme = "everforest",
                    globalstatus = true,
                    component_separators = "",
                    -- section_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },

                    disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
                },
                sections = {
                    lualine_a = {
                        {
                            "macro-recording",
                            fmt = function()
                                local recording_register = vim.fn.reg_recording()
                                if recording_register == "" then
                                    return ""
                                else
                                    return "Recording @" .. recording_register
                                end
                            end,
                        },
                        "mode",
                    },
                    lualine_b = { "branch" },

                    lualine_c = {
                        "filename",
                        {
                            "diagnostics",
                            symbols = {
                                error = " ",
                                warn = " ",
                                info = " ",
                                hint = "",
                            },
                        },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        {
                            "diff",
                            symbols = {
                                -- added = "+ ",
                                -- modified = "~ ",
                                -- removed = "- ",
                                added = " ",
                                modified = " ",
                                removed = " ",
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed = gitsigns.removed,
                                    }
                                end
                            end,
                        },
                    },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%R")
                        end,
                    },
                },
                extensions = { "neo-tree", "lazy" },
            }
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {},
            preset = "modern",
            spec = {
                {
                    mode = { "n", "v" },
                    { "g", group = "goto" },
                    -- { "]", group = "next" },
                    -- { "[", group = "prev" },
                    { "<leader>c", group = "code" },
                    { "<leader>g", group = "Git/p4v" },
                    { "<leader>t", group = "DAP" },
                    { "<leader>l", group = "lua/latex" },
                    { "<leader>a", group = "AI" },
                    { "<leader>b", group = "buffer" },
                    { "<leader>f", group = "file" },
                    { "<leader>s", group = "search" },
                    { "<leader>u", group = "ui" },
                    { "<leader>w", group = "windows" },
                    { "<leader>x", group = "build" },
                },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            if not vim.tbl_isempty(opts.defaults) then
                wk.register(opts.defaults)
            end
        end,
    },
}
