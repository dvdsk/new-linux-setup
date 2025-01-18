local dap = require("dap")

dap.configurations.lua = {
	{
		type = "nlua",
		request = "attach",
		name = "Attach to running Neovim instance",
		host = function()
			return "127.0.0.1"
		end,
		port = function()
			return 4242
		end,
	},
}

-- erust or `embedded rust` made up name. Config for debugging
-- embedded rust code running on stm32 via probe-rs
dap.configurations.rust = {
	{
		type = "probe_rs",
		request = "launch",
		name = "probe_rs flash and launch",
		flashingConfig = {
			flashingEnabled = true,
		},
		chip = "STM32F401CCUx",
		coreConfigs = {
			{
				programBinary = "target/thumbv7em-none-eabihf/release/bed-sensors"
			},
		},
		program = function()
			return "target/thumbv7em-none-eabihf/release/bed-sensors"
		end,
		cwd = '${workspaceFolder}',
		host = function()
			return "127.0.0.1"
		end,
		port = function()
			return 4242
		end,
	}
}

dap.adapters.nlua = function(callback, config)
	callback({ type = "server", host = config.host, port = config.port })
end

-- dap.adapters.probe_rs = {
-- 	type = "executable",
-- 	command = "probe-rs",
-- 	env = { "RUST_LOG=trace" },
-- 	args = { "dap-server", "--port", "4242" , "--log-file", "daplog.txt"}
-- }

dap.adapters.probe_rs = {
	type = "server",
	port = 4242,
	-- executable = {
	-- 	command = "probe-rs",
	-- 	env = { "RUST_LOG=trace" },
	-- 	args = { "dap-server", "--port", "4242" , "--log-file", "daplog.txt"}
	-- }
}

require("dapui").setup()
