-- Initialize Plugin Manager
local install_path = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.startup(function(use)
  use 'wbthomason/packer.nvim' -- Packer can manage itself
  use 'preservim/nerdtree'      -- NERDTree plugin
  
  -- Theme
  use {
    'scottmckendry/cyberdream.nvim',
    config = function()
      require("cyberdream").setup({
        transparent = true,
        italic_comments = true,
      })
    end
  }

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

      -- Make indent lines more visible
      vim.cmd [[
        highlight IndentBlanklineChar guifg=#FF5555 gui=nocombine
        highlight IndentBlanklineSpaceChar guifg=#FF5555 gui=nocombine
        highlight IndentBlanklineContextChar guifg=#FFD700 gui=bold
      ]]
    end
  }

end)

-- Set colorscheme
local theme_ok, _ = pcall(vim.cmd, "colorscheme cyberdream")
if not theme_ok then
  print("Failed to load theme: cyberdream")
end

-- Apply highlights after everything loads
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

-- Force trigger ColorScheme event in case the theme is reloaded later
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

-- Show line numbers
vim.o.number = true

-- Open NERDTree automatically but do not take focus
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

-- Custom Clip command (Copy all contents to clipboard)
vim.api.nvim_create_user_command('Clip', function()
  vim.cmd("normal! ggVG\"+y")
end, {})

-- Reload VIM config
vim.api.nvim_create_user_command('ReloadConfig', function()
    vim.cmd("source $MYVIMRC")
end, {})

-- Tab fixes
vim.opt.tabstop = 4      -- Number of spaces that <tab> counts for
vim.opt.shiftwidth = 4   -- Number of spaces to use for each step of auto-indent
vim.opt.expandtab = true -- Convert tabs to spaces

------ KEYMAPS -----

-- Remap arrows to visual lines instead of logical lines
vim.api.nvim_set_keymap('n', '<Down>', 'gj', { noremap = true })
vim.api.nvim_set_keymap('n', '<Up>', 'gk', { noremap = true })

