/*
		Andrea Abril Palencia Gutierrez                Luis Perez Aju
					18198                                  18212
									 Simon Dice
									 20/05/2019
*/
.data
.align 2
	menu:
		.asciz "1.Reglas. \n 2. Por consola. \n 3. Por sistema. \n 4. Salir "
	reglas:
		.asciz "Se le dara una secuencia de 4 colores (luces led y usted tendrea que ingresar correctamente la secuencia dada. Si usted\n 
		ingresa una posicion incorrecta se prenderan las 4 luces led para indicar que se confundio. El juego no tiene puntaje y finaliza\n 
		cuando el jugador ingresa una posicion incorrecta. Habra un boton de reinicio, que se podra utilizar en cualquier momento para comenzar de nuevo.\n"
	led:
		.asciz "Ingrese la led que desea:\n"
	secuenciaRandom:
		.word 0, 0, 0, 0
	secuenciaFinal:
		.word 0, 0, 0, 0
	op:
		.word 0
	Error_no_opcion:
		.asciz "Error!!!! La opcion no es correcta"
	opFormato:
		.asciz "%d"
	contador:
		.word 0
	cadena:
		.asciz "%s"
	memoria:
		.word 0
/*#################################  Main  #############################################*/
.text
.align 2
.global main
.type main, %function
main:
		/* configuracion de los puertos */
		mov r0, #17				@@ Seteamos pin 17
		mov  r1, #1				@@ Configuramos salida
		bl   SetGpioFunction	

		mov r0, #22			@@ Seteamos pin 22
		mov  r1, #1				@@ Configuramos salida
		bl   SetGpioFunction	

		mov r0, #18			@@ Seteamos pin 18
		mov  r1, #1				@@ Configuramos salida
		bl   SetGpioFunction
		
		mov r0, #27			@@ Seteamos pin 27
		mov  r1, #1				@@ Configuramos salida
		bl   SetGpioFunction	

        @@ grabar registro de enlace en la pila
        stmfd   sp!, {lr}

menu:
	/* muestra menu */
       ldr r0, =menu
       bl puts

       ldr r0,= opFormato
       ldr r1,= op
       bl scanf
	   /* guarda en registro lo que ingreso */
       ldr r1, =op
       ldr r0, [r1]

       /* condicionales del menu */
       cmp r0,#1
			beq reglas
       cmpne r0,#2
			beq juegoConsola
       cmpne r0,#3
			beq juegoSistema
	   cmpne r0, #4
			beq salir
       bne error
juegoConsola:
/* SECUENCIA RANDOM */
	bl secuenciaRan

	
reglas:
        @@muestra las reglas con puts
        ldr r0,=reglas
        bl puts
        b main
error:
        ldr r0,=Error_no_opcion
        bl puts
        b main
salir:
        mov     r3, #0
        mov     r0, r3
        /* colocar registro de enlace para desactivar la pila y retorna al SO*/
        ldmfd   sp!, {lr}
        bx      lr
secuenciaRan:
	ciclo:
		push {lr}
		/* generar numero random */
		mov r12, #4
	
		/* se guarda el numero random en r12 */
		bl RANDOM 

		/* se prende la led correspondiente */
		cmp r12, #1
			/* apagar GPIO */
			moveq r0, #17
			moveq r1, #0
			bleq SetGpio
			/* encender GPIO 17 */
			moveq r0, #17
			moveq r1, #1
			bleq SetGpio
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			/* apagar GPIO */
			moveq r0, #17
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #2
			/* apagar GPIO */
			moveq r0, #18
			moveq r1, #0
			bleq SetGpio
			/* encender GPIO 18 */
			moveq r0, #18
			moveq r1, #1
			bleq SetGpio
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			/* apagar GPIO */
			moveq r0, #18
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #3
			/* apagar GPIO */
			moveq r0, #22
			moveq r1, #0
			bleq SetGpio
			/* encender GPIO 22 */
			moveq r0, #22
			moveq r1, #1
			bleq SetGpio
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			/* apagar GPIO */
			moveq r0, #22
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #4
			/* apagar GPIO */cgfvhgbjn
			moveq r0, #27
			moveq r1, #0
			bleq SetGpio
			/* encender GPIO 27 */
			moveq r0, #27
			moveq r1, #1
			bleq SetGpio
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			/* apagar GPIO */
			moveq r0, #27
			moveq r1, #0
			bleq SetGpio

		/* guardar numero random en vector */
		ldr r5, =memoria
		ldr r5, [r5]
		ldr r1, =secuenciaRandom
		add r6 r1, r5
		str r12, [r6]

		/* contador */
		ldr r1, =contador
        ldr r8, [r1]
        add r6, r8, #1
        str r6, [r1]
        ldr r1,=contador
        ldr r10, [r1]

		/* sumar cuatro en memoria */
		ldr r1, =memoria
        ldr r8, [r1]
        add r6, r8, #4
        str r6, [r1]

		/* condicion para salir del ciclo */
		cmp r10, #4
			beq fin
		bne ciclo
	fin:
		pop {pc}