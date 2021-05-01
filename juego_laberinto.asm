			.module	prueba5        	
			.area PROG (ABS)

         			; Inicio definicion de constantes
fin     	.equ 	0xFF01
teclado		.equ	0xFF02
pantalla 	.equ 	0xFF00
pilaU		.equ	0xF000
cadena2		.equ	0xE000
         			; Fin definicion de constantes
        	.org 	0x100	
        	.globl 	programa

menu:		.ascii	"\n\neliga una opcion\n\n"
			.ascii	"\na) elegir laberinto\n\n"
			.ascii	"\nb) jugar\n\n"       				;Menu que se muestra al usuario.
			.asciz	"\nc)salir\n\n"
opciona:	.asciz	"\neliga laberinto de 1 a 3\n"

error:	.asciz	"\t\t\tmovimiento imposible\n"			;Mensaje de error para cuando el usuario intenta atravesar una pared.
laberinto:	
		.ascii	"XXXXXXXXXX XXXXX\n"
		.ascii	"X   X X    X   X\n"
		.ascii	"X X   X XXXX X X\n"
		.ascii	"X XXX X X X  X X\n"
		.ascii	"X X X   X X XX X\n"
		.ascii	"X X XXX X      X\n"
		.ascii	"X X     XX XX XX\n"
		.ascii	"XXX XX XXX  X XX\n"					;Variable auxiliar con la que el usuario jugará.
		.ascii	"X   XX X    X  X\n"
		.ascii	"X X  X   XXXX XX\n"
		.ascii	"X XX X X X     X\n"
		.ascii	"X  X   X X XXXXX\n"
		.ascii	"XX X X X     X X\n"
		.ascii	"XXXX XXXXX X X X\n"
		.ascii	"X        X X   X\n"
		.ascii	"XXXXXXXXXX XXXXX\n"
		.byte	0

laberinto_numero:		.byte	3
laberinto1:	
		.ascii	"XXXXXXXXXX XXXXX"
		.ascii	"X   X X    X   X"
		.ascii	"X X   X XXXX X X"
		.ascii	"X XXX X X X  X X"
		.ascii	"X X X   X X XX X"
		.ascii	"X X XXX X      X"
		.ascii	"X X     XX XX XX"
		.ascii	"XXX XX XXX  X XX"						;Primer laberinto que el usuario puede jugar.
		.ascii	"X   XX X    X  X"
		.ascii	"X X  X   XXXX XX"
		.ascii	"X XX X X X     X"
		.ascii	"X  X   X X XXXXX"
		.ascii	"XX X X X     X X"
		.ascii	"XXXX XXXXX X X X"
		.ascii	"X        X X   X"
		.ascii	"XXXXXXXXXX XXXXX"
		.byte	0
laberinto2:
		.ascii	"X XXXXXXXXXXXXXX"
		.ascii	"X   X X    X   X"
		.ascii	"X X   X XXXX X X"
		.ascii	"X XXX X X X  X X"
		.ascii	"X   X   X X XX X"
		.ascii	"X X XXX X      X"
		.ascii	"X X     XX XX XX"
		.ascii	"XXX XX XXX  X XX"						;Segundo laberinto que el usuario puede jugar.
		.ascii	"X   XX X    X  X"	
		.ascii	"X X      XXXX XX"
		.ascii	"X XX X X X     X"
		.ascii	"X  X   X X XXXXX"
		.ascii	"XX X X X     X X"
		.ascii	"XXXX XXXXX X X X"
		.ascii	"X        X X   X"
		.ascii	"XX XXXXXXXXXXXXX"
		.byte	0
laberinto3:
		.ascii	"XXXXXXXXXXXXXX X"
		.ascii	"X   X X    X   X"
		.ascii	"X X   X XXXX X X"
		.ascii	"X XXX X X X  X X"
		.ascii	"X   X X X X XXXX"
		.ascii	"X X XXX        X"
		.ascii	"X X     XX XX XX"
		.ascii	"XXX XX XXX  X XX"						;Tercer laberinto que el usuario puede jugar.
		.ascii	"X   XXXX    X  X"
		.ascii	"X X      XXXX XX"
		.ascii	"X XX X X X     X"
		.ascii	"X  X   X X XXXXX"
		.ascii	"XX X X X     X X"
		.ascii	"XXXX XXXXX X X X"
		.ascii	"X        X X   X"
		.ascii	"XXXXXXXXXXXXXX X"
		.byte	0

posicion_jugador:	.word	0x0000						
pos_valida:			.word	0x0000						
num_de_lab:			.word	0x0000						
pos:				.word	0x0000						
lab_selec:			.word	1							
lab_terminado:		.asciz	"laberinto finalizado!!\n"	

;posicion_jugador: variable que guarda la posicion del jugador en el laberinto cuando este sale al menu.
;pos_valida: variable que guarda la posicion del jugador antes de hacer un salto en el laberinto y comprobar si hay una X.
;pos: variable flag que sirve para comprobar si el usuario a terminado un laberinto y mostrar un mensaje por pantalla.
;lab_selec: variable que guarda el numero de laberinto seleccionado para mostrarlo por pantalla.
;lab_terminado: cadena que se muestra al finalizar cualquiera de los laberintos.




programa:
		lds		pilaU									;inicia pila
menu_prin:
		ldx		#menu									;se imprime el menu
		jsr		imprime_cadena
bucle_elige:
		lda		teclado
		cmpa	#'a
		beq		opcion_a								;se lee la opcion elegida por el usuario.
		cmpa    #'b										
		beq		opcion_b
		cmpa	#'c
		beq		opcion_c
		bra		bucle_elige

opcion_a:												;el programa permite al usuario elegir laberinto.
		ldx		#opciona
		jsr		imprime_cadena
lee_op_a:
		ldd		#0
		std		posicion_jugador						
		std		pos	
		lda		teclado
		sta		lab_selec 								
		suba	#'0
		cmpa	#1
		beq		copia1
		cmpa	#2
		beq		copia2
		cmpa	#3
		beq		copia3
		bra		lee_op_a
copia1:
		lda		#'\n
		sta		pantalla
		ldy		#laberinto1
		jsr		copia_laberinto							;copia el laberinto 1.
		bra		menu_prin
copia2:
		lda		#'\n
		sta		pantalla
		ldy		#laberinto2
		jsr		copia_laberinto							;copia el laberinto 2.
		bra		menu_prin
copia3:
		lda		#'\n
		sta		pantalla
		ldy		#laberinto3
		jsr		copia_laberinto							;copia el laberinto 3.
		bra		menu_prin
		
opcion_c:
		jmp		acabar									;finaliza el programa.
opcion_b:
		ldx		posicion_jugador
		cmpx	#0										;comprueba si el usuario ya tenia una posicion en ese laberinto y le permite continuar por donde se quedó.
		bne		continua
		ldx		#laberinto								;imprime un primer laberinto sin el usuario colocado en él.
		jsr		imprime_cadena

		ldx		#laberinto
		ldb		#0

posicion:
		lda		,x+
		incb
		cmpb	#255									;se coloca en la ultima fila del laberinto para posicionar al jugador.
		beq		continua
		bra 	posicion

continua:

recorre:
		lda		,x+
		cmpa	#'X
		bne		coloca_jugador							;recorre toda la ultima fila en busca del espacio en blanco.
		bra		recorre

coloca_jugador:
		
		lda		#'O
		sta		,-x

		pshs	x
		ldx		#laberinto								;una vez localizado el espacio carga al usuario y imprime de nuevo el laberinto.
		jsr		imprime_cadena
		puls	x

lee:
		lda		teclado
		cmpa	#'w
		beq		mov_arriba
		cmpa	#'s
		beq		mov_abajo								;el programa espera la introducción de una tecla de movimiento válida.
		cmpa	#'a	
		beq		to_mov_izq
		cmpa    #'d
		beq		to_mov_der
		cmpa	#'q
		beq		to_acabar
		bra		lee

to_mov_izq:
		jmp		mov_izq									;salto a movimiento a la izquierda.
to_mov_der:
		jmp		mov_der									;salto a movimiento a la derecha.


mov_arriba:
		lda		#'.
		sta		,x
		stx		pos_valida								;carga un punto en la posicion del jugador y la guarda.
		ldb		#0

coloca:		
		lda		,-x
		incb		
		cmpb	#17										;se desplaza tantas posiciones como requiera el movimiento.
		beq		continua2
		bra		coloca

continua2:
		cmpa	#'.
		beq		continua2_1	
		cmpa	#'X
		bne		continua2_1
		pshs	x
		ldx		#error									;comprueba que el movimiento a realizar es posible, de lo contrario se lo indicara al usuario.
		jsr		imprime_cadena
		puls	x
		ldx		pos_valida
		jmp 	lee
		

continua2_1:
		lda		#'O
		sta		,x
		
		lda		#'\n
		sta		pantalla
		lda		lab_selec
		sta		pantalla								;carga al usuario en la nueva posicion e imprime el laberinto junto a su número.
		lda		#'\n
		sta		pantalla
		pshs	x
		ldx		#laberinto
		jsr		imprime_cadena
		jsr		fin_de_laberinto
		ldb		pos
		cmpb	#1
		lbeq	menu_prin
		puls	x

		bra		lee
to_acabar:
		stx		posicion_jugador						;al presionar la q el programa guarda la posicion actual del jugador y vuelve al menu principal.
		jmp		menu_prin

mov_abajo:
		lda		#'.
		sta		,x
		stx		pos_valida								;coloca un punto en la posicion del usuario y guarda la posicion actual.
		ldb		#0

coloca3:		
		lda		,x+
		incb		
		cmpb	#17
		beq		continua3								;se desplaza tantas posiciones como requiera el movimiento.
		bra		coloca3

continua3:
		cmpa	#'.
		beq		continua3_1	
		lda		,x+		;cambio
		cmpa	#'X
		bne		continua3_1								;comprueba que el movimiento es posible, si no lo es le avisa al usuario.
		pshs	x
		ldx		#error
		jsr		imprime_cadena
		puls	x
		ldx		pos_valida
		jmp 	lee

continua3_1:
		lda		,-x		;cambio
		lda		#'O
		sta		,x

		lda		#'\n
		sta		pantalla
		sta		pantalla								;situa al jugador en la nueva posicion y imprime el laberinto actualizado.
		lda		lab_selec
		sta		pantalla
		lda		#'\n
		sta		pantalla
		pshs	x
		ldx		#laberinto
		jsr		imprime_cadena
		puls	x

		jmp		lee
mov_izq:
		lda		#'.
		sta		,x
		stx		pos_valida								;coloca un punto en la posicion del usuario y guarda la posicion actual.
		ldb		#0

coloca4:		
		lda		,-x
		incb		
		cmpb	#1
		beq		continua4								;se desplaza tantas posiciones como requiera el movimiento.
		bra		coloca4

continua4:
		cmpa	#'.
		beq		continua4_1	
		cmpa	#'X
		bne		continua4_1
		pshs	x
		ldx		#error
		jsr		imprime_cadena							;comprueba que el movimiento es posible, si no lo es le avisa al usuario.
		puls	x
		ldx		pos_valida
		jmp 	lee
continua4_1:
		lda		#'O
		sta		,x

		lda		#'\n
		sta		pantalla
		sta		pantalla
		lda		lab_selec
		sta		pantalla								;situa al jugador en la nueva posicion y imprime el laberinto actualizado.
		lda		#'\n
		sta		pantalla
		pshs	x
		ldx		#laberinto
		bsr		imprime_cadena
		puls	x

		jmp		lee

mov_der:
		lda		#'.
		sta		,x
		stx		pos_valida								;coloca un punto en la posicion del usuario y guarda la posicion actual.
		ldb		#0

coloca5:		
		lda		,x+
		incb		
		cmpb	#2										;se desplaza tantas posiciones como requiera el movimiento.
		beq		continua5
		bra		coloca5

continua5:
		lda		,-x
		cmpa	#'.
		beq		continua5_1	
		cmpa	#'X
		bne		continua5_1
		pshs	x
		ldx		#error
		jsr		imprime_cadena							;comprueba que el movimiento es posible, si no lo es le avisa al usuario.
		puls    x
		ldx		pos_valida
		jmp 	lee
continua5_1:
		lda		#'O
		sta		,x

		lda		#'\n
		sta		pantalla
		sta		pantalla
		lda		lab_selec
		sta		pantalla								;situa al jugador en la nueva posicion y imprime el laberinto actualizado.
		lda		#'\n
		sta		pantalla
		pshs	x
		ldx		#laberinto
		bsr		imprime_cadena
		puls	x

		jmp		lee

acabar: 	
		clra
		sta 	fin

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;imprime cadena                                   ;
;registro utilizado: x                            ; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

imprime_cadena:
		

sigue_imprimiendo:
		lda		,x+
		beq		ic_fin
		sta		pantalla
		bra		sigue_imprimiendo
ic_fin:
		rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;bucle para copiar el laberinto							 ;
;coge la variable num_de_lab y la multiplica por 256     ;
;de esta forma se posiciona en el laberinto a copiar	 ;
;														 ;
;														 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
copia_laberinto:
			pshs	x
			pshs	y	
			pshs	a

			ldx		#laberinto
copia_lab:
			incb
			cmpb	#17
			beq		salto_linea						;cada 16 posiciones copia un salto de línea.
			lda		,y+
			sta		,x+
			beq		fin_cop							;copia cada caracter de una variable en la otra.
			bra		copia_lab
salto_linea:
			lda 	#'\n
			sta		,x+
			ldb		#0
			bra		copia_lab						;introduce el salto de linea.
fin_cop:
			puls	a
			puls	y
			puls	x
			rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Detecta si el jugador ha llegado al final del laberinto    ;
;                                                           ;
;                                                           ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

fin_de_laberinto:
			pshs	x
			pshs	b
			pshs	a
			
			ldx		#laberinto
			
sigue_buscando:
			lda		,x+
			cmpa	#'\n
			beq		fin_buscar
			cmpa	#'O
			beq		laberinto_terminado				;recorre la primera fila buscando al usuario.
			bra		sigue_buscando

laberinto_terminado:
			ldx		#lab_terminado					;si ha encontrado al usuario imprime un mensaje por pantalla.
			jsr		imprime_cadena
			ldb		#1
			stb		pos								;activa el flag a 1
			ldb		#0
			stb		posicion_jugador				;reinicia la posicion del jugador
		
fin_buscar:
			puls	a
			puls	b
			puls	x
			rts



.org 	0xFFFE	; Vector de RESET
		.word 	programa
