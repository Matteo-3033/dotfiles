# Dotfiles

## Overview
This repository contains configuration files for various tools and utilities aimed at improving your terminal experience. Below is a list of programs, dependencies, and setup instructions.

---

## Programs
This repository contains configuration files for the following programs:

- **atuin**: Enhanced shell history database
- **bat**: Improved `cat` command
- **bspwm**: A tiling window manager
- **btop**: Advanced system monitor (alternative to `htop`)
- **fzf**: Fuzzy finder
- **Kitty / Alacritty**: Terminal emulators
- **neofetch**: System information tool
- **nitrogen**: Background browser and setter
- **Neovim**: A good editor
- **oh-my-posh / starship**: Customizable prompts
- **rofi**: Window switcher and application launcher
- **shellfirm**: Warnings for dangerous commands
- **sxhkd**: Keyboard event handler
- **Tmux**: Terminal multiplexer
- **yazi**: Terminal file manager
- **zoxide**: Smarter `cd` command
- **zsh**: Z shell

It is not required to install all these programs to use this repository—these are just the programs I use in my daily workflow. Feel free to customize it as you like.

---

## Dependencies
Before proceeding with the installation, ensure the following dependencies are installed for full functionality:

- **A nerd font**: Required for proper font rendering in terminals
- **fd**: Fast and user-friendly alternative to `find`
- **ffmpeg**: For multimedia processing
- **ffmpegthumbnailer**: Generate video thumbnails
- **gcc**: C/C++ compiler
- **jq**: Command-line JSON parser
- **lazygit**: Git CLI interface
- **nvm**: Node.js version manager
- **poppler**: PDF previews
- **python**: Python runtime
- **ripgrep**: High-performance text search tool
- **stow**: For managing symlinks
- **unzip**: Extract `.zip` files
- **xclip**: Clipboard management

---

## Installation

1. Clone the repository and initialize its submodules:
   ```bash
   git clone --recurse-submodules <repository-url>
   ```

2. Run the following command to symlink the dotfiles:
   ```bash
   stow .
   ```

---

### Manual Configuration

#### Tmux
1. Open Tmux.
2. Install plugins by pressing:
   ```
   Ctrl + S -> Ctrl + I
   ```

#### Neovim

1. Navigate to the Neovim data directory (create it if it does not exist):
   ```bash
   mkdir -p ~/.local/share/nvim
   cd ~/.local/share/nvim
   ```
2. Set up a Python virtual environment and install Neovim requirements:
   ```bash
   python -m venv python
   cd python
   source bin/activate
   pip install pynvim mypy
   ```
3. Install Node.js:
   ```bash
   nvm install 20
   nvm use 20
   ```
4. Open Neovim to install required plugins:
   ```bash
   nvim
   ```

#### Oh-My-Zsh
1. Install Oh-My-Zsh:
   ```bash
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```
2. Remove the existing `.zshrc` file:
   ```bash
   rm ~/.zshrc
   ```
3. Re-run the following command to apply the new configuration:
   ```bash
   stow .
   ```

---

## Additional Resources

### Betterfox
For enhanced Firefox configurations, refer to the Betterfox repository:  
[https://github.com/yokoffing/BetterFox](https://github.com/yokoffing/BetterFox)

---

Feel free to modify and adapt these configurations to suit your workflow.
