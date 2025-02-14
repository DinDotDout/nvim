-- Set filetype for glsl files
local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("auto hlsl filetype"),
    pattern = { "*.dbx" },
    callback = function()
        vim.cmd("set filetype=cs")
        vim.cmd("setlocal commentstring=//%s")
    end,
})
autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("auto hlsl filetype"),
    pattern = { "*.hlsl" },
    callback = function()
        vim.cmd("set filetype=hlsl")
        vim.cmd("setlocal commentstring=//%s")
    end,
})

autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("auto gdshader filetype"),
    pattern = { "*.gdshader", "*.gdshaderinc" },
    callback = function()
        -- vim.lsp.start({
        --     name = "gdshader-lsp",
        --     cmd = {
        --         "/home/joan/.local/share/nvim/mason/extra/gdshader-lsp",
        --     },
        --     capabilities = vim.lsp.protocol.make_client_capabilities(),
        -- })
        vim.cmd("set filetype=gdshader")
        vim.cmd("setlocal commentstring=//%s")
    end,
})

-- autocmd({ "FileType" }, {
--     group = augroup("pencil"),
--     pattern = { "markdown", "mkd", "txt", "md" },
--
--     -- pattern = { "*.markdown", "*.mkd", "*.txt", "*.md" },
--     -- pattern = { "*.markdown", "*.mkd", "*.txt", "*.md" },
--     callback = function()
--         print("Pencil")
--         -- vim.cmf("set filetype?")
--         vim.cmd("setlocal nowrap")
--         vim.cmd("setlocal nobreakindent")
--         vim.wo.wrap = false
--         vim.wo.breakindent = false
--         vim.opt.wrap = false
--         vim.opt.breakindent = false
--     end,
-- })
-- vim.api.nvim_create_autocmd("InsertEnter", {
--     pattern = { "*.markdown", "*.mkd", "*.txt", "*.md" },
--     callback = function()
--         vim.cmd("set wrap")
--         vim.cmd("set breakindent")
--     end,
--     group = "pencil",
-- })

autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("auto glsl filetype"),
    pattern = { ".glsl", "*.comp", "*.vert", "*.frag", "*.ply", "*.lst", "*.obj", "*.gltf", "*.glb" },
    callback = function()
        vim.cmd("set filetype=glsl")
        vim.cmd("setlocal commentstring=//%s")
    end,
})

-- -- Set commentstring for glsl files
-- autocmd({ "BufRead", "BufNewFile" }, {
--     pattern = { "*.gdshader", "*.gdshaderinc", "*.comp", "*.glsl", "*.vert", "*.frag" },
--     command = "setlocal commentstring=//%s",
-- })

-- Autocmd for lualine
autocmd("RecordingEnter", {
    group = augroup("lualine update"),
    callback = function()
        require("lualine").refresh({
            place = { "statusline" },
        })
    end,
})

autocmd("RecordingLeave", {
    group = augroup("lualine timer update"),
    callback = function()
        -- This is going to seem really weird!
        -- Instead of just calling refresh we need to wait a moment because of the nature of
        -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
        -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
        -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
        -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
        local timer = vim.loop.new_timer()
        timer:start(
            50,
            0,
            vim.schedule_wrap(function()
                require("lualine").refresh({
                    place = { "statusline" },
                })
            end)
        )
    end,
})

-- Lazyvim sane defaults
-- Check if we need to reload the file when it changed
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
    group = augroup("checktime"),
    callback = function()
        if vim.o.buftype ~= "nofile" then
            vim.cmd("checktime")
        end
    end,
})

-- Highlight on yank
autocmd("TextYankPost", {
    group = augroup("highlight_yank"),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- resize splits if window got resized
autocmd({ "VimResized" }, {
    group = augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

-- go to last loc when opening a buffer
autocmd("BufReadPost", {
    group = augroup("last_loc"),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q>
autocmd("FileType", {
    group = augroup("close_with_q"),
    pattern = {
        "dap-hover",
        "dap-scopes",
        "PlenaryTestPopup",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        -- "spectre_panel",
        -- "startuptime",
        "tsplayground",
        "neotest-output",
        "checkhealth",
        "neotest-summary",
        "neotest-output-panel",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- wrap and check for spell in text filetypes
autocmd("FileType", {
    group = augroup("wrap_spell"),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Fix conceallevel for json files
autocmd({ "FileType" }, {
    group = augroup("json_conceal"),
    pattern = { "json", "jsonc", "json5" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
autocmd({ "BufWritePre" }, {
    group = augroup("auto_create_dir"),
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})
