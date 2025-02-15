#!/usr/bin/env bash

# Check if the URL is provided
if [ -z "$1" ]; then
  echo "Error: Please provide a URL to a font zip file."
  echo "Usage: font-install <font-zip-url>"
  exit 1
fi

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Created temporary directory for download..."

# Download the font zip file
echo "Downloading font package..."
if ! wget -O "$TEMP_DIR/font.zip" "$1"; then
  echo "Error: Failed to download the font package"
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Unzip the font file
echo "Extracting font files..."
if ! unzip "$TEMP_DIR/font.zip" -d "$TEMP_DIR"; then
  echo "Error: Failed to extract the font package"
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Check if any font files were extracted
if ! ls "$TEMP_DIR"/*.{ttf,otf} >/dev/null 2>&1; then
  echo "Error: No font files (.ttf or .otf) found in the package"
  rm -rf "$TEMP_DIR"
  exit 1
fi

# Create fonts directory if it doesn't exist
sudo mkdir -p /usr/local/share/fonts/

# Move the font files to the system fonts directory
echo "Installing fonts..."
if ! sudo mv "$TEMP_DIR"/*.{ttf,otf} /usr/local/share/fonts/; then
  echo "Error: Failed to install fonts"
  rm -rf "$TEMP_DIR"
  exit 1
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
