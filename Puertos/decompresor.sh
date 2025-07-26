#!/bin/bash

ctrl_c() {
  echo -e "\n\n[!] Saliendo...\n"
  exit 1
}
#Crtl+C
trap ctrl_c INT

#sleep 10

actual_file_name="datos.gz"

next_file() {
  next_file_name="$(7z l $1 2>/dev/null | tail -n 3 | head -n 1 | awk '{print $NF}')"
}
decomprimir() {
  7z x $1 &>/dev/null
  actual_file_name="$next_file_name"
}

next_file "$actual_file_name"

while [[ -n "$next_file_name" ]]; do

  echo -e "\n[+] El archivo actual es $actual_file_name"
  echo -e "\n[+] El siguiente archivo es $next_file_name"
  decomprimir "$actual_file_name"
  next_file "$actual_file_name"

done

echo -e "\n--------------------------------------------------------------->El archivo final es $actual_file_name"
file $actual_file_name
cat $actual_file_name
