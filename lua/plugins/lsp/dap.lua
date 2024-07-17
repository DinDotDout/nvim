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
        "rcarriga/nvim-dap-ui",
        dependencies = "nvim-neotest/nvim-nio",
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
                "<F1>",
                function()
                    require("dapui").toggle({ reset = true })
                end,
                desc = "Toggle DAP UI",
            },
            {
                "<F14>",
                function()
                    require("dapui").eval()
                end,
                desc = "DAP Eval",
            },
        },
    },
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            -- Runs preLaunchTask / postDebugTask if present
            { "stevearc/overseer.nvim", config = true },
            "williamboman/mason.nvim",
        },
        keys = {
            {
                "<leader>ds",
                function()
                    local widgets = require("dap.ui.widgets")
                    widgets.centered_float(widgets.scopes, { border = "rounded" })
                end,
                desc = "DAP Scopes",
            },
            {
                "<F2>",
                function()
                    require("dap.ui.widgets").hover(nil, { border = "rounded" })
                end,
            },
            { "<F4>", "<CMD>DapTerminate<CR>", desc = "DAP Terminate" },
            {
                "<F5>",
                function()
                    require("dap").continue()
                end,
                -- "<CMD>DapContinue<CR>",
                desc = "DAP Continue",
            },
            {
                "<F17>",
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
            -- { "<F9>", "<CMD>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
            { "<leader>t", "<CMD>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
            {
                "<F21>",
                function()
                    vim.ui.input({ prompt = "Breakpoint condition: " }, function(input)
                        require("dap").set_breakpoint(input)
                    end)
                end,
                desc = "Conditional Breakpoint",
            },
            { "<F10>", "<CMD>DapStepOver<CR>", desc = "Step Over" },
            { "<F11>", "<CMD>DapStepInto<CR>", desc = "Step Into" },
            { "<F12>", "<CMD>DapStepOut<CR>", desc = "Step Out" },
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
