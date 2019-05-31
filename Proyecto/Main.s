/*
		Andrea Abril Palencia Gutierrez                Luis Perez Aju
					18198                                  18212
									 Simon Dice
									 20/05/2019
*/
.data
.align 2
.global myloc
myloc:
	.word 0
	
menu:
		.asciz "1.Reglas. \n 2. Por consola. \n 3. Por sistema. \n 4. Salir "
	reglas:
		.asciz "Se le dara una secuencia de 4 colores (luces led y usted tendrea que ingresar correctamente la secuencia dada. Si usted\n" 
		.asciz "ingresa una posicion incorrecta se prenderan las 4 luces led para indicar que se confundio. El juego no tiene puntaje y finaliza\n" 
		.asciz "cuando el jugador ingresa una posicion incorrecta. Habra un boton de reinicio, que se podra utilizar en cualquier momento para comenzar de nuevo."
	led:
		.asciz "Ingrese la led que desea:"
	secuenciaRandom:
		.word 0,0,0,0
	secuenciaFinal:
		.word 0,0,0,0
	op:
		.word 0
	Error_no_opcion:
		.asciz "Error!!!! La opcion no es correcta"
	jeje:
		.asciz "jejeje  "
	opFormato:
		.asciz "%d"
	contador:
		.word 0
	cadena:
		.asciz "%d\n"
	memoria:
		.word 0
	memoria1:
		.word 0
	texto:
		.asciz "Ingrese el led: (1, 2, 3 o 4)"
	perdio:
		.asciz "INCORRECTO!"
	contador1:
		.word 0
	mensajebien:
		.asciz "YEAH \n"
/*#################################  Main  #############################################*/
.text
.align 2
.global main
.type main, %function
main:
		 @@ grabar registro de enlace en la pila
        stmfd   sp!, {lr}

		bl GetGpioAddress
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

        /* apagar GPIO 17 */
			mov r0, #17
			mov r1, #0
			bl SetGpio

			/* apagar GPIO 17 */
			mov r0, #18
			mov r1, #0
			bl SetGpio
		/* apagar GPIO 17 */
			mov r0, #22
			mov r1, #0
			bl SetGpio

		/* apagar GPIO 17 */
			mov r0, #27
			mov r1, #0
			bl SetGpio


       
menu1:
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
			beq reglas1
       cmpne r0,#2
			beq juegoConsola
      /* cmpne r0,#3
			beq juegoSistema*/
	   cmpne r0, #4
			beq salir
       bne error
juegoConsola:
/* SECUENCIA RANDOM */
	bl secuenciaRan	
/* TURNO DEL JUGADOR */
	bl secuenciaIng
	b salir
reglas1:
        @@muestra las reglas con puts
        ldr r0,=reglas
        bl puts
        b menu1
error:
        ldr r0,=Error_no_opcion
        bl puts
        b menu1
salir:
        mov     r3, #0
        mov     r0, r3
        /* colocar registro de enlace para desactivar la pila y retorna al SO*/
        ldmfd   sp!, {lr}
        bx      lr
secuenciaRan:
	push {lr}
		/* generar numero random */
		mov r12, #4
	
		/* se guarda el numero random en r12 */
		bl RANDOM 

		/* se prende la led correspondiente */
		cmp r12, #1
			/* encender GPIO 17 */
			moveq r0, #17
			moveq r1, #1
			bleq SetGpio
			cmp r12, #1
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmp r12, #1
			/* apagar GPIO */
			moveq r0, #17
			moveq r1, #0
			cmp r12, #1
			bleq SetGpio
		cmpne r12, #2
			/* encender GPIO 18 */
			moveq r0, #18
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #2
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #2
			/* apagar GPIO */
			moveq r0, #18
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #3
			/* encender GPIO 22 */
			moveq r0, #22
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #3
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #3
			/* apagar GPIO */
			moveq r0, #22
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #4
			/* encender GPIO 27 */
			moveq r0, #27
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #4
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #4
			moveq r0, #27
			moveq r1, #0
			bleq SetGpio

		ldr r1, =secuenciaRandom
		str r12, [r1]

		/* generar numero random */
		mov r12, #4
	
		/* se guarda el numero random en r12 */
		bl RANDOM 

		/* se prende la led correspondiente */
		cmp r12, #1
			/* encender GPIO 17 */
			moveq r0, #17
			moveq r1, #1
			bleq SetGpio
			cmp r12, #1
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmp r12, #1
			/* apagar GPIO */
			moveq r0, #17
			moveq r1, #0
			cmp r12, #1
			bleq SetGpio
		cmpne r12, #2
			/* encender GPIO 18 */
			moveq r0, #18
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #2
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #2
			/* apagar GPIO */
			moveq r0, #18
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #3
			/* encender GPIO 22 */
			moveq r0, #22
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #3
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #3
			/* apagar GPIO */
			moveq r0, #22
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #4
			/* encender GPIO 27 */
			moveq r0, #27
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #4
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #4
			moveq r0, #27
			moveq r1, #0
			bleq SetGpio

		ldr r1, =secuenciaRandom
		add r6, r1, #4
		str r12, [r6]

		/* generar numero random */
		mov r12, #4
	
		/* se guarda el numero random en r12 */
		bl RANDOM 

		/* se prende la led correspondiente */
		cmp r12, #1
			/* encender GPIO 17 */
			moveq r0, #17
			moveq r1, #1
			bleq SetGpio
			cmp r12, #1
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmp r12, #1
			/* apagar GPIO */
			moveq r0, #17
			moveq r1, #0
			cmp r12, #1
			bleq SetGpio
		cmpne r12, #2
			/* encender GPIO 18 */
			moveq r0, #18
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #2
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #2
			/* apagar GPIO */
			moveq r0, #18
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #3
			/* encender GPIO 22 */
			moveq r0, #22
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #3
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #3
			/* apagar GPIO */
			moveq r0, #22
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #4
			/* encender GPIO 27 */
			moveq r0, #27
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #4
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #4
			moveq r0, #27
			moveq r1, #0
			bleq SetGpio

		ldr r1, =secuenciaRandom
		add r6, r1, #8
		str r12, [r6]

		/* generar numero random */
		mov r12, #4
	
		/* se guarda el numero random en r12 */
		bl RANDOM 

		/* se prende la led correspondiente */
		cmp r12, #1
			/* encender GPIO 17 */
			moveq r0, #17
			moveq r1, #1
			bleq SetGpio
			cmp r12, #1
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmp r12, #1
			/* apagar GPIO */
			moveq r0, #17
			moveq r1, #0
			cmp r12, #1
			bleq SetGpio
		cmpne r12, #2
			/* encender GPIO 18 */
			moveq r0, #18
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #2
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #2
			/* apagar GPIO */
			moveq r0, #18
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #3
			/* encender GPIO 22 */
			moveq r0, #22
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #3
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #3
			/* apagar GPIO */
			moveq r0, #22
			moveq r1, #0
			bleq SetGpio
		cmpne r12, #4
			/* encender GPIO 27 */
			moveq r0, #27
			moveq r1, #1
			bleq SetGpio
			cmpne r12, #4
			/* espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r12, #4
			moveq r0, #27
			moveq r1, #0
			bleq SetGpio

		ldr r1, =secuenciaRandom
		add r6, r1, #12
		str r12, [r6]
	
		pop {pc}


secuenciaIng:
	push {lr}
	ciclo_jugador:
		ldr r0, =texto
		bl puts

		ldr r0,= opFormato
		ldr r1,= op
		bl scanf
		/* guarda en registro lo que ingreso */
		ldr r1, =op
		ldr r7, [r1]

		/* guardar numero ingresado en vector */
		ldr r5, =memoria1
		ldr r5, [r5]
		ldr r1, =secuenciaFinal
		add r6, r1, r5
		str r7, [r6]

		/* jalar la misma direccion del vector random */
		ldr r5, =memoria1
		ldr r5, [r5]
		ldr r1, =secuenciaRandom
		add r6, r1, r5
		ldr r8, [r6]

		/*imprimir el nuevo valor de la posicion */
        mov r1, r7
        ldr r0, =cadena
        bl printf

		/*imprimir el nuevo valor de la posicion */
        mov r1, r8
        ldr r0, =cadena
        bl printf
        
		/* comparar lo ingresado con la secuencia random */
		cmp r8, r7
			ldreq r0, =jeje
			bleq puts
			beq igual
		bne perder
	toto:
		/* contador */
		ldr r1, =contador1
        ldr r8, [r1]
        add r6, r8, #1
        str r6, [r1]
        ldr r1,=contador1
        ldr r1, [r1]

		/* sumar cuatro en memoria */
		ldr r1, =memoria1
        ldr r8, [r1]
        add r6, r8, #4
        str r6, [r1]

		/* condicion para salir del ciclo */
		cmp r1, #4
			beq fin1
		bne ciclo_jugador

	fin1:
		pop {pc}

	igual:
		 /*jalar el valor ingresado*/
		ldr r5, =memoria1
		ldr r5, [r5]
		ldr r1, =secuenciaFinal
		add r6, r1, r5
		ldr r9, [r6]
		cmp r9, #1
			/*encender GPIO 17*/
			moveq r0, #17
			moveq r1, #1
			bleq SetGpio
			cmp r9, #1
			/*espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			/*apagar GPIO*/
			cmp r9, #1
			moveq r0, #17
			moveq r1, #0
			bleq SetGpio
			cmp r9, #1
			beq toto
		cmpne r9, #2
			/*encender GPIO 18*/
			moveq r0, #18
			moveq r1, #1
			bleq SetGpio
			cmpne r9, #2
			/*espera dos segundos*/
			moveq r0, #2
			bleq ESPERASEG
			cmpne r9, #2
			/*apagar GPIO*/
			moveq r0, #18
			moveq r1, #0
			bleq SetGpio
			cmpne r9, #2
			beq toto
		cmpne r9, #3
			/*encender GPIO 22*/
			moveq r0, #22
			moveq r1, #1
			bleq SetGpio
			cmpne r9, #3
			/*espera dos segundos */
			moveq r0, #2
			bleq ESPERASEG
			cmpne r9, #3
			/*apagar GPIO*/
			moveq r0, #22
			moveq r1, #0
			bleq SetGpio
			cmpne r9, #3
			beq toto
		cmpne r9, #4
			/*encender GPIO 27*/
			moveq r0, #27
			moveq r1, #1
			bleq SetGpio
			cmpne r9, #4
			/*espera dos segundos*/
			moveq r0, #2
			bleq ESPERASEG
			cmpne r9, #4
			/*apagar GPIO */
			moveq r0, #27
			moveq r1, #0
			bleq SetGpio
			cmpne r9, #4
			beq toto

		perder:
			ldr r0, =perdio
			bl puts
			
			/* apagar todos los GPIO */
			mov r0, #17
			mov r1, #0
			bl SetGpio

			mov r0, #18
			mov r1, #0
			bleq SetGpio

			mov r0, #22
			mov r1, #0
			bl SetGpio

			mov r0, #27
			mov r1, #0
			bl SetGpio

			/* Encender todos los GPIO */
			mov r0, #17
			mov r1, #1
			bl SetGpio

			mov r0, #18
			mov r1, #1
			bl SetGpio

			mov r0, #22
			mov r1, #1
			bl SetGpio

			mov r0, #27
			mov r1, #1
			bl SetGpio

			/* espera dos segundos */
			mov r0, #2
			bl ESPERASEG

			/* apagar todos los GPIO */
			mov r0, #17
			mov r1, #0
			bl SetGpio

			mov r0, #18
			mov r1, #0
			bleq SetGpio

			mov r0, #22
			mov r1, #0
			bl SetGpio

			mov r0, #27
			mov r1, #0
			bl SetGpio
			
			bl fin1
	

