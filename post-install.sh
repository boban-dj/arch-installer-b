#!/bin/sh
: 'Copyright (C) 2015 Andrés Quiceno Hernández, Mario Gordillo Ortiz

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>'

#Load the X11 keymap
localectl --no-convert set-x11-keymap selectedkeymap

user=$(cat /etc/passwd | grep 1000 | awk -F':' '{ print $1}' | head -1)
noConflict="0"
dialog --backtitle "ArchLinux Installation" --title "Desktop Environment instalation" \
		--yesno "Do you want to install any desktop environment?" 6 51
if [[ $? == 0 ]];then
	until [[ $noConflict == "1" ]];do
		dialog --backtitle "ArchLinux Installation" --title "Be careful" --msgbox 'These are the some incompatibilities between desktops\n
		      ┌─Gnome \n
		Unity─┼─Deepin \n
		      └─Pantheon\n
		\nKDE4 ── KDE5      ' 0 0
		cmd=(dialog --backtitle "ArchLinux Installation" --separate-output --checklist "Select the Desktop Environment:" 0 0 0)
		options=(KDE4 "KDE desktop environment v4"	off
				KDE5 "KDE desktop environment v5"	off
				Gnome "GNOME Desktop environment"	off
				XFCE "XFCE desktop environment"	off
				LXDE "Light Desktop environment"	off
				MATE "A mantained fork of GNOME v2"	off
				Pantheon "Elementary OS' Desktop environment"	off
				LXQT "Light Desktop environment with QT"	off
				Unity "Ubuntu's Desktop environment"	off
				DDE "Deepin's Desktop environment"	off
				OpenBox "Simple and minimalistic DE"	off
				i3 "Tiled Window manager"	off
				Cinnamon "Linux Mint's desktop environment"	off
				Budgie "Solus' desktop environment"	off
				Enlightenment "Enlightenment desktop environment" off
				bspwm "Minimalistic tiled window manager" off
				)
		desktop=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

		KDE4true=$(echo "$desktop" | grep "KDE4")
		KDE5true=$(echo "$desktop" | grep "KDE5")
		Unitytrue=$(echo "$desktop" | grep "Unity")
		Gnometrue=$(echo "$desktop" | grep "Gnome")
		DDEtrue=$(echo "$desktop" | grep "DDE")
		Pantheontrue=$(echo "$desktop" | grep "Pantheon")

		if [[ $KDE4true == "KDE4" ]] && [[ $KDE5true == "KDE5" ]]
		then
			dialog --backtitle "ArchLinux Installation" --title "Incompatibility detected" --msgbox 'KDE4 and KDE5 are not compatible. Choose only one KDE' 6 57
			noConflict=0
		elif [[ $Unitytrue == "Unity" ]] && [[ $Gnometrue == "Gnome" || $DDEtrue == "DDE" || $Pantheontrue == "Pantheon" ]]
		then
			dialog --backtitle "ArchLinux Installation" --title "Incompatibility detected" --msgbox 'Unity cannot be installed at the same time that: Gnome, Deepin or Pantheon' 6 78
			noConflict=0
		else
			noConflict=1
		fi
	done
	pacman -Sy
	clear
	for choice in $desktop #For each line that is on the variable $desktop, grab one line and fit it on the $choice variable
	do
		case $choice in #In the case that the $choice variable is..., do... Ex: $choice=KDE5; case $choice in. This will select the KDE5 option
			"KDE4")
				dialog --backtitle "ArchLinux Installation" --title "KDE4 Instalation" \
						--yesno "Do you want to install KDE4's extra software? (kde-meta)" 6 60
				if [[ $? = 0 ]];then
					kdemeta=kde-meta
				fi
				pacman -S --noconfirm kde $kdemeta
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"KDE5")
				dialog --backtitle "ArchLinux Installation" --title "KDE5 Instalation" \
						--yesno "Do you want to install KDE5's extra software? (plasma-meta)" 6 63
				if [[ $? = 0 ]];then
					plasmameta=plasma-meta
				fi
				pacman -S --noconfirm plasma $plasmameta
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"Gnome")
				dialog --backtitle "ArchLinux Installation" --title "GNOME Instalation" \
						--yesno "Do you want to install GNOME's extra software? (gnome-extra)" 6 64
				if [[ $? = 0 ]];then
					gnomeextra=gnome-extra
				fi
				pacman -S --noconfirm gnome $gnomeextra
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"XFCE")
				dialog --backtitle "ArchLinux Installation" --title "XFCE4 Instalation" \
						--yesno "Do you want to install XFCE's extra software? (xfce4-goodies)" 6 65
				if [[ $? = 0 ]];then
					xfce4goodies=xfce4-goodies
				fi
				pacman -S --noconfirm xfce4 $xfce4goodies
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"LXDE")
				dialog --backtitle "ArchLinux Installation" --title "LXDE Instalation" \
						--yesno "Do you want to install LXDE's extra software? (lxde-common)" 6 63
				if [[ $? = 0 ]];then
					lxdecommon=lxde-common
				fi
				pacman -S --noconfirm lxde $lxdecommon
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"MATE")
				dialog --backtitle "ArchLinux Installation" --title "MATE Instalation" \
						--yesno "Do you want to install MATE's extra software? (mate-extra)" 6 62
				if [[ $? = 0 ]];then
					mateextra=mate-extra
				fi
				pacman -S --noconfirm mate $mateextra
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"Pantheon")
				printf "\n[pantheon]\nServer = http://pkgbuild.com/~alucryd/\x24repo/\x24arch\nSigLevel = Optional TrustAll\n" >> /etc/pacman.conf
				pacman -Sy --noconfirm pantheon-session-bzr audience-bzr contractor-bzr eidete-bzr elementary-icon-theme-bzr elementary-icon-theme-bzr elementary-wallpapers-bzr gtk-theme-elementary-bzr footnote-bzr geary lightdm-pantheon-greeter-bzr maya-calendar-bzr midori-granite-bzr noise-bzr pantheon-backgrounds-bzr pantheon-calculator-bzr pantheon-default-settings-bzr pantheon-files-bzr pantheon-print-bzr pantheon-terminal-bzr plank-theme-pantheon-bzr scratch-text-editor-bzr snap-photobooth-bzr switchboard-bzr ttf-dejavu ttf-droid ttf-freefont ttf-liberation indicator-session indicator-sound
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -A -S --noconfirm ttf-opensans pantheon-notify-bzr
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"LXQT")
				#Reload pacman's keys, this resolves an issue related to instalation of lxqt
				pacman-key --init
				pacman-key --populate archlinux
				#Install LXQt
				pacman -Sy --noconfirm lxqt oxygen-icons qtcurve
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -A -S --noconfirm qterminal-git obconf-qt-git
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				#Enable NetworkManager
				systemctl enable NetworkManager
				wm=$(dialog --backtitle "ArchLinux Installation" --clear --title "Window Manager Selecion: " \
						--menu "LXQt requires an Window Manger to work, select it:" 0 0 0 \
						Openbox "Simple Window manager" \
						Kwin "KDE Window Manager" 2>&1 > /dev/tty)
				for choice in $wm
				do
					case $choice in
						"Openbox")
							pacman -S --noconfirm openbox
						;;

						"Kwin")
							pacman -S --noconfirm kwin
						;;
				esac
				done
			;;

			"Unity")
				printf "\n[Unity-for-Arch]\nServer = http://dl.dropbox.com/u/486665/Repos/\x24repo/\x24arch\nSigLevel = Optional TrustAll\n\n[Unity-for-Arch-Extra]\nServer = http://dl.dropbox.com/u/486665/Repos/\x24repo/\x24arch\nSigLevel = Optional TrustAll\n" >> /etc/pacman.conf
				pacman -Sy
				ubuntu=$(pacman -Slq Unity-for-Arch | grep -v upower-compat | grep -v gsettings-desktop-schemas)
				ubuntuextra=$(pacman -Slq Unity-for-Arch-Extra | grep -v pidgin-libnotify-ubuntu)
				pacman -R --noconfirm gsettings-desktop-schemas glib-networking libsoup networkmanager
				pacman -S --noconfirm ${ubuntu} ${ubuntuextra}
				pacman -S --noconfirm networkmanager
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"DDE")
				dialog --backtitle "ArchLinux Installation" --title "Deepin Instalation" \
						--yesno "Do you want to install Deepin's extra software? (deepin-extra)" 6 66
				if [[ $? = 0 ]];then
					deepinextra=deepin-extra
				fi
				printf "\n[home_metakcahura_arch-deepin_Arch_Extra]\nServer = http://download.opensuse.org/repositories/home:/metakcahura:/arch-deepin/Arch_Extra/\x24arch\nSigLevel = Never\n" >> /etc/pacman.conf
				pacman -Sy --noconfirm deepin $deepinextra
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"OpenBox")
				pacman -S --noconfirm openbox
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"i3")
				pacman -S --noconfirm i3-wm i3status i3lock rxvt-unicode
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"Cinnamon")
				pacman -S --noconfirm cinnamon
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"Budgie")
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -A -S --noconfirm budgie-desktop-git
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"Enlightenment")
				pacman -S --noconfirm enlightenment
				#Enable NetworkManager
				systemctl enable NetworkManager
			;;

			"bspwm")
				pacman -S --noconfirm bspwm sxhkd rxvt-unicode
				mkdir -p /home/$user/.config/bspwm
				mkdir -p /home/$user/.config/sxhkd
				cp /usr/share/doc/bspwm/examples/bspwmrc /home/$user/.config/bspwm/bspwmrc
				echo "sxhkd &" >> /home/$user/.config/bspwm/bspwmrc
				chmod +x /home/$user/.config/bspwm/bspwmrc
				chown -R $user:users /home/$user/.config/bspwm
				cp /usr/share/doc/bspwm/examples/sxhkdrc /home/$user/.config/sxhkd/sxhkdrc
				chmod +x /home/$user/.config/sxhkd/sxhkdrc
				chown -R $user:users /home/$user/.config/sxhkd
			;;
	esac
	done

	until [[ $noDmConflict == "1" ]];do
		dm=$(dialog --backtitle "ArchLinux Installation" --clear --title "Display Manager selection: " \
				--menu "Select the Display Manager:" 0 0 0 \
				GDM "GNOME Display manager" \
				SDDM "KDE4 Display manager" \
				LXDM "LXDE Display manager" \
				MDM "Linux Mint's Display manager" \
				Entrance "Enlightenment's Display manager (Experimental)" \
				LightDM "Cross-desktop display manager" 2>&1 > /dev/tty)

		GDMtrue=$(echo "$dm" | grep "GDM")
		if [[ $Unitytrue == "Unity" ]] && [[ $GDMtrue == "GDM" ]]
		then
			dialog --backtitle "ArchLinux Installation" --title "Incompatibility detected" --msgbox 'Unity and GDM are not compatible. Please, choose other desktop manager than GDM' 6 83
			noDmConflict=0
		else
			noDmConflict=1
		fi
	done
	for choice in $dm
	do
		case $choice in
			"GDM")
				pacman -S --noconfirm gdm
				systemctl enable gdm
			;;

			"SDDM")
				pacman -S --noconfirm sddm
				systemctl enable sddm
			;;

			"LXDM")
				pacman -S --noconfirm lxdm
				systemctl enable lxdm
			;;

			"MDM")
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -A -S --noconfirm mdm-display-manager
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				systemctl enable mdm
			;;

			"Entrance")
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -A -S --noconfirm entrance-git
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				systemctl enable entrance
			;;

			"LightDM")
				pacman -S --noconfirm lightdm lightdm-gtk-greeter
				systemctl enable lightdm
			;;
	esac
	done
fi
sh=$(dialog --backtitle "ArchLinux Installation" --clear --title "Default Shell selection: " \
		--menu "Select the Default Shell:" 0 0 0 \
		BASH "Default Shell" \
		SH "SH Shell" \
		ZSH "ZSH Shell" \
		FISH "FISH Shell" \
		CShell "C Shell" \
		DASH "DASH Shell" 2>&1 > /dev/tty)
for choice in $sh
do
	case $choice in
		"BASH")
			usermod -s /bin/bash root
			usermod -s /bin/bash $user
		;;

		"SH")
			usermod -s /bin/sh root
			usermod -s /bin/sh $user
		;;

		"ZSH")
			pacman -S --noconfirm zsh
			zsh=$(dialog --backtitle "ArchLinux Installation" --clear --title "ZSH selection: " \
					--menu "Select the ZSH theme:" 0 0 0 \
					grml "grml zsh config" \
					oh-my-zsh "oh my zsh" \
					None "Pure ZSH!" 2>&1 > /dev/tty)
			for choice in $zsh
			do
				case $choice in
					"grml")
						pacman -S --noconfirm grml-zsh-config
					;;

					"oh-my-zsh")
						sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
						sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
						sudo -u $user yaourt -S -A --noconfirm oh-my-zsh-git bullet-train-oh-my-zsh-theme-git oh-my-zsh-powerline-theme-git powerline-fonts-git
						sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
						sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
						cp /usr/share/oh-my-zsh/zshrc /home/$user/.zshrc
						cp /usr/share/oh-my-zsh/zshrc /root/.zshrc
						themes=$(ls /usr/share/oh-my-zsh/themes | awk -F "." '{print $1}' | sed -e 's/$/ theme/')
						theme=$(dialog --backtitle "ArchLinux Installation" --clear --title "Oh my ZSH theme selection: " \
								--menu "Select the Oh my ZSH theme:" 0 0 0 ${themes} 2>&1 > /dev/tty)
						sed -i "s/ZSH_THEME=\x22robbyrussell\x22/ZSH_THEME=\x22$theme\x22/" /home/$user/.zshrc
						sed -i "s/ZSH_THEME=\x22robbyrussell\x22/ZSH_THEME=\x22$theme\x22/" /root/.zshrc
					;;

					"None")
						echo "Pure ZSH!"
					;;
				esac
			done

			usermod -s /bin/zsh root
			usermod -s /bin/zsh $user
		;;

		"FISH")
			pacman -S --noconfirm fish
			usermod -s /usr/bin/fish root
			usermod -s /usr/bin/fish $user
		;;

		"CShell")
			pacman -S --noconfirm tcsh
			usermod -s /bin/tcsh root
			usermod -s /bin/tcsh $user
		;;

		"DASH")
			pacman -S --noconfirm dash
			usermod -s /bin/dash root
			usermod -s /bin/dash $user
		;;
	esac
done

#Install the compatibility layer for virtualbox or the graphics card driver
dialog --backtitle "ArchLinux Installation" --title "Graphics Drivers installation" \
		--yesno "Are you on a VirtualBox machine?" 6 36
response=$?
case $response in
	0) pacman -S --noconfirm  virtualbox-guest-utils virtualbox-guest-modules
		modprobe -a vboxguest vboxsf vboxvideo
		systemctl enable vboxservice && systemctl start vboxservice;;
	1) graphics=$(lspci -k | grep -A 2 -E "(VGA|3D)")
		if [[ $graphics  = *Intel* || $graphics = *intel* || $graphics = *INTEL* ]]
		then
		        pacman -S --noconfirm xf86-video-intel mesa-libgl
		fi
		if [[ $graphics = *NVIDIA* || $graphics = *nvidia* || $graphics = *Nvidia* ]]
		then
		        pacman -S --noconfirm nvidia
		fi
		if [[ $graphics  = *ATI* || $graphics = *ati* || $graphics = *Ati* || $graphics = *AMD* || $graphics = *amd* || $graphics = *amd* ]]
		then
		        pacman -S --noconfirm xf86-video-ati mesa-libgl mesa-vdpau lib32-mesa-vdpau
		fi
;;
esac
LAMP=0

dialog --backtitle "ArchLinux Installation" --title "Services instalation" \
		--yesno "Do you want to install any service? Ex: SSH" 6 47
if [[ $? == 0 ]];then
	noConflict=0
	until [[ $noConflict == "1" ]];do
		dialog --backtitle "ArchLinux Installation" --title "Be careful" --msgbox 'These are the some incompatibilities between servers\n
	        Subsonic ── Madsonic' 0 0

		cmd=(dialog --backtitle "ArchLinux Installation" --separate-output --checklist "Select the Services that you want to install:" 0 0 0)
		options=(SSH "Remote console"	off
				Web "Apache + PHP5 + MariaDB(Mysql) A complete Web Server"	off
				Owncloud "Self-hosted cloud"	off
				Wordpress "Self-hosted blog"	off
				Subsonic "Music Server"	off
				Madsonic "Music Server"	off
				GitLab "Git Code server" off
				Gogs "Simple Git code server" off
				NTOP "Traffic monitoring tool"	off
				TightVNC "Remote screen server"	off
				Deluge "Torrent server with web UI"	off
				L2TP "VirtualPrivateNetwork Server L2TP, IPSEC"	off
				)
		desktop=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

		Subtrue=$(echo "$desktop" | grep "Subsonic")
		Madtrue=$(echo "$desktop" | grep "Madsonic")

		if [[ $Subtrue == "Subsonic" ]] && [[ $Madtrue == "Madsonic" ]]
		then
			dialog --backtitle "ArchLinux Installation" --title "Incompatibility detected" --msgbox 'Subsonic and Madsonic are not compatible. Choose only one' 6 61
			noConflict=0
		else
			noConflict=1
		fi
	done

	clear
	for choice in $desktop
	do
		case $choice in
			"SSH")
				port=22
				ip=$(ip a | grep inet | grep -v inet6 | grep -v host | awk -F " " '{print $2}' | awk -F "/" '{print $1}')
				pacman -S --noconfirm openssh
				dialog --backtitle "ArchLinux Installation" --title "SSH Configuration" \
						--yesno "Do you want to change the default port(22) of SSHD?" 7 60 
				response=$?
				case $response in
					0)  port=$(dialog --backtitle "Archlinux Installation" --title "SSH Configuration" \
								--inputbox "Enter the port that you want to use:" 8 40 2>&1 > /dev/tty)
						if [ "$?" = "0" ]
						then
							sed -i -e "s/#Port 22/Port $(echo $port)/g" /etc/ssh/sshd_config
						fi;;
					1)  echo "Port not changed";;
				esac
				systemctl start sshd
				systemctl enable sshd
				dialog --backtitle "ArchLinux Installation" --title "SSH Installation" \
						--msgbox "SSH Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip \nPort: $port" 0 0
			;;

			"Web")
				ip=$(ip a | grep inet | grep -v inet6 | grep -v host | awk -F " " '{print $2}' | awk -F "/" '{print $1}')
				pacman -S --noconfirm apache apache php php-apache php-apcu php-cgi php-embed php-enchant php-gd php-fpm php-intl php-ldap php-mcrypt php-mssql php-odbc php-pear php-pgsql php-snmp php-tidy php-xcache php-xsl php-docs mariadb
				##MariaDB
				mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
				systemctl start mysqld
				systemctl enable mysqld

				#Ask for the password of the root's database username
				rpassword=$(dialog --backtitle "Archlinux Installation" --passwordbox "Enter the root's password for MySQL/MariaDB:" 8 40 2>&1 > /dev/tty)
				if [ "$?" = "0" ]
				then
					/usr/bin/mysqladmin -u root password $rpassword
				fi

				#Add the main user of mysql
				db=$(dialog --backtitle "Archlinux Installation" --title "Mysql user creation" \
						--form "\nPlease, enter the mysql user configuration" 25 60 16 \
						"Username :" 1 1 "user" 1 25 25 30 \
						"Password :" 2 1 "passw0rd" 2 25 25 30 2>&1 > /dev/tty)
				dbuser=$(echo "$db" | sed -n 1p)
				dbpass=$(echo "$db" | sed -n 2p)
				if [ "$?" = "0" ]
				then
					DB1="CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"
					DB2=" GRANT ALL PRIVILEGES ON *.* TO '$dbuser'@'localhost' WITH GRANT OPTION;"
					DB="${DB1}${DB2}"
					mysql -uroot -p$rpassword -e "$DB"
					userdb="\n\nMySQL User\nUser: $dbuser\nPassword: $dbpass"
				fi
				dialog --backtitle "ArchLinux Installation" --title "MySQL Installation" \
						--msgbox "MySQL Instalation is now completed. You can use this settings to connect to the server:\n\nUsername: root \nPassword: $rpassword$userdb" 0 0

				##Apache+PHP5
				sed -i 's/LoadModule mpm_event_module modules\x2Fmod_mpm_event.so/LoadModule mpm_prefork_module modules\x2Fmod_mpm_prefork.so/g' /etc/httpd/conf/httpd.conf #Replace the first string with the second one
				sed -i '/LoadModule dir_module modules\x2Fmod_dir.so/a LoadModule php5_module modules\x2Flibphp5.so' /etc/httpd/conf/httpd.conf #Append the second string after the first one
				sed -i '/Include conf\x2Fextra\x2Fhttpd-default.conf/a \\n\x23PHP5\nInclude conf\x2Fextra\x2Fphp5_module.conf' /etc/httpd/conf/httpd.conf #Append the second string after the first one
				systemctl enable httpd
				systemctl start httpd
				LAMP=1
				dialog --backtitle "ArchLinux Installation" --title "Apache Installation" \
						--msgbox "Apache Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip" 0 0
			;;

			"Owncloud")
				if [[ $LAMP == "0" ]]; then
					ip=$(ip a | grep inet | grep -v inet6 | grep -v host | awk -F " " '{print $2}' | awk -F "/" '{print $1}')
					pacman -S --noconfirm apache php php-apache mariadb
					##MariaDB
					mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
					systemctl start mysqld
					systemctl enable mysqld

					#Ask for the password of the root's database username
					rpassword=$(dialog --backtitle "Archlinux Installation" --passwordbox "Enter the root's password for MySQL/MariaDB:" 8 40 2>&1 > /dev/tty)
					if [ "$?" = "0" ]
					then
						/usr/bin/mysqladmin -u root password $rpassword
					fi

					#Add the main user of mysql
					db=$(dialog --backtitle "Archlinux Installation" --title "Mysql user creation" \
							--form "\nPlease, enter the mysql user configuration" 25 60 16 \
							"Username :" 1 1 "user" 1 25 25 30 \
							"Password :" 2 1 "passw0rd" 2 25 25 30 2>&1 > /dev/tty)
					dbuser=$(echo "$db" | sed -n 1p)
					dbpass=$(echo "$db" | sed -n 2p)
					if [ "$?" = "0" ]
					then
						DB1="CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"
						DB2=" GRANT ALL PRIVILEGES ON *.* TO '$dbuser'@'localhost' WITH GRANT OPTION;"
						DB="${DB1}${DB2}"
						mysql -uroot -p$rpassword -e "$DB"
						userdb="\n\nMySQL User\nUser: $dbuser\nPassword: $dbpass"
					fi
					dialog --backtitle "ArchLinux Installation" --title "MySQL Installation" \
							--msgbox "MySQL Instalation is now completed. You can use this settings to connect to the server:\n\nUsername: root \nPassword: $rpassword$userdb" 0 0

					##Apache+PHP5
					sed -i 's/LoadModule mpm_event_module modules\x2Fmod_mpm_event.so/LoadModule mpm_prefork_module modules\x2Fmod_mpm_prefork.so/g' /etc/httpd/conf/httpd.conf #Replace the first string with the second one
					sed -i '/LoadModule dir_module modules\x2Fmod_dir.so/a LoadModule php5_module modules\x2Flibphp5.so' /etc/httpd/conf/httpd.conf #Append the second string after the first one
					sed -i '/Include conf\x2Fextra\x2Fhttpd-default.conf/a \\n\x23PHP5\nInclude conf\x2Fextra\x2Fphp5_module.conf' /etc/httpd/conf/httpd.conf #Append the second string after the first one
					systemctl enable httpd
					systemctl start httpd
					LAMP=1
					dialog --backtitle "ArchLinux Installation" --title "Apache Installation" \
							--msgbox "Apache Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip" 0 0
				fi
				pacman -S --noconfirm owncloud php-intl php-mcrypt
				sed -i '/extension=gd.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=iconv.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=xmlrpc.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=zip.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=bz2.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=curl.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=intl.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=mcrypt.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=openssl.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=pdo_mysql.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=mysql.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				cp /etc/webapps/owncloud/apache.example.conf /etc/httpd/conf/extra/owncloud.conf
				echo -e "Include conf/extra/owncloud.conf" >> /etc/httpd/conf/httpd.conf
				owncloudname=wordpress
				dialog --backtitle "ArchLinux Installation" --title "Owncloud Instalation" --yesno "Do you want to change the default address for owncloud?\n(Default http://domain.com/owncloud/)" 8 45
				if [[ $? == "0" ]];then
					owncloudname=$(dialog --backtitle "ArchLinux Installation" --title "Owncloud Instalation" --inputbox "Enter the address that you want to use:\n(Ej: acloud = http://domain.com/acloud)" 9 50 2>&1 > /dev/tty)
					sed -i "s/Alias \x2Fowncloud/Alias \x2F$owncloudname/g" /etc/httpd/conf/extra/owncloud.conf
				fi
				dialog --backtitle "ArchLinux Installation" --title "Owncloud Instalation" --yesno "Do you want to change the default port for owncloud?\n(Default: 80)" 8 45
				if [[ $? == "0" ]];then
					owncloudport=$(dialog --backtitle "ArchLinux Installation" --title "Owncloud Instalation" --inputbox "Enter the port that you want to use: (Ej: 5297 = http://domain.com:5297)" 8 40 2>&1 > /dev/tty)
					sed -i "s/*:80/*:$owncloudport/g" /etc/httpd/conf/extra/owncloud.conf
					sed -i "s/Listen 80/Listen 80\nListen $owncloudport/g" /etc/httpd/conf/httpd.conf

					definedport=1
				fi
				chown http:http -R /usr/share/webapps/owncloud/
				#Enter the database's password
				ownpass=$(dialog --backtitle "Archlinux Installation" --passwordbox "Enter owncloud's database password:" 8 40 2>&1 > /dev/tty)
				DB1="CREATE USER 'owncloud'@'localhost' IDENTIFIED BY '$ownpass';"
				DB2=" CREATE DATABASE owncloud;"
				DB3=" GRANT ALL PRIVILEGES ON owncloud.* TO 'owncloud'@'localhost' WITH GRANT OPTION;"
				DB="${DB1}${DB2}${DB3}"
				mysql -uroot -p$rpassword -e "$DB"
				if [[ defined == "1" ]];then
					definedport="\nOr you can acces through $ip:$owncloudport"
				fi
				systemctl restart httpd
				dialog --backtitle "ArchLinux Installation" --title "Owncloud Installation" \
						--msgbox "Owncloud Instalation is now completed. You can use this settings to connect to the server:\nAddress: $ip/$owncloudname$definedport" 0 0
			;;

			"Wordpress")
				if [[ $LAMP == "0" ]]; then
					ip=$(ip a | grep inet | grep -v inet6 | grep -v host | awk -F " " '{print $2}' | awk -F "/" '{print $1}')
					pacman -S --noconfirm apache php php-apache mariadb
					##MariaDB
					mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
					systemctl start mysqld
					systemctl enable mysqld

					#Ask for the password of the root's database username
					rpassword=$(dialog --backtitle "Archlinux Installation" --passwordbox "Enter the root's password for MySQL/MariaDB:" 8 40 2>&1 > /dev/tty)
					if [ "$?" = "0" ]
					then
						/usr/bin/mysqladmin -u root password $rpassword
					fi

					#Add the main user of mysql
					db=$(dialog --backtitle "Archlinux Installation" --title "Mysql user creation" \
							--form "\nPlease, enter the mysql user configuration" 25 60 16 \
							"Username :" 1 1 "user" 1 25 25 30 \
							"Password :" 2 1 "passw0rd" 2 25 25 30 2>&1 > /dev/tty)
					dbuser=$(echo "$db" | sed -n 1p)
					dbpass=$(echo "$db" | sed -n 2p)
					if [ "$?" = "0" ]
					then
						DB1="CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpass';"
						DB2=" GRANT ALL PRIVILEGES ON *.* TO '$dbuser'@'localhost' WITH GRANT OPTION;"
						DB="${DB1}${DB2}"
						mysql -uroot -p$rpassword -e "$DB"
						userdb="\n\nMySQL User\nUser: $dbuser\nPassword: $dbpass"
					fi
					dialog --backtitle "ArchLinux Installation" --title "MySQL Installation" \
							--msgbox "MySQL Instalation is now completed. You can use this settings to connect to the server:\n\nUsername: root \nPassword: $rpassword$userdb" 0 0

					##Apache+PHP5
					sed -i 's/LoadModule mpm_event_module modules\x2Fmod_mpm_event.so/LoadModule mpm_prefork_module modules\x2Fmod_mpm_prefork.so/g' /etc/httpd/conf/httpd.conf #Replace the first string with the second one
					sed -i '/LoadModule dir_module modules\x2Fmod_dir.so/a LoadModule php5_module modules\x2Flibphp5.so' /etc/httpd/conf/httpd.conf #Append the second string after the first one
					sed -i '/Include conf\x2Fextra\x2Fhttpd-default.conf/a \\n\x23PHP5\nInclude conf\x2Fextra\x2Fphp5_module.conf' /etc/httpd/conf/httpd.conf #Append the second string after the first one
					systemctl enable httpd
					systemctl start httpd
					LAMP=1
					dialog --backtitle "ArchLinux Installation" --title "Apache Installation" \
							--msgbox "Apache Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip" 0 0
				fi
				pacman -S --noconfirm wordpress
				sed -i '/extension=ftp.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=curl.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=gd.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=iconv.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=pdo_mysql.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=mysql.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=openssl.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=sockets.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=xmlrpc.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				sed -i '/extension=pspell.so/s/^;//g' /etc/php/php.ini #Uncomment the line matching that string
				printf "Alias /wordpress \x22/usr/share/webapps/wordpress\x22\n<Directory \x22/usr/share/webapps/wordpress\x22>\n\tAllowOverride All\n\tOptions FollowSymlinks\n\tRequire all granted\n\tphp_admin_value open_basedir \x22/srv/:/tmp/:/usr/share/webapps/:/etc/webapps:\x24\x22\n</Directory>" > /etc/httpd/conf/extra/httpd-wordpress.conf
				wordpressname=wordpress
				echo -e "\nInclude conf/extra/httpd-wordpress.conf\n" >> /etc/httpd/conf/httpd.conf
				dialog --backtitle "ArchLinux Installation" --title "Wordpress Instalation" --yesno "Do you want to change the default address for Wordpress?\n(Default http://domain.com/wordpress/)" 8 45
				if [[ $? == "0" ]];then
					wordpressname=$(dialog --backtitle "ArchLinux Installation" --title "Wordpress Instalation" --inputbox "Enter the address that you want to use\n(Ej: myblog = http://domain.com/myblog)" 9 50 2>&1 > /dev/tty)
					sed -i "s/Alias \x2Fwordpress/Alias \x2F$wordpressname/g" /etc/httpd/conf/extra/httpd-wordpress.conf
				fi
				chown http:http -R /usr/share/webapps/wordpress/
				#Enter the database's password
				wordpass=$(dialog --backtitle "Archlinux Installation" --passwordbox "Enter WordPress' database password:" 8 40 2>&1 > /dev/tty)
				DB1="CREATE USER 'wordpress'@'localhost' IDENTIFIED BY '$wordpass';"
				DB2=" CREATE DATABASE wordpress;"
				DB3=" GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' WITH GRANT OPTION;"
				DB="${DB1}${DB2}${DB3}"
				mysql -uroot -p$rpassword -e "$DB"
				systemctl restart httpd
				dialog --backtitle "ArchLinux Installation" --title "Wordpress Installation" \
						--msgbox "Wordpress Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip/$wordpressname" 0 0
			;;

			"Subsonic")
				pacman -S --noconfirm ffmpeg flac lame
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -S -A --noconfirm subsonic
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				useradd --system subsonic
				gpasswd --add subsonic audio
				cd /var/lib/subsonic
				chown -R subsonic:subsonic .
				test -d transcode || mkdir transcode
				chown -R root:root transcode
				mkdir /var/lib/subsonic/transcode
				cd /var/lib/subsonic/transcode
				ln -s "$(which ffmpeg)"
				ln -s "$(which flac)"
				ln -s "$(which lame)"

				dialog --backtitle "ArchLinux Installation" --title "Subsonic Configuration" \
						--yesno "Do you want to change the default HTTP port(4040) of Subsonic?" 7 60
				response=$?
				case $response in
					0)  port=$(dialog --backtitle "Archlinux Installation" --title "Subsonic Configuration" \
								--inputbox "Enter the port that you want to use:" 8 40 2>&1 > /dev/tty)
						if [ "$?" = "0" ]
						then
							sed -i "s/SUBSONIC_PORT=4040/SUBSONIC_PORT=$port/g" /var/lib/subsonic/subsonic.sh
						fi;;
					1) echo "HTTP port not changed";;
				esac

				dialog --backtitle "ArchLinux Installation" --title "Subsonic Configuration" \
						--yesno "Do you want to add a HTTPS port to Subsonic?" 7 60
				response=$?
				case $response in
					0)  port=$(dialog --backtitle "Archlinux Installation" --title "Subsonic Configuration" \
								--inputbox "Enter the port that you want to use:" 8 40 2>&1 > /dev/tty)
						if [ "$?" = "0" ]
						then
							sed -i "s/SUBSONIC_HTTPS_PORT=0/SUBSONIC_HTTPS_PORT=$port/g" /var/lib/subsonic/subsonic.sh
						fi;;
					1) echo "HTTPS port not configured";;
				esac
				systemctl enable subsonic
				systemctl start subsonic
				dialog --backtitle "ArchLinux Installation" --title "Subsonic Installation" \
						--msgbox "Subsonic Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip:$port\nUser: admin\nPassword: admin" 0 0
			;;

			"Madsonic")
				pacman -S --noconfirm ffmpeg flac lame
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -S -A --noconfirm madsonic
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				cd /var/madsonic
				test -d transcode || mkdir transcode
				chown -R root:root transcode
				mkdir /var/madsonic/transcode
				cd /var/madsonic/transcode
				ln -s "$(which ffmpeg)"
				ln -s "$(which flac)"
				ln -s "$(which lame)"

				dialog --backtitle "ArchLinux Installation" --title "Madsonic Configuration" \
						--yesno "Do you want to change the default HTTP port(4040) of Madsonic?" 7 60
				response=$?
				case $response in
					0)  port=$(dialog --backtitle "Archlinux Installation" --title "Madsonic Configuration" \
								--inputbox "Enter the port that you want to use:" 8 40 2>&1 > /dev/tty)
						if [ "$?" = "0" ]
						then
							sed -i "s/MADSONIC_PORT=4040/MADSONIC_PORT=$port/g" /var/madsonic/madsonic.sh
						fi;;
					1) echo "HTTP port not changed";;
				esac

				dialog --backtitle "ArchLinux Installation" --title "Madsonic Configuration" \
						--yesno "Do you want to add a HTTPS port to Madsonic?" 7 60
				response=$?
				case $response in
					0)  port=$(dialog --backtitle "Archlinux Installation" --title "Madsonic Configuration" \
								--inputbox "Enter the port that you want to use:" 8 40 2>&1 > /dev/tty)
						if [ "$?" = "0" ]
						then
							sed -i "s/MADSONIC_HTTPS_PORT=0/MADSONIC_HTTPS_PORT=$port/g" /var/madsonic/madsonic.sh
						fi;;
					1) echo "HTTPS port not configured";;
				esac
				systemctl enable madsonic
				systemctl start madsonic
				dialog --backtitle "ArchLinux Installation" --title "Madsonic Installation" \
						--msgbox "Madsonic Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip:$port\nUser: admin\nPassword: admin" 0 0
			;;

			"GitLab")
				ip=$(ip a | grep inet | grep -v inet6 | grep -v host | awk -F " " '{print $2}' | awk -F "/" '{print $1}')
				gitport=8080
				gitdomain=$ip
				if [[ $LAMP != 1 ]];then
					pacman -S --noconfirm mariadb
					##MariaDB
					mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
					systemctl start mysqld
					systemctl enable mysqld

					#Ask for the password of the root's database username
					rpassword=$(dialog --backtitle "Archlinux Installation" --passwordbox "Enter the root's password for MySQL/MariaDB:" 8 40 2>&1 > /dev/tty)
					if [ "$?" = "0" ]
					then
						/usr/bin/mysqladmin -u root password $rpassword
					fi
				fi

				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -S -A --noconfirm ruby-2.1
				sudo -u $user yaourt -S -A --noconfirm gitlab
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string

				gitsqlpass=$(dialog --backtitle "Archlinux Installation" --passwordbox "Enter gitlabs's database password:" 0 0 2>&1 > /dev/tty)
				gitsqlusernumber=$(cat -n /etc/webapps/gitlab/database.yml | grep "username: gitlab" | awk -F " " '{print $1}' | head -1)
				gitsqlusernumber=$[$gitsqlusernumber+1]
				sed -i "${gitsqlusernumber}s/.*/  password: $gitsqlpass/g" /etc/webapps/gitlab/database.yml
				gitsqlrootnumber=$(cat -n /etc/webapps/gitlab/database.yml | grep "username: root" | awk -F " " '{print $1}' | head -1)
				gitsqlrootnumber=$[$gitsqlrootnumber+1]
				sed -i "${gitsqlrootnumber}s/.*/  password: $rpassword/g" /etc/webapps/gitlab/database.yml

				sed -i 's/listen "127.0.0.1:8080"/listen "*:8080"/g' /etc/webapps/gitlab/unicorn.rb
				dialog --backtitle "ArchLinux Installation" --title "GitLab Installation" \
						--yesno "Do you want to change the listening port?\nDefault: 8080" 7 45
				if [[ $? == 0 ]];then
					gitport=$(dialog --backtitle "Archlinux Installation" --inputbox "Enter the port that you want to use:" 0 0 2>&1 > /dev/tty)
					sed -i "s/:8080/:$gitport/g" /etc/webapps/gitlab/unicorn.rb
				fi

				dialog --backtitle "ArchLinux Installation" --title "GitLab Installation" \
						--yesno "Do you want to configure a domain?" 7 38
				if [[ $? == 0 ]];then
					gitdomain=$(dialog --backtitle "Archlinux Installation" --inputbox "Enter the domain that you want to use:" 0 0 2>&1 > /dev/tty)
					gitdomainline=$(cat /usr/share/webapps/gitlab/config/gitlab.yml -n | grep "Web server settings" | awk -F " " '{print $1}' | head -1)
					gitdomainline=$[$gitdomainline+1]
					sed -i "${gitsqlrootnumber}s/.*/    host: $gitdomain/g" /usr/share/webapps/gitlab/config/gitlab.yml
				else
					gitdomainline=$(cat /usr/share/webapps/gitlab/config/gitlab.yml -n | grep "Web server settings" | awk -F " " '{print $1}' | head -1)
					gitdomainline=$[$gitdomainline+1]
					sed -i "${gitsqlrootnumber}s/.*/    host: $ip/g" /usr/share/webapps/gitlab/config/gitlab.yml
				fi
				sed -i "s/port: 80/port: $gitport/g" /etc/webapps/gitlab/gitlab.yml
				sed -i "s/:8080\x2F\x22/:$gitport\x2F\x22/g" /etc/webapps/gitlab-shell/config.yml
				cd /usr/share/webapps/gitlab ; printf "yes\n$rpassword" | bundle exec rake gitlab:setup RAILS_ENV=production
				su - gitlab -s /bin/sh -c "cd '/usr/share/webapps/gitlab'; bundle exec rake assets:precompile RAILS_ENV=production"
				systemctl start gitlab-sidekiq.service gitlab-unicorn
				systemctl enable gitlab-sidekiq.service gitlab-unicorn
				dialog --backtitle "ArchLinux Installation" --title "GitLab Installation" \
						--msgbox "GitLab Instalation is now completed. You can use this settings to connect to the server:\nIP: $gitdomain\nPort: $gitport\nUser: root\nPassword: 5iveL!fe" 0 0
			;;

			"Gogs")
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -S -A --noconfirm gogs
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				systemctl start gogs
				systemctl enable gogs
			;;

			"NTOP")
				pacman -S --noconfirm ntop
				ntoppass=$(dialog --backtitle "Archlinux Installation" --passwordbox "Enter NTOP's admin password:" 8 40 2>&1 > /dev/tty)
				ntop --set-admin-password=$ntoppass
				patterns=$(echo -e "en\nwl")
				interfaces=$(ip a | grep -E "$patterns" | grep -v inet | grep -v loop | grep -v link | grep -v DOWN | awk -F " " '{print $2}' | sed 's/://g' | sed 's/$/ net/')
				interface=$(dialog --backtitle "ArchLinux Installation" --clear --title "Interface: " \
						--menu "In what interface do you want to run NTOP?" 0 0 0 ${interfaces} 2>&1 > /dev/tty)
				sed -i "s/-i eth0/-i $interface/g" /lib/systemd/system/ntop.service
				ntopport=3000
				dialog --backtitle "ArchLinux Installation" --title "NTOP Instalation" --yesno "Do you want to change the default port for NTOP?\n(Default: 3000)" 8 45
				if [[ $? == "0" ]];then
					ntopport=$(dialog --backtitle "ArchLinux Installation" --title "NTOP Instalation" --inputbox "Enter the port that you want to use: " 8 40 2>&1 > /dev/tty)
					sed -i "s/-w 3000/-w $ntopport/g" /lib/systemd/system/ntop.service
				fi
				systemctl daemon-reload
				systemctl enable ntop
				systemctl start ntop
				dialog --backtitle "ArchLinux Installation" --title "NTOP Installation" \
						--msgbox "NTOP Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip:$ntopport\nUser: admin\nPassword: $ntoppass" 0 0
			;;

			"TightVNC")
				sessions=$(ls /usr/share/xsessions | awk -F "." '{print $1" "$2}')
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -S -A --noconfirm tightvnc
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string

				cp /lib/systemd/system/vncserver.service /lib/systemd/system/vncserver@:1.service
				sudo -u $user vncpasswd
				interface=$(dialog --backtitle "ArchLinux Installation" --clear --title "TightVNC Installation" \
									--menu "What desktop would you like to setup the VNC?" 0 0 0 ${sessions} 2>&1 > /dev/tty)
				mv /home/$user/.vnc/xstartup /home/$user/.vnc/xstartup.bak
				cat /usr/share/xsessions/$interface.desktop | grep Exec | grep -v Try | sed 's/^Exec=//g' > /home/$user/.vnc/xstartup
				sed -i "s/User=/User=$user/g" /lib/systemd/system/vncserver@:1.service
				systemctl enable vncserver@:1
				systemctl start vncserver@:1
				dialog --backtitle "ArchLinux Installation" --title "TightVNC Installation" \
						--msgbox "TightVNC Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip:5901\nPassword: The one you entered at the VNC configuration" 0 0

			;;

			"Deluge")
				pacman -S --noconfirm deluge python2-pip python2-mako
				pip2.7 install service-identity
				delugeport=8112
				dialog --backtitle "ArchLinux Installation" --title "Deluge Instalation" --yesno "Do you want to change the default port for Deluge?\n(Default: 8112)" 8 45
				if [[ $? == "0" ]];then
					delugeport=$(dialog --backtitle "ArchLinux Installation" --title "NTOP Instalation" --inputbox "Enter the port that you want to use: " 8 40 2>&1 > /dev/tty)
					sed -i "s/8112/$delugeport/g" /srv/deluge/.config/deluge/web.conf
				fi
				systemctl start deluged
				systemctl enable deluged
				systemctl start deluge-web
				systemctl enable deluge-web
				dialog --backtitle "ArchLinux Installation" --title "Deluge Installation" \
						--msgbox "Deluge Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip:$delugeport\nPassword: deluge" 0 0
			;;

			"L2TP")
				patterns=$(echo -e "en\nwl")
				interfaces=$(ip a | grep -E "$patterns" | grep -v inet | grep -v loop | grep -v link | grep -v DOWN | awk -F " " '{print $2}' | sed 's/://g' | sed 's/$/ net/')

				iface=$(dialog --backtitle "ArchLinux Installation" --clear --title "Interface: " \
						--menu "In what interface do you want to setup the VPN Server?" 20 30 7 ${interfaces} 2>&1 > /dev/tty)

				net=$(ip addr show dev $iface | grep "inet " | awk -F ' ' '{print $4}' | sed 's/255/0/g')
				ip=$(ip addr show dev $iface | grep "inet " | awk -F ' ' '{print $2}' | sed 's/\x2F24//g')
				gateway=$(ip route show dev $iface | grep default | awk -F " " '{print $3}')

				pacman -S --noconfirm xl2tpd ppp lsof python2
				sed -i '/%wheel ALL=(ALL) ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				sudo -u $user yaourt -A -S --noconfirm openswan
				sed -i '/%wheel ALL=(ALL) NOPASSWD: ALL/s/^/#/g' /etc/sudoers #Comment the line matching that string
				sed -i '/%wheel ALL=(ALL) ALL/s/^#//g' /etc/sudoers #Uncomment the line matching that string
				iptables --table nat --append POSTROUTING --jump MASQUERADE
				echo "net.ipv4.ip_forward = 1" |  tee -a /etc/sysctl.conf
				echo "net.ipv4.conf.all.accept_redirects = 0" |  tee -a /etc/sysctl.conf
				echo "net.ipv4.conf.all.send_redirects = 0" |  tee -a /etc/sysctl.conf
				echo "net.ipv4.conf.default.rp_filter = 0" |  tee -a /etc/sysctl.conf
				echo "net.ipv4.conf.default.accept_source_route = 0" |  tee -a /etc/sysctl.conf
				echo "net.ipv4.conf.default.send_redirects = 0" |  tee -a /etc/sysctl.conf
				echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" |  tee -a /etc/sysctl.conf
				for vpn in /proc/sys/net/ipv4/conf/*
				do
					echo 0 > $vpn/accept_redirects
					echo 0 > $vpn/send_redirects
				done
				sysctl -p
				printf "\x23\x21/usr/bin/env bash\nfor vpn in /proc/sys/net/ipv4/conf/*; do\n\techo 0 > \x24vpn/accept_redirects;\n\techo 0 > \x24vpn/send_redirects;\ndone\niptables --table nat --append POSTROUTING --jump MASQUERADE\n\nsysctl -p" > /usr/local/bin/vpn-boot.sh
				chmod 755 /usr/local/bin/vpn-boot.sh
				printf "[Unit]\nDescription=VPN Settings at boot\nAfter=netctl@$iface.service\nBefore=openswan.service xl2tpd.service\n\n[Service]\nExecStart=/usr/local/bin/vpn-boot.sh\n\n[Install]\nWantedBy=multi-user.target\n" > /etc/systemd/system/vpnboot.service
				systemctl enable vpnboot.service
				#IPSEC Configuration
				sed -i "s/\x23 plutoopts=\x22--perpeerlog\x22/plutoopts=\x22--interface=$iface\x22/g" /etc/ipsec.conf
				sed -i "s/virtual_private=%v4:10.0.0.0\x2F8,%v4:192.168.0.0\x2F16,%v4:172.16.0.0\x2F12,%v4:25.0.0.0\x2F8,%v6:fd00::\x2F8,%v6:fe80::\x2F10/virtual_private=%v4:10.0.0.0\x2F8,%v4:192.168.0.0\x2F16,%v4:$net\x2F24,%v4:172.16.0.0\x2F12,%v4:25.0.0.0\x2F8,%v6:fd00::\x2F8,%v6:fe80::\x2F10/g" /etc/ipsec.conf
				sed -i "s/protostack=auto/protostack=netkey/g" /etc/ipsec.conf
				sed -i '/#plutostderrlog=\x2Fdev\x2Fnull/a \\tforce_keepalive=yes\n\tkeep_alive=60\n\t# Send a keep-alive packet every 60 seconds.' /etc/ipsec.conf
				printf "\nconn L2TP-PSK-noNAT\n\tauthby=secret\n\t#shared secret. Use rsasig for certificates.\n\n\tpfs=no\n\t#Not enable pfs\n\n\tauto=add\n\n\t#the ipsec tunnel should be started and routes created when the ipsec daemon itself starts.\n\n\tkeyingtries=3\n\t#Only negotiate a conn. 3 times.\n\n\tikelifetime=8h\n\tkeylife=1h\n\n\ttype=transport\n\t#because we use l2tp as tunnel protocol\n\n\tleft=$ip\n\t#fill in server IP above\n\tleftnexthop=$gateway\n\tleftprotoport=17/1701\n\n\tright=\x25any\n\trightprotoport=17/\x25any\n\trightsubnetwithin=0.0.0.0/0\n\n\tdpddelay=10\n\t# Dead Peer Dectection (RFC 3706) keepalives delay\n\tdpdtimeout=20\n\t#  length of time (in seconds) we will idle without hearing either an R_U_THERE poll from our peer, or an R_U_THERE_ACK reply.\n\tdpdaction=clear\n\t# When a DPD enabled peer is declared dead, what action should be taken. clear means the eroute and SA with both be cleared.\n" >> /etc/ipsec.conf
				echo -e "$ip %any:\t PSK \x22$(openssl rand -hex 30)\x22" > /etc/ipsec.secrets
				systemctl start openswan
				ipsec verify
				systemctl enable openswan
				printf "[global]\nipsec saref = yes\nsaref refinfo = 30\nauth file = /etc/ppp/pap-secrets\nlisten-addr = $ip\n\n[lns default]\nip range = 172.16.1.30-172.16.1.100\nlocal ip = 172.16.1.1\nrequire authentication = yes\nppp debug = no\npppoptfile = /etc/ppp/options.xl2tpd\nlength bit = yes" > /etc/xl2tpd/xl2tpd.conf
				mkdir /var/run/xl2tpd/
				#printf "ms-dns 8.8.8.8\nms-dns 8.8.4.4\nauth\nmtu 1200\nmru 1000\ncrtscts\nhide-password\nmodem\nname l2tpd\nproxyarp\nlcp-echo-interval 30\nlcp-echo-failure 4\nlogin" > /etc/ppp/options.xl2tpd
				printf "ipcp-accept-local\nipcp-accept-remote\nms-dns 8.8.8.8\nms-dns 8.8.4.4\nauth\nmtu 1200\nmru 1000\ncrtscts\nhide-password\nmodem\nname l2tpd\nproxyarp\nlcp-echo-interval 30\nlcp-echo-failure 4\nlogin" > /etc/ppp/options.xl2tpd

				##PAM Auth
				echo -e "\nunix authentication = yes" >> /etc/xl2tpd/xl2tpd.conf
				printf "auth\trequired\tpam_nologin.so\nauth\trequired\tpam_unix.so\naccount required\tpam_unix.so\nsession required\tpam_unix.so" > /etc/pam.d/ppp
				echo -e "*\tl2tpd\t\x22\x22\t*" >> /etc/ppp/pap-secrets

				systemctl restart openswan
				systemctl restart xl2tpd
				systemctl enable xl2tpd
				externalip=$(dig +short myip.opendns.com @resolver1.opendns.com)
				dialog --backtitle "ArchLinux Installation" --title "L2TP Installation" \
						--msgbox "L2TP + IPSEC + PAM Instalation is now completed. You can use this settings to connect to the server:\nExternal IP: $externalip\nUser: Your system username\nPassword: Your system password according to the user" 0 0
			;;
			
			## added extra dotfiles#########################################################
			"dotfiles")
				pacman -S --noconfirm openssh
				dialog --backtitle "ArchLinux Installation" --title "Dotfiles copy" \
						--yesno "Do you want to add the full dotfiles" 7 60 
				
				## change from from here
				response=$?
				case $response in
					0)  port=$(dialog --backtitle "Archlinux Installation" --title "SSH Configuration" \
								--inputbox "Enter the port that you want to use:" 8 40 2>&1 > /dev/tty)
						if [ "$?" = "0" ]
						then
							sed -i -e "s/#Port 22/Port $(echo $port)/g" /etc/ssh/sshd_config
						fi;;
					1)  echo "Port not changed";;
				esac
				systemctl start sshd
				systemctl enable sshd
				dialog --backtitle "ArchLinux Installation" --title "SSH Installation" \
						--msgbox "SSH Instalation is now completed. You can use this settings to connect to the server:\nIP: $ip \nPort: $port" 0 0
			##################################################################################			
			;;
		esac
	done
fi

#Disable root automatic login tn tty1
rm -R /etc/systemd/system/getty@tty1.service.d
sed -i 's/sh post-install.sh//g' /root/.bashrc
rm /root/.bash_profile



# Delete the scripts and reboot
rm post-install.sh
reboot
