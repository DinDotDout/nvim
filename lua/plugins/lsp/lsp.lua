local function keymaps(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    -- require("completion").on_attach(client)
    -- require("diagnostic").on_attach(client)
    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP " .. desc })
    end
    -- map("<leader>cl", "<cmd>LspInfo<cr>", "Info")
    map("<leader>cf", vim.lsp.buf.format, "lsp Code format")
    -- map("<leader>co", ":LspRestart<CR>", "Restart")
    map("crn", vim.lsp.buf.rename, "[R]e[n]ame")

    -- TODO: Leave defaults?
    map("crr", vim.lsp.buf.code_action, "[C]ode [A]ction")

    map("gs", vim.lsp.buf.document_symbol, "Document symbols")
    map("gS", vim.lsp.buf.workspace_symbol, "Document symbols")
    map("gr", vim.lsp.buf.references, "[G]oto [R]references")
    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    -- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    -- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("gi", vim.lsp.buf.incoming_calls, "[G]oto [I]incoming calls")
    map("go", vim.lsp.buf.outgoing_calls, "[G]oto [O]utgoing calls")
    map("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype definition")
    -- map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    -- map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype definition")

    -- map("<leader>cs", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    -- map("<leader>cS", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    -- TODO: modified
    map("<leader>ct", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
    end, "Toggle inlay hints")
    map("K", vim.lsp.buf.hover, "Hover Documentation")

    map("<C-S-k>", vim.lsp.buf.signature_help, "Signature help") -- show

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    if client and client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

return { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for neovim
        "saghen/blink.cmp",        -- ensure blink loads
        "williamboman/mason.nvim", -- lsp, dap, ... installer
        -- "hrsh7th/cmp-nvim-lsp", -- completion
        -- "williamboman/mason-lspconfig.nvim",
        -- "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- Useful status updates for LSP.
        { "j-hui/fidget.nvim", opts = {} },
        {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- See the configuration section for more details
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    { plugins = { "nvim-dap-ui" }, types = true, }
                },
            },
        },
    },

    opts = {
        servers = {
            gdshader_lsp = {},
            slangd = {
                cmd = { "slangd" }
            },
            lua_ls = {},
            clangd = {
                cmd = { "clangd", "--offset-encoding=utf-16" },
                on_attach = function(client, bufnr)
                    -- Define the command only if clangd is attached
                    vim.api.nvim_buf_set_keymap(
                        bufnr,
                        "n",
                        "gh",
                        "<cmd>ClangdSwitchSourceHeader<CR>",
                        { noremap = true, silent = true }
                    )
                end,
            },
        },
    },
    config = function(_, opts)
        -- defineDiagnosticSigns
        local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        local mason = require("mason")
        mason.setup({
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        })

        local lspconfig = require("lspconfig")
        for server, config in pairs(opts.servers) do
            -- passing config.capabilities to blink.cmp merges with the capabilities in your
            -- `opts[server].capabilities, if you've defined it
            -- vim.lsp._set_defaults(client, bufnr)
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
            lspconfig[server].setup(config)
        end
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = keymaps,
        })
    end,
}
-- }
