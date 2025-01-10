return {
    { "ngemily/vim-vp4",
        lazy = false,
        config = function()
        end,
            -- {
            -- require("vim-vp4").setup()

                -- local keymap = vim.keymap.set
                -- keymap({ "x", "n" }, "<leader>ge", "<cmd>Vp4Edit<CR><esc>", { desc = "Save file" }, opts)
                -- keymap({ "x", "n" }, "<leader>gr", "<cmd>Vp4Revert<CR><esc>", { desc = "Save file" }, opts)
                -- keymap({ "x", "n" }, "<leader>gd", "<cmd>Vp4Diff<CR><esc>", { desc = "Save file" }, opts)

        -- },
        keys = {
            {
                "<leader>gpa",
                "<cmd>Vp4Annotate<cr>",
                mode = { "v", "x" },
                desc = "P4 annotate",
            },
            {
                "<leader>gpd",
                "<cmd>Vp4Diff<cr>",
                mode = { "n" },
                desc = "P4 diff",
            },
            {
                "<leader>ge",
                "<cmd>Vp4Edit<cr>",
                mode = { "n" },
                desc = "P4 edit",
            },
            {
                "<leader>gr",
                "<cmd>Vp4Revert<cr>",
                mode = { "n" },
                desc = "P4 revert",
            },

            {
                "<leader>gd",
                "<cmd>Vp4Diff<cr>",
                mode = { "n" },
                desc = "P4 diff",
            },


        },
    }
}
