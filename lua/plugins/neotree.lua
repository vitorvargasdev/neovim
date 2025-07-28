return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  lazy = false, -- neo-tree will lazily load itself
  ---@module "neo-tree"
  ---@type neotree.Config?
  opts = {
    window = {
      position = "right",
    },
    -- fill any relevant options here
  },
  config = function()
    require("neo-tree").setup({
      window = {
        position = "right",
        mappings = {
          ["l"] = "open",
        },
      },
    })
    vim.keymap.set("n", "<leader>ee", "<Cmd>Neotree toggle reveal_force_cwd<CR>")
    vim.keymap.set("n", "<leader>ef", "<Cmd>Neotree focus<CR>")
    vim.keymap.set("n", "<leader>bg", "<Cmd>Neotree toggle git_status right<CR>")
    vim.keymap.set("n", "M", "<Cmd>Neotree toggle git_status right<CR>")
  end,
}

