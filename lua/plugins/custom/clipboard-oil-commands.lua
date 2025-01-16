M = {}
function get_oil_entry_path(line)
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
    return entry.name
end

local function get_selected_oil_entries(start_line, end_line)
    local paths = {}
    for l = start_line, end_line do
        local path = get_oil_entry_path(l)
        if path then
            table.insert(paths, vim.fn.fnameescape(path))
        end
    end
    return paths
end

local function format_paths(paths, delimiter, pre, post)
    delimiter = delimiter or "\n"
    pre = pre or "'"
    post = post or "'"

    local formatted_paths = {}
    for _, path in ipairs(paths) do
        table.insert(formatted_paths, pre .. path .. post)
    end
    return table.concat(formatted_paths, delimiter)
end


local function is_empty_or_nil(s)
    return not s or s == ""
end

local function copy_files_to_clipboard_cmd(paths)
    if is_empty_or_nil(paths) then
        vim.notify("No file or directory selected", vim.log.levels.WARN)
        return
    end

    local oil = require("oil")
    local path = oil.get_current_dir(vim.api.nvim_get_current_buf())

    local cmd
    if M.get_os() == "Windows_NT" then
        cmd = string.format('powershell -command "Set-Location -Path %s; Set-Clipboard -Path @(%s)"', path, paths)
    else -- Assumed linux
        cmd = string.format("wl-copy -t text/uri-list <<< '%s'", paths)
    end

    local result = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify("Copy failed: " .. result, vim.log.levels.ERROR)
    else
        vim.notify("Copied to system clipboard " .. paths, vim.log.levels.INFO)
    end
end

local function compress_files_and_copy_to_clipboard_cmd(formated_entries)
    local timestamp = os.date("%y%m%d%H%M%S") -- Append timestamp to avoid duplicates

    local temp_dir = os.getenv("TEMP") or os.getenv("TMP") or "/tmp"
    local zip_path = string.format("%s/%s_%s.zip", temp_dir, "tmp_compression", timestamp)

    local oil = require("oil")
    local path = oil.get_current_dir(vim.api.nvim_get_current_buf())

    -- Create the zip file
    local zip_cmd = ""
    if vim.loop.os_uname().sysname == "Windows_NT" then
        zip_cmd = string.format(
            'powershell -command "Set-Location -Path %s; Compress-Archive -Path @(%s) -DestinationPath %s"',
            path,
            vim.fn.shellescape(formated_entries),
            vim.fn.shellescape(zip_path)
        )
    else
        zip_cmd = string.format( -- fix
            "cd %s && zip -r %s %s",
            path,
            vim.fn.shellescape(zip_path),
            formated_entries
        )
        print(zip_cmd)
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

    local copy_result = vim.fn.system(copy_cmd)
    if vim.v.shell_error ~= 0 then
        vim.notify(
            "Failed to copy zip file to clipboard: " .. copy_result,
            vim.log.levels.ERROR
        )
        return
    end
    vim.notify("Zipped and copied to clipboard " .. zip_path, vim.log.levels.INFO)
end

M.get_os = function()
    return vim.loop.os_uname().sysname
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

    local path = oil.get_current_dir(vim.api.nvim_get_current_buf())
    return path..entry.name
end

M.compress_file_and_copy_to_clipboard = function()
    local start_line, end_line = M.get_selected_line_indices()
    local entries = get_selected_oil_entries(start_line, end_line)
    local delimiter = " "
    if M.get_os() == "Windows_NT" then
        delimiter = ", "
    end
    local formated_entries = format_paths(entries, delimiter)
    compress_files_and_copy_to_clipboard_cmd(formated_entries)
end

M.copy_selected_files_to_clipoard = function()
    local start_line, end_line = M.get_selected_line_indices()
    local entries = get_selected_oil_entries(start_line, end_line)
    local oil = require("oil")
    local path = oil.get_current_dir(vim.api.nvim_get_current_buf())

    local delimiter = "\n"
    local pre = "file://'" .. path
    if M.get_os() == "Windows_NT" then
        delimiter = ", "
    end
    local formated_entries = format_paths(entries, delimiter, pre)
    copy_files_to_clipboard_cmd(formated_entries)
end
return M
