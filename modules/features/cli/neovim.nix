{
  flake.modules.nixos.cli = { pkgs, ... }: {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      withPython3 = true;
      withNodeJs = true;
      vimAlias = true;
      viAlias = true;
      configure = {
        customLuaRC = ''
          vim.g.mapleader = ' '
          vim.g.maplocalleader = ' '
          vim.opt.number = true
          vim.opt.relativenumber = true
          vim.opt.mouse = 'a'
          vim.opt.showmode = false
          vim.schedule(function()
            vim.opt.clipboard = 'unnamedplus'
          end)
          vim.opt.tabstop = 2
          vim.opt.softtabstop = 2
          vim.opt.shiftwidth = 2
          vim.o.expandtab = true
          vim.opt.breakindent = true
          vim.opt.undofile = true
          vim.opt.ignorecase = true
          vim.opt.smartcase = true
          vim.opt.signcolumn = 'yes'
          vim.opt.updatetime = 250
          vim.opt.timeoutlen = 300
          vim.opt.splitright = true
          vim.opt.splitbelow = true
          vim.opt.list = true
          vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
          vim.opt.inccommand = 'split'
          vim.opt.cursorline = true
          vim.opt.scrolloff = 10
          vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
          vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
          vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
          vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
          vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
          vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

          vim.api.nvim_create_autocmd('TextYankPost', {
            desc = 'Highlight when yanking (copying) text',
            group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
            callback = function()
              vim.highlight.on_yank()
            end,
          })
          
          local nvim_dir = vim.fn.expand("~/.config/nvim")
          local init_lua = nvim_dir .. "/init.lua"
          vim.opt.runtimepath:append(nvim_dir)
          if vim.fn.filereadable(init_lua) == 1 then
            dofile(init_lua)
          end
        '';
        packages.myVimPackage.start = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
        ];
      };
    };
  };
  flake.modules.homeManager.cli = {
    xdg = {
      enable = true;
      desktopEntries.nvim = {
        name = "Neovim wrapper";
        noDisplay = true;
      };
    };
  };
}
