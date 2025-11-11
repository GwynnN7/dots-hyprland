rm -rf ~/.config/nvim
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git

mkdir -p ~/Programming/Cortana
git clone https://github.com/GwynnN7/Cortana ~/Programming/Cortana

mkdir -p ~/Programming/dots-hyprland
git clone https://github.com/GwynnN7/Cortana ~/Programming/dots-hyprland

#headsetcontrol -s 0
sudo systemctl enable sddm
fc-cache -f
xdg-user-dirs-update