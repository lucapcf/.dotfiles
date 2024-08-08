require('lucapcf.remap')
print('.config/nvim/lua/lucapcf/init.lua')

-- Specify a directory for plugins
vim.fn['plug#begin']('~/.local/share/nvim/plugged')

-- Add the VimBeGood plugin
vim.fn['plug#']('ThePrimeagen/vim-be-good')

-- Initialize plugin system
vim.fn['plug#end']()

-- Basic settings for a better editing experience
vim.o.number = true            -- Show line numbers
vim.o.relativenumber = true    -- Show relative line numbers
vim.o.cursorline = false       -- Highlight the current line
vim.o.swapfile = false         -- Disable swap files
vim.o.backup = false           -- Disable backup files
vim.o.undodir = '~/.nvim/undodir' -- Set undo directory
vim.o.undofile = true          -- Enable persistent undo
vim.o.hidden = true            -- Allow buffer switching without saving
vim.o.wrap = true              -- Enable line wrapping
vim.o.scrolloff = 8            -- Keep 8 lines visible above/below the cursor
vim.o.sidescrolloff = 8        -- Keep 8 columns visible left/right of the cursor
