# Neovim Configuration

A modern Neovim configuration with LSP support, AI assistance, and a beautiful UI.

## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [System Dependencies Installation](#system-dependencies-installation)
  - [Arch Linux](#arch-linux)
  - [Fedora](#fedora)
  - [Ubuntu/Debian](#ubuntudebian)
  - [Verify Installation](#verify-installation)
- [Installation](#installation)
- [Plugin List](#plugin-list)
- [Key Mappings](#key-mappings)
  - [General](#general)
  - [Navigation](#navigation)
  - [Buffer Management](#buffer-management)
  - [File Explorer](#file-explorer)
  - [Telescope](#telescope)
  - [Git](#git)
  - [Git Hunks](#git-hunks-minidiff)
  - [Git Status View](#git-status-view)
  - [LSP](#lsp)
- [Configuration Structure](#configuration-structure)
- [Screenshots](#screenshots)
- [Usage Guide](#usage-guide)
  - [Quick Start](#quick-start)
  - [Common Workflows](#common-workflows)
  - [Productivity Tips](#productivity-tips)
- [Troubleshooting](#troubleshooting)
  - [Common Issues](#common-issues)
- [Customization](#customization)
  - [Adding Plugins](#adding-plugins)
  - [Modifying Settings](#modifying-settings)
  - [Changing Theme](#changing-theme)
- [Tips](#tips)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgments](#acknowledgments)
- [Related Projects](#related-projects)

## Features

- 🚀 **LSP Support**: Full language server protocol support with auto-completion and diagnostics
- 🤖 **AI Integration**: GitHub Copilot and Avante.nvim for AI-powered coding assistance
- 🎨 **Beautiful UI**: Catppuccin theme with custom dashboard and smooth cursor animations
- 📁 **File Management**: Snacks.nvim explorer and Neo-tree for project navigation
- 🔧 **Git Integration**: Fugitive, Diffview, and mini-diff for comprehensive git workflows
- 📝 **Note Taking**: Obsidian.nvim integration for markdown and note management
- 🐛 **Debugging**: DAP (Debug Adapter Protocol) support with UI
- ⚡ **Fast Completion**: Blink.cmp for ultra-fast autocompletion
- 🛠️ **Utilities**: Snacks.nvim for various productivity enhancements

## Requirements

- Neovim >= 0.8.0
- Git
- Node.js (for LSP servers and Copilot)
- [Ripgrep](https://github.com/BurntSushi/ripgrep) (for Telescope and Obsidian.nvim)
- A [Nerd Font](https://www.nerdfonts.com/) (for icons)
- C compiler (for Treesitter)

## System Dependencies Installation

### Arch Linux

```bash
# Core dependencies
sudo pacman -S neovim git base-devel nodejs npm

# Essential tools
sudo pacman -S ripgrep fd lazygit github-cli

# Clipboard support (choose based on your display server)
sudo pacman -S xclip          # For X11
sudo pacman -S wl-clipboard   # For Wayland

# Nerd Font (example: JetBrains Mono)
# Using yay (AUR helper)
yay -S ttf-jetbrains-mono-nerd

# Or manually from the official repo
sudo pacman -S ttf-jetbrainsmono-nerd
```

### Fedora

```bash
# Core dependencies
sudo dnf install neovim git gcc gcc-c++ nodejs npm

# Essential tools
sudo dnf install ripgrep fd-find

# Lazygit
sudo dnf copr enable atim/lazygit -y
sudo dnf install lazygit

# GitHub CLI
sudo dnf install 'dnf-command(config-manager)'
sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
sudo dnf install gh --repo gh-cli

# Clipboard support (choose based on your display server)
sudo dnf install xclip          # For X11
sudo dnf install wl-clipboard   # For Wayland

# Nerd Font (example: JetBrains Mono)
# Download from: https://www.nerdfonts.com/font-downloads
# Extract to ~/.local/share/fonts/ and run:
fc-cache -fv
```

### Ubuntu/Debian

```bash
# Core dependencies
sudo apt update
sudo apt install neovim git build-essential nodejs npm

# Ripgrep
sudo apt install ripgrep

# fd (called fd-find in Ubuntu/Debian)
sudo apt install fd-find
# Create alias for fd
ln -s $(which fdfind) ~/.local/bin/fd

# Lazygit
sudo add-apt-repository ppa:lazygit-team/daily
sudo apt update
sudo apt install lazygit

# GitHub CLI
(type -p wget >/dev/null || sudo apt install wget -y) \
&& sudo mkdir -p -m 755 /etc/apt/keyrings \
&& wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh

# Clipboard support (choose based on your display server)
sudo apt install xclip          # For X11
sudo apt install wl-clipboard   # For Wayland

# Nerd Font (example: JetBrains Mono)
# Download from: https://www.nerdfonts.com/font-downloads
# Extract to ~/.local/share/fonts/ and run:
fc-cache -fv
```

### Verify Installation

After installing dependencies, verify everything is working:

```bash
nvim --version      # Should be >= 0.8.0
git --version       # Any recent version
node --version      # Should be installed
npm --version       # Should be installed
rg --version        # Ripgrep should be installed
fd --version        # fd should be installed
lazygit --version   # Lazygit should be installed
gh --version        # GitHub CLI should be installed
```

## Installation

1. **Backup your existing Neovim configuration**:
   ```bash
   mv ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clone this repository**:
   ```bash
   git clone https://github.com/vitorvargasdev/neovim.git ~/.config/nvim
   ```

3. **Install Neovim plugins**:
   ```bash
   nvim
   ```
   Lazy.nvim will automatically install on first launch

4. **Install LSP servers**:
   After opening Neovim, Mason will help you install language servers:
   ```vim
   :Mason
   ```

## Plugin List

### Core
- **[lazy.nvim](https://github.com/folke/lazy.nvim)**: Modern plugin manager
- **[plenary.nvim](https://github.com/nvim-lua/plenary.nvim)**: Lua utility functions

### UI & Theme
- **[catppuccin](https://github.com/catppuccin/nvim)**: Beautiful pastel theme
- **[lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)**: Statusline
- **[bufferline.nvim](https://github.com/akinsho/bufferline.nvim)**: Buffer tabs
- **[dressing.nvim](https://github.com/stevearc/dressing.nvim)**: Better UI for input/select
- **[snacks.nvim](https://github.com/folke/snacks.nvim)**: Collection of utilities including file explorer, dashboard, and more

### Editor Enhancement
- **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: Better syntax highlighting
- **[nvim-autopairs](https://github.com/windwp/nvim-autopairs)**: Auto close brackets
- **[Comment.nvim](https://github.com/numToStr/Comment.nvim)**: Smart commenting
- **[smear-cursor.nvim](https://github.com/sphamba/smear-cursor.nvim)**: Smooth cursor animations

### File Management
- **[neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)**: File tree explorer
- **[telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)**: Fuzzy finder

### Git Integration
- **[vim-fugitive](https://github.com/tpope/vim-fugitive)**: Git commands
- **[diffview.nvim](https://github.com/sindrets/diffview.nvim)**: Git diff viewer
- **[mini.diff](https://github.com/echasnovski/mini.nvim)**: Git signs in gutter

### LSP & Completion
- **[nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)**: LSP configurations
- **[mason.nvim](https://github.com/williamboman/mason.nvim)**: LSP server installer
- **[blink.cmp](https://github.com/Saghen/blink.cmp)**: Fast completion engine
- **[none-ls.nvim](https://github.com/nvimtools/none-ls.nvim)**: Formatters and linters

### AI & Productivity
- **[copilot.lua](https://github.com/zbirenbaum/copilot.lua)**: GitHub Copilot
- **[avante.nvim](https://github.com/yetone/avante.nvim)**: AI coding assistant

### Note Taking
- **[obsidian.nvim](https://github.com/epwalsh/obsidian.nvim)**: Obsidian vault integration

### Debugging
- **[nvim-dap](https://github.com/mfussenegger/nvim-dap)**: Debug Adapter Protocol
- **[nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui)**: UI for debugging

## Key Mappings

### General
- **Leader key**: `<Space>`
- **Save file**: `tw`
- **Quit all**: `tq`
- **Clear search highlight**: `<Esc>`

### Navigation
- **Next buffer**: `ty`
- **Previous buffer**: `tr`
- **Window navigation**: `<C-h/j/k/l>`

### Buffer Management
- **Close buffer**: `<leader>dd`
- **Close all buffers**: `<leader>daa`

### File Explorer
- **Toggle Explorer**: `<leader>e`

### Telescope
- **Find files**: `<leader>ff`
- **Live grep**: `<leader>fg`
- **Recent files**: `<leader>fo`

### Git
- **Git status**: `<leader>gs`
- **Git commits**: `<leader>gc`
- **Diffview open**: `<leader>do`

### Git Hunks (mini.diff)
- **Next hunk**: `.`
- **Previous hunk**: `,`
- **Next hunk + preview**: `>` (Shift+.)
- **Previous hunk + preview**: `<` (Shift+,)
- **Toggle diff overlay**: `m`
- **Apply hunk**: `gh`
- **Reset hunk**: `gH`

### Git Status View
- **Toggle Neo-tree git status**: `M`

### LSP
- **Go to definition**: `gd`
- **Show hover**: `K`
- **Code actions**: `<leader>ca`
- **Rename**: `<leader>rn`
- **Format**: `<leader>f`

## Configuration Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lazy-lock.json          # Plugin version lock file
├── lua/
│   ├── config/
│   │   ├── nvim.lua       # Core Neovim settings
│   │   ├── lazy.lua       # Plugin manager setup
│   │   └── diff-colors.lua # Diff highlighting
│   └── plugins/           # Plugin configurations
│       ├── lsp-config.lua # LSP setup
│       ├── completions.lua # Completion setup
│       ├── telescope.lua  # Fuzzy finder
│       └── ...           # Other plugin configs
```

## Screenshots

> Add your screenshots here to showcase your setup

## Usage Guide

### Quick Start
1. Open Neovim: `nvim`
2. Find files: `<leader>ff`
3. Search in files: `<leader>fg`
4. Open file explorer: `<leader>e`
5. Toggle terminal: `<C-\>`

### Common Workflows

#### Git Workflow
1. Check git status: `<leader>gs`
2. Navigate hunks: `,` and `.`
3. Preview changes: `m`
4. Stage changes: `gh`
5. Open lazygit: `<leader>tl`

#### Code Navigation
1. Go to definition: `gd`
2. Find references: `gr`
3. Show documentation: `K`
4. Code actions: `<leader>ca`

#### AI Assistance
- Toggle Copilot: `:Copilot toggle`
- Open Avante: `<leader>aa`

### Productivity Tips
- **Zen Mode**: `<leader>z` for distraction-free coding
- **Rename**: `<leader>rn` with preview
- **Format code**: `<leader>f`
- **Quick fix**: `<leader>qf`

## Troubleshooting

### Common Issues

#### LSP not working
```bash
:checkhealth lsp
:Mason
# Install missing servers
```

#### Telescope errors
Ensure ripgrep and fd are installed:
```bash
which rg fd
```

#### Copilot not activating
```vim
:Copilot setup
:Copilot status
```

#### Treesitter highlighting issues
```vim
:TSUpdate
:TSInstall <language>
```

## Customization

### Adding Plugins
Create a new file in `lua/plugins/` or add to an existing one:
```lua
return {
  "username/plugin-name",
  config = function()
    require("plugin-name").setup({
      -- your config here
    })
  end,
}
```

### Modifying Settings
- Core settings: Edit `lua/config/nvim.lua`
- Plugin settings: Edit respective files in `lua/plugins/`
- LSP servers: Modify `lua/plugins/lsp-config.lua`

### Changing Theme
Edit `lua/plugins/catppuccin.lua` to change theme variant or switch to a different colorscheme.

## Tips

1. Run `:checkhealth` to ensure all dependencies are installed
2. Use `:Mason` to manage LSP servers
3. Update plugins with `:Lazy update`
4. Sync plugins after changes with `:Lazy sync`

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Guidelines
1. Follow the existing code style
2. Test your changes thoroughly
3. Update documentation as needed
4. Keep commits atomic and well-described

## License

This configuration is open source and available under the [MIT License](LICENSE).

## Acknowledgments

Special thanks to:
- The Neovim team for creating an amazing editor
- All plugin authors who make Neovim extensible
- The Neovim community for inspiration and support

## Related Projects

- [LazyVim](https://github.com/LazyVim/LazyVim) - A Neovim config for the lazy
- [AstroNvim](https://github.com/AstroNvim/AstroNvim) - An aesthetic and feature-rich Neovim config
- [NvChad](https://github.com/NvChad/NvChad) - Blazing fast Neovim config

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/vitorvargasdev">vitorvargasdev</a>
</p>
