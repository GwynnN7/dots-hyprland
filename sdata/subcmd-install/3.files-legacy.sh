# This script is meant to be sourced.
# It's not for directly running.

# shellcheck shell=bash

# In case some dirs does not exists
v mkdir -p $XDG_BIN_HOME $XDG_CACHE_HOME $XDG_CONFIG_HOME $XDG_DATA_HOME/icons

# `--delete' for rsync to make sure that
# original dotfiles and new ones in the SAME DIRECTORY
# (eg. in ~/.config/hypr) won't be mixed together

# MISC (For dots/.config/* but not quickshell, not fish, not Hyprland, not fontconfig)
case $SKIP_MISCCONF in
  true) sleep 0;;
  *)
    for i in $(find dots/.config/ -mindepth 1 -maxdepth 1 ! -name 'quickshell' ! -name 'fish' ! -name 'hypr' ! -name 'fontconfig' -exec basename {} \;); do
#      i="dots/.config/$i"
      echo "[$0]: Found target: dots/.config/$i"
      if [ -d "dots/.config/$i" ];then warning_rsync_delete; v rsync -av --delete "dots/.config/$i/" "$XDG_CONFIG_HOME/$i/"
      elif [ -f "dots/.config/$i" ];then warning_rsync_normal; v rsync -av "dots/.config/$i" "$XDG_CONFIG_HOME/$i"
      fi
    done
    ;;
esac

case $SKIP_QUICKSHELL in
  true) sleep 0;;
  *)
    warning_rsync_delete; v rsync -av --delete dots/.config/quickshell/ "$XDG_CONFIG_HOME"/quickshell/
    ;;
esac

case $SKIP_FISH in
  true) sleep 0;;
  *)
    warning_rsync_delete; v rsync -av --delete dots/.config/fish/ "$XDG_CONFIG_HOME"/fish/
    ;;
esac

case $SKIP_FONTCONFIG in
  true) sleep 0;;
  *)
    case "$FONTSET_DIR_NAME" in
      "") warning_rsync_delete; v rsync -av --delete dots/.config/fontconfig/ "$XDG_CONFIG_HOME"/fontconfig/ ;;
      *) warning_rsync_delete; v rsync -av --delete dots-extra/fontsets/$FONTSET_DIR_NAME/ "$XDG_CONFIG_HOME"/fontconfig/ ;;
    esac;;
esac

# For Hyprland
case $SKIP_HYPRLAND in
  true) sleep 0;;
  *)warning_rsync_delete; v rsync -av --delete dots/.config/hypr/ "$XDG_CONFIG_HOME"/hypr/;;
esac

v rsync -av "dots/.local/bin/" "$XDG_BIN_HOME"
v cp -f "dots/.local/share/icons/illogical-impulse.svg" "${XDG_DATA_HOME}"/icons/illogical-impulse.svg
