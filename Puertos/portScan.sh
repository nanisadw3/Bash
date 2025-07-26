#!/bin/bash

ctrl_c() {
  echo "Saliendo ..."
  exit 1
}

trap ctrl_c INT

for puerto in $(seq 1 65535); do
  (bash -c "echo "" >/dev/tcp/localhost/$puerto") 2>/dev/null && echo "El puerto $puerto esta abierto" &
done
wait
