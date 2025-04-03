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

Ce script bash permet d’automatiser l’installation initiale d’un environnement Debian 12 en mode technicien réseau/système :

- ✅ Mettre à jour le système  
- ✅ Installer des paquets via `apt`  
- ✅ Appliquer un `.bashrc` stylé (alias, couleur, infos)  
- ✅ Appliquer un `.nanorc` coloré et lisible  
- ✅ Afficher un motd ASCII avec une loutre badass  
- ✅ Proposer d'ajouter une clé SSH  
- ✅ Générer un log d’installation  

---

## ⚙️ Prérequis

- Debian 12 installé  
- Connexion internet active  
- Accès root ou `sudo`

---

## 🚀 Exécution du script

```bash
sudo chmod +x postinstall.sh
sudo ./postinstall.sh
```

> Le script pose une question à l’utilisateur pour ajouter une clé SSH.  
> Un fichier `install.log` est généré à la racine pour suivre toutes les étapes.

---

## 🧩 Détails des fichiers personnalisés

| Fichier              | Description                                 |
|----------------------|---------------------------------------------|
| `config/.bashrc`     | Prompt personnalisé + alias utiles          |
| `config/.nanorc`     | Affichage des couleurs + numéros de ligne   |
| `config/motd.txt`    | Bannière ASCII (loutre stylée 🦦)            |
| `lists/packages.txt` | Liste de paquets utiles à installer         |

---

## 📦 Exemple de paquets installés

Voici un extrait de la liste `packages.txt` :
- `htop`, `neofetch`, `curl`, `wget`, `vim`, `git`, `nmap`, `openssh-server`, `net-tools`, `tree`, `sudo`, `build-essential`, etc.

Tu peux modifier cette liste à ta convenance avant l’exécution du script.

---

## ⚠️ À savoir

> Le script ne relance pas le service SSH automatiquement.  
> Tu peux le faire manuellement avec :

```bash
sudo systemctl restart sshd.service
```

---

## ✅ Statut du projet

- 💯 Fonctionnel  
- 🧪 Testé sur Debian 12 (version minimale)  
- ✍️ Commenté pour un usage pédagogique  
- 🔥 Bonus : tout stylé comme un·e vrai·e Lucifer TSSR 😈

---

## 🙋‍♀️ Auteur

**Lucifer-BC**  
👩‍💻 [Portfolio GitHub Pages](https://lucifer-bc.github.io)  
🐙 [GitHub](https://github.com/Lucifer-BC)  
💼 [LinkedIn](https://www.linkedin.com/in/lucie-collet-beasle)

---

🦦 *Même l’enfer mérite une config propre.*
