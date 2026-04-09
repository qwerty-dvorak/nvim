return {
    cmd = function(dispatchers, config)
        local workspace = vim.fn.stdpath("cache") .. "/jdtls/workspace"
        local data_dir = workspace

        if config.root_dir then
            data_dir = data_dir .. "/" .. vim.fn.fnamemodify(config.root_dir, ":p:h:t")
        end

        local cmd = {
            "jdtls",
            "-data",
            data_dir,
        }

        return vim.lsp.rpc.start(cmd, dispatchers, {
            cwd = config.cmd_cwd,
            env = config.cmd_env,
            detached = config.detached,
        })
    end,
    filetypes = { "java" },
    root_markers = {
        { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" },
        { "build.xml", "pom.xml", "build.gradle", "build.gradle.kts" },
    },
    init_options = {},
}
