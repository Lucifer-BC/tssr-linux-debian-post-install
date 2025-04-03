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
    log "✔️ $pkg is already installed."
  else
    log "📦 Installing $pkg..."
    apt install -y "$pkg" &>>"$LOG_FILE"
    if [ $? -eq 0 ]; then
      log "✅ $pkg successfully installed."
    else
      log "❌ Failed to install $pkg."
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
log "🚀 Starting post-installation script. Logged user: $USERNAME"

if [ "$EUID" -ne 0 ]; then
  log "❌ This script must be run as root."
  exit 1
fi

# === DRY RUN MODE ===
if ask_yes_no "🧪 Voulez-vous tester les paquets avant l'installation (dry-run) ?"; then
  log "=== DRY RUN MODE ACTIVÉ ==="
  if [ -f "$PACKAGE_LIST" ]; then
    while IFS= read -r pkg || [[ -n "$pkg" ]]; do
      [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
      dpkg -s "$pkg" &>/dev/null && log "✔️ $pkg est déjà installé" && continue

      apt-cache show "$pkg" &>/dev/null
      if [ $? -eq 0 ]; then
        log "➕ $pkg est disponible dans les dépôts"
      else
        log "❌ $pkg est introuvable dans les dépôts APT"
      fi
    done < "$PACKAGE_LIST"
  else
    log "❌ Fichier de liste de paquets introuvable : $PACKAGE_LIST"
  fi

  if ! ask_yes_no "✅ Voulez-vous maintenant procéder à l'installation réelle ?"; then
    log "⛔ Annulation par l'utilisateur. Fin du script."
    exit 0
  fi
fi

# === 1. MISE À JOUR SYSTÈME ===
log "🔄 Updating system packages..."
apt update && apt upgrade -y &>>"$LOG_FILE"

# === 2. INSTALLATION DES PAQUETS ===
if [ -f "$PACKAGE_LIST" ]; then
  log "📦 Lecture de la liste des paquets dans $PACKAGE_LIST"

  while IFS= read -r pkg; do
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue
    check_and_install "$pkg"
  done < "$PACKAGE_LIST"
else
  log "❌ Liste de paquets non trouvée : $PACKAGE_LIST"
fi

# === 3. MOTD ===
if [ -f "$CONFIG_DIR/motd.txt" ]; then
  cp "$CONFIG_DIR/motd.txt" /etc/motd
  log "🖼️ MOTD mis à jour."
else
  log "⚠️ motd.txt introuvable."
fi

# === 4. .bashrc ===
if [ -f "$CONFIG_DIR/bashrc.append" ]; then
  cat "$CONFIG_DIR/bashrc.append" >> "$USER_HOME/.bashrc"
  chown "$USERNAME:$USERNAME" "$USER_HOME/.bashrc"
  log "💡 .bashrc personnalisé."
else
  log "⚠️ bashrc.append introuvable."
fi

# === 5. .nanorc ===
if [ -f "$CONFIG_DIR/nanorc.append" ]; then
  cat "$CONFIG_DIR/nanorc.append" >> "$USER_HOME/.nanorc"
  chown "$USERNAME:$USERNAME" "$USER_HOME/.nanorc"
  log "📝 .nanorc personnalisé."
else
  log "⚠️ nanorc.append introuvable."
fi

# === 6. SSH KEY ===
if ask_yes_no "🔐 Voulez-vous ajouter une clé publique SSH ?"; then
  read -p "📥 Collez votre clé publique SSH : " ssh_key
  mkdir -p "$USER_HOME/.ssh"
  echo "$ssh_key" >> "$USER_HOME/.ssh/authorized_keys"
  chown -R "$USERNAME:$USERNAME" "$USER_HOME/.ssh"
  chmod 700 "$USER_HOME/.ssh"
  chmod 600 "$USER_HOME/.ssh/authorized_keys"
  log "🔑 Clé SSH ajoutée."
fi

# === 7. SÉCURISATION SSH ===
if [ -f /etc/ssh/sshd_config ]; then
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
  sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
  sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
  systemctl restart ssh
  log "🛡️ SSH configuré avec authentification par clé uniquement."
else
  log "⚠️ Fichier sshd_config introuvable."
fi

log "✅ Script post-installation terminé."
exit 0
