return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require("dap")
        local dap_breakpoints = require("dap.breakpoints")
        local breakpoint_store = vim.fn.stdpath("data") .. "/dap_breakpoints.json"

        local function save_breakpoints()
            local breakpoints = {}
            for bufnr, bps in pairs(dap_breakpoints.get()) do
                local path = vim.api.nvim_buf_get_name(bufnr)
                if path ~= "" then
                    breakpoints[path] = {}
                    for _, bp in ipairs(bps) do
                        table.insert(breakpoints[path], {
                            line = bp.line,
                            condition = bp.condition,
                            hitCondition = bp.hitCondition,
                            logMessage = bp.logMessage,
                        })
                    end
                end
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
                local ok, breakpoints = pcall(vim.json.decode, content)
                if ok and breakpoints then
                    for path, bps in pairs(breakpoints) do
                        local bufnr = vim.fn.bufadd(path)
                        if bufnr > 0 then
                            for _, bp in ipairs(bps) do
                                dap_breakpoints.set({
                                    condition = bp.condition,
                                    hit_condition = bp.hitCondition,
                                    log_message = bp.logMessage,
                                }, bufnr, bp.line)
                            end
                        end
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

        vim.keymap.set("n", "<leader>dap", dap.continue, { desc = "DAP: Continue/Start" })
        vim.keymap.set("n", "<leader>bp", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>db", dap.list_breakpoints, { desc = "DAP: List Breakpoints" })
        vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "DAP: Open REPL" })
        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
        vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "DAP: Step Over" })
        vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
        vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "DAP: Step Out" })
    end,
}
