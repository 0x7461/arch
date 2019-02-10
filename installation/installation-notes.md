# Notes on Arch Linux installation
### [Complete installation guide](https://wiki.archlinux.org/index.php/installation_guide)

## Pre-installation
1. Verify boot mode / `ls /sys/firmware/efi/efivars`
	* If the directory exists, [search for UEFI guide](https://www.google.com/search?q=install+Arch+linux+UEFI);
	* Else, go on
2. Connect to the Internet
	* `ping 8.8.8.8` to check
	* Try `ip link`, if wireless card show up, use `wifi-menu <interface>` to connect to a wifi;
	* Else, use ethernet (`dhcpcd`) or USB Tethering on Android.
3. Update clock / `timedatectl set-ntp true`
4. Disk partitioning / using *fdisk* to modify partition table
    * *swap* : equals or lesser than 1/2 of RAM
    * */boot* : 500MiB
    * */root* : 50GiB
    * */home* : rest of the disk
5. Format partitions
	* For *boot, root, home* : `mkfs.ext4 <parttion>`
	* For *swap* : `mkswap <parttion>`, then `swapon <parttion>`
6. Mount the file systems
	* mount *root* to */mnt*
	* create *boot* and *home* on */mnt* (use *mkdir*)
	* mount *boot* and *home* arccordingly to theirs mountpoints on */mnt*
	* *swap* doesn't need to mount

## Installation
1. Select mirrors

Edit */etc/pacman.d/mirrorlist*, move 5-10 closest mirrors to top of file.

2. pacstrap / `pacstrap /mnt base sudo vim`

## Configure system
1. Fstab
	* `genfstab -U /mnt >> /mnt/etc/fstab`
	* Double check to make sure parttion table is correct.
2. Change root / `arch-chroot /mnt`
3. Timezone
	* Set timezone: `ln -sf /usr/share/zoneinfo/Asia/Bangkok /etc/localtime`
	* Sync: `hwclock --systohc`
4. Locale
	* Uncomment <i>en_US.UTF-8 UTF-8</i> in */etc/locale.gen*, then `locale-gen`
	* `echo LANG=en_US.UTF-8 >> /etc/locale.conf`
5. Hostname
	* Create */etc/hostname* file with host's name (*mmcdxx*)
	* Edit */etc/hosts* arccordingly if needed
6. Networking / `pacman -S linux-headers broadcom-wl-dkms networkmanager` 
7. Initramfs (opt.) / `mkinitcpio -p linux`
8. Change root password / `passwd`
9. Add a normal user
	* `usermod -m -g users -G wheel,storage,power,audio,video -s /bin/bash ta`
	* `passwd ta`
10. Boot loader
	* `pacman -S intel-ucode ntfs-3g os-prober grub`
	* `grub-install /dev/sda/`
	* `grub-mkconfig -o /boot/grub/grub.cfg`
11. Fonts / `pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-inconsolata`
12. Reboot
	* `exit`
	* `umount -R /mnt`
	* `reboot`

# Post-installation
1. Configure pacman (*/etc/pacman.conf*)
	* Use multillib repos: uncomment 2 lines of multillib repo
	* `sudo pacman -Syy`
    * `sudo pacman -S pacman-contrib`
	* Color in pacman : uncomment `Color` under *Misc options*
	* `pacman -S reflector`
	* `mkdir -p /etc/pacman.d/hooks/`
	* `vim /etc/pacman.d/hooks/mirrorupgrade.hook`
		```shell
		[Trigger]
		Operation = Upgrade
		Type = Package
		Target = pacman-mirrorlist

		[Action]
		Description = Updating pacman-mirrorlist with reflector and removing pacnew...
		When = PostTransaction
		Depends = reflector
		Exec = /bin/sh -c "reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist;  rm -f /etc/pacman.d/mirrorlist.pacnew"
		```
	* `vim /etc/pacman.d/hooks/cleanpacmancache.hook`
		```shell
		[Trigger]
		Operation = Upgrade
		Operation = Install
		Operation = Remove
		Type = Package
		Target = *

		[Action]
		Description = Cleaning pacman cache...
		When = PostTransaction
		Exec = /usr/bin/paccache -rvk1
		```
2. Update *mirrorlist*
	* `sudo reflector --latest 200 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist`
	* (opt.) `rm -f /etc/pacman.d/mirrorlist.pacnew`
3. Update system / `sudo pacman -Syu`
4. AUR wrapper (*yay*)
    * `pacman -S git`
	* `cd /tmp`
	* `git clone https://aur.archlinux.org/yay.git`
    * Install *yay* with `makepkg`
5. X and i3
	* `pacman -S xorg-server xorg-xinit xorg-xset xorg-xbacklight xautolock i3 dunst rxvt-unicode lxappearance`
	* `sudo cp /etc/X11/xinit/xinitrc ~/.xinitrc`
	* Add to the end of *xinitrc*
		```shell
		exec i3
		``` 
	* Add to the end of *~/.bash_profile*
		```shell
		if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
			exec startx
		fi
		```
6. Other stuffs
	* Needed: `pacman -S alsa-utils compton transmission-gtk feh vifm mpd mpc ncmpcpp mpv firefox gvfs xdg-user-dirs`
    * `xdg-user-dirs-update`
	* Nedded (AUR) : `yay -S aic94xx-firmware wd719x-firmware google-chrome`
	* GPU: `pacman -S nvidia bumblebee mesa nvidia xf86-video-intel lib32-virtualgl lib32-nvidia-utils mesa-demos bbswitch primus lib32-primus`
		1. Add user to *bumblebee* group : `gpasswd -a ta bumblebee`
		2. Start and enable *bumblebeed.service*
		3. Tests (may need a reboot to work):
			* `optirun glxgears -info`
			* `optirun glxspheres64`
			* `optirun glxspheres32`
7. Reboot, fixing errors and other broken things
8. Adjust new system arccording to needs 
9. Consider using *Tor browser* for bittorrent.
