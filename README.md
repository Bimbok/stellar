# ✨ Stellar

Stellar is a collection of high-performance CLI utility scripts for **Termux** designed to turn your Android device into a powerful remote media streamer. It leverages `rclone` to serve your cloud storage (like Google Drive) and `fzf` for a lightning-fast file selection experience, launching content directly into the **MPV** media player.

## 🚀 Key Components

### 🌌 Nebula (`nebula`)
A robust daemon manager for `rclone serve http`. It runs in the background, exposing your cloud storage as a local HTTP stream.
- **Daemonized:** Runs as a background process.
- **Auto-Discovery:** Automatically detects your local IP for network streaming.
- **State Management:** Simple commands to start, stop, and check server status.

### ☄️ Comet (`comet`)
The interactive frontend for browsing and playing media.
- **Fast Search:** Uses `fzf` for fuzzy searching through your remote files.
- **Intent Launching:** Directly communicates with the MPV Android app to start playback.
- **Dynamic Links:** Automatically encodes URLs and handles pathing between Nebula and MPV.

---

## 📥 Installation

You can install Stellar directly using `curl`. This script will install necessary dependencies, move the scripts to your `~/bin` directory, and update your `PATH`.

```bash
curl -sSL https://raw.githubusercontent.com/Bimbok/stellar/main/install.sh | bash
```

### 📋 Prerequisites
1. **Termux:** Installed from [F-Droid](https://f-droid.org/en/packages/com.termux/).
2. **MPV for Android:** Installed via Play Store or [F-Droid](https://f-droid.org/en/packages/is.xyz.mpv/).
3. **Rclone Config:** You must have an rclone remote configured.
   - Run `rclone config`
   - Name your remote `gdrive` (or specify your remote name when using the scripts).

---

## 🛠 Usage

### 1. Start the Stream Server (`nebula`)
Before streaming, you need to start the background service:
```bash
nebula start
```
Other commands:
- `nebula status`: Check if the server is running.
- `nebula stop`: Stop the background service.
- `nebula logs`: View the server logs.

### 2. Browse and Play (`comet`)
Once Nebula is running, use Comet to find your media:
```bash
# Browse the default path (movies)
comet

# Browse a specific folder
comet -p "TV Shows/Anime"

# Use a different rclone remote
comet -r "my_onedrive" -p "Videos"
```

---

## ⚙️ Configuration
Stellar looks for a remote named `gdrive` by default. You can change this by setting environment variables in your `.bashrc` or `.zshrc`:

```bash
export NEBULA_REMOTE="my_remote:"
export NEBULA_PORT="8080"
```

## 📦 Dependencies
The installer automatically handles these, but for reference:
- `rclone`: The engine for cloud access.
- `fzf`: For the interactive UI.
- `python3`: For robust URL encoding.
- `curl`: For health checks.
- `mpv (Android app)`: The actual media player.

---

## 🤝 Contributing
Feel free to open issues or submit pull requests on the [GitHub repository](https://github.com/Bimbok/stellar.git).

---
*Created with ❤️ for the Termux community.*
