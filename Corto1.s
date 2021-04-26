; El programa consiste en ensender la luz blanca al mantener
; presionado el boton de PF4

;-------------------Define el uso de instrucciones THUMB-----------
		THUMB
;-----------Define area para datos de 4 bytes---------------
		AREA 	DATA, ALIGN=4 
;-----------Declarar Variables -------------------------
resultado	SPACE	4
;----------Define área de codigo, con capacidad de ser importado C---------
		AREA	|.text|, CODE, READONLY, ALIGN=2
;----------Declara la instrucción Start como Global-----------			
		EXPORT	Start
;----------------------Codigo------------------------------------


Start   
;---------Habilitar el reloj en perifericos---------
Int_PF		LDR R1, =0X400FE608
			LDR R0 , [R1]
			ORR R0, #0X02
			STR R0, [R1]
			NOP
			NOP
			NOP
;---------DESACTIVAR FUNCIONES ANALOGICAS AMSEL			
			LDR R1, =0X40025000; DIRECCION BASE PUERTO F
			LDR R0, [R1,#0X528]
			BIC R0, #0XFF
			STR R0, [R1,#0X528]
;--------ASIGNAR ENTRADAS Y SALIDAS, DIR---
			LDR R0, [R1, #0X400]
			ORR R0, #0X0E; 
			STR R0, [R1,#0X400]
;-----ASIGNAR FUNCION ALTERNATIVA,PCTL (GPI0 = 0)
			MOV R0, #0
			STR R0, [R1, #0X52C]
;-----DESABILITAR FUNCION ALTERNATIVA, AFSEL
			LDR R0, [R1, #0X420]
			BIC R0, #0XFF
			STR R0, [R1, #0X420]
;-------HABILITAR FUNCIONES DIGITALES, DEN
			LDR R0, [R1, #0X51C]
			ORR R0, #0X1A
			STR R0, [R1, #0X51C]
;-------HABILITAR RESISTENCIA PULL UP, PUR
			LDR R0, [R1, #0X510]
			ORR R0, #0X10
			STR R0, [R1, #0X510]

;-------Main---------


			LDR R1, =0X40025000; DIRECCION BASE PUERTO F
LEER		LDR R0, [R1, #0X3FC]
			CMP R0 , #0X10
			BNE LED_ON

LED_OFF		LDR R0, [R1, #0X3FC]
			BIC R0, #0X0E
			STR R0, [R1, #0X3FC]
			B LEER

LED_ON		LDR R0, [R1, #0X3FC]
			ORR R0, #0X0E
			STR R0, [R1, #0X3FC]
			B LEER
			
		ALIGN      
		END 