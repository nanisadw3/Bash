#!/bin/bash
#iterar en un areglo en bash
declare -a array=(asd 423 ds 32 inaki)

posicion=0

for i in ${array[@]}; do
  let posicion+=1
  echo -e "[+] Elemento ($posicion): $i"

done

echo -e "\t[+] Existen ${#array[@]} elementos en el areglo"
echo -e "\n\t Sumar extremos\n"
arreglo=(1 2 3 4)

for i in ${arreglo[@]}; do
  echo "[+] VALOR: $i"
done

extremos=$((arreglo[0] + arreglo[-1]))
echo -e "\t[+] La suma de los extremos es $extremos"

arreglo+=(5)

for i in ${arreglo[@]}; do
  echo "[+] VALOR: $i"
done

extremos=$((arreglo[0] + arreglo[-1]))
echo -e "\t[+] La suma de los extremos es $extremos"

unset arreglo[0]        #Quitar el primer elemento del areglo
unset arreglo[-1]       #Quitar el ultimo elemento
arreglo=(${arreglo[@]}) #Restaurar el tamanio del areglo

for i in ${arreglo[@]}; do
  echo "[+] VALOR: $i"
done

unset arreglo[0]        #Quitar el primer elemento del areglo
unset arreglo[-1]       #Quitar el ultimo elemento
arreglo=(${arreglo[@]}) #Restaurar el tamanio del areglo

echo -e "[+] El tamanio ahora es ${#arreglo[@]}"
echo -e "${arreglo[-1]}"
