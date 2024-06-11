vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>", "<nop>", opts) -- Unmap leader

-- Macro keybinds and unbind Q
keymap("n", "Q", "@qj", { desc = "Execute 'q' macro and jump down" }, opts) -- Execute macro and jump down
keymap("x", "Q", ":norm @q<CR>", { desc = "Execute 'q' macro on selection" }, opts) -- Execute macro on selection

keymap("n", "<leader>lr", "<cmd>.lua<CR>", { desc = "Execute the current line" })
keymap("n", "<leader>lR", "<cmd>source %<CR>", { desc = "Execute the current file" })

keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete no copying" }, opts)

-- Replacement commands
keymap(
    "n",
    "<leader>r",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor" },
    opts
)
keymap(
    "v",
    "<leader>r",
    [[y:let @/ = @"<CR>:%s/<C-r>///gc<left><left><left>]],
    { desc = "Replace selected text" },
    opts
)

keymap(
    "n",
    "<leader>R",
    [[:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word under cursor cdo" },
    opts
)

-- Better up down movement
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true }, opts)
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true }, opts)
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }, opts)
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true }, opts)

-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "Move down" }, opts)
keymap("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "Move up" }, opts)
keymap("i", "<A-j>", "<esc><cmd>m .+1<CR>==gi", { desc = "Move down" }, opts)
keymap("i", "<A-k>", "<esc><cmd>m .-2<CR>==gi", { desc = "Move up" }, opts)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" }, opts)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" }, opts)

-- buffers
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Prev buffer" }, opts)
keymap("n", "<leader>bn", "<cmd>bprevious<CR>", { desc = "Next buffer" }, opts)

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<cmd>noh<CR><esc>", { desc = "Escape and clear hlsearch" }, opts)

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
keymap(
    "n",
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / clear hlsearch / diff update" },
    opts
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" }, opts)
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" }, opts)
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" }, opts)
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" }, opts)
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" }, opts)
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" }, opts)

-- Add undo break-points
keymap("i", ",", ",<c-g>u", opts)
keymap("i", ".", ".<c-g>u", opts)
keymap("i", ";", ";<c-g>u", opts)

-- save file
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<CR><esc>", { desc = "Save file" }, opts)

--keywordprg
keymap("n", "<leader>K", "<cmd>norm! K<CR>", { desc = "Keywordprg" }, opts)

-- better indenting
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- lazy
-- keymap("n", "<leader>l", "<cmd>Lazy<CR>", { desc = "Lazy" }, opts)

-- new file
keymap("n", "<leader>fn", "<cmd>enew<CR>", { desc = "New File" }, opts)

keymap("n", "<leader>cq", "<cmd>copen<CR>", { desc = "Quickfix List" }, opts)

keymap("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" }, opts)
keymap("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" }, opts)

-- formatting
-- keymap({ "n", "v" }, "<leader>cf", function()
--  Util.format({ force = true })
--end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" }, opts)
keymap("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" }, opts)
keymap("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" }, opts)
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" }, opts)
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" }, opts)
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" }, opts)
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" }, opts)

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
keymap("n", "<leader>uT", function()
    if vim.b.ts_highlight then
        vim.treesitter.stop()
    else
        vim.treesitter.start()
    end
end, { desc = "Toggle Treesitter Highlight" }, opts)

-- highlights under cursor
keymap("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" }, opts)

-- quit
keymap("n", "<leader>Q", "<cmd>confirm qall<CR>", { desc = "Quit all" }, opts)
keymap("n", "<leader>q", "<cmd>quit<CR>", { desc = "Close window/Quit", noremap = true, silent = true }, opts)
-- keymap("n", "<leader>bd", "<cmd>bd<Cr>", { desc = "Delete buffer", remap = true }, opts)
keymap("n", "<leader>bd", "<cmd>bnext | bd #<Cr>", { desc = "Delete buffer", remap = true }, opts)
-- keymap("n", "<leader>bd", "<cmd>if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1 | bnext | endif | bd #<Cr>", { desc = "Delete buffer", remap = true }, opts)

keymap("n", "-", "<C-W>s", { desc = "Split window down", remap = true }, opts)
keymap("n", "\\", "<C-W>v", { desc = "Split window right", remap = true }, opts)
--
-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" }, opts)
keymap("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" }, opts)
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" }, opts)
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" }, opts)

-- Move to window using the <ctrl> hjkl keys
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true }, opts)
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true }, opts)
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true }, opts)
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true }, opts)

keymap("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window", remap = true }, opts)
keymap("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window", remap = true }, opts)
keymap("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window", remap = true }, opts)
keymap("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window", remap = true }, opts)
