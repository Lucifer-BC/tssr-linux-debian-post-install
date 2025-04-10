# 🐧 TSSR - Linux Post Install Script

Script d’installation et de personnalisation pour Debian 12, destiné aux technicien·ne·s TSSR qui veulent aller vite, proprement, et avec du style 🔥

---

## 📁 Arborescence du projet

```
📦 tssr-linux-debian-post-install/
├── 📁 config/
│   ├── .bashrc         → Fichier bashrc personnalisé (alias + prompt)
│   ├── .nanorc         → Configuration pour nano avec couleurs
│   └── motd.txt        → Message d’accueil ASCII (loutre stylée 🦦)
├── 📁 lists/
│   └── packages.txt    → Liste personnalisée de paquets à installer
├── 🖥️ postinstall.sh     → Script d’installation principal
└── 📄 README.md         → Ce fichier
```

---

## 🎯 Objectifs du script

Ce script Bash automatise la post-installation d’une Debian 12 minimale pour un usage **TSSR** :

- ✅ Mise à jour complète du système  
- ✅ Installation de paquets réseau/console utiles  
- ✅ Ajout d’un `.bashrc` customisé (prompt stylé + alias)  
- ✅ Ajout d’un `.nanorc` coloré  
- ✅ Affichage d’un **motd** ASCII badass (🦦 inside)  
- ✅ Configuration SSH sécurisée (clé publique only)  
- ✅ Génération d’un fichier de log  
- ✅ **Mode `--dry-run`** pour tester sans exécuter  

---

## ⚙️ Prérequis

- Debian 12 (idéalement en VM)
- Connexion internet active
- Accès root ou `sudo`
- Git installé :
```bash
sudo apt update && sudo apt install git -y
```

---

## 🚀 Installation et exécution

Cloner le dépôt :

```bash
git clone https://github.com/Lucifer-BC/tssr-linux-debian-post-install.git
cd tssr-linux-debian-post-install
chmod +x postinstall.sh
```

**Lancer le script :**
```bash
sudo ./postinstall.sh
```

**Ou tester le script sans rien modifier (`dry-run`) :**
```bash
sudo ./postinstall.sh --dry-run
```

---

## 🧩 Contenu personnalisé

| Fichier              | Rôle                                 |
|----------------------|----------------------------------------|
| `config/.bashrc`     | Prompt stylé, alias utiles, neofetch   |
| `config/.nanorc`     | Numérotation, coloration pour nano     |
| `config/motd.txt`    | Art ASCII personnalisé (loutre badass) |
| `lists/packages.txt` | Liste des paquets installés avec apt   |

---

## 📦 Extrait des paquets installés

- `htop`, `curl`, `wget`, `vim`, `git`, `neofetch`,  
  `net-tools`, `tree`, `nmap`, `openssh-server`,  
  `ufw`, `fail2ban`, `sudo`, `gnupg`, `build-essential`, etc.

Modifie le fichier `packages.txt` à ta guise.

---

## 🔐 Sécurisation SSH

- Option d’ajout automatique de ta clé publique
- Désactivation de l’authentification par mot de passe
- Redémarrage du service SSH à la fin

---

## 🔍 Tester en VM Debian 12

1. Crée une VM Debian 12 (mode netinst ou graphique)
2. Ouvre un terminal
3. Installe `git` si nécessaire :
```bash
sudo apt update && sudo apt install git -y
```
4. Clone le dépôt :
```bash
git clone https://github.com/Lucifer-BC/tssr-linux-debian-post-install.git
cd tssr-linux-debian-post-install
chmod +x postinstall.sh
```
5. Lancer avec :
```bash
sudo ./postinstall.sh
```

---

## ✅ Vérification post-installation

- ✅ `htop`, `nmap`, `tree`, `neofetch` fonctionnent
- ✅ `.bashrc` & `.nanorc` modifiés dans `~`
- ✅ `/etc/motd` contient l’art ASCII
- ✅ Fichier `logs/postinstall_*.log` créé avec suivi détaillé

---

## ⚠️ Remarques

- Le script **ne relance pas automatiquement le système**
- Pour redémarrer manuellement le service SSH :
```bash
sudo systemctl restart sshd.service
```

---

## ✅ Statut du projet

- 🔧 Fonctionnel et testé
- ✍️ Commenté pour apprentissage TSSR
- 🔥 Ultra stylé pour impressionner tes formateurs (ou Lucifer)

---

## 🙋‍♀️ Auteur

**Lucifer-BC**  
🌐 [Portfolio GitHub Pages](https://lucifer-bc.github.io)  
🐙 [GitHub](https://github.com/Lucifer-BC)  
💼 [LinkedIn](https://www.linkedin.com/in/lucie-collet-beasle)

---

🦦 *Même l’enfer mérite une config propre.*
