BINUTILS=/Users/matt/Downloads/gcc-arm-none-eabi-10-2020-q4-major/arm-none-eabi/bin/
PAD_CHECKSUM=/Users/matt/src/pico-sdk/src/rp2_common/boot_stage2/pad_checksum

AS=${BINUTILS}/as
LD=${BINUTILS}/ld
OBJCOPY=${BINUTILS}/objcopy

.PHONY: all clean

all: build/blink.elf

clean:
	rm -rf build

build:
	mkdir build

build/main.o: main.s | build
	"${AS}" -o "$@" "$<"

build/main.bin: build/main.o | build
	"${OBJCOPY}" -Obinary "$<" "$@"

build/pad_checksum.s: build/main.bin | build
	"${PAD_CHECKSUM}" -s 0xffffffff "$<" "$@"

build/pad_checksum.o: build/pad_checksum.s | build
	"${AS}" -o "$@" "$<"

build/blink.elf: build/pad_checksum.o | build
	"${LD}" -o "$@" --section-start .boot2=0x10000000 "$<"