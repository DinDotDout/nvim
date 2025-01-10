return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
        end,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        opts = {
            debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
            disable_extra_info = "yes", -- Disable extra information (e.g: system prompt) in the response.
            window = { layout = "float" },
            auto_follow_cursor = false,
            -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
        },
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        build = function()
            vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        end,
        event = "VeryLazy",
        keys = {
            {
                "<leader>at",
                ":CopilotChatToggle<cr>",
                mode = { "n" },
                desc = "CopilotChat - Toggle",
            },
            {
                "<leader>as",
                ":CopilotChatStop<cr>",
                mode = { "n" },
                desc = "CopilotChat - Stop Answering",
            },
            {
                "<leader>am",
                ":CopilotChatCommitStaged<cr>",
                mode = { "n" },
                desc = "CopilotChat - Write commit message",
            },
            {
                "<leader>ac",
                mode = { "n", "v", "x" },
                function()
                    local input = vim.fn.input("Quick Chat: ")
                    if input ~= "" then
                        if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == "^V" then
                            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual  })
                        else
                            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
                        end
                    end
                end,
                desc = "CopilotChat - Quick chat",
            },

            -- Show help actions with telescope
            -- {
            --     "<leader>ah",
            --     function()
            --         local actions = require("CopilotChat.actions")
            --         require("CopilotChat.integrations.telescope").pick(actions.help_actions())
            --     end,
            --     desc = "CopilotChat - Help actions",
            -- },
            -- Show prompts actions with telescope
            -- {
            --     "<leader>aa",
            --     function()
            --         local actions = require("CopilotChat.actions")
            --         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
            --     end,
            --     desc = "CopilotChat - Prompt actions",
            -- },
        },
    },
}
