
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 2.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega8A
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _dipSwitchStatus=R4
	.DEF _dipSwitchStatus_msb=R5
	.DEF _status=R7

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x48,0x65,0x6C,0x6C,0x6F,0x31
_0x0:
	.DB  0x25,0x2E,0x32,0x66,0x20,0xA,0xD,0x20
	.DB  0x0
_0x2004A:
	.DB  0xE7,0xE7,0xE7,0xE7,0xE7,0xC2,0xC2,0xC2
	.DB  0xC2,0xC2,0xE7,0xE7,0xE7,0xE7,0xE7
_0x20000:
	.DB  0x41,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x02
	.DW  _0x2002D
	.DW  _0x20000*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.14 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 7/9/2023
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8A
;Program type            : Application
;AVR Core Clock frequency: 2.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;
;// Declare your global variables here
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;#include "uart.h"
;#include "NRF24L01plus.h"
;
;
;#define Internal_REF  1.78
;#define Tolerance_Res  1.091
;
;uint8_t str[20];
;float voltage_battery  = 0;
;float voltage_reset = 0;
;
;int dipSwitchStatus = 0;
;
;uint8_t RXData[32];
;
;uint8_t status = 0;
;uint8_t ACK_Payload[7] = "Hello1";

	.DSEG
;// Timer 0 overflow interrupt service routine
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0035 {

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0036 // Reinitialize Timer 0 value
; 0000 0037 
; 0000 0038 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0039 
; 0000 003A // Place your code here
; 0000 003B 
; 0000 003C      if(isDataAvailable(1))
	LDI  R26,LOW(1)
	LDI  R27,0
	RCALL _isDataAvailable
	CPI  R30,0
	BREQ _0x4
; 0000 003D       {
; 0000 003E        NRF24_Recive(RXData);
	LDI  R26,LOW(_RXData)
	LDI  R27,HIGH(_RXData)
	RCALL _NRF24_Recive
; 0000 003F        nrf24_write_ack();
	RCALL _nrf24_write_ack
; 0000 0040        UART_SendString(str,11);
	RCALL SUBOPT_0x0
	LDI  R26,LOW(11)
	RCALL _UART_SendString
; 0000 0041       }
; 0000 0042 }
_0x4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// Voltage Reference: AREF pin
;#define ADC_VREF_TYPE ((0<<REFS1) | (0<<REFS0) | (0<<ADLAR))
;uint8_t  RxAddress[] ;//= {0xEE,0xDD,0xCC,0xBB,0xAA};
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0049 {
_read_adc:
; .FSTART _read_adc
; 0000 004A ADMUX=adc_input | ADC_VREF_TYPE;
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 004B // Delay needed for the stabilization of the ADC input voltage
; 0000 004C delay_us(10);
	__DELAY_USB 7
; 0000 004D // Start the AD conversion
; 0000 004E ADCSRA|=(1<<ADSC);
	SBI  0x6,6
; 0000 004F // Wait for the AD conversion to complete
; 0000 0050 while ((ADCSRA & (1<<ADIF))==0);
_0x5:
	SBIS 0x6,4
	RJMP _0x5
; 0000 0051 ADCSRA|=(1<<ADIF);
	SBI  0x6,4
; 0000 0052 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20A0008
; 0000 0053 }
; .FEND
;
;#include "NRF24L01plus.h"
;void Battery_monitoring(float voltage)
; 0000 0057 {
_Battery_monitoring:
; .FSTART _Battery_monitoring
; 0000 0058     if(voltage <= 3.29)
	RCALL SUBOPT_0x1
;	voltage -> Y+0
	RCALL SUBOPT_0x2
	BREQ PC+3
	BRCS PC+2
	RJMP _0x8
; 0000 0059     {
; 0000 005A 
; 0000 005B         PORTC.1 = 1;
	SBI  0x15,1
; 0000 005C         PORTC.2 = 1;
	SBI  0x15,2
; 0000 005D         PORTC.0 = 0;
	CBI  0x15,0
; 0000 005E         delay_ms(300);
	RCALL SUBOPT_0x3
; 0000 005F         PORTC.0 = 1;
	SBI  0x15,0
; 0000 0060         delay_ms(300);
	RCALL SUBOPT_0x3
; 0000 0061     }
; 0000 0062     else if( voltage > 3.29 && voltage <=3.42)
	RJMP _0x11
_0x8:
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x2
	BREQ PC+2
	BRCC PC+2
	RJMP _0x13
	RCALL SUBOPT_0x5
	BREQ PC+3
	BRCS PC+2
	RJMP _0x13
	RJMP _0x14
_0x13:
	RJMP _0x12
_0x14:
; 0000 0063     {
; 0000 0064     PORTC.0 = 0;
	CBI  0x15,0
; 0000 0065     PORTC.1 = 1;
	RJMP _0x49
; 0000 0066     PORTC.2 = 1;
; 0000 0067     }
; 0000 0068     else if(voltage >3.42 && voltage <= 3.70)
_0x12:
	RCALL SUBOPT_0x5
	BREQ PC+2
	BRCC PC+2
	RJMP _0x1D
	RCALL SUBOPT_0x6
	BREQ PC+3
	BRCS PC+2
	RJMP _0x1D
	RJMP _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
; 0000 0069     {
; 0000 006A     PORTC.0 = 0;
	CBI  0x15,0
; 0000 006B     PORTC.1 = 0;
	CBI  0x15,1
; 0000 006C     PORTC.2 = 1;
	RJMP _0x4A
; 0000 006D     }
; 0000 006E     else if(voltage >3.70)
_0x1C:
	RCALL SUBOPT_0x6
	BREQ PC+2
	BRCC PC+2
	RJMP _0x26
; 0000 006F     {
; 0000 0070     PORTC.0 = 0;
	CBI  0x15,0
; 0000 0071     PORTC.1 = 0;
	CBI  0x15,1
; 0000 0072     PORTC.2 = 0;
	CBI  0x15,2
; 0000 0073     }
; 0000 0074     else
	RJMP _0x2D
_0x26:
; 0000 0075     {
; 0000 0076     PORTC.0 = 1;
	SBI  0x15,0
; 0000 0077     PORTC.1 = 1;
_0x49:
	SBI  0x15,1
; 0000 0078     PORTC.2 = 1;
_0x4A:
	SBI  0x15,2
; 0000 0079 
; 0000 007A    }
_0x2D:
_0x11:
; 0000 007B }
	RJMP _0x20A0003
; .FEND
;void DipSwitch()
; 0000 007D {
_DipSwitch:
; .FSTART _DipSwitch
; 0000 007E 
; 0000 007F       //  DDRD &= ~(0b11111111);
; 0000 0080 
; 0000 0081         // Read the status of DIP switches from pins D3 to D7
; 0000 0082             dipSwitchStatus = (PIND  & 0xF8) >> 3;
	IN   R30,0x10
	ANDI R30,LOW(0xF8)
	LDI  R31,0
	RCALL __ASRW3
	MOVW R4,R30
; 0000 0083 
; 0000 0084         // Compare the dipSwitchStatus with desired cases using switch
; 0000 0085   switch (dipSwitchStatus) {
; 0000 0086             case 0b00000:
	SBIW R30,0
	BRNE _0x37
; 0000 0087                 // No switches are ON
; 0000 0088                 // Perform corresponding actions
; 0000 0089                 RxAddress[0] = 0x00;
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x7
; 0000 008A                 RxAddress[1] = 0xDD;
; 0000 008B                 RxAddress[2] = 0xCC;
; 0000 008C                 RxAddress[3] = 0xBB;
; 0000 008D                 RxAddress[4] = 0xCB;
; 0000 008E                 NRF24_Write_Register(RF_CH, 0); // will be setup during TX or RX
	LDI  R26,LOW(0)
	RJMP _0x4B
; 0000 008F              break;
; 0000 0090             case 0b00001:
_0x37:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x38
; 0000 0091                 // Switch D3 is ON, other switches are OFF
; 0000 0092                 // Perform corresponding actions
; 0000 0093                 RxAddress[0] = 0x03;
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x7
; 0000 0094                 RxAddress[1] = 0xDD;
; 0000 0095                 RxAddress[2] = 0xCC;
; 0000 0096                 RxAddress[3] = 0xBB;
; 0000 0097                 RxAddress[4] = 0xCB;
; 0000 0098                 NRF24_Write_Register(RF_CH, 3); // will be setup during TX or RX
	LDI  R26,LOW(3)
	RJMP _0x4B
; 0000 0099                 break;
; 0000 009A             case 0b00010:
_0x38:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x39
; 0000 009B                 // Switch D4 is ON, other switches are OFF
; 0000 009C                 // Perform corresponding actions
; 0000 009D                       RxAddress[0] = 0xEE;
	LDI  R30,LOW(238)
	STS  _RxAddress,R30
; 0000 009E                 RxAddress[1] = 0x06;
	LDI  R30,LOW(6)
	__PUTB1MN _RxAddress,1
; 0000 009F                 RxAddress[2] = 0xCC;
	LDI  R30,LOW(204)
	__PUTB1MN _RxAddress,2
; 0000 00A0                 RxAddress[3] = 0xBB;
	LDI  R30,LOW(187)
	__PUTB1MN _RxAddress,3
; 0000 00A1                 RxAddress[4] = 0xCB;
	LDI  R30,LOW(203)
	__PUTB1MN _RxAddress,4
; 0000 00A2                 NRF24_Write_Register(RF_CH, 6); // will be setup during TX or RX
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(6)
	RJMP _0x4B
; 0000 00A3              break;
; 0000 00A4             case 0b00100:
_0x39:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x3A
; 0000 00A5                 // Switch D5 is ON, other switches are OFF
; 0000 00A6                 // Perform corresponding actions
; 0000 00A7                 RxAddress[0] = 0x09;
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x7
; 0000 00A8                 RxAddress[1] = 0xDD;
; 0000 00A9                 RxAddress[2] = 0xCC;
; 0000 00AA                 RxAddress[3] = 0xBB;
; 0000 00AB                 RxAddress[4] = 0xCB;
; 0000 00AC                 NRF24_Write_Register(RF_CH, 9); // will be setup during TX or RX
	LDI  R26,LOW(9)
	RJMP _0x4B
; 0000 00AD                 break;
; 0000 00AE             case 0b01000:
_0x3A:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x3B
; 0000 00AF                 // Switch D6 is ON, other switches are OFF
; 0000 00B0                 // Perform corresponding actions
; 0000 00B1                 RxAddress[0] = 0x0B;
	LDI  R30,LOW(11)
	RCALL SUBOPT_0x7
; 0000 00B2                 RxAddress[1] = 0xDD;
; 0000 00B3                 RxAddress[2] = 0xCC;
; 0000 00B4                 RxAddress[3] = 0xBB;
; 0000 00B5                 RxAddress[4] = 0xCB;
; 0000 00B6                 NRF24_Write_Register(RF_CH, 12); // will be setup during TX or RX
	LDI  R26,LOW(12)
	RJMP _0x4B
; 0000 00B7                   break;
; 0000 00B8             case 0b10000:
_0x3B:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x36
; 0000 00B9                 // Switch D7 is ON, other switches are OFF
; 0000 00BA                 // Perform corresponding actions
; 0000 00BB                 RxAddress[0] = 0x0E;
	LDI  R30,LOW(14)
	RCALL SUBOPT_0x7
; 0000 00BC                 RxAddress[1] = 0xDD;
; 0000 00BD                 RxAddress[2] = 0xCC;
; 0000 00BE                 RxAddress[3] = 0xBB;
; 0000 00BF                 RxAddress[4] = 0xCB;
; 0000 00C0                 NRF24_Write_Register(RF_CH, 15); // will be setup during TX or RX
	LDI  R26,LOW(15)
_0x4B:
	RCALL _NRF24_Write_Register
; 0000 00C1                 break;
; 0000 00C2 
; 0000 00C3   }
_0x36:
; 0000 00C4 
; 0000 00C5 
; 0000 00C6 }
	RET
; .FEND
;unsigned int averaging_adc()
; 0000 00C8 {   int i;
_averaging_adc:
; .FSTART _averaging_adc
; 0000 00C9     unsigned int value = 0;
; 0000 00CA     unsigned int array[40];
; 0000 00CB     for( i = 0; i < 40; i++)
	SBIW R28,63
	SBIW R28,17
	RCALL __SAVELOCR4
;	i -> R16,R17
;	value -> R18,R19
;	array -> Y+4
	__GETWRN 18,19,0
	RCALL SUBOPT_0x8
_0x3E:
	__CPWRN 16,17,40
	BRGE _0x3F
; 0000 00CC     {
; 0000 00CD         array[i] = read_adc(3);
	RCALL SUBOPT_0x9
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R26,LOW(3)
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X+,R30
	ST   X,R31
; 0000 00CE     }
	RCALL SUBOPT_0xA
	RJMP _0x3E
_0x3F:
; 0000 00CF     for(i = 0; i < 40; i++)
	RCALL SUBOPT_0x8
_0x41:
	__CPWRN 16,17,40
	BRGE _0x42
; 0000 00D0     {
; 0000 00D1        value += array[i];
	RCALL SUBOPT_0x9
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETW1P
	__ADDWRR 18,19,30,31
; 0000 00D2     }
	RCALL SUBOPT_0xA
	RJMP _0x41
_0x42:
; 0000 00D3     value /= 40;
	MOVW R26,R18
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	RCALL __DIVW21U
	MOVW R18,R30
; 0000 00D4     return value;
	RCALL __LOADLOCR4
	ADIW R28,63
	ADIW R28,21
	RET
; 0000 00D5 
; 0000 00D6 }
; .FEND
;
;
;
;void main(void)
; 0000 00DB {
_main:
; .FSTART _main
; 0000 00DC 
; 0000 00DD // Declare your local variables here
; 0000 00DE 
; 0000 00DF // Input/Output Ports initialization
; 0000 00E0 // Port B initialization
; 0000 00E1 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=Out Bit0=In
; 0000 00E2 DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(46)
	OUT  0x17,R30
; 0000 00E3 // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=0 Bit0=T
; 0000 00E4 PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 00E5 
; 0000 00E6 // Port C initialization
; 0000 00E7 // Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 00E8 DDRC=(1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(119)
	OUT  0x14,R30
; 0000 00E9 // State: Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 00EA PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	LDI  R30,LOW(55)
	OUT  0x15,R30
; 0000 00EB 
; 0000 00EC // Port D initialization
; 0000 00ED // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 00EE DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 00EF // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 00F0 PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(248)
	OUT  0x12,R30
; 0000 00F1 
; 0000 00F2 // Timer/Counter 0 initialization
; 0000 00F3 // Clock source: System Clock
; 0000 00F4 // Clock value: 250.000 kHz
; 0000 00F5 TCCR0=(0<<CS02) | (1<<CS01) | (0<<CS00);
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 00F6 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 00F7 
; 0000 00F8 // Timer/Counter 1 initialization
; 0000 00F9 // Clock source: System Clock
; 0000 00FA // Clock value: Timer1 Stopped
; 0000 00FB // Mode: Normal top=0xFFFF
; 0000 00FC // OC1A output: Disconnected
; 0000 00FD // OC1B output: Disconnected
; 0000 00FE // Noise Canceler: Off
; 0000 00FF // Input Capture on Falling Edge
; 0000 0100 // Timer1 Overflow Interrupt: Off
; 0000 0101 // Input Capture Interrupt: Off
; 0000 0102 // Compare A Match Interrupt: Off
; 0000 0103 // Compare B Match Interrupt: Off
; 0000 0104 TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0105 TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (0<<CS10);
	OUT  0x2E,R30
; 0000 0106 TCNT1H=0xF8;
	LDI  R30,LOW(248)
	OUT  0x2D,R30
; 0000 0107 TCNT1L=0x30;
	LDI  R30,LOW(48)
	OUT  0x2C,R30
; 0000 0108 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0109 ICR1L=0x00;
	OUT  0x26,R30
; 0000 010A OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 010B OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 010C OCR1BH=0x00;
	OUT  0x29,R30
; 0000 010D OCR1BL=0x00;
	OUT  0x28,R30
; 0000 010E 
; 0000 010F // Timer/Counter 2 initialization
; 0000 0110 // Clock source: System Clock
; 0000 0111 // Clock value: Timer2 Stopped
; 0000 0112 // Mode: Normal top=0xFF
; 0000 0113 // OC2 output: Disconnected
; 0000 0114 ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 0115 TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0116 TCNT2=0x06;
	LDI  R30,LOW(6)
	OUT  0x24,R30
; 0000 0117 OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 0118 
; 0000 0119 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 011A TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<TOIE0);
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 011B 
; 0000 011C // External Interrupt(s) initialization
; 0000 011D // INT0: Off
; 0000 011E // INT1: Off
; 0000 011F MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0120 
; 0000 0121 // USART initialization
; 0000 0122 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0123 // USART Receiver: On
; 0000 0124 // USART Transmitter: On
; 0000 0125 // USART Mode: Asynchronous
; 0000 0126 // USART Baud Rate: 9600
; 0000 0127 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 0128 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0129 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 012A UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 012B UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 012C 
; 0000 012D // Analog Comparator initialization
; 0000 012E // Analog Comparator: Off
; 0000 012F // The Analog Comparator's positive input is
; 0000 0130 // connected to the AIN0 pin
; 0000 0131 // The Analog Comparator's negative input is
; 0000 0132 // connected to the AIN1 pin
; 0000 0133 ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0134 
; 0000 0135 // ADC initialization
; 0000 0136 // ADC Clock frequency: 1000.000 kHz
; 0000 0137 // ADC Voltage Reference: AREF pin
; 0000 0138 ADMUX=ADC_VREF_TYPE;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 0139 ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (1<<ADPS0);
	LDI  R30,LOW(129)
	OUT  0x6,R30
; 0000 013A SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 013B 
; 0000 013C // SPI initialization
; 0000 013D // SPI Type: Master
; 0000 013E // SPI Clock Rate: 500.000 kHz
; 0000 013F // SPI Clock Phase: Cycle Start
; 0000 0140 // SPI Clock Polarity: Low
; 0000 0141 // SPI Data Order: MSB First
; 0000 0142 SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 0143 SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 0144 
; 0000 0145 // TWI initialization
; 0000 0146 // TWI disabled
; 0000 0147 TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 0148 
; 0000 0149 // Global enable interrupts
; 0000 014A #asm("sei")
	sei
; 0000 014B PORTC.4 = 0;
	CBI  0x15,4
; 0000 014C delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 014D 
; 0000 014E NRF24L01plus_Init();
	RCALL _NRF24L01plus_Init
; 0000 014F DipSwitch();
	RCALL _DipSwitch
; 0000 0150 NRF24_RxMode(( uint8_t *)RxAddress,9);
	LDI  R30,LOW(_RxAddress)
	LDI  R31,HIGH(_RxAddress)
	RCALL SUBOPT_0xB
	LDI  R26,LOW(9)
	RCALL _NRF24_RxMode
; 0000 0151 
; 0000 0152 while (1)
_0x45:
; 0000 0153       {
; 0000 0154       // Place your code here
; 0000 0155 
; 0000 0156         voltage_battery =4.2*(2*(averaging_adc()/1023.00))/Tolerance_Res;// 1023  511.5
	RCALL _averaging_adc
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0xC
	__GETD1N 0x447FC000
	RCALL __DIVF21
	__GETD2N 0x40000000
	RCALL __MULF12
	__GETD2N 0x40866666
	RCALL __MULF12
	RCALL SUBOPT_0xC
	__GETD1N 0x3F8BA5E3
	RCALL __DIVF21
	STS  _voltage_battery,R30
	STS  _voltage_battery+1,R31
	STS  _voltage_battery+2,R22
	STS  _voltage_battery+3,R23
; 0000 0157         sprintf(str, "%.2f \n\r ", voltage_battery);
	RCALL SUBOPT_0x0
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0xB
	LDS  R30,_voltage_battery
	LDS  R31,_voltage_battery+1
	LDS  R22,_voltage_battery+2
	LDS  R23,_voltage_battery+3
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _sprintf
	ADIW R28,8
; 0000 0158         //UART_SendString(str, 20);
; 0000 0159         Battery_monitoring(voltage_battery);
	LDS  R26,_voltage_battery
	LDS  R27,_voltage_battery+1
	LDS  R24,_voltage_battery+2
	LDS  R25,_voltage_battery+3
	RCALL _Battery_monitoring
; 0000 015A 
; 0000 015B 
; 0000 015C     }
	RJMP _0x45
; 0000 015D }
_0x48:
	RJMP _0x48
; .FEND
;#include "NRF24L01plus.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include "uart.h"
;//------------------------------------------------------------
;
;void NRF24_Write_Register(uint8_t reg, uint8_t Data)
; 0001 0006 {

	.CSEG
_NRF24_Write_Register:
; .FSTART _NRF24_Write_Register
; 0001 0007 if(reg <= 31)
	ST   -Y,R26
;	reg -> Y+1
;	Data -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x20)
	BRSH _0x20003
; 0001 0008 {
; 0001 0009    uint8_t buf[2];
; 0001 000A    buf[0] = reg|(1<<5);
	SBIW R28,2
;	reg -> Y+3
;	Data -> Y+2
;	buf -> Y+0
	LDD  R30,Y+3
	ORI  R30,0x20
	ST   Y,R30
; 0001 000B    buf[1] = Data;
	LDD  R30,Y+2
	STD  Y+1,R30
; 0001 000C    CSN_Enable;
	CBI  0x18,2
; 0001 000D    SPI_Transmit(buf[0]);
	LD   R26,Y
	RCALL _SPI_Transmit
; 0001 000E    SPI_Transmit(buf[1]);
	LDD  R26,Y+1
	RCALL _SPI_Transmit
; 0001 000F    CSN_Disable;
	SBI  0x18,2
; 0001 0010 }
	ADIW R28,2
; 0001 0011 }
_0x20003:
	ADIW R28,2
	RET
; .FEND
;
;void NRF24_WriteMulti_Register(uint8_t reg, uint8_t * Data, uint8_t size)
; 0001 0014 {   uint8_t i;
_NRF24_WriteMulti_Register:
; .FSTART _NRF24_WriteMulti_Register
; 0001 0015     uint8_t buf;
; 0001 0016     buf = reg | (1 << 5);
	ST   -Y,R26
	RCALL __SAVELOCR2
;	reg -> Y+5
;	*Data -> Y+3
;	size -> Y+2
;	i -> R17
;	buf -> R16
	LDD  R30,Y+5
	ORI  R30,0x20
	MOV  R16,R30
; 0001 0017     CSN_Enable;
	CBI  0x18,2
; 0001 0018     SPI_Transmit(buf);
	MOV  R26,R16
	RCALL _SPI_Transmit
; 0001 0019     SPI_TransmitBytes(Data, size);
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	RCALL SUBOPT_0xB
	LDD  R26,Y+4
	CLR  R27
	RCALL _SPI_TransmitBytes
; 0001 001A     CSN_Disable;
	SBI  0x18,2
; 0001 001B }
	RJMP _0x20A000A
; .FEND
;
;uint8_t NRF24_Read_Register(uint8_t reg)
; 0001 001E {
_NRF24_Read_Register:
; .FSTART _NRF24_Read_Register
; 0001 001F if(reg <= 31)
	ST   -Y,R26
;	reg -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x2000C
; 0001 0020 {
; 0001 0021     uint8_t Data = 0;
; 0001 0022     CSN_Enable;
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	reg -> Y+1
;	Data -> Y+0
	CBI  0x18,2
; 0001 0023     SPI_Transmit(reg);
	LDD  R26,Y+1
	RCALL _SPI_Transmit
; 0001 0024     Data = SPI_Receive();
	RCALL _SPI_Receive
	ST   Y,R30
; 0001 0025     CSN_Disable;
	SBI  0x18,2
; 0001 0026     return Data;
	ADIW R28,1
	RJMP _0x20A0008
; 0001 0027 }
; 0001 0028 return 0;
_0x2000C:
	LDI  R30,LOW(0)
	RJMP _0x20A0008
; 0001 0029 }
; .FEND
;
;void NRF24_ReadMulti_Register(uint8_t reg, uint8_t *data, uint8_t size)
; 0001 002C {
; 0001 002D     CSN_Enable;
;	reg -> Y+3
;	*data -> Y+1
;	size -> Y+0
; 0001 002E 
; 0001 002F     SPI_Transmit(reg);
; 0001 0030     SPI_ReceiveBytes(data, size);
; 0001 0031 
; 0001 0032     CSN_Disable;
; 0001 0033 }
;
;
;// send the command to the NRF
;void NRF24_SendCMD(uint8_t cmd)
; 0001 0038 {
_NRF24_SendCMD:
; .FSTART _NRF24_SendCMD
; 0001 0039     CSN_Enable;
	ST   -Y,R26
;	cmd -> Y+0
	CBI  0x18,2
; 0001 003A     SPI_Transmit(cmd);
	LD   R26,Y
	RCALL _SPI_Transmit
; 0001 003B     CSN_Disable;
	SBI  0x18,2
; 0001 003C }
	RJMP _0x20A0008
; .FEND
;//----------------------------------------------------
;
;
;void NRF24L01plus_Init()
; 0001 0041 {
_NRF24L01plus_Init:
; .FSTART _NRF24L01plus_Init
; 0001 0042     uint8_t config;
; 0001 0043     CE_Disable;
	ST   -Y,R17
;	config -> R17
	CBI  0x18,1
; 0001 0044     NRF_RESET(STATUS);
	LDI  R26,LOW(7)
	RCALL _NRF_RESET
; 0001 0045     NRF_RESET(FIFO_STATUS);
	LDI  R26,LOW(23)
	RCALL _NRF_RESET
; 0001 0046 
; 0001 0047 
; 0001 0048     NRF24_Write_Register(CONFIG,0); // will be configured later
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
; 0001 0049     NRF24_Write_Register(SETUP_RETR, 0xFA); // Enable automatic retransmission with maximum delay and retries
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(250)
	RCALL _NRF24_Write_Register
; 0001 004A 
; 0001 004B     NRF24_Write_Register(RF_CH, 9); // will be setup during TX or RX
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(9)
	RCALL SUBOPT_0xF
; 0001 004C     NRF24_Write_Register(SETUP_AW, 0x03);//5byte for  TX/RX Address
; 0001 004D     NRF24_Write_Register(RF_SETUP, 0x0E); // Power = 0db, data rate =  250kbps
	RCALL SUBOPT_0x10
; 0001 004E     NRF24_Write_Register(FEATURE,0x06); //EN_ACK_PAY  ,  EN_DPL
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(6)
	RCALL SUBOPT_0xF
; 0001 004F     NRF24_Write_Register(SETUP_AW, 0x03); // Set address width to 5 bytes
; 0001 0050     config = NRF24_Read_Register(CONFIG);
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x11
; 0001 0051     config = config | (1<<3) | (1 << 2); // CRC ENABLE ,  CRC 2BYTE
	ORI  R17,LOW(12)
; 0001 0052     NRF24_Write_Register(CONFIG, config);
	RCALL SUBOPT_0xD
	MOV  R26,R17
	RCALL _NRF24_Write_Register
; 0001 0053 
; 0001 0054     CE_Enable;
	SBI  0x18,1
; 0001 0055 }
	LD   R17,Y+
	RET
; .FEND
;/*----------------------------------------------*/
;/*-----------------TxMode-----------------------*/
;void NRF24_TXMode( uint8_t const* Address, uint8_t channel)
; 0001 0059  {
; 0001 005A     uint8_t config = 0;
; 0001 005B     uint8_t dynpd = 0;
; 0001 005C     CE_Disable;
;	*Address -> Y+3
;	channel -> Y+2
;	config -> R17
;	dynpd -> R16
; 0001 005D 
; 0001 005E     NRF24_Write_Register(RF_CH, channel); // select the channel
; 0001 005F 
; 0001 0060     NRF24_WriteMulti_Register(TX_ADDR, Address, 5); // Write the TX address
; 0001 0061 
; 0001 0062     // power up the device
; 0001 0063     config = NRF24_Read_Register(CONFIG);
; 0001 0064     config = config | (1<<1) | (0 << 0);
; 0001 0065     NRF24_Write_Register(CONFIG, config);
; 0001 0066 
; 0001 0067     // Enable Enhanced ShockBurst
; 0001 0068     NRF24_Write_Register(EN_AA, 0x01); // Enable Auto ACK on pipe 0
; 0001 0069     NRF24_Write_Register(EN_RXADDR, 0x01); // Enable data pipe 0
; 0001 006A     NRF24_Write_Register(DYNPD, 0x01); //Enable DPL  PIPE 0
; 0001 006B     NRF24_WriteMulti_Register(RX_ADDR_P0, Address, 5); //Write the TX address
; 0001 006C 
; 0001 006D 
; 0001 006E 
; 0001 006F 
; 0001 0070 
; 0001 0071     CE_Enable;
; 0001 0072  }
;
;
;uint8_t NRF24_Transmit(uint8_t * data , uint8_t length)
; 0001 0076  {
; 0001 0077 
; 0001 0078     uint8_t counter = 0;
; 0001 0079     uint8_t cmdtosend = 0;
; 0001 007A     uint8_t fifostatus = 0;
; 0001 007B     //Select the device
; 0001 007C 
; 0001 007D   CSN_Enable;
;	*data -> Y+5
;	length -> Y+4
;	counter -> R17
;	cmdtosend -> R16
;	fifostatus -> R19
; 0001 007E     cmdtosend = W_TX_PAYLOAD;
; 0001 007F     SPI_Transmit(cmdtosend);
; 0001 0080     SPI_TransmitBytes(data,length);
; 0001 0081   CSN_Disable;
; 0001 0082 
; 0001 0083  // delay_ms(2);
; 0001 0084 
; 0001 0085 
; 0001 0086    fifostatus = NRF24_Read_Register(FIFO_STATUS);
; 0001 0087     if ((fifostatus&(1<<4)) && (!(fifostatus&(1<<3))))
; 0001 0088     {
; 0001 0089 
; 0001 008A         cmdtosend = FLUSH_TX;
; 0001 008B         NRF24_SendCMD(cmdtosend);
; 0001 008C         NRF_RESET(FIFO_STATUS);
; 0001 008D         NRF_RESET(STATUS);
; 0001 008E         return 1;
; 0001 008F     }
; 0001 0090     ++counter;
; 0001 0091     if(counter == 15)
; 0001 0092     {
; 0001 0093     counter = 0;
; 0001 0094         NRF_RESET(FIFO_STATUS);
; 0001 0095         NRF_RESET(STATUS);
; 0001 0096     }
; 0001 0097  }
;
;
;void NRF24_RxMode (uint8_t *Address, uint8_t channel)
; 0001 009B  {
_NRF24_RxMode:
; .FSTART _NRF24_RxMode
; 0001 009C     uint8_t en_rxaddr;
; 0001 009D     uint8_t en_aa;
; 0001 009E     uint8_t config;
; 0001 009F     //Disable the chip before configuring the device
; 0001 00A0     CE_Disable;
	ST   -Y,R26
	RCALL __SAVELOCR4
;	*Address -> Y+5
;	channel -> Y+4
;	en_rxaddr -> R17
;	en_aa -> R16
;	config -> R19
	CBI  0x18,1
; 0001 00A1 
; 0001 00A2    // NRF24_Write_Register(RF_CH, channel); // select the channel
; 0001 00A3 
; 0001 00A4     en_rxaddr = NRF24_Read_Register(EN_RXADDR);
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x11
; 0001 00A5     en_rxaddr = en_rxaddr | (1 << 1);
	ORI  R17,LOW(2)
; 0001 00A6     NRF24_Write_Register(EN_RXADDR, en_rxaddr); // enable data pipe 1
	LDI  R30,LOW(2)
	ST   -Y,R30
	MOV  R26,R17
	RCALL _NRF24_Write_Register
; 0001 00A7     en_aa = NRF24_Read_Register(EN_AA);
	LDI  R26,LOW(1)
	RCALL _NRF24_Read_Register
	MOV  R16,R30
; 0001 00A8     en_aa = en_aa | (1 << 1);
	ORI  R16,LOW(2)
; 0001 00A9     NRF24_Write_Register(EN_AA, en_aa); // enable auto acknowledgment for data pipe 1
	LDI  R30,LOW(1)
	ST   -Y,R30
	MOV  R26,R16
	RCALL _NRF24_Write_Register
; 0001 00AA 
; 0001 00AB     NRF24_WriteMulti_Register(RX_ADDR_P1, Address, 5); // Write the RX address for data pipe 1
	LDI  R30,LOW(11)
	ST   -Y,R30
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
; 0001 00AC     NRF24_Write_Register(DYNPD, 0x02); // DPL for PIPE 1
	LDI  R30,LOW(28)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _NRF24_Write_Register
; 0001 00AD 
; 0001 00AE     // power up the device and enable Enhanced ShockBurst
; 0001 00AF     config = NRF24_Read_Register(CONFIG);
	LDI  R26,LOW(0)
	RCALL _NRF24_Read_Register
	MOV  R19,R30
; 0001 00B0     config = config | (1 << 1) | (1 << 0);
	ORI  R19,LOW(3)
; 0001 00B1     NRF24_Write_Register(CONFIG, config);
	RCALL SUBOPT_0xD
	MOV  R26,R19
	RCALL _NRF24_Write_Register
; 0001 00B2 
; 0001 00B3     // Enable the chip after configuring the device
; 0001 00B4     CE_Enable;
	SBI  0x18,1
; 0001 00B5 
; 0001 00B6  }
	RCALL __LOADLOCR4
	ADIW R28,7
	RET
; .FEND
;
;void nrf24_write_ack(void)
; 0001 00B9 {
_nrf24_write_ack:
; .FSTART _nrf24_write_ack
; 0001 00BA 	const uint8_t *ack = "A";
; 0001 00BB 	unsigned int length = 1;
; 0001 00BC 	CSN_Enable;
	RCALL __SAVELOCR4
;	*ack -> R16,R17
;	length -> R18,R19
	__POINTWRMN 16,17,_0x2002D,0
	__GETWRN 18,19,1
	CBI  0x18,2
; 0001 00BD 	SPI_Transmit(W_ACK_PAYLOAD);
	LDI  R26,LOW(168)
	RCALL _SPI_Transmit
; 0001 00BE 	while (length--) SPI_Transmit(*(uint8_t *)ack++);
_0x20030:
	MOVW R30,R18
	__SUBWRN 18,19,1
	SBIW R30,0
	BREQ _0x20032
	MOVW R26,R16
	RCALL SUBOPT_0xA
	LD   R26,X
	RCALL _SPI_Transmit
	RJMP _0x20030
_0x20032:
; 0001 00BF PORTB.2 = 1;;
	SBI  0x18,2
; 0001 00C0       delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0001 00C1       PORTC.5 = 0;
	CBI  0x15,5
; 0001 00C2       PORTC.4 = 1;
	SBI  0x15,4
; 0001 00C3       delay_ms(300);
	RCALL SUBOPT_0x3
; 0001 00C4       PORTC.5 = 1;
	SBI  0x15,5
; 0001 00C5 
; 0001 00C6 }
	RCALL __LOADLOCR4
	RJMP _0x20A0003
; .FEND

	.DSEG
_0x2002D:
	.BYTE 0x2
;
;
;uint8_t isDataAvailable(int pipenum)
; 0001 00CA {

	.CSEG
_isDataAvailable:
; .FSTART _isDataAvailable
; 0001 00CB 
; 0001 00CC     uint8_t status;
; 0001 00CD     status = NRF24_Read_Register(STATUS);
	RCALL SUBOPT_0x14
	ST   -Y,R17
;	pipenum -> Y+1
;	status -> R17
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x11
; 0001 00CE     if((status&(1<<6))&&(status&(pipenum<<1)))
	SBRS R17,6
	RJMP _0x2003C
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LSL  R30
	ROL  R31
	MOV  R26,R17
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x2003D
_0x2003C:
	RJMP _0x2003B
_0x2003D:
; 0001 00CF     {
; 0001 00D0         PORTC.5 = 1;
	SBI  0x15,5
; 0001 00D1         PORTC.4 = 0;
	CBI  0x15,4
; 0001 00D2        NRF24_Write_Register(STATUS,status);
	LDI  R30,LOW(7)
	ST   -Y,R30
	MOV  R26,R17
	RCALL _NRF24_Write_Register
; 0001 00D3        return 1;
	LDI  R30,LOW(1)
	RJMP _0x20A000B
; 0001 00D4     }
; 0001 00D5     return 0;
_0x2003B:
	LDI  R30,LOW(0)
_0x20A000B:
	LDD  R17,Y+0
	ADIW R28,3
	RET
; 0001 00D6 
; 0001 00D7 }
; .FEND
;
;void NRF24_Recive(uint8_t *data)
; 0001 00DA {
_NRF24_Recive:
; .FSTART _NRF24_Recive
; 0001 00DB 
; 0001 00DC 
; 0001 00DD  uint8_t cmdtosend = 0;
; 0001 00DE  uint8_t length = 0;
; 0001 00DF  uint8_t counter = 0;
; 0001 00E0  uint8_t i;
; 0001 00E1  // select the device
; 0001 00E2  CSN_Enable;
	RCALL SUBOPT_0x14
	RCALL __SAVELOCR4
;	*data -> Y+4
;	cmdtosend -> R17
;	length -> R16
;	counter -> R19
;	i -> R18
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	CBI  0x18,2
; 0001 00E3  cmdtosend = R_RX_PL_WID;
	LDI  R17,LOW(96)
; 0001 00E4  SPI_Transmit(cmdtosend);
	MOV  R26,R17
	RCALL _SPI_Transmit
; 0001 00E5  length = SPI_Receive();
	RCALL _SPI_Receive
	MOV  R16,R30
; 0001 00E6  CSN_Disable;
	SBI  0x18,2
; 0001 00E7 
; 0001 00E8  CSN_Enable;
	CBI  0x18,2
; 0001 00E9  cmdtosend = R_RX_PAYLOAD;
	LDI  R17,LOW(97)
; 0001 00EA  SPI_Transmit(cmdtosend);
	MOV  R26,R17
	RCALL _SPI_Transmit
; 0001 00EB  SPI_ReceiveBytes(data,length);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0xB
	MOV  R26,R16
	CLR  R27
	RCALL _SPI_ReceiveBytes
; 0001 00EC  //UART_SendString(data,32);
; 0001 00ED 
; 0001 00EE // Unselect the device
; 0001 00EF 
; 0001 00F0  CSN_Disable;
	SBI  0x18,2
; 0001 00F1  cmdtosend = FLUSH_RX;
	LDI  R17,LOW(226)
; 0001 00F2  NRF24_SendCMD(cmdtosend);
	MOV  R26,R17
	RCALL _NRF24_SendCMD
; 0001 00F3 
; 0001 00F4 }
	RCALL __LOADLOCR4
	RJMP _0x20A0009
; .FEND
;
;void NRF_RESET(uint8_t REG)
; 0001 00F7 {
_NRF_RESET:
; .FSTART _NRF_RESET
; 0001 00F8 uint8_t rx_addr_p0_def[5]= {0xE7, 0xE7, 0xE7, 0xE7, 0xE7};
; 0001 00F9 uint8_t rx_addr_p1_def[5]=  {0xC2, 0xC2, 0xC2, 0xC2, 0xC2};
; 0001 00FA uint8_t tx_addr_def[5] = {0xE7, 0xE7, 0xE7, 0xE7, 0xE7};
; 0001 00FB uint8_t status;
; 0001 00FC     if (REG == STATUS)
	ST   -Y,R26
	SBIW R28,15
	LDI  R24,15
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2004A*2)
	LDI  R31,HIGH(_0x2004A*2)
	RCALL __INITLOCB
	ST   -Y,R17
;	REG -> Y+16
;	rx_addr_p0_def -> Y+11
;	rx_addr_p1_def -> Y+6
;	tx_addr_def -> Y+1
;	status -> R17
	LDD  R26,Y+16
	CPI  R26,LOW(0x7)
	BRNE _0x2004B
; 0001 00FD     {
; 0001 00FE      status = NRF24_Read_Register(STATUS);
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x11
; 0001 00FF      status = status | (1 << 4) | (1 << 5) | (1 << 6);
	ORI  R17,LOW(112)
; 0001 0100      NRF24_Write_Register(STATUS, status);
	LDI  R30,LOW(7)
	ST   -Y,R30
	MOV  R26,R17
	RJMP _0x2004F
; 0001 0101     }
; 0001 0102     else if (REG == FIFO_STATUS)
_0x2004B:
	LDD  R26,Y+16
	CPI  R26,LOW(0x17)
	BRNE _0x2004D
; 0001 0103     {
; 0001 0104         NRF24_Write_Register(FIFO_STATUS, 0x11);
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(17)
	RJMP _0x2004F
; 0001 0105     }
; 0001 0106     else {
_0x2004D:
; 0001 0107         NRF24_Write_Register(CONFIG, 0x08);
	RCALL SUBOPT_0xD
	LDI  R26,LOW(8)
	RCALL _NRF24_Write_Register
; 0001 0108         NRF24_Write_Register(EN_AA, 0x3F);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(63)
	RCALL _NRF24_Write_Register
; 0001 0109         NRF24_Write_Register(EN_RXADDR, 0x03);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL SUBOPT_0xF
; 0001 010A         NRF24_Write_Register(SETUP_AW, 0x03);
; 0001 010B         NRF24_Write_Register(SETUP_RETR, 0x03);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _NRF24_Write_Register
; 0001 010C         NRF24_Write_Register(RF_CH, 0x02);
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _NRF24_Write_Register
; 0001 010D         NRF24_Write_Register(RF_SETUP, 0x0E);
	RCALL SUBOPT_0x10
; 0001 010E         NRF24_Write_Register(STATUS, 0x00);
	LDI  R30,LOW(7)
	RCALL SUBOPT_0x15
; 0001 010F         NRF24_Write_Register(OBSERVE_TX, 0x00);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x15
; 0001 0110         NRF24_Write_Register(CD, 0x00);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x15
; 0001 0111         NRF24_WriteMulti_Register(RX_ADDR_P0, rx_addr_p0_def, 5);
	LDI  R30,LOW(10)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,12
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x13
; 0001 0112         NRF24_WriteMulti_Register(RX_ADDR_P1, rx_addr_p1_def, 5);
	LDI  R30,LOW(11)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x13
; 0001 0113         NRF24_Write_Register(RX_ADDR_P2, 0xC3);
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(195)
	RCALL _NRF24_Write_Register
; 0001 0114         NRF24_Write_Register(RX_ADDR_P3, 0xC4);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(196)
	RCALL _NRF24_Write_Register
; 0001 0115         NRF24_Write_Register(RX_ADDR_P4, 0xC5);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(197)
	RCALL _NRF24_Write_Register
; 0001 0116         NRF24_Write_Register(RX_ADDR_P5, 0xC6);
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R26,LOW(198)
	RCALL _NRF24_Write_Register
; 0001 0117         NRF24_WriteMulti_Register(TX_ADDR, tx_addr_def, 5);
	LDI  R30,LOW(16)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x13
; 0001 0118         NRF24_Write_Register(RX_PW_P0, 0);
	LDI  R30,LOW(17)
	RCALL SUBOPT_0x15
; 0001 0119         NRF24_Write_Register(RX_PW_P1, 0);
	LDI  R30,LOW(18)
	RCALL SUBOPT_0x15
; 0001 011A         NRF24_Write_Register(RX_PW_P2, 0);
	LDI  R30,LOW(19)
	RCALL SUBOPT_0x15
; 0001 011B         NRF24_Write_Register(RX_PW_P3, 0);
	LDI  R30,LOW(20)
	RCALL SUBOPT_0x15
; 0001 011C         NRF24_Write_Register(RX_PW_P4, 0);
	LDI  R30,LOW(21)
	RCALL SUBOPT_0x15
; 0001 011D         NRF24_Write_Register(RX_PW_P5, 0);
	LDI  R30,LOW(22)
	RCALL SUBOPT_0x15
; 0001 011E         NRF24_Write_Register(FIFO_STATUS, 0x11);
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(17)
	RCALL _NRF24_Write_Register
; 0001 011F         NRF24_Write_Register(DYNPD, 0);
	LDI  R30,LOW(28)
	RCALL SUBOPT_0x15
; 0001 0120         NRF24_Write_Register(FEATURE, 0);
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(0)
_0x2004F:
	RCALL _NRF24_Write_Register
; 0001 0121     }
; 0001 0122 }
	LDD  R17,Y+0
	ADIW R28,17
	RET
; .FEND
;
;#include "spi.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;// Function to initialize SPI
;
;// Function to send data over SPI
;void SPI_Transmit(uint8_t data)
; 0002 0008 {

	.CSEG
_SPI_Transmit:
; .FSTART _SPI_Transmit
; 0002 0009     // Start transmission
; 0002 000A     SPDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0002 000B     // Wait for transmission to complete
; 0002 000C     while (!(SPSR & (1 << SPIF)));
_0x40003:
	SBIS 0xE,7
	RJMP _0x40003
; 0002 000D }
	RJMP _0x20A0008
; .FEND
;
;// Function to send multiple bytes over SPI
;void SPI_TransmitBytes(const uint8_t* data, uint16_t length)
; 0002 0011 {      uint8_t i;
_SPI_TransmitBytes:
; .FSTART _SPI_TransmitBytes
; 0002 0012 
; 0002 0013     for (i = 0; i < length; i++) {
	RCALL SUBOPT_0x14
	ST   -Y,R17
;	*data -> Y+3
;	length -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x40007:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x40008
; 0002 0014 
; 0002 0015         SPDR = data[i];
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	OUT  0xF,R30
; 0002 0016 
; 0002 0017         while (!(SPSR & (1 << SPIF)));
_0x40009:
	SBIS 0xE,7
	RJMP _0x40009
; 0002 0018     }
	SUBI R17,-1
	RJMP _0x40007
_0x40008:
; 0002 0019 
; 0002 001A }
	LDD  R17,Y+0
	RJMP _0x20A0007
; .FEND
;
;// Function to receive data over SPI (single byte)
;uint8_t SPI_Receive()
; 0002 001E {
_SPI_Receive:
; .FSTART _SPI_Receive
; 0002 001F     // Send dummy data to initiate data exchange
; 0002 0020     SPI_Transmit(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_Transmit
; 0002 0021     // Wait for reception to complete
; 0002 0022     while (!(SPSR & (1 << SPIF)));
_0x4000C:
	SBIS 0xE,7
	RJMP _0x4000C
; 0002 0023     // Return received data
; 0002 0024     return SPDR;
	IN   R30,0xF
	RET
; 0002 0025 }
; .FEND
;
;// Function to receive multiple bytes over SPI
;void SPI_ReceiveBytes(uint8_t* buffer, uint16_t length)
; 0002 0029 {
_SPI_ReceiveBytes:
; .FSTART _SPI_ReceiveBytes
; 0002 002A     uint16_t i;
; 0002 002B     for (i = 0; i < length; i++)
	RCALL SUBOPT_0x14
	RCALL __SAVELOCR2
;	*buffer -> Y+4
;	length -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x8
_0x40010:
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CP   R16,R30
	CPC  R17,R31
	BRSH _0x40011
; 0002 002C     {
; 0002 002D         buffer[i] = SPI_Receive();
	MOVW R30,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _SPI_Receive
	POP  R26
	POP  R27
	ST   X,R30
; 0002 002E     }
	RCALL SUBOPT_0xA
	RJMP _0x40010
_0x40011:
; 0002 002F }
_0x20A000A:
	RCALL __LOADLOCR2
_0x20A0009:
	ADIW R28,6
	RET
; .FEND
;void SPI_ReceiveBytes2(uint8_t* buffer)
; 0002 0031 {
; 0002 0032     uint16_t i;
; 0002 0033     for (i = 0; i < strlen(buffer); i++)
;	*buffer -> Y+2
;	i -> R16,R17
; 0002 0034     {
; 0002 0035         buffer[i] = SPI_Receive();
; 0002 0036     }
; 0002 0037 }
;#include "uart.h"
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;unsigned char UART_RxChar()
; 0003 0004 {

	.CSEG
; 0003 0005     while ((UCSRA & (1 << RXC)) == 0);/* Wait till data is received */
; 0003 0006     return(UDR);            /* Return the byte*/
; 0003 0007 }
;
;void UART_TxChar(uint8_t ch)
; 0003 000A {
_UART_TxChar:
; .FSTART _UART_TxChar
; 0003 000B 	while (! (UCSRA & (1<<UDRE)));  /* Wait for empty transmit buffer */
	ST   -Y,R26
;	ch -> Y+0
_0x60006:
	SBIS 0xB,5
	RJMP _0x60006
; 0003 000C 	UDR = ch ;
	LD   R30,Y
	OUT  0xC,R30
; 0003 000D }
_0x20A0008:
	ADIW R28,1
	RET
; .FEND
;
;void UART_SendString(uint8_t *str, uint8_t length)
; 0003 0010 {
_UART_SendString:
; .FSTART _UART_SendString
; 0003 0011 int i;
; 0003 0012 for(i = 0; i< length;++i)
	ST   -Y,R26
	RCALL __SAVELOCR2
;	*str -> Y+3
;	length -> Y+2
;	i -> R16,R17
	RCALL SUBOPT_0x8
_0x6000A:
	LDD  R30,Y+2
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x6000B
; 0003 0013 {
; 0003 0014     UART_TxChar(str[i]);
	MOVW R30,R16
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R26,X
	RCALL _UART_TxChar
; 0003 0015 }
	RCALL SUBOPT_0xA
	RJMP _0x6000A
_0x6000B:
; 0003 0016 }
	RJMP _0x20A0006
; .FEND
;
;void UART_SendString2(char *str)
; 0003 0019 {
; 0003 001A 	unsigned char j=0;
; 0003 001B 
; 0003 001C 	while (str[j]!=0)		/* Send string till null */
;	*str -> Y+1
;	j -> R17
; 0003 001D 	{
; 0003 001E 		UART_TxChar(str[j]);
; 0003 001F 		j++;
; 0003 0020 	}
; 0003 0021 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	RCALL SUBOPT_0x14
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x16
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	RCALL SUBOPT_0x16
	ADIW R26,2
	RCALL SUBOPT_0x18
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000013:
	RCALL SUBOPT_0x16
	RCALL __GETW1P
	TST  R31
	BRMI _0x2000014
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x18
_0x2000014:
	RJMP _0x2000015
_0x2000010:
	RCALL SUBOPT_0x16
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
_0x20A0006:
	RCALL __LOADLOCR2
_0x20A0007:
	ADIW R28,5
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	RCALL SUBOPT_0x19
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2000019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RCALL SUBOPT_0xB
	__POINTW2FN _0x2000000,0
	RCALL _strcpyf
	RJMP _0x20A0005
_0x2000019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2000018
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0xB
	__POINTW2FN _0x2000000,1
	RCALL _strcpyf
	RJMP _0x20A0005
_0x2000018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x200001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x200001B:
	LDD  R17,Y+11
_0x200001C:
	RCALL SUBOPT_0x1B
	BREQ _0x200001E
	RCALL SUBOPT_0x1C
	RJMP _0x200001C
_0x200001E:
	RCALL SUBOPT_0x1D
	RCALL __CPD10
	BRNE _0x200001F
	LDI  R19,LOW(0)
	RCALL SUBOPT_0x1C
	RJMP _0x2000020
_0x200001F:
	LDD  R19,Y+11
	RCALL SUBOPT_0x1E
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000021
	RCALL SUBOPT_0x1C
_0x2000022:
	RCALL SUBOPT_0x1E
	BRLO _0x2000024
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RJMP _0x2000022
_0x2000024:
	RJMP _0x2000025
_0x2000021:
_0x2000026:
	RCALL SUBOPT_0x1E
	BRSH _0x2000028
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x22
	SUBI R19,LOW(1)
	RJMP _0x2000026
_0x2000028:
	RCALL SUBOPT_0x1C
_0x2000025:
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1E
	BRLO _0x2000029
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
_0x2000029:
_0x2000020:
	LDI  R17,LOW(0)
_0x200002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x200002C
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0xC
	RCALL _floor
	__PUTD1S 4
	RCALL SUBOPT_0x1F
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x26
	RCALL SUBOPT_0x27
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x24
	RCALL __MULF12
	RCALL SUBOPT_0x1F
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x22
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x200002A
	RCALL SUBOPT_0x26
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x200002A
_0x200002C:
	RCALL SUBOPT_0x28
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x200002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000113
_0x200002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000113:
	ST   X,R30
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	RCALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0005:
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0x14
	SBIW R28,63
	SBIW R28,17
	RCALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	RCALL SUBOPT_0x18
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000036
	CPI  R18,37
	BRNE _0x2000037
	LDI  R17,LOW(1)
	RJMP _0x2000038
_0x2000037:
	RCALL SUBOPT_0x2B
_0x2000038:
	RJMP _0x2000035
_0x2000036:
	CPI  R30,LOW(0x1)
	BRNE _0x2000039
	CPI  R18,37
	BRNE _0x200003A
	RCALL SUBOPT_0x2B
	RJMP _0x2000114
_0x200003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x200003B
	LDI  R16,LOW(1)
	RJMP _0x2000035
_0x200003B:
	CPI  R18,43
	BRNE _0x200003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003C:
	CPI  R18,32
	BRNE _0x200003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2000035
_0x200003D:
	RJMP _0x200003E
_0x2000039:
	CPI  R30,LOW(0x2)
	BRNE _0x200003F
_0x200003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000040
	ORI  R16,LOW(128)
	RJMP _0x2000035
_0x2000040:
	RJMP _0x2000041
_0x200003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2000042
_0x2000041:
	CPI  R18,48
	BRLO _0x2000044
	CPI  R18,58
	BRLO _0x2000045
_0x2000044:
	RJMP _0x2000043
_0x2000045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000035
_0x2000043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2000046
	LDI  R17,LOW(4)
	RJMP _0x2000035
_0x2000046:
	RJMP _0x2000047
_0x2000042:
	CPI  R30,LOW(0x4)
	BRNE _0x2000049
	CPI  R18,48
	BRLO _0x200004B
	CPI  R18,58
	BRLO _0x200004C
_0x200004B:
	RJMP _0x200004A
_0x200004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2000035
_0x200004A:
_0x2000047:
	CPI  R18,108
	BRNE _0x200004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2000035
_0x200004D:
	RJMP _0x200004E
_0x2000049:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x2000035
_0x200004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000053
	RCALL SUBOPT_0x2C
	RCALL SUBOPT_0x2D
	RCALL SUBOPT_0x2C
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x2E
	RJMP _0x2000054
_0x2000053:
	CPI  R30,LOW(0x45)
	BREQ _0x2000057
	CPI  R30,LOW(0x65)
	BRNE _0x2000058
_0x2000057:
	RJMP _0x2000059
_0x2000058:
	CPI  R30,LOW(0x66)
	BRNE _0x200005A
_0x2000059:
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x30
	RCALL __GETD1P
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x32
	LDD  R26,Y+13
	TST  R26
	BRMI _0x200005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x200005D
	CPI  R26,LOW(0x20)
	BREQ _0x200005F
	RJMP _0x2000060
_0x200005B:
	RCALL SUBOPT_0x33
	RCALL __ANEGF1
	RCALL SUBOPT_0x31
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200005D:
	SBRS R16,7
	RJMP _0x2000061
	LDD  R30,Y+21
	ST   -Y,R30
	RCALL SUBOPT_0x2E
	RJMP _0x2000062
_0x2000061:
_0x200005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	RCALL SUBOPT_0x34
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000062:
_0x2000060:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2000064
	RCALL SUBOPT_0x33
	RCALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	RCALL _ftoa
	RJMP _0x2000065
_0x2000064:
	RCALL SUBOPT_0x33
	RCALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x2000065:
	RCALL SUBOPT_0x2F
	RCALL SUBOPT_0x35
	RJMP _0x2000066
_0x200005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2000068
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x34
	RCALL SUBOPT_0x35
	RJMP _0x2000069
_0x2000068:
	CPI  R30,LOW(0x70)
	BRNE _0x200006B
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x34
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000069:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x200006D
	CP   R20,R17
	BRLO _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	MOV  R17,R20
_0x200006C:
_0x2000066:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x200006F
_0x200006B:
	CPI  R30,LOW(0x64)
	BREQ _0x2000072
	CPI  R30,LOW(0x69)
	BRNE _0x2000073
_0x2000072:
	ORI  R16,LOW(4)
	RJMP _0x2000074
_0x2000073:
	CPI  R30,LOW(0x75)
	BRNE _0x2000075
_0x2000074:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000076
	__GETD1N 0x3B9ACA00
	RCALL SUBOPT_0x37
	LDI  R17,LOW(10)
	RJMP _0x2000077
_0x2000076:
	__GETD1N 0x2710
	RCALL SUBOPT_0x37
	LDI  R17,LOW(5)
	RJMP _0x2000077
_0x2000075:
	CPI  R30,LOW(0x58)
	BRNE _0x2000079
	ORI  R16,LOW(8)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000B8
_0x200007A:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x10000000
	RCALL SUBOPT_0x37
	LDI  R17,LOW(8)
	RJMP _0x2000077
_0x200007C:
	__GETD1N 0x1000
	RCALL SUBOPT_0x37
	LDI  R17,LOW(4)
_0x2000077:
	CPI  R20,0
	BREQ _0x200007D
	ANDI R16,LOW(127)
	RJMP _0x200007E
_0x200007D:
	LDI  R20,LOW(1)
_0x200007E:
	SBRS R16,1
	RJMP _0x200007F
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x30
	ADIW R26,4
	RCALL __GETD1P
	RJMP _0x2000115
_0x200007F:
	SBRS R16,2
	RJMP _0x2000081
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x36
	RCALL __CWD1
	RJMP _0x2000115
_0x2000081:
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x36
	CLR  R22
	CLR  R23
_0x2000115:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000083
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2000084
	RCALL SUBOPT_0x33
	RCALL __ANEGD1
	RCALL SUBOPT_0x31
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000084:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2000085
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2000086
_0x2000085:
	ANDI R16,LOW(251)
_0x2000086:
_0x2000083:
	MOV  R19,R20
_0x200006F:
	SBRC R16,0
	RJMP _0x2000087
_0x2000088:
	CP   R17,R21
	BRSH _0x200008B
	CP   R19,R21
	BRLO _0x200008C
_0x200008B:
	RJMP _0x200008A
_0x200008C:
	SBRS R16,7
	RJMP _0x200008D
	SBRS R16,2
	RJMP _0x200008E
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x200008F
_0x200008E:
	LDI  R18,LOW(48)
_0x200008F:
	RJMP _0x2000090
_0x200008D:
	LDI  R18,LOW(32)
_0x2000090:
	RCALL SUBOPT_0x2B
	SUBI R21,LOW(1)
	RJMP _0x2000088
_0x200008A:
_0x2000087:
_0x2000091:
	CP   R17,R20
	BRSH _0x2000093
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000094
	RCALL SUBOPT_0x38
	BREQ _0x2000095
	SUBI R21,LOW(1)
_0x2000095:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2000094:
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL SUBOPT_0x2E
	CPI  R21,0
	BREQ _0x2000096
	SUBI R21,LOW(1)
_0x2000096:
	SUBI R20,LOW(1)
	RJMP _0x2000091
_0x2000093:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2000097
_0x2000098:
	CPI  R19,0
	BREQ _0x200009A
	SBRS R16,3
	RJMP _0x200009B
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	RCALL SUBOPT_0x34
	RJMP _0x200009C
_0x200009B:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x200009C:
	RCALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x200009D
	SUBI R21,LOW(1)
_0x200009D:
	SUBI R19,LOW(1)
	RJMP _0x2000098
_0x200009A:
	RJMP _0x200009E
_0x2000097:
_0x20000A0:
	RCALL SUBOPT_0x39
	RCALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A2
	SBRS R16,3
	RJMP _0x20000A3
	SUBI R18,-LOW(55)
	RJMP _0x20000A4
_0x20000A3:
	SUBI R18,-LOW(87)
_0x20000A4:
	RJMP _0x20000A5
_0x20000A2:
	SUBI R18,-LOW(48)
_0x20000A5:
	SBRC R16,4
	RJMP _0x20000A7
	CPI  R18,49
	BRSH _0x20000A9
	RCALL SUBOPT_0x3A
	__CPD2N 0x1
	BRNE _0x20000A8
_0x20000A9:
	RJMP _0x20000AB
_0x20000A8:
	CP   R20,R19
	BRSH _0x2000116
	CP   R21,R19
	BRLO _0x20000AE
	SBRS R16,0
	RJMP _0x20000AF
_0x20000AE:
	RJMP _0x20000AD
_0x20000AF:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B0
_0x2000116:
	LDI  R18,LOW(48)
_0x20000AB:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B1
	RCALL SUBOPT_0x38
	BREQ _0x20000B2
	SUBI R21,LOW(1)
_0x20000B2:
_0x20000B1:
_0x20000B0:
_0x20000A7:
	RCALL SUBOPT_0x2B
	CPI  R21,0
	BREQ _0x20000B3
	SUBI R21,LOW(1)
_0x20000B3:
_0x20000AD:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x39
	RCALL __MODD21U
	RCALL SUBOPT_0x31
	LDD  R30,Y+20
	RCALL SUBOPT_0x3A
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __DIVD21U
	RCALL SUBOPT_0x37
	__GETD1S 16
	RCALL __CPD10
	BREQ _0x20000A1
	RJMP _0x20000A0
_0x20000A1:
_0x200009E:
	SBRS R16,0
	RJMP _0x20000B4
_0x20000B5:
	CPI  R21,0
	BREQ _0x20000B7
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x2E
	RJMP _0x20000B5
_0x20000B7:
_0x20000B4:
_0x20000B8:
_0x2000054:
_0x2000114:
	LDI  R17,LOW(0)
_0x2000035:
	RJMP _0x2000030
_0x2000032:
	RCALL SUBOPT_0x2A
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x3B
	SBIW R30,0
	BRNE _0x20000B9
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0004
_0x20000B9:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x3B
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0xB
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0xB
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	RCALL SUBOPT_0x2A
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0004:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	RCALL SUBOPT_0x14
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0x14
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0x14
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.CSEG

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	RCALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	RCALL SUBOPT_0x1
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x3C
	RJMP _0x20A0003
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x3C
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20A0003:
	ADIW R28,4
	RET
; .FEND

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x19
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x208000D
	RCALL SUBOPT_0x12
	__POINTW2FN _0x2080000,0
	RCALL _strcpyf
	RJMP _0x20A0002
_0x208000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x208000C
	RCALL SUBOPT_0x12
	__POINTW2FN _0x2080000,1
	RCALL _strcpyf
	RJMP _0x20A0002
_0x208000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x208000F
	RCALL SUBOPT_0x3D
	RCALL __ANEGF1
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3F
	LDI  R30,LOW(45)
	ST   X,R30
_0x208000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2080010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2080010:
	LDD  R17,Y+8
_0x2080011:
	RCALL SUBOPT_0x1B
	BREQ _0x2080013
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x41
	RJMP _0x2080011
_0x2080013:
	RCALL SUBOPT_0x42
	RCALL __ADDF12
	RCALL SUBOPT_0x3E
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x41
_0x2080014:
	RCALL SUBOPT_0x42
	RCALL __CMPF12
	BRLO _0x2080016
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x41
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2080017
	RCALL SUBOPT_0x12
	__POINTW2FN _0x2080000,5
	RCALL _strcpyf
	RJMP _0x20A0002
_0x2080017:
	RJMP _0x2080014
_0x2080016:
	CPI  R17,0
	BRNE _0x2080018
	RCALL SUBOPT_0x3F
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2080019
_0x2080018:
_0x208001A:
	RCALL SUBOPT_0x1B
	BREQ _0x208001C
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0xC
	RCALL _floor
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x42
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x27
	LDI  R31,0
	RCALL SUBOPT_0x40
	RCALL __CWD1
	RCALL __CDF1
	RCALL __MULF12
	RCALL SUBOPT_0x43
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x3E
	RJMP _0x208001A
_0x208001C:
_0x2080019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0001
	RCALL SUBOPT_0x3F
	LDI  R30,LOW(46)
	ST   X,R30
_0x208001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2080020
	RCALL SUBOPT_0x43
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x3D
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x27
	LDI  R31,0
	RCALL SUBOPT_0x43
	RCALL __CWD1
	RCALL __CDF1
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x3E
	RJMP _0x208001E
_0x2080020:
_0x20A0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0002:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
_str:
	.BYTE 0x14
_voltage_battery:
	.BYTE 0x4
_RXData:
	.BYTE 0x20
_RxAddress:
	.BYTE 0x1
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(_str)
	LDI  R31,HIGH(_str)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	RCALL __PUTPARD2
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	__GETD1N 0x40528F5C
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4:
	RCALL __GETD2S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5:
	RCALL SUBOPT_0x4
	__GETD1N 0x405AE148
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x4
	__GETD1N 0x406CCCCD
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x7:
	STS  _RxAddress,R30
	LDI  R30,LOW(221)
	__PUTB1MN _RxAddress,1
	LDI  R30,LOW(204)
	__PUTB1MN _RxAddress,2
	LDI  R30,LOW(187)
	__PUTB1MN _RxAddress,3
	LDI  R30,LOW(203)
	__PUTB1MN _RxAddress,4
	LDI  R30,LOW(5)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,4
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(0)
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	RCALL _NRF24_Write_Register
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(14)
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	RCALL _NRF24_Read_Register
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(5)
	RJMP _NRF24_WriteMulti_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x14:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x18:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0x14
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x1C:
	__GETD2S 4
	__GETD1N 0x41200000
	RCALL __MULF12
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	__GETD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x1E:
	__GETD1S 4
	__GETD2S 12
	RCALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1F:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x21:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x26:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x28:
	RCALL SUBOPT_0x1A
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x2B:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2C:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x2D:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2E:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x30:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x31:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x32:
	RCALL SUBOPT_0x2C
	RJMP SUBOPT_0x2D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RCALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0x30
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x37:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x38:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	__GETD2S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3E:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0x2A
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x40:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x41:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x42:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x43:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0x1F4
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
