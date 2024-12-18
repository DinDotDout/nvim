-- CPP DBG does not have stop events and shows less info
local function taskExistsOrNil(taskName)
    -- Get the path to the tasks.json file in the .vscode directory of the current working directory
    local tasksFile = vim.fn.getcwd() .. "/.vscode/tasks.json"

    -- Check if the tasks file exists
    if vim.fn.filereadable(tasksFile) == 0 then
        return nil
    end

    -- Read the tasks file
    local tasks = vim.fn.json_decode(vim.fn.readfile(tasksFile))

    -- Check if a task with the given name exists
    for _, task in ipairs(tasks.tasks) do
        if task.label == taskName then
            return taskName
        end
    end

    return nil
end

return {
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
            {
                "theHamsta/nvim-dap-virtual-text",
                config = function()
                    require("nvim-dap-virtual-text").setup({
                        commented = true,
                    })
                end,
            },
        },
        opts = {
            handlers = {},
            enssure_installed = {
                "codelldb",
                -- "cpptools",
                "cppdbg",
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- Runs preLaunchTask / postDebugTask if present
            { "stevearc/overseer.nvim", config = true },
            "williamboman/mason.nvim",
            "nvim-neotest/nvim-nio",
            {
                "rcarriga/nvim-dap-ui",
                -- dependencies = "nvim-telescope/telescope-dap.nvim",
                opts = {
                    icons = {
                        expanded = "󰅀",
                        collapsed = "󰅂",
                        current_frame = "󰅂",
                    },
                    -- layouts = {
                    --     {
                    --         elements = { "console", "watches" },
                    --         position = "bottom",
                    --         size = 15,
                    --     },
                    -- },
                    -- expand_lines = false,
                    -- controls = {
                    --     enabled = false,
                    -- },
                    -- floating = {
                    --     border = "rounded",
                    -- },
                    -- render = {
                    --     indent = 2,
                    -- Hide variable types as C++'s are verbose
                    -- max_type_length = 0,
                    -- },
                },
                keys = {
                    {
                        "<leader>tu",
                        function()
                            require("dapui").toggle({ reset = true })
                        end,
                        desc = "Toggle DAP UI",
                    },
                    {
                        "<leader>?",
                        function()
                            require("dapui").eval(nil, { enter = true })
                        end,
                        desc = "DAP Eval",
                    },
                },
            },
        },
        keys = {
            {
                "<leader>ts",
                function()
                    local widgets = require("dap.ui.widgets")
                    widgets.centered_float(widgets.scopes, { border = "rounded" })
                end,
                desc = "DAP Scopes",
            },
            -- {
            --     "<F2>",
            --     function()
            --         require("dap.ui.widgets").hover(nil, { border = "rounded" })
            --     end,
            -- },
            { "<F4>", "<CMD>DapTerminate<CR>", desc = "DAP Terminate" },
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                desc = "DAP Continue",
            },
            {
                "<F10>",
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
            },
            {
                "<F6>",
                function()
                    require("dap").run_to_cursor()
                end,
                desc = "Run to Cursor",
            },
            { "<leader>t", "<CMD>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
            { "<F1>", "<CMD>DapStepOver<CR>", desc = "Step Over" },
            { "<F2>", "<CMD>DapStepInto<CR>", desc = "Step Into" },
            { "<F3>", "<CMD>DapStepOut<CR>", desc = "Step Out" },
        },
        config = function()
            -- It appears that codelldb works as cpp tools for now, keep cpptools?
            -- Signs
            -- require('telescope').load_extension('dap')
            local sign = vim.fn.sign_define
            local dap_round_groups =
                { "DapBreakpoint", "DapBreakpointCondition", "DapBreakpointRejected", "DapLogPoint" }
            for _, group in pairs(dap_round_groups) do
                sign(group, { text = "●", texthl = group })
            end

            local dap = require("dap")
            vim.keymap.set("n", "<F7>", dap.step_back)

            -- Replace this with your own logic to check if the task exists
            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")
            local build_task = taskExistsOrNil("build") -- NOTE: Will need to reload plugin
            local dapui = require("dapui")
            -- dapui.setup()

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            local cppconfig = {
                name = "Dap CPP choose executable",
                type = "cppdbg",
                request = "launch",
                cwd = "${workspaceFolder}",
                preLaunchTask = build_task,
                stopOnEntry = false,
                program = function()
                    return coroutine.create(function(coro)
                        local opts = {}
                        pickers
                            .new(opts, {
                                prompt_title = "Path to executable",
                                finder = finders.new_oneshot_job(
                                    -- { "fd", "--hidden", "--no-ignore", "--type", "x" },
                                    { "fd", "--no-ignore", "--type", "x" },
                                    {}
                                ),
                                sorter = conf.generic_sorter(opts),
                                attach_mappings = function(buffer_number)
                                    actions.select_default:replace(function()
                                        actions.close(buffer_number)
                                        coroutine.resume(coro, action_state.get_selected_entry()[1])
                                    end)
                                    return true
                                end,
                            })
                            :find()
                    end)
                end,
            }

            local run_this = {
                name = "CPP Run this",
                type = "cppdbg",
                request = "launch",
                cwd = "${workspaceFolder}",
                preLaunchTask = build_task,
                stopOnEntry = false,
                program = function()
                    return vim.fn.expand("%:t:r") -- Get the filename without extension
                end,
            }

            dap.configurations.cpp = {
                cppconfig,
                run_this,
            }

            local function get_dap_type()
                local dap_types = {
                    cpp = "cppdbg",
                }
                local ext = vim.fn.expand("%:e")
                return dap_types[ext]
            end

            local function run_script()
                local dap_type = get_dap_type()
                if not dap_type then
                    print("No DAP type configured for this file type")
                    return
                end
                dap.run({
                    name = "CPP Run this",
                    type = dap_type,
                    request = "launch",
                    cwd = "${workspaceFolder}",
                    preLaunchTask = build_task,
                    stopOnEntry = false,
                    program = function()
                        return vim.fn.expand("%:t:r") -- Get the filename without extension
                    end,
                })
            end

            vim.keymap.set("n", "<leader>tr", function()
                run_script()
            end, { desc = "Run Script/Binary" })
        end,
    },
}
