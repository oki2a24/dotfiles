-- # コンセプト
-- - バニラ Neovim プラスアルファを心がける。
-- - 操作に関しては既存の Vim 設定を維持し、変更しないでそのままとする。
-- - UI は自らの好みで好きなタイミングでカスタマイズする。

local opt = vim.opt
local cmd = vim.cmd
local g = vim.g
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- デフォルト設定の読み込み相当
opt.compatible = false
cmd('filetype plugin indent on')
cmd('syntax on')

-- キーマッピング
g.mapleader = " "

-- 自動保存・自動読み込みの設定
opt.autoread = true

local auto_save_grp = augroup("AutoSaveAndRead", { clear = true })
autocmd({ "FocusGained", "BufEnter" }, {
  group = auto_save_grp,
  pattern = "*",
  callback = function() vim.cmd("checktime") end,
})
autocmd("FocusLost", {
  group = auto_save_grp,
  pattern = "*",
  callback = function() vim.cmd("wall") end,
})

-- ヤンク時にクリップボードにもコピーする
opt.clipboard = "unnamedplus"

-- colorscheme に関連する項目
opt.cursorline = true
opt.list = true
opt.listchars = { tab = "->" }

-- ビープ音にビジュアルベルを使う
opt.visualbell = true

-- 検索ハイライト
opt.hlsearch = true
