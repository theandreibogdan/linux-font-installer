#!/usr/bin/env bash

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

# Check if any font files were extracted
if ! ls "$TEMP_DIR"/*.{ttf,otf,woff,woff2} "$TEMP_DIR"/*/*.{ttf,otf,woff,woff2} >/dev/null 2>&1; then
  echo "Error: No supported font files (.ttf, .otf, .woff, or .woff2) found in the package"
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Create fonts directory if it doesn't exist
sudo mkdir -p /usr/local/share/fonts/

# Move the font files to the system fonts directory
echo "Installing fonts..."
if [ "$2" = "--force" ]; then
  if ! sudo mv -f "$TEMP_DIR"/*.{ttf,otf,woff,woff2} "$TEMP_DIR"/*/*.{ttf,otf,woff,woff2} /usr/local/share/fonts/ 2>/dev/null; then
    echo "Error: Failed to install fonts (even with --force)"
    rm -rf "$TEMP_DIR"
    exit 1
  fi
elif [ "$2" = "--dry-run" ]; then
  echo "Dry run: Simulating font installation..."
  echo "The following fonts would be installed:"
  ls "$TEMP_DIR"/*.{ttf,otf,woff,woff2} "$TEMP_DIR"/*/*.{ttf,otf,woff,woff2}
  rm -rf "$TEMP_DIR"
  exit 0
else
  if ! sudo mv -i "$TEMP_DIR"/*.{ttf,otf,woff,woff2} "$TEMP_DIR"/*/*.{ttf,otf,woff,woff2} /usr/local/share/fonts/ 2>/dev/null; then
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
