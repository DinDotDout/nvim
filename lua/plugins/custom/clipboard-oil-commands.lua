M = {}


M.get_os = function()
    return vim.loop.os_uname().sysname
end

M._get_os_delimiter = function()
    local concat_str = " "
    if M.get_os() == "Windows_NT" then
        concat_str = ", "
    end
    return concat_str
end

M._get_parsed_lines = function(start_line, end_line)
    local paths = {}
    local os_delimiter = M._get_os_delimiter()
    for l = start_line, end_line do
        local path = M.get_oil_entry_path(l)
        if path then
            local escaped_path = vim.fn.fnameescape(path)
            local path_string = "'" .. escaped_path .. "'"
            table.insert(paths, path_string)
        end
    end
    local concat = table.concat(paths, os_delimiter)
    return concat
end

local function is_empty_or_nil(s)
    return not s or s == ""
end

M.get_selected_line_indices = function()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    return start_line, end_line
end

M.get_oil_entry_path = function(line)
    local oil = require("oil")
    local entry
    if line then
        entry = oil.get_entry_on_line(0, line)
    else
        entry = oil.get_cursor_entry()
    end
    if not entry then return "" end

    if entry.name == ".." then
        vim.notify("No file or directory selected", vim.log.levels.WARN)
        return
    end
    local folder = oil.get_current_dir(vim.api.nvim_get_current_buf())
    local full_path = folder .. entry.name
    return full_path
end

-- TODO: modified
-- TODO: pass multiple to wl and do escaping here depending on os
M.copy_files_to_clipboard = function(paths)
    if is_empty_or_nil(paths) then
        vim.notify("No file or directory selected", vim.log.levels.WARN)
        return
    end

    local cmd
    if M.get_os() == "Windows_NT" then
        cmd = string.format('powershell -command "Set-Clipboard -Path @(%s)"', paths)
    else -- Assumed linux
        -- cmd = string.format("wl-copy -t text/uri-list <<< file://%s", paths)
        -- cmd = string.format("wl-copy -t text/uri-list <<< '%s'", "file://" .. paths)
        cmd = string.format("wl-copy -t text/uri-list <<< '%s'", "file://" .. paths:gsub(" ", "\nfile://")) -- Replace " " with \nfile://
    end
    -- local cmd =
    --     string.format([[osascript -e 'set the clipboard to POSIX file "%s"' ]], escaped_path)
    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("Copy failed: " .. result, vim.log.levels.ERROR)
    else vim.notify("Copied to system clipboard " .. paths, vim.log.levels.INFO)
    end
end


M.copy_selected_files_to_clipoard = function()
    local start_line, end_line = M.get_selected_line_indices()
    local parsed_lines = M._get_parsed_lines(start_line, end_line)
    M.copy_files_to_clipboard(parsed_lines)
end

M.compress_file_and_copy_to_clipboard = function()
    local start_line, end_line = M.get_selected_line_indices()
    local parsed_lines = M._get_parsed_lines(start_line, end_line)
    local timestamp = os.date("%y%m%d%H%M%S")     -- Append timestamp to avoid duplicates
    local temp_dir = os.getenv("TEMP") or os.getenv("TMP") or "/tmp"
    local zip_path = string.format("%s/%s_%s.zip", temp_dir, "tmp_compression", timestamp)

    -- Create the zip file
    local zip_cmd = ""
    if vim.loop.os_uname().sysname == "Windows_NT" then
        zip_cmd = string.format(
            'powershell -command "Compress-Archive -Path @(%s) -DestinationPath %s"',
            vim.fn.shellescape(parsed_lines),
            vim.fn.shellescape(zip_path)
        )
    else
        zip_cmd = string.format(-- fix
            "zip -r %s %s",
            vim.fn.shellescape(zip_path),
            parsed_lines
        )
    end
    local result = vim.fn.system(zip_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("Failed to create zip file: " .. result, vim.log.levels.ERROR)
        return
    end
    local copy_cmd
    --     string.format("wl-copy -t text/uri-list <<< file://%s", vim.fn.fnameescape(zip_path))
    if M.get_os() == "Windows_NT" then
        copy_cmd = string.format(
        'powershell -command "Set-Clipboard -Path %s"',
        vim.fn.fnameescape(zip_path)
    )
    else -- Assumed linux
        copy_cmd = string.format("wl-copy -t text/uri-list <<< file://%s", zip_path)
    end

    -- local copy_cmd = string.format(
    --     [[osascript -e 'set the clipboard to POSIX file "%s"' ]],
    --     vim.fn.fnameescape(zip_path)
    -- )
    local copy_result = vim.fn.system(copy_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify(
            "Failed to copy zip file to clipboard: " .. copy_result,
            vim.log.levels.ERROR
        )
        return
    end
    vim.notify("Zipped and copied to clipboard ".. zip_path, vim.log.levels.INFO)
end

return M
