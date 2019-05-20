#!/bin/bash

echo "$(sudo gcc -c phys_to_virt.c)"

echo "$(sudo as -o Main.o Main.s Random.s gpio0_2.s -g)"

echo "$(sudo gcc -o Main Main.o phys_to_virt.o)"

