# Dotfiles

## Programs:

- Kitty / Alacritty
- Tmux
- zsh
- atuin: history database
- zoxide: better cd
- fzf: fuzzy finder
- btop: better htop
- bat: better cat
- shellfirm: dangerous commands warning
- oh-my-posh / starship: prompt
- neofetch: system info

### Dependencies:

- ffmpeg
- ffmpegthumbnailer: video thumbnails
- unzip: zip files extraction
- jq: json parsing
- poppler: pdf previews
- fd: file searching
- ripgrep: for text searching
- xclip: clipboard managment
- lazygit: git cli
- shellfirm: dangerous commands warning
- A nerd font

## Installation:

Run `stow .` in this directory.

### Manual configuration:

#### TMUX:

Open tmux and press `Ctrl + S -> Ctrl + I` to install plugins.

#### Python:

Go to `~/.local/share/nvim` and run:

```console
python -m venv python
cd python
source bin/activate
pip install pynvim mypy
```

#### Oh-my-zsh:

Run:

```console
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Then remove the `~/.zshrc` file and rerun `stow .` in this directory.

## Also check:

### Betterfox:

https://github.com/yokoffing/BetterFox?tab=readme-ov-file
