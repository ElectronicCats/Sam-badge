                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Mac OS X x86_64)
                                      4 ;--------------------------------------------------------
                                      5 	.module blink
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _delay
                                     13 ;--------------------------------------------------------
                                     14 ; ram data
                                     15 ;--------------------------------------------------------
                                     16 	.area DATA
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area INITIALIZED
                                     21 ;--------------------------------------------------------
                                     22 ; Stack segment in internal ram 
                                     23 ;--------------------------------------------------------
                                     24 	.area	SSEG
      FFFFFF                         25 __start__stack:
      FFFFFF                         26 	.ds	1
                                     27 
                                     28 ;--------------------------------------------------------
                                     29 ; absolute external ram data
                                     30 ;--------------------------------------------------------
                                     31 	.area DABS (ABS)
                                     32 
                                     33 ; default segment ordering for linker
                                     34 	.area HOME
                                     35 	.area GSINIT
                                     36 	.area GSFINAL
                                     37 	.area CONST
                                     38 	.area INITIALIZER
                                     39 	.area CODE
                                     40 
                                     41 ;--------------------------------------------------------
                                     42 ; interrupt vector 
                                     43 ;--------------------------------------------------------
                                     44 	.area HOME
      008000                         45 __interrupt_vect:
      008000 82 00 80 07             46 	int s_GSINIT ; reset
                                     47 ;--------------------------------------------------------
                                     48 ; global & static initialisations
                                     49 ;--------------------------------------------------------
                                     50 	.area HOME
                                     51 	.area GSINIT
                                     52 	.area GSFINAL
                                     53 	.area GSINIT
      008007                         54 __sdcc_gs_init_startup:
      008007                         55 __sdcc_init_data:
                                     56 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   57 	ldw x, #l_DATA
      00800A 27 07            [ 1]   58 	jreq	00002$
      00800C                         59 00001$:
      00800C 72 4F 00 00      [ 1]   60 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   61 	decw x
      008011 26 F9            [ 1]   62 	jrne	00001$
      008013                         63 00002$:
      008013 AE 00 00         [ 2]   64 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   65 	jreq	00004$
      008018                         66 00003$:
      008018 D6 80 23         [ 1]   67 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   68 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   69 	decw	x
      00801F 26 F7            [ 1]   70 	jrne	00003$
      008021                         71 00004$:
                                     72 ; stm8_genXINIT() end
                                     73 	.area GSFINAL
      008021 CC 80 04         [ 2]   74 	jp	__sdcc_program_startup
                                     75 ;--------------------------------------------------------
                                     76 ; Home
                                     77 ;--------------------------------------------------------
                                     78 	.area HOME
                                     79 	.area HOME
      008004                         80 __sdcc_program_startup:
      008004 CC 80 50         [ 2]   81 	jp	_main
                                     82 ;	return from main will return to caller
                                     83 ;--------------------------------------------------------
                                     84 ; code
                                     85 ;--------------------------------------------------------
                                     86 	.area CODE
                                     87 ;	blink.c: 34: void delay(unsigned long count) {
                                     88 ;	-----------------------------------------
                                     89 ;	 function delay
                                     90 ;	-----------------------------------------
      008024                         91 _delay:
      008024 52 08            [ 2]   92 	sub	sp, #8
                                     93 ;	blink.c: 35: while (count--)
      008026 16 0D            [ 2]   94 	ldw	y, (0x0d, sp)
      008028 17 07            [ 2]   95 	ldw	(0x07, sp), y
      00802A 1E 0B            [ 2]   96 	ldw	x, (0x0b, sp)
      00802C                         97 00101$:
      00802C 1F 01            [ 2]   98 	ldw	(0x01, sp), x
      00802E 7B 07            [ 1]   99 	ld	a, (0x07, sp)
      008030 6B 03            [ 1]  100 	ld	(0x03, sp), a
      008032 7B 08            [ 1]  101 	ld	a, (0x08, sp)
      008034 16 07            [ 2]  102 	ldw	y, (0x07, sp)
      008036 72 A2 00 01      [ 2]  103 	subw	y, #0x0001
      00803A 17 07            [ 2]  104 	ldw	(0x07, sp), y
      00803C 24 01            [ 1]  105 	jrnc	00117$
      00803E 5A               [ 2]  106 	decw	x
      00803F                        107 00117$:
      00803F 4D               [ 1]  108 	tnz	a
      008040 26 08            [ 1]  109 	jrne	00118$
      008042 16 02            [ 2]  110 	ldw	y, (0x02, sp)
      008044 26 04            [ 1]  111 	jrne	00118$
      008046 0D 01            [ 1]  112 	tnz	(0x01, sp)
      008048 27 03            [ 1]  113 	jreq	00104$
      00804A                        114 00118$:
                                    115 ;	blink.c: 36: nop();
      00804A 9D               [ 1]  116 	nop
      00804B 20 DF            [ 2]  117 	jra	00101$
      00804D                        118 00104$:
                                    119 ;	blink.c: 37: }
      00804D 5B 08            [ 2]  120 	addw	sp, #8
      00804F 81               [ 4]  121 	ret
                                    122 ;	blink.c: 39: int main(void)
                                    123 ;	-----------------------------------------
                                    124 ;	 function main
                                    125 ;	-----------------------------------------
      008050                        126 _main:
                                    127 ;	blink.c: 42: CLK_CKDIVR = 4;
      008050 35 04 50 C6      [ 1]  128 	mov	0x50c6+0, #0x04
                                    129 ;	blink.c: 45: PA_DDR = 0xF7; //PA3 not an output
      008054 35 F7 50 02      [ 1]  130 	mov	0x5002+0, #0xf7
                                    131 ;	blink.c: 46: PC_DDR = 0xFF;
      008058 35 FF 50 0C      [ 1]  132 	mov	0x500c+0, #0xff
                                    133 ;	blink.c: 47: PD_DDR = 0xFD; //PD1 not an output
      00805C 35 FD 50 11      [ 1]  134 	mov	0x5011+0, #0xfd
                                    135 ;	blink.c: 49: PA_CR1 = 0xFF;
      008060 35 FF 50 03      [ 1]  136 	mov	0x5003+0, #0xff
                                    137 ;	blink.c: 50: PC_CR1 = 0xFF;
      008064 35 FF 50 0D      [ 1]  138 	mov	0x500d+0, #0xff
                                    139 ;	blink.c: 51: PD_CR1 = 0xFF;
      008068 35 FF 50 12      [ 1]  140 	mov	0x5012+0, #0xff
                                    141 ;	blink.c: 53: PA_ODR = 0x00;
      00806C 35 00 50 00      [ 1]  142 	mov	0x5000+0, #0x00
                                    143 ;	blink.c: 54: PC_ODR = 0x00;
      008070 35 00 50 0A      [ 1]  144 	mov	0x500a+0, #0x00
                                    145 ;	blink.c: 55: PD_ODR = 0x00;
      008074 35 00 50 0F      [ 1]  146 	mov	0x500f+0, #0x00
                                    147 ;	blink.c: 61: while(1) {
      008078                        148 00102$:
                                    149 ;	blink.c: 66: PA_ODR = 0xFF;
      008078 35 FF 50 00      [ 1]  150 	mov	0x5000+0, #0xff
                                    151 ;	blink.c: 67: PD_ODR = 0x00;
      00807C 35 00 50 0F      [ 1]  152 	mov	0x500f+0, #0x00
                                    153 ;	blink.c: 68: PC_ODR = 0xAA;
      008080 35 AA 50 0A      [ 1]  154 	mov	0x500a+0, #0xaa
                                    155 ;	blink.c: 69: delay(10000L);
      008084 4B 10            [ 1]  156 	push	#0x10
      008086 4B 27            [ 1]  157 	push	#0x27
      008088 5F               [ 1]  158 	clrw	x
      008089 89               [ 2]  159 	pushw	x
      00808A CD 80 24         [ 4]  160 	call	_delay
      00808D 5B 04            [ 2]  161 	addw	sp, #4
                                    162 ;	blink.c: 72: PA_ODR = 0x00;
      00808F 35 00 50 00      [ 1]  163 	mov	0x5000+0, #0x00
                                    164 ;	blink.c: 73: PD_ODR = 0x8A;
      008093 35 8A 50 0F      [ 1]  165 	mov	0x500f+0, #0x8a
                                    166 ;	blink.c: 74: PC_ODR = 0x55;
      008097 35 55 50 0A      [ 1]  167 	mov	0x500a+0, #0x55
                                    168 ;	blink.c: 75: delay(10000L);
      00809B 4B 10            [ 1]  169 	push	#0x10
      00809D 4B 27            [ 1]  170 	push	#0x27
      00809F 5F               [ 1]  171 	clrw	x
      0080A0 89               [ 2]  172 	pushw	x
      0080A1 CD 80 24         [ 4]  173 	call	_delay
      0080A4 5B 04            [ 2]  174 	addw	sp, #4
                                    175 ;	blink.c: 77: PA_ODR = 0xAA;
      0080A6 35 AA 50 00      [ 1]  176 	mov	0x5000+0, #0xaa
                                    177 ;	blink.c: 78: PD_ODR = 0x56;
      0080AA 35 56 50 0F      [ 1]  178 	mov	0x500f+0, #0x56
                                    179 ;	blink.c: 79: PC_ODR = 0xAA;
      0080AE 35 AA 50 0A      [ 1]  180 	mov	0x500a+0, #0xaa
                                    181 ;	blink.c: 80: delay(10000L);
      0080B2 4B 10            [ 1]  182 	push	#0x10
      0080B4 4B 27            [ 1]  183 	push	#0x27
      0080B6 5F               [ 1]  184 	clrw	x
      0080B7 89               [ 2]  185 	pushw	x
      0080B8 CD 80 24         [ 4]  186 	call	_delay
      0080BB 5B 04            [ 2]  187 	addw	sp, #4
                                    188 ;	blink.c: 82: PA_ODR = 0x55;
      0080BD 35 55 50 00      [ 1]  189 	mov	0x5000+0, #0x55
                                    190 ;	blink.c: 83: PD_ODR = 0x00 ;
      0080C1 35 00 50 0F      [ 1]  191 	mov	0x500f+0, #0x00
                                    192 ;	blink.c: 84: PC_ODR = 0x5A;
      0080C5 35 5A 50 0A      [ 1]  193 	mov	0x500a+0, #0x5a
                                    194 ;	blink.c: 85: delay(10000L);
      0080C9 4B 10            [ 1]  195 	push	#0x10
      0080CB 4B 27            [ 1]  196 	push	#0x27
      0080CD 5F               [ 1]  197 	clrw	x
      0080CE 89               [ 2]  198 	pushw	x
      0080CF CD 80 24         [ 4]  199 	call	_delay
      0080D2 5B 04            [ 2]  200 	addw	sp, #4
      0080D4 20 A2            [ 2]  201 	jra	00102$
                                    202 ;	blink.c: 88: }
      0080D6 81               [ 4]  203 	ret
                                    204 	.area CODE
                                    205 	.area CONST
                                    206 	.area INITIALIZER
                                    207 	.area CABS (ABS)
