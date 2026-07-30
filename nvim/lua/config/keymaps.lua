local map = vim.keymap.set

map({ "n", "i", "x", "s" }, "<C-s>", "<cmd>silent update<cr>", { desc = "Save file" })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

map("n", "<leader>-", "<C-w>s", { desc = "Split below", remap = true })
map("n", "<leader>|", "<C-w>v", { desc = "Split right", remap = true })
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

map("n", "<A-j>", "<cmd>move .+1<cr>==", { desc = "Move line down" })
map("n", "<A-k>", "<cmd>move .-2<cr>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc><cmd>move .+1<cr>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc><cmd>move .-2<cr>==gi", { desc = "Move line up" })
map("x", "<A-j>", ":move '>+1<cr>gv=gv", { desc = "Move selection down" })
map("x", "<A-k>", ":move '<-2<cr>gv=gv", { desc = "Move selection up" })
map("x", "<", "<gv", { desc = "Indent left" })
map("x", ">", ">gv", { desc = "Indent right" })

map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New file" })
map("n", "[q", "<cmd>cprev<cr>", { desc = "Previous quickfix" })
map("n", "]q", "<cmd>cnext<cr>", { desc = "Next quickfix" })
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Enter normal mode" })

local function toggle_arabic_keymap()
  if vim.opt.keymap:get() == "arabic" then
    vim.cmd("set keymap=")
    vim.notify("Arabic keyboard off")
  else
    vim.cmd("set keymap=arabic")
    vim.notify("Arabic keyboard on")
  end
end

local function toggle_rightleft()
  if vim.opt.rightleft:get() then
    vim.cmd("set norightleft")
    vim.notify("LTR direction")
  else
    vim.cmd("set rightleft")
    vim.notify("RTL direction")
  end
end

map("n", "<leader>uk", toggle_arabic_keymap, { desc = "Toggle Arabic keyboard" })
map("n", "<leader>ud", toggle_rightleft, { desc = "Toggle RTL direction" })
