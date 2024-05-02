return {
    {
        -- "github/copilot.vim",
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },

    -- {
    -- "zbirenbaum/copilot-cmp",
    -- opts ={},
    -- },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        opts = {
            debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
            disable_extra_info = "yes", -- Disable extra information (e.g: system prompt) in the response.
            window = { layout = "float" },
            -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
        },
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        -- build = function()
        --     vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        -- end,
        event = "VeryLazy",
        keys = {
            {
                "<leader>ct",
                ":CopilotChatToggle<cr>",
                mode = {"n"},
                desc = "CopilotChat - Run in-place code",
            },
            -- lazy.nvim keys

            -- TODO: Add prompt for search grep in Telescope
            -- Quick chat with Copilot
            {
                "<leader>cc",
                mode = {"n", "v", "x"},
                function()
                    local input = vim.fn.input("Quick Chat: ")
                    if input ~= "" then
                        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
                    end
                end,
                desc = "CopilotChat - Quick chat",
            },
            -- lazy.nvim keys

            -- Show help actions with telescope
            -- {
            --     "<leader>cch",
            --     function()
            --         local actions = require("CopilotChat.actions")
            --         require("CopilotChat.integrations.telescope").pick(actions.help_actions())
            --     end,
            --     desc = "CopilotChat - Help actions",
            -- },
            -- -- Show prompts actions with telescope
            -- {
            --     "<leader>ccp",
            --     function()
            --         local actions = require("CopilotChat.actions")
            --         require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
            --     end,
            --     desc = "CopilotChat - Prompt actions",
            -- },
        },
    },
}
