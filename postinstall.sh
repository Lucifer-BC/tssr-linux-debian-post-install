#!/bin/bash -e

# === VARIABLES ===
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/postinstall_$TIMESTAMP.log"
CONFIG_DIR="./config"
PACKAGE_LIST="./lists/packages.txt"
USERNAME=$(logname)
USER_HOME="/home/$USERNAME"

# === FONCTIONS ===

log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_and_install() {
  local pkg=$1
  if dpkg -s "$pkg" &>/dev/null; then
    log "$pkg is already installed."
  else
    log "Installing $pkg..."
    apt install -y "$pkg" &>>"$LOG_FILE"
    if [ $? -eq 0 ]; then
      log "$pkg successfully installed."
    else
      log "Failed to install $pkg."
    fi
  fi
}

ask_yes_no() {
  read -p "$1 [y/N]: " answer
  case "$answer" in
    [Yy]* ) return 0 ;;
    * ) return 1 ;;
  esac
}

# === DÉBUT DU SCRIPT ===

mkdir -p "$LOG_DIR"
touch "$LOG_FILE"
log "Starting post-installation script. Logged user: $USERNAME"

if [ "$EUID" -ne 0 ]; then
  log "This script must be run as root."
  exit 1
fi

# === 1. MISE À JOUR SYSTÈME ===
log "Updating system packages..."
apt update && apt upgrade -y &>>"$LOG_FILE"

# === 2. INSTALLATION DES PAQUETS ===
if [ -f "$PACKAGE_LIST" ]; then
  log "Reading package list from $PACKAGE_LIST"

  while IFS= read -r pkg; do
    [ -z "$pkg" ] && continue
    check_and_install "$pkg"
  done < "$PACKAGE_LIST"
else
  log "Package list file $PACKAGE_LIST not found. Skipping package installation."
fi

# === 3. MOTD ===
if [ -f "$CONFIG_DIR/motd.txt" ]; then
  cp "$CONFIG_DIR/motd.txt" /etc/motd
  log "MOTD updated."
else
  log "motd.txt not found."
fi

# === 4. .bashrc ===
if [ -f "$CONFIG_DIR/bashrc.append" ]; then
  cat "$CONFIG_DIR/bashrc.append" >> "$USER_HOME/.bashrc"
  chown "$USERNAME:$USERNAME" "$USER_HOME/.bashrc"
  log ".bashrc customized."
else
  log "bashrc.append not found."
fi

# === 5. .nanorc ===
if [ -f "$CONFIG_DIR/nanorc.append" ]; then
  cat "$CONFIG_DIR/nanorc.append" >> "$USER_HOME/.nanorc"
  chown "$USERNAME:$USERNAME" "$USER_HOME/.nanorc"
  log ".nanorc customized."
else
  log "nanorc.append not found."
fi

# === 6. SSH KEY ===
if ask_yes_no "Would you like to add a public SSH key?"; then
  read -p "Paste your public SSH key: " ssh_key
  mkdir -p "$USER_HOME/.ssh"
  echo "$ssh_key" >> "$USER_HOME/.ssh/authorized_keys"
  chown -R "$USERNAME:$USERNAME" "$USER_HOME/.ssh"
  chmod 700 "$USER_HOME/.ssh"
  chmod 600 "$USER_HOME/.ssh/authorized_keys"
  log "SSH public key added."
fi

# === 7. SÉCURISATION SSH ===
if [ -f /etc/ssh/sshd_config ]; then
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
  sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
  systemctl restart ssh
  log "SSH configured to accept key-based authentication only."
else
  log "sshd_config file not found."
fi

log "Post-installation script completed."
exit 0
