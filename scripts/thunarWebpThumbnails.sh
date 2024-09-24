#!/bin/bash

# Display thumbmnails for webp images in file browsers.

# Install required packages
echo "Installing required packages..."
sudo pacman -S --noconfirm libwebp tumbler

# Create the thumbnailer configuration
THUMBNAILER_FILE="/usr/share/thumbnailers/webp.thumbnailer"
echo "Creating thumbnailer configuration at $THUMBNAILER_FILE..."
sudo bash -c "cat << EOF > $THUMBNAILER_FILE
[Thumbnailer Entry]
Version=1.0
Encoding=UTF-8
Type=X-Thumbnailer
Name=webp Thumbnailer
MimeType=image/webp;
Exec=/usr/bin/convert -thumbnail %s %i %o
EOF"

# Create the MIME type configuration
MIME_FILE="$HOME/.local/share/mime/packages/webp.xml"
echo "Creating MIME type configuration at $MIME_FILE..."
mkdir -p "$(dirname "$MIME_FILE")"
cat << EOF > "$MIME_FILE"
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="image/webp">
        <comment>WebP file</comment>
        <icon name="image"/>
        <glob-deleteall/>
        <glob pattern="*.webp"/>
    </mime-type>
</mime-info>
EOF

# Update the MIME database
echo "Updating MIME database..."
update-mime-database "$HOME/.local/share/mime"

echo "Setup complete!"
