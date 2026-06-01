-- ~/dotfiles/nvim/init.lua ───────────────────────────────────────────
-- Real Neovim config, tracked in shatz001/dotfiles.
-- Loaded via a tiny stub at ~/.config/nvim/init.lua that dofile()s this,
-- mirroring the "source from dotfiles" pattern used for zsh/tmux.

-- Reuse existing vimscript config (BreakHere / `gh` mapping, etc.)
vim.cmd('source ~/dotfiles/vimrc')

-- ── Bootstrap lazy.nvim (plugin manager) ──────────────────────────────
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ───────────────────────────────────────────────────────────
require('lazy').setup({
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Native fzf sorter for speed (compiled with `make`; harmless if it fails)
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local telescope = require('telescope')
      telescope.setup({})
      pcall(telescope.load_extension, 'fzf')

      local builtin = require('telescope.builtin')
      -- find_files searches Neovim's cwd (the dir you launched nvim from) by default
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope: find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = 'Telescope: live grep' })
      vim.keymap.set('n', '<C-p>',      builtin.find_files, { desc = 'Telescope: find files' })
    end,
  },
})
