return {
    { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, opts = {} },
    {
        "mbbill/undotree",
        enabled = true,
        keys = { { "<leader>ut", "<cmd>UndotreeToggle<CR>", desc = "Undotree" } },
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
            end
            set_keymaps()
        end,
    },

    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = {
                    enabled = false,
                },
                char = {
                    multi_line = false,
                },
            },
        },
        -- stylua: ignore
        keys = {
            { "s", mode = { "n", "x", "o" }, function()     require("flash").jump()
            end, desc = "Flash" },
            { "S", mode = { "n", "x", "o" }, function()     require("flash").treesitter()
            end, desc = "Flash Treesitter" },
            -- { "r", mode = "o", function()     require("flash").remote()
            -- end, desc = "Remote Flash" },
            -- { "R", mode = { "o", "x" }, function()     require("flash").treesitter_search()
            -- end, desc = "Treesitter Search" },
            -- { "<c-s>", mode = { "c" }, function()     require("flash").toggle()
            -- end, desc = "Toggle Flash Search" },
        },
    },
}
