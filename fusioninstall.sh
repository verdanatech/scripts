#!/bin/bash
# -------------------------------------------------------------------------
# @Programa 
# 	@name: fusioninstall.sh
#	@versao: 1.1.1
#	@Data 13 de Maio de 2021
#	@Copyright: Verdanatech Soluções em TI, 2021
# --------------------------------------------------------------------------
# LICENSE
#
# fusioninstall.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# fusioninstall.shis distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------
 
#
# Variables Declaration
#

versionDate="Out 26, 2021"
TITULO="Verdanatech FusionInstall - v.1.1.1"
BANNER="http://www.verdanatech.com"

#
# Debian Links
#
FUSION_DEB_LINK="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/fusioninventory-agent_2.6-1_all.deb"
FUSIONTASK_DEB_LINK="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/fusioninventory-agent-task-collect_2.6-1_all.deb"
FUSIONNET_DEB_LINK="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/fusioninventory-agent-task-network_2.6-1_all.deb"
FUSIONESX_DEB_LINK="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/fusioninventory-agent-task-esx_2.6-1_all.deb"

#
# MAC Links
#
FUSION_MAC_LINK="https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/FusionInventory-Agent-2.6-2.pkg.tar.gz"


clear

cd /tmp

echo -e " ------------------------------------------------ _   _   _ \n ----------------------------------------------- / \\ / \\ / \\ \n ---------------------------------------------- ( \033[31mi\033[0m | \033[32mF\033[0m | \033[32mS\033[0m ) \n ----------------------------------------------- \\_/ \\_/ \\_/ \n| __      __          _                   _            _\n| \\ \\    / /         | |                 | |          | | \n|  \\ \\  / ___ _ __ __| | __ _ _ __   __ _| |_ ___  ___| |__ \n|   \\ \\/ / _ | '__/ _\` |/ _\` | '_ \\ / _\` | __/ _ \\/ __| '_ \\ \n|    \\  |  __| | | (_| | (_| | | | | (_| | ||  __| (__| | | | \n|     \\/ \\___|_|  \\__,_|\\__,_|_| |_|\\__,_|\\__\\___|\\___|_| |_| \n| \n|                    consulting, training and implementation \n|                                  comercial@verdanatech.com \n|                                        www.verdanatech.com \n|                                          \033[1m+55 81 3091 42 52\033[0m \n ------------------------------------------------------------ \n| \033[32m$TITULO\033[0m \n ----------------------------------------------------------- \n"

sleep 5

cd /tmp/

#
# install fusioninventory-agent
#


#
# Functions
#

# Function setAgentConfig

function setAgentConfig(){

		if [ $SO != Darwin ]
		then
	
			erroDescription="Error to set GLPi Server!"
			GLPI_SERVER=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --inputbox "Enter the GLPi Server address: eg: https://empresa.verdanadesk.com." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

			erroDescription="Error to set fusion TAG!"
			FUSION_TAG=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --inputbox "Enter the fusion TAG to use." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

			erroDescription="Error to set HTTP TRUSTED HOST!"
			TRUST=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --inputbox "Enter the http_trust host or network in CIDR format. eg: 127.0.0.1/32 192.168.1.0/24." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

			erroDescription="Error to create Agent Configuration!"
			echo -e "server = '$GLPI_SERVER/plugins/fusioninventory/'\nlocal = /tmp\ntasks = inventory\ndelaytime = 300\nlazy = 1\nscan-homedirs = 0\nscan-profiles = 0\nhtml = 0\nbackend-collect-timeout = 30\nforce = 1\nadditional-content =\nno-p2p = 0\nno-ssl-check = 0\ntimeout = 180\nno-httpd = 0\nhttpd-port = 62354\nhttpd-trust = $TRUST\nforce = 1\nlogger = syslog\nlogfacility = LOG_DAEMON\ncolor = 0\ntag = $FUSION_TAG\ndebug = 0\n" > /etc/fusioninventory/agent.cfg; [ $? -ne 0 ] && erroDetect

		else
		
			clear
			echo " - - - - - - - - - - - - - "
			echo " Enter the GLPi Server address: eg: https://empresa.verdanadesk.com."
			read GLPI_SERVER
			echo "Enter the fusion TAG to use."
			read FUSION_TAG
			echo "Enter the http_trust host or network in CIDR format. eg: 127.0.0.1/32 192.168.1.0/24."
			read TRUST
			
			erroDescription="Error to create Agent Configuration!"
			echo -e "server = '$GLPI_SERVER/plugins/fusioninventory/'\nlocal = /tmp\ntasks = inventory\ndelaytime = 300\nlazy = 1\nscan-homedirs = 0\nscan-profiles = 0\nhtml = 0\nbackend-collect-timeout = 30\nforce = 0\nadditional-content =\nno-p2p = 0\nno-ssl-check = 0\ntimeout = 180\nno-httpd = 0\nhttpd-port = 62354\nhttpd-trust = $TRUST\nforce = 1\nlogger = syslog\nlogfacility = LOG_DAEMON\ncolor = 0\ntag = $FUSION_TAG\ndebug = 0\n" > /opt/fusioninventory-agent/etc/agent.cfg; [ $? -ne 0 ] && erroDetect
			
		fi

}


# Function erroDetect

function erroDetect(){
	clear
	echo -e "
\033[31m
 ----------------------------------------------------------- 
#                    ERRO DETECTED!!!                       #
 -----------------------------------------------------------\033[0m
  There was an error.
  An error was encountered in the installer and the process 
  was aborted.
  - - -
  \033[1m Error Description:\033[0m
 
  *\033[31m $erroDescription \033[0m
  - - -
  
  \033[1mFor commercial support contact us:\033[0m 
  
  +55 81 3091 42 52
  $comercialMail
  $devMail 
  
 ----------------------------------------------------------
  \033[32mVerdanatech Solucoes em TI - http://www.verdanatech.com\033[0m 
 ----------------------------------------------------------"

		kill $$
	
}

# Function INSTALL
INSTALL ()
{
	clear

	# Discovery and test SO support
	erroDescription="This System is not supported"
	SO=$(uname); [ $SO != Darwin ] && [ $SO != Linux ] && erroDetect
	
	# Test if the user is root
	erroDescription="System administrator privilege is required"
	[ $UID -ne 0 ] && erroDetect
	
	
	# Test if the systen has which package
	erroDescription="The whiptail package is required to run the fusioninstall.sh"
	
	if [ $SO != Darwin ]
	then
		which whiptail; [ $? -ne 0 ] && erroDetect
	
		# Discovery the system version and instanciate variables
		erroDescription="Operating system not supported."
	
		source /etc/os-release ; [ $? -ne 0 ] && erroDetect
		
		case $ID in

			debian)
	
				case $VERSION_ID in
		
					11 | 10 | 9 | 8)
		
						clear
						echo "System GNU/Linux $PRETTY_NAME detect..."
						sleep 2
						echo "Starting fusioninstall.sh by Verdanatech"
						echo "-----------------"; sleep 1;
	
						# Download and install fusioninventory-agent
						erroDescription="Erro to get fusioninventory-agent"
	
						wget -O fusioninventory-agent.deb $FUSION_DEB_LINK; [ $? -ne 0 ] && erroDetect
	
						dpkg -i fusioninventory-agent.deb
					
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
						
												# Download and install fusioninventory-task
						erroDescription="Erro to get fusioninventory-task"
	
						wget -O fusioninventory-task.deb $FUSIONTASK_DEB_LINK; [ $? -ne 0 ] && erroDetect
	
						dpkg -i fusioninventory-task.deb
				
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
						
						
						# Download and install fusioninventory-net
						erroDescription="Erro to get fusioninventory-net"
	
						wget -O fusioninventory-net.deb $FUSIONNET_DEB_LINK; [ $? -ne 0 ] && erroDetect
	
						dpkg -i fusioninventory-net.deb
				
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
						

						# Download and install fusioninventory-esx
						erroDescription="Erro to get fusioninventory-esx"
	
						wget -O fusioninventory-esx.deb $FUSIONESX_DEB_LINK; [ $? -ne 0 ] && erroDetect
	
						dpkg -i fusioninventory-esx.deb
				
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
					
					;;

				*)
					erroDescription="Operating system not supported."
					erroDetect				
				;;
		
				esac

			;;
		
			centos)
	
				case $VERSION_ID in
		
					7)

						clear
						echo "System GNU/Linux $PRETTY_NAME detect..."
						sleep 1
						echo "Starting fusioninstall.sh by Verdanatech"
						echo "-----------------"; sleep 1
						echo "-----------------"; sleep 1
	
						# Add perl repository to resolv dependencies
						erroDescription="Erro to  add EPEL repository!"
						yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm; [ $? -ne 0 ] && erroDetect
	
						# Add fusioninventory repository
						erroDescription="Erro to create fusioninventory repository!"
						echo -e "[trasher-fusioninventory-agent]
name=Copr repo for fusioninventory-agent owned by trasher
baseurl=https://copr-be.cloud.fedoraproject.org/results/trasher/fusioninventory-agent/epel-7-\$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/trasher/fusioninventory-agent/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
" > /etc/yum.repos.d/copr.fusion.repo; [ $? -ne 0 ] && erroDetect

						# Install fusioninventory-agent
						yum install -y fusioninventory-agent
					
					;;

					*)
						erroDescription="Operating system not supported."
						erroDetect				
					;;
		
				esac

			;;

			rhel)

				case $VERSION_ID in
				
					"8.1")

						clear
						echo "System GNU/Linux $PRETTY_NAME detect..."
						sleep 2
						echo "Starting fusioninstall.sh by Verdanatech"
						echo "-----------------"; sleep 1

						# Add perl repository to resolv dependencies
						erroDescription="Erro to  add EPEL repository!"
						yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm; [ $? -ne 0 ] && erroDetect

						# Add fusioninventory repository
						erroDescription="Erro to create fusioninventory repository!"
						echo -e "[trasher-fusioninventory-agent]
name=Copr repo for fusioninventory-agent owned by trasher
baseurl=https://copr-be.cloud.fedoraproject.org/results/trasher/fusioninventory-agent/epel-8-\$basearch/
type=rpm-md
skip_if_unavailable=True
gpgcheck=1
gpgkey=https://copr-be.cloud.fedoraproject.org/results/trasher/fusioninventory-agent/pubkey.gpg
repo_gpgcheck=0
enabled=1
enabled_metadata=1
" > /etc/yum.repos.d/copr.fusion.repo; [ $? -ne 0 ] && erroDetect

						# Install fusioninventory-agent
						yum install -y fusioninventory-agent
				
					;;


				
					*)
						erroDescription="Operating system not supported."
						erroDetect				
					;;
				esac
		
			;;
	
			ubuntu)

				case $VERSION_ID in

					"16.04" | "16.10" | "17.04" | "17.10" | "18.04" | "18.10" | "19.04" | "19.10" | "20.04" | "20.10" | 21.04 | 21.10 | 22.04 )
		
						clear
						echo "System GNU/Linux $PRETTY_NAME detect..."
						sleep 2
						echo "Starting fusioninstall.sh by Verdanatech"
						echo "-----------------"; sleep 1;

						# Download and install fusioninventory-agent
						erroDescription="Erro to get fusioninventory-agent"
	
						wget -O fusioninventory-agent.deb $FUSION_DEB_LINK; [ $? -ne 0 ] && erroDetect
	
						dpkg -i fusioninventory-agent.deb
				
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect


						# Download and install fusioninventory-task
						erroDescription="Erro to get fusioninventory-task"
	
						wget -O fusioninventory-task.deb $FUSIONTASK_DEB_LINK; [ $? -ne 0 ] && erroDetect
	
						dpkg -i fusioninventory-task.deb
				
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
						
						
						# Download and install fusioninventory-net
						erroDescription="Erro to get fusioninventory-net"
	
						wget -O fusioninventory-net.deb $FUSIONNET_DEB_LINK; [ $? -ne 0 ] && erroDetect
	
						dpkg -i fusioninventory-net.deb
				
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
						

						# Download and install fusioninventory-esx
						erroDescription="Erro to get fusioninventory-esx"
	
						wget -O fusioninventory-esx.deb $FUSIONESX_DEB_LINK; [ $? -ne 0 ] && erroDetect
	
						dpkg -i fusioninventory-esx.deb
				
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
						
					;;

					*)
						erroDescription="Operating system not supported."
						erroDetect
	
					;;
				esac

		esac
	else
		#
		# INSTALA MacOS
		#
		
		clear
		echo "System MacOS detect..."
		sleep 2
		echo "Starting fusioninstall.sh by Verdanatech"
		echo "-----------------"; sleep 1;

		# Download and install fusioninventory-agent
		erroDescription="Erro to get fusioninventory-agent"
	
		curl -sSL $FUSION_MAC_LINK -o fusioninventory-agent.tar.gz ; [ $? -ne 0 ] && erroDetect
	
		tar xfz fusioninventory-agent.tar.gz
		
		installer -pkg FusionInventory-Agent-2.6-2.pkg -target / -lang en
		
	fi

	clear
	echo "Configuring fusioninventory-agent..."
	sleep 2

	setAgentConfig

	clear
	echo "enable fusioninventory-agent to start with system"
	sleep 1

	erroDescription="Error to enable fusioninventory-agent with SystemCTL"

	# enable stato with system
	if [ $SO != Darwin ]
	then
		systemctl enable fusioninventory-agent; [ $? -ne 0 ] && erroDetect
		sleep 1
		
		erroDescription="Error to start fusioninventory-agent"
		# Iniciando o serviço fusioninventory
		systemctl start fusioninventory-agent; [ $? -ne 0 ] && erroDetect

		fusioninventory-agent --force; [ $? -ne 0 ] && erroDetect
		
	else
	
		erroDescription="Error to start fusioninventory-agent"
		# Iniciando o serviço fusioninventory	
		launchctl start org.fusioninventory.agent; [ $? -ne 0 ] && erroDetect
		
		erroDescription="Error to start fusioninventory-agent"
		# Iniciando o serviço fusioninventory
		/opt/fusioninventory-agent/bin/fusioninventory-agent; [ $? -ne 0 ] && erroDetect
		
	fi

}

INSTALL

clear

echo -e "
\033[32m
 ----------------------------------------------------------- 
#                    Congratulations!                       #
 -----------------------------------------------------------\033[0m
|                                                           |
|\033[34m Apparently, everything went well.\033[0m                         |
|\033[34m Know our services and products for you and your company.\033[0m  |
|\033[34m Conheca nossos servicos e produtos.\033[0m                       |
 -----------------------------------------------------------
|\033[32m https://www.verdanatech.com\033[0m                               |
 -----------------------------------------------------------
"


