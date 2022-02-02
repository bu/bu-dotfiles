-- Bu's neovim configuration

local vim = vim
local g = vim.g
local cmd = vim.cmd
local key = vim.api.nvim_set_keymap

-- Helpers ------------------
	function wopt(name, value) 
		vim.api.nvim_win_set_option(0, name, value)
	end

	function opt(name, value)
		vim.api.nvim_set_option(name, value)
	end

-- Disable build in plugins ----
vim.g.loaded_zip = 1
vim.g.loaded_gzip = 1
vim.g.loaded_man = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_remote_plugins = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tarPlugin= 1
vim.g.loaded_2html_plugin= 1
vim.g.loaded_tutor_mode_plugin= 1

-- Editor -------------------
	-- always show line number
	wopt("number", true)
	-- always show tab line
	opt("showtabline", 2)
	-- default tab size
	opt("tabstop", 4)
	opt("softtabstop", 4)
	opt("shiftwidth", 4)

	-- some guiding lines
	wopt("cursorline", true)
	wopt("colorcolumn", "81,121")
	cmd("highlight ColorColumn ctermbg=239")

	-- start autoindent and smartindent
	opt("autoindent", true)
	opt("smartindent", true)

	-- fold by indent
	wopt("foldmethod", "indent")

	-- disable arrow key in normal mode, we should use hjkl instead
	key("n", "<Left>", "<Nop>", { noremap = true })
	key("n", "<Up>", "<Nop>", { noremap = true })
	key("n", "<Down>", "<Nop>", { noremap = true })
	key("n", "<Right>", "<Nop>", { noremap = true })

	-- use ; as :
	key("n", ";", ":", { noremap = true })
	-- use jk to simluate <esc>, useful on ipad pro
	key("i", "jk", "<Esc>", { noremap = true, silent = true })

	-- tab for indent and outdent
	key("n", "<Tab>", "v>", {})
	key("v", "<tab>", "v>", {})
	key("n", "<S-Tab>", "v<", {})
	key("v", "<s-tab>", "v<", {})


-- NetRW --------------------
	-- use previous split to open document
	g.netrw_browse_split = 4
	-- tree view
	g.netrw_liststyle = 3
	-- no netrw banner (folder stats)
	g.netrw_banner = 0
	-- limit netrw to approx 25% of the window
	g.netrw_winsize = 25
	-- 
	g.netrw_altv = 1
	-- map 1 to toggle tree view
	key("n", "1", ":Le<CR>", { noremap = true, silent = true })

-- Packaging 

local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
  -- My plugins here
  -- use 'foo1/bar1.nvim'
  -- use 'foo2/bar2.nvim'
  --
  use { "wbthomason/packer.nvim" }
  use { "neovim/nvim-lspconfig" }
  use { "jacoborus/tender.vim" }
  use { "neoclide/vim-jsx-improve" }
  use { "editorconfig/editorconfig-vim" }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

-- colorscheme
vim.cmd[[colorscheme tender]]

-- no mouse
vim.cmd[[set mouse=]]

-- show all tabs
vim.cmd[[set list]]

-- Golang
require("lspconfig").gopls.setup{}

function goimports(timeout_ms)
    local context = { only = { "source.organizeImports" } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or next(result) == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit)
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
end

vim.cmd("autocmd BufWritePre *.go lua goimports(1000)")
vim.cmd("autocmd BufWritePost * lua vim.lsp.buf.formatting()")
vim.cmd("autocmd FileType go setlocal omnifunc=v:lua.vim.lsp.omnifunc")

-- load 

