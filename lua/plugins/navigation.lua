return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        event = { "BufRead", "BufNewFile", "BufEnter" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local harpoon = require("harpoon")
            local keymap = vim.keymap
            keymap.set("n", "<leader>m", function()
                harpoon:list():add()
            end, { desc = "Mark File (Harpoon)" })
            keymap.set("n", "<leader>h", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon Quick Menu" })

            keymap.set("n", "<C-1>", function()
                harpoon:list():select(1)
            end, { desc = "Jump to File 1 (Harpoon)" })
            keymap.set("n", "<C-2>", function()
                harpoon:list():select(2)
            end, { desc = "Jump to File 2 (Harpoon)" })
            keymap.set("n", "<C-3>", function()
                harpoon:list():select(3)
            end, { desc = "Jump to File 3 (Harpoon)" })
            keymap.set("n", "<C-4>", function()
                harpoon:list():select(4)
            end, { desc = "Jump to File 4 (Harpoon)" })

            keymap.set("n", "<C-z>", function()
                harpoon:list():select(1)
            end, { desc = "Jump to File 1 (Harpoon)" })
            keymap.set("n", "<C-x>", function()
                harpoon:list():select(2)
            end, { desc = "Jump to File 2 (Harpoon)" })
            keymap.set("n", "<C-c>", function()
                harpoon:list():select(3)
            end, { desc = "Jump to File 3 (Harpoon)" })
            keymap.set("n", "<C-v>", function()
                harpoon:list():select(4)
            end, { desc = "Jump to File 4 (Harpoon)" })
            -- -- Toggle previous & next buffers stored within Harpoon list
            -- vim.keymap.set("n", "<C-P>", function() harpoon:list():prev() end)
            -- vim.keymap.set("n", "<C-N>", function() harpoon:list():next() end)
        end,
    },
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

    -- {
    --     "stevearc/oil.nvim",
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     lazy = false,
    --     opts = {
    --         view_options = {
    --             show_hidden = true,
    --         },
    --         default_file_explorer = true,
    --         keymaps = {
    --             ["<esc>"] = "actions.close",
    --             ["<leader>e"] = "actions.close",
    --             ["q"] = "actions.close",
    --             ["<C-h>"] = "<cmd>wincmd h<cr>",
    --             ["<C-l>"] = "<cmd>wincmd l<cr>",
    --         },
    --     },
    --     keys = {
    --         { "<leader>e", "<cmd>Oil<CR>", desc = "Open file explorer" },
    --         { "<leader>E", "<cmd>Oil .<CR>", desc = "Open at cwd" },
    --     },
    -- },
    -- {
    --     "ibhagwan/fzf-lua",
    --     -- optional for icon support
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    --     config = function()
    --         -- calling `setup` is optional for customization
    --         require("fzf-lua").setup({})
    --     end,
    -- },
    -- {
    --     "nvim-telescope/telescope.nvim",
    --     cmd = "Telescope",
    --     version = false, -- telescope did only one release, so use HEAD for now
    --     dependencies = {
    --         {
    --             "nvim-telescope/telescope-fzf-native.nvim",
    --             build = "make",
    --             enabled = vim.fn.executable("make") == 1,
    --             config = function()
    --                 require("telescope").load_extension("fzf")
    --             end,
    --         },
    --     },
    --     keys = {
    --         -- Always show hidden for now, revise when available for live_grep
    --         { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
    --         {
    --             "<leader><leader>",
    --             "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
    --             desc = "Switch Buffer",
    --         },
    --         { "<leader>sl", "<cmd>Telescope live_grep<cr>", desc = "Grep (root dir)" },
    --         {
    --             "<leader>/",
    --             function()
    --                 local builtin = require("telescope.builtin")
    --                 local str = vim.fn.input("Grep > ")
    --                 if str == "" then
    --                     return
    --                 end
    --                 builtin.grep_string({ search = str })
    --             end,
    --             desc = "Grep (root dir)",
    --         },
    --         { "<leader>.", "<cmd>Telescope find_files<cr>", desc = "Find Files (root dir)" },
    --         -- { "<leader>sg", "<cmd>Telescope git_files<cr>", desc = "Find Git Files (root dir)" },
    --
    --         -- { "<leader>sf", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
    --         -- {
    --         --     "<leader>sg",
    --         --     "<cmd>Telescope live_grep vimgrep_arguments={'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'}<cr>",
    --         --     desc = "Grep (root dir hidden)",
    --         -- },
    --         --
    --         {
    --             "<leader>sw",
    --             "<cmd>Telescope grep_string<cr>",
    --             { word_match = "-w" },
    --             desc = "Word under cursor (root dir)",
    --         },
    --         { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
    --         { "<leader>sR", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
    --         {
    --             "<leader>sn",
    --             function()
    --                 local builtin = require("telescope.builtin")
    --                 builtin.find_files({ cwd = vim.fn.stdpath("config") })
    --             end,
    --             desc = "Nvim dotfiles",
    --         },
    --         -- search
    --         { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
    --         { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
    --
    --         { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
    --         { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
    --         { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
    --         { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Search Todo Comments" },
    --         {
    --             "<leader>fc",
    --             function()
    --                 local builtin = require("telescope.builtin")
    --                 local filetype = vim.fn.input("File Type > ")
    --                 if filetype == "" then
    --                     return
    --                 end
    --                 builtin.find_files({
    --                     prompt_title = "Find " .. filetype .. " Files",
    --                     -- find_command = { "rg", "--files", "--type", filetype },
    --                     find_command = { "rg", "--files", "-g", "*.{" .. filetype .. "}" },
    --                     -- '*.{c,h}'
    --                 })
    --             end,
    --             desc = "Find Files by Type",
    --         },
    --         {
    --             "<leader>sc",
    --             function()
    --                 local builtin = require("telescope.builtin")
    --                 local filetype = vim.fn.input("File Type > ")
    --                 if filetype == "" then
    --                     return
    --                 end
    --                 builtin.live_grep({
    --                     prompt_title = "Grep in " .. filetype .. " Files",
    --                     additional_args = function()
    --                         return { "-g", "*.{" .. filetype .. "}" }
    --                         -- return { "--type", filetype }
    --                     end,
    --                 })
    --             end,
    --             desc = "Grep in Files by Type",
    --         },
    --     },
    --     opts = function()
    --         local actions = require("telescope.actions")
    --         local builtin = require("telescope.builtin")
    --         local find_files_no_ignore = function()
    --             local action_state = require("telescope.actions.state")
    --             local line = action_state.get_current_line()
    --             builtin.find_files({ no_ignore = true, default_text = line })
    --             -- Util.telescope("find_files", { no_ignore = true, default_text = line })()
    --         end
    --         local find_files_with_hidden = function()
    --             local action_state = require("telescope.actions.state")
    --             local line = action_state.get_current_line()
    --             builtin.find_files({ hidden = true, default_text = line })
    --             -- Util.telescope("find_files", { hidden = true, default_text = line })()
    --         end
    --         -- local telescopeConfig = require("telescope.config")
    --         -- local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
    --         -- table.insert(vimgrep_arguments, "--glob")
    --         -- table.insert(vimgrep_arguments, "!**/.git/*")
    --         -- table.insert(vimgrep_arguments, "--ignore-file")
    --         -- table.insert(vimgrep_arguments, ".p4ignore")
    --         -- local find_files_command = { "rg", "--files" }
    --         -- for _, arg in ipairs(vimgrep_arguments) do
    --         --     table.insert(find_files_command, arg)
    --         -- end
    --         -- find_files_command = { "rg", "--files", "--hidden", "--ignore-file", ".p4ignore", "--glob", "!**/.git/*" }
    --
    --         return {
    --             defaults = {
    --                 layout_strategy = "horizontal",
    --                 layout_config = { prompt_position = "bottom" },
    --                 sorting_strategy = "ascending",
    --                 -- vimgrep_arguments = vimgrep_arguments,
    --                 -- pickers = {
    --                 --     find_files = {
    --                 --         find_command = {
    --                 --             "ag",
    --                 --             "--silent",
    --                 --             "--nocolor",
    --                 --             "--follow",
    --                 --             "-g",
    --                 --             "",
    --                 --             "--literal",
    --                 --             "--hidden",
    --                 --             "--ignore",
    --                 --             ".git ",
    --                 --         },
    --                 --     },
    --                 -- },
    --                 -- },
    --
    --                 prompt_prefix = " ",
    --                 selection_caret = " ",
    --                 -- open files in the first window that is an actual file.
    --                 -- use the current window if no other window is available.
    --                 get_selection_window = function()
    --                     local wins = vim.api.nvim_list_wins()
    --                     table.insert(wins, 1, vim.api.nvim_get_current_win())
    --                     for _, win in ipairs(wins) do
    --                         local buf = vim.api.nvim_win_get_buf(win)
    --                         if vim.bo[buf].buftype == "" then
    --                             return win
    --                         end
    --                     end
    --                     return 0
    --                 end,
    --                 mappings = {
    --                     i = {
    --                         ["<c-d>"] = actions.delete_buffer, -- Close buffer from buff list
    --                         ["<a-i>"] = find_files_no_ignore,
    --                         ["<C-Down>"] = actions.cycle_history_next,
    --                         ["<C-Up>"] = actions.cycle_history_prev,
    --                         ["<C-ESC>"] = actions.close,
    --
    --                         ["<C-f>"] = actions.preview_scrolling_down,
    --                         ["<C-b>"] = actions.preview_scrolling_up,
    --                         -- ["<c-k>"] = actions.move_selection_previous,
    --                         -- ["<C-j>"] = actions.move_selection_next,
    --                     },
    --                     n = {
    --                         ["<c-d>"] = actions.delete_buffer, -- Close buffer from buff list
    --                         ["q"] = actions.close,
    --                         ["<C-ESC>"] = actions.close,
    --                         -- ["<c-k>"] = actions.move_selection_previous,
    --                         -- ["<C-j>"] = actions.move_selection_next,
    --                     },
    --                 },
    --             },
    --             -- Hidden files included
    --             -- pickers = {
    --             --     find_files = {
    --             --         -- hidden = true,
    --             --     },
    --             --     grep_string = {
    --             --         additional_args = function(opts)
    --             --             -- return { "--hidden" }
    --             --         end,
    --             --     },
    --             --     live_grep = {
    --             --         additional_args = function(opts)
    --             --             -- return { "--hidden" }
    --             --         end,
    --             --     },
    --             -- },
    --         }
    --     end,
    -- },
}
