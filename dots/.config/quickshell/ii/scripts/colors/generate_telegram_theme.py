#!/usr/bin/env python3
import io
import json
import re
from pathlib import Path
from PIL import Image
from zipfile import ZipFile

HOME = Path.home()
XDG_STATE_HOME = HOME / ".local" / "state"
XDG_CONFIG_HOME = HOME / ".config"

# generated configs
COLORS_CONFIG_PATH = XDG_STATE_HOME / "quickshell" / "user" / "generated"
WALLPAPER_PATH_PATH = COLORS_CONFIG_PATH / "wallpaper" / "path.txt"  # this file contains the path to the current wallpaper
COLORS_CONFIG = COLORS_CONFIG_PATH / "colors.json"

# telegram configs
TELEGRAM_CONFIG_DIR = XDG_CONFIG_HOME / "telegram" / "themes"
TELEGRAM_TEMPLATE = TELEGRAM_CONFIG_DIR / "template.tdesktop-theme"
TELEGRAM_BG = TELEGRAM_CONFIG_DIR / "background.jpg"
TELEGRAM_COLORS = TELEGRAM_CONFIG_DIR / "colors.tdesktop-theme"
TELEGRAM_FINAL = TELEGRAM_CONFIG_DIR / "matugen.tdesktop-theme"

MAX_BG_SIZE = 4_194_304  # 4MB in bytes

# Load colors from colors.json
with open(COLORS_CONFIG, "r") as f:
    colors = json.load(f)

# Load the theme template
with open(TELEGRAM_TEMPLATE, "r") as f:
    template = f.read()


# Replace placeholders like {{primary}} with actual color values
def replace_placeholders(template, colors):
    def replacer(match):
        key = match.group(1)
        return colors.get(key, "#ffffff")  # fallback to white if not found

    return re.sub(r"{{\s*(\w+)\s*}}", replacer, template)


def resize_image_to_fit(
    input_path, output_path, max_bytes=MAX_BG_SIZE, steps=5, min_quality=20
):
    img = Image.open(input_path)
    img_format = img.format

    if img_format == "PNG":
        img = img.convert("RGB")
        img_format = "JPEG"

    quality = 95
    while quality >= min_quality:
        buffer = io.BytesIO()
        img.save(buffer, format=img_format, quality=quality)
        size = buffer.tell()
        if size <= max_bytes:
            with open(output_path, "wb") as f:
                f.write(buffer.getvalue())
            return True

        quality -= steps

    return False


output_theme = replace_placeholders(template, colors)

# Write the final .tdesktop-theme file
with open(TELEGRAM_COLORS, "w") as f:
    f.write(output_theme)

with open(WALLPAPER_PATH_PATH) as f:
    wallpaper_path = f.read().strip("\n")

resize_image_to_fit(wallpaper_path, TELEGRAM_BG)

with ZipFile(TELEGRAM_FINAL, "w") as zf:
    zf.write(TELEGRAM_COLORS, arcname=TELEGRAM_COLORS.name)
    zf.write(TELEGRAM_BG, arcname=TELEGRAM_BG.name)


print("✅ Theme generated: matugen.tdesktop-theme")
