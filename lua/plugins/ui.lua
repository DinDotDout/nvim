local logo = [[
                           .::-::-::.                             
                     :=*#@@@@@@@@@@@@@@@@#+                       
                .-.   -#@@@@@@@@@@@@@@@@@@@:  %*=.                
             .=%@@@#=.  .=#@@@@@@@@@@@@@@@@*  +@@@%+.             
           -#@@@@@@@@@#-   .=%@@@@@@@@@@@@@@  .@@@@@@#-           
         =%@@@@@@@@@@@@@@*-   .+%@@@@@@@@@@@-  #@@@@@@@@=         
       -%@@@@@@@@@@@@@@@@@@@#-   .=%@@@@@@@@%  -@@@@@@@@@%-       
      *@@@@@@@@@@@@@@@@@@@@@@@@*:   .+@@@@@@@.  @@@@@@@@@@@*      
    .%@@@@@@@@@@@@@@@@@%%*+==-:.       :+%@@@=  *@@@@@@@@@@@%.    
   :@@@@@@@@@%#*+=-:.                     :+%%  :@@@@@@@@@@@@#    
  .#**==-:.      .::                         :   %@@@@@@@@@@=     
       .:-=+*#%@@@#                              +@@@@@@@@%.  =@. 
 =*#%@@@@@@@@@@@@=          几乇ㄖᐯ丨爪          .@@@@@@@#  .#@@# 
.@@@@@@@@@@@@@@@:                                 #@@@@@=  -@@@@@:
+@@@@@@@@@@@@@#                  |                =@@@@:  +@@@@@@*
%@@@@@@@@@@@@+                  |||                @@*  .#@@@@@@@@
@@@@@@@@@@@%:                  |||||               *-  -@@@@@@@@@@
@@@@@@@@@@#   *              -|||󰆤|||-                +@@@@@@@@@@@
%@@@@@@@@+  :%@-               |||||                .%@@@@@@@@@@@@
*@@@@@@@-  +@@@*                |||                -@@@@@@@@@@@@@#
-@@@@@#.  #@@@@@                 |                *@@@@@@@@@@@@@@=
 %@@@*  :%@@@@@@-                               .%@@@@@@@@@@@@@@@ 
 -@@-  =@@@@@@@@#           几乇ㄖᐯ丨爪        -@@@@@@@%#*+=--..  
  -   *@@@@@@@@@@.                            -*+=-:.      .:-=:  
    :%@@@@@@@@@@@+  **-                         ..-==+##%@@@@@*   
    =@@@@@@@@@@@@%  :@@@*-            ..-=+*#%@@@@@@@@@@@@@@@*    
     :@@@@@@@@@@@@.  @@@@@@*-    :*%@@@@@@@@@@@@@@@@@@@@@@@@-     
       *@@@@@@@@@@+  +@@@@@@@@*-   -*@@@@@@@@@@@@@@@@@@@@@#.      
        :%@@@@@@@@@  .@@@@@@@@@@@*-   -#@@@@@@@@@@@@@@@@%-        
          -#@@@@@@@:  %@@@@@@@@@@@@@+:   =#@@@@@@@@@@@#-          
            .=%@@@@#  +@@@@@@@@@@@@@@@@*:   =#@@@@@%+.            
               .=#@@. .@@@@@@@@@@@@@@@@@@@*:   -*+:               
                   :.  #@@@@@@@@@@@@@@@@@@@@*                     
                        :-==+**####***==-:",                      ]]

return {
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            -- -@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = function()
            vim.g.lualine_laststatus = vim.o.laststatus
            if vim.fn.argc(-1) > 0 then
                -- set an empty statusline till lualine loads
                vim.o.statusline = " "
            else
                -- hide the statusline on the starter page
                vim.o.laststatus = 0
            end
        end,
        opts = function()
            -- PERF: we don't need this lualine require madness 🤷
            local lualine_require = require("lualine_require")
            lualine_require.require = require

            vim.o.laststatus = vim.g.lualine_laststatus

            return {
                options = {
                    -- theme = "auto",
                    theme = "everforest",
                    globalstatus = true,
                    disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },

                    lualine_c = {
                        "filename",
                        {
                            "diagnostics",
                            symbols = {
                                error = " ",
                                warn = " ",
                                info = " ",
                                hint = "",
                            },
                        },
                    },
                    lualine_x = {
                        -- stylua: ignore
                        {
                            "diff",
                            symbols = {
                                added = " ",
                                modified = " ",
                                removed = " ",
                            },
                            source = function()
                                local gitsigns = vim.b.gitsigns_status_dict
                                if gitsigns then
                                    return {
                                        added = gitsigns.added,
                                        modified = gitsigns.changed,
                                        removed = gitsigns.removed,
                                    }
                                end
                            end,
                        },
                    },
                    lualine_y = {
                        { "progress", separator = " ", padding = { left = 1, right = 0 } },
                        { "location", padding = { left = 0, right = 1 } },
                    },
                    lualine_z = {
                        function()
                            return " " .. os.date("%R")
                        end,
                    },
                },
                extensions = { "neo-tree", "lazy" },
            }
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                -- ["gs"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                -- ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        opts = function()
            logo = string.rep("\n", 8) .. logo .. "\n\n"

            local opts = {
                theme = "doom",
                hide = {
                    -- this is taken care of by lualine
                    -- enabling this messes up the actual laststatus setting after loading a file
                    statusline = false,
                },
                config = {
                    header = vim.split(logo, "\n"),
                    -- stylua: ignore
                    center = {
                        { action = "Telescope find_files",                                     desc = " Find file",       icon = " ", key = "." },
                        { action = "Telescope live_grep",                                      desc = " Find text",       icon = " ", key = "/" },
                        { action = "Telescope oldfiles",                                       desc = " Recent files",    icon = " ", key = "r" },
                        { action = "Lazy",                                                     desc = " Lazy",            icon = "󰒲 ", key = "l" },
                        { action = "qa",                                                       desc = " Quit",            icon = " ", key = "q" },
                    },
                    footer = function()
                        local stats = require("lazy").stats()
                        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                        return {
                            "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
                        }
                    end,
                },
            }

            for _, button in ipairs(opts.config.center) do
                button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
                button.key_format = "  %s"
            end

            -- close Lazy and re-open when the dashboard is ready
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "DashboardLoaded",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            return opts
        end,
    },
}
