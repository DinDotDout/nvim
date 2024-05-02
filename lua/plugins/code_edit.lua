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
                vim.keymap.set("n", "<leader>cx", '<cmd>TermExec cmd="./build.sh"<cr>', { desc = "Toggleterm build.sh" }),
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
    -- {
    --     "nvim-pack/nvim-spectre",
    --     build = false,
    --     cmd = "Spectre",
    --     opts = { open_cmd = "noswapfile vnew" },
    --     -- stylua: ignore
    --     keys = { { "<leader>ss", function()     require("spectre").open()
    --     end, desc = "Replace in files (Spectre)" },},
    -- },


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
        "folke/flash.nvim",
        event = "VeryLazy",
        ---@type Flash.Config
        opts = {},
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function()     require("flash").jump()
            end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function()     require("flash").treesitter()
            end, desc = "Flash Treesitter" },
            { "r", mode = "o", function()     require("flash").remote()
            end, desc = "Remote Flash" },
            -- { "R", mode = { "o", "x" }, function()     require("flash").treesitter_search()
            -- end, desc = "Treesitter Search" },
            -- { "<c-s>", mode = { "c" }, function()     require("flash").toggle()
            -- end, desc = "Toggle Flash Search" },
        },
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