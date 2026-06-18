-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Force terminal to exit to normal mode with Esc
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit Terminal Mode" })

-- Allow window navigation from terminal mode
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { desc = "Go to Left Window" })
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { desc = "Go to Lower Window" })
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { desc = "Go to Upper Window" })
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { desc = "Go to Right Window" })

-- Quality of life
vim.keymap.set("n", "<leader>re", "<Cmd>restart<CR>", { desc = "Restart neovim" })
vim.keymap.set("n", "<C-c>", "<Cmd>%y+<CR>", { desc = "Yank whole file" })
vim.keymap.set("n", "gh", "^", { desc = "Start of line (non ws)" })
vim.keymap.set("n", "gH", "0", { desc = "Start of line" })
vim.keymap.set("n", "gl", "$", { desc = "End of line" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Better Ctrl-D" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Better Ctrl-U" })

-- fzf-lua
vim.keymap.set("n", "z=", "<Cmd>FzfLua spell_suggest<Cr>", { desc = "Find spell suggestions" })
vim.keymap.set("n", "<leader>fu", "<Cmd>FzfLua undotree<Cr>", { desc = "UndoTree" })
vim.keymap.set("n", "<leader>fN", "<Cmd>FzfLua files cwd=~/nixos-dotfiles<Cr>", { desc = "NixOS Dotfiles" })
-- vim.keymap.set("n", "<leader>fz", "<Cmd>FzfLua zoxide<Cr>", { desc = "Zoxide menu" })

-- Harpoon-like buffer jump
vim.keymap.set("n", "<leader>h", "<Cmd>BufferLinePick<CR>", { desc = "Pick Buffer (alt.)" })

-- Running gtest
vim.keymap.set("n", "<leader>tg", function()
  Snacks.terminal("make gtest && echo; read", {
    win = {
      border = "rounded",
    },
  })
end, { desc = "Run make gtest (Terminal)" })

-- Luasnip mappings
vim.keymap.set("n", "gcC", function()
  vim.cmd("normal! O")

  local ls = require("luasnip")
  local snippets = ls.get_snippets("all")

  for _, snip in ipairs(snippets) do
    if snip.trigger == "fcomment" then
      ls.snip_expand(snip)

      vim.cmd("startinsert")
      return
    end
  end

  print("Snippet not found!")
end, { desc = "Add fancy comment line" })
