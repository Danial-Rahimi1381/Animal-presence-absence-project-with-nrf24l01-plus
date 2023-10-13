
;CodeVisionAVR C Compiler V3.14 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega8A
;Program type           : Application
;Clock frequency        : 2.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
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
	.DEF _counter_delay=R4
	.DEF _counter_delay_msb=R5
	.DEF _request_counter_delay=R6
	.DEF _request_counter_delay_msb=R7
	.DEF _dipSwitchStatus=R9
	.DEF _flag_tx=R8
	.DEF _counter=R11

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
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x14,0x0
	.DB  0x0,0x0,0x0,0x0

_0x3:
	.DB  0x0,0xDD,0xCC,0xBB,0xCB,0x3,0xDD,0xCC
	.DB  0xBB,0xCB,0x6,0xDD,0xCC,0xBB,0xCB,0x9
	.DB  0xDD,0xCC,0xBB,0xCB,0xC,0xDD,0xCC,0xBB
	.DB  0xCB,0xF,0xDD,0xCC,0xBB,0xCB,0x12,0xDD
	.DB  0xCC,0xBB,0xCB,0x15,0xDD,0xCC,0xBB,0xCB
	.DB  0x18,0xDD,0xCC,0xBB,0xCB,0x1B,0xDD,0xCC
	.DB  0xBB,0xCB
_0x4:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x2,0x2,0x2,0x2
	.DB  0x2,0x2,0x3,0x3,0x3,0x3,0x3,0x3
	.DB  0x4,0x4,0x4,0x4,0x4,0x4,0x5,0x5
	.DB  0x5,0x5,0x5,0x5,0x6,0x6,0x6,0x6
	.DB  0x6,0x6,0x7,0x7,0x7,0x7,0x7,0x7
	.DB  0x8,0x8,0x8,0x8,0x8,0x8,0x9,0x9
	.DB  0x9,0x9,0x9,0x9
_0x2004B:
	.DB  0xE7,0xE7,0xE7,0xE7,0xE7,0xC2,0xC2,0xC2
	.DB  0xC2,0xC2,0xE7,0xE7,0xE7,0xE7,0xE7

__GLOBAL_INI_TBL:
	.DW  0x08
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x32
	.DW  _TxAddress
	.DW  _0x3*2

	.DW  0x3C
	.DW  _TxData
	.DW  _0x4*2

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
;Date    : 7/22/2023
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
;// Declare your global variables here
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// SPI functions
;#include <spi.h>
;#include "NRF24L01plus.h"
;#include "uart.h"
;
;// Timer1 output compare A interrupt service routine
;uint16_t counter_delay = 0;
;uint16_t request_counter_delay = 20;
;uint8_t dipSwitchStatus = 0;
;uint8_t  TxAddress[10][5] =
;{
;    {0x00,0xDD,0xCC,0xBB,0xCB},
;    {0x03,0xDD,0xCC,0xBB,0xCB},
;    {0x06,0xDD,0xCC,0xBB,0xCB},
;    {0x09,0xDD,0xCC,0xBB,0xCB},
;    {0x0C,0xDD,0xCC,0xBB,0xCB},
;    {0x0F,0xDD,0xCC,0xBB,0xCB},
;    {0x12,0xDD,0xCC,0xBB,0xCB},
;    {0x15,0xDD,0xCC,0xBB,0xCB},
;    {0x18,0xDD,0xCC,0xBB,0xCB},
;    {0x1B,0xDD,0xCC,0xBB,0xCB}
;};

	.DSEG
;uint8_t TxData[10][6] = {
;    {0, 0, 0, 0, 0, 0},
;    {1, 1, 1, 1, 1, 1},
;    {2, 2, 2, 2, 2, 2},
;    {3, 3, 3, 3, 3, 3},
;    {4, 4, 4, 4, 4, 4},
;    {5, 5, 5, 5, 5, 5},
;    {6, 6, 6, 6, 6, 6},
;    {7, 7, 7, 7, 7, 7},
;    {8, 8, 8, 8, 8, 8},
;    {9, 9, 9, 9, 9, 9}
;};
;uint8_t flag_tx = 0;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)//10ms
; 0000 0043 {

	.CSEG
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0044 // Place your code here
; 0000 0045 counter_delay++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0046 if(counter_delay >= request_counter_delay)
	__CPWRR 4,5,6,7
	BRLO _0x5
; 0000 0047 {
; 0000 0048   flag_tx = 1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0049   counter_delay = 0;
	CLR  R4
	CLR  R5
; 0000 004A }
; 0000 004B }
_0x5:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;void DipSwitch(void)
; 0000 004D {
_DipSwitch:
; .FSTART _DipSwitch
; 0000 004E  dipSwitchStatus = ~((PIND  & 0xF8) >> 3) & 0x1F;
	IN   R30,0x10
	ANDI R30,LOW(0xF8)
	LDI  R31,0
	RCALL __ASRW3
	COM  R30
	ANDI R30,LOW(0x1F)
	MOV  R9,R30
; 0000 004F  set_addr(TxAddress[dipSwitchStatus],3 * dipSwitchStatus);
	RCALL SUBOPT_0x0
	MOV  R30,R9
	LDI  R26,LOW(3)
	MULS R30,R26
	MOVW R30,R0
	MOV  R26,R30
	RCALL _set_addr
; 0000 0050 
; 0000 0051 }
	RET
; .FEND
;void main(void)
; 0000 0053 {
_main:
; .FSTART _main
; 0000 0054 
; 0000 0055 // Declare your local variables here
; 0000 0056 
; 0000 0057 // Input/Output Ports initialization
; 0000 0058 // Port B initialization
; 0000 0059 // Function: Bit7=In Bit6=In Bit5=Out Bit4=In Bit3=Out Bit2=Out Bit1=In Bit0=In
; 0000 005A DDRB=(0<<DDB7) | (0<<DDB6) | (1<<DDB5) | (0<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (0<<DDB0);
	LDI  R30,LOW(46)
	OUT  0x17,R30
; 0000 005B // State: Bit7=T Bit6=T Bit5=0 Bit4=T Bit3=0 Bit2=0 Bit1=T Bit0=T
; 0000 005C PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 005D 
; 0000 005E // Port C initialization
; 0000 005F // Function: Bit6=In Bit5=Out Bit4=Out Bit3=In Bit2=Out Bit1=Out Bit0=Out
; 0000 0060 DDRC=(0<<DDC6) | (1<<DDC5) | (1<<DDC4) | (0<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
	LDI  R30,LOW(55)
	OUT  0x14,R30
; 0000 0061 // State: Bit6=T Bit5=0 Bit4=0 Bit3=T Bit2=0 Bit1=0 Bit0=0
; 0000 0062 PORTC=(0<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (0<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
	OUT  0x15,R30
; 0000 0063 
; 0000 0064 // Port D initialization
; 0000 0065 // Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In
; 0000 0066 DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (0<<DDD3) | (0<<DDD2) | (0<<DDD1) | (0<<DDD0);
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0067 // State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T
; 0000 0068 PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);
	LDI  R30,LOW(248)
	OUT  0x12,R30
; 0000 0069 
; 0000 006A // Timer/Counter 0 initialization
; 0000 006B // Clock source: System Clock
; 0000 006C // Clock value: Timer 0 Stopped
; 0000 006D TCCR0=(0<<CS02) | (0<<CS01) | (0<<CS00);
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 006E TCNT0=0x00;
	OUT  0x32,R30
; 0000 006F 
; 0000 0070 // Timer/Counter 1 initialization
; 0000 0071 // Clock source: System Clock
; 0000 0072 // Clock value: 250.000 kHz
; 0000 0073 // Mode: Fast PWM top=ICR1
; 0000 0074 // OC1A output: Disconnected
; 0000 0075 // OC1B output: Disconnected
; 0000 0076 // Noise Canceler: Off
; 0000 0077 // Input Capture on Falling Edge
; 0000 0078 // Timer Period: 10 ms
; 0000 0079 // Timer1 Overflow Interrupt: Off
; 0000 007A // Input Capture Interrupt: Off
; 0000 007B // Compare A Match Interrupt: On
; 0000 007C // Compare B Match Interrupt: Off
; 0000 007D TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (1<<WGM11) | (0<<WGM10);
	LDI  R30,LOW(2)
	OUT  0x2F,R30
; 0000 007E TCCR1B=(0<<ICNC1) | (0<<ICES1) | (1<<WGM13) | (1<<WGM12) | (0<<CS12) | (1<<CS11) | (0<<CS10);
	LDI  R30,LOW(26)
	OUT  0x2E,R30
; 0000 007F TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 0080 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0081 ICR1H=0x09;
	LDI  R30,LOW(9)
	OUT  0x27,R30
; 0000 0082 ICR1L=0xC3;
	LDI  R30,LOW(195)
	OUT  0x26,R30
; 0000 0083 OCR1AH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2B,R30
; 0000 0084 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0085 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0086 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0087 
; 0000 0088 
; 0000 0089 // Timer/Counter 2 initialization
; 0000 008A // Clock source: System Clock
; 0000 008B // Clock value: Timer2 Stopped
; 0000 008C // Mode: Normal top=0xFF
; 0000 008D // OC2 output: Disconnected
; 0000 008E ASSR=0<<AS2;
	OUT  0x22,R30
; 0000 008F TCCR2=(0<<PWM2) | (0<<COM21) | (0<<COM20) | (0<<CTC2) | (0<<CS22) | (0<<CS21) | (0<<CS20);
	OUT  0x25,R30
; 0000 0090 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0091 OCR2=0x00;
	OUT  0x23,R30
; 0000 0092 
; 0000 0093 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0094 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<TOIE0);
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 0095 
; 0000 0096 // External Interrupt(s) initialization
; 0000 0097 // INT0: Off
; 0000 0098 // INT1: Off
; 0000 0099 MCUCR=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 009A 
; 0000 009B // USART initialization
; 0000 009C // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 009D // USART Receiver: On
; 0000 009E // USART Transmitter: On
; 0000 009F // USART Mode: Asynchronous
; 0000 00A0 // USART Baud Rate: 9600
; 0000 00A1 UCSRA=(0<<RXC) | (0<<TXC) | (0<<UDRE) | (0<<FE) | (0<<DOR) | (0<<UPE) | (0<<U2X) | (0<<MPCM);
	OUT  0xB,R30
; 0000 00A2 UCSRB=(0<<RXCIE) | (0<<TXCIE) | (0<<UDRIE) | (1<<RXEN) | (1<<TXEN) | (0<<UCSZ2) | (0<<RXB8) | (0<<TXB8);
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00A3 UCSRC=(1<<URSEL) | (0<<UMSEL) | (0<<UPM1) | (0<<UPM0) | (0<<USBS) | (1<<UCSZ1) | (1<<UCSZ0) | (0<<UCPOL);
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00A4 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 00A5 UBRRL=0x0C;
	LDI  R30,LOW(12)
	OUT  0x9,R30
; 0000 00A6 
; 0000 00A7 // Analog Comparator initialization
; 0000 00A8 // Analog Comparator: Off
; 0000 00A9 // The Analog Comparator's positive input is
; 0000 00AA // connected to the AIN0 pin
; 0000 00AB // The Analog Comparator's negative input is
; 0000 00AC // connected to the AIN1 pin
; 0000 00AD ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIC) | (0<<ACIS1) | (0<<ACIS0);
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00AE SFIOR=(0<<ACME);
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00AF 
; 0000 00B0 // ADC initialization
; 0000 00B1 // ADC disabled
; 0000 00B2 ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
	OUT  0x6,R30
; 0000 00B3 
; 0000 00B4 // SPI initialization
; 0000 00B5 // SPI Type: Master
; 0000 00B6 // SPI Clock Rate: 500.000 kHz
; 0000 00B7 // SPI Clock Phase: Cycle Start
; 0000 00B8 // SPI Clock Polarity: Low
; 0000 00B9 // SPI Data Order: MSB First
; 0000 00BA SPCR=(0<<SPIE) | (1<<SPE) | (0<<DORD) | (1<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);
	LDI  R30,LOW(80)
	OUT  0xD,R30
; 0000 00BB SPSR=(0<<SPI2X);
	LDI  R30,LOW(0)
	OUT  0xE,R30
; 0000 00BC 
; 0000 00BD // TWI initialization
; 0000 00BE // TWI disabled
; 0000 00BF TWCR=(0<<TWEA) | (0<<TWSTA) | (0<<TWSTO) | (0<<TWEN) | (0<<TWIE);
	OUT  0x36,R30
; 0000 00C0 NRF24L01plus_Init();
	RCALL _NRF24L01plus_Init
; 0000 00C1 NRF24_TXMode(TxAddress[dipSwitchStatus],0);
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	RCALL _NRF24_TXMode
; 0000 00C2 #asm("sei")
	sei
; 0000 00C3 
; 0000 00C4 while (1)
_0x6:
; 0000 00C5       {
; 0000 00C6       DipSwitch();
	RCALL _DipSwitch
; 0000 00C7       UART_TxChar(dipSwitchStatus);
	MOV  R26,R9
	RCALL _UART_TxChar
; 0000 00C8       UART_TxChar('\n');
	LDI  R26,LOW(10)
	RCALL _UART_TxChar
; 0000 00C9       UART_TxChar('\r');
	LDI  R26,LOW(13)
	RCALL _UART_TxChar
; 0000 00CA       // Place your code here
; 0000 00CB       if(flag_tx)
	TST  R8
	BREQ _0x9
; 0000 00CC       {   counter_delay = 0;
	CLR  R4
	CLR  R5
; 0000 00CD           flag_tx = 0;
	CLR  R8
; 0000 00CE 
; 0000 00CF           switch(NRF24_Transmit(TxData[dipSwitchStatus],5))
	MOV  R30,R9
	LDI  R26,LOW(6)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_TxData)
	SBCI R31,HIGH(-_TxData)
	RCALL SUBOPT_0x1
	LDI  R26,LOW(5)
	RCALL _NRF24_Transmit
; 0000 00D0            {
; 0000 00D1               case 0:
	CPI  R30,0
	BRNE _0xD
; 0000 00D2                  request_counter_delay = 20;
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	MOVW R6,R30
; 0000 00D3                  break;
	RJMP _0xC
; 0000 00D4               case 1:
_0xD:
	CPI  R30,LOW(0x1)
	BRNE _0xC
; 0000 00D5                   request_counter_delay = 300;
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	MOVW R6,R30
; 0000 00D6                   PORTC.4 = 0;
	CBI  0x15,4
; 0000 00D7                   delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00D8                   PORTC.4 = 1;
	SBI  0x15,4
; 0000 00D9               break;
; 0000 00DA 
; 0000 00DB 
; 0000 00DC            }
_0xC:
; 0000 00DD       }
; 0000 00DE       }
_0x9:
	RJMP _0x6
; 0000 00DF }
_0x13:
	RJMP _0x13
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
;uint8_t counter = 0;
;
;void NRF24_Write_Register(uint8_t reg, uint8_t Data)
; 0001 0008 {

	.CSEG
_NRF24_Write_Register:
; .FSTART _NRF24_Write_Register
; 0001 0009 if(reg <= 31)
	ST   -Y,R26
;	reg -> Y+1
;	Data -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x20)
	BRSH _0x20003
; 0001 000A {
; 0001 000B    uint8_t buf[2];
; 0001 000C    buf[0] = reg|(1<<5);
	SBIW R28,2
;	reg -> Y+3
;	Data -> Y+2
;	buf -> Y+0
	LDD  R30,Y+3
	ORI  R30,0x20
	ST   Y,R30
; 0001 000D    buf[1] = Data;
	LDD  R30,Y+2
	STD  Y+1,R30
; 0001 000E    CSN_Enable;
	CBI  0x18,2
; 0001 000F    SPI_Transmit(buf[0]);
	LD   R26,Y
	RCALL _SPI_Transmit
; 0001 0010    SPI_Transmit(buf[1]);
	LDD  R26,Y+1
	RCALL _SPI_Transmit
; 0001 0011    CSN_Disable;
	SBI  0x18,2
; 0001 0012 }
	ADIW R28,2
; 0001 0013 }
_0x20003:
	ADIW R28,2
	RET
; .FEND
;
;void NRF24_WriteMulti_Register(uint8_t reg, uint8_t * Data, uint8_t size)
; 0001 0016 {   uint8_t i;
_NRF24_WriteMulti_Register:
; .FSTART _NRF24_WriteMulti_Register
; 0001 0017     uint8_t buf;
; 0001 0018     buf = reg | (1 << 5);// write function
	RCALL SUBOPT_0x2
;	reg -> Y+5
;	*Data -> Y+3
;	size -> Y+2
;	i -> R17
;	buf -> R16
	LDD  R30,Y+5
	ORI  R30,0x20
	MOV  R16,R30
; 0001 0019     CSN_Enable;
	CBI  0x18,2
; 0001 001A     SPI_Transmit(buf);
	MOV  R26,R16
	RCALL _SPI_Transmit
; 0001 001B     SPI_TransmitBytes(Data, size);
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	RCALL SUBOPT_0x1
	LDD  R26,Y+4
	CLR  R27
	RCALL _SPI_TransmitBytes
; 0001 001C     CSN_Disable;
	SBI  0x18,2
; 0001 001D }
	RCALL __LOADLOCR2
	ADIW R28,6
	RET
; .FEND
;
;uint8_t NRF24_Read_Register(uint8_t reg)
; 0001 0020 {
_NRF24_Read_Register:
; .FSTART _NRF24_Read_Register
; 0001 0021 if(reg <= 31)
	ST   -Y,R26
;	reg -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x20)
	BRSH _0x2000C
; 0001 0022 {
; 0001 0023     uint8_t Data = 0;
; 0001 0024     CSN_Enable;
	SBIW R28,1
	LDI  R30,LOW(0)
	ST   Y,R30
;	reg -> Y+1
;	Data -> Y+0
	CBI  0x18,2
; 0001 0025     SPI_Transmit(reg);
	LDD  R26,Y+1
	RCALL _SPI_Transmit
; 0001 0026     Data = SPI_Receive();
	RCALL _SPI_Receive
	ST   Y,R30
; 0001 0027     CSN_Disable;
	SBI  0x18,2
; 0001 0028     return Data;
	ADIW R28,1
	RJMP _0x2080003
; 0001 0029 }
; 0001 002A return 0;
_0x2000C:
	LDI  R30,LOW(0)
	RJMP _0x2080003
; 0001 002B }
; .FEND
;
;void NRF24_ReadMulti_Register(uint8_t reg, uint8_t *data, uint8_t size)
; 0001 002E {
; 0001 002F     CSN_Enable;
;	reg -> Y+3
;	*data -> Y+1
;	size -> Y+0
; 0001 0030 
; 0001 0031     SPI_Transmit(reg);
; 0001 0032     SPI_ReceiveBytes(data, size);
; 0001 0033 
; 0001 0034     CSN_Disable;
; 0001 0035 }
;
;
;// send the command to the NRF
;void NRF24_SendCMD(uint8_t cmd)
; 0001 003A {
; 0001 003B     CSN_Enable;
;	cmd -> Y+0
; 0001 003C     SPI_Transmit(cmd);
; 0001 003D     CSN_Disable;
; 0001 003E }
;//----------------------------------------------------
;
;
;void NRF24L01plus_Init()
; 0001 0043 {
_NRF24L01plus_Init:
; .FSTART _NRF24L01plus_Init
; 0001 0044     uint8_t config;
; 0001 0045     CE_Disable;
	ST   -Y,R17
;	config -> R17
	CBI  0x18,1
; 0001 0046     NRF_RESET(0);
	LDI  R26,LOW(0)
	RCALL _NRF_RESET
; 0001 0047     NRF24_Write_Register(CONFIG,0); // will be configured later
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0001 0048     NRF24_Write_Register(SETUP_RETR, 0xFF); // Enable automatic retransmission with maximum delay and retries
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(255)
	RCALL SUBOPT_0x5
; 0001 0049   //  NRF24_Write_Register(RF_CH, 0); // will be setup during TX or RX
; 0001 004A     NRF24_Write_Register(SETUP_AW, 0x03);//5byte for  TX/RX Address
; 0001 004B     NRF24_Write_Register(RF_SETUP, 0x0E); // Power = 0db, data rate =  250kbps
	RCALL SUBOPT_0x6
; 0001 004C     NRF24_Write_Register(FEATURE,0x06); //EN_ACK_PAY  ,  EN_DPL
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(6)
	RCALL _NRF24_Write_Register
; 0001 004D     config = NRF24_Read_Register(CONFIG);
	RCALL SUBOPT_0x7
; 0001 004E     config = config | (1<<3) | (1 << 2); // CRC ENABLE ,  CRC 2BYTE
	ORI  R17,LOW(12)
; 0001 004F     NRF24_Write_Register(CONFIG, config);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x8
; 0001 0050 
; 0001 0051     CE_Enable;
	SBI  0x18,1
; 0001 0052 }
	LD   R17,Y+
	RET
; .FEND
;/*----------------------------------------------*/
;/*-----------------TxMode-----------------------*/
;void NRF24_TXMode( uint8_t const* Address, uint8_t channel)
; 0001 0056  {
_NRF24_TXMode:
; .FSTART _NRF24_TXMode
; 0001 0057     uint8_t config = 0;
; 0001 0058     uint8_t dynpd = 0;
; 0001 0059     CE_Disable;
	RCALL SUBOPT_0x2
;	*Address -> Y+3
;	channel -> Y+2
;	config -> R17
;	dynpd -> R16
	LDI  R17,0
	LDI  R16,0
	CBI  0x18,1
; 0001 005A 
; 0001 005B     NRF24_Write_Register(RF_CH, channel); // select the channel
	RCALL SUBOPT_0x9
; 0001 005C 
; 0001 005D     NRF24_WriteMulti_Register(TX_ADDR, Address, 5); // Write the TX address
; 0001 005E 
; 0001 005F     // power up the device
; 0001 0060     config = NRF24_Read_Register(CONFIG);
; 0001 0061     config = (config | (1<<1)) & 0b11111110;
	RCALL SUBOPT_0xA
; 0001 0062     NRF24_Write_Register(CONFIG, config);
	RCALL SUBOPT_0x8
; 0001 0063 
; 0001 0064     // Enable Enhanced ShockBurst
; 0001 0065     NRF24_Write_Register(EN_AA, 0x02); // Enable Auto ACK on pipe 0
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xB
; 0001 0066     NRF24_Write_Register(EN_RXADDR, 0x02); // Enable data pipe 0
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xB
; 0001 0067     NRF24_Write_Register(DYNPD, 0x02); //Enable DPL  PIPE 0
	LDI  R30,LOW(28)
	RCALL SUBOPT_0xB
; 0001 0068     NRF24_WriteMulti_Register(RX_ADDR_P1, Address, 5); //Write the TX address
	LDI  R30,LOW(11)
	RCALL SUBOPT_0xC
; 0001 0069     delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0001 006A 
; 0001 006B 
; 0001 006C 
; 0001 006D  }
	RCALL __LOADLOCR2
	RJMP _0x2080002
; .FEND
;
;void set_addr( uint8_t const* Address, uint8_t channel)
; 0001 0070  {
_set_addr:
; .FSTART _set_addr
; 0001 0071     uint8_t config = 0;
; 0001 0072     uint8_t dynpd = 0;
; 0001 0073     CE_Disable;
	RCALL SUBOPT_0x2
;	*Address -> Y+3
;	channel -> Y+2
;	config -> R17
;	dynpd -> R16
	LDI  R17,0
	LDI  R16,0
	CBI  0x18,1
; 0001 0074     config = NRF24_Read_Register(CONFIG);
	RCALL SUBOPT_0x7
; 0001 0075     config = config | (1<<0);
	ORI  R17,LOW(1)
; 0001 0076     NRF24_Write_Register(CONFIG, config);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x8
; 0001 0077 
; 0001 0078     NRF24_Write_Register(RF_CH, channel); // select the channel
	RCALL SUBOPT_0x9
; 0001 0079     NRF24_WriteMulti_Register(TX_ADDR, Address, 5); // Write the TX address
; 0001 007A 
; 0001 007B     // power up the device
; 0001 007C     config = NRF24_Read_Register(CONFIG);
; 0001 007D     config = (config | (1<<1)) & 0b11111110;
	RCALL SUBOPT_0xA
; 0001 007E     NRF24_Write_Register(CONFIG, config);
	RCALL SUBOPT_0x8
; 0001 007F 
; 0001 0080     // Enable Enhanced ShockBurst
; 0001 0081     NRF24_Write_Register(EN_AA, 0x01); // Enable Auto ACK on pipe 0
	LDI  R30,LOW(1)
	RCALL SUBOPT_0xD
; 0001 0082     NRF24_Write_Register(EN_RXADDR, 0x01); // Enable data pipe 0
	LDI  R30,LOW(2)
	RCALL SUBOPT_0xD
; 0001 0083     NRF24_Write_Register(DYNPD, 0x01); //Enable DPL  PIPE 0
	LDI  R30,LOW(28)
	RCALL SUBOPT_0xD
; 0001 0084     NRF24_WriteMulti_Register(RX_ADDR_P0, Address, 5); //Write the TX address
	LDI  R30,LOW(10)
	RCALL SUBOPT_0xC
; 0001 0085 
; 0001 0086     delay_ms(300);
	LDI  R26,LOW(300)
	LDI  R27,HIGH(300)
	RCALL _delay_ms
; 0001 0087  }
	RCALL __LOADLOCR2
	RJMP _0x2080002
; .FEND
;
;void nrf24_state(uint8_t state)
; 0001 008A {
_nrf24_state:
; .FSTART _nrf24_state
; 0001 008B 	uint8_t config_register;
; 0001 008C     uint8_t data;
; 0001 008D 	config_register = NRF24_Read_Register(CONFIG);
	RCALL SUBOPT_0x2
;	state -> Y+2
;	config_register -> R17
;	data -> R16
	RCALL SUBOPT_0x7
; 0001 008E 
; 0001 008F 	switch (state)
	LDD  R30,Y+2
	LDI  R31,0
; 0001 0090 	{
; 0001 0091 		case POWERUP:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x20024
; 0001 0092 		// Check if already powered up
; 0001 0093 		if (!(config_register & (1 << PWR_UP)))
	SBRC R17,1
	RJMP _0x20025
; 0001 0094 		{
; 0001 0095 			data = config_register | (1 << PWR_UP);
	MOV  R30,R17
	ORI  R30,2
	RCALL SUBOPT_0xE
; 0001 0096 			NRF24_Write_Register(CONFIG,data);
	RCALL SUBOPT_0xF
; 0001 0097 			// 1.5ms from POWERDOWN to start up
; 0001 0098 			delay_ms(2);
	LDI  R26,LOW(2)
	LDI  R27,0
	RCALL _delay_ms
; 0001 0099 		}
; 0001 009A 		break;
_0x20025:
	RJMP _0x20023
; 0001 009B 		case POWERDOWN:
_0x20024:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20026
; 0001 009C 		data = config_register & ~(1 << PWR_UP);
	MOV  R30,R17
	ANDI R30,0xFD
	RCALL SUBOPT_0xE
; 0001 009D 		NRF24_Write_Register(CONFIG,data);
	RCALL SUBOPT_0xF
; 0001 009E 		break;
	RJMP _0x20023
; 0001 009F 		case RECEIVE:
_0x20026:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x20027
; 0001 00A0 		data = config_register | (1 << PRIM_RX);
	MOV  R30,R17
	ORI  R30,1
	RCALL SUBOPT_0xE
; 0001 00A1 		NRF24_Write_Register(CONFIG,data);
	RCALL SUBOPT_0xF
; 0001 00A2 		// Clear STATUS register
; 0001 00A3 		data = (1 << RX_DR) | (1 << TX_DS) | (1 << MAX_RT);
	LDI  R16,LOW(112)
; 0001 00A4 		NRF24_Write_Register(STATUS,data);
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xF
; 0001 00A5 		break;
	RJMP _0x20023
; 0001 00A6 		case TRANSMIT:
_0x20027:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x20028
; 0001 00A7 		data = config_register & ~(1 << PRIM_RX);
	MOV  R30,R17
	ANDI R30,0xFE
	RCALL SUBOPT_0xE
; 0001 00A8 		NRF24_Write_Register(CONFIG,data);
	RCALL SUBOPT_0xF
; 0001 00A9 		break;
	RJMP _0x20023
; 0001 00AA 		case STANDBY1:
_0x20028:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x20029
; 0001 00AB 		CE_Disable;
	CBI  0x18,1
; 0001 00AC 		break;
	RJMP _0x20023
; 0001 00AD 		case STANDBY2:
_0x20029:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x20023
; 0001 00AE 		data = config_register & ~(1 << PRIM_RX);
	MOV  R30,R17
	ANDI R30,0xFE
	RCALL SUBOPT_0xE
; 0001 00AF 		NRF24_Write_Register(CONFIG,data);
	RCALL SUBOPT_0xF
; 0001 00B0 		CE_Enable;
	RCALL SUBOPT_0x11
; 0001 00B1 		delay_us(150);
; 0001 00B2 		break;
; 0001 00B3 	}
_0x20023:
; 0001 00B4 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; .FEND
;
;
;void nrf24_start_listening(void)
; 0001 00B8 {
_nrf24_start_listening:
; .FSTART _nrf24_start_listening
; 0001 00B9 	nrf24_state(RECEIVE);				// Receive mode
	LDI  R26,LOW(3)
	RCALL _nrf24_state
; 0001 00BA 	//if (AUTO_ACK) nrf24_write_ack();	// Write acknowledgment
; 0001 00BB     CE_Enable;
	RCALL SUBOPT_0x11
; 0001 00BC     delay_us(150);						// Settling time
; 0001 00BD }
	RET
; .FEND
;
;
;uint8_t NRF24_Transmit(uint8_t* data , uint8_t length)
; 0001 00C1  {
_NRF24_Transmit:
; .FSTART _NRF24_Transmit
; 0001 00C2 
; 0001 00C3     uint8_t cmdtosend = 0;
; 0001 00C4     uint8_t fifostatus = 0;
; 0001 00C5     uint8_t status = 0 ;
; 0001 00C6     uint8_t data_reg = 0;
; 0001 00C7     //Select the device
; 0001 00C8     	// Transmit mode
; 0001 00C9 	nrf24_state(TRANSMIT);
	ST   -Y,R26
	RCALL __SAVELOCR4
;	*data -> Y+5
;	length -> Y+4
;	cmdtosend -> R17
;	fifostatus -> R16
;	status -> R19
;	data_reg -> R18
	LDI  R17,0
	LDI  R16,0
	LDI  R19,0
	LDI  R18,0
	LDI  R26,LOW(4)
	RCALL _nrf24_state
; 0001 00CA 
; 0001 00CB     // Flush TX/RX and clear TX interrupt
; 0001 00CC 	NRF24_Write_Register(FLUSH_RX,0);
	LDI  R30,LOW(226)
	RCALL SUBOPT_0x12
; 0001 00CD 	NRF24_Write_Register(FLUSH_TX,0);
	LDI  R30,LOW(225)
	RCALL SUBOPT_0x12
; 0001 00CE 	data_reg = (1 << TX_DS);
	LDI  R18,LOW(32)
; 0001 00CF 	NRF24_Write_Register(STATUS,data_reg);
	RCALL SUBOPT_0x10
	MOV  R26,R18
	RCALL _NRF24_Write_Register
; 0001 00D0 
; 0001 00D1   CE_Enable;
	SBI  0x18,1
; 0001 00D2   delay_us(100);
	__DELAY_USB 67
; 0001 00D3   CE_Disable;
	CBI  0x18,1
; 0001 00D4 
; 0001 00D5   CSN_Enable;
	CBI  0x18,2
; 0001 00D6     cmdtosend = W_TX_PAYLOAD;
	LDI  R17,LOW(160)
; 0001 00D7     SPI_Transmit(cmdtosend);
	MOV  R26,R17
	RCALL _SPI_Transmit
; 0001 00D8     SPI_Transmit_nrf24(data,length);
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	RCALL SUBOPT_0x1
	LDD  R26,Y+6
	CLR  R27
	RCALL _SPI_Transmit_nrf24
; 0001 00D9     PORTC.5 = 0;
	CBI  0x15,5
; 0001 00DA   CSN_Disable;
	SBI  0x18,2
; 0001 00DB 
; 0001 00DC   delay_ms(3);//10000 US
	LDI  R26,LOW(3)
	LDI  R27,0
	RCALL _delay_ms
; 0001 00DD 
; 0001 00DE 
; 0001 00DF    //fifostatus = NRF24_Read_Register(FIFO_STATUS);
; 0001 00E0     status = NRF24_Read_Register(STATUS);
	LDI  R26,LOW(7)
	RCALL _NRF24_Read_Register
	MOV  R19,R30
; 0001 00E1     if (status&(1<<5))//(fifostatus&(1<<4)) && (!(fifostatus&(1<<3))))
	SBRS R19,5
	RJMP _0x2003B
; 0001 00E2     {
; 0001 00E3     PORTC.5 = 1;
	SBI  0x15,5
; 0001 00E4      counter  = 0;
	CLR  R11
; 0001 00E5     // cmdtosend = FLUSH_TX;
; 0001 00E6     // NRF24_SendCMD(cmdtosend);
; 0001 00E7     nrf24_start_listening();
	RCALL _nrf24_start_listening
; 0001 00E8     NRF24_Write_Register(STATUS, status);
	RCALL SUBOPT_0x10
	MOV  R26,R19
	RCALL _NRF24_Write_Register
; 0001 00E9     data_reg = NRF24_Read_Register(CONFIG);
	RCALL SUBOPT_0x13
; 0001 00EA     data_reg = data_reg & 0b11111101;
; 0001 00EB     NRF24_Write_Register(CONFIG,data_reg);
	MOV  R26,R18
	RCALL _NRF24_Write_Register
; 0001 00EC 
; 0001 00ED      return 1;
	LDI  R30,LOW(1)
	RJMP _0x2080004
; 0001 00EE     }
; 0001 00EF     //power down
; 0001 00F0     data_reg = NRF24_Read_Register(CONFIG);
_0x2003B:
	RCALL SUBOPT_0x13
; 0001 00F1     data_reg = data_reg & 0b11111101;
; 0001 00F2     NRF24_Write_Register(CONFIG,data_reg);
	MOV  R26,R18
	RCALL _NRF24_Write_Register
; 0001 00F3     //-----
; 0001 00F4 
; 0001 00F5     return 0;
	LDI  R30,LOW(0)
_0x2080004:
	RCALL __LOADLOCR4
	ADIW R28,7
	RET
; 0001 00F6  }
; .FEND
;
;
;void NRF24_RxMode (uint8_t *Address, uint8_t channel)
; 0001 00FA  {
; 0001 00FB     uint8_t en_rxaddr;
; 0001 00FC     uint8_t en_aa;
; 0001 00FD     uint8_t config;
; 0001 00FE     NRF_RESET(STATUS);
;	*Address -> Y+5
;	channel -> Y+4
;	en_rxaddr -> R17
;	en_aa -> R16
;	config -> R19
; 0001 00FF     //Disable the chip before configuring the device
; 0001 0100     CE_Disable;
; 0001 0101 
; 0001 0102     NRF24_Write_Register(RF_CH, channel); // select the channel
; 0001 0103 
; 0001 0104     en_rxaddr = NRF24_Read_Register(EN_RXADDR);
; 0001 0105     en_rxaddr = en_rxaddr | (1 << 1);
; 0001 0106     NRF24_Write_Register(EN_RXADDR, en_rxaddr); // enable data pipe 1
; 0001 0107     en_aa = NRF24_Read_Register(EN_AA);
; 0001 0108     en_aa = en_aa | (1 << 1);
; 0001 0109     NRF24_Write_Register(EN_AA, en_aa); // enable auto acknowledgment for data pipe 1
; 0001 010A 
; 0001 010B //    NRF24_WriteMulti_Register(RX_ADDR_P1, Address, 5); // Write the RX address for data pipe 1
; 0001 010C     NRF24_Write_Register(DYNPD, 0x02); // DPL for PIPE 1
; 0001 010D 
; 0001 010E     // power up the device and enable Enhanced ShockBurst
; 0001 010F     config = NRF24_Read_Register(CONFIG);
; 0001 0110     config = config | (1 << 1) | (1 << 0);
; 0001 0111     NRF24_Write_Register(CONFIG, config);
; 0001 0112 
; 0001 0113     // Enable the chip after configuring the device
; 0001 0114     CE_Enable;
; 0001 0115 
; 0001 0116  }
;void setRX_Address(uint8_t const* Address)
; 0001 0118 {
; 0001 0119     NRF24_WriteMulti_Register(RX_ADDR_P1, Address, 5); // Write the RX address for data pipe 1
;	*Address -> Y+0
; 0001 011A }
;
;void writeAckPayload(uint8_t number_pipe, uint8_t *Data, uint8_t DataSize)
; 0001 011D     {
; 0001 011E      uint8_t cmdtosend;
; 0001 011F     cmdtosend = W_ACK_PAYLOAD;
;	number_pipe -> Y+4
;	*Data -> Y+2
;	DataSize -> Y+1
;	cmdtosend -> R17
; 0001 0120     SPI_Transmit(cmdtosend |(number_pipe & 0x07));
; 0001 0121     SPI_TransmitBytes(Data,DataSize);
; 0001 0122 
; 0001 0123     CSN_Enable;
; 0001 0124     }
;
;uint8_t isDataAvailable(int pipenum)
; 0001 0127 {
; 0001 0128 
; 0001 0129     uint8_t status;
; 0001 012A     uint8_t cmdtosend;
; 0001 012B     uint8_t length;
; 0001 012C     status = NRF24_Read_Register(STATUS);
;	pipenum -> Y+4
;	status -> R17
;	cmdtosend -> R16
;	length -> R19
; 0001 012D     if((status&(1<<6))&&(status&(pipenum<<1)))
; 0001 012E     {
; 0001 012F 
; 0001 0130         NRF24_Write_Register(STATUS, (1<<6));
; 0001 0131         NRF24_Write_Register(STATUS, (1<<5));
; 0001 0132 
; 0001 0133         return 1;
; 0001 0134     }
; 0001 0135     return 0;
; 0001 0136 
; 0001 0137 }
;
;void NRF24_Recive(uint8_t *data,uint8_t length)
; 0001 013A {
; 0001 013B  uint8_t cmdtosend = 0;
; 0001 013C  uint8_t i;
; 0001 013D 
; 0001 013E  // select the device
; 0001 013F 
; 0001 0140  CSN_Enable;
;	*data -> Y+3
;	length -> Y+2
;	cmdtosend -> R17
;	i -> R16
; 0001 0141 
; 0001 0142  cmdtosend = R_RX_PAYLOAD;
; 0001 0143  SPI_Transmit(cmdtosend);
; 0001 0144  SPI_ReceiveBytes(data,length);
; 0001 0145 
; 0001 0146 /*
; 0001 0147 
; 0001 0148 cmdtosend = R_RX_PL_WID;
; 0001 0149 SPI_Transmit(cmdtosend);
; 0001 014A length = SPI_Receive();
; 0001 014B 
; 0001 014C */
; 0001 014D // Unselect the device
; 0001 014E 
; 0001 014F  CSN_Disable;
; 0001 0150  cmdtosend = FLUSH_RX;
; 0001 0151  NRF24_SendCMD(cmdtosend);
; 0001 0152 }
;void nrf24_read(uint8_t *data)
; 0001 0154 {
; 0001 0155      NRF24_Recive(data,32);
;	*data -> Y+0
; 0001 0156 }
;void NRF_RESET(uint8_t REG)
; 0001 0158 {
_NRF_RESET:
; .FSTART _NRF_RESET
; 0001 0159 uint8_t rx_addr_p0_def[5]= {0xE7, 0xE7, 0xE7, 0xE7, 0xE7};
; 0001 015A uint8_t rx_addr_p1_def[5]=  {0xC2, 0xC2, 0xC2, 0xC2, 0xC2};
; 0001 015B uint8_t tx_addr_def[5] = {0xE7, 0xE7, 0xE7, 0xE7, 0xE7};
; 0001 015C uint8_t status;
; 0001 015D     if (REG == STATUS)
	ST   -Y,R26
	SBIW R28,15
	LDI  R24,15
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x2004B*2)
	LDI  R31,HIGH(_0x2004B*2)
	RCALL __INITLOCB
	ST   -Y,R17
;	REG -> Y+16
;	rx_addr_p0_def -> Y+11
;	rx_addr_p1_def -> Y+6
;	tx_addr_def -> Y+1
;	status -> R17
	LDD  R26,Y+16
	CPI  R26,LOW(0x7)
	BRNE _0x2004C
; 0001 015E     {
; 0001 015F      status = NRF24_Read_Register(STATUS);
	LDI  R26,LOW(7)
	RCALL _NRF24_Read_Register
	MOV  R17,R30
; 0001 0160      status = status | (1 << 4) | (1 << 5) | (1 << 6);
	ORI  R17,LOW(112)
; 0001 0161      NRF24_Write_Register(STATUS, status);
	RCALL SUBOPT_0x10
	MOV  R26,R17
	RJMP _0x20050
; 0001 0162     }
; 0001 0163 
; 0001 0164     else if (REG == FIFO_STATUS)
_0x2004C:
	LDD  R26,Y+16
	CPI  R26,LOW(0x17)
	BRNE _0x2004E
; 0001 0165     {
; 0001 0166         NRF24_Write_Register(FIFO_STATUS, 0x11);
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(17)
	RJMP _0x20050
; 0001 0167 
; 0001 0168     }
; 0001 0169     else {
_0x2004E:
; 0001 016A         NRF24_Write_Register(CONFIG, 0x08);
	RCALL SUBOPT_0x3
	LDI  R26,LOW(8)
	RCALL _NRF24_Write_Register
; 0001 016B         NRF24_Write_Register(EN_AA, 0x3F);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(63)
	RCALL _NRF24_Write_Register
; 0001 016C         NRF24_Write_Register(EN_RXADDR, 0x03);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x5
; 0001 016D         NRF24_Write_Register(SETUP_AW, 0x03);
; 0001 016E         NRF24_Write_Register(SETUP_RETR, 0x03);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RCALL _NRF24_Write_Register
; 0001 016F         NRF24_Write_Register(RF_CH, 0x02);
	LDI  R30,LOW(5)
	RCALL SUBOPT_0xB
; 0001 0170         NRF24_Write_Register(RF_SETUP, 0x0E);
	RCALL SUBOPT_0x6
; 0001 0171         NRF24_Write_Register(STATUS, 0x00);
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x4
; 0001 0172         NRF24_Write_Register(OBSERVE_TX, 0x00);
	LDI  R30,LOW(8)
	RCALL SUBOPT_0x12
; 0001 0173         NRF24_Write_Register(CD, 0x00);
	LDI  R30,LOW(9)
	RCALL SUBOPT_0x12
; 0001 0174         NRF24_WriteMulti_Register(RX_ADDR_P0, rx_addr_p0_def, 5);
	LDI  R30,LOW(10)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,12
	RCALL SUBOPT_0x14
; 0001 0175         NRF24_WriteMulti_Register(RX_ADDR_P1, rx_addr_p1_def, 5);
	LDI  R30,LOW(11)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,7
	RCALL SUBOPT_0x14
; 0001 0176         NRF24_Write_Register(RX_ADDR_P2, 0xC3);
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(195)
	RCALL _NRF24_Write_Register
; 0001 0177         NRF24_Write_Register(RX_ADDR_P3, 0xC4);
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R26,LOW(196)
	RCALL _NRF24_Write_Register
; 0001 0178         NRF24_Write_Register(RX_ADDR_P4, 0xC5);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R26,LOW(197)
	RCALL _NRF24_Write_Register
; 0001 0179         NRF24_Write_Register(RX_ADDR_P5, 0xC6);
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R26,LOW(198)
	RCALL _NRF24_Write_Register
; 0001 017A         NRF24_WriteMulti_Register(TX_ADDR, tx_addr_def, 5);
	LDI  R30,LOW(16)
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,2
	RCALL SUBOPT_0x14
; 0001 017B         NRF24_Write_Register(RX_PW_P0, 0);
	LDI  R30,LOW(17)
	RCALL SUBOPT_0x12
; 0001 017C         NRF24_Write_Register(RX_PW_P1, 0);
	LDI  R30,LOW(18)
	RCALL SUBOPT_0x12
; 0001 017D         NRF24_Write_Register(RX_PW_P2, 0);
	LDI  R30,LOW(19)
	RCALL SUBOPT_0x12
; 0001 017E         NRF24_Write_Register(RX_PW_P3, 0);
	LDI  R30,LOW(20)
	RCALL SUBOPT_0x12
; 0001 017F         NRF24_Write_Register(RX_PW_P4, 0);
	LDI  R30,LOW(21)
	RCALL SUBOPT_0x12
; 0001 0180         NRF24_Write_Register(RX_PW_P5, 0);
	LDI  R30,LOW(22)
	RCALL SUBOPT_0x12
; 0001 0181         NRF24_Write_Register(FIFO_STATUS, 0x11);
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDI  R26,LOW(17)
	RCALL _NRF24_Write_Register
; 0001 0182         NRF24_Write_Register(DYNPD, 0);
	LDI  R30,LOW(28)
	RCALL SUBOPT_0x12
; 0001 0183         NRF24_Write_Register(FEATURE, 0);
	LDI  R30,LOW(29)
	ST   -Y,R30
	LDI  R26,LOW(0)
_0x20050:
	RCALL _NRF24_Write_Register
; 0001 0184     }
; 0001 0185 }
	LDD  R17,Y+0
	ADIW R28,17
	RET
; .FEND
;
;void PowerDown()
; 0001 0188 {
; 0001 0189     // power up the device
; 0001 018A     uint8_t config;
; 0001 018B     config = NRF24_Read_Register(CONFIG);
;	config -> R17
; 0001 018C     config = config | (0<<1) ;
; 0001 018D     NRF24_Write_Register(CONFIG, config);
; 0001 018E }
;
;void PowerUP()
; 0001 0191 {
; 0001 0192     // power up the device
; 0001 0193 
; 0001 0194     uint8_t config;
; 0001 0195     config = NRF24_Read_Register(CONFIG);
;	config -> R17
; 0001 0196     config = config | (1<<1) ;
; 0001 0197     NRF24_Write_Register(CONFIG, config);
; 0001 0198 }
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
; 0002 0004 {

	.CSEG
; 0002 0005     while ((UCSRA & (1 << RXC)) == 0);/* Wait till data is received */
; 0002 0006     return(UDR);            /* Return the byte*/
; 0002 0007 }
;
;void UART_TxChar(uint8_t ch)
; 0002 000A {
_UART_TxChar:
; .FSTART _UART_TxChar
; 0002 000B 	while (! (UCSRA & (1<<UDRE)));  /* Wait for empty transmit buffer */
	ST   -Y,R26
;	ch -> Y+0
_0x40006:
	SBIS 0xB,5
	RJMP _0x40006
; 0002 000C 	UDR = ch ;
	LD   R30,Y
	OUT  0xC,R30
; 0002 000D }
	RJMP _0x2080003
; .FEND
;
;void UART_SendString(uint8_t *str, uint8_t length)
; 0002 0010 {
; 0002 0011 int i;
; 0002 0012 for(i = 0; i< length;++i)
;	*str -> Y+3
;	length -> Y+2
;	i -> R16,R17
; 0002 0013 {
; 0002 0014     UART_TxChar(str[i]);
; 0002 0015 }
; 0002 0016 }
;
;void UART_SendString2(char *str)
; 0002 0019 {
; 0002 001A 	unsigned char j=0;
; 0002 001B 
; 0002 001C 	while (str[j]!=0)		/* Send string till null */
;	*str -> Y+1
;	j -> R17
; 0002 001D 	{
; 0002 001E 		UART_TxChar(str[j]);
; 0002 001F 		j++;
; 0002 0020 	}
; 0002 0021 }
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
;#include "uart.h"
;// Function to initialize SPI
;void SPI_Init()
; 0003 0006 {

	.CSEG
; 0003 0007     // Set MOSI, SCK, SS as output pins
; 0003 0008     DDRB |= (1 << DDB3) | (1 << DDB5) | (1 << DDB2);
; 0003 0009     // Enable SPI, Set as Master
; 0003 000A     // Prescaler: Fosc/16, Enable Interrupts
; 0003 000B     SPCR |= (1 << SPE) | (1 << MSTR) | (1 << SPR0);
; 0003 000C }
;
;// Function to send data over SPI
;void SPI_Transmit(uint8_t data)
; 0003 0010 {
_SPI_Transmit:
; .FSTART _SPI_Transmit
; 0003 0011     // Start transmission
; 0003 0012     SPDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	OUT  0xF,R30
; 0003 0013     // Wait for transmission to complete
; 0003 0014     while (!(SPSR & (1 << SPIF)));
_0x60003:
	SBIS 0xE,7
	RJMP _0x60003
; 0003 0015 }
_0x2080003:
	ADIW R28,1
	RET
; .FEND
;
;// Function to send multiple bytes over SPI
;void SPI_TransmitBytes(uint8_t* data, uint16_t length)
; 0003 0019 {      uint8_t i = 0;
_SPI_TransmitBytes:
; .FSTART _SPI_TransmitBytes
; 0003 001A 
; 0003 001B         for(i = 0; i < length;++i)
	RCALL SUBOPT_0x15
;	*data -> Y+3
;	length -> Y+1
;	i -> R17
_0x60007:
	RCALL SUBOPT_0x16
	BRSH _0x60008
; 0003 001C         {
; 0003 001D         SPDR = data[i];
	RCALL SUBOPT_0x17
; 0003 001E         while (!(SPSR & (1 << SPIF)));
_0x60009:
	SBIS 0xE,7
	RJMP _0x60009
; 0003 001F         }
	SUBI R17,-LOW(1)
	RJMP _0x60007
_0x60008:
; 0003 0020 
; 0003 0021        // UART_SendString(data,32);
; 0003 0022 }
	RJMP _0x2080001
; .FEND
;void SPI_Transmit_nrf24(uint8_t* data, uint16_t length)
; 0003 0024 {      uint8_t i = 0;
_SPI_Transmit_nrf24:
; .FSTART _SPI_Transmit_nrf24
; 0003 0025 
; 0003 0026         for(i = 0; i < length;++i)
	RCALL SUBOPT_0x15
;	*data -> Y+3
;	length -> Y+1
;	i -> R17
_0x6000D:
	RCALL SUBOPT_0x16
	BRSH _0x6000E
; 0003 0027         {
; 0003 0028         SPDR = data[i];
	RCALL SUBOPT_0x17
; 0003 0029         while (!(SPSR & (1 << SPIF)));
_0x6000F:
	SBIS 0xE,7
	RJMP _0x6000F
; 0003 002A         }
	SUBI R17,-LOW(1)
	RJMP _0x6000D
_0x6000E:
; 0003 002B 
; 0003 002C        // UART_SendString(data,32);
; 0003 002D }
_0x2080001:
	LDD  R17,Y+0
_0x2080002:
	ADIW R28,5
	RET
; .FEND
;// Function to receive data over SPI (single byte)
;uint8_t SPI_Receive()
; 0003 0030 {
_SPI_Receive:
; .FSTART _SPI_Receive
; 0003 0031     // Send dummy data to initiate data exchange
; 0003 0032     SPI_Transmit(0xFF);
	LDI  R26,LOW(255)
	RCALL _SPI_Transmit
; 0003 0033     // Wait for reception to complete
; 0003 0034     while (!(SPSR & (1 << SPIF)));
_0x60012:
	SBIS 0xE,7
	RJMP _0x60012
; 0003 0035     // Return received data
; 0003 0036     return SPDR;
	IN   R30,0xF
	RET
; 0003 0037 }
; .FEND
;
;// Function to receive multiple bytes over SPI
;void SPI_ReceiveBytes(uint8_t* buffer, uint16_t length)
; 0003 003B {
; 0003 003C     uint16_t i;
; 0003 003D     for (i = 0; i < length; i++)
;	*buffer -> Y+4
;	length -> Y+2
;	i -> R16,R17
; 0003 003E     {
; 0003 003F         buffer[i] = SPI_Receive();
; 0003 0040     }
; 0003 0041 }
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

	.CSEG

	.CSEG

	.DSEG
_TxAddress:
	.BYTE 0x32
_TxData:
	.BYTE 0x3C

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	MOV  R30,R9
	LDI  R26,LOW(5)
	MUL  R30,R26
	MOVW R30,R0
	SUBI R30,LOW(-_TxAddress)
	SBCI R31,HIGH(-_TxAddress)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	ST   -Y,R26
	RCALL __SAVELOCR2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(0)
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	RCALL _NRF24_Write_Register
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R26,LOW(3)
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(14)
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(0)
	RCALL _NRF24_Read_Register
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	MOV  R26,R17
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDD  R26,Y+3
	RCALL _NRF24_Write_Register
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0x1
	LDI  R26,LOW(5)
	RCALL _NRF24_WriteMulti_Register
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	MOV  R30,R17
	ORI  R30,2
	ANDI R30,0xFE
	MOV  R17,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	ST   -Y,R30
	LDI  R26,LOW(2)
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	RCALL SUBOPT_0x1
	LDI  R26,LOW(5)
	RJMP _NRF24_WriteMulti_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	ST   -Y,R30
	LDI  R26,LOW(1)
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	MOV  R16,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	MOV  R26,R16
	RJMP _NRF24_Write_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(7)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	SBI  0x18,1
	__DELAY_USB 100
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x12:
	ST   -Y,R30
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(0)
	RCALL _NRF24_Read_Register
	MOV  R18,R30
	ANDI R18,LOW(253)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0x1
	LDI  R26,LOW(5)
	RJMP _NRF24_WriteMulti_Register

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	LDI  R17,0
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	OUT  0xF,R30
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

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
