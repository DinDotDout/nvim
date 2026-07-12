local opt = vim.opt
vim.bo.commentstring = "// %s"
opt.shiftwidth = 4
opt.tabstop = 4
vim.opt_local.makeprg = "bear -- gcc -g -std=c99 -fsanitize-recover=address,undefined -Wall -Wextra -Wdiv-by-zero % -o %:r"

local function find_buildfile()
    local candidates = {
        "build.sh",
        "build/build.sh",
        "scripts/build.sh",
        -- extend here: "Makefile", "build/Makefile", etc.
    }

    for _, path in ipairs(candidates) do
        if vim.fn.filereadable(path) == 1 then
            return path
        end
    end
    return nil
end

vim.api.nvim_create_user_command('Make', function()
    local buildfile = find_buildfile()

    if buildfile then
        -- Use the found build file directly
        vim.opt.makeprg = vim.fn.shellescape("./" .. buildfile)
        vim.cmd("make")
        return
    end
    if not vim.g.make_filename then
        vim.ui.input({ prompt = 'Make target name (no extension): ', completion = "file" }, function(input)
            if not input or input == '' then return end
            vim.g.make_filename = input
            vim.opt.makeprg = input
            -- "bear -- gcc -g -fsanitize-recover=address,undefined -Wall -Wextra -std=c99 " ..
            -- vim.fn.shellescape(vim.g.make_filename .. ".c") .. " -o " .. vim.fn.shellescape(vim.g.make_filename)
            --
            -- vim.opt.makeprg =
            --     "bear -- gcc -g -fsanitize-recover=address,undefined -Wall -Wextra -std=c99 " ..
            --     vim.fn.shellescape(vim.g.make_filename .. ".c") .. " -o " .. vim.fn.shellescape(vim.g.make_filename)
            vim.cmd('make')
        end)
        return
    end
    -- vim.opt.makeprg =
    --     "bear -- gcc -g -fsanitize-recover=address,undefined -Wall -Wextra -std=c99 " ..
    --     vim.fn.shellescape(vim.g.make_filename .. ".c") .. " -o " .. vim.fn.shellescape(vim.g.make_filename)
    vim.cmd("make")
end, {
    desc = "Run :make on current file without extension",
})

vim.keymap.set("n", "<leader>b", "<cmd>Make<CR>", { desc = "Run :Make command" })
vim.keymap.set("n", "<leader>B", function() vim.g.make_filename = nil end, { desc = "Run :Make command" })
