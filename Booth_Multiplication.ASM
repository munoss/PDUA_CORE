			JMP		CTE
			INIT_IF
Data_A	:	0x00				; Data_A inicializado en 0
Q		:	0xFD				; Valor de Q
M		:	0x07				; valor de M
Q1		:	0X00 				; Q-1 inicializado en 0
Count	:	0x00				; Valor de Count conforme el número de bits
INIT_VAR:	MOV		DPTR, CTE	; Inicializar Data_A
			Data_A		
			MOV 	ACC, CTE
			0x00
			MOV   	[DPTR], ACC
			MOV		DPTR, CTE	; Inicializar Q-1
			Q1		
			MOV 	ACC, CTE
			0x00
			MOV   	[DPTR], ACC
			MOV		DPTR, CTE	; Inicializar Count
			Count		
			MOV 	ACC, CTE
			0x08
			MOV   	[DPTR], ACC
INIT_IF:		MOV		DPTR, CTE	; Traer Q
			Q					
			MOV   	ACC, [DPTR]
			AND 	ACC, CTE	; Hacer AND de Q con 1 para enmasacara el último bit
			0x01				; El valor de Q enmascarado queda en ACC
			MOV		A, ACC		; Cargar el valor del LSB de Q a A
			MOV   	DPTR, CTE	; Apuntar a la dirección de Q-1 con el DPTR-
			Q1
			MOV   	ACC, [DPTR]	; Cargar el valor de Q-1 en ACC
			XOR		ACC, A 		; PARA SABER SI ES 11 O 00 (OBVIAMENTE GENERA FLAG)!!
			JZ		CTE			; Realizamos el Shift directamente
			SHIFT_QM1 			
			MOV		ACC, A		; Aqui se verifica si es el caso 10 O 01
			JZ		CTE
			SUM_01
DIF_10:		MOV 	DPTR, CTE	; Apuntar a la dirección de M con el DPTR
			M					; Dirección de M
			MOV		ACC, [DPTR]	; Cargar el valor de M al registro M
			MOV		A, ACC		; Treaer el valor del ACC al A
			MOV 	DPTR, CTE	; Apuntar a la dirección de Data_A con el DPTR
			Data_A				; Dirección de Data_A
			MOV		ACC, [DPTR]	; Cargar el valor de Data_A
			SUB		ACC, A 		; A-M 
			MOV		[DPTR], ACC ; GUARDAR EN MEMORIA A-M en Data_A			
			JMP		CTE
			ARIT_SHFT
SUM_01:		MOV 	DPTR, CTE	; Apuntar a la dirección de M con el DPTR
			M					; Dirección de M
			MOV		ACC, [DPTR]	; Cargar el valor de M al registro M
			MOV		A, ACC		; Treaer el valor del ACC al A
			MOV 	DPTR, CTE	; Cargar el dirección de Data_A al ACC
			Data_A				; Dirección de Data_A
			MOV		ACC, [DPTR]	; Cargar el valor de Data_A
			ADD		ACC, A 		; A+M 
			MOV		[DPTR], ACC ; GUARDAR EN MEMORIA A+M en Data_A
ARIT_SHFT:	MOV 	DPTR, CTE	; Apuntar a la direccion de Q con el DPTR
			Q					; Dirección de Q
			MOV		ACC, [DPTR]	; Cargar el valor de Q al registro ACC
			AND 	ACC, CTE	; Hacer AND de Q con 1 para enmasacara el LSB
			0x01				; El valor de Q enmascarado queda en ACC
			MOV 	DPTR, CTE	; Apuntar a la dirección Q1 con el DPTR
			Q1					; Dirección de Q1
			MOV		[DPTR], ACC ; Guardar en memoria el valor final de Q1
			MOV 	DPTR, CTE	; Apuntar a Q con el DPTR
			Q					; Dirección de Q
			MOV		ACC, [DPTR]	; Cargar el valor de Q al registro ACC
			LSR		ACC			; Se aplica el shift lógico para desplazar los bits a la derecha
			MOV		[DPTR], ACC ; Guardar en memoria el valor final de Q desplazado
			MOV 	DPTR, CTE	; Apuntar a la dirección de A con el DPTR
			Data_A				; Dirección de Data_A
			MOV		ACC, [DPTR]	; Cargar el valor de Data_A al ACC
			AND 	ACC, CTE	; Hacer AND de A con 1 para enmasacara el LSB (OBVIAMENTE GENERA FLAG)!!
			0x01				; El valor de Data_A enmascarado queda en ACC
			JZ		CTE
			A_MSB
			MOV 	ACC, CTE	; Cargar el valor constante 0x80 para la comparación en ACC
			0x80
			MOV 	A, ACC		; Guardar temporalmente el valor 0x80 en el registro A
			MOV 	DPTR, CTE	; Apuntar a la dirección de Q con el DPTR
			Q					; Dirección de Q
			MOV		ACC, [DPTR]	; Cargar el valor de Q al registro ACC
			OR	 	ACC, A		; Hacer OR de Q con 0x80 para concatenar el LSB de Data_A en el ACC
			MOV		[DPTR], ACC ; Guardar en memoria el valor final de Q desplazado
A_MSB:		MOV 	DPTR, CTE	; Apuntar a la dirección de Data_A con el DPTR
			Data_A				; Dirección de A
			MOV		ACC, [DPTR]	; Cargar el valor de Data_A al ACC
			MOV		A, ACC		; Copiar ACC en A para la comparacion
			AND 	ACC, CTE	; Hacer AND de A con 1 para enmasacara el último bit (OBVIAMENTE GENERA FLAG)
			0x80				; El valor de Data_A enmascarado queda en ACC
			SWAP		ACC, A		; Cambiamos el valor de A con el valor del ACC
			LSR		ACC			; Desplazamos el ACC a la derecha
			OR		ACC, A		; Agregamos con un OR el Bit 1 MSB con Data_A desplazado
			MOV		[DPTR], ACC ; Guardar en memoria el valor final de Data_A desplazado
COUNT_ACT:	MOV 	DPTR, CTE	; Cargar el dirección de Count en el DPTR
			Count				; Dirección de Count
			MOV		ACC, [DPTR]	; Cargar el valor de Count en el ACC
			ADD		ACC, CTE 	; Decrementar -1 Count y guardarlo en el ACC
			0xFF				
			MOV 	[DPTR], ACC	; Actualizar el valor de Count y guardarlo en su Registro
IF_OVER:		MOV		A, ACC		; Restar para activar la bandera de SUB
			JZ		CTE			; Si el flag es 1, Count ha llegado a 0, ejecutafin del programa
			FIN					
			JMP 	CTE			; Si el flag es 0, Count no ha llegado a 0, ejecuta de nuevo desde INIT_IF
			INIT_IF
FIN:			MOV 	DPTR, CTE	; Apuntar a la dirección de Data_A con el DPTR
			Data_A				; Dirección de A
			MOV		ACC, [DPTR]	; Cargar el valor de Data_A al ACC
			MOV		A, ACC		; Copiar ACC en A para la comparacion
			MOV 	DPTR, CTE	; Apuntae a la dirección de Q con el DPTR
			Q					; Dirección de Q
			MOV		ACC, [DPTR]	; Cargar el valor de Q al registro ACC
			HALT