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
            -- "nvim-lua/plenary.nvim",

            -- see below for full list of optional dependencies 👇
        },
        opts = {
            workspaces = {
                {
                    name = "personal",
                    path = "~/Nextcloud/Obsidian",
                },
            },
            -- ui = { enable = false },

            -- see below for full list of options 👇
        },
        mappings = { -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
            -- ["gf"] = {
            --     action = function()
            --         return require("obsidian").util.gf_passthrough()
            --     end,
            --     opts = { noremap = false, expr = true, buffer = true },
            -- },
            -- Toggle check-boxes.
            ["<leader>ch"] = {
                action = function()
                    return require("obsidian").util.toggle_checkbox()
                end,
                opts = { buffer = true },
            },
            -- Smart action depending on context, either follow link or toggle checkbox.
            ["<cr>"] = {
                action = function()
                    return require("obsidian").util.smart_action()
                end,
                opts = { buffer = true, expr = true },
            },
            ["<leader>ol"] = {
                action = "<cmd>ObsidianLink<CR>",
                opt = {buffer = true, expr = true},
            },
            ["<leader>/"] = {
                action = function()
                    return require("obsidian").search_notes()
                end,
                opt = {buffer = true, expr = true},
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
