require "nvchad.options"

-- add yours here!

local o = vim.o

-- Basic settings for a better editing experience
-- vim.o.number = true            -- Show line numbers
o.relativenumber = true    -- Show relative line numbers
-- vim.o.cursorline = false       -- Highlight the current line
-- vim.o.swapfile = false         -- Disable swap files
-- vim.o.backup = false           -- Disable backup files
-- vim.o.undodir = '~/.nvim/undodir' -- Set undo directory
o.undofile = true          -- Enable persistent undo
o.hidden = true            -- Allow buffer switching without saving
o.wrap = true              -- Enable line wrapping
o.scrolloff = 8            -- Keep 8 lines visible above/below the cursor
o.sidescrolloff = 8        -- Keep 8 columns visible left/right of the cursor

-- Set the colorcolumn option to 80
vim.opt.colorcolumn = "80"



o.cursorlineopt ='both' -- to enable cursorline!
