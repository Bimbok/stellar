#!/data/data/com.termux/files/usr/bin/bash

# --- Configuration ---
BIN_DIR="$HOME/bin"
SCRIPTS=("nebula" "comet")
DEPENDENCIES=("rclone" "fzf" "python" "curl" "procps" "lsof")

# --- Utils ---
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
RESET='\033[0m'

log_info() { echo -e "${BLUE}ℹ${RESET} $1"; }
log_success() { echo -e "${GREEN}✔${RESET} $1"; }
log_warn() { echo -e "${YELLOW}⚠${RESET} $1"; }
log_error() { echo -e "${RED}✖ $1${RESET}"; }

# --- Execution ---

echo -e "${BOLD}Gemini CLI - Nebula & Comet Installer${RESET}
"

# 1. Install Dependencies
log_info "Updating package lists..."
pkg update -y >/dev/null 2>&1

log_info "Installing dependencies: ${DEPENDENCIES[*]}..."
pkg install "${DEPENDENCIES[@]}" -y >/dev/null 2>&1

# 2. Setup Bin Directory
if [ ! -d "$BIN_DIR" ]; then
    log_info "Creating $BIN_DIR..."
    mkdir -p "$BIN_DIR"
fi

# 3. Move Scripts & Set Permissions
REPO_RAW_URL="https://raw.githubusercontent.com/Bimbok/stellar/main"

for script in "${SCRIPTS[@]}"; do
    if [ -f "./$script" ]; then
        log_info "Setting up $script (local)..."
        chmod +x "./$script"
        if [ "$(realpath "./$script")" != "$(realpath "$BIN_DIR/$script")" ]; then
            cp "./$script" "$BIN_DIR/"
        fi
    else
        log_info "Downloading $script from GitHub..."
        curl -sSL "$REPO_RAW_URL/$script" -o "$BIN_DIR/$script" || log_error "Failed to download $script"
        chmod +x "$BIN_DIR/$script"
    fi
done

# 4. PATH Configuration
PATH_ENTRY='export PATH="$HOME/bin:$PATH"'
SHELL_CONFIGS=("$HOME/.bashrc" "$HOME/.zshrc")
ADDED_TO_PATH=0

for config in "${SHELL_CONFIGS[@]}"; do
    if [ -f "$config" ]; then
        if ! grep -q "$PATH_ENTRY" "$config"; then
            log_info "Adding $BIN_DIR to $config..."
            echo -e "
# Added by Gemini CLI Installer
$PATH_ENTRY" >> "$config"
            ADDED_TO_PATH=1
        fi
    fi
done

# 5. Rclone Configuration Check
if ! rclone listremotes | grep -q "gdrive:"; then
    echo ""
    log_warn "No 'gdrive:' remote found in rclone."
    log_info "You should run ${BOLD}rclone config${RESET} to set up your Google Drive remote."
    log_info "Name it 'gdrive' for the default configuration to work."
fi

# 6. MPV Check
echo ""
log_info "Note: This setup requires ${BOLD}MPV for Android${RESET} to be installed."
log_info "You can find it on the Play Store or F-Droid (is.xyz.mpv)."

echo -e "
${GREEN}${BOLD}Installation Complete!${RESET}"
if [ $ADDED_TO_PATH -eq 1 ]; then
    log_warn "Please restart your terminal or run: ${BOLD}source ~/.bashrc${RESET}"
fi
log_success "You can now run 'nebula' and 'comet' from anywhere."
