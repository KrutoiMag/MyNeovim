return {
	"neovim/nvim-lspconfig",
	config = function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		vim.lsp.config("clangd", {
			cmd = { "clangd-21" },
		})
		vim.lsp.enable("clangd", { capabilities = capabilities })
		vim.lsp.enable("lua_ls")
		vim.lsp.enable('bashls')
	end,
}
