return {
    {
        "github/copilot.vim",
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        opts = {
            show_help = "yes",         -- Show help text for CopilotChatInPlace, default: yes
            debug = false,             -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
            disable_extra_info = "no", -- Disable extra information (e.g: system prompt) in the response.
            -- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
        },
        build = function()
            vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
        end,
        event = "VeryLazy",
        keys = {
            {
                "<leader>cc",
                ":CopilotChatInPlace<cr>",
                mode = "x",
                desc = "CopilotChat - Run in-place code",
            },
        },
    },
}
