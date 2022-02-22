#!/bin/bash

# Author: s4vitar - nmap y pa' dentro

#Colours
greenColor="\e[0;32m\033[1m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"
endColor="\033[0m\e[0m"

export DEBIAN_FRONTEND=noninteractive

trap ctrl_c INT

function ctrl_c(){
	echo -e "\n${yellowColor}[*]${endColor}${yellowColor}Saliendo${endColor}"
	tput cnorm; exit 0
	exit 0
}

function helpPanel(){
	echo -e "\n${yellowColor}[*]${endColor}${grayColor} Uso: ./s4viPwnWifi.sh${endColor}"
	echo -e "\t${purpleColor}a)${endColor}${yellowColor} Modo de ataque${endColor}"
	echo -e "\t\t${redColor}Handshake${endColor}"
	echo -e "\t\t${redColor}PKMID${endColor}"
	echo -e "\t${purpleColor}n)${endColor}${yellowColor} Nombre de la tarjeta de red${endColor}\n"
	exit 0
}

function dependencies(){
	tput civis
	clear; dependencies=(aircrack-ng macchanger)

	echo -e "${yellowColor}[*]${endColor}${grayColor} Comprobando programas necesarios...${endColor}"
	sleep 2

	for program in "${dependencies[@]}"; do
		echo -ne "\n${yellowColor}[*]${endColor}${blueColor} Herramientas ${endColor}${purpleColor}$program${endColor}${blueColor}...${endColor}"

		test -f /usr/bin/$program

		if [ "$(echo $?)" == "0" ]; then
			echo -e " ${greenColor}(V)${endColor}\n"
		else
			echo -e " ${redColor}(X)${endColor}\n"
			echo -e "${yellowColor}[*]${endColor}${grayColor} Instalando herramienta ${endColor}${blueColor}$program${endColor}${yellowColor}...${endColor}"
			apt-get install $program -y > /dev/null 2>&1
		fi; sleep 1

	done

}

function startAttack(){
	clear
	echo -e "${yellowColor}[*]${endColor}${grayColor} Configurando tarjeta de red...${endColor}\n"
	airmon-ng start $networkCard > /dev/null 2>&1
}


# Main

if [ "$(id -u)" == "0" ]; then
	declare -i parameter_counter=0; while getopts ":a:n:h:" arg; do
		case $arg in 
			a)attack_mode=$OPTARG; let parameter_counter+=1 ;;
			n) networkCard=$OPTARG; let parameter_counter+=1 ;;
			h) helpPanel ;;

		esac 
	done

	if [ $parameter_counter -ne 2 ]; then
		helpPanel
	else
		dependencies
		startAttack
		tput cnorm
	fi

else
	echo -e "\n${redColor}[*] No soy root${endColor}\n"
fi
