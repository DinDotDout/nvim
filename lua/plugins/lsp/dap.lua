return {
    {
        "rcarriga/nvim-dap-ui",
        lazy = true,
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio",
        },
        opts = {
            icons = {
                expanded = "󰅀",
                collapsed = "󰅂",
                current_frame = "󰅂",
            },
            layouts = {
                -- Hide variable types as C++'s are verbose
                max_type_length = 0,
            },
        },
        config = function()
            local dapui = require("dapui")
            dapui.setup()
            vim.keymap.set("n", "<leader>tu", function()
                    require("dapui").toggle({ reset = true })
                end,
                { desc = "Toggle DAP UI" }, opts

            )
            vim.keymap.set("n",
                "<leader>?",
                function()
                    require("dapui").eval(nil, { enter = true })
                end,
                { desc = "DAP Eval" }
            )
            vim.keymap.set("n", "<leader>tt", require("dapui").elements.watches.add, { desc = "Add to watches" })
            vim.keymap.set("n", "<leader>tr",
                function()
                    local index = tonumber(vim.fn.input("Enter index of expression to remove: "))
                    require("dapui").elements.watches.remove(index)
                end
                , { desc = "Remove from watches" }
            )
            vim.keymap.set("n", "<leader>te",
                function()
                    local index = tonumber(vim.fn.input("Enter index of expression to remove: "))
                    require("dapui").elements.watches.edit(index, "test")
                end, { desc = "Edit watches" }
            )
        end
    },
    {
        "mfussenegger/nvim-dap", -- Must be first to load to have everything configured
        dependencies = {
            -- Runs preLaunchTask / postDebugTask if present
            -- { "stevearc/overseer.nvim", config = true },
            {
                "theHamsta/nvim-dap-virtual-text",
                config = function()
                    require("nvim-dap-virtual-text").setup({
                        commented = true,
                    })
                end,
            },
            "rcarriga/nvim-dap-ui",
            {
                "jay-babu/mason-nvim-dap.nvim", -- Predefined config to run for installed handlers
                dependencies = { "williamboman/mason.nvim" },
                opts = {
                    handlers = {},
                    enssure_installed = {
                        "codelldb",
                        -- "cppdbg",
                    },
                },
            },

        },
        lazy = true,
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
            { "<F4>",       "<CMD>DapTerminate<CR>",        desc = "DAP Terminate" },
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
            { "<leader>tb", "<CMD>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
            { "<F1>",       "<CMD>DapStepOver<CR>",         desc = "Step Over" },
            { "<F2>",       "<CMD>DapStepInto<CR>",         desc = "Step Into" },
            { "<F3>",       "<CMD>DapStepOut<CR>",          desc = "Step Out" },
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
            local dapui = require("dapui")
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
                -- require("zen-mode").
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end

            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
            local cppconfig = {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = true,
                setupCommands = {
                    {
                        text = '-enable-pretty-printing',
                        description = 'enable pretty printing',
                        ignoreFailures = false
                    },
                },
            }

            dap.configurations.cpp = {
                cppconfig,
                -- run_this,
            }
        end,
    },
}
