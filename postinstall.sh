    # Indique que ce script doit être interprété avec Bash
#!/bin/bash

# === VARIABLES ===
    # Stocke la date et l'heure dans un format compact
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
    # Dossier où seront stockés les logs
LOG_DIR="./logs"
    # Nom du fichier de log (avec la date)
LOG_FILE="$LOG_DIR/postinstall_$TIMESTAMP.log"
    # Répertoire contenant les fichiers de configuration (bashrc, motd, etc.)
CONFIG_DIR="./config"
    # Fichier contenant la liste des paquets à installer
PACKAGE_LIST="./lists/packages.txt"
    # Nom de l'utilisateur connecté (hors root)
USERNAME=$(logname)
    # Chemin vers le dossier personnel de l'utilisateur
USER_HOME="/home/$USERNAME"

# === FUNCTIONS === 

    # Fonction log() : affiche un message avec l’heure et le stocke dans un fichier log
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
    # tee -a permet d’écrire dans le fichier log ET d'afficher à l'écran
}

    # Fonction check_and_install() : installe un paquet si ce n’est pas déjà fait
check_and_install() {
  local pkg=$1  # On récupère le nom du paquet passé en paramètre
  if dpkg -s "$pkg" &>/dev/null; then  # Si le paquet est déjà installé
    log "$pkg is already installed."
  else
    log "Installing $pkg..."
    apt install -y "$pkg" &>>"$LOG_FILE"  # On installe silencieusement et on log
    if [ $? -eq 0 ]; then
      log "$pkg successfully installed."
    else
      log "Failed to install $pkg."
    fi
  fi
}

    # Fonction ask_yes_no() : pose une question à l’utilisateur, renvoie 0 si "oui"
ask_yes_no() {
  read -p "$1 [y/N]: " answer
  case "$answer" in
    [Yy]* ) return 0 ;;  # Si réponse commence par Y ou y → vrai
    * ) return 1 ;;      # Sinon → faux
  esac
}

# === INITIAL SETUP ===

mkdir -p "$LOG_DIR"  # Crée le dossier des logs s’il n’existe pas déjà
touch "$LOG_FILE"    # Crée le fichier de log vide
log "Starting post-installation script. Logged user: $USERNAME"  # Note le début du script dans les logs

# Vérifie que le script est lancé en tant que root (EUID = 0 pour root)
if [ "$EUID" -ne 0 ]; then
  log "This script must be run as root."  # Message d’erreur si non-root
  exit 1  # Stoppe le script
fi


# === 1. SYSTEM UPDATE ===

log "Updating system packages..."  # Message dans le log : début de la mise à jour
apt update && apt upgrade -y &>>"$LOG_FILE"  
# Met à jour la liste des paquets ET met à jour les paquets installés
# Le tout est redirigé dans le fichier de log sans afficher à l’écran


# === 2. PACKAGE INSTALLATION ===

if [ -f "$PACKAGE_LIST" ]; then  # Vérifie que le fichier de liste existe
  log "Reading package list from $PACKAGE_LIST"
  
  # Boucle qui lit chaque ligne du fichier packages.txt
  while IFS= read -r pkg || [[ -n "$pkg" ]]; do
    [[ -z "$pkg" || "$pkg" =~ ^# ]] && continue  
    # Si la ligne est vide ou commence par # → on passe à la suivante
    
    check_and_install "$pkg"  # Appelle la fonction d’installation
  done < "$PACKAGE_LIST"

else
  log "Package list file $PACKAGE_LIST not found. Skipping package installation."
  # Si le fichier n’existe pas → message dans les logs et on saute l’installation
fi


# === 3. UPDATE MOTD ===

if [ -f "$CONFIG_DIR/motd.txt" ]; then  # Vérifie que le fichier motd.txt existe dans config/
  cp "$CONFIG_DIR/motd.txt" /etc/motd   # Copie ce fichier dans /etc/motd (emplacement système)
  log "MOTD updated."                   # Log de confirmation
else
  log "motd.txt not found."             # Log d’erreur si le fichier est absent
fi

# === 4. CUSTOM .bashrc ===

if [ -f "$CONFIG_DIR/bashrc.append" ]; then  # Vérifie que le fichier bashrc.append existe
  cat "$CONFIG_DIR/bashrc.append" >> "$USER_HOME/.bashrc"  # Ajoute son contenu à la fin du .bashrc utilisateur
  chown "$USERNAME:$USERNAME" "$USER_HOME/.bashrc"         # Assure que l’utilisateur reste propriétaire du fichier
  log ".bashrc customized."                                # Log de confirmation
else
  log "bashrc.append not found."                           # Log d’erreur si fichier absent
fi


# === 5. CUSTOM .nanorc ===

if [ -f "$CONFIG_DIR/nanorc.append" ]; then  # Vérifie que le fichier nanorc.append existe
  cat "$CONFIG_DIR/nanorc.append" >> "$USER_HOME/.nanorc"  # Ajoute son contenu à la fin du .nanorc utilisateur
  chown "$USERNAME:$USERNAME" "$USER_HOME/.nanorc"         # Assure que l’utilisateur reste propriétaire du fichier
  log ".nanorc customized."                                # Log de confirmation
else
  log "nanorc.append not found."                           # Log si le fichier est absent
fi


# === 6. ADD SSH PUBLIC KEY ===

if ask_yes_no "Would you like to add a public SSH key?"; then  # Pose la question à l’utilisateur
  read -p "Paste your public SSH key: " ssh_key               # Récupère la clé entrée par l’utilisateur
  mkdir -p "$USER_HOME/.ssh"                                  # Crée le dossier .ssh s’il n’existe pas
  echo "$ssh_key" >> "$USER_HOME/.ssh/authorized_keys"        # Ajoute la clé au fichier des clés autorisées
  chown -R "$USERNAME:$USERNAME" "$USER_HOME/.ssh"            # Donne les bons droits à l’utilisateur
  chmod 700 "$USER_HOME/.ssh"                                 # Dossier .ssh : accès restreint
  chmod 600 "$USER_HOME/.ssh/authorized_keys"                 # Fichier de clés : lecture/écriture par le propriétaire uniquement
  log "SSH public key added."                                 # Log de confirmation
fi


# === 7. SSH CONFIGURATION: KEY AUTH ONLY ===

if [ -f /etc/ssh/sshd_config ]; then  # Vérifie que le fichier de config SSH existe
  sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
  # Désactive l’authentification par mot de passe

  sed -i 's/^#\?ChallengeResponseAuthentication.*/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
  # Désactive l’authentification par question/réponse

  sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
  # Active l’authentification par clé publique

  systemctl restart ssh  # Redémarre le service SSH pour appliquer les changements
  log "SSH configured to accept key-based authentication only."  # Log de confirmation
else
  log "sshd_config file not found."  # Log d’erreur si le fichier n’existe pas
fi


log "Post-installation script completed."  # Message de fin
exit 0  # Quitte le script proprement