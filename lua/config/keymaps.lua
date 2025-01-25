vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Rebinding increment and decrement due to tmux/wezterm colission
keymap({ "n", "c", "v", "i" }, "<C-p>", "<C-x>", { noremap = true, silent = true })
keymap({ "n", "c", "v", "i" }, "<C-n>", "<C-a>", { noremap = true, silent = true })
keymap({ "n", "c", "v", "i" }, "g<C-n>", "g<C-a>", { noremap = true, silent = true })
keymap({ "n", "c", "v", "i" }, "g<C-p>", "g<C-x>", { noremap = true, silent = true })

-- TODO: modified
keymap("n", "<C-_>", "gcc", { desc = "Comment Line", remap = true }) -- Needed for tmux
keymap("x", "<C-_>", "gc", { remap = true }, { desc = "Comment Line" }) -- Needed for tmux
keymap("n", "<C-/>", "gcc", { remap = true }, { desc = "Comment Line" })
keymap("x", "<C-/>", "gc", { remap = true }, { desc = "Comment Line" })

-- Macro keybinds and unbind Q
keymap("n", "Q", "@q", { desc = "Execute 'q' macro and jump down" }, opts) -- Execute macro and jump down
keymap("x", "Q", ":norm @q<CR>", { desc = "Execute 'q' macro on selection" }, opts) -- Execute macro on selection

local path_commands = require("plugins.custom.clipboard-oil-commands")

local function get_selection_as_string_array()
    local start_line, end_line = path_commands.get_selected_line_indices()
    start_line, end_line = start_line-1, end_line-1
    local lines = vim.api.nvim_buf_get_lines(0, start_line, end_line+1, false)
    return lines
end
local function execute_string_as_lua(arr)
    if arr then
        local code = table.concat(arr, "\n") -- Separate?
        local chunk, err = load(code)
        if chunk then
            local res = pcall(chunk)--chunk()
            if not res then
                vim.notify("Error executing code: " .. res, vim.log.levels.ERROR)
            end
        else
            vim.notify("Error: " .. err, vim.log.levels.ERROR)
            print(err)
        end
    end
end

keymap("v", "<leader>ld", function()
    local text = (vim.inspect(get_selection_as_string_array()))
    print(text)
end, {desc = "Print selected text"}, opts)

-- Keymap
keymap("n", "<leader>lr", "<cmd>.lua<CR>", { desc = "Execute the current line" })
keymap("v", "<leader>lr", function()
    local selection = get_selection_as_string_array()
    execute_string_as_lua(selection)
end, { desc = "Execute the current selection" })

keymap("n", "<leader>lR", "<cmd>source %<CR>", { desc = "Execute the current file" })

keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete no copying" }, opts)

-- TODO: modified
-- Replace word under cursor
local function is_quickfix()
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = 0 })
    return buftype == "quickfix"
end

-- TODO: fix cdo modified
local function text_replace_mappings()
    -- WARNING: Replace selection does not escape characters and I probably do not need it either
    if is_quickfix() then
        keymap(
            "n",
            "<leader>r",
            [[:cdo s/\<<C-r><C-w>\>//gc<left><left><left>]],
            { desc = "Replace word under cursor cdo" },
            opts
        )
        -- Replace selection
        keymap(
            "v",
            "<leader>r",
            [[y:let @/ = @"<CR>:cdo s/\V<C-r>///gc<left><left><left>]],
            { desc = "Replace selected text cdo" },
            opts
        )
    else
        keymap("n", "<leader>r", [[:%s/\<<C-r><C-w>\>//g<left><left>]], { desc = "Replace word under cursor" }, opts)
        -- Replace selection
        keymap(
            "v",
            "<leader>r",
            [[y:let @/ = @"<CR>:%s/\V<C-r>///g<left><left>]],
            { desc = "Replace selected text" },
            opts
        )
    end
end

local augroup = vim.api.nvim_create_augroup("ConditionalMapping", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = augroup,
    callback = text_replace_mappings,
})

-- Replace word under cursor

-- Better up down movement
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true }, opts)
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true }, opts)
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }, opts)
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }, opts)

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<cmd>noh<CR><esc>", { desc = "Escape and clear hlsearch" }, opts)

-- Add undo break-points when typing things
keymap("i", ",", ",<c-g>u", opts)
keymap("i", ".", ".<c-g>u", opts)
keymap("i", ";", ";<c-g>u", opts)

--keywordprg
keymap("n", "<leader>K", "<cmd>norm! K<CR>", { desc = "Keywordprg" }, opts)

-- better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- TODO: modified
local function toggle_quickfix()
    local quickfix_open = vim.fn.getqflist({ winid = 0 }).winid ~= 0
    if quickfix_open then
        vim.cmd("cclose")
    else
        vim.cmd("copen")
    end
end
keymap("n", "<leader>q", function()
    toggle_quickfix()
end, { desc = "Quickfix List" }, opts)

keymap("n", "<C-left>", vim.cmd.cprev, { desc = "Previous quickfix" }, opts)
keymap("n", "<C-right>", vim.cmd.cnext, { desc = "Next quickfix" }, opts)

-- diagnostic move fw or bw
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" }, opts)

keymap("n", "<C-[>", diagnostic_goto(false), { desc = "Previous Diagnostic" }, opts)
keymap("n", "<C-]>", diagnostic_goto(true), { desc = "Next Diagnostic" }, opts)

keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" }, opts)
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" }, opts)
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" }, opts)
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" }, opts)
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" }, opts)
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" }, opts)

keymap("n", "-", "<C-W>s", { desc = "Split window down", remap = true }, opts)
keymap("n", "\\", "<C-W>v", { desc = "Split window right", remap = true }, opts)
--
-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" }, opts)
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" }, opts)

keymap("n", "<M-,>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" }, opts)
keymap("n", "<M-.>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" }, opts)

-- Move to window using the <ctrl> hjkl keys
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true }, opts)
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true }, opts)
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true }, opts)
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true }, opts)

keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window", remap = true }, opts)
keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window", remap = true }, opts)
keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window", remap = true }, opts)
keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window", remap = true }, opts)


local function copy_buffer_path_to_clipboard()
    local curr_path = vim.fn.expand("%:p") -- Get file path
    if curr_path == "" then
        vim.notify("No file or directory selected", vim.log.levels.WARN)
        return
    end
    -- Escape the path for shell command
    local escaped_path = vim.fn.fnameescape(curr_path)
    vim.fn.setreg("+", escaped_path) -- Copy the relative path to the clipboard register
    if vim.v.shell_error ~= 0 then
        vim.notify("Copy failed: " .. result, vim.log.levels.ERROR)
    else
        vim.notify("Path copied to clipboard: " .. curr_path, vim.log.levels.INFO)
    end
end



vim.keymap.set("n", "<M-c>", copy_buffer_path_to_clipboard, { desc = "Copy path to clipboard", noremap = true, silent = true })
