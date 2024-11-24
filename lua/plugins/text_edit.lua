local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end
return {
    {
        "tadmccorkle/markdown.nvim",
        ft = "markdown",
        -- event = "VeryLazy"
        opts = {
            -- configuration here or empty for defaults
        },
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false, -- Recommended
        -- ft = "markdown" -- If you decide to lazy-load anyway

        dependencies = {
            -- You will not need this if you installed the
            -- parsers manually
            -- Or if the parsers are in your $RUNTIMEPATH
            "nvim-treesitter/nvim-treesitter",

            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "epwalsh/obsidian.nvim",
        version = "*", -- recommended, use latest release instead of latest commit
        -- lazy = true,
        ft = "markdown",
        -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
        -- event = {
        --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
        --   -- refer to `:h file-pattern` for more examples
        --   "BufReadPre path/to/my-vault/*.md",
        --   "BufNewFile path/to/my-vault/*.md",
        -- },
        dependencies = {
            -- Required.
            "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            new_note_location = "Notes/", -- Add this line to specify the folder for new notes
            workspaces = {
                {
                    name = "personal",
                    path = "~/Nextcloud/Obsidian",
                },
            },
            templates = {
                substitutions = {
                    tags = function()
                        return 'write'
                    end,

                    yesterday = function()
                        return os.date("%Y-%m-%d", os.time() - 86400)
                    end,
                },
            },
            -- note_id_func = function(title)
            --     -- return title
            --     -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            --     -- In this case a note with the title 'My new note' will be given an ID that looks
            --     -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            --     local suffix = ""
            --     if title ~= nil then
            --         -- If title is given, transform it into valid file name.
            --         suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            --     else
            --         -- If title is nil, just add 4 random uppercase letters to the suffix.
            --         for _ = 1, 4 do
            --             suffix = suffix .. string.char(math.random(65, 90))
            --         end
            --     end
            --     return tostring(os.time()) .. "-" .. suffix
            -- end,

            -- ui = { enable = false },

            -- see below for full list of options 👇
            mappings = { -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
                -- ["gf"] = {
                --     action = function()
                --         return require("obsidian").util.gf_passthrough()
                --     end,
                --     opts = { noremap = false, expr = true, buffer = true },
                -- },
                -- Toggle check-boxes.
                ["<leader>oc"] = {
                    action = function()
                        return require("obsidian").util.toggle_checkbox()
                    end,
                    opts = { buffer = true },
                },
                -- Smart action depending on context, either follow link or toggle checkbox.
                -- ["<cr>"] = {
                --     action = "<cmd>ObsidianFollowLink<CR>",
                --     opt = { buffer = true, expr = true },
                -- },
                ["<cr>"] = {
                    action = function()
                        return require("obsidian").util.smart_action()
                    end,
                    opts = { buffer = true, expr = true },
                },
                ["<leader>on"] = {
                    action = "<cmd>ObsidianNew<CR>",
                    opt = { mode = "v", buffer = true },
                    -- opts = { mode = "v", buffer = true, expr = true  },
                },
                ["<leader>oe"] = {
                    action = "<cmd>ObsidianExtractNote<CR>",
                    opt = { mode = "v", buffer = true },
                    -- opts = { mode = "v", buffer = true, expr = true  },
                },
                ["<leader>oi"] = {
                    action = "<cmd>ObsidianPasteImg<CR>",
                    opt = { buffer = true, expr = true },
                },
                ["<leader>ot"] = {
                    action = "<cmd>ObsidianTags<CR>",
                    opt = { buffer = true, expr = true },
                },
                ["<leader>ol"] = {
                    action = "<cmd>ObsidianLinks<CR>",
                    opt = { buffer = true, expr = true },
                },
                ["<leader>ob"] = {
                    action = "<cmd>ObsidianBacklinks<CR>",
                    opt = { buffer = true, expr = true },
                },
                ["<leader>/"] = {
                    action = "<cmd>ObsidianSearch<CR>",
                    opt = { buffer = true, expr = true },
                },
                ["<leader>."] = {
                    action = "<cmd>ObsidianQuickSwitch<CR>",
                    opt = { buffer = true, expr = true },
                },
            },
        },
    },
    {
        "lervag/vimtex",
        config = function()
            vim.g["vimtex_view_method"] = "zathura" -- main variant with xdotool (requires X11; not compatible with wayland)
            -- vim.g['maplocalleader'] = " "
            -- vim.g['vimtex_format_enabled'] = 1
            -- vim.g['vimtex_view_method'] = 'zathura_simple' -- for variant without xdotool to avoid errors in wayland
            -- vim.g['vimtex_quickfix_mode'] = 0              -- suppress error reporting on save and build
            -- vim.g['vimtex_mappings_enabled'] = 0           -- Ignore mappings
            -- vim.g['vimtex_indent_enabled'] = 0             -- Auto Indent

            vim.g["tex_flavor"] = "latex" -- how to read tex files
            vim.g["tex_indent_items"] = 0 -- turn off enumerate indent
            vim.g["tex_indent_brace"] = 0 -- turn off brace indent
            vim.g["vimtex_context_pdf_viewer"] = "okular" -- external PDF viewer run from vimtex menu command
            -- vim.g['vimtex_context_pdf_viewer'] = 'zathura'  -- external PDF viewer run from vimtex menu command
            vim.g["vimtex_log_ignore"] = { -- Error suppression:
                "Underfull",
                "Overfull",
                "specifier changed to",
                "Token not allowed in a PDF string",
            }
        end,
    },
    {
        "preservim/vim-pencil",
        -- ft = "markdown",
        keys = { { "<leader>n", "<cmd>TogglePencil<CR>", desc = "Pencil mode" } },
    },
}
