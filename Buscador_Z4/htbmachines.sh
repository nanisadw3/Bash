#!/bin/bash

#Colores
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"
#variables Globales:
main_url="https://htbmachines.github.io/bundle.js"
#Funciones
ctrl_c() {
  echo -e "\n\n${redColour}[!]Saliendo ...${endColour}"
  tput cnorm && exit 1
}
helpPanel() {
  echo -e "\n\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour}"
  echo -e "\t ${purpleColour}u)${endColour} ${grayColour}Descargar o actualizar archivos nesesarios${endColour}"
  echo -e "\t ${purpleColour}m)${endColour} ${grayColour}Buscar por nombre de maquna ${endColour}"
  echo -e "\t ${purpleColour}i)${endColour} ${grayColour}Buscar por ip${endColour}"
  echo -e "\t ${purpleColour}y)${endColour} ${grayColour}Obtener link de la resolucion de la maqyuina en youtuve${endColour}"
  echo -e "\t ${purpleColour}d)${endColour} ${grayColour}Listado de maquinas con ls dificultad especificada${endColour}"
  echo -e "\t ${purpleColour}o)${endColour} ${grayColour}Listado de maquina por sistema operativo${endColour}"
  echo -e "\t ${purpleColour}s)${endColour} ${grayColour}Buscar por skill${endColour}"
  echo -e "\t ${purpleColour}h)${endColour} ${grayColour}Mostrar panel de ayuda${endColour}"
}
updateFiles() {

  if [ ! -f bundle.js ]; then #si el archivo NO existe
    tput civis                #Ocultar el cursor
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Descargando Archivos nesesarios...${endColour}"
    curl -s -X GET $main_url >bundle.js
    js-beautify bundle.js | sponge bundle.js
    echo -e "${yellowColour}\n[+]${endColour} ${grayColour}Todos los archivos han sido Descargandos ${endColour}"
    tput cnorm #Recuperar el cursor
  else
    tput civis #Ocultar el cursor
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comprobando si hay actualizaciones pendientes ...${endColour}"
    curl -s -X GET $main_url >temp_bundle.js
    js-beautify temp_bundle.js | sponge temp_bundle.js
    md5_temp=$(md5sum temp_bundle.js | awk '{print $1}')
    md5_real=$(md5sum bundle.js | awk '{print $1}')

    if [ $md5_temp == $md5_real ]; then
      echo -e "${yellowColour}\n[+]${endColour} ${grayColour} No se han detectado actualizaciones"${endColour}
      rm temp_bundle.js
    else
      echo -e "${yellowColour}\n[+]${endColour} ${grayColour} Se han encontrado actualizaciones disponibles${endColour}"
      sleep 1
      rm bundle.js
      mv temp_bundle.js bundle.js
      echo -e "${yellowColour}\n[+]${endColour} ${grayColour} Los archivos se han actualizado${endColour}"
    fi
    tput cnorm #Recuperar el cursor
  fi

}
serchMachine() {
  maquna="$1" # obtenemos el nombre de la maquna

  existe=$(

    cat bundle.js | awk "/name: \"$maquna\"/,/resuelta:/" | grep -vE "resuelta|id|sku" | tr -d '"' | tr -d ',' | sed 's/^ *//' |
      awk -F ':' -v green="\033[1;32m" -v blue="\033[1;34m" -v reset="\033[0m" '{
      if (NF > 1) {
          printf "%s%s:%s%s\n", green, $1, blue, $2 reset
      } else {
          print $0
      }
  }'
  )

  if [ "$existe" ]; then

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listando las propiedades de la maquna${endColour} ${blueColour} $maquna ${endColour}${grayColour}:${endColour}\n"

    cat bundle.js | awk "/name: \"$maquna\"/,/resuelta:/" | grep -vE "resuelta|id|sku" | tr -d '"' | tr -d ',' | sed 's/^ *//' |
      awk -F ':' -v green="\033[1;32m" -v blue="\033[1;34m" -v reset="\033[0m" '{
        if (NF > 1) {
            printf "%s%s:%s%s\n", green, $1, blue, $2 reset
        } else {
            print $0
        }
    }'
  else
    echo -e "\n\t${redColour}[!]${endColour} La maquina especificada no existe\n"
  fi

}
getYoutuve() {

  maquna="$1" # obtenemos el nombre de la maquna
  youtube=$(
    cat bundle.js | awk "/name: \"$maquina\"/,/resuelta:/" | grep -vE "resuelta|id|sku" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep "youtube" | awk '{print$2}'
  )

  if [[ "$youtube" ]]; then
    echo -e "\n \t${yellowColour}[+]${endColour}${grayColour} El tutorial esta en este enlace ->${endColour} ${blueColour}$youtube${endColour}"
  else
    echo -e "\n\t${redColour}[!]${endColour} La maquina especificada no existe\n"
  fi
}

serchIp() {
  ipadd=$1

  machine=$(cat bundle.js | grep "ip: \"$ipadd\"" -B 3 | grep "name:" | awk '{print $NF}' | tr -d '"' | tr -d ',')
  if [[ $machine ]]; then
    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}El nombre de la maquina con la ip:${blueColour} $ipadd${endColour} es:${purpleColour} $machine ${endColour}"
  else
    echo -e "\n\t${redColour}[!]${endColour} La direccion ip existe\n"
  fi
}
getDif() {
  dif=$1

  difi="$(cat bundle.js | iconv -f utf8 -t ascii//TRANSLIT | grep "$dif" -B 5 | grep "name:" | awk '{print$2}' | tr -d '"' | tr -d ',' | column)"

  if [ "$difi" ]; then

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listando las maquinas con la dificultad ($dif)${endColour}:\n"

    echo -e "${grayColour}$difi${endColour}"

  else
    echo -e "\n\t${redColour}[!]${endColour} ${grayColour}Esta dificultad no esta registrada${endColour}"
  fi
}
getSO() {

  so=$1

  mach="$(cat bundle.js | grep "so: \"$so\"" -B 4 | grep "name:" | awk '{print$2}' | tr -d ',' | tr -d '"' | column)"

  if [ "$mach" ]; then

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listando las maquinas con el so: (${endColour}${purpleColour}$so${endColour}${grayColour}):${endColour}"
    echo -e "\n${grayColour}$mach${endColour}"

  else
    echo -e "\n\t${redColour}[!]${endColour} El sistema operativo no se encuentra registrado\n"
  fi
}

getSOYDificultad() {
  dif=$1
  so=$2

  match="$(cat bundle.js | iconv -f utf8 -t ascii//TRANSLIT | grep "so: \"$so\"" -C 4 | grep "dificultad: \"$dif\"" -B 5 | grep "name:" | awk '{print $2}' | tr -d '"' | tr -d ',' | column)"

  if [[ "$match" ]]; then

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listando maquinas con la dificultad (${endColour}${purpleColour}$dif${endColour}$grayColour) y con el so (${endColour}${blueColour}$so${endColour}${grayColour})${endColour}:\n"
    echo -e "${grayColour}$match${endColour}"

  else

    echo -e "\n\t${redColour}[!]${endColour} ${grayColour}El sistema operativo o la dificultad no estan registradas${endColour}\n"

  fi
}

getSkill() {
  skill=$1
  maquinas="$(cat bundle.js | grep "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk '{print$2}' | tr -d '"' | tr -d ',' | column)"

  if [[ $maquinas ]]; then

    echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Listado de maquinas que requieren esta skill ->(${endColour}${purpleColour}$skill${endColour}${grayColour}):${endColour}\n"
    echo -e "${grayColour}$maquinas${endColour}"

  else
    echo -e "\n\t${redColour}[!]${endColour} ${grayColour}No se encontro la skill ($skill)${endColour}"
  fi
}

#Ctrl+c
trap ctrl_c INT
# Indicadores
declare -i paramiter_counter=0 #declaro una variable entera que me va a servir como Indicador
declare -i dificultad=0
declare -i sistemaOp=0

#Main
#Sintaxis para los argumentos que le pasemos al comando
while getopts "m:uhi:y:d:o:s:" arg; do
  case $arg in
  m)
    maquina=$OPTARG
    let paramiter_counter+=1
    ;; #con OPTARG recivo la maquna que nos mando el ususario
  u) let paramiter_counter+=2 ;;
  i)
    ipadd=$OPTARG
    let paramiter_counter+=3
    ;;
  y)
    maquina=$OPTARG
    let paramiter_counter+=4
    ;;
  d)
    dif=$OPTARG
    dificultad=1
    let paramiter_counter+=5
    ;;
  o)
    so=$OPTARG
    sistemaOp=1
    let paramiter_counter+=6
    ;;
  s)
    skill=$OPTARG
    let paramiter_counter+=7
    ;;
  h) ;;
  esac
done

if [ $paramiter_counter -eq 1 ]; then
  serchMachine $maquina
elif [ $paramiter_counter -eq 2 ]; then
  updateFiles
elif [ $paramiter_counter -eq 3 ]; then
  serchIp $ipadd
elif [ $paramiter_counter -eq 4 ]; then
  getYoutuve $maquina
elif [ $paramiter_counter -eq 5 ]; then
  getDif $dif
elif [ $paramiter_counter -eq 6 ]; then
  getSO $so
elif [ $dificultad -eq 1 ] && [ $sistemaOp -eq 1 ]; then
  getSOYDificultad $dif $so
elif [ $paramiter_counter -eq 7 ]; then
  getSkill "$skill"
else
  helpPanel
fi
