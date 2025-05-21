; division.asm
; Division de dos números enteros utilizando sólo registros de 32 bits.

section .data       ; En esta sección vamos a colocar los números a operar y el formato de la salida esperada. Es decir, variables inicializadas.    num1 dd 100               ; Define 'num1' (32 bits) con valor 100.
    num1 dd 100     ; Define 'num1' (32 bits) con valor 100.
    num2 dd 10      ; Define 'num2' (32 bits) con valor 10.

    titulo      db "=== División de dos números enteros utilizando registros de 32 bits. ===", 10, 0 ; Título del programa
    msg_dividendo db "Dividendo: ", 0   ; Mensaje para mostrar el primer número (dividendo)
    msg_divisor   db "Divisor: ", 0     ; Mensaje para mostrar el segundo número (divisor)
    msg_resultado db "Resultado: ", 0   ; Mensaje para mostar el cociente
    msg_residuo   db "Residuo: ", 0     ; Mensaje para mostrar el residuo
    msg_sep       db " / ", 0           ; Símbolo 'entre' para separar el dividendo y el divisor
    msg_igual     db " = ", 0           ; Símbolo 'igual' para el resultado (cociente)
    salto_linea   db 10, 0              ; Insertamos una cadena con un salto de línea

section .bss ; Sección para reservar espacio en memoria para variables no inicializadas.
    buffer_num1       resb 12   ; Buffer para la cadena del dividendo.
    buffer_num2       resb 12   ; Buffer para la cadena del divisor.
    buffer_resultado  resb 12   ; Buffer para la cadena del cociente.
    buffer_residuo    resb 12   ; Buffer para la cadena del residuo.

section .text       ; Sección donde va el código ejecutable.
    global _start   ; Punto de entrada del programa.

_start:
    ; Realizamos la division donde EAX = dividendo / divisor y EDX es el residuo 
    mov eax, [num1]           ; Mueve el dividendo (num1) a EAX.
    xor edx, edx              ; Limpia EDX para la división (EDX:EAX es el dividendo de 64 bits).
    mov ebx, [num2]           ; Mueve el divisor (num2) a EBX.
    div ebx                   ; Divide EDX:EAX por EBX. Cociente en EAX, residuo en EDX.

    ; Guardar los resultados en registros auxiliares (R8D para cociente, R9D para residuo).
    mov r8d, eax              ; Guarda el cociente de EAX en R8D.
    mov r9d, edx              ; Guarda el residuo de EDX en R9D.

    ; Convertir números a cadena para impresión.
    mov esi, [num1]           ; Mueve num1 a ESI.
    mov edi, buffer_num1      ; Destino: buffer_num1.
    call int_to_string        ; Convierte num1 a cadena.

    mov esi, [num2]           ; Mueve num2 a ESI.
    mov edi, buffer_num2      ; Destino: buffer_num2.
    call int_to_string        ; Convierte num2 a cadena.

    mov esi, r8d              ; Mueve el cociente (R8D) a ESI.
    mov edi, buffer_resultado ; Destino: buffer_resultado.
    call int_to_string        ; Convierte el cociente a cadena.

    mov esi, r9d              ; Mueve el residuo (R9D) a ESI.
    mov edi, buffer_residuo   ; Destino: buffer_residuo.
    call int_to_string        ; Convierte el residuo a cadena.

    ; Mostrar resultados
    mov rsi, titulo           ; Carga la dirección del título en RSI.
    call imprimir             ; Imprime el título.

    ; Mostrar dividendo.
    mov rsi, msg_dividendo    ; Carga mensaje "Dividendo: ".
    call imprimir             ; Imprime mensaje.
    mov rsi, buffer_num1      ; Carga cadena de num1.
    call imprimir             ; Imprime num1.
    call salto                ; Imprime salto de línea.

    ; Mostrar divisor.
    mov rsi, msg_divisor      ; Carga mensaje "Divisor: ".
    call imprimir             ; Imprime mensaje.
    mov rsi, buffer_num2      ; Carga cadena de num2.
    call imprimir             ; Imprime num2.
    call salto                ; Imprime salto de línea.

    ; Mostrar expresión de división y cociente.
    mov rsi, msg_resultado    ; Carga mensaje "Resultado: ".
    call imprimir             ; Imprime mensaje.
    mov rsi, buffer_num1      ; Carga cadena de num1.
    call imprimir             ; Imprime num1.
    mov rsi, msg_sep          ; Carga símbolo " / ".
    call imprimir             ; Imprime símbolo.
    mov rsi, buffer_num2      ; Carga cadena de num2.
    call imprimir             ; Imprime num2.
    mov rsi, msg_igual        ; Carga símbolo " = ".
    call imprimir             ; Imprime símbolo.
    mov rsi, buffer_resultado ; Carga cadena del cociente.
    call imprimir             ; Imprime cociente.
    call salto                ; Imprime salto de línea.

    ; Mostrar residuo.
    mov rsi, msg_residuo      ; Carga mensaje "Residuo: ".
    call imprimir             ; Imprime mensaje.
    mov rsi, buffer_residuo   ; Carga cadena del residuo.
    call imprimir             ; Imprime residuo.
    call salto                ; Imprime salto de línea.

    ; Salida del programa
    mov rax, 60     ; Número de llamada al sistema para 'exit' en Linux x86_64
    xor rdi, rdi    ; Código de salida 0 que significa que el programa se ha ejecutado con éxito
    syscall         ; Realiza la llamada al sistema

; imprimir: Imprime cadena terminada en 0
imprimir:
    mov rax, 1              ; Número de llamada al sistema para 'write'
    mov rdi, 1              ; Descriptor de archivo 1: salida estándar (stdout)
    mov rdx, 0              ; Inicializa RDX (longitud de la cadena)
.find_len:
    cmp byte [rsi + rdx], 0 ; Compara el byte en la dirección RSI+RDX con 0 al final de cadena
    je .write               ; Si es 0, salta a .write
    inc rdx                 ; Incrementa RDX (longitud)
    jmp .find_len           ; Vuelve a .find_len para seguir buscando el final de la cadena
.write:
    syscall                 ; Realiza la llamada al sistema 'write'
    ret                     ; Regresa de la subrutina 
salto:
    mov rsi, salto_linea    ; Mueve la dirección del salto de línea a RSI
    call imprimir           ; Llama a imprimir para mostrar el salto de línea
    ret

; int_to_string: Convierte entero (en ESI) a cadena (en EDI).
int_to_string:
    mov eax, esi              ; Mueve el número a EAX.
    mov ecx, 10               ; Divisor base 10.
    lea rbx, [edi + 11]       ; Apunta al final del buffer (para escribir de derecha a izquierda).
    mov byte [rbx], 0         ; Coloca terminador nulo.
    dec rbx                   ; Retrocede un byte.

; convert_loop: Bucle para convertir el número a dígitos ASCII
.convert_loop:
    xor edx, edx              ; Limpia EDX (residuo de la división).
    div ecx                   ; Divide EAX por 10. Cociente en EAX, residuo en EDX.
    add dl, '0'               ; Convierte dígito a ASCII.
    mov [rbx], dl             ; Almacena dígito en el buffer.
    dec rbx                   ; Retrocede para el siguiente dígito.
    test eax, eax             ; Comprueba si EAX es cero.
    jnz .convert_loop         ; Si no es cero, sigue convirtiendo.
    inc rbx                   ; Ajusta RBX al inicio de la cadena de dígitos.

; copy_loop: Bucle para copiar la cadena del buffer temporal (donde se generó de derecha a izquierda)
.copy_loop:
    mov al, [rbx]             ; Mueve carácter desde RBX.
    mov [edi], al             ; Copia carácter a EDI.
    inc rbx                   ; Avanza puntero de origen.
    inc edi                   ; Avanza puntero de destino.
    cmp al, 0                 ; Comprueba si es el terminador nulo.
    jne .copy_loop            ; Si no es nulo, sigue copiando.
    ret                       ; Regresa de la subrutina