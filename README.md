# Linux Font Installer

A simple command-line tool to easily install fonts on Linux systems. Just provide a URL to a font zip file, and the tool will handle the download, extraction, and installation automatically.

## 🚀 Quick Install

```bash
curl -fsSL https://raw.githubusercontent.com/theandreibogdan/linux-font-installer/main/install.sh | sudo bash
```

## 📋 Requirements

- curl
- wget
- unzip

## 🎯 Usage

After installation, you can use the `font-install` command from anywhere in your terminal:

```bash
font-install <font-zip-url>
```

### Example:
```bash
font-install https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
```

## ✨ Features

- Easy one-line installation
- Global command accessible from anywhere
- Automatic font cache update
- Error handling and validation
- Progress feedback
- Cleanup after installation

## 🔒 Security

The installer requires sudo privileges to:
1. Install the script in `/usr/local/bin`
2. Create the fonts directory if it doesn't exist
3. Move font files to the system fonts directory
4. Update the font cache

## 📝 License

MIT License
