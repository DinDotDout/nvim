return {
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim", -- required
            "nvim-telescope/telescope.nvim", -- optional
            "sindrets/diffview.nvim", -- optional
            "ibhagwan/fzf-lua", -- optional
        },
        -- config = true,
        opts = {},
        key = {
            { "n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Neogit" } },
        },
    },
    {
        "ThePrimeagen/git-worktree.nvim",

    },
    {
        "lewis6991/gitsigns.nvim",
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
                -- map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
                map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame Line")
                map("n", "<leader>gd", gs.diffthis, "Diff This")
                -- map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
            end,
        }
    },
}
