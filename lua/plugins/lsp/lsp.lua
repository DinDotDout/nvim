local function symbol_info()
  local bufnr = vim.api.nvim_get_current_buf()
  local clangd_client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
  if not clangd_client or not clangd_client.supports_method('textDocument/symbolInfo', bufnr) then
    return vim.notify('Clangd client not found', vim.log.levels.ERROR)
  end
  local win = vim.api.nvim_get_current_win()
  local params = vim.lsp.util.make_position_params(win, clangd_client.offset_encoding)
  clangd_client.request('textDocument/symbolInfo', params, function(err, res)
    if err or #res == 0 then
      -- Clangd always returns an error, there is not reason to parse it
      return
    end
    local container = string.format('container: %s', res[1].containerName) ---@type string
    local name = string.format('name: %s', res[1].name) ---@type string
    vim.lsp.util.open_floating_preview({ name, container }, '', {
      height = 2,
      width = math.max(string.len(name), string.len(container)),
      focusable = false,
      focus = false,
      border = 'single',
      title = 'Symbol Info',
    })
  end, bufnr)
end
local function switch_source_header(bufnr)
    local method_name = 'textDocument/switchSourceHeader'
    -- bufnr = util.validate_bufnr(bufnr)
    local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'clangd' })[1]
    if not client then
        return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
    end
    local params = vim.lsp.util.make_text_document_params(bufnr)
    client.request(method_name, params, function(err, result)
        if err then
            error(tostring(err))
        end
        if not result then
            vim.notify('corresponding file cannot be determined')
            return
        end
        vim.cmd.edit(vim.uri_to_fname(result))
    end, bufnr)
end
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
    -- map("crn", vim.lsp.buf.rename, "[R]e[n]ame")

    -- TODO: Leave defaults?
    -- map("crr", vim.lsp.buf.code_action, "[C]ode [A]ction")

    map("gs", vim.lsp.buf.document_symbol, "Document symbols")
    map("gS", vim.lsp.buf.workspace_symbol, "Document symbols")
    -- map("gr", vim.lsp.buf.references, "[G]oto [R]references")
    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    -- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    -- map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
    map("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("gi", vim.lsp.buf.incoming_calls, "[G]oto [I]incoming calls")
    -- map("go", vim.lsp.buf.outgoing_calls, "[G]oto [O]utgoing calls")

    -- map("gt", vim.lsp.buf.type_definition, "[G]oto [T]ype definition")

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
--
--     if client and client.server_capabilities.documentFormattingProvider then
--         map("<leader>cf", vim.lsp.buf.format, "Code format")
--     end
--
--     -- Visual mode range format
--     if client and client.server_capabilities.documentRangeFormattingProvider then
--         map("<leader>cf", vim.lsp.buf.range_formatting, "Range format", "v")
--     end
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
                cmd = { "clangd", "--offset-encoding=utf-16", "--header-insertion=never" },
                root_markers = { "compile_commands.json", ".clangd", ".clang-tidy", ".clang-format", "compile_flags.txt", "configure.ac", ".git" },
                on_attach = function(client, bufnr)
                    -- Define the command only if clangd is attached
                    -- vim.keymap.set("n", "gh", function()
                    --     vim.lsp.buf.execute_command("clangd.switchSourceHeader")
                    -- end, { buffer = bufnr, silent = true })
                    --
                    vim.keymap.set("n", "<leader>li", function()
                        symbol_info()
                    end, { buffer = bufnr, silent = true })

                    vim.keymap.set("n", "gh", function()
                        switch_source_header(bufnr)
                    end, { buffer = bufnr, silent = true })

                    -- vim.api.nvim_buf_set_keymap(
                    --     bufnr,
                    --     "n",
                    --     "gh",
                    --     function()
                    --     -- "<cmd>ClangdSwitchSourceHeader<CR>"
                    --     end,
                    --     { noremap = true, silent = true }
                    -- )
                end,
            },
        },
    },
    config = function(_, opts)
        require("mason").setup({})

        for server, config in pairs(opts.servers) do
            config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)

            vim.lsp.config(server, config)
            vim.lsp.enable(server)
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = keymaps,
        })
    end
}
-- }
--
