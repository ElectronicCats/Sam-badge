;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Mac OS X x86_64)
;--------------------------------------------------------
	.module blink
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _delay
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_gs_init_startup:
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	blink.c: 34: void delay(unsigned long count) {
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
	sub	sp, #8
;	blink.c: 35: while (count--)
	ldw	y, (0x0d, sp)
	ldw	(0x07, sp), y
	ldw	x, (0x0b, sp)
00101$:
	ldw	(0x01, sp), x
	ld	a, (0x07, sp)
	ld	(0x03, sp), a
	ld	a, (0x08, sp)
	ldw	y, (0x07, sp)
	subw	y, #0x0001
	ldw	(0x07, sp), y
	jrnc	00117$
	decw	x
00117$:
	tnz	a
	jrne	00118$
	ldw	y, (0x02, sp)
	jrne	00118$
	tnz	(0x01, sp)
	jreq	00104$
00118$:
;	blink.c: 36: nop();
	nop
	jra	00101$
00104$:
;	blink.c: 37: }
	addw	sp, #8
	ret
;	blink.c: 39: int main(void)
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	blink.c: 42: CLK_CKDIVR = 4;
	mov	0x50c6+0, #0x04
;	blink.c: 45: PA_DDR = 0xF7; //PA3 not an output
	mov	0x5002+0, #0xf7
;	blink.c: 46: PC_DDR = 0xFF;
	mov	0x500c+0, #0xff
;	blink.c: 47: PD_DDR = 0xFD; //PD1 not an output
	mov	0x5011+0, #0xfd
;	blink.c: 49: PA_CR1 = 0xFF;
	mov	0x5003+0, #0xff
;	blink.c: 50: PC_CR1 = 0xFF;
	mov	0x500d+0, #0xff
;	blink.c: 51: PD_CR1 = 0xFF;
	mov	0x5012+0, #0xff
;	blink.c: 53: PA_ODR = 0x00;
	mov	0x5000+0, #0x00
;	blink.c: 54: PC_ODR = 0x00;
	mov	0x500a+0, #0x00
;	blink.c: 55: PD_ODR = 0x00;
	mov	0x500f+0, #0x00
;	blink.c: 61: while(1) {
00102$:
;	blink.c: 66: PA_ODR = 0xFF;
	mov	0x5000+0, #0xff
;	blink.c: 67: PD_ODR = 0x00;
	mov	0x500f+0, #0x00
;	blink.c: 68: PC_ODR = 0xAA;
	mov	0x500a+0, #0xaa
;	blink.c: 69: delay(10000L);
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
	addw	sp, #4
;	blink.c: 72: PA_ODR = 0x00;
	mov	0x5000+0, #0x00
;	blink.c: 73: PD_ODR = 0x8A;
	mov	0x500f+0, #0x8a
;	blink.c: 74: PC_ODR = 0x55;
	mov	0x500a+0, #0x55
;	blink.c: 75: delay(10000L);
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
	addw	sp, #4
;	blink.c: 77: PA_ODR = 0xAA;
	mov	0x5000+0, #0xaa
;	blink.c: 78: PD_ODR = 0x56;
	mov	0x500f+0, #0x56
;	blink.c: 79: PC_ODR = 0xAA;
	mov	0x500a+0, #0xaa
;	blink.c: 80: delay(10000L);
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
	addw	sp, #4
;	blink.c: 82: PA_ODR = 0x55;
	mov	0x5000+0, #0x55
;	blink.c: 83: PD_ODR = 0x00 ;
	mov	0x500f+0, #0x00
;	blink.c: 84: PC_ODR = 0x5A;
	mov	0x500a+0, #0x5a
;	blink.c: 85: delay(10000L);
	push	#0x10
	push	#0x27
	clrw	x
	pushw	x
	call	_delay
	addw	sp, #4
	jra	00102$
;	blink.c: 88: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
