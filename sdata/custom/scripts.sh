rm -rf ~/.config/nvim
git clone --depth 1 https://github.com/AstroNvim/template ~/.config/nvim
rm -rf ~/.config/nvim/.git

libinput-gestures-setup autostart start
headsetcontrol -s 0
fc-cache -fv