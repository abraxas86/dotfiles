-- Initialize Plugin Managers (Packer & Vim-Plug)
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

local plug_path = vim.fn.stdpath('data')..'/site/autoload/plug.vim'
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
  vim.fn.system({'sh', '-c', 'curl -fLo ' .. plug_path .. ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'})
end

-- Ensure Packer is loaded
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Initialize Packer and define plugins
packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  use 'preservim/nerdtree'      -- NERDTree plugin for file navigation
  
  -- Theme configuration
  use {
    'scottmckendry/cyberdream.nvim',
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
      })
    end
  }

-- Initialize Vimplug Plugins:
vim.cmd [[
  call plug#begin(stdpath('data') . '/plugged')

  Plug 'vimwiki/vimwiki'     " Vimwiki

  call plug#end()
]]


  -- Indentation Guides
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require("indent_blankline").setup {
        char = "│",  -- Main indent line
        context_char = "▎",  -- Thicker highlight for current scope
        show_current_context = true,
        show_current_context_start = true,
      }
      
      -- Customize indent line colors
      vim.cmd [[
        highlight IndentBlanklineChar guifg=#FF5555 gui=nocombine
        highlight IndentBlanklineSpaceChar guifg=#FF5555 gui=nocombine
        highlight IndentBlanklineContextChar guifg=#FFD700 gui=bold
      ]]
    end
  }
end)

-- Set colorscheme with error handling
local theme_ok, _ = pcall(vim.cmd, "colorscheme cyberdream")
if not theme_ok then
  print("Failed to load theme: cyberdream")
end

-- Apply custom highlights after Neovim has fully loaded
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    vim.cmd [[
      hi MsgArea guifg=#FF5532 guibg=#000000
      hi StatusLine guifg=#000000 guibg=#C77600
      hi StatusLineNC guifg=#B87070 guibg=#3A0010
      hi Pmenu guifg=#000000 guibg=#DBA100
      hi PmenuSel guifg=#ffffff guibg=#990000
    ]]
  end,
})

-- Ensure ColorScheme autocommand triggers when theme is reloaded
vim.cmd("doautocmd ColorScheme")

-- Keybinding to toggle between light and dark mode
vim.api.nvim_set_keymap("n", "<leader>tt", ":CyberdreamToggleMode<CR>", { noremap = true, silent = true })

-- Autocommand to react to theme mode changes
vim.api.nvim_create_autocmd("User", {
  pattern = "CyberdreamToggleMode",
  callback = function(event)
    local mode = event.data == "default" and "dark" or "light"
    print("Switched to " .. mode .. " mode!")
  end,
})

-- Enable line numbers
vim.o.number = true

-- Open NERDTree automatically on startup, but do not take focus
vim.api.nvim_create_autocmd("VimEnter", {
  pattern = "*",
  callback = function()
    if vim.fn.exists(":NERDTreeToggle") == 2 then
      vim.cmd("NERDTree")
      vim.cmd("wincmd p")
    end
  end,
})

---------- CUSTOM COMMANDS ----------

-- Custom command: Copy entire file to clipboard
vim.api.nvim_create_user_command('Clip', function()
  vim.cmd("normal! ggVG\"+y")
end, {})

-- Custom command: Reload Neovim configuration
vim.api.nvim_create_user_command('ReloadConfig', function()
    vim.cmd("source $MYVIMRC")
end, {})

---------- INDENTATION SETTINGS ----------

-- Set tab behavior
vim.opt.tabstop = 4      -- Number of spaces that <tab> counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of auto-indent
vim.opt.expandtab = true -- Convert tabs to spaces

---------- KEYMAPS ----------

-- Remap arrow keys to move by visual lines instead of logical lines
vim.api.nvim_set_keymap('n', '<Down>', 'gj', { noremap = true })
vim.api.nvim_set_keymap('n', '<Up>', 'gk', { noremap = true })
