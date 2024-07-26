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
                -- "codelldb",
                "cpptools",
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
                "<F6>",
                function()
                    require("dap").run_last()
                end,
                desc = "Run Last",
            },
            {
                "<F7>",
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
            local sign = vim.fn.sign_define
            local dap_round_groups =
                { "DapBreakpoint", "DapBreakpointCondition", "DapBreakpointRejected", "DapLogPoint" }
            for _, group in pairs(dap_round_groups) do
                sign(group, { text = "●", texthl = group })
            end


            -- local dap = require("dap")
            -- dap.adapters.codelldb = {
            --     type = "server",
            --     port = "${port}",
            --     executable = {
            --         command = "codelldb",
            --         args = { "--port", "${port}" },
            --     },
            -- }
        end,
    },
}
