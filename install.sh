#!/bin/sh

set -eu

if [ "$(id -u)" -ne 0 ]; then
    echo "ERROR: This script must be run as root."
    exit 1
fi

ZSH_DIR="/root/.zsh"
PLUGINS_DIR="/root/.zsh/plugins"
ZSHRC="/root/.zshrc"
CONFIG_DIR="/root/.config"

echo "==> Installing packages..."

apt-get update

apt-get install -y \
    zsh \
    git \
    curl \
    lsd \
    neovim \
    zsh-autosuggestions \
    software-properties-common

# ============================================================
# Starship
# ============================================================

echo "==> Installing Starship..."

if ! command -v starship >/dev/null 2>&1; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# ============================================================
# Fastfetch
# ============================================================

echo "==> Installing Fastfetch..."

if ! command -v fastfetch >/dev/null 2>&1; then
    add-apt-repository -y ppa:zhangsongcui3371/fastfetch
    apt-get update
    apt-get install -y fastfetch
fi

# ============================================================
# Directories
# ============================================================

echo "==> Creating directories..."

mkdir -p "$PLUGINS_DIR"
mkdir -p "$CONFIG_DIR"

# ============================================================
# F-Sy-H
# ============================================================

echo "==> Installing Fast Syntax Highlighting..."

if [ ! -d "$PLUGINS_DIR/F-Sy-H" ]; then
    git clone --depth=1 \
        https://github.com/z-shell/F-Sy-H.git \
        "$PLUGINS_DIR/F-Sy-H"
fi

# ============================================================
# zsh-completions
# ============================================================

echo "==> Installing zsh-completions..."

if [ ! -d "$PLUGINS_DIR/zsh-completions" ]; then
    git clone --depth=1 \
        https://github.com/zsh-users/zsh-completions.git \
        "$PLUGINS_DIR/zsh-completions"
fi

# ============================================================
# .zshrc
# ============================================================

echo "==> Configuring Zsh..."

cat > "$ZSHRC" <<'EOF'
# ============================================================
# ZSH
# ============================================================

# Completion
autoload -Uz compinit
compinit

# ============================================================
# Plugins
# ============================================================

# Autosuggestions
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Extra completions
fpath=(~/.zsh/plugins/zsh-completions/src $fpath)

# Fast Syntax Highlighting
source ~/.zsh/plugins/F-Sy-H/F-Sy-H.plugin.zsh

# ============================================================
# History
# ============================================================

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# ============================================================
# Zsh options
# ============================================================

setopt AUTO_CD
setopt CORRECT
setopt INTERACTIVE_COMMENTS

# ============================================================
# Starship
# ============================================================

alias ls='lsd -a'

fastfetch

eval "$(starship init zsh)"
EOF

# ============================================================
# Starship
# ============================================================

echo "==> Configuring Starship..."

starship preset bracketed-segments \
    -o "$CONFIG_DIR/starship.toml" \
    --force

# ============================================================
# Default shell
# ============================================================

echo "==> Setting Zsh as default shell..."

chsh -s "$(command -v zsh)" root

# ============================================================
# Disable Ubuntu MOTD
# ============================================================

echo "==> Disabling login MOTD..."

touch /root/.hushlogin

# ============================================================
# Done
# ============================================================

exec zsh
