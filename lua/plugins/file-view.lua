return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        opts = {
            view_options = {
                show_hidden = true,
            },
            default_file_explorer = true,
            keymaps = {
                ["<esc>"] = { "actions.close", desc = "Close" },
                ["<leader>e"] = { "actions.close", desc = "Close" },
                ["<leader>oe"] = { "actions.open_external", desc = "Open external program" },
                ["<leader>tt"] = { "actions.toggle_trash", desc = "Toggle trash" },
                ["<M-y>"] = { "actions.yank_entry", desc = "Yank entry" },
                ["q"] = { "actions.close", desc = "" },
                ["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "" },
                ["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "" },
            },
        },
        keys = {
            { "<leader>e", "<cmd>Oil<CR>",   desc = "Open file explorer" },
            { "<leader>E", "<cmd>Oil .<CR>", desc = "Open at cwd" },
        },
        config = function()
            local oil = require("oil")
            local oil_custom_commands = require("plugins.custom.clipboard-oil-commands")
            oil.setup({
                keymaps = {
                    -- ["<esc>"] = { "actions.close", desc = "Close" },
                    ["<leader>e"] = { "actions.close", desc = "Close" },
                    ["<leader>oe"] = { "actions.open_external", desc = "Open external program" },
                    ["<leader>tt"] = { "actions.toggle_trash", desc = "Toggle trash" },
                    ["q"] = { "actions.close", desc = "Close" },
                    ["<C-h>"] = { "<cmd>wincmd h<cr>", desc = "Go to right split" },
                    ["<C-l>"] = { "<cmd>wincmd l<cr>", desc = "Go to left split" },
                    -- ["<M-c>"] = "actions.yank_entry",
                    ["<M-c>"] = {
                        function()                        -- yank and notify
                            local full_path = oil_custom_commands.get_oil_entry_path()
                            vim.fn.setreg("+", full_path) -- write to clippoard
                            vim.notify("Path copied to clipboard: " .. full_path, vim.log.levels.INFO)
                        end,
                        desc = "Yank entry",
                    },
                    ["<leader>yz"] = {
                        function()
                            oil_custom_commands.compress_file_and_copy_to_clipboard()
                        end,
                        desc = "Compress and copy entry to clipboard",
                    },
                    ["<leader>yc"] = {
                        function()
                            oil_custom_commands.copy_selected_files_to_clipoard()
                        end,
                        desc = "Copy entry to clipboard",
                    },
                },
            })
        end,
    },
}
