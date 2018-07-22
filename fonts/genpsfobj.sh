#!/usr/bin/env bash

ERR="[ERROR\t]"
WRN="[WARNING\t]"
INF="[INFO\t]"

PSF="font.psfu"
OBJ="font.o"

echo -e "\n\n$INF Welcome to PSF object generator!\n\n"

if [ ! -f "./$PSF" ]; then
    echo -e "\n\n$ERR File $PSF not found!\n$INF Put $PSF in this folder!"
    exit 1
fi

objcopy -O elf64-x86-64 -B i386 -I binary ./$PSF ./$OBJ

if [ -f "./$OBJ" ]; then
    echo -e "\n$INF Congratulations ./$OBJ ready!"
    exit 0
fi
