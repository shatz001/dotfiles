-- ~/dotfiles/nvim/init.lua ───────────────────────────────────────────
-- Real Neovim config, tracked in shatz001/dotfiles.
-- Loaded via a tiny stub at ~/.config/nvim/init.lua that dofile()s this,
-- mirroring the "source from dotfiles" pattern used for zsh/tmux.

-- Reuse existing vimscript config (BreakHere / `gh` mapping, etc.)
vim.cmd('source ~/dotfiles/vimrc')

-- ── Editor options ────────────────────────────────────────────────────
vim.opt.number = true          -- show absolute line numbers

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
      vim.keymap.set('n', '<leader>fo', function() builtin.oldfiles({ cwd_only = true }) end, { desc = 'Telescope: recent files (this repo)' })
      vim.keymap.set('n', '<leader>fO', builtin.oldfiles,    { desc = 'Telescope: recent files (global)' })
      vim.keymap.set('n', '<C-p>',      builtin.find_files, { desc = 'Telescope: find files' })
    end,
  },

  -- Start screen with pressable buttons (shown when you launch `nvim` with no file)
  {
    'goolord/alpha-nvim',
    config = function()
      local alpha = require('alpha')
      local dashboard = require('alpha.themes.dashboard')
      dashboard.section.header.val = { '', 'N E O V I M', '' }
      dashboard.section.buttons.val = {
        dashboard.button('f', 'Find file',    '<cmd>Telescope find_files<cr>'),
        dashboard.button('r', 'Recent files (repo)',   "<cmd>lua require('telescope.builtin').oldfiles({ cwd_only = true })<cr>"),
        dashboard.button('R', 'Recent files (global)', "<cmd>lua require('telescope.builtin').oldfiles()<cr>"),
        dashboard.button('g', 'Live grep',    '<cmd>Telescope live_grep<cr>'),
        dashboard.button('e', 'New file',     '<cmd>ene <bar> startinsert<cr>'),
        dashboard.button('q', 'Quit',         '<cmd>qa<cr>'),
      }
      -- Reminder of the editor shortcuts (leader = \)
      dashboard.section.footer.val = {
        '',
        'find files:  Ctrl-p   or  <leader>ff',
        'live grep:   <leader>fg',
        'all keys:    press <leader> and wait  (which-key)',
        '(leader = \\)',
      }
      alpha.setup(dashboard.config)
    end,
  },

  -- Popup that lists available keybindings when you press <leader> and pause
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    config = function()
      require('which-key').setup({})
    end,
  },
})
