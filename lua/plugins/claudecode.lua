--- Send visual selection to external Claude via WebSocket (no terminal)
local function send_to_external_claude()
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
  vim.api.nvim_feedkeys(esc, "x", false)
  vim.schedule(function()
    local start_line = vim.fn.line("'<")
    local end_line = vim.fn.line("'>")
    local file = vim.fn.expand("%:p")

    if file == "" or start_line == 0 then
      vim.notify("No file or selection", vim.log.levels.WARN)
      return
    end

    local ok, claudecode = pcall(require, "claudecode")
    if ok and claudecode.is_claude_connected and claudecode.is_claude_connected() then
      -- Send directly via WebSocket (0-indexed)
      local success, err = claudecode._broadcast_at_mention(file, start_line - 1, end_line - 1)
      if success then
        vim.notify(string.format("Sent lines %d-%d to Claude", start_line, end_line), vim.log.levels.INFO)
      else
        vim.notify("Failed: " .. (err or "unknown"), vim.log.levels.ERROR)
      end
    else
      -- Fallback: copy @-mention to clipboard
      local mention = string.format("@%s:%d-%d", file, start_line, end_line)
      vim.fn.setreg("+", mention)
      vim.notify("Clipboard: " .. mention, vim.log.levels.INFO)
    end
  end)
end

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  event = "VeryLazy",
  opts = {
    terminal_cmd = "/home/vitor/.local/bin/claude --ide",
    auto_start = true,
    terminal = {
      split_side = "right",
      split_width_percentage = 0.4,
      provider = "snacks",
    },
    diff_opts = {
      auto_close_on_accept = true,
      show_diff_stats = true,
      vertical_split = true,
    },
  },
  keys = {
    -- Terminal integrado
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude Code" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude Code" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume session" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue session" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
    -- Enviar contexto
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add buffer to Claude" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to terminal" },
    { "<leader>oa", send_to_external_claude, mode = "v", desc = "Send to external Claude" },
    -- Diff
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
  cmd = {
    "ClaudeCode",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeFocus",
    "ClaudeCodeSend",
    "ClaudeCodeAdd",
    "ClaudeCodeSelectModel",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeStatus",
  },
}
