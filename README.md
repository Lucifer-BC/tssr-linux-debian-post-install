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

Ce script bash permet d’automatiser l’installation initiale d’un environnement Debian 12 en mode technicien système & réseau :

- ✅ Mettre à jour le système  
- ✅ Installer des paquets via `apt`  
- ✅ Appliquer un `.bashrc` stylé (alias, couleurs, infos)  
- ✅ Appliquer un `.nanorc` coloré pour un `nano` agréable  
- ✅ Afficher un motd ASCII avec une loutre badass 🦦  
- ✅ Proposer d'ajouter une clé SSH (optionnel)  
- ✅ Générer un fichier de log avec le résumé des actions  

---

## ⚙️ Prérequis

- Debian 12 installé (testé en VM)
- Connexion internet active
- Accès root ou via `sudo`
- `git` installé (si besoin : `sudo apt install git -y`)

---

## 🚀 Installation et exécution du script

Cloner ce dépôt sur la machine :

```bash
git clone https://github.com/Lucifer-BC/tssr-linux-debian-post-install.git
cd tssr-linux-debian-post-install
chmod +x postinstall.sh
sudo ./postinstall.sh
```

Le script :
- pose une question pour ajouter une clé SSH,
- installe les paquets définis,
- copie les fichiers de configuration personnalisés,
- et crée un log dans `install.log`.

---

## 🧩 Fichiers personnalisés

| Fichier              | Description                                 |
|----------------------|---------------------------------------------|
| `config/.bashrc`     | Prompt coloré, alias utiles, message d'accueil |
| `config/.nanorc`     | Numéros de lignes, coloration syntaxique     |
| `config/motd.txt`    | Bannière ASCII en mode loutre infernale 🦦  |
| `lists/packages.txt` | Liste des paquets à installer via APT       |

---

## 📦 Exemples de paquets installés

Extrait de la liste `packages.txt` :
- `htop`, `neofetch`, `curl`, `wget`, `vim`, `git`,  
  `nmap`, `openssh-server`, `net-tools`, `tree`, `sudo`, `build-essential`, etc.

Tu peux modifier cette liste avant l'exécution selon tes besoins.

---

## 🧪 Tester le script sur une VM Debian

1. Lancer une nouvelle VM Debian 12
2. Ouvrir un terminal
3. Installer Git si ce n’est pas déjà fait :
```bash
sudo apt update && sudo apt install git -y
```
4. Cloner le dépôt :
```bash
git clone https://github.com/Lucifer-BC/tssr-linux-debian-post-install.git
cd tssr-linux-debian-post-install
```
5. Rendre le script exécutable :
```bash
chmod +x postinstall.sh
```
6. Lancer le script :
```bash
sudo ./postinstall.sh
```

### 🔍 Vérifications post-installation :

- `htop`, `nmap`, `tree`, etc. fonctionnent en terminal
- `neofetch` s’affiche automatiquement à l’ouverture du terminal
- `.bashrc` et `.nanorc` sont bien présents dans `~`
- `/etc/motd` contient l’art ASCII de la loutre
- Un fichier `install.log` est présent dans le dossier du script

---

## ⚠️ À savoir

> Le script ne redémarre pas le service SSH automatiquement.  
> Tu peux le faire manuellement si nécessaire :

```bash
sudo systemctl restart sshd.service
```

---

## ✅ Statut du projet

- 💯 Fonctionnel et testé  
- 📦 Adapté à une VM Debian 12 de base  
- ✍️ Commenté pour apprentissage et réutilisation  
- 🔥 Bonus : ça tape dans le terminal (au propre comme au figuré)

---

## 🙋‍♀️ Auteur

**Lucifer-BC**  
👩‍💻 [Portfolio GitHub Pages](https://lucifer-bc.github.io)  
🐙 [GitHub](https://github.com/Lucifer-BC)  
💼 [LinkedIn](https://www.linkedin.com/in/lucie-collet-beasle)

---

🦦 *Même l’enfer mérite une config propre.*
