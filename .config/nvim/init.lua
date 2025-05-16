vim.cmd([[
		set number
		set encoding=utf-8
		set ruler
		set cursorline
		set relativenumber
		set visualbell
		set mouse=a
		set background=light
		set confirm
		set spell
		set cursorcolumn
	]])

require("config.lazy")

vim.cmd.colorscheme("tokyonight-day")

vim.api.nvim_create_user_command("ClangFormat", function()
	vim.cmd("%!clang-format-21")
end, {})

vim.cmd([[tnoremap <Esc> <C-\><C-n>]])
