#!/usr/bin/env bash
set -euo pipefail

# ── Purple Ops — bare-metal bootstrap ──────────────────────────────
# Usage:  curl -fsSL https://dotfiles.mubaraksec.dev/bootstrap | bash
#         (or run locally from the cloned repo)

REPO="MubarakSec/dotfiles"
BRANCH="${1:-main}"
DOTFILES="$HOME/.config"

echo "◆ Purple Ops bootstrap — installing workstation essentials"

# ── 1. System packages ──────────────────────────────────────────────
install_system() {
  echo "  ■ system packages"
  sudo apt update -qq
  sudo apt install -y -qq \
    curl git build-essential pkg-config \
    libssl-dev libreadline-dev zlib1g-dev \
    libsqlite3-dev libncurses-dev libffi-dev libbz2-dev \
    unzip ripgrep fd-find eza bat zoxide \
    kitty tmux btop bison flex
}

# ── 2. Neovim (latest stable) ───────────────────────────────────────
install_nvim() {
  echo "  ■ neovim"
  local ver
  ver=$(curl -fsSL https://api.github.com/repos/neovim/neovim/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4)
  curl -fsSL "https://github.com/neovim/neovim/releases/download/$ver/nvim-linux64.tar.gz" \
    | sudo tar xzf - -C /usr/local --strip-components=1
}

# ── 3. Node.js (via nvm, for prettier / LSPs) ──────────────────────
install_node() {
  echo "  ■ node (via nvm)"
  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm install --lts
  npm install -g neovim prettier
}

# ── 4. Go (for some LSPs) ──────────────────────────────────────────
install_go() {
  echo "  ■ go"
  curl -fsSL https://go.dev/dl/go1.23.0.linux-amd64.tar.gz \
    | sudo tar xzf - -C /usr/local
  export PATH="/usr/local/go/bin:$PATH"
}

# ── 5. Rust (for tools) ────────────────────────────────────────────
install_rust() {
  echo "  ■ rust"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"
}

# ── 6. Starship prompt ─────────────────────────────────────────────
install_starship() {
  echo "  ■ starship"
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
}

# ── 7. Lazygit ──────────────────────────────────────────────────────
install_lazygit() {
  echo "  ■ lazygit"
  LAZYGIT_VERSION=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
    | grep '"tag_name"' | cut -d'"' -f4 | sed 's/v//')
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" \
    | tar xzf - -C /usr/local/bin lazygit
}

# ── 8. Yazi ─────────────────────────────────────────────────────────
install_yazi() {
  echo "  ■ yazi"
  curl -fsSL https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip \
    | funzip > /usr/local/bin/yazi
  chmod +x /usr/local/bin/yazi
}

# ── 9. ble.sh ──────────────────────────────────────────────────────
install_ble() {
  echo "  ■ ble.sh"
  git clone --recursive https://github.com/akinomyoga/ble.sh "$HOME/.local/share/blesh"
  make -C "$HOME/.local/share/blesh" install PREFIX="$HOME/.local"
}

# ── 10. tmux plugins ───────────────────────────────────────────────
install_tpm() {
  echo "  ■ tmux plugins (TPM + resurrect + continuum)"
  git clone https://github.com/tmux-plugins/tpm "$DOTFILES/tmux/plugins/tpm"
  # Install plugins by starting a headless tmux session
  tmux new-session -d -s __bootstrap_tpm__
  "$DOTFILES/tmux/plugins/tpm/scripts/install_plugins.sh"
  tmux kill-session -t __bootstrap_tpm__ 2>/dev/null || true
}

# ── 11. Dotfiles themselves ────────────────────────────────────────
install_dotfiles() {
  echo "  ■ dotfiles"
  if [ ! -d "$DOTFILES/.git" ]; then
    git clone --recursive "git@github.com:$REPO.git" "$DOTFILES"
  fi
}

# ── 12. Neovim headless setup (Mason LSPs, Treesitter) ────────────
setup_nvim() {
  echo "  ■ neovim plugins + LSPs (headless)"
  nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
  nvim --headless "+MasonInstall lua-language-server stylua eslint-lsp typescript-language-server" +qa 2>/dev/null || true
  nvim --headless "+TSUpdateSync" +qa 2>/dev/null || true
}

# ── Main ────────────────────────────────────────────────────────────
install_system
install_node
install_go
install_rust
install_starship
install_lazygit
install_yazi
install_ble
install_dotfiles
install_tpm
setup_nvim

echo "✔ Purple Ops bootstrap complete — restart your shell"
