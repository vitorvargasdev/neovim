return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
  },
  opts = {
    -- Optional: Configure default settings
    auto_start = false, -- Don't auto-start servers on startup
    debug = false, -- Enable debug logging
  },
  config = function(_, opts)
    require("mcphub").setup(opts)
  end,
  keys = {
    { "<leader>mh", "<cmd>MCPHub<cr>", desc = "Open MCP Hub" },
    { "<leader>ms", "<cmd>MCPHub servers<cr>", desc = "MCP Servers" },
    { "<leader>mt", "<cmd>MCPHub tools<cr>", desc = "MCP Tools" },
    { "<leader>mr", "<cmd>MCPHub resources<cr>", desc = "MCP Resources" },
    { "<leader>mp", "<cmd>MCPHub prompts<cr>", desc = "MCP Prompts" },
    { "<leader>mm", "<cmd>MCPHub marketplace<cr>", desc = "MCP Marketplace" },
    { "<leader>ml", "<cmd>MCPHub logs<cr>", desc = "MCP Logs" },
    { "<leader>mi", "<cmd>MCPHub install<cr>", desc = "Install MCP Server" },
  },
  cmd = {
    "MCPHub",
    "MCPHubStart",
    "MCPHubStop",
    "MCPHubRestart",
  },
}