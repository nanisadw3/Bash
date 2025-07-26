#!/bin/bash

ctrl_c() {
  echo "Saliendo ..."
  exit 1
}

trap ctrl_c INT

for i in $(seq 0 63353); do
  (bash -c "echo "">/dev/tcp/localhost/$i") &>/dev/null && echo "$i -OPEN" &
done
wait
