return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")

        conform.setup({
            formatters_by_ft = {
                lua = { "stylua" },
                json = { { "prettierd", "prettier" } },
                markdown = { { "prettierd", "prettier" } },
                rust = { "rustfmt" },
                yaml = { "yamlfix" },
                toml = { "taplo" },
                css = { { "prettierd", "prettier" } },
                scss = { { "prettierd", "prettier" } },
                bash = { "shfmt" },
                gdscript = { "gdformat" },
                cmake = { "cmakelang" },
                cpp = { "clang-format" },
            },
        })

        format_on_save = {
            lsp_fallback = true,
            async = false,
            timout_ms = 500,
        }

        vim.keymap.set({ "n", "v", "x" }, "<leader>cf", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                timeout_ms = 1000,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
