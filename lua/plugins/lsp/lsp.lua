local function defineDiagnosticSigns()
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
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

local function setupKeyBindings(opts)
    local keymap = vim.keymap -- for conciseness

    -- set keybinds
    opts.desc = "Lsp Info"
    keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", opts)

    opts.desc = "Code format"
    keymap.set("n", "<leader>cf", vim.lsp.buf.format, opts)

    opts.desc = "Show LSP references"
    keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

    opts.desc = "Go to declaration"
    keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

    opts.desc = "Show LSP definitions"
    keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

    opts.desc = "Show LSP implementations"
    keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

    opts.desc = "Show LSP type definitions"
    keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

    opts.desc = "See available code actions"
    keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

    opts.desc = "Smart rename"
    keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts) -- smart rename

    opts.desc = "Show buffer diagnostics"
    keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

    opts.desc = "Show documentation for what is under cursor"
    keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation

    opts.desc = "Signature Help"
    keymap.set("n", "<c-K>", vim.lsp.buf.signature_help, opts) -- show

    opts.desc = "Restart LSP"
    keymap.set("n", "<leader>co", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
end

local function defineServerConfig(server_name, capabilities, on_attach)
    local config = {
        capabilities = capabilities,
        on_attach = on_attach,
    }

    -- Server specific configurations
    if server_name == "clangd" then
        config.cmd = { "clangd", "--offset-encoding=utf-16" }
    end

    if server_name == "lua_ls" then
        config.settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                },
                workspace = {
                    checkThirdParty = false,
                },
                completion = {
                    callSnippet = "Replace",
                },
            },
        }
    end

    return config
end

local function setupLspConfig(on_attach, capabilities)
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
        ensure_installed = {
            "lua_ls",
            "clangd",
            "tsserver",
            "html",
            "cssls",
        },
        handlers = {
            function(server_name)
                local config = defineServerConfig(server_name, capabilities, on_attach)
                require("lspconfig")[server_name].setup(config)
            end,
        },
        automatic_installation = true,
    })
end

local function setupPackageInstallSuccessEvent()
    local mr = require("mason-registry")
    mr:on("package:install:success", function()
        vim.defer_fn(function()
            -- trigger FileType event to possibly load this newly installed LSP server
            require("lazy.core.handler.event").trigger({
                event = "FileType",
                buf = vim.api.nvim_get_current_buf(),
            })
        end, 100)
    end)
end

return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    dependencies = {
        "j-hui/fidget.nvim", -- lsp notifications
        "hrsh7th/cmp-nvim-lsp", -- completion
        {
            "williamboman/mason.nvim",
            dependencies = {
                "williamboman/mason-lspconfig.nvim",
            },
            cmd = "Mason",
            build = ":MasonUpdate",
            keys = { { "<leader>cm", "<cmd>Mason<CR>", desc = "Mason" } },

            config = function()
                defineDiagnosticSigns()
                setupMason()

                local opts = { noremap = true, silent = true }
                local on_attach = function(_, bufnr)
                    opts.buffer = bufnr
                    setupKeyBindings(opts)
                end

                -- Used to enable autocompletion (assign to every lsp server config)
                local cmp_nvim_lsp = require("cmp_nvim_lsp")
                local capabilities = vim.tbl_deep_extend(
                    "force",
                    {},
                    vim.lsp.protocol.make_client_capabilities(),
                    cmp_nvim_lsp.default_capabilities()
                )
                setupLspConfig(on_attach, capabilities)
                setupPackageInstallSuccessEvent()
            end,
        },
    },
}
