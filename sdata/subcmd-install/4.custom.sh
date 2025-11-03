printf "\n"
printf "Do you want to install custom packages?\n"
printf "  y = Yes (DEFAULT)\n"
printf "  n = No\n"
read -p "===> [Y/n]: " p
case $p in
    [nN]) echo -e "Skipping packages installation";;
    *) yay -S --needed - < ./sdata/custom/packages.txt;;
esac

printf "\n"
printf "Do you want to install custom software?\n"
printf "  y = Yes (DEFAULT)\n"
printf "  n = No\n"
read -p "===> [Y/n]: " p
case $p in
    [nN]) echo -e "Skipping software installation";;
    *) yay -S --needed - < ./sdata/custom/software.txt;;
esac

printf "\n"
printf "Do you want to setup Nvidia?\n"
printf "  y = Yes\n"
printf "  n = No (DEFAULT)\n"
read -p "===> [y/N]: " p
case $p in
    [yY]) sudo ./sdata/custom/nvidia.sh;;
    *) echo -e "Skipping Nvidia setup";;
esac

printf "\n"
printf "Do you want to run custom scripts?\n"
printf "  y = Yes (DEFAULT)\n"
printf "  n = No\n"
read -p "===> [Y/n]: " p
case $p in
    [nN]) echo -e "Skipping custom scripts";;
    *) ./sdata/custom/scripts.sh;;
esac

printf "\n"
printf "Done! Do you want to reboot the system?\n"
printf "  y = Yes (DEFAULT)\n"
printf "  n = No\n"
read -p "===> [Y/n]: " p
case $p in
    [nN]) echo -e "Installation complete!";;
    *) reboot;;
esac