local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true

-- Indentation
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true

-- Editing
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.whichwrap:append("<,>,h,l")
opt.undofile = true
opt.confirm = true

-- Pick up changes made outside nvim (agents, git checkout, formatters).
opt.autoread = true

-- UI
opt.termguicolors = true
opt.wrap = true
opt.linebreak = true
opt.scrolloff = 8
opt.splitright = true
opt.splitbelow = true
opt.showmode = false
opt.winborder = "rounded"
opt.updatetime = 250
opt.timeoutlen = 400
