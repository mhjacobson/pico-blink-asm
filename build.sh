#!/bin/sh

set -e
set -x

/Users/matt/Downloads/gcc-arm-none-eabi-10-2020-q4-major/arm-none-eabi/bin/as -o main.o main.s
/Users/matt/Downloads/gcc-arm-none-eabi-10-2020-q4-major/bin/arm-none-eabi-objcopy -Obinary main.o main.bin
~/src/pico-sdk/src/rp2_common/boot_stage2/pad_checksum -s 0xffffffff main.bin pad_checksum.s
/Users/matt/Downloads/gcc-arm-none-eabi-10-2020-q4-major/arm-none-eabi/bin/as -o pad_checksum.o pad_checksum.s
/Users/matt/Downloads/gcc-arm-none-eabi-10-2020-q4-major/arm-none-eabi/bin/ld -o blink.elf --section-start .boot2=0x10000000 pad_checksum.o
