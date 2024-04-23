return {
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                open_mapping = [[<c-\>]],
                hide_numbers = true, -- hide the number column in toggleterm buffers
                shade_filetypes = {},
                -- autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
                shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
                -- shading_factor = '<number>', -- the percentage by which to lighten terminal background, default: -30 (gets multiplied by -3 if background is light)
                start_in_insert = true,
                insert_mappings = true, -- whether or not the open mapping applies in insert mode

                terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
                -- persist_size = true,
                -- persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
                -- direction = 'vertical' | 'horizontal' | 'tab' | 'float',
                -- use vim copy mode
                direction = "float",
                -- direction = "tab",
                close_on_exit = true, -- close the terminal window when the process exits

                -- Change the default shell. Can be a string or a function returning a string
                shell = vim.o.shell,
                auto_scroll = true, -- automatically scroll to the bottom on terminal output
                -- This field is only relevant if direction is set to 'float'
                float_opts = {
                    border = "curved",
                    -- title_pos = 'left' | 'center' | 'right', position of the title of the floating window
                },
                -- winbar = {
                -- enabled = false,
                -- name_formatter = function(term) --  term: Terminal
                -- return term.name
                -- end
                -- },
                vim.keymap.set("t", "<esc>", [[<C-\><C-n>]]),
                vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]]),
                vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]]),
                vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]]),
                vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]]),
                vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]]),
                vim.keymap.set("n", "<leader>cx", '<cmd>TermExec cmd="./build.sh"<cr>', {desc = "Toggleterm build.sh"}),
                --   -- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
            })
        end,
    },

    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
    { -- Smart comments
        "numToStr/Comment.nvim",
        -- event = { "BufRead", "BufNewFile", "BufWritePost" },
        lazy = false,
        config = function()
            require("Comment").setup()
            vim.keymap.set("n", "<C-_>", "gcc", { remap = true }, { desc = "Comment Line" }) -- Needed for tmux
            vim.keymap.set("x", "<C-_>", "gc", { remap = true }, { desc = "Comment Line" }) -- Needed for tmux

            vim.keymap.set("n", "<C-/>", "gcc", { remap = true }, { desc = "Comment Line" })
            vim.keymap.set("x", "<C-/>", "gc", { remap = true }, { desc = "Comment Line" })

            vim.keymap.set("n", "gC", "gcc", { remap = true }, { desc = "Comment Line" })
            vim.keymap.set("x", "gC", "gc", { remap = true }, { desc = "Comment Line" })
        end,
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        event = { "BufRead", "BufNewFile", "BufEnter" },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
            local keymap = vim.keymap
            keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Mark File (Harpoon)" })
            keymap.set("n", "<C-e>", function()
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
        "mbbill/undotree",
        enabled = true,
        keys = { { "<leader>ut", "<cmd>UndotreeToggle<CR>", desc = "Undotree" } },
    },

    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<CR>", desc = "Symbols Outline" } },
        config = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        version = false, -- telescope did only one release, so use HEAD for now
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                enabled = vim.fn.executable("make") == 1,
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
        },
        keys = {
            -- Always show hidden for now, revise when available for live_grep
            { "<leader>,", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Switch Buffer" },
            {
                "<leader><leader>",
                "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
                desc = "Switch Buffer",
            },
            { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (root dir)" },
            { "<leader>.", "<cmd>Telescope find_files<cr>", desc = "Find Files (root dir)" },

            -- { "<leader>sf", "<cmd>Telescope find_files hidden=true<cr>", desc = "Find Files (hidden)" },
            -- {
            --     "<leader>sg",
            --     "<cmd>Telescope live_grep vimgrep_arguments={'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case'}<cr>",
            --     desc = "Grep (root dir hidden)",
            -- },

            {
                "<leader>sw",
                "<cmd>Telescope grep_string<cr>",
                { word_match = "-w" },
                desc = "Word under cursor (root dir)",
            },
            { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Resume" },
            { "<leader>sR", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
            {
                "<leader>sn",
                function()
                    local builtin = require("telescope.builtin")
                    builtin.find_files({ cwd = vim.fn.stdpath("config") })
                end,
                desc = "Nvim dotfiles",
            },
            -- search
            { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
            { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },

            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
            { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
            { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
        },
        opts = function()
            local actions = require("telescope.actions")
            local builtin = require("telescope.builtin")
            local find_files_no_ignore = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                builtin.find_files({ no_ignore = true, default_text = line })
                -- Util.telescope("find_files", { no_ignore = true, default_text = line })()
            end
            local find_files_with_hidden = function()
                local action_state = require("telescope.actions.state")
                local line = action_state.get_current_line()
                builtin.find_files({ hidden = true, default_text = line })
                -- Util.telescope("find_files", { hidden = true, default_text = line })()
            end

            return {
                defaults = {
                    layout_strategy = "horizontal",
                    layout_config = { prompt_position = "bottom" },
                    sorting_strategy = "ascending",

                    prompt_prefix = " ",
                    selection_caret = " ",
                    -- open files in the first window that is an actual file.
                    -- use the current window if no other window is available.
                    get_selection_window = function()
                        local wins = vim.api.nvim_list_wins()
                        table.insert(wins, 1, vim.api.nvim_get_current_win())
                        for _, win in ipairs(wins) do
                            local buf = vim.api.nvim_win_get_buf(win)
                            if vim.bo[buf].buftype == "" then
                                return win
                            end
                        end
                        return 0
                    end,
                    mappings = {
                        i = {
                            ["<c-d>"] = actions.delete_buffer, -- Close buffer from buff list
                            ["<a-i>"] = find_files_no_ignore,
                            ["<C-Down>"] = actions.cycle_history_next,
                            ["<C-Up>"] = actions.cycle_history_prev,

                            ["<C-f>"] = actions.preview_scrolling_down,
                            ["<C-b>"] = actions.preview_scrolling_up,
                            -- ["<c-k>"] = actions.move_selection_previous,
                            -- ["<C-j>"] = actions.move_selection_next,
                        },
                        n = {
                            ["<c-d>"] = actions.delete_buffer, -- Close buffer from buff list
                            ["q"] = actions.close,
                            -- ["<c-k>"] = actions.move_selection_previous,
                            -- ["<C-j>"] = actions.move_selection_next,
                        },
                    },
                },
                -- Hidden files included
                -- pickers = {
                --     find_files = {
                --         -- hidden = true,
                --     },
                --     grep_string = {
                --         additional_args = function(opts)
                --             -- return { "--hidden" }
                --         end,
                --     },
                --     live_grep = {
                --         additional_args = function(opts)
                --             -- return { "--hidden" }
                --         end,
                --     },
                -- },
            }
        end,
    },
    {
        "stevearc/oil.nvim",
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
        lazy = false,
        opts = {
            default_file_explorer = true,
            keymaps = {
                ["<esc>"] = "actions.close",
                ["<leader>e"] = "actions.close",
                ["q"] = "actions.close",
                ["<C-h>"] = "<cmd>wincmd h<cr>",
                ["<C-l>"] = "<cmd>wincmd l<cr>",
            },
        },
        keys = { { "<leader>e", "<cmd> Oil<CR>", desc = "Open file explorer" } },
    },
    {
        "nvim-pack/nvim-spectre",
        build = false,
        cmd = "Spectre",
        opts = { open_cmd = "noswapfile vnew" },
        -- stylua: ignore
        keys = { { "<leader>ss", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },},
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                -- ["gs"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                -- ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },

    -- Mostly from lazyvim
    -- Allows better actions jumping to them when found within n_lines
    {
        "echasnovski/mini.ai",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    -- Block
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    -- Function
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    -- Class
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                    -- a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }, {}),
                    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
                },
            }
        end,
        config = function(_, opts)
            require("mini.ai").setup(opts)
            -- register all text objects with which-key
            local function set_keymaps()
                ---@type table<string, string|table>
                local i = {
                    [" "] = "Whitespace",
                    ['"'] = 'Balanced "',
                    ["'"] = "Balanced '",
                    ["`"] = "Balanced `",
                    ["("] = "Balanced (",
                    [")"] = "Balanced ) including white-space",
                    [">"] = "Balanced > including white-space",
                    ["<lt>"] = "Balanced <",
                    ["]"] = "Balanced ] including white-space",
                    ["["] = "Balanced [",
                    ["}"] = "Balanced } including white-space",
                    ["{"] = "Balanced {",
                    ["?"] = "User Prompt",
                    _ = "Underscore",
                    a = "Argument",
                    b = "Balanced ), ], }",
                    c = "Class",
                    f = "Function",
                    o = "Block, conditional, loop",
                    q = "Quote `, \", '",
                    t = "Tag",
                }
                local a = vim.deepcopy(i)
                for k, v in pairs(a) do
                    a[k] = v:gsub(" including.*", "")
                end

                local ic = vim.deepcopy(i)
                local ac = vim.deepcopy(a)
                for key, name in pairs({ n = "Next", l = "Last" }) do
                    i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
                    a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
                end
                --[[ require("which-key").register({
        mode = { "o", "x" },
        i = i,
        a = a,
        }) ]]
            end
            set_keymaps()
        end,
    },
    {
        "folke/trouble.nvim",
        cmd = { "TroubleToggle", "Trouble" },
        opts = { use_diagnostic_signs = true },
        keys = {
            { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
            { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
            -- { "<leader>xL", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
            -- { "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
            {
                "[q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cprev)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Previous trouble/quickfix item",
            },
            {
                "]q",
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({ skip_groups = true, jump = true })
                    else
                        local ok, err = pcall(vim.cmd.cnext)
                        if not ok then
                            vim.notify(err, vim.log.levels.ERROR)
                        end
                    end
                end,
                desc = "Next trouble/quickfix item",
            },
        },
    },
}
