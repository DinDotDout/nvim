local mason_servers = {
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
    html = {},
    cssls = {},
    glsl_analyzer = {},

    lua_ls = {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                workspace = {
                    checkThirdParty = false,
                    -- Tells lua_ls where to find all the Lua files that you have loaded
                    -- for your neovim configuration.
                    library = {
                        "${3rd}/luv/library",
                        unpack(vim.api.nvim_get_runtime_file("", true)),
                    },
                    -- If lua_ls is really slow on your computer, you can try this instead:
                    -- library = { vim.env.VIMRUNTIME },
                },
                completion = {
                    callSnippet = "Replace",
                },
                -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                -- diagnostics = { disable = { 'missing-fields' } },
            },
        },
    },
}

local other_servers = {
    glslls = {
        -- cmd = { "glslls", "--stdin" },
        -- single_file_support = true,
    },
    gdscript = {},
}

local function defineDiagnosticSigns()
    -- local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
end

local function keymaps(event)
    local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP " .. desc })
    end
    -- map("<leader>cl", "<cmd>LspInfo<cr>", "Info")
    -- map("<leader>cf", vim.lsp.buf.format, "lsp Code format")
    map("<leader>co", ":LspRestart<CR>", "Restart")
    map("<leader>cr", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

    map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
    map("gt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype definition")

    map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    map("K", vim.lsp.buf.hover, "Hover Documentation")

    map("<C-S-K>", vim.lsp.buf.signature_help, "Signature help") -- show
    map("<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Type [D]efinition")

    -- The following two autocommands are used to highlight references of the
    -- word under your cursor when your cursor rests there for a little while.
    --    See `:help CursorHold` for information about when this is executed
    -- When you move your cursor, the highlights will be cleared (the second autocommand).
    local client = vim.lsp.get_client_by_id(event.data.client_id)
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

local function setupMason()
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
end

local function setupServers(capabilities)
    local ensure_installed = vim.tbl_keys(mason_servers or {})
    -- local ensure_installed = { "clangd", "html", "cssls", "glsl_analyzer", "lua_ls" }
    vim.list_extend(ensure_installed, {
        "prettier", -- Used to format HTML, CSS, JS, etc.
        "prettierd", -- Used to format HTML, CSS, JS, etc.
        "stylua", -- Used to format lua code
        "clang-format", -- Used to format C/C++ code
        "shfmt", -- Used to format shell scripts
        "shellcheck", -- Used to lint shell scripts
        "cpplint",
        "cmakelint",
        "cmakelang",
    })
    require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

    require("mason-lspconfig").setup({
        handlers = {
            function(server_name)
                local server = mason_servers[server_name] or {}
                -- This handles overriding only values explicitly passed
                -- by the server configuration above. Useful when disabling
                -- certain features of an LSP (for example, turning off formatting for tsserver)
                server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                require("lspconfig")[server_name].setup(server)
            end,
        },
    })
    for server_name, server in pairs(other_servers) do
        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
        require("lspconfig")[server_name].setup(server)
    end
end

return { -- LSP Configuration & Plugins
    "neovim/nvim-lspconfig",
    -- event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for neovim
        "hrsh7th/cmp-nvim-lsp", -- completion
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",

        -- Useful status updates for LSP.
        -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
        { "j-hui/fidget.nvim", opts = {} },
    },

    config = function()
        defineDiagnosticSigns()

        -- setup keymaps on attach
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = keymaps,
        })

        local capabilities = vim.tbl_deep_extend(
            "force",
            vim.lsp.protocol.make_client_capabilities(),
            require("cmp_nvim_lsp").default_capabilities()
        )

        setupMason()
        setupServers(capabilities)
    end,
}
