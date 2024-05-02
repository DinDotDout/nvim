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
                    diffview.setup({
                        keymaps = {
                            view = {
                                {
                                    { "n", "v" },
                                    "<leader>e",
                                    "<Cmd>DiffviewToggleFiles<CR>",
                                    { silent = true },
                                },
                            },
                            file_panel = {
                                {
                                    { "n", "v" },
                                    "<leader>e",
                                    "<Cmd>DiffviewToggleFiles<CR>",
                                    { silent = true },
                                },
                            },
                        },
                    })

                    local keymap = vim.keymap.set
                    keymap("n", "<leader>gd", function()
                        if next(require("diffview.lib").views) == nil then
                            vim.cmd("DiffviewOpen")
                        else
                            vim.cmd("DiffviewClose")
                        end
                    end, { desc = "Diffview Toggle" })
                    keymap("n", "<leader>gs", function()
                        require("telescope.builtin").git_branches({
                            attach_mappings = function(_, map)
                                map("i", "<CR>", function(prompt_bufnr)
                                    local selection =
                                        require("telescope.actions.state").get_selected_entry(prompt_bufnr)
                                    require("telescope.actions").close(prompt_bufnr)
                                    vim.cmd("DiffviewOpen " .. selection.value)
                                end)
                                return true
                            end,
                        })
                    end, { desc = "Diffview Branch" })
                    keymap("n", "<leader>gh", function()
                        if next(require("diffview.lib").views) == nil then
                            vim.cmd("DiffviewFileHistory %")
                        else
                            vim.cmd("DiffviewClose")
                        end
                    end, { desc = "DiffviewFileHistory Toggle" })
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
