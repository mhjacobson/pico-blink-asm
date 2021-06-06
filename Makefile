AS=arm-eabi-as
LD=arm-eabi-ld
OBJCOPY=arm-eabi-objcopy
PAD_CHECKSUM=../pico-sdk/src/rp2_common/boot_stage2/pad_checksum

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
