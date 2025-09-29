#!/bin/bash
# -------------------------------------------------------------------------
# @Programa 
# 	@name: glpiagentinstall.sh
#	@versao: 1.1.0
#	@Data 29 de Setembro de 2025
#	@Copyright: Verdanatech Soluções em TI, 2022 - 2025
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
 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Variables Declaration
#

versionDate="Sep 29, 2025"
TITLE="Verdanadesk GLPi Agent Install - v.1.1.0"
BANNER="http://www.verdanatech.com"

comercialMail="comercial@verdanatech.com"
devMail="halexsandro.sales@verdanatech.com"

AGENT_VERSION=$(curl -s https://github.com/glpi-project/glpi-agent/releases/ | grep "/glpi-project/glpi-agent/tree/" | head -1 | awk '{print $2}' | rev | cut -d"/" -f1 | rev | tr -d '"')

#
# Debian Links
#
GLPI_DEB_AGT_LINK="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/glpi-agent_${AGENT_VERSION}-1_all.deb"
GLPI_DEB_NET_LINK="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/glpi-agent-task-network_${AGENT_VERSION}-1_all.deb"
GLPI_DEB_ESX_LINK="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/glpi-agent-task-esx_${AGENT_VERSION}-1_all.deb"
GLPI_DEB_COL_LINK="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/glpi-agent-task-collect_${AGENT_VERSION}-1_all.deb"
GLPI_DEB_TSK_LINK="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/glpi-agent-task-deploy_${AGENT_VERSION}-1_all.deb"

#
# Fedora Link
#
RH_INSTALLER="https://github.com/glpi-project/glpi-agent/releases/download/1.15/glpi-agent-1.15-1.noarch.rpm"

#
# MAC OS Links
#

# x86_64
GLPI_MAC_AGT_AMD64_PKG="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/GLPI-Agent-${AGENT_VERSION}_x86_64.pkg"
#GLPI_MAC_AGT_AMD64_DMG="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/GLPI-Agent-${AGENT_VERSION}_x86_64.dmg"

# arm64
GLPI_MAC_AGT_ARM64_PKG="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/GLPI-Agent-${AGENT_VERSION}_arm64.pkg"
#GLPI_MAC_AGT_ARM64_DMG="https://github.com/glpi-project/glpi-agent/releases/download/$AGENT_VERSION/GLPI-Agent-${AGENT_VERSION}_arm64.dmg"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# End variables Declaration
#


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Script functions
#

#
# erroDetect
#

function erroDetect(){
	#clear
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

#
# printLine
#

function printLine(){

	echo "- - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
	sleep 1

}

#
# soDiscovery
#

function soDiscovery(){

	erroDescription="This System is not supported"
	SO=$(uname);
	[ $SO != Darwin ] && [ $SO != Linux ] && erroDetect

	echo "Operation System Detected: $SO"
	echo "Press V to continue or any other key to cancel"
	read -n1 OPTION
	
	case $OPTION in
	
		v | V)
			echo "Continuing the installation..."
		;;
		
		*)
			erroDescription="Installation process aborted. Have a great day!"
			erroDetect
		;;
	
	esac

}

# Requirements 
which curl &> /dev/null
if [ $? -ne 0 ]
then 
	erroDescription="CURL not found. Please install it"
	erroDetect
 fi

#
# archDiscovery
#

function archDiscovery(){

	systemArch=$(uname -m)

	case $SO in

		Darwin)
		
			confPath="/Applications/GLPI-Agent/etc/agent.cfg"
			case $systemArch in

				arm64)

					echo "$systemArch architecture detected"
					MAC_AGENT=$GLPI_MAC_AGT_ARM64_PKG

				;;

				x86_64)

					echo "$systemArch architecture detected"
					MAC_AGENT=$GLPI_MAC_AGT_AMD64_PKG

				;;

				*)

					erroDescription="Detected architecture was $systemArch. Unfortunately this architecture is not yet supported by this installer. Contact your Verdanadesk support for help."
					erroDetect

				;;

			esac

		;;

		Linux)

			confPath="/etc/glpi-agent/agent.cfg"
			case $systemArch in

				i386 | i686 | x86_64 | armv7l | armhf | aarch64)

					echo "$systemArch architecture detected"

				;;

				*)

					erroDescription="Detected architecture was $systemArch. Unfortunately this architecture is not yet supported by this installer. Contact your Verdanadesk support for help."
					erroDetect

				;;

			esac
			
		;;

	esac

}


#
# discoveryDistro
#

function discoveryLinuxDistro(){

	erroDescription="Unable to find out your GNU/Linux distribution."
	source /etc/os-release ; [ $? -ne 0 ] && erroDetect
		
#Debian Based
	case $ID in

		debian | ubuntu | linuxmint | zorin | fedora )
	
			case $VERSION_ID in
		
				13 | 12 | 11 | 10 | 9 | 8 | "18.04" | "18.10" | "19.04" | "19.10" | "20.04" | "20.10" | "21.04" | "21.10" | "22.04" | "22.10" | "23.04" | "24.04" | "24.10" | "20.3" | "21.1" | "21.2" | "19.3" | 17 | "17.3" | 42 )

				echo "GNU/Linux distribution $ID and version $VERSION_ID detected."

			;;

				*)

					erroDescription="GNU/Linux distribution version not currently supported.. Contact your Verdanadesk consultant for assistance."
					erroDetect

				;;

			esac
            
        ;;

		*)

			erroDescription="GNU/Linux distribution or version not supported. Contact your Verdanadesk consultant for assistance."			erroDetect

		;;

	esac
}

#
# checkAgentExist
#

function checkAgentExist(){
	
	case $SO in

		Darwin)

			[ -e $confPath ] && confRequired=0  || confRequired=1
			egrep ^"server =" /Applications/GLPI-Agent/etc/agent.cfg > /dev/null 2>&1

		;;

		Linux)

			[ -e $confPath ] && confRequired=0  || confRequired=1

		;;

	esac

		if [ $confRequired -eq 0 ]
		then
			echo "Agent configuration file found..."
			sleep 1
			echo "Searching for valid entry for service..."
			sleep 1
			egrep ^"server =" /etc/glpi-agent/agent.cfg > /dev/null 2>&1
				
			if [ $? -eq 0 ]
			then

				SERVER=$(egrep ^"server =" /etc/glpi-agent/agent.cfg | cut -d"=" -f2)
				CONFIGURATION_OPTION=$(whiptail --title "${TITLE}" --backtitle "${BANNER}" --radiolist \
				"The installer found a configuration file pointing to the following server: $SERVER. Create a new configuration?" 10 80 2 \
				"yes" "New configuration" ON \
				"no" "Keep existing configuration." OFF 3>&1 1>&2 2>&3)

				if [ $CONFIGURATION_OPTION == yes ]; then
					confRequired=1
				else
					confRequired=0
				fi
			else
				confRequired=1
			fi
		fi
    
}

#
# createNewConf
#

function createNewConf(){

	if [ $SO == Linux ]
	then

		erroDescription="Error to set GLPi Server!"
		VERDANADESK_SERVER=$(whiptail --title "${TITLE}" --backtitle "${BANNER}" --inputbox "Enter your Verdanadesk our GLPi Server address: eg: https://empresa.verdanadesk.com." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

		erroDescription="Error to set Asset TAG!"
		ASSET_TAG=$(whiptail --title "${TITLE}" --backtitle "${BANNER}" --inputbox "Enter the Asset TAG to use." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

		erroDescription="Error to set HTTP TRUSTED HOST!"
		HTTPD_TRUST=$(whiptail --title "${TITLE}" --backtitle "${BANNER}" --inputbox "Enter the http_trust host or network in CIDR format. eg: 127.0.0.1/32 192.168.1.0/24." --fb 10 60 3>&1 1>&2 2>&3); [ $? -ne 0 ] && erroDetect

	else

		printLine

		echo "Enter your Verdanadesk our GLPi Server address: eg: https://empresa.verdanadesk.com."
		read VERDANADESK_SERVER

		echo "Enter the Asset TAG to use."
		read ASSET_TAG

		echo "Enter the http_trust host or network in CIDR format. eg: 127.0.0.1/32 192.168.1.0/24."
		read HTTPD_TRUST

	fi

erroDescription="Error to create Agent Configuration!"

cat > $confPath << EOF ; [ $? -ne 0 ] && erroDetect
# GLPI agent configuration by Verdanadesk

server = $VERDANADESK_SERVER
local = /tmp

tasks = inventory,netdiscovery,netinventory,deploy

delaytime = 3600
lazy = 0

scan-homedirs = 1
scan-profiles = 1
html = 0
json = 0
backend-collect-timeout = 180
force = 0
additional-content =

assetname-support = 1

no-p2p = 0

# Proxy Options
proxy =
user =
password =

# CA certificates directory
ca-cert-dir =
ca-cert-file =
no-ssl-check = 0

timeout = 180

#
# Web interface options
#

no-httpd = 0
httpd-ip =
httpd-port = 62354
httpd-trust = $HTTPD_TRUST

#
# Logging options
#

logger = syslog
logfile = /var/log/glpi-agent.log
logfile-maxsize = 1
logfacility = LOG_DAEMON
color = 0

#
# Execution mode options
#

tag = $ASSET_TAG
debug = 0

conf-reload-interval = 0

include "conf.d/"

EOF


}

# Function INSTALL
startInstall ()
{

	case $SO in

		Linux)

			case $ID in
				
				debian | ubuntu | linuxmint | zorin )

					echo "Starting..."
					printLine

					# Seleção de itens a instalar

					OPCOES=$(whiptail --title "Selecione as opções" --checklist \
					"Use a barra de espaço para selecionar as opções:" 15 60 5 \
					"1" "Inventory" OFF \
					"2" "NetInventory          " OFF \
					"3" "ESX" OFF \
					"4" "Collect" OFF \
					"5" "Deploy" OFF 3>&1 1>&2 2>&3)

					erroDescription="Installation process aborted."
					if [ $? -ne 0 ]; then

						erroDetect

					fi

					for i in $(echo $OPCOES | tr "\"" " ")
					do

						case $i in

							1)
								
								# Download and install Inventory
								erroDescription="Erro to get glpi-agent"
								wget -O glpi-agent.deb $GLPI_DEB_AGT_LINK  ; [ $? -ne 0 ] && erroDetect
      							echo "Inventory install ..."
								dpkg -i glpi-agent.deb > /dev/null 2>&1
								erroDescription="Error to resolve dependencies"
								apt-get -f install -y; [ $? -ne 0 ] && erroDetect

							;;

							2)

								# Download and install glpi-net
								erroDescription="Erro to get glpi-net"
								wget -O glpi-net.deb $GLPI_DEB_NET_LINK; [ $? -ne 0 ] && erroDetect
      							echo "Netinventory install ... "
								dpkg -i glpi-net.deb > /dev/null 2>&1
								erroDescription="Error to resolve dependencies"
								apt-get -f install -y; [ $? -ne 0 ] && erroDetect

							;;

							3)

								# Download and install glpi-esx
								erroDescription="Erro to get glpi-esx"
								wget -O glpi-esx.deb $GLPI_DEB_ESX_LINK; [ $? -ne 0 ] && erroDetect
      							echo "ESX install ..."
								dpkg -i glpi-esx.deb > /dev/null 2>&1
								erroDescription="Error to resolve dependencies"
								apt-get -f install -y; [ $? -ne 0 ] && erroDetect

							;;

							4) 

								# Download and install glpi-task
								erroDescription="Erro to get glpi-collect"
								wget -O glpi-colelct.deb $GLPI_DEB_COL_LINK; [ $? -ne 0 ] && erroDetect
      							echo "Task install ..."
								dpkg -i glpi-colelct.deb > /dev/null 2>&1
								erroDescription="Error to resolve dependencies"
								apt-get -f install -y; [ $? -ne 0 ] && erroDetect

							;;

							5)

								# Download and install glpi-task
								erroDescription="Erro to get glpi-task"
								wget -O glpi-task.deb $GLPI_DEB_TSK_LINK; [ $? -ne 0 ] && erroDetect
      							echo "Task install ..."
								dpkg -i glpi-task.deb > /dev/null 2>&1
								erroDescription="Error to resolve dependencies"
								apt-get -f install -y; [ $? -ne 0 ] && erroDetect

							;;	

						esac

					done

  				;;

				fedora)
				
					cd /tmp/
					curl -sSL $RH_INSTALLER -o glpi-agent.rpm
					rpm -i glpi-agent.rpm 

				;;

			esac
         
        ;;

		Darwin)

			erroDescription="Failed to download installation package from the internet"
			
			curl -L -k -o GLPI-Agent.pkg -O -#  $MAC_AGENT; [ $? -ne 0 ] && erroDetect

			erroDescription="Failed to install package downloaded from internet"
			installer -pkg GLPI-Agent.pkg -target /Applications; [ $? -ne 0 ] && erroDetect

		;;

	esac

}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# End script functions
#

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Start program
#

clear

cd /tmp

echo -e " ------------------------------------------------ _   _   _ \n ----------------------------------------------- / \\ / \\ / \\ \n ---------------------------------------------- ( \033[31mV\033[0m | \033[32mD\033[0m | \033[32mK\033[0m ) \n ----------------------------------------------- \\_/ \\_/ \\_/ \n| __      __          _                   _            _\n| \\ \\    / /         | |                 | |          | | \n|  \\ \\  / ___ _ __ __| | __ _ _ __   __ _| |_ ___  ___| |__ \n|   \\ \\/ / _ | '__/ _\` |/ _\` | '_ \\ / _\` | __/ _ \\/ __| '_ \\ \n|    \\  |  __| | | (_| | (_| | | | | (_| | ||  __| (__| | | | \n|     \\/ \\___|_|  \\__,_|\\__,_|_| |_|\\__,_|\\__\\___|\\___|_| |_| \n| \n|                     consulting, training and implementation \n|                                        of GLPi Professional \n|                                  comercial@verdanatech.com \n|                                        www.verdanatech.com \n|                                          \033[1m+55 81 3091 42 52\033[0m \n ------------------------------------------------------------ \n| \033[32m$TITLE\033[0m \n ----------------------------------------------------------- \n"

sleep 5

# Test if you have administrative privileges
erroDescription="System administrator privilege is required"
[ $UID -ne 0 ] && erroDetect

# Analyzing whether the Operating System is supported
soDiscovery

# If it is GNU/Linux, check if the distribution is supported
if [ $SO == Linux  ]
then

	discoveryLinuxDistro
	
	# Check if you have the whiptail package installed
	erroDescription="Your system does not have the whiptail package installed. Try installing it first with \"apt-get install whiptail\""
	which whiptail > /dev/null 2>&1 || erroDetect

fi

# Analyzing whether system architecture is supported
archDiscovery

# Starts the installation of the agent and other packages if possible/necessary
startInstall

# Analyzing if there is present agent configuration
checkAgentExist

# Validate whether it is necessary to create a new configuration for the agent.
if [ $confRequired -eq 1 ]
then

	createNewConf

fi

clear

echo "Running a new inventory"

if [ $SO == Linux  ]
then

	glpi-agent -f

else
	launchctl unload /Library/LaunchDaemons/com.teclib.glpi-agent.plist
	launchctl load /Library/LaunchDaemons/com.teclib.glpi-agent.plist
	/Applications/GLPI-Agent/bin/glpi-agent -f

fi

echo

echo -e "
\033[32m
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  
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

