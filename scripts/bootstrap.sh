#!/usr/bin/env bash
# bootstrap.sh
# One-time setup: installs init-project as a global command
#
# Usage (run once):
#   curl -fsSL https://raw.githubusercontent.com/Sahagan/sahagan_agent_template/main/scripts/bootstrap.sh | bash
#
# After bootstrap, from any folder:
#   init-project my-project
#   init-project my-project https://github.com/user/repo.git
#   init-project my-project https://github.com/user/repo.git ~/projects

set -euo pipefail

RAW_BASE="https://raw.githubusercontent.com/Sahagan/sahagan_agent_template/main/scripts"
INSTALL_DIR="$HOME/.sahagan/scripts"
BIN_LINK="/usr/local/bin/init-project"

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   Sahagan Agent Template — Bootstrap     ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# ─── Step 1: Download init-project.sh ─────────────────────────────────────────

mkdir -p "$INSTALL_DIR"
SCRIPT_PATH="$INSTALL_DIR/init-project.sh"

echo "  [1/3] Downloading init-project.sh..."
curl -fsSL "$RAW_BASE/init-project.sh" -o "$SCRIPT_PATH"
chmod +x "$SCRIPT_PATH"
echo "  [1/3] Saved to: $SCRIPT_PATH ✓"

# ─── Step 2: Create symlink or shell function ──────────────────────────────────

echo "  [2/3] Installing global command..."

# Try to create symlink in /usr/local/bin (may need sudo)
if ln -sf "$SCRIPT_PATH" "$BIN_LINK" 2>/dev/null; then
    echo "  [2/3] Symlink created: $BIN_LINK ✓"
else
    # Fallback: add to ~/.bashrc and ~/.zshrc
    SHELL_FUNC="
# ── Sahagan Agent Template ──────────────────────────────────────────────────
alias init-project='$SCRIPT_PATH'
# ────────────────────────────────────────────────────────────────────────────"

    for RC_FILE in "$HOME/.bashrc" "$HOME/.zshrc"; do
        if [[ -f "$RC_FILE" ]] || [[ "$RC_FILE" == "$HOME/.bashrc" ]]; then
            if ! grep -q "Sahagan Agent Template" "$RC_FILE" 2>/dev/null; then
                echo "$SHELL_FUNC" >> "$RC_FILE"
                echo "  [2/3] Added alias to $RC_FILE ✓"
            else
                echo "  [2/3] Already in $RC_FILE (skipped)"
            fi
        fi
    done

    # Load for current session
    alias init-project="$SCRIPT_PATH"
fi

# ─── Step 3: Verify ───────────────────────────────────────────────────────────

echo "  [3/3] Verifying..."
if command -v init-project &>/dev/null || [[ -L "$BIN_LINK" ]]; then
    echo "  [3/3] init-project is available ✓"
else
    echo "  [3/3] Restart your terminal to activate"
fi

# ─── Done ─────────────────────────────────────────────────────────────────────

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║   Bootstrap complete!              ✓      ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""
echo "  From now on, run from ANY folder:"
echo ""
echo "    init-project my-project"
echo "    init-project my-project https://github.com/user/repo.git"
echo "    init-project my-project https://github.com/user/repo.git ~/projects"
echo ""
echo "  (Restart terminal if command not found yet)"
echo ""
