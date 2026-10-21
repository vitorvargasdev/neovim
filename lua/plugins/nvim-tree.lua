return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "NvimTreeToggle", "NvimTreeOpen", "NvimTreeClose", "NvimTreeFindFile", "NvimTreeFindFileToggle" },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
    { "<leader>E", "<cmd>NvimTreeFindFileToggle<cr>", desc = "Explorer (current file)" },
  },
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = false,
    },
    view = {
      side = "left",
      width = 40,
      preserve_window_proportions = true,
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")
      
      -- Default mappings
      api.map.on_attach.default(bufnr)
      
      -- Custom mappings
      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end
      
      -- Use 'l' to open files and folders
      vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
      -- Use 'L' to open files on the right side (vertical split)
      vim.keymap.set("n", "L", api.node.open.vertical, opts("Open: Vertical Split"))
      -- Use 'H' to open files on horizontal split
      vim.keymap.set("n", "H", api.node.open.horizontal, opts("Open: Horizontal Split"))
      -- Use 'h' to close folders
      vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
      -- Use 'z' to close all folders
      vim.keymap.set("n", "z", api.tree.collapse_all, opts("Collapse All"))
    end,
    renderer = {
      group_empty = true,
      highlight_git = true,
      highlight_opened_files = "name",
      icons = {
        show = {
          git = true,
          folder = true,
          file = true,
          folder_arrow = true,
        },
      },
    },
    filters = {
      dotfiles = false,
      custom = { "^.git$", "^node_modules$" },
    },
    actions = {
      open_file = {
        quit_on_open = false,
        resize_window = true,
      },
    },
    git = {
      enable = true,
      ignore = false,
    },
  },
  config = function(_, opts)
    require("nvim-tree").setup(opts)
  end,
}