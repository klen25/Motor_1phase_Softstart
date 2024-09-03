
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16A
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : float, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega16A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

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
	.EQU __DSTACK_SIZE=0x0200
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _zero=R4
	.DEF _temp=R7
	.DEF _keyupdate=R6
	.DEF _lastkeyupdate=R9
	.DEF _tekan=R8
	.DEF _Arus=R10
	.DEF _countpwm=R13
	.DEF _pressed=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int2_isr
	JMP  _timer0_comp_isr
	JMP  0x00

_0x3:
	.DB  0x2,0x2B,0x87,0x3D
_0x52:
	.DB  0x30
_0x9F:
	.DB  0x0,0x2,0x30,0x0,0x0,0x30,0x0,0x0
	.DB  0x0,0x0
_0x0:
	.DB  0x53,0x45,0x54,0x20,0x49,0x20,0x20,0x3A
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x6D,0x41
	.DB  0x0,0x2A,0x3A,0x2C,0x0,0x23,0x3A,0x43
	.DB  0x6C,0x72,0x0,0x41,0x52,0x55,0x53,0x20
	.DB  0x3D,0x20,0x0,0x25,0x64,0x20,0x6D,0x41
	.DB  0x0,0x53,0x45,0x54,0x20,0x4B,0x70,0x20
	.DB  0x3A,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x4B,0x70,0x20
	.DB  0x3D,0x20,0x0,0x25,0x30,0x2E,0x32,0x66
	.DB  0x0,0x53,0x45,0x54,0x20,0x4B,0x69,0x20
	.DB  0x3A,0x20,0x0,0x20,0x20,0x4B,0x69,0x20
	.DB  0x3D,0x20,0x0,0x20,0x20,0x53,0x4F,0x46
	.DB  0x54,0x20,0x53,0x54,0x41,0x52,0x54,0x45
	.DB  0x52,0x20,0x20,0x0,0x20,0x20,0x4D,0x4F
	.DB  0x54,0x4F,0x52,0x20,0x31,0x20,0x46,0x41
	.DB  0x53,0x41,0x20,0x20,0x0,0x41,0x52,0x55
	.DB  0x53,0x20,0x3A,0x20,0x0,0x50,0x57,0x4D
	.DB  0x20,0x20,0x3A,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x25,0x64
	.DB  0x0,0x53,0x65,0x6E,0x73,0x20,0x41,0x43
	.DB  0x53,0x20,0x25,0x30,0x2E,0x31,0x66,0x7C
	.DB  0x50,0x57,0x4D,0x20,0x25,0x64,0x0,0xD
	.DB  0xA,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2060060:
	.DB  0x1
_0x2060000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  _sensitivity
	.DW  _0x3*2

	.DW  0x01
	.DW  _savedkey
	.DW  _0x52*2

	.DW  0x08
	.DW  _0x5D
	.DW  _0x0*2+9

	.DW  0x08
	.DW  _0x5D+8
	.DW  _0x0*2+51

	.DW  0x08
	.DW  _0x5D+16
	.DW  _0x0*2+51

	.DW  0x08
	.DW  _0x92
	.DW  _0x0*2+125

	.DW  0x08
	.DW  _0x92+8
	.DW  _0x0*2+133

	.DW  0x09
	.DW  _0x92+16
	.DW  _0x0*2+141

	.DW  0x09
	.DW  _0x92+25
	.DW  _0x0*2+141

	.DW  0x03
	.DW  _0x92+34
	.DW  _0x0*2+175

	.DW  0x0A
	.DW  0x04
	.DW  _0x9F*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G103
	.DW  _0x2060060*2

_0xFFFFFFFF:
	.DW  0

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

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 11/27/2022
;Author  : Herlambang
;Company : Anugrah
;Comments:
;
;
;Chip type               : ATmega16A
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;/*Library Header*/
;#include <mega16a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;// Alphanumeric LCD functions
;#include <alcd.h>
;
;#include <stdio.h>
;#include <string.h>
;#include <stdlib.h>
;#include <stdbool.h>
;#include <math.h>
;
;/*Inisialisasi Parameter*/
;#define ADC_VREF_TYPE 0x40
;#define Returning 100
;#define ACInput 232
;#define DCRef 4.96
;#define MaxSpeed 200
;#define ditekan 0
;
;#define ADC_SCALE 1023.0
;#define VREF 5.0
;#define DEFAULT_FREQUENCY 50
;int zero = 512;
;float sensitivity = 0.066;

	.DSEG
;
;/*Inisialisasi Pinout*/
;#define ZeroCross PINB.2
;#define startt PINC.3
;
;/*Inisialisasi Variabel */
;char temp;
;volatile unsigned long millis_value; /*Inisialisasi untuk counter tik untuk millis*/
;char keyupdate = '0', lastkeyupdate = '0';/*Inisialisasi variabel keypad*/
;bool tekan = false;
;float Kp = 0.0, Ki = 0.0;
;int Arus = 0;  /*Inisialisasi PI Parameters*/
;unsigned char countpwm = 0;
;
;/*fungsi untuk cek interrupt zero crossing*/
;void Cek_Interrupt() {
; 0000 0041 void Cek_Interrupt() {

	.CSEG
_Cek_Interrupt:
; 0000 0042     char i;
; 0000 0043 
; 0000 0044     /*Filter untuk memastikan bukan noise*/
; 0000 0045     for (temp = 0;temp < 5;) { /*pengecekan 5x*/
	ST   -Y,R17
;	i -> R17
	CLR  R7
_0x5:
	LDI  R30,LOW(5)
	CP   R7,R30
	BRSH _0x6
; 0000 0046             if(!ZeroCross)
	SBIC 0x16,2
	RJMP _0x7
; 0000 0047             { temp++; }
	INC  R7
; 0000 0048             else { temp = Returning; }
	RJMP _0x8
_0x7:
	LDI  R30,LOW(100)
	MOV  R7,R30
_0x8:
; 0000 0049     }
	RJMP _0x5
_0x6:
; 0000 004A 
; 0000 004B     if(temp != Returning) {
	LDI  R30,LOW(100)
	CP   R30,R7
	BREQ _0x9
; 0000 004C         /*Proses ketika zero crossing, PWM dikeluarkan*/
; 0000 004D         OCR2 = countpwm; /*PWM diaktifkan*/
	OUT  0x23,R13
; 0000 004E         for(i=0x2F;i>0;i--); /*PWM dijeda*/
	LDI  R17,LOW(47)
_0xB:
	CPI  R17,1
	BRLO _0xC
	SUBI R17,1
	RJMP _0xB
_0xC:
; 0000 004F         OCR2 = 0;/*PWM di nol kan*/
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 0050       }
; 0000 0051 }
_0x9:
	LD   R17,Y+
	RET
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0055 {
_read_adc:
; 0000 0056 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0057 // Delay needed for the stabilization of the ADC input voltage
; 0000 0058 delay_us(10);
	__DELAY_USB 37
; 0000 0059 // Start the AD conversion
; 0000 005A ADCSRA|=0x40;
	SBI  0x6,6
; 0000 005B // Wait for the AD conversion to complete
; 0000 005C while ((ADCSRA & 0x10)==0);
_0xD:
	SBIS 0x6,4
	RJMP _0xD
; 0000 005D ADCSRA|=0x10;
	SBI  0x6,4
; 0000 005E return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x20C0006
; 0000 005F }
;
;/*Interrupt untuk tik millis*/
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 0063 {
_timer0_comp_isr:
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0064 // Place your code here
; 0000 0065     millis_value++;
	LDI  R26,LOW(_millis_value)
	LDI  R27,HIGH(_millis_value)
	CALL __GETD1P_INC
	__SUBD1N -1
	CALL __PUTDP1_DEC
; 0000 0066 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R23,Y+
	LD   R22,Y+
	RETI
;
;/*Interrupt untuk cek zero crossing*/
;interrupt [EXT_INT2] void ext_int2_isr(void)
; 0000 006A {
_ext_int2_isr:
; 0000 006B // Place your code here
; 0000 006C //    Cek_Interrupt();
; 0000 006D }
	RETI
;
;// Declare your global variables here
;/*Inisialisasi Variabel millis*/
;volatile unsigned long lastmillis_value;
;
;/*Fungsi untuk variabel millis*/
;unsigned long millis() {
; 0000 0074 unsigned long millis() {
_millis:
; 0000 0075     unsigned long m;
; 0000 0076     #asm("cli")
	SBIW R28,4
;	m -> Y+0
	cli
; 0000 0077     m = millis_value;
	LDS  R30,_millis_value
	LDS  R31,_millis_value+1
	LDS  R22,_millis_value+2
	LDS  R23,_millis_value+3
	CALL SUBOPT_0x0
; 0000 0078     #asm("sei")
	sei
; 0000 0079     return m;
	CALL SUBOPT_0x1
	RJMP _0x20C0008
; 0000 007A }
;
;/*Inisialisasi Variabel Keypad*/
;unsigned long lastDebounceTime = 0;
;#define debounceDelay  100
;#define aktif    0
;#define nonaktif 1
;/*Fungsi cek penekanan keypad*/
;char keypad() {
; 0000 0082 char keypad() {
; 0000 0083     char out = '\0';
; 0000 0084 
; 0000 0085     if((millis() - lastDebounceTime) > debounceDelay) { // Jika ada penekanan keypad
;	out -> R17
; 0000 0086         lastDebounceTime = millis();
; 0000 0087 
; 0000 0088         PORTA.7=aktif;
; 0000 0089         PORTA.6=nonaktif;
; 0000 008A         PORTA.5=nonaktif;
; 0000 008B         PORTA.4=nonaktif;
; 0000 008C         delay_ms(20);
; 0000 008D         if (PINA.3==aktif) { lastDebounceTime = millis(); tekan = true; out = '1'; }
; 0000 008E         if (PINA.2==aktif) { lastDebounceTime = millis(); tekan = true; out = '2'; }
; 0000 008F         if (PINA.1==aktif) { lastDebounceTime = millis(); tekan = true; out = '3'; }
; 0000 0090 
; 0000 0091         PORTA.7=nonaktif;
; 0000 0092         PORTA.6=aktif;
; 0000 0093         PORTA.5=nonaktif;
; 0000 0094         PORTA.4=nonaktif;
; 0000 0095         delay_ms(20);
; 0000 0096         if (PINA.3==aktif) { lastDebounceTime = millis(); tekan = true; out = '4'; }
; 0000 0097         if (PINA.2==aktif) { lastDebounceTime = millis(); tekan = true; out = '5'; }
; 0000 0098         if (PINA.1==aktif) { lastDebounceTime = millis(); tekan = true; out = '6'; }
; 0000 0099 
; 0000 009A         PORTA.7=nonaktif;
; 0000 009B         PORTA.6=nonaktif;
; 0000 009C         PORTA.5=aktif;
; 0000 009D         PORTA.4=nonaktif;
; 0000 009E         delay_ms(20);
; 0000 009F         if (PINA.3==aktif) { lastDebounceTime = millis(); tekan = true; out = '7'; }
; 0000 00A0         if (PINA.2==aktif) { lastDebounceTime = millis(); tekan = true; out = '8'; }
; 0000 00A1         if (PINA.1==aktif) { lastDebounceTime = millis(); tekan = true; out = '9'; }
; 0000 00A2 
; 0000 00A3         PORTA.7=nonaktif;
; 0000 00A4         PORTA.6=nonaktif;
; 0000 00A5         PORTA.5=nonaktif;
; 0000 00A6         PORTA.4=aktif;
; 0000 00A7         delay_ms(20);
; 0000 00A8         if (PINA.3==aktif) { lastDebounceTime = millis(); tekan = true; out = '*'; }
; 0000 00A9         if (PINA.2==aktif) { lastDebounceTime = millis(); tekan = true; out = '0'; }
; 0000 00AA         if (PINA.1==aktif) { lastDebounceTime = millis(); tekan = true; out = '#'; }
; 0000 00AB 
; 0000 00AC         PORTA.6=nonaktif;
; 0000 00AD         PORTA.5=nonaktif;
; 0000 00AE         PORTA.4=nonaktif;
; 0000 00AF         PORTA.7=nonaktif;
; 0000 00B0         delay_ms(20);
; 0000 00B1 
; 0000 00B2 //        tekan = true;
; 0000 00B3         return out;
; 0000 00B4      }
; 0000 00B5 }
;
;/*Fungsi untuk menghitung watt*/
;float CalcWatt(float input) {
; 0000 00B8 float CalcWatt(float input) {
; 0000 00B9     float watt;
; 0000 00BA     watt = ACInput * input;
;	input -> Y+4
;	watt -> Y+0
; 0000 00BB     return watt;
; 0000 00BC }
;
;int calibrate() {
; 0000 00BE int calibrate() {
_calibrate:
; 0000 00BF 	int acc = 0;
; 0000 00C0     int i = 0;
; 0000 00C1 	for (i = 0; i < 10; i++) {
	CALL SUBOPT_0x2
;	acc -> R16,R17
;	i -> R18,R19
_0x46:
	__CPWRN 18,19,10
	BRGE _0x47
; 0000 00C2 		acc += read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
	__ADDWRR 16,17,30,31
; 0000 00C3 	}
	__ADDWRN 18,19,1
	RJMP _0x46
_0x47:
; 0000 00C4 	zero = acc / 10;
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOVW R4,R30
; 0000 00C5 	return zero;
	MOVW R30,R4
	CALL __LOADLOCR4
_0x20C0008:
	ADIW R28,4
	RET
; 0000 00C6 }
;
;/*Inisialisasi Variabel Sensor arus*/
;int acscount = 0;
;#define maxacscount 20
;
;/*Fungsi untuk membaca sensor arus ACS*/
;float readACS() {
; 0000 00CD float readACS() {
_readACS:
; 0000 00CE     float adc_volt;
; 0000 00CF //    float amp = 0;
; 0000 00D0 //    float temps;
; 0000 00D1 
; 0000 00D2 	int acc = 0;
; 0000 00D3     int i = 0;
; 0000 00D4 	for (i = 0; i < 10; i++) {
	SBIW R28,4
	CALL SUBOPT_0x2
;	adc_volt -> Y+4
;	acc -> R16,R17
;	i -> R18,R19
_0x49:
	__CPWRN 18,19,10
	BRGE _0x4A
; 0000 00D5 		acc += read_adc(0) - zero;
	LDI  R26,LOW(0)
	RCALL _read_adc
	SUB  R30,R4
	SBC  R31,R5
	__ADDWRR 16,17,30,31
; 0000 00D6 	}
	__ADDWRN 18,19,1
	RJMP _0x49
_0x4A:
; 0000 00D7 	adc_volt = (float)acc / 10.0 / ADC_SCALE * VREF / sensitivity;
	MOVW R30,R16
	CALL SUBOPT_0x3
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x4
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x447FC000
	CALL __DIVF21
	__GETD2N 0x40A00000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_sensitivity
	LDS  R31,_sensitivity+1
	LDS  R22,_sensitivity+2
	LDS  R23,_sensitivity+3
	CALL __DIVF21
	CALL SUBOPT_0x5
; 0000 00D8 
; 0000 00D9 //    for (acscount = 0; acscount < maxacscount; acscount++) { amp += read_adc(0); } // Sampling pembacaan sensor sebanyak 20x
; 0000 00DA //    amp /= maxacscount;
; 0000 00DB //    temps = amp *(DCRef/1023);
; 0000 00DC //    adc_volt = fabs(temps-(DCRef/2))/0.066; //0.066 di dapat dari data sheet
; 0000 00DD 
; 0000 00DE     return adc_volt;
	CALL SUBOPT_0x6
	CALL __LOADLOCR4
	ADIW R28,8
	RET
; 0000 00DF }
;
;/*Inisialisasi Variabel Sensor arus*/
;float arus1, vout1;
;int adc1, count, dataMin, dataMax;
;
;/*Fungsi membaca sensor arus ACS dengan nilai tertinggi saja*/
;unsigned char readACSMAX() {
; 0000 00E6 unsigned char readACSMAX() {
; 0000 00E7     for ( count = 0; count <= 1000; count++) { // sampling pembacaan sensor arus sebanyak 1000x
; 0000 00E8         adc1 = read_adc(0);
; 0000 00E9         if ( adc1 >= dataMax ) dataMax = adc1;
; 0000 00EA         if ( adc1 <= dataMin ) dataMin = adc1;
; 0000 00EB         delay_ms(1);
; 0000 00EC     }
; 0000 00ED     vout1 = dataMax*(DCRef/1023);
; 0000 00EE     arus1 = fabs(vout1-(DCRef/2))/0.066;
; 0000 00EF 
; 0000 00F0     return arus1;
; 0000 00F1 }
;
;int prev_res=0, prev_err_1=0, prev_err_2=0, total_err=0;  // PI Control Variables
;/*Fungsi untuk perhitungan PI*/
;void PIControl(unsigned int sensor_val) {
; 0000 00F5 void PIControl(unsigned int sensor_val) {
; 0000 00F6 //    unsigned char data[16];
; 0000 00F7     int motor_res,err_func;
; 0000 00F8     float KonstP;
; 0000 00F9     long KonstI;
; 0000 00FA     long cont_res;
; 0000 00FB     err_func = Arus - sensor_val; //  Get the Error Function
;	sensor_val -> Y+16
;	motor_res -> R16,R17
;	err_func -> R18,R19
;	KonstP -> Y+12
;	KonstI -> Y+8
;	cont_res -> Y+4
; 0000 00FC     KonstP = Kp * (err_func); //Kp;
; 0000 00FD     KonstI = Ki * (err_func + total_err); //Ki;
; 0000 00FE     // Menghitung output dari nilai KP dan KI
; 0000 00FF 
; 0000 0100     cont_res=(float)(prev_res + KonstP + KonstI);
; 0000 0101 
; 0000 0102     // Membatasi output kecepatan motor
; 0000 0103     motor_res=(int)cont_res;
; 0000 0104     if (motor_res > MaxSpeed) motor_res = MaxSpeed;
; 0000 0105     if (motor_res < 0) motor_res = 0;
; 0000 0106 
; 0000 0107 
; 0000 0108     // Menyimpan nilai error function terbaru
; 0000 0109     prev_res=motor_res;
; 0000 010A     prev_err_2=prev_err_1;
; 0000 010B     prev_err_1=err_func;
; 0000 010C     total_err+=err_func;
; 0000 010D     countpwm-=motor_res;
; 0000 010E 
; 0000 010F //    lcd_gotoxy(0,0); lcd_puts("         ");
; 0000 0110 //    lcd_gotoxy(0,0); sprintf(data, "R: %d", motor_res); lcd_puts(data);
; 0000 0111 //    lcd_gotoxy(0,1); lcd_puts("         ");
; 0000 0112 //    lcd_gotoxy(0,1); sprintf(data, "A: %d", sensor_val); lcd_puts(data);
; 0000 0113 }
;
;/*Inisialisasi Variabel untuk update nilai parameter*/
;int buttonstate = 0;
;int lastbuttonstate = 0;
;int pos = 0;
;bool pressed = false;
;bool blink = false;
;bool koma = false;
;char savedkey = '0';

	.DSEG
;unsigned char data[16];
;volatile unsigned long millis_cek;
;char Kp_Temp[];
;char Ki_Temp[];
;char Arus_Temp[5];
;/*Fungsi untuk set parameter*/
;void SetParameter() {
; 0000 0123 void SetParameter() {

	.CSEG
; 0000 0124 /*Update nilai arus*/
; 0000 0125     lcd_clear();
; 0000 0126     memset(Arus_Temp, 0, sizeof(Arus_Temp));
; 0000 0127     lcd_gotoxy(0,0); lcd_putsf("SET I  :      mA");
; 0000 0128     lcd_gotoxy(0,1); lcd_putsf("*:,"); lcd_gotoxy(11,1); lcd_putsf("#:Clr");
; 0000 0129     lastkeyupdate = '\0';
; 0000 012A     keyupdate = '\0';
; 0000 012B     pos = 9;
; 0000 012C     // looping set nilai arus motor
; 0000 012D     do {
; 0000 012E         if(millis() - millis_cek >= 50) {
; 0000 012F             millis_cek = millis();
; 0000 0130             keyupdate = keypad();
; 0000 0131             if(tekan == true) { // Jika ada penekanan keypad
; 0000 0132                 if(pos < 13) {
; 0000 0133                     if((keyupdate >= 48) && (keyupdate <= 57)) {
; 0000 0134                         lastkeyupdate = keyupdate;
; 0000 0135                         savedkey = keyupdate;
; 0000 0136                         lcd_gotoxy(pos,0); lcd_putchar(savedkey);
; 0000 0137                         Arus_Temp[pos-9] = savedkey;
; 0000 0138 //                        if(keyupdate == '*') { lcd_gotoxy(pos,0); lcd_putchar(','); }
; 0000 0139                         pos++;
; 0000 013A                     }
; 0000 013B                 }
; 0000 013C                 if(keyupdate == '#') {
; 0000 013D                     memset(Arus_Temp, 0, sizeof(Arus_Temp));
; 0000 013E                     lcd_gotoxy(9,0); lcd_puts("     mA");
; 0000 013F                     pos = 9;
; 0000 0140                 }
; 0000 0141                 tekan = false;
; 0000 0142             }
; 0000 0143         }
; 0000 0144 
; 0000 0145         if(millis() - lastmillis_value >= 500) { // Untuk membuat kursor '_' berkedip
; 0000 0146             lastmillis_value = millis();
; 0000 0147             if(pos < 13) {
; 0000 0148                 if(blink) { lcd_gotoxy(pos,0); lcd_putchar(' '); }
; 0000 0149                 else { lcd_gotoxy(pos,0); lcd_putchar('_'); }
; 0000 014A                 blink = !blink;
; 0000 014B             }
; 0000 014C         }
; 0000 014D 
; 0000 014E         buttonstate = startt;
; 0000 014F         if (buttonstate != lastbuttonstate) { // Jika yang ditekan tombol start, maka keluar dari loop
; 0000 0150             if (startt == ditekan) { pressed = true; }
; 0000 0151         }
; 0000 0152         lastbuttonstate = buttonstate;
; 0000 0153     } while(pressed == false);
; 0000 0154     pressed = false;
; 0000 0155     Arus = atoi(Arus_Temp);
; 0000 0156     lcd_clear();
; 0000 0157     lcd_gotoxy(0,0); lcd_putsf("ARUS = ");
; 0000 0158     lcd_gotoxy(8,0); sprintf(data, "%d mA", Arus); lcd_puts(data);
; 0000 0159     memset(Arus_Temp, 0, sizeof(Arus_Temp));
; 0000 015A     delay_ms(2000);
; 0000 015B 
; 0000 015C /*Update nilai Kp*/
; 0000 015D     koma = false;
; 0000 015E     memset(Kp_Temp, 0, sizeof(Kp_Temp));
; 0000 015F     lcd_clear();
; 0000 0160     lcd_gotoxy(0,0); lcd_putsf("SET Kp : ");
; 0000 0161     lcd_gotoxy(0,1); lcd_putsf("*:,"); lcd_gotoxy(11,1); lcd_putsf("#:Clr");
; 0000 0162     lastkeyupdate = '\0';
; 0000 0163     keyupdate = '\0';
; 0000 0164     savedkey = '0';
; 0000 0165     pos = 9;
; 0000 0166 // looping set nilai Kp
; 0000 0167     do {
; 0000 0168         if(millis() - millis_cek >= 50) {
; 0000 0169             millis_cek = millis();
; 0000 016A             keyupdate = keypad();
; 0000 016B             if(tekan == true) { // Jika ada penekanan keypad
; 0000 016C                 if(pos < 13) {
; 0000 016D                     if((keyupdate >= 48) && (keyupdate <= 57)) {
; 0000 016E                         lastkeyupdate = keyupdate;
; 0000 016F                         savedkey = keyupdate;
; 0000 0170                     }
; 0000 0171                     else if((keyupdate == '*') && (koma == false)) {
; 0000 0172                         koma = true;
; 0000 0173                         savedkey = '.';
; 0000 0174                     }
; 0000 0175                     lcd_gotoxy(pos,0); lcd_putchar(savedkey);
; 0000 0176                     Kp_Temp[pos-9] = savedkey;
; 0000 0177                     pos++;
; 0000 0178                 }
; 0000 0179 
; 0000 017A                 if(keyupdate == '#') {
; 0000 017B                     memset(Kp_Temp, 0, sizeof(Kp_Temp));
; 0000 017C                     koma = false;
; 0000 017D                     lcd_gotoxy(9,0); lcd_puts("       ");
; 0000 017E                     pos = 9;
; 0000 017F                 }
; 0000 0180                 tekan = false;
; 0000 0181             }
; 0000 0182         }
; 0000 0183 
; 0000 0184         if(millis() - lastmillis_value >= 500) { // Untuk membuat kursor '_' berkedip
; 0000 0185             lastmillis_value = millis();
; 0000 0186             if(pos < 13) {
; 0000 0187                 if(blink) { lcd_gotoxy(pos,0); lcd_putchar(' '); }
; 0000 0188                 else { lcd_gotoxy(pos,0); lcd_putchar('_'); }
; 0000 0189                 blink = !blink;
; 0000 018A             }
; 0000 018B         }
; 0000 018C 
; 0000 018D         buttonstate = startt;
; 0000 018E         if (buttonstate != lastbuttonstate) { // Jika yang ditekan tombol start, maka keluar dari loop
; 0000 018F             if (startt == ditekan) {
; 0000 0190                 pressed = true;
; 0000 0191             }
; 0000 0192         }
; 0000 0193         lastbuttonstate = buttonstate;
; 0000 0194     } while(pressed == false);
; 0000 0195     pressed = false;
; 0000 0196     Kp = atof(Kp_Temp);
; 0000 0197     lcd_clear();
; 0000 0198     lcd_gotoxy(0,0); lcd_putsf("  Kp = ");
; 0000 0199     lcd_gotoxy(8,0); sprintf(data, "%0.2f", Kp); lcd_puts(data);
; 0000 019A     lcd_gotoxy(8,1); lcd_puts(Kp_Temp);
; 0000 019B     memset(Kp_Temp, 0, sizeof(Kp_Temp));
; 0000 019C     delay_ms(2000);
; 0000 019D 
; 0000 019E /*Update nilai Ki*/
; 0000 019F     koma = false;
; 0000 01A0     memset(Ki_Temp, 0, sizeof(Ki_Temp));
; 0000 01A1     lcd_clear();
; 0000 01A2     lcd_gotoxy(0,0); lcd_putsf("SET Ki : ");
; 0000 01A3     lcd_gotoxy(0,1); lcd_putsf("*:,"); lcd_gotoxy(11,1); lcd_putsf("#:Clr");
; 0000 01A4     lastkeyupdate = '\0';
; 0000 01A5     keyupdate = '\0';
; 0000 01A6     pos = 9;
; 0000 01A7 // looping set nilai Kp
; 0000 01A8     do {
; 0000 01A9         if(millis() - millis_cek >= 250) {
; 0000 01AA             millis_cek = millis();
; 0000 01AB             keyupdate = keypad();
; 0000 01AC             if(tekan == true) { // Jika ada penekanan keypad
; 0000 01AD                 if(pos < 14) {
; 0000 01AE                     if((keyupdate >= 48) && (keyupdate <= 57)) {
; 0000 01AF                         lastkeyupdate = keyupdate;
; 0000 01B0                         savedkey = keyupdate;
; 0000 01B1                         lcd_gotoxy(pos,0); lcd_putchar(savedkey);
; 0000 01B2                     }
; 0000 01B3                     else if((keyupdate == '*') && (koma == false)) {
; 0000 01B4                         koma = true;
; 0000 01B5                         savedkey = '.';
; 0000 01B6                         lcd_gotoxy(pos,0); lcd_putchar(savedkey);
; 0000 01B7                     }
; 0000 01B8                     Ki_Temp[pos-9] = savedkey;
; 0000 01B9                     pos++;
; 0000 01BA                 }
; 0000 01BB 
; 0000 01BC                 if(keyupdate == '#') {
; 0000 01BD                     koma = false;
; 0000 01BE                     memset(Ki_Temp, 0, sizeof(Ki_Temp));
; 0000 01BF                     lcd_gotoxy(9,0); lcd_puts("       ");
; 0000 01C0                     pos = 9;
; 0000 01C1                 }
; 0000 01C2                 tekan = false;
; 0000 01C3             }
; 0000 01C4         }
; 0000 01C5 
; 0000 01C6         if(millis() - lastmillis_value >= 500) { // Untuk membuat kursor '_' berkedip
; 0000 01C7             lastmillis_value = millis();
; 0000 01C8             if(pos < 13) {
; 0000 01C9                 if(blink) { lcd_gotoxy(pos,0); lcd_putchar(' '); }
; 0000 01CA                 else { lcd_gotoxy(pos,0); lcd_putchar('_'); }
; 0000 01CB                 blink = !blink;
; 0000 01CC             }
; 0000 01CD         }
; 0000 01CE 
; 0000 01CF         buttonstate = startt;
; 0000 01D0         if (buttonstate != lastbuttonstate) { // Jika yang ditekan tombol start, maka keluar dari loop
; 0000 01D1             if (startt == ditekan) {
; 0000 01D2                 pressed = true;
; 0000 01D3             }
; 0000 01D4         }
; 0000 01D5         lastbuttonstate = buttonstate;
; 0000 01D6     } while(pressed == false);
; 0000 01D7     pressed = false;
; 0000 01D8     Ki = atof(Ki_Temp);
; 0000 01D9     lcd_clear();
; 0000 01DA     lcd_gotoxy(0,0); lcd_putsf("  Ki = ");
; 0000 01DB     lcd_gotoxy(8,0); sprintf(data, "%0.2f", Ki); lcd_puts(data);
; 0000 01DC     lcd_gotoxy(8,1); lcd_puts(Ki_Temp);
; 0000 01DD     memset(Ki_Temp, 0, sizeof(Ki_Temp));
; 0000 01DE     delay_ms(2000);
; 0000 01DF }

	.DSEG
_0x5D:
	.BYTE 0x18
;
;/*Fungsi untuk kirim data via serial*/
;void UART_TxChar(char ch) {
; 0000 01E2 void UART_TxChar(char ch) {

	.CSEG
_UART_TxChar:
; 0000 01E3 	while (! (UCSRA & (1<<UDRE)));	/* Menunggu buffer transmit kosong*/
	ST   -Y,R26
;	ch -> Y+0
_0x8C:
	SBIS 0xB,5
	RJMP _0x8C
; 0000 01E4 	UDR = ch ;
	LD   R30,Y
	OUT  0xC,R30
; 0000 01E5 }
	JMP  _0x20C0006
;
;void UART_SendString(char *str) {
; 0000 01E7 void UART_SendString(char *str) {
_UART_SendString:
; 0000 01E8 	unsigned char j=0;
; 0000 01E9 	while (str[j]!=0) { /*Kirim data*/
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
;	*str -> Y+1
;	j -> R17
	LDI  R17,0
_0x8F:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R30,X
	CPI  R30,0
	BREQ _0x91
; 0000 01EA 		UART_TxChar(str[j]);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	RCALL _UART_TxChar
; 0000 01EB 		j++;
	SUBI R17,-1
; 0000 01EC 	}
	RJMP _0x8F
_0x91:
; 0000 01ED }
	JMP  _0x20C0007
;
;/*Fungsi utama*/
;void main(void)
; 0000 01F1 {
_main:
; 0000 01F2 // Declare your local variables here
; 0000 01F3     unsigned char data[16];
; 0000 01F4     float ACSVal = 0;
; 0000 01F5 // Input/Output Ports initialization
; 0000 01F6 // Port A initialization
; 0000 01F7 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01F8 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01F9 //PORTA=0x00;
; 0000 01FA //DDRA=0x00;
; 0000 01FB 
; 0000 01FC // Input/Output Ports initialization
; 0000 01FD // Port A initialization
; 0000 01FE // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 01FF // State7=0 State6=0 State5=0 State4=0 State3=P State2=P State1=P State0=T
; 0000 0200 PORTA=0x0E;
	SBIW R28,20
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
;	data -> Y+4
;	ACSVal -> Y+0
	LDI  R30,LOW(14)
	OUT  0x1B,R30
; 0000 0201 DDRA=0xF0;
	LDI  R30,LOW(240)
	OUT  0x1A,R30
; 0000 0202 
; 0000 0203 // Port B initialization
; 0000 0204 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0205 // State7=T State6=T State5=T State4=T State3=T State2=P State1=T State0=T
; 0000 0206 PORTB=0x04;
	LDI  R30,LOW(4)
	OUT  0x18,R30
; 0000 0207 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 0208 
; 0000 0209 // Port C initialization
; 0000 020A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 020B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 020C PORTC=0x00;
	OUT  0x15,R30
; 0000 020D DDRC=0x00;
	OUT  0x14,R30
; 0000 020E 
; 0000 020F // Port D initialization
; 0000 0210 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 0211 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=P State1=P State0=P
; 0000 0212 PORTD=0x07;
	LDI  R30,LOW(7)
	OUT  0x12,R30
; 0000 0213 DDRD=0xF8;
	LDI  R30,LOW(248)
	OUT  0x11,R30
; 0000 0214 
; 0000 0215 // Timer/Counter 0 initialization
; 0000 0216 // Clock source: System Clock
; 0000 0217 // Clock value: 172.800 kHz
; 0000 0218 // Mode: CTC top=OCR0
; 0000 0219 // OC0 output: Disconnected
; 0000 021A TCCR0=0x0B;
	LDI  R30,LOW(11)
	OUT  0x33,R30
; 0000 021B TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 021C OCR0=0xAC;
	LDI  R30,LOW(172)
	OUT  0x3C,R30
; 0000 021D 
; 0000 021E // Timer/Counter 1 initialization
; 0000 021F // Clock source: System Clock
; 0000 0220 // Clock value: Timer1 Stopped
; 0000 0221 // Mode: Normal top=0xFFFF
; 0000 0222 // OC1A output: Discon.
; 0000 0223 // OC1B output: Discon.
; 0000 0224 // Noise Canceler: Off
; 0000 0225 // Input Capture on Falling Edge
; 0000 0226 // Timer1 Overflow Interrupt: Off
; 0000 0227 // Input Capture Interrupt: Off
; 0000 0228 // Compare A Match Interrupt: Off
; 0000 0229 // Compare B Match Interrupt: Off
; 0000 022A TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 022B TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 022C TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 022D TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 022E ICR1H=0x00;
	OUT  0x27,R30
; 0000 022F ICR1L=0x00;
	OUT  0x26,R30
; 0000 0230 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0231 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0232 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0233 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0234 
; 0000 0235 // Timer/Counter 2 initialization
; 0000 0236 // Clock source: System Clock
; 0000 0237 // Clock value: 11059.200 kHz
; 0000 0238 // Mode: Fast PWM top=0xFF
; 0000 0239 // OC2 output: Non-Inverted PWM
; 0000 023A ASSR=0x00;
	OUT  0x22,R30
; 0000 023B TCCR2=0x69;
	LDI  R30,LOW(105)
	OUT  0x25,R30
; 0000 023C TCNT2=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 023D OCR2=0x00;
	OUT  0x23,R30
; 0000 023E 
; 0000 023F // External Interrupt(s) initialization
; 0000 0240 // INT0: Off
; 0000 0241 // INT1: Off
; 0000 0242 // INT2: On
; 0000 0243 // INT2 Mode: Rising Edge
; 0000 0244 GICR|=0x20;
	IN   R30,0x3B
	ORI  R30,0x20
	OUT  0x3B,R30
; 0000 0245 MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 0246 MCUCSR=0x40;
	LDI  R30,LOW(64)
	OUT  0x34,R30
; 0000 0247 GIFR=0x20;
	LDI  R30,LOW(32)
	OUT  0x3A,R30
; 0000 0248 
; 0000 0249 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 024A TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 024B 
; 0000 024C // USART initialization
; 0000 024D // USART disabled
; 0000 024E //UCSRB=0x00;
; 0000 024F 
; 0000 0250 // USART initialization
; 0000 0251 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0252 // USART Receiver: Off
; 0000 0253 // USART Transmitter: On
; 0000 0254 // USART Mode: Asynchronous
; 0000 0255 // USART Baud Rate: 9600
; 0000 0256 UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0257 UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0258 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0259 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 025A UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 025B 
; 0000 025C // Analog Comparator initialization
; 0000 025D // Analog Comparator: Off
; 0000 025E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 025F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0260 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0261 
; 0000 0262 // ADC initialization
; 0000 0263 // ADC Clock frequency: 691.200 kHz
; 0000 0264 // ADC Voltage Reference: AREF pin
; 0000 0265 // ADC Auto Trigger Source: ADC Stopped
; 0000 0266 // Only the 8 most significant bits of
; 0000 0267 // the AD conversion result are used
; 0000 0268 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0269 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 026A 
; 0000 026B // SPI initialization
; 0000 026C // SPI disabled
; 0000 026D SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 026E 
; 0000 026F // TWI initialization
; 0000 0270 // TWI disabled
; 0000 0271 TWCR=0x00;
	OUT  0x36,R30
; 0000 0272 
; 0000 0273 /* Enable global interrupt */
; 0000 0274     #asm("sei")
	sei
; 0000 0275 
; 0000 0276 // Alphanumeric LCD initialization
; 0000 0277 // Connections are specified in the
; 0000 0278 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0279 // RS - PORTC Bit 0
; 0000 027A // RD - PORTC Bit 1
; 0000 027B // EN - PORTC Bit 2
; 0000 027C // D4 - PORTC Bit 4
; 0000 027D // D5 - PORTC Bit 5
; 0000 027E // D6 - PORTC Bit 6
; 0000 027F // D7 - PORTC Bit 7
; 0000 0280 // Characters/line: 16
; 0000 0281 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0282 lcd_gotoxy(0,0); lcd_putsf("  SOFT STARTER  ");
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
	__POINTW2FN _0x0,91
	RCALL _lcd_putsf
; 0000 0283 lcd_gotoxy(0,1); lcd_putsf("  MOTOR 1 FASA  ");
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
	__POINTW2FN _0x0,108
	RCALL _lcd_putsf
; 0000 0284 delay_ms(2000);
	LDI  R26,LOW(2000)
	LDI  R27,HIGH(2000)
	CALL _delay_ms
; 0000 0285 calibrate();
	RCALL _calibrate
; 0000 0286 lcd_clear();
	RCALL _lcd_clear
; 0000 0287 countpwm = 200;
	LDI  R30,LOW(200)
	MOV  R13,R30
; 0000 0288 lcd_clear();
	RCALL _lcd_clear
; 0000 0289 lcd_gotoxy(0,0); lcd_puts("ARUS : ");
	LDI  R30,LOW(0)
	CALL SUBOPT_0x8
	__POINTW2MN _0x92,0
	RCALL _lcd_puts
; 0000 028A lcd_gotoxy(0,1); lcd_puts("PWM  : ");
	LDI  R30,LOW(0)
	CALL SUBOPT_0x9
	__POINTW2MN _0x92,8
	RCALL _lcd_puts
; 0000 028B while (1)
_0x93:
; 0000 028C       {
; 0000 028D       // Place your code here
; 0000 028E           Cek_Interrupt(); // Memanggil fungsi Cek_Interrupt()
	RCALL _Cek_Interrupt
; 0000 028F           if(millis() - lastmillis_value >= 1000) { // Update LCD, kirim data serial dan Fungsi PIControl() setiap 1 detik
	RCALL _millis
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_lastmillis_value
	LDS  R31,_lastmillis_value+1
	LDS  R22,_lastmillis_value+2
	LDS  R23,_lastmillis_value+3
	CALL __SUBD21
	__CPD2N 0x3E8
	BRSH PC+3
	JMP _0x96
; 0000 0290             lastmillis_value = millis();
	RCALL _millis
	STS  _lastmillis_value,R30
	STS  _lastmillis_value+1,R31
	STS  _lastmillis_value+2,R22
	STS  _lastmillis_value+3,R23
; 0000 0291             if(countpwm >= 250) count++;
	LDI  R30,LOW(250)
	CP   R13,R30
	BRLO _0x97
	LDI  R26,LOW(_count)
	LDI  R27,HIGH(_count)
	CALL SUBOPT_0xA
; 0000 0292             else countpwm = countpwm + 10;
	RJMP _0x98
_0x97:
	LDI  R30,LOW(10)
	ADD  R13,R30
; 0000 0293             //OCR2 = countpwm;
; 0000 0294             ACSVal = readACS();
_0x98:
	RCALL _readACS
	CALL SUBOPT_0x0
; 0000 0295             if(count > 3 ) { countpwm = 0; count = 0; }
	LDS  R26,_count
	LDS  R27,_count+1
	SBIW R26,4
	BRLT _0x99
	CLR  R13
	LDI  R30,LOW(0)
	STS  _count,R30
	STS  _count+1,R30
; 0000 0296             lcd_gotoxy(7,0); lcd_puts("        "); lcd_gotoxy(7,1); lcd_puts("        ");
_0x99:
	LDI  R30,LOW(7)
	CALL SUBOPT_0x8
	__POINTW2MN _0x92,16
	RCALL _lcd_puts
	LDI  R30,LOW(7)
	CALL SUBOPT_0x9
	__POINTW2MN _0x92,25
	RCALL _lcd_puts
; 0000 0297             lcd_gotoxy(7,0); sprintf(data, "%d", ACSVal); lcd_puts(data);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x8
	CALL SUBOPT_0xB
	CALL SUBOPT_0x6
	CALL SUBOPT_0xC
; 0000 0298             lcd_gotoxy(7,1); sprintf(data, "%d", countpwm); lcd_puts(data);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x9
	CALL SUBOPT_0xB
	MOV  R30,R13
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0xC
; 0000 0299             sprintf(data, "Sens ACS %0.1f|PWM %d", ACSVal, countpwm); UART_SendString(data); UART_SendString("\r\n"); // Kirim data via serial untuk monitoring
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,153
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x6
	CALL __PUTPARD1
	MOV  R30,R13
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	MOVW R26,R28
	ADIW R26,4
	RCALL _UART_SendString
	__POINTW2MN _0x92,34
	RCALL _UART_SendString
; 0000 029A           }
; 0000 029B       }
_0x96:
	RJMP _0x93
; 0000 029C }
_0x9A:
	RJMP _0x9A

	.DSEG
_0x92:
	.BYTE 0x25
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	ST   -Y,R26
	IN   R30,0x15
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x15,R30
	__DELAY_USB 7
	SBI  0x15,2
	__DELAY_USB 18
	CBI  0x15,2
	__DELAY_USB 18
	RJMP _0x20C0006
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 184
	RJMP _0x20C0006
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	CALL SUBOPT_0xD
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	CALL SUBOPT_0xD
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000005
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000004
_0x2000005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	SUBI R26,-LOW(1)
	STS  __lcd_y,R26
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000007
	RJMP _0x20C0006
_0x2000007:
_0x2000004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x20C0006
_lcd_puts:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2000008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2000008
_0x200000A:
	RJMP _0x20C0007
_lcd_putsf:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x200000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x200000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x200000B
_0x200000D:
_0x20C0007:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	IN   R30,0x14
	ORI  R30,LOW(0xF0)
	OUT  0x14,R30
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R26,LOW(20)
	LDI  R27,0
	CALL _delay_ms
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 276
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0006:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G101:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2020010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2020012
	__CPWRN 16,17,2
	BRLO _0x2020013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2020012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0xA
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2020014
	CALL SUBOPT_0xA
_0x2020014:
_0x2020013:
	RJMP _0x2020015
_0x2020010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2020015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__ftoe_G101:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL SUBOPT_0x7
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x2020019
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2020000,0
	CALL _strcpyf
	RJMP _0x20C0005
_0x2020019:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x2020018
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2020000,1
	CALL _strcpyf
	RJMP _0x20C0005
_0x2020018:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x202001B
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x202001B:
	LDD  R17,Y+11
_0x202001C:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x202001E
	CALL SUBOPT_0xF
	RJMP _0x202001C
_0x202001E:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x202001F
	LDI  R19,LOW(0)
	CALL SUBOPT_0xF
	RJMP _0x2020020
_0x202001F:
	LDD  R19,Y+11
	CALL SUBOPT_0x10
	BREQ PC+2
	BRCC PC+3
	JMP  _0x2020021
	CALL SUBOPT_0xF
_0x2020022:
	CALL SUBOPT_0x10
	BRLO _0x2020024
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	RJMP _0x2020022
_0x2020024:
	RJMP _0x2020025
_0x2020021:
_0x2020026:
	CALL SUBOPT_0x10
	BRSH _0x2020028
	CALL SUBOPT_0x11
	CALL SUBOPT_0x13
	CALL SUBOPT_0x14
	SUBI R19,LOW(1)
	RJMP _0x2020026
_0x2020028:
	CALL SUBOPT_0xF
_0x2020025:
	__GETD1S 12
	CALL SUBOPT_0x15
	CALL SUBOPT_0x14
	CALL SUBOPT_0x10
	BRLO _0x2020029
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
_0x2020029:
_0x2020020:
	LDI  R17,LOW(0)
_0x202002A:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x202002C
	__GETD2S 4
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x5
	CALL SUBOPT_0x6
	CALL SUBOPT_0x11
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2S 4
	CALL __MULF12
	CALL SUBOPT_0x11
	CALL SUBOPT_0x19
	CALL SUBOPT_0x14
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x202002A
	CALL SUBOPT_0x17
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x202002A
_0x202002C:
	CALL SUBOPT_0x1A
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x202002E
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x202010E
_0x202002E:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x202010E:
	ST   X,R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x1A
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0005:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
__print_G101:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2020030:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0xA
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2020032
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2020036
	CPI  R18,37
	BRNE _0x2020037
	LDI  R17,LOW(1)
	RJMP _0x2020038
_0x2020037:
	CALL SUBOPT_0x1B
_0x2020038:
	RJMP _0x2020035
_0x2020036:
	CPI  R30,LOW(0x1)
	BRNE _0x2020039
	CPI  R18,37
	BRNE _0x202003A
	CALL SUBOPT_0x1B
	RJMP _0x202010F
_0x202003A:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x202003B
	LDI  R16,LOW(1)
	RJMP _0x2020035
_0x202003B:
	CPI  R18,43
	BRNE _0x202003C
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003C:
	CPI  R18,32
	BRNE _0x202003D
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x2020035
_0x202003D:
	RJMP _0x202003E
_0x2020039:
	CPI  R30,LOW(0x2)
	BRNE _0x202003F
_0x202003E:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2020040
	ORI  R16,LOW(128)
	RJMP _0x2020035
_0x2020040:
	RJMP _0x2020041
_0x202003F:
	CPI  R30,LOW(0x3)
	BRNE _0x2020042
_0x2020041:
	CPI  R18,48
	BRLO _0x2020044
	CPI  R18,58
	BRLO _0x2020045
_0x2020044:
	RJMP _0x2020043
_0x2020045:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2020035
_0x2020043:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x2020046
	LDI  R17,LOW(4)
	RJMP _0x2020035
_0x2020046:
	RJMP _0x2020047
_0x2020042:
	CPI  R30,LOW(0x4)
	BRNE _0x2020049
	CPI  R18,48
	BRLO _0x202004B
	CPI  R18,58
	BRLO _0x202004C
_0x202004B:
	RJMP _0x202004A
_0x202004C:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x2020035
_0x202004A:
_0x2020047:
	CPI  R18,108
	BRNE _0x202004D
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x2020035
_0x202004D:
	RJMP _0x202004E
_0x2020049:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x2020035
_0x202004E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2020053
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1C
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1E
	RJMP _0x2020054
_0x2020053:
	CPI  R30,LOW(0x45)
	BREQ _0x2020057
	CPI  R30,LOW(0x65)
	BRNE _0x2020058
_0x2020057:
	RJMP _0x2020059
_0x2020058:
	CPI  R30,LOW(0x66)
	BREQ PC+3
	JMP _0x202005A
_0x2020059:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x1F
	CALL __GETD1P
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	LDD  R26,Y+13
	TST  R26
	BRMI _0x202005B
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x202005D
	RJMP _0x202005E
_0x202005B:
	CALL SUBOPT_0x22
	CALL __ANEGF1
	CALL SUBOPT_0x20
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x202005D:
	SBRS R16,7
	RJMP _0x202005F
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x1E
	RJMP _0x2020060
_0x202005F:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2020060:
_0x202005E:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x2020062
	CALL SUBOPT_0x22
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x2020063
_0x2020062:
	CALL SUBOPT_0x22
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G101
_0x2020063:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x23
	RJMP _0x2020064
_0x202005A:
	CPI  R30,LOW(0x73)
	BRNE _0x2020066
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
	RJMP _0x2020067
_0x2020066:
	CPI  R30,LOW(0x70)
	BRNE _0x2020069
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2020067:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x202006B
	CP   R20,R17
	BRLO _0x202006C
_0x202006B:
	RJMP _0x202006A
_0x202006C:
	MOV  R17,R20
_0x202006A:
_0x2020064:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x202006D
_0x2020069:
	CPI  R30,LOW(0x64)
	BREQ _0x2020070
	CPI  R30,LOW(0x69)
	BRNE _0x2020071
_0x2020070:
	ORI  R16,LOW(4)
	RJMP _0x2020072
_0x2020071:
	CPI  R30,LOW(0x75)
	BRNE _0x2020073
_0x2020072:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2020074
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x25
	LDI  R17,LOW(10)
	RJMP _0x2020075
_0x2020074:
	__GETD1N 0x2710
	CALL SUBOPT_0x25
	LDI  R17,LOW(5)
	RJMP _0x2020075
_0x2020073:
	CPI  R30,LOW(0x58)
	BRNE _0x2020077
	ORI  R16,LOW(8)
	RJMP _0x2020078
_0x2020077:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x20200B6
_0x2020078:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x202007A
	__GETD1N 0x10000000
	CALL SUBOPT_0x25
	LDI  R17,LOW(8)
	RJMP _0x2020075
_0x202007A:
	__GETD1N 0x1000
	CALL SUBOPT_0x25
	LDI  R17,LOW(4)
_0x2020075:
	CPI  R20,0
	BREQ _0x202007B
	ANDI R16,LOW(127)
	RJMP _0x202007C
_0x202007B:
	LDI  R20,LOW(1)
_0x202007C:
	SBRS R16,1
	RJMP _0x202007D
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x2020110
_0x202007D:
	SBRS R16,2
	RJMP _0x202007F
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL __CWD1
	RJMP _0x2020110
_0x202007F:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CLR  R22
	CLR  R23
_0x2020110:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2020081
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2020082
	CALL SUBOPT_0x22
	CALL __ANEGD1
	CALL SUBOPT_0x20
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2020082:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x2020083
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x2020084
_0x2020083:
	ANDI R16,LOW(251)
_0x2020084:
_0x2020081:
	MOV  R19,R20
_0x202006D:
	SBRC R16,0
	RJMP _0x2020085
_0x2020086:
	CP   R17,R21
	BRSH _0x2020089
	CP   R19,R21
	BRLO _0x202008A
_0x2020089:
	RJMP _0x2020088
_0x202008A:
	SBRS R16,7
	RJMP _0x202008B
	SBRS R16,2
	RJMP _0x202008C
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x202008D
_0x202008C:
	LDI  R18,LOW(48)
_0x202008D:
	RJMP _0x202008E
_0x202008B:
	LDI  R18,LOW(32)
_0x202008E:
	CALL SUBOPT_0x1B
	SUBI R21,LOW(1)
	RJMP _0x2020086
_0x2020088:
_0x2020085:
_0x202008F:
	CP   R17,R20
	BRSH _0x2020091
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2020092
	CALL SUBOPT_0x26
	BREQ _0x2020093
	SUBI R21,LOW(1)
_0x2020093:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2020092:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x1E
	CPI  R21,0
	BREQ _0x2020094
	SUBI R21,LOW(1)
_0x2020094:
	SUBI R20,LOW(1)
	RJMP _0x202008F
_0x2020091:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x2020095
_0x2020096:
	CPI  R19,0
	BREQ _0x2020098
	SBRS R16,3
	RJMP _0x2020099
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x202009A
_0x2020099:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x202009A:
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x202009B
	SUBI R21,LOW(1)
_0x202009B:
	SUBI R19,LOW(1)
	RJMP _0x2020096
_0x2020098:
	RJMP _0x202009C
_0x2020095:
_0x202009E:
	CALL SUBOPT_0x27
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20200A0
	SBRS R16,3
	RJMP _0x20200A1
	SUBI R18,-LOW(55)
	RJMP _0x20200A2
_0x20200A1:
	SUBI R18,-LOW(87)
_0x20200A2:
	RJMP _0x20200A3
_0x20200A0:
	SUBI R18,-LOW(48)
_0x20200A3:
	SBRC R16,4
	RJMP _0x20200A5
	CPI  R18,49
	BRSH _0x20200A7
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20200A6
_0x20200A7:
	RJMP _0x20200A9
_0x20200A6:
	CP   R20,R19
	BRSH _0x2020111
	CP   R21,R19
	BRLO _0x20200AC
	SBRS R16,0
	RJMP _0x20200AD
_0x20200AC:
	RJMP _0x20200AB
_0x20200AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20200AE
_0x2020111:
	LDI  R18,LOW(48)
_0x20200A9:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20200AF
	CALL SUBOPT_0x26
	BREQ _0x20200B0
	SUBI R21,LOW(1)
_0x20200B0:
_0x20200AF:
_0x20200AE:
_0x20200A5:
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x20200B1
	SUBI R21,LOW(1)
_0x20200B1:
_0x20200AB:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x27
	CALL __MODD21U
	CALL SUBOPT_0x20
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x25
	__GETD1S 16
	CALL __CPD10
	BREQ _0x202009F
	RJMP _0x202009E
_0x202009F:
_0x202009C:
	SBRS R16,0
	RJMP _0x20200B2
_0x20200B3:
	CPI  R21,0
	BREQ _0x20200B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1E
	RJMP _0x20200B3
_0x20200B5:
_0x20200B2:
_0x20200B6:
_0x2020054:
_0x202010F:
	LDI  R17,LOW(0)
_0x2020035:
	RJMP _0x2020030
_0x2020032:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x28
	SBIW R30,0
	BRNE _0x20200B7
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0004
_0x20200B7:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x28
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G101)
	LDI  R31,HIGH(_put_buff_G101)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G101
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG
_strcpyf:
	ST   -Y,R27
	ST   -Y,R26
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
_strlen:
	ST   -Y,R27
	ST   -Y,R26
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
_strlenf:
	ST   -Y,R27
	ST   -Y,R26
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

	.CSEG
_ftoa:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	CALL SUBOPT_0x7
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x206000D
	CALL SUBOPT_0x29
	__POINTW2FN _0x2060000,0
	CALL _strcpyf
	RJMP _0x20C0003
_0x206000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x206000C
	CALL SUBOPT_0x29
	__POINTW2FN _0x2060000,1
	CALL _strcpyf
	RJMP _0x20C0003
_0x206000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x206000F
	__GETD1S 9
	CALL __ANEGF1
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	LDI  R30,LOW(45)
	ST   X,R30
_0x206000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2060010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2060010:
	LDD  R17,Y+8
_0x2060011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2060013
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2D
	RJMP _0x2060011
_0x2060013:
	CALL SUBOPT_0x2E
	CALL __ADDF12
	CALL SUBOPT_0x2A
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	CALL SUBOPT_0x2D
_0x2060014:
	CALL SUBOPT_0x2E
	CALL __CMPF12
	BRLO _0x2060016
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x13
	CALL SUBOPT_0x2D
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2060017
	CALL SUBOPT_0x29
	__POINTW2FN _0x2060000,5
	CALL _strcpyf
	RJMP _0x20C0003
_0x2060017:
	RJMP _0x2060014
_0x2060016:
	CPI  R17,0
	BRNE _0x2060018
	CALL SUBOPT_0x2B
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2060019
_0x2060018:
_0x206001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x206001C
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x16
	CALL SUBOPT_0x15
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2E
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x18
	LDI  R31,0
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x3
	CALL __MULF12
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2A
	RJMP _0x206001A
_0x206001C:
_0x2060019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0002
	CALL SUBOPT_0x2B
	LDI  R30,LOW(46)
	ST   X,R30
_0x206001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2060020
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x13
	CALL SUBOPT_0x2A
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x18
	LDI  R31,0
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x3
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2A
	RJMP _0x206001E
_0x2060020:
_0x20C0002:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0003:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET

	.DSEG

	.CSEG

	.CSEG
_ftrunc:
	CALL __PUTPARD2
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
_floor:
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL SUBOPT_0x0
    brne __floor1
__floor0:
	CALL SUBOPT_0x1
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	CALL SUBOPT_0x1
	__GETD2N 0x3F800000
	CALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET

	.CSEG

	.DSEG
_sensitivity:
	.BYTE 0x4
_millis_value:
	.BYTE 0x4
_Kp:
	.BYTE 0x4
_Ki:
	.BYTE 0x4
_lastmillis_value:
	.BYTE 0x4
_lastDebounceTime:
	.BYTE 0x4
_arus1:
	.BYTE 0x4
_vout1:
	.BYTE 0x4
_adc1:
	.BYTE 0x2
_count:
	.BYTE 0x2
_dataMin:
	.BYTE 0x2
_dataMax:
	.BYTE 0x2
_prev_res:
	.BYTE 0x2
_prev_err_1:
	.BYTE 0x2
_prev_err_2:
	.BYTE 0x2
_total_err:
	.BYTE 0x2
_buttonstate:
	.BYTE 0x2
_lastbuttonstate:
	.BYTE 0x2
_pos:
	.BYTE 0x2
_blink:
	.BYTE 0x1
_koma:
	.BYTE 0x1
_savedkey:
	.BYTE 0x1
_data:
	.BYTE 0x10
_millis_cek:
	.BYTE 0x4
_Kp_Temp:
	.BYTE 0x1
_Ki_Temp:
	.BYTE 0x1
_Arus_Temp:
	.BYTE 0x5
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G103:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	CALL __SAVELOCR4
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 18,19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CALL __CWD1
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x4:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x6:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	ST   -Y,R30
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xA:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	MOVW R30,R28
	ADIW R30,4
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,150
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	MOVW R26,R28
	ADIW R26,4
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	CALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(48)
	CALL __lcd_write_nibble_G100
	__DELAY_USW 276
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xF:
	__GETD2S 4
	RCALL SUBOPT_0x4
	CALL __MULF12
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
	RCALL SUBOPT_0x6
	__GETD2S 12
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	__PUTD1S 12
	SUBI R19,-LOW(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x4
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x15:
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	__GETD1N 0x3DCCCCCD
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1C:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1D:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1F:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	RCALL SUBOPT_0x1C
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x1F
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x26:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2A:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	__GETD2S 9
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
	wdr
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

__SUBD21:
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R25,R23
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
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

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
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

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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

;END OF CODE MARKER
__END_OF_CODE:
