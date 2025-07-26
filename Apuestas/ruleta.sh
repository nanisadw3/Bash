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

ctrl_c() {
  echo -e "\n\n${redColour}[!]${endColour} ${grayColour}Saliendo...${endColour}"
  tput cnorm
  exit 1
}

helpPanel() {
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour} ${purpleColour}$0${endColour}\n"
  echo -e "\t${blueColour}-m)${blueColour} ${grayColour}Dinero con el que se desea jugar${endColour}"
  echo -e "\t${blueColour}-t)${endColour} ${grayColour}Tecnica a utilizar${endColour}"
  echo -e "\t${blueColour}-l)${endColour} ${grayColour}Listar tecnicas${endColour}"
  echo -e "\t${blueColour}-h)${endColour} ${grayColour}Panel de ayuda${endColour}\n"

  exit 1
}
getListado() {
  echo -e "${yellowColour}[+]${endColour} ${grayColour}Tecnicas para jugar:${endColour}\n"
  echo -e "\t${turquoiseColour}->${endColour} ${grayColour}Martingala${endColour}"
  echo -e "\t${turquoiseColour}->${endColour} ${grayColour}InverseLabrouchere${endColour}"
}
martingala() {

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour}$money${endColour}\n"
  continuar="false"
  while [ "$continuar" == "false" ]; do
    echo -ne "\t${turquoiseColour}[>]${endColour} ${grayColour}Cuanto Dinero quieres apostar? -> ${endColour}" && read apuesta
    if [[ apuesta -gt money ]]; then
      echo -e "\t${redColour}[!]${endColour} ${grayColour}No tienes sificiente dinero como para realizar esta apuesta${endColour}"
    else
      continuar="true"
    fi
  done

  #Guardamos la apuesta original
  apuesta_org=$apuesta

  #Contador de jugadas
  contador=0

  #Contador de jugadas Malas
  malas_jugadas=""

  #Mayor cantidad
  mayor=$money

  echo -ne "\t${turquoiseColour}[>]${endColour} ${grayColour}A que vas a apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Se va a jugar con una cantidad de ${endColour}${yellowColour}$apuesta${endColour} ${grayColour}a${endColour} ${yellowColour}$par_impar${endColour}\n"
  tput civis #Ocultar cursor
  while [[ true ]]; do
    money=$(($money - $apuesta))

    random="$(($RANDOM % 37))"
    #sleep 2

    if [[ "$money" -lt 0 ]]; then

      echo -e "\t${redColour}[+]${endColour} ${grayColour}Te quedaste sin dinero${endColour}"

      echo -e "\t${redColour}[+]${endColour} ${grayColour}Huvieron${endColour} ${blueColour}$contador${endColour} ${grayColour}apuestas${endColour}"

      echo -e "\t${redColour}[i]${endColour} ${grayColour}Malas jugadas: ( ${endColour}${blueColour}$malas_jugadas${grayColour})${endColour}"

      echo -e "\t${yellowColour}[i]${endColour} ${grayColour}Mayor cantidad de dinero alcanzada: ${endColour}${blueColour}$mayor${endColour}"
      tput cnorm
      exit 0

    else

      if [[ "$par_impar" == "par" ]]; then
        if [[ "$(($random % 2))" -eq 0 ]]; then
          if [[ "$random" -eq 0 ]]; then
            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Has apostado${endColour} ${yellowColour}$apuesta${endColour}${grayColour}, por lo que tienes${endColour} ${yellowColour}$money${endColour}"
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el ${endColour}${redColour}0${endColour} ${grayColour}por lo que pierdes${endColour}"
            echo -e "\t${redColour}[>]${blueColour} ${grayColour}Pierdes (${endColour}${yellowColour}$((apuesta))${endColour}${grayColour})"
            echo -e "\t${redColour}[>]${endColour} ${grayColour}Ahora tienes (${endColour}${yellowColour}$money${endColour}$grayColour)${endColour}\n"
            malas_jugadas+="$random "
            apuesta=$(($apuesta * 2))

          else
            echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Has apostado${endColour} ${yellowColour}$apuesta${endColour}${grayColour}, por lo que tienes${endColour} ${yellowColour}$money${endColour}"
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha saliendo el numero${endColour} ${blueColour}$random${endColour}"
            echo -e "${greenColour}[#]${endColour} ${grayColour}El numero es par, Ganas!${endColour}"
            money=$(($money + (2 * apuesta)))
            echo -e "\t${blueColour}[>]${blueColour} ${grayColour}Ganas (${endColour}${yellowColour}$((2 * apuesta))${endColour}${grayColour})"
            echo -e "\t${blueColour}[>]${endColour} ${grayColour}Ahora tienes (${endColour}${yellowColour}$money${endColour}$grayColour)${endColour}\n"
            apuesta=$apuesta_org
            malas_jugadas=""
          fi
        else

          echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Has apostado${endColour} ${yellowColour}$apuesta${endColour}${grayColour}, por lo que tienes${endColour} ${yellowColour}$money${endColour}"
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha saliendo el numero${endColour} ${blueColour}$random${endColour}"
          echo -e "${greenColour}[#]${endColour} ${grayColour}El numero es impar, Pierdes!${endColour}"
          echo -e "\t${redColour}[>]${blueColour} ${grayColour}Pierdes (${endColour}${yellowColour}$((apuesta))${endColour}${grayColour})"
          echo -e "\t${redColour}[>]${endColour} ${grayColour}Ahora tienes (${endColour}${yellowColour}$money${endColour}$grayColour)${endColour}\n"
          apuesta=$(($apuesta * 2))
          malas_jugadas+="$random "
        fi
      else

        if [[ "$(($random % 2))" -eq 1 ]]; then
          echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Has apostado${endColour} ${yellowColour}$apuesta${endColour}${grayColour}, por lo que tienes${endColour} ${yellowColour}$money${endColour}"
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha saliendo el numero${endColour} ${blueColour}$random${endColour}"
          echo -e "${greenColour}[#]${endColour} ${grayColour}El numero es impar, Ganas!${endColour}"
          money=$(($money + (2 * apuesta)))
          echo -e "\t${blueColour}[>]${blueColour} ${grayColour}Ganas (${endColour}${yellowColour}$((2 * apuesta))${endColour}${grayColour})"
          echo -e "\t${blueColour}[>]${endColour} ${grayColour}Ahora tienes (${endColour}${yellowColour}$money${endColour}$grayColour)${endColour}\n"
          apuesta=$apuesta_org
          malas_jugadas=""
        fi

        if [[ "$random" -eq 0 ]]; then
          echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Has apostado${endColour} ${yellowColour}$apuesta${endColour}${grayColour}, por lo que tienes${endColour} ${yellowColour}$money${endColour}"
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el ${endColour}${redColour}0${endColour} ${grayColour}por lo que pierdes${endColour}"
          echo -e "\t${redColour}[>]${blueColour} ${grayColour}Pierdes (${endColour}${yellowColour}$((apuesta))${endColour}${grayColour})"
          echo -e "\t${redColour}[>]${endColour} ${grayColour}Ahora tienes (${endColour}${yellowColour}$money${endColour}$grayColour)${endColour}\n"
          malas_jugadas+="$random "
          apuesta=$(($apuesta * 2))

        else
          echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Has apostado${endColour} ${yellowColour}$apuesta${endColour}${grayColour}, por lo que tienes${endColour} ${yellowColour}$money${endColour}"
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha saliendo el numero${endColour} ${blueColour}$random${endColour}"
          echo -e "${greenColour}[#]${endColour} ${grayColour}El numero es par, Pierdes!${endColour}"
          echo -e "\t${redColour}[>]${blueColour} ${grayColour}Pierdes (${endColour}${yellowColour}$((apuesta))${endColour}${grayColour})"
          echo -e "\t${redColour}[>]${endColour} ${grayColour}Ahora tienes (${endColour}${yellowColour}$money${endColour}$grayColour)${endColour}\n"
          apuesta=$(($apuesta * 2))
          malas_jugadas+="$random "
        fi

      fi
    fi
    if ((money > mayor)); then
      mayor=$money
    fi
    contador=$((contador + 1))
  done

  tput cnorm # Recupperamos el cursor
}

inverseLabrouchere() {

  secuencia=(1 2 3 4)
  seq_org=${#secuencia[@]}
  apuesta_i=$((${secuencia[0]} + ${secuencia[-1]}))
  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour}$money${endColour}\n"
  continuar="false"
  while [ "$continuar" == "false" ]; do
    if [[ $apuesta_i -gt $money ]]; then
      echo -e "\t${redColour}[!]${endColour} ${grayColour}No tienes sificiente dinero como para jugar${endColour}"
      exit 1
    else
      continuar="true"
    fi
  done

  superado=0

  tope=$(($money + 20))

  mayor=$money

  contador=0

  echo -ne "\t${turquoiseColour}[>]${endColour} ${grayColour}A que vas a apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  echo -e "${yellowColour}\n[+]${endColour} ${grayColour}Secuencia [${endColour}${greenColour}${secuencia[@]}${endColour}${grayColour}]${endColour}"

  echo -e "\n\t${yellowColour}[$]${endColour} ${grayColour}Dinero actual: ${endColour}${yellowColour}$money${endColour}\n"

  tput civis
  while [[ true ]]; do

    random=$(($RANDOM % 37))

    if [[ ${#secuencia[@]} -ne 1 ]]; then

      apuesta_i=$((${secuencia[0]} + ${secuencia[-1]}))

    elif [[ ${#secuencia[@]} -eq 1 ]]; then

      apuesta_i=${secuencia[0]}

    fi

    if [[ $money -lt 0 || $apuesta_i -gt $money ]]; then
      echo -e "${redColour}[!]${endColour} ${grayColour}Te quedaste sin dinero${endColour}"
      echo -e "${blueColour}[+]${endColour} ${grayColour}La mayor cantidad de dinero que se junto fue${endColour} ${blueColour}$mayor${endColour}"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Total de apuestas${endColour} ${blueColour}${contador}${endColour}"
      echo -e "${turquoiseColour}[+]${endColour} ${grayColour}El tope se ha superado ${endColour}${purpleColour}$superado${endColour} ${grayColour}veces${endColour} ${grayColour}el tope maximo fue -> ${endColour}${blueColour}$tope${endColour}"
      tput cnorm
      return
      exit 1

    fi

    echo -e "${yellowColour}[+]${endColour} ${grayColour}Ha salido el numero${endColour} ${blueColour}$random${endColour}"
    money=$(($money - $apuesta_i))
    echo -e "${yellowColour}[$]${endColour} ${grayColour}Invertimos ${yellowColour}$apuesta_i${endColour}${grayColour} por lo que tienes ${endColour}${yellowColour}$money${endColour}"

    if [[ "$par_impar" == "par" ]]; then

      if [[ "$(($random % 2))" -eq 0 ]]; then
        if [[ "$random" -eq 0 ]]; then

          echo -e "${redColour}[<] ${redColour}0${endColour} ${grayColour}pierdes!${endColour}"

          echo -e "\t${greenColour}[$]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money${endColour} ${grayColour}dinero${endColour}"

          if [[ ${#secuencia[@]} -ne 1 ]]; then
            unset secuencia[0]          #Quitar el primer elemento del secuencia
            unset secuencia[-1]         #Quitar el ultimo elemento
            secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

          elif [[ ${#secuencia[@]} -eq 1 ]]; then

            unset secuencia[0]          #Quitar el primer elemento del secuencia
            secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

          fi

          if [[ ${#secuencia[@]} -eq 0 ]]; then

            echo -e "${purpleColour}[...]${endColour}${grayColour}Se tiene que formatear la secuencia${endColour}"
            secuencia=(1 2 3 4)

          fi

          if [[ $money -lt $(($tope - 60)) ]]; then

            echo -e "\t${redColour}[!]${endColour} ${grayColour}Se ha llegado a un minimo critico, por lo que se reajustara el tope${endColour}"
            tope=$(($tope - 60))
            echo -e "\t${blueColour}[i]${endColour} ${grayColour}El tope se a renobado a ${endColour}${blueColour}$tope${endColour}"
            echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"
          else
            echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"
          fi

        else
          echo -e "${turquoiseColour}[+]${endColour} ${grayColour}El numero es par Ganas!${endColour}"
          money=$(($money + $apuesta_i * 2))
          echo -e "\t${greenColour}[$]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money${endColour} ${grayColour}dinero${endColour}"

          secuencia+=($apuesta_i)
          secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

          apuesta_i=$((${secuencia[0]} + ${secuencia[-1]}))

          if [[ $money -gt $mayor ]]; then

            mayor=$money

          fi

          if [[ $money -gt $tope ]]; then

            echo -e "\t${greenColour}[*]${endColour} ${grayColour}Se ha superado el tope establesido de${endColour} ${blueColour}$tope${endColour} ${grayColour}por lo que se reinicia la secuencia${endColour}"
            secuencia=(1 2 3 4)
            echo -e "\t${purpleColour}[#]${endColour} ${grayColour}Se formatea la secuencia -> [${endColour}${purpleColour}${secuencia[@]}${endColour}${grayColour}]${endColour}"
            tope=$(($tope + 20))
            echo -e "\t${greenColour}[i]${endColour} ${grayColour}Ahora el tope esta en${endColour} ${turquoiseColour}$tope${endColour}\n"
            superado=$(($superado + 1))

          else

            echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"

          fi

        fi
      else
        echo -e "${redColour}[<]${endColour} ${grayColour}El numero es impar Pierdes!${endColour}"
        echo -e "\t${greenColour}[$]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money${endColour} ${grayColour}dinero${endColour}"

        if [[ ${#secuencia[@]} -ne 1 ]]; then
          unset secuencia[0]          #Quitar el primer elemento del secuencia
          unset secuencia[-1]         #Quitar el ultimo elemento
          secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

        elif [[ ${#secuencia[@]} -eq 1 ]]; then

          unset secuencia[0]          #Quitar el primer elemento del secuencia
          secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

        fi

        if [[ ${#secuencia[@]} -eq 0 ]]; then

          echo -e "${purpleColour}[...]${endColour}${grayColour}Se tiene que formatear la secuencia${endColour}"
          secuencia=(1 2 3 4)

        fi

        if [[ $money -lt $(($tope - 60)) ]]; then

          echo -e "\t${redColour}[!]${endColour} ${grayColour}Se ha llegado a un minimo critico, por lo que se reajustara el tope${endColour}"
          tope=$(($tope - 60))
          echo -e "\t${blueColour}[i]${endColour} ${grayColour}El tope se a renobado a ${endColour}${blueColour}$tope${endColour}"
          echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"
        else
          echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"
        fi

      fi

    else

      if [[ "$(($random % 2))" -eq 0 ]]; then
        if [[ "$random" -eq 0 ]]; then

          echo -e "${redColour}[<] ${redColour}0${endColour} ${grayColour}pierdes!${endColour}"

          echo -e "\t${greenColour}[$]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money${endColour} ${grayColour}dinero${endColour}"

          if [[ ${#secuencia[@]} -ne 1 ]]; then
            unset secuencia[0]          #Quitar el primer elemento del secuencia
            unset secuencia[-1]         #Quitar el ultimo elemento
            secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

          elif [[ ${#secuencia[@]} -eq 1 ]]; then

            unset secuencia[0]          #Quitar el primer elemento del secuencia
            secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

          fi

          if [[ ${#secuencia[@]} -eq 0 ]]; then

            echo -e "\t${purpleColour}[...]${endColour}${grayColour}Se tiene que formatear la secuencia${endColour}"
            secuencia=(1 2 3 4)

          fi

          if [[ $money -lt $(($tope - 60)) ]]; then

            echo -e "\t${redColour}[!]${endColour} ${grayColour}Se ha llegado a un minimo critico, por lo que se reajustara el tope${endColour}"
            tope=$(($tope - 60))
            echo -e "\t${blueColour}[i]${endColour} ${grayColour}El tope se a renobado a ${endColour}${blueColour}$tope${endColour}"
            echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"
          else
            echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"
          fi

        else
          echo -e "${redColour}[<]${endColour} ${grayColour}El numero es par Pierdes!${endColour}"

          echo -e "\t${greenColour}[$]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money${endColour} ${grayColour}dinero${endColour}"

          if [[ ${#secuencia[@]} -ne 1 ]]; then
            unset secuencia[0]          #Quitar el primer elemento del secuencia
            unset secuencia[-1]         #Quitar el ultimo elemento
            secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

          elif [[ ${#secuencia[@]} -eq 1 ]]; then

            unset secuencia[0]          #Quitar el primer elemento del secuencia
            secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia

          fi

          if [[ ${#secuencia[@]} -eq 0 ]]; then

            echo -e "${purpleColour}[...]${endColour}${grayColour}Se tiene que formatear la secuencia${endColour}"
            secuencia=(1 2 3 4)

          fi

          if [[ $money -lt $(($tope - 60)) ]]; then

            echo -e "\t${redColour}[!]${endColour} ${grayColour}Se ha llegado a un minimo critico, por lo que se reajustara el tope${endColour}"
            tope=$(($tope - 60))
            echo -e "\t${blueColour}[i]${endColour} ${grayColour}El tope se a renobado a ${endColour}${blueColour}$tope${endColour}"
            echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"
          else
            echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"
          fi

        fi
      else
        echo -e "${turquoiseColour}[+]${endColour} ${grayColour}El numero es impar Ganas!${endColour}"

        money=$(($money + $apuesta_i * 2))
        echo -e "\t${greenColour}[$]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money${endColour} ${grayColour}dinero${endColour}"

        secuencia+=($apuesta_i)
        secuencia=(${secuencia[@]}) #Restaurar el tamanio del secuencia
        apuesta_i=$((${secuencia[0]} + ${secuencia[-1]}))

        if [[ $money -gt $mayor ]]; then

          mayor=$money

        fi

        if [[ $money -gt $tope ]]; then

          echo -e "\t${greenColour}[*]${endColour} ${grayColour}Se ha superado el tope establesido de${endColour} ${blueColour}$tope${endColour} ${grayColour}por lo que se reinicia la secuencia${endColour}"
          secuencia=(1 2 3 4)
          echo -e "\t${purpleColour}[#]${endColour} ${grayColour}Se formatea la secuencia -> [${endColour}${purpleColour}${secuencia[@]}${endColour}${grayColour}]${endColour}"
          tope=$(($tope + 20))
          echo -e "\t${greenColour}[i]${endColour} ${grayColour}Ahora el tope esta en${endColour} ${turquoiseColour}$tope${endColour}\n"
          superado=$(($superado + 1))

        else

          echo -e "${yellowColour}[+]${endColour} ${grayColour}La nueva secuencia es -> [${endColour}${blueColour}${secuencia[@]}${endColour}${grayColour}]${endColour}\n"

        fi

      fi

    fi

    contador=$((contador + 1))
  done
  tput cnorm

}

#Control c
trap ctrl_c INT
declare -i opcion_c=0

while getopts "m:t:hl" arg; do

  case $arg in
  m)
    money=$OPTARG
    ;;
  t)
    tecnique=$OPTARG
    ;;
  h)
    helpPanel
    ;;
  l)
    opcion_c+=1
    ;;
  esac
done

if [[ $money && $tecnique ]]; then
  if [[ "$tecnique" == "martingala" ]]; then
    martingala
  elif [[ "$tecnique" == "inverseLabrouchere" ]]; then
    inverseLabrouchere
  else
    echo -e "${redColour}[!]${endColour} ${grayColour}La tecnica no existe${endColour}\n"
    getListado
  fi
elif [[ $opcion_c -eq 1 ]]; then
  getListado
else
  helpPanel
fi
