#!/usr/bin/env bash

# Check if the script is called with the -h or --help option
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
  ehco ""
  echo "Usage: font-install <font-zip-url>"
  echo "       font-install uninstall"
  echo ""
  echo "Options:"
  echo "  -h, --help    Show this help message and exit"
  echo "  uninstall     Uninstall the Linux Font Installer"
  echo ""
  echo "🔍 Looking for awesome fonts to install? Here's a quick tutorial!"
  echo ""
  echo "1. Open the Nerd Fonts download page: https://www.nerdfonts.com/font-downloads"
  echo "2. Browse through the collection and find a font you like."
  echo "3. Right-click on the 'Download' button next to the font and select 'Copy Link'."
  echo "4. Come back to your terminal and run:"
  echo ""
  echo "   font-install <paste-the-copied-link-here>"
  echo ""
  echo "   For example:"
  echo "   font-install https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip"
  echo ""
  echo "That's it! The font-installer will handle the download, extraction, and installation for you."
  echo "Happy font hunting! 🎉"
  exit 0
fi

# Check if uninstall command
if [ "$1" = "uninstall" ]; then
    echo "🗑️  Uninstalling Linux Font Installer..."
    
    # Remove the script
    if sudo rm -f /usr/local/bin/font-install; then
        echo "✨ Linux Font Installer has been successfully uninstalled!"
    else
        echo "❌ Error: Failed to uninstall. Please try again with sudo privileges."
        exit 1
    fi
    exit 0
fi

# Check if the script is called with the --fonts option
if [ "$1" = "--fonts" ]; then
  echo "🔍 Looking for awesome fonts to install? Here's a quick tutorial!"
  echo ""
  echo "1. Open the Nerd Fonts download page: https://www.nerdfonts.com/font-downloads"
  echo "2. Browse through the collection and find a font you like."
  echo "3. Right-click on the 'Download' button next to the font and select 'Copy Link'."
  echo "4. Come back to your terminal and run:"
  echo ""
  echo "   font-install <paste-the-copied-link-here>"
  echo ""
  echo "   For example:"
  echo "   font-install https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/JetBrainsMono.zip"
  echo ""
  echo "That's it! The font-installer will handle the download, extraction, and installation for you."
  echo "Happy font hunting! 🎉"
  exit 0
fi

# Continue with existing URL check
if [ -z "$1" ]; then
    echo "Error: Please provide a URL to a font zip file or use 'uninstall' command."
    echo "Usage: font-install <font-zip-url>"
    echo "       font-install uninstall"
    exit 1
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory for download..."

# Download the font package
echo "Downloading font package..."
if ! wget -O "$TEMP_DIR/font.archive" "$1"; then
  echo "Error: Failed to download the font package"
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Check if the downloaded file is a valid archive
if ! file "$TEMP_DIR/font.archive" | grep -q "archive"; then
  echo "Error: The downloaded file is not a valid archive"
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Detect file type and extract accordingly
echo "Extracting font files..."
if file "$TEMP_DIR/font.archive" | grep -q "XZ compressed data"; then
  # Handle tar.xz files
  if ! tar -xf "$TEMP_DIR/font.archive" -C "$TEMP_DIR"; then
    echo "Error: Failed to extract the tar.xz package"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
  
  # Move font files from subdirectory to main directory if needed
  if [ "$(ls -A $TEMP_DIR/*.{ttf,otf} 2>/dev/null)" = "" ]; then
    if [ "$(ls -A $TEMP_DIR/*/*.{ttf,otf} 2>/dev/null)" != "" ]; then
      mv $TEMP_DIR/*/*.{ttf,otf} $TEMP_DIR/
    fi
  fi
else
  # Handle zip files
  if ! unzip "$TEMP_DIR/font.archive" -d "$TEMP_DIR"; then
    echo "Error: Failed to extract the package"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
fi

echo "Debugging: Contents of the temporary directory after extraction:"
ls -lR "$TEMP_DIR"

# Check if any font files were extracted
find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.woff" -o -name "*.woff2" \) > /dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "Error: No supported font files (.ttf, .otf, .woff, or .woff2) found in the package"
  echo "Debugging: Supported font files not found, exiting..."
  rm -rf "$TEMP_DIR"
  exit 1
fi

echo "Debugging: Supported font files found, continuing with installation..."

# Create fonts directory if it doesn't exist
sudo mkdir -p /usr/local/share/fonts/

# Move the font files to the system fonts directory
echo "Installing fonts..."
if [ "$2" = "--force" ]; then
  if ! sudo find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.woff" -o -name "*.woff2" \) -exec mv -f {} /usr/local/share/fonts/ \; ; then
    echo "Error: Failed to install fonts (even with --force)"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
elif [ "$2" = "--dry-run" ]; then
  echo "Dry run: Simulating font installation..."
  echo "The following fonts would be installed:"
  find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.woff" -o -name "*.woff2" \)
  rm -rf "$TEMP_DIR"
  exit 0
else
  if ! sudo find "$TEMP_DIR" -type f \( -name "*.ttf" -o -name "*.otf" -o -name "*.woff" -o -name "*.woff2" \) -exec mv -i {} /usr/local/share/fonts/ \; ; then
    echo "Error: Failed to install fonts (you may use --force to overwrite existing files)"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
fi

# Update the font cache
echo "Updating font cache..."
if ! fc-cache -f -v; then
  echo "Error: Failed to update font cache"
  exit 1
fi

# Clean up
rm -rf "$TEMP_DIR"

echo "✨ Fonts installed successfully! ✨"

echo ""
echo "🔍 Looking for more awesome fonts to install? Run 'font-install -h' or 'font-install --help' for a quick tutorial!"

# Check if the script is called with the --fonts option
if [ "$1" = "--fonts" ]; then
  exit 0
fi
