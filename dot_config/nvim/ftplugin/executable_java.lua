local bundles = {
	vim.fn.glob(
		"/home/matteo/.config/nvim/ftplugin/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar",
		1
	),
}
vim.list_extend(
	bundles,
	vim.split(vim.fn.glob("/home/matteo/.config/nvim/ftplugin/vscode-java-test/server/*.jar", 1), "\n")
)

local config = {
	cmd = { "/usr/bin/jdtls" },
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
	settings = {
		java = {},
	},
	init_options = {
		bundles = bundles,
	},
}
require("jdtls").start_or_attach(config)
