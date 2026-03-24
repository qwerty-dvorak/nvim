return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require("dap")
        local breakpoint_store = vim.fn.stdpath("data") .. "/dap_breakpoints.json"

        local function save_breakpoints()
            local breakpoints = {}
            for path, bps in pairs(dap.breakpoints) do
                breakpoints[path] = bps
            end
            local file = io.open(breakpoint_store, "w")
            if file then
                file:write(vim.json.encode(breakpoints))
                file:close()
            end
        end

        local function load_breakpoints()
            local file = io.open(breakpoint_store, "r")
            if file then
                local content = file:read("*all")
                file:close()
                local breakpoints = vim.json.decode(content)
                if breakpoints then
                    for path, bps in pairs(breakpoints) do
                        dap.breakpoints[path] = bps
                    end
                end
            end
        end

        load_breakpoints()

        vim.api.nvim_create_autocmd("VimLeavePre", {
            callback = save_breakpoints,
        })

        vim.api.nvim_set_hl(0, "DapBreakpoint", { link = "Error" })
        vim.api.nvim_set_hl(0, "DapStopped", { link = "Special" })

        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
        vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStoppedLine", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpoint", linehl = "", numhl = "" })

        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "--interpreter=dap", "--quiet" },
        }

        dap.configurations.c = {
            {
                name = "Launch GDB",
                type = "gdb",
                request = "launch",
                program = "/home/afish/.config/nvim/test",
                cwd = "${workspaceFolder}",
            },
        }

        vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP: Continue/Start" })
        vim.keymap.set("n", "<leader>bp", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>db", dap.list_breakpoints, { desc = "DAP: List Breakpoints" })
        vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
        vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "DAP: Step Over" })
        vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
        vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP: Step Out" })
    end,
}
