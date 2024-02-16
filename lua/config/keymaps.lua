vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("n", "<leader>", "<nop>") -- Unmap leader

-- Macro keybinds and unbind Q
keymap("n", 'Q', '@qj', {desc = "Execute 'q' macro and jump down"}) -- Execute macro and jump down
keymap("x", 'Q', ':norm @q<CR>', {desc = "Execute 'q' macro on selection"}) -- Execute macro on selection

keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete no copying" })

-- Allow some small movement in insert mode
--keymap("i", "<A-h>", "<C-o>h")
--keymap("i", "<A-j>", "<C-o>j")
--keymap("i", "<A-k>", "<C-o>k")
--keymap("i", "<A-l>", "<C-o>l")

-- keymap("n", "<C-H>", "db", opts)
-- keymap("i", "<C-H>", "<C-W>", opts)

-- Replacement commands
keymap("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word under cursor" })
keymap("v", "<leader>r", [[y:let @/ = @"<CR>:%s/<C-r>///gc<left><left><left>]], { desc = "Replace selected text" })

keymap(
  "n",
  "<leader>R",
  [[:cdo s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor cdo" }
)


-- Git commands
keymap("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Open Neogit" })

-- Copilot
keymap("i", "<C-a>", 'copilot#Accept("<CR>")', { expr = true, replace_keycodes = false, desc = "Copilot accept" })

-- Better up down movement
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })


-- Move Lines
keymap("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
keymap("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
keymap("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
keymap("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
keymap("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
keymap("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
-- should probably remove and not use bufferline
keymap("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
keymap("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
--keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
--keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
--keymap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
--keymap("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Clear search with <esc>
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
keymap(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next search result" })
keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev search result" })
keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

--keymap("n", "n", "nzzzv")
--keymap("n", "n", "nzzzv")
--keymap("n", "N", "Nzzzv")


-- Add undo break-points
keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")

-- save file
keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

--keywordprg
keymap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- lazy
keymap("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })


keymap("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

keymap("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
keymap("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

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
keymap("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
keymap("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- stylua: ignore start
-- toggle options
--keymap("n", "<leader>ul", function() Util.toggle.number() end, { desc = "Toggle Line Numbers" })
--keymap("n", "<leader>ud", function() Util.toggle.diagnostics() end, { desc = "Toggle Diagnostics" })

--keymap("n", "<leader>uf", function() Util.format.toggle() end, { desc = "Toggle auto format (global)" })
--keymap("n", "<leader>uF", function() Util.format.toggle(true) end, { desc = "Toggle auto format (buffer)" })
--keymap("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
--keymap("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
-- keymap("n", "<leader>uL", function() Util.toggle("relativenumber") end, { desc = "Toggle Relative Line Numbers" })


local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
----keymap("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
----if vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint then
----  keymap( "n", "<leader>uh", function() Util.toggle.inlay_hints() end, { desc = "Toggle Inlay Hints" })
----end
keymap("n", "<leader>uT", function() if vim.b.ts_highlight then vim.treesitter.stop() else vim.treesitter.start() end end, { desc = "Toggle Treesitter Highlight" })
----keymap("n", "<leader>ub", function() Util.toggle("background", false, {"light", "dark"}) end, { desc = "Toggle Background" })


-- highlights under cursor
keymap("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- LazyVim Changelog
--keymap("n", "<leader>L", function() Util.news.changelog() end, { desc = "LazyVim Changelog" })


-- quit
keymap("n", "<leader>Q", "<cmd>confirm qall<cr>", { desc = "Quit all" })
keymap('n', '<leader>q', '<cmd>quit<CR>', { desc = "Close window/Quit", noremap = true, silent = true})
keymap("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Delete buffer", remap = true })

keymap("n", "-", "<C-W>s", { desc = "Split window down", remap = true })
keymap("n", "\\", "<C-W>v", { desc = "Split window right", remap = true })
-- Resize window using <ctrl> arrow keys
keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })


-- Move to window using the <ctrl> hjkl keys
keymap("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
keymap("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
keymap("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
keymap("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })


-- tabs
--keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
--keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
--keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
--keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
--keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
--keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
