#!/usr/bin/env bash

echo "🚀 Installing Linux Font Installer..."

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    echo "❌ Error: curl is not installed. Please install curl first."
    exit 1
fi

# Check if wget is installed
if ! command -v wget &> /dev/null; then
    echo "❌ Error: wget is not installed. Please install wget first."
    exit 1
fi

# Check if unzip is installed
if ! command -v unzip &> /dev/null; then
    echo "❌ Error: unzip is not installed. Please install unzip first."
    exit 1
fi

# Check if tar is installed
if ! command -v tar &> /dev/null; then
    echo "❌ Error: tar is not installed. Please install tar first."
    exit 1
fi

# Check if file is installed
if ! command -v file &> /dev/null; then
    echo "❌ Error: file is not installed. Please install file first."
    exit 1
fi

# Download the font installer script
echo "📥 Downloading font installer..."
sudo curl -o /usr/local/bin/font-install https://raw.githubusercontent.com/theandreibogdan/linux-font-installer/main/font_installer.sh

# Make it executable
echo "🔧 Setting up permissions..."
sudo chmod +x /usr/local/bin/font-install

echo "✨ Installation completed! You can now use the 'font-install' command."
echo "📚 Usage example: font-install https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip" 