-- Minimal Neovim config. VS Code is the primary editor; this is for quick edits
-- in the terminal and over SSH.

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- Options
local o = vim.opt
o.number = true
o.relativenumber = true
o.expandtab = true
o.shiftwidth = 2
o.tabstop = 2
o.smartindent = true
o.ignorecase = true
o.smartcase = true
o.termguicolors = true
o.signcolumn = "yes"
o.undofile = true
o.scrolloff = 8
o.splitright = true
o.splitbelow = true
o.clipboard = "unnamedplus"

-- Basic keymaps
local map = vim.keymap.set

map("n", "<leader>w", "<C-w>v<C-w>l", { desc = "Vertical split" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<esc>", "<cmd>nohlsearch<cr>")

-- jj exits insert mode
map("i", "jj", "<esc>")

-- Treat softwrapped lines as multiple lines
map({ "n", "v" }, "j", "gj")
map({ "n", "v" }, "k", "gk")

-- Window switching
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Start/end of line
map({ "n", "v" }, "H", "^")
map({ "n", "v" }, "L", "$")

-- Keep cursor centered
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-d>", "<C-d>zz")

-- Don't jump on first * match
map("n", "*", "*<C-o>")

-- Disable accidental manual lookup
map("n", "K", "<nop>")

-- Switch between the last two files
map("n", "<leader><leader>", "<C-^>", { desc = "Alternate file" })

-- Strip trailing whitespace
map("n", "<leader>W", [[:%s/\s\+$//<cr>:let @/=''<cr>]], { desc = "Strip trailing whitespace" })

-- Reformat whole file
map("n", "<leader>=", "ggVG=", { desc = "Reformat file" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "catppuccin/nvim", name = "catppuccin", priority = 1000,
    config = function() vim.cmd.colorscheme("catppuccin-mocha") end },

  { "nvim-treesitter/nvim-treesitter", branch = "master", build = ":TSUpdate",
    opts = {
      ensure_installed = { "lua", "python", "javascript", "typescript", "ruby", "bash", "fish", "json", "yaml", "markdown" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end },

  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
    } },

  { "tpope/vim-fugitive", cmd = { "G", "Git" } },
  { "tpope/vim-surround" },
  { "tpope/vim-repeat" },
  { "tpope/vim-commentary" },
  { "tpope/vim-endwise" },
  { "lewis6991/gitsigns.nvim", opts = {} },
  { "github/copilot.vim" },

  { "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "-", "<cmd>Neotree toggle reveal<cr>", desc = "Toggle file tree" },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
      },
      window = { width = 35 },
    } },
})
