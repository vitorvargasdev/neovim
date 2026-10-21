-- Git root of the current buffer, falling back to the cwd
local function git_root()
  return vim.fs.root(0, ".git") or vim.fn.getcwd()
end

-- Hides every visible lazygit terminal without killing the process.
-- Called from lazygit itself (see the `os.*` templates below) so that opening a
-- file with `e` keeps the lazygit session alive instead of quitting it.
local function hide_lazygit()
  for _, term in ipairs(Snacks.terminal.list()) do
    local cmd = term.cmd
    local name = type(cmd) == "table" and cmd[1] or cmd
    if name and tostring(name):match("lazygit") and term:win_valid() then
      term:hide()
    end
  end
end

function _G.LazygitHide()
  -- Runs from an RPC request while Neovim sits in terminal-mode, where closing a
  -- window can be blocked; retry on the main loop if that happens.
  if not pcall(hide_lazygit) then
    vim.schedule(hide_lazygit)
  end
  return ""
end

-- lazygit's `nvim-remote` preset sends `q` to Neovim before opening a file, which
-- reaches the terminal buffer and quits lazygit (losing the whole session).
-- These templates hide the window instead. `{{filename}}` / `{{dir}}` arrive
-- already shell-quoted from lazygit.
local lazygit_os = {
  editPreset = "nvim-remote",
  edit = '[ -z "$NVIM" ] && nvim -- {{filename}} || '
    .. '(nvim --server "$NVIM" --remote-expr "v:lua.LazygitHide()" >/dev/null && '
    .. 'nvim --server "$NVIM" --remote-tab {{filename}})',
  editAtLine = '[ -z "$NVIM" ] && nvim +{{line}} -- {{filename}} || '
    .. '(nvim --server "$NVIM" --remote-expr "v:lua.LazygitHide()" >/dev/null && '
    .. 'nvim --server "$NVIM" --remote-tab {{filename}} && '
    .. 'nvim --server "$NVIM" --remote-send ":{{line}}<CR>")',
  openDirInEditor = '[ -z "$NVIM" ] && nvim -- {{dir}} || '
    .. '(nvim --server "$NVIM" --remote-expr "v:lua.LazygitHide()" >/dev/null && '
    .. 'nvim --server "$NVIM" --remote-tab {{dir}})',
}

-- lazygit.yml holds the `q` -> LazygitHide() custom command. snacks keeps an
-- existing LG_CONFIG_FILE and only appends its theme file to it.
vim.env.LG_CONFIG_FILE = table.concat(
  vim.tbl_filter(function(f)
    return vim.uv.fs_stat(f) ~= nil
  end, { vim.fn.expand("~/.config/lazygit/config.yml"), vim.fn.stdpath("config") .. "/lazygit.yml" }),
  ","
)

-- Fullscreen window for lazygit, with `q` and `<C-q>` swapped:
--   `q`     hides the window; the lazygit process keeps running, so reopening
--           lands on the exact same panel/commit/scroll position. In terminal
--           mode this is lazygit's own custom command (see lazygit.yml),
--           so `q` still types normally inside commit messages and prompts.
--   `<C-q>` forwards <ctrl+c> (lazygit's other quit key), quitting it for good.
local function lazygit_win()
  local function hide(self)
    self:hide()
  end

  local function quit(self)
    local chan = vim.b[self.buf].terminal_job_id
    if chan then
      pcall(vim.api.nvim_chan_send, chan, "\3")
    else
      self:close()
    end
  end

  return {
    style = "lazygit",
    width = 0, -- 0 = full width
    height = 0, -- 0 = full height
    border = "none",
    keys = {
      lg_hide_n = { "q", hide, mode = "n", desc = "Hide LazyGit (keep state)" },
      lg_quit_t = { "<C-q>", quit, mode = "t", desc = "Quit LazyGit" },
      lg_quit_n = { "<C-q>", quit, mode = "n", desc = "Quit LazyGit" },
    },
  }
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function(_, opts)
    require("snacks").setup(opts)
  end,
  opts = {
    -- Dashboard (replacement for alpha.nvim)
    dashboard = {
      enabled = true,
      width = 60,
      pane_gap = 3,
      preset = {
        keys = {},
        header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⡴⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣾⡄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣶⣾⣷⣾⣿⣃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠟⢹⣧
⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠋⠀⢸⣿
⠀⠀⠀⢀⣠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⡿⠁⠀⠀⢸⣿
⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⡿⠁⠀⠀⠀⣿⣿
⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣍⢤⣬⣥⣾⣿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⠁⠀⠀⠀⢰⣿⡏
⣸⣿⣿⣿⣿⣿⣿⡟⠛⠻⠿⠿⠿⠿⣿⡿⠇⢨⣍⣙⣛⣠⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⣿⡏⠀⠀⠀⢀⣾⣿⠁
⣿⣿⣿⣿⣿⣿⣿⣧⡘⢶⣶⣶⣶⣶⣶⣤⣤⣤⣤⣭⣉⣉⣉⣛⠛⠿⠿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⢀⣠⣴⣦⣤⣶⣶⣿⣿⣧⣤⣤⣄⠉⢻⡇⠀⠀⠀⣼⣿⡏⠀
⣿⣿⣿⣿⣿⣿⠿⣿⣿⣄⠙⢿⣿⣄⠀⠀⠀⠀⠈⠉⠙⠛⠻⠿⣿⣿⣶⣤⡉⠻⣿⣿⣿⡆⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣥⣤⣭⣁⣀⠀⣸⣿⡟⠀⠀
⢻⣿⣿⣿⣿⣿⡄⢬⣙⠻⢰⣤⡙⠻⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣷⣌⠻⢿⡇⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣍⡁⠿⠋⠀⠀⠀
⠸⣿⡏⣉⡻⢿⣿⡜⣿⣿⣿⣿⣿⣶⣄⡙⠻⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣷⣄⢁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣛⣛⣛⠛⠂⠀⠀⠀⠀
⠀⢻⡇⣿⣿⣶⣬⣙⠈⢿⣿⣿⣿⣿⣿⣿⣶⣌⡙⠻⢿⣶⣤⣄⡀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀
⠀⠈⠁⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣈⠙⠻⢿⣿⣶⣦⣄⣀⣀⣤⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠗⢀⣀⣉⠙⠛⠛⠛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⣉⠻⣿⣿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠙⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢉⣠⣾⣿⣿⠟⣁⣤⣴⣶⣶⢸⣿⣿⣿⣿⣿⣿⣿⢟⣛⠻⣿⣿⣿⣿⣿⣿⣿⣿⠁⣿⠇⠸⣿⡀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠿⢿⣿⣿⣿⣿⡿⠃⣴⣿⣿⣿⠟⣡⣾⣿⣿⣿⣿⣿⢸⣿⣿⣿⣿⣿⣿⢣⣿⣿⠀⠘⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⣿⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⢀⣾⣿⣿⣿⠏⣼⡿⢟⣿⣿⣿⣿⣿⠀⣿⣿⣿⣿⣿⣿⠘⠛⠋⠀⠀⢹⣿⣿⣿⣿⣿⣿⣇⠠⠤⢃⣿⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣀⡅⣠⣿⣿⣿⣿⣿⣿⣇⢹⣿⣿⣿⣿⣿⠰⣷⣀⣠⡄⣸⣿⣿⣿⣿⣿⠿⢻⣷⣶⣿⣿⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⢡⣿⣿⣿⣿⣿⣿⣿⣿⡄⢻⣿⣿⣿⣿⣷⣬⣉⣉⣴⣿⣿⣿⣿⣿⣿⣿⠿⢟⣿⣿⠟⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⡇⢸⡇⣿⣿⣿⣿⣿⡿⢹⣿⣦⡙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣛⣋⣭⣶⣾⡿⢟⣡⣾⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⣇⢈⣥⢸⣿⣿⣿⣿⡇⣾⣿⣿⣿⣶⣬⣙⠻⠿⣿⣿⣿⣿⣿⣿⠿⠿⢛⣉⣥⣶⣿⡿⠟⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⡿⠈⢿⣿⣿⣿⡀⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣤⣤⣤⣤⣴⣶⣾⣿⣿⢿⣿⣿⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⠡⣿⣌⢻⣿⣿⣧⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢸⣿⠃⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⠇⠀⢿⣿⣷⡙⠛⣿⡇⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠛⠁⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⠀⠀⠈⢿⣿⣿⣶⠈⣰⣷⣬⡻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠈⠉⠋⢠⣿⣿⣿⣿⣮⡛⢿⠏⠻⢿⣿⣿⣿⣿⢟⣴⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⢿⠆⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⣿⡆⠀⠀⠀⢉⡛⠟⣱⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⣿⠀⠀⠀⠀⠈⣿⣾⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⢹⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀⠉⠛⠋⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠿⣿⡟⢿⠟⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
      },
      sections = {
        { section = "header" },
        { icon = " ", title = "Recent Files (Current Project)", section = "recent_files", cwd = true, limit = 8, padding = 1 },
        {
          pane = 2,
          icon = " ",
          desc = "Browse Repo",
          padding = 1,
          key = "b",
          action = function()
            Snacks.gitbrowse()
          end,
        },
        function()
          local in_git = Snacks.git.get_root() ~= nil
          local cmds = {
            {
              title = "Git Status",
              cmd = "git status --short --branch --renames",
              height = 5,
              icon = " ",
            },
            {
              title = "GitHub Notifications",
              cmd = "gh notify -s -a -n5 2>/dev/null || echo 'gh not configured'",
              action = function()
                vim.ui.open("https://github.com/notifications")
              end,
              key = "n",
              icon = " ",
              height = 5,
            },
            {
              title = "Open Issues",
              cmd = "gh issue list -L 3 2>/dev/null || echo 'No issues'",
              key = "i",
              action = function()
                vim.fn.jobstart("gh issue list --web", { detach = true })
              end,
              icon = " ",
              height = 7,
            },
            {
              icon = " ",
              title = "Open PRs",
              cmd = "gh pr list -L 3 2>/dev/null || echo 'No PRs'",
              key = "p",
              action = function()
                vim.fn.jobstart("gh pr list --web", { detach = true })
              end,
              height = 7,
            },
          }
          return vim.tbl_map(function(cmd)
            return vim.tbl_extend("force", {
              pane = 2,
              section = "terminal",
              enabled = in_git,
              padding = 1,
              ttl = 5 * 60,
              indent = 3,
            }, cmd)
          end, cmds)
        end,
        { section = "startup" },
      },
    },
    -- Smooth scrolling (replacement for neoscroll.nvim)
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 20, total = 250 },
        easing = "linear",
      },
    },
    -- Better notifications
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    -- LSP rename with preview
    rename = {
      enabled = true,
    },
    -- Better buffer deletion
    bufdelete = {
      enabled = true,
    },
    -- Better vim.ui.input
    input = {
      enabled = true,
    },
    -- Enable lazygit integration
    lazygit = {
      enabled = true,
      -- Keep the lazygit session alive when editing a file from inside it
      config = {
        os = lazygit_os,
      },
      -- Configure lazygit to use the current Neovim colorscheme
      theme = {
        nerdFontsVersion = "3", -- Use nerd fonts version 3
      },
    },
    -- Enable indent guides
    indent = {
      enabled = true,
      -- Show scope highlighting
      scope = {
        enabled = true,
      },
    },
    -- Enable zen mode for distraction-free coding
    zen = {
      enabled = true,
      toggles = {
        dim = true,
        git_signs = true,  -- Show git changes
        mini_diff_signs = true,  -- Show mini diff signs
        diagnostics = false,
        inlay_hints = false,
        -- Hide more distractions for better focus
        number = false,
        relativenumber = false,
        signcolumn = true,  -- Keep signcolumn for git signs
        foldcolumn = false,
        cursorline = false,
        colorcolumn = false,
        spell = false,
        list = false,
      },
      show = {
        statusline = false,
        tabline = false,
        -- Hide command line when not in use
        ruler = false,
        showcmd = false,
      },
      win = {
        -- Center the content with a comfortable reading width
        width = 120,
        -- Configure backdrop for better focus
        backdrop = {
          transparent = false,
          -- Maximum blend for ultimate focus
          blend = 90,
        },
        -- Add padding around the window
        wo = {
          -- Add virtual text padding
          number = false,
          relativenumber = false,
          cursorline = false,
          cursorcolumn = false,
          foldcolumn = "0",
          signcolumn = "yes",  -- Show signcolumn for git signs
          colorcolumn = "",
          spell = false,
          list = false,
          -- Smooth scrolling margins
          scrolloff = 10,
          sidescrolloff = 15,
          -- Clean wrap settings
          wrap = true,
          linebreak = true,
        },
      },
      -- Animation for smooth transitions
      animate = {
        enabled = true,
        duration = {
          step = 10,
          total = 150,
        },
      },
      -- Callbacks for additional customization
      on_open = function()
        -- Optional: Set a clean colorscheme or adjust highlights
        vim.cmd("set laststatus=0")
        vim.cmd("set cmdheight=0")
      end,
      on_close = function()
        -- Restore settings
        vim.cmd("set laststatus=2")
        vim.cmd("set cmdheight=1")
      end,
    },
  },
  keys = {
    -- Main lazygit command (matching your existing keybinding)
    { "<leader>tl", function() Snacks.lazygit({ cwd = git_root(), win = lazygit_win() }) end, desc = "LazyGit (fullscreen toggle)" },
    { "<leader>tG", function() Snacks.lazygit.log({ cwd = git_root(), win = lazygit_win() }) end, desc = "LazyGit Log" },
    { "<leader>tf", function() Snacks.lazygit.log_file({ win = lazygit_win() }) end, desc = "LazyGit Current File" },
    -- Zen mode keybindings
    { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },

    -- Buffer management
    { "<leader>dd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>daa", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },

    -- Terminal
    { "<leader>tt", function() Snacks.terminal(nil, { win = { position = "float", width = 0.9, height = 0.9 } }) end, desc = "Terminal (float)" },
    { "<leader>th", function() Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } }) end, desc = "Terminal (bottom)" },
    { "<leader>tv", function() Snacks.terminal(nil, { win = { position = "right", width = 0.4 } }) end, desc = "Terminal (right)" },
    -- Numbered terminals (tabs). Each count = separate instance, id shown in statusline.
    { "<leader>t1", function() Snacks.terminal(nil, { count = 1, win = { position = "right", width = 0.4 } }) end, desc = "Terminal #1 (right)" },
    { "<leader>t2", function() Snacks.terminal(nil, { count = 2, win = { position = "right", width = 0.4 } }) end, desc = "Terminal #2 (right)" },
    { "<leader>t3", function() Snacks.terminal(nil, { count = 3, win = { position = "right", width = 0.4 } }) end, desc = "Terminal #3 (right)" },
  },
}
