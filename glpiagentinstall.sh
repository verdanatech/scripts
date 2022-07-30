#!/bin/bash
# -------------------------------------------------------------------------
# @Programa 
# 	@name: glpiagentinstall.sh
#	@versao: 0.0.1
#	@Data 30 de Julho de 2022
#	@Copyright: Verdanatech Soluções em TI, 2022
# --------------------------------------------------------------------------
# LICENSE
#
# glpiagentinstall.sh is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# glpiagentinstall.sh is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------------
 
#
# Variables Declaration
#

versionDate="Jul 30, 2022"
TITULO="Verdanatech GLPiInstall - v.0.0.1"
BANNER="http://www.verdanatech.com"

#
# Debian Links
#
GLPI_DEB_AGT_LINK="https://github.com/glpi-project/glpi-agent/releases/download/1.4/glpi-agent_1.4-1_all.deb"
GLPI_DEB_NET_LINK="https://github.com/glpi-project/glpi-agent/releases/download/1.4/glpi-agent-task-network_1.4-1_all.deb"
GLPI_DEB_ESX_LINK="https://github.com/glpi-project/glpi-agent/releases/download/1.4/glpi-agent-task-esx_1.4-1_all.deb"
GLPI_DEB_TSK_LINK="https://github.com/glpi-project/glpi-agent/releases/download/1.4/glpi-agent-task-collect_1.4-1_all.deb"


clear

cd /tmp

echo -e " ------------------------------------------------ _   _   _ \n ----------------------------------------------- / \\ / \\ / \\ \n ---------------------------------------------- ( \033[31mi\033[0m | \033[32mF\033[0m | \033[32mS\033[0m ) \n ----------------------------------------------- \\_/ \\_/ \\_/ \n| __      __          _                   _            _\n| \\ \\    / /         | |                 | |          | | \n|  \\ \\  / ___ _ __ __| | __ _ _ __   __ _| |_ ___  ___| |__ \n|   \\ \\/ / _ | '__/ _\` |/ _\` | '_ \\ / _\` | __/ _ \\/ __| '_ \\ \n|    \\  |  __| | | (_| | (_| | | | | (_| | ||  __| (__| | | | \n|     \\/ \\___|_|  \\__,_|\\__,_|_| |_|\\__,_|\\__\\___|\\___|_| |_| \n| \n|                    consulting, training and implementation \n|                                  comercial@verdanatech.com \n|                                        www.verdanatech.com \n|                                          \033[1m+55 81 3091 42 52\033[0m \n ------------------------------------------------------------ \n| \033[32m$TITULO\033[0m \n ----------------------------------------------------------- \n"

sleep 5

cd /tmp/

#
# install glpi-agent
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

			erroDescription="Error to set Asset TAG!"
			ASSET_TAG=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --inputbox "Enter the Asset TAG to use." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

			erroDescription="Error to set HTTP TRUSTED HOST!"
			TRUST=$(whiptail --title "${TITULO}" --backtitle "${BANNER}" --inputbox "Enter the http_trust host or network in CIDR format. eg: 127.0.0.1/32 192.168.1.0/24." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

			erroDescription="Error to create Agent Configuration!"
			echo -e "server = '$GLPI_SERVER'\nlocal = /tmp\ntasks = inventory,deploy,inventory\ndelaytime = 300\nlazy = 1\nscan-homedirs = 0\nscan-profiles = 0\nhtml = 0\nbackend-collect-timeout = 30\nforce = 1\nadditional-content =\nno-p2p = 0\nno-ssl-check = 0\ntimeout = 180\nno-httpd = 0\nhttpd-port = 62354\nhttpd-trust = $TRUST\nforce = 1\nlogger = syslog\nlogfacility = LOG_DAEMON\ncolor = 0\ntag = $ASSET_TAG\ndebug = 0\n" > /etc/glpi-agent/agent.cfg; [ $? -ne 0 ] && erroDetect
		
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
	SO=$(uname);
  [ $SO != Linux ] && erroDetect
	
	# Test if the user is root
	erroDescription="System administrator privilege is required"
	[ $UID -ne 0 ] && erroDetect
	
	# Test if the systen has which package
	erroDescription="The whiptail package is required to run the glpiagentinstall.sh"
	
	if [ $SO != Darwin ]
	then
		which whiptail; [ $? -ne 0 ] && erroDetect
	
		# Discovery the system version and instanciate variables
		erroDescription="Operating system not supported."
	
		source /etc/os-release ; [ $? -ne 0 ] && erroDetect
		
		case $ID in

			debian | ubuntu)
	
				case $VERSION_ID in
		
					11 | 10 | 9 | 8 | "16.04" | "16.10" | "17.04" | "17.10" | "18.04" | "18.10" | "19.04" | "19.10" | "20.04" | "20.10" | "21.04" | "21.10" | "22.04" )
		
						clear
						echo "System GNU/Linux $PRETTY_NAME detect..."
						sleep 2
						echo "Starting glpiagentinstall.sh by Verdanatech"
						echo "-----------------"; sleep 1;
	
						# Download and install glpi-agent
						erroDescription="Erro to get glpi-agent"
						wget -O glpi-agent.deb $GLPI_DEB_AGT_LINK; [ $? -ne 0 ] && erroDetect
						dpkg -i glpi-agent.deb
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
            
            # Download and install glpi-net
						erroDescription="Erro to get glpi-net"
						wget -O glpi-net.deb $GLPI_DEB_NET_LINK; [ $? -ne 0 ] && erroDetect
						dpkg -i glpi-net.deb
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
            
            # Download and install glpi-esx
						erroDescription="Erro to get glpi-esx"
						wget -O glpi-esx.deb $GLPI_DEB_ESX_LINK; [ $? -ne 0 ] && erroDetect
						dpkg -i glpi-esx.deb
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
						
						# Download and install glpi-task
						erroDescription="Erro to get glpi-task"
						wget -O glpi-task.deb $GLPI_DEB_TSK_LINK; [ $? -ne 0 ] && erroDetect
						dpkg -i glpi-task.deb
						erroDescription="Error to resolve dependencies"
						apt-get -f install -y; [ $? -ne 0 ] && erroDetect
					
					;;

				*)
					erroDescription="Operating system not supported."
					erroDetect				
				;;
		
				esac
	
		esac
		
	fi

	clear
	echo "Configuring glpi-agent..."
	sleep 2

	setAgentConfig

	clear
	echo "enable glpi-agent to start with system"
	sleep 1

	erroDescription="Error to enable glpi-agent with SystemCTL"

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


