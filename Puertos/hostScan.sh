#!/bin/bash

ctrl_c() {
  echo "Saliendo ..."
  exit 1
}

trap ctrl_c INT

for i in $(seq 1 254); do
  timeout 1 bash -c "ping -c 1 192.168.100.$i >/dev/null" && echo "192.168.100.$i - Activo" &
done
wait
