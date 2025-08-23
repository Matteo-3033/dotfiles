-- Floating terminal
-- Press <leader>tt to toggle the terminal
return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        local Terminal = require("toggleterm.terminal").Terminal

        -- terminale persistente id=1, float, start in insert
        local float_term = Terminal:new({
            id = 1,
            direction = "float",
            start_in_insert = true,
            close_on_exit = true,
            float_opts = { border = "curved" },
        })

        local toggle_smart = function()
            float_term:toggle()
            vim.cmd("startinsert")
        end

        -- mapping normal mode
        vim.keymap.set("n", "<leader>tt", toggle_smart, { desc = "Toggle smart floating terminal" })

        -- mapping terminal mode: torna in normal mode e richiama toggle
        vim.keymap.set(
            "t",
            "<leader>tt",
            [[<C-\><C-n>:lua require("toggleterm.terminal").get(1):toggle()<CR>i]],
            { desc = "Toggle smart floating terminal in insert" }
        )
    end,
}
