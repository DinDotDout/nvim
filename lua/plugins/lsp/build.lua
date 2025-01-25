-- TODO: Make stdout go to terminal not quickfix
return {
    -- Task set_module_param cmake target chose target * chose trget *
    {
        "Shatur/neovim-tasks",
        dependencies = {
            "mfussenegger/nvim-dap", -- Must be first to load to have everything configured
        },
        lazy = true,
        config = function()
            local Path = require("plenary.path")
            require("tasks").setup({
                default_params = {                                                             -- Default module parameters with which `neovim.json` will be created.
                    cmake = {
                        cmd = "cmake",                                                         -- CMake executable to use, can be changed using `:Task set_module_param cmake cmd`.
                        build_dir = tostring(Path:new("{cwd}", "build", "{os}-{build_type}")), -- Build directory. The expressions `{cwd}`, `{os}` and `{build_type}` will be expanded with the corresponding text values. Could be a function that return the path to the build directory.
                        build_type = "Debug",                                                  -- Build type, can be changed using `:Task set_module_param cmake build_type`.
                        -- dap_name = "codelldb",                                                 -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
                        dap_name = "cppdbg",                                                 -- DAP configuration name from `require('dap').configurations`. If there is no such configuration, a new one with this name as `type` will be created.
                        args = {                                                               -- Task default arguments.
                            configure = { "-D", "CMAKE_EXPORT_COMPILE_COMMANDS=1", "-G", "Ninja" },
                        },
                    },
                },
                -- save_before_run = true, -- If true, all files will be saved before executing a task.
                params_file = "neovim-tasks.json", -- JSON file to store module and task parameters.
                quickfix = {
                    pos = "bot",                   -- Default quickfix position.
                    height = 12,                   -- Default height.
                },
                dap_open_command = function()
                end,
            })
        end,
        keys = {
            {
                "<leader>xs",
                mode = { "n", "v" },
                "<cmd>Task set_module_param cmake target<cr>",
                desc = "Run set module param cmake target",
            },
            {
                "<leader>xm",
                mode = { "n", "v" },
                "<cmd>Task start cmake configure<cr>",
                desc = "Rerun cmake configure",
            },
            {
                "<leader>xc",
                mode = { "n", "v" },
                "<cmd>Task cancel<cr>",
                desc = "Cancel task",
            },
            {
                "<leader>xr",
                mode = { "n", "v" },
                "<cmd>Task start cmake run<cr>",
                desc = "Cmake run",
            },
            {
                "<leader>xb",
                mode = { "n", "v" },
                "<cmd>Task start cmake build<cr>",
                desc = "Cmake build",
            },
            {
                "<leader>xd",
                mode = { "n", "v" },
                "<cmd>Task start cmake debug<cr>",
                desc = "Cmake build and debug",
            },
        },
    },
}
