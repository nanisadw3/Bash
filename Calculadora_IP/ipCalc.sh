#!/usr/bin/bash
#Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Funciones

ctrl_c() {
  echo -e "${redColour}[+]${endColour} ${grayColour}Saliendo${endColour}"
  exit 1
}
validar_cidr() {
  local cidr="$1"

  # Validar formato con expresión regular
  if [[ "$cidr" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}/([0-9]{1,2})$ ]]; then
    # Separar IP y prefijo
    ip="${cidr%/*}"
    prefix="${cidr#*/}"

    # Validar prefijo
    if ((prefix < 0 || prefix > 32)); then
      return 1
    fi

    # Validar cada octeto
    IFS='.' read -r o1 o2 o3 o4 <<<"$ip"
    for octeto in $o1 $o2 $o3 $o4; do
      if ((octeto < 0 || octeto > 255)); then
        return 1
      fi
    done

    return 0
  else
    return 1
  fi
}

helpPanel() {
  echo -e "\n${grayColour}Uso ${endColour}${blueColour}$0${endColour}${grayColour}:${endColour}"
  echo -e "\n\t${purpleColour}-i${endColour}${grayColour}) Realizar todos los calculos para el CIDR correspondiente${endColour}"
  echo -e "\t${purpleColour}-s${endColour}${grayColour}) Escaneo de hosts activos con ARP${endColour}"
  echo -e "\t${purpleColour}-n${endColour}${grayColour}) Escaneo de puertos con nmap a un host específico${endColour}"
  echo -e "\t${purpleColour}-h${endColour}${grayColour}) Mostrar el panel de ayuda${endColour}"
}

ipCalc() {
  local cidr="$1"

  if validar_cidr "$cidr"; then

    echo -e "\n\t${yellowColour}=================================${endColour}"
    echo -e "\t${yellowColour}[+]${endColour} ${grayColour}CIDR = ${endColour}${blueColour}$cidr${endColour}"
    echo -e "\t${yellowColour}=================================${endColour}\n"

    # Convertir cada octeto a binario
    IFS='.' read -r o1 o2 o3 o4 <<<"$ip"
    bin_ip=$(printf "%08d.%08d.%08d.%08d\n" \
      "$(bc <<<"obase=2;$o1")" \
      "$(bc <<<"obase=2;$o2")" \
      "$(bc <<<"obase=2;$o3")" \
      "$(bc <<<"obase=2;$o4")")

    # Calcular máscara binaria completa de 32 bits
    bin_mask=$(printf "%-032s" "$(head -c "$prefix" </dev/zero | tr '\0' '1')")
    bin_mask=${bin_mask// /0}

    # Separar máscara binaria en 4 octetos
    b1=${bin_mask:0:8}
    b2=${bin_mask:8:8}
    b3=${bin_mask:16:8}
    b4=${bin_mask:24:8}

    # Convertir cada octeto de binario a decimal
    m1=$((2#$b1))
    m2=$((2#$b2))
    m3=$((2#$b3))
    m4=$((2#$b4))

    dec_mask="$m1.$m2.$m3.$m4"
    full_bin_mask="$b1.$b2.$b3.$b4"

    # Eliminar puntos de bin_ip para operar bit a bit
    bin_ip_clean=$(echo "$bin_ip" | tr -d '.')

    # Calcular Network ID binario (AND bit a bit)
    net_bin=""
    for i in {0..31}; do
      bit_ip=${bin_ip_clean:$i:1}
      bit_mask=${bin_mask:$i:1}
      if [[ $bit_ip == "1" && $bit_mask == "1" ]]; then
        net_bin+="1"
      else
        net_bin+="0"
      fi
    done

    # Separar en octetos binarios
    n1=${net_bin:0:8}
    n2=${net_bin:8:8}
    n3=${net_bin:16:8}
    n4=${net_bin:24:8}

    # Convertir a decimal
    net_dec="$((2#$n1)).$((2#$n2)).$((2#$n3)).$((2#$n4))"
    net_bin_fmt="$n1.$n2.$n3.$n4"

    # Invertir máscara binaria (NOT)
    inv_mask=""
    for ((i = 0; i < 32; i++)); do
      bit=${bin_mask:$i:1}
      if [[ $bit == "1" ]]; then
        inv_mask+="0"
      else
        inv_mask+="1"
      fi
    done

    # OR entre IP binaria y la máscara invertida para obtener broadcast
    bcast_bin=""
    for ((i = 0; i < 32; i++)); do
      bit_ip=${bin_ip_clean:$i:1}
      bit_inv_mask=${inv_mask:$i:1}
      if [[ $bit_ip == "1" || $bit_inv_mask == "1" ]]; then
        bcast_bin+="1"
      else
        bcast_bin+="0"
      fi
    done

    # Separar en octetos binarios
    b1=${bcast_bin:0:8}
    b2=${bcast_bin:8:8}
    b3=${bcast_bin:16:8}
    b4=${bcast_bin:24:8}

    # Convertir a decimal
    bcast_dec="$((2#$b1)).$((2#$b2)).$((2#$b3)).$((2#$b4))"
    bcast_bin_fmt="$b1.$b2.$b3.$b4"

    echo -e "${yellowColour}[+]${endColour} ${grayColour}Ip Binaria: ${endColour}${purpleColour}$bin_ip${endColour}"
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Mascara Binaria: ${endColour}${purpleColour}$full_bin_mask${endColour}"
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Network ID Binario: ${endColour}${purpleColour}$net_bin_fmt${endColour}"
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Broadcast Binario: ${endColour}${purpleColour}$bcast_bin_fmt${endColour}"

    echo -e ""

    echo -e "${yellowColour}[+]${endColour} ${grayColour}Mascara: ${endColour}${blueColour}$dec_mask${endColour}"
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Network ID Decimal: ${endColour}${blueColour}$net_dec${endColour}"
    echo -e "${yellowColour}[+]${endColour} ${grayColour}Broadcast Decimal: ${endColour}${blueColour}$bcast_dec${endColour}"

  else
    echo -e "${redColour}[!]${endColour} ${grayColour}CIDR inválido:${endColour} ${redColour}$cidr${endColour}"
    exit 1
  fi
}

escaneo_hosts() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Escaneando hosts activos con arp-scan...${endColour}\n"
  interface=$(ip route | grep default | awk '{print $5}')
  sudo arp-scan -I$interface --localnet
}

reconocimiento_nmap() {
  read -rp "Introduce la IP del host a escanear con nmap: " host_ip
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Escaneando puertos en $host_ip con nmap...${endColour}\n"
  sudo nmap -sS -Pn "$host_ip"
}
#Control+c
trap ctrl_c INT

declare -i opcion=0
while getopts "i:hsn" args; do
  case $args in
  i)
    cidr=$OPTARG
    opcion+=1
    ;;
  h)
    helpPanel
    ;;
  s)
    opcion+=2
    ;;
  n)
    opcion+=3
    ;;
  esac
done

if [[ $opcion -eq 1 ]]; then
  ipCalc $cidr
elif [[ $opcion -eq 2 ]]; then
  escaneo_hosts
elif [[ $opcion -eq 3 ]]; then
  reconocimiento_nmap
fi
