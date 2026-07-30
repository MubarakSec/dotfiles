local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "number,line"
opt.signcolumn = "yes"
opt.foldcolumn = "1"
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true

opt.wrap = false
opt.linebreak = true
opt.showbreak = "↳  "
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹",
}

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"
opt.grepprg = "rg --vimgrep --smart-case --hidden"
opt.grepformat = "%f:%l:%c:%m"

opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.pumheight = 12
opt.confirm = true
opt.hidden = true

opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.laststatus = 3
opt.showmode = false
opt.cmdheight = 0
opt.winborder = "rounded"

opt.undofile = true
opt.swapfile = false
opt.backup = false
opt.writebackup = false

opt.updatetime = 200
opt.timeoutlen = 300
opt.ttimeoutlen = 10
opt.autoread = true

opt.termguicolors = true
opt.termbidi = true
opt.arabicshape = true
opt.virtualedit = "block"
opt.sessionoptions = {
  "buffers",
  "curdir",
  "folds",
  "help",
  "tabpages",
  "winsize",
  "winpos",
  "terminal",
  "localoptions",
}

opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldtext = ""
opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  diff = "╱",
}

opt.wildoptions:remove("pum")
opt.shortmess:append("WIcC")
