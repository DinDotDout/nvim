return {
    {
        "NeogitOrg/neogit",
        event = "VeryLazy",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
            {
                "sindrets/diffview.nvim",
                config = function()
                    local diffview = require("diffview")
                    diffview.setup()

                    local keymap = vim.keymap.set
                    keymap("n", "<leader>gd", function()
                        if next(require("diffview.lib").views) == nil then
                            vim.cmd("DiffviewOpen")
                        else
                            vim.cmd("DiffviewClose")
                        end
                    end, { desc = "Diffview Toggle" })
                end,
            },
        },
        -- config = true,
        opts = {},
        keys = {
            { "<leader>gg", mode = "n", "<cmd>Neogit<cr>", { desc = "Neogit" } },
        },
    },
    {
        "ThePrimeagen/git-worktree.nvim",
        -- event = "VeryLazy",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            local git_worktree = require("git-worktree")
            git_worktree.setup()
            local telescope = require("telescope")
            telescope.load_extension("git_worktree")

            local keymap = vim.keymap.set
            keymap(
                "n",
                "<leader>gw",
                "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
                { desc = "Git Worktrees" }
            )
            keymap(
                "n",
                "<leader>gc",
                "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
                {
                    desc = "Git Create Worktree",
                }
            )
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufWritePost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
                untracked = { text = "▎" },
            },
            on_attach = function(buffer)
                local gs = package.loaded.gitsigns

                local function map(mode, l, r, desc)
                    vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
                end
                map("n", "<leader>gb", function()
                    gs.blame_line({ full = true })
                end, "Blame Line")
            end,
        },
    },
}
