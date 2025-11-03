#!/bin/bash

echo

set -e

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo.\n"
  exit 1
fi

# --------------------- Drivers ---------------------

pacman -S --needed - < ./sdata/custom/nvidia.txt;

echo "Drivers installed!"
echo

# --------------------- Config ---------------------

GRUB_FILE="/etc/default/grub"
NVIDIA_FILE="/etc/modprobe.d/nvidia.conf"
CPIO_FILE="/etc/mkinitcpio.conf"

GRUB_PARAMS=(
  "nvidia-drm.modeset=1"
  "nvidia-drm.fbdev=1"
  "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
)
NVIDIA_PARAMS=(
  "options nvidia_drm modeset=1"
  "options nvidia NVreg_PreserveVideoMemoryAllocations=1"
  "options nvidia NVreg_RegistryDwords=\"PowerMizerEnable=0x1; PerfLevelSrc=0x3333; PowerMizerLevel=0x2; PowerMizerDefault=0x2; PowerMizerDefaultAC=0x2\""
)
CPIO_PARAMS=(
  "nvidia"
  "nvidia_modeset"
  "nvidia_uvm"
  "nvidia_drm"
)

# --------------------- GRUB ---------------------

CURRENT_CMDLINE=$(grep '^GRUB_CMDLINE_LINUX_DEFAULT=' "$GRUB_FILE" | cut -d'"' -f2)

for param in "${GRUB_PARAMS[@]}"; do
  if ! [[ "$CURRENT_CMDLINE" == *"$param"* ]]; then
    CURRENT_CMDLINE="$CURRENT_CMDLINE $param"
    echo "Adding '$param'..."
  else
    echo "'$param' already exists. Skipping."
  fi
done

CURRENT_CMDLINE=$(echo "$CURRENT_CMDLINE" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
sed -i "s#^GRUB_CMDLINE_LINUX_DEFAULT=.*#GRUB_CMDLINE_LINUX_DEFAULT=\"${CURRENT_CMDLINE}\"#" "$GRUB_FILE"

echo "File \"$GRUB_FILE\" updated!"
echo

# --------------------- NVIDIA ---------------------

rm -f "$NVIDIA_FILE"
for param in "${NVIDIA_PARAMS[@]}"; do
  echo "$param" >> "$NVIDIA_FILE"
done

echo "File \"$NVIDIA_FILE\" created!"
echo

# --------------------- CPIO ---------------------

CURRENT_CMDLINE=$(grep '^MODULES=' "$CPIO_FILE" | cut -d'(' -f2 | cut -d')' -f1)

for param in "${CPIO_PARAMS[@]}"; do
  if ! [[ "$CURRENT_CMDLINE" == *"$param"* ]]; then
    CURRENT_CMDLINE="$CURRENT_CMDLINE $param"
    echo "Adding '$param'..."
  else
    echo "'$param' already exists. Skipping."
  fi
done

CURRENT_CMDLINE=$(echo "$CURRENT_CMDLINE" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
sed -i "s#^MODULES=.*#MODULES=(${CURRENT_CMDLINE})#" "$CPIO_FILE"

echo "File \"$CPIO_FILE\" updated!"
echo

# --------------------- UPDATE ---------------------

grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P

echo
echo "Nvidia setup complete!"
echo
