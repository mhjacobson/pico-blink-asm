.set APB_BASE, 0x40000000

.set RESETS_BASE, (APB_BASE + 0xc000)
.set RESETS_CTRL, (RESETS_BASE + 0x0)
.set RESETS_PADS_BANK0, (1 << 8)
.set RESETS_IO_BANK0, (1 << 5)
.set RESETS_DONE, (RESETS_BASE + 0x8)

.set IO_BANK0_BASE, (APB_BASE + 0x14000)
.set GPIO0_CTRL, (IO_BANK0_BASE + 0x004)
.set GPIO25_CTRL, (IO_BANK0_BASE + 0x0cc)
.set FUNCTION_SIO, 5

.set PADS_BANK0_BASE, (APB_BASE + 0x1c000)
.set PADS_GPIO0, (PADS_BANK0_BASE + 0x4)
.set PADS_GPIO25, (PADS_BANK0_BASE + 0x68)

.set SIO_BASE, 0xd0000000
.set GPIO_OUT, (SIO_BASE + 0x10)
.set GPIO_OE_SET, (SIO_BASE + 0x24)

.cpu cortex-m0plus
.thumb

.globl main
.thumb_func
main:
unreset:
	// take RESETS_PADS_BANK0 and RESETS_IO_BANK0 out of reset
	ldr r1, =RESETS_CTRL
	ldr r0, [r1]
	ldr r2, =(RESETS_PADS_BANK0 | RESETS_IO_BANK0)
	bic r0, r0, r2
	str r0, [r1]
	
unreset_check_loop:
	ldr r1, =RESETS_DONE
	ldr r0, [r1]
	tst r0, r2
	beq unreset_check_loop
	
configure:
	// configure our GPIO pin to be driven by SIO
	ldr r0, =FUNCTION_SIO
	ldr r1, =GPIO0_CTRL
	str r0, [r1]
	
	// configure pad options, too
	ldr r0, =0x0
	ldr r1, =PADS_GPIO0
	str r0, [r1]
	
	// enable SIO output
	ldr r0, =0xffffffff
	ldr r1, =GPIO_OE_SET
	str r0, [r1]
	
blink:
	// write to the pin via SIO
	ldr r3, =0xffffffff // all pins high
loop:
	ldr r1, =GPIO_OUT
	str r3, [r1]
	mvn r3, r3
	
sleep:
	ldr r0, =0
	ldr r1, =0x100000
wait:
	add r0, r0, #1
	cmp r0, r1
	blo wait
	
	b loop
