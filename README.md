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
- tar
- file

## 🎯 Usage

After installation, you can use the `font-install` command from anywhere in your terminal:

```bash
font-install <font-zip-url>
```

### Example:
```bash
font-install https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
```

To uninstall the script (this won't remove installed fonts):
```bash
font-install uninstall
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

## 🔍 Finding and Installing Fonts

Looking for awesome fonts to install? Here's a quick tutorial:

1. Open the [Nerd Fonts download page](https://www.nerdfonts.com/font-downloads) in your web browser.
2. Browse through the extensive collection and find a font that catches your eye.
3. Right-click on the 'Download' button next to the font you like and select 'Copy Link'.
4. Come back to your terminal and run:

   ```bash
   font-install <paste-the-copied-link-here>
   ```

   For example:
   ```bash
   font-install https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip
   ```

That's it! The font-installer will handle the download, extraction, and installation process for you. In just a few moments, you'll have your new font ready to use.

Happy font hunting! 🎉
