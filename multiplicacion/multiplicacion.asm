; multiplicacion.asm
; Multiplicación de dos números enteros utilizando sólo registros de 8 bits.

section .data   ; En esta sección vamos a colocar los números a operar y el formato de la salida esperada. Es decir, variables inicializadas.
    num1 db 10  ; Define 'num1' como un byte (8 bits) e inicializa su valor a 10.
    num2 db 5   ; Define 'num2' como un byte (8 bits) e inicializa su valor a 5.

    titulo db "=== Multiplicacion de dos numeros enteros utilizando registros de 8 bits. ===", 10, 0 ; Título del programa
    msg_num1 db "Num1: ", 0             ; Mensaje para mostrar el primer número
    msg_num2 db "Num2: ", 0             ; Mensaje para mostrar el segundo número
    msg_resultado db "Resultado: ", 0   ; Mensaje para mostrar el resultado
    msg_sep db " * ", 0                 ; Simbolo 'por' para separar el primer y segundo número
    msg_igual db " = ", 0               ; Simbolo 'igual' para separar el resultado
    salto_linea db 10, 0                ; Insertamos una cadena con un salto de línea

section .bss ; Sección para reservar espacio en memoria de las variables no inicializadas
    buffer_num1 resb 10       ; Reserva 10 bytes para la cadena del primer número
    buffer_num2 resb 10       ; Reserva 10 bytes para la cadena del segundo número
    buffer_res  resb 10       ; Reserva 10 bytes para la cadena del resultado
    result resw 1             ; Reserva 2 bytes o 1 word para el resultado de la multiplicacion

section .text       ; Sección donde va el código ejecutable
    global _start   ; Punto de entrada del programa

_start:
    ; Realizamos la multiplicación donde AX = num1 * num2
    mov al, [num1]            ; Mueve el valor del byte en la dirección de memoria 'num1' al registro AL
    mov bl, [num2]            ; Mueve el valor del byte en la dirección de memoria 'num2' al registro BL
    mul bl                    ; Multiplica el contenido de AL (10) por el contenido de BL (5).
                              ; El resultado (50) se almacena en AX. Como 50 cabe en 8 bits, AH será 0.
                              ; AX = 0x0032 (donde 0x32 es 50 en hexadecimal)
    mov [result], ax          ; Mueve el valor de AX (el resultado de 16 bits) en la dirección de memoria 'result'.

    ; Mostrar título del programa
    mov rsi, titulo           ; Carga la dirección de la cadena 'titulo' en el registro RSI (Source Index).
    call imprimir             ; Llama a la subrutina 'imprimir' para mostrar el título en la consola.

    ; Mostrar el valor de Num1
    movzx rax, byte [num1]    ; Mueve el valor del byte en 'num1' a RAX, extendiendo con ceros los bits superiores. Esto es necesario porque 'int_to_string' espera un valor en RAX.
    mov rdi, buffer_num1      ; Carga la dirección de 'buffer_num1' en RDI (Destination Index). Este buffer se usará para almacenar la cadena resultante de la conversión.
    call int_to_string        ; Llama a la subrutina 'int_to_string' para convertir el número en RAX a una cadena ASCII y guardarla en el buffer apuntado por RDI.
    mov rsi, msg_num1         ; Carga la dirección de la cadena "Num1: " en RSI.
    call imprimir             ; Imprime "Num1: ".
    mov rsi, buffer_num1      ; Carga la dirección de la cadena convertida de num1 en RSI.
    call imprimir             ; Imprime el valor de num1.
    call salto                ; Llama a la subrutina 'salto' para imprimir un salto de línea.

    ; Mostrar Num2 donde se utilizan los mismos principios que se aplicaron para Num1
    movzx rax, byte [num2]
    mov rdi, buffer_num2
    call int_to_string
    mov rsi, msg_num2
    call imprimir
    mov rsi, buffer_num2
    call imprimir
    call salto

    ; Mostrar el resultado
    mov rsi, msg_resultado    ; Mueve la dirección de la cadena "Resultado: " en RSI.
    call imprimir             ; Imprime "Resultado: ".

    mov rsi, buffer_num1      ; Carga la dirección de la cadena de num1 en RSI.
    call imprimir             ; Imprime el valor de num1.
    mov rsi, msg_sep          ; Carga la dirección de la cadena " * " en RSI.
    call imprimir             ; Imprime " * ".
    mov rsi, buffer_num2      ; Carga la dirección de la cadena de num2 en RSI.
    call imprimir             ; Imprime el valor de num2.
    mov rsi, msg_igual        ; Carga la dirección de la cadena " = " en RSI.
    call imprimir             ; Imprime " = ".

    ; Mostrar el resultado de la multiplicación
    movzx rax, word [result]  ; Mueve el valor de la palabra (16 bits) en 'result' a RAX, extendiendo con ceros. Esto es importante porque 'result' se definió como 'resw' (16 bits).
    mov rdi, buffer_res       ; Carga la dirección de 'buffer_res' en RDI.
    call int_to_string        ; Convierte el resultado numérico en RAX a una cadena y lo guarda en 'buffer_res'.
    mov rsi, buffer_res       ; Carga la dirección de la cadena del resultado en RSI.
    call imprimir             ; Imprime el resultado.
    call salto                ; Imprime un salto de línea.

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

; int_to_string: Convierte el número en RAX a su representación en cadena, almacenándola en la dirección apuntada por RDI
int_to_string:
    mov rcx, 10         ; Divisor base 10 para convertir a decimal
    mov rbx, rdi        ; Guarda la dirección inicial del buffer en RBX
    add rbx, 9          ; Apunta al final del buffer, acá asumimos que el máximo serían 10 dígitos
    mov byte [rbx], 0   ; Colocamos el terminador nulo al final de la cadena
    dec rbx             ; Decrementamos RBX para apuntar al último dígito

; convert_loop: Bucle para convertir el número a dígitos ASCII
.convert_loop:
    xor rdx, rdx        ; Limpia RDX que es el residuo de la división
    div rcx             ; Divide RAX entre 10.  Cociente en RAX, residuo en RDX
    add dl, '0'         ; Convierte el dígito (0-9) a su carácter ASCII ('0'-'9')
    mov [rbx], dl       ; Almacena el dígito ASCII en el buffer
    dec rbx             ; Decrementa RBX para el siguiente dígito
    test rax, rax       ; Verifica si el cociente (RAX) es cero
    jnz .convert_loop   ; Si no es cero, sigue dividiendo
    inc rbx             ; Incrementa RBX para apuntar al primer dígito de la cadena

; copy_loop: Bucle para copiar la cadena del buffer temporal (donde se generó de derecha a izquierda)
.copy_loop:
    mov al, [rbx]       ; Mueve un byte (carácter) desde la cadena convertida a AL
    mov [rdi], al       ; Copia el carácter a la ubicación de destino (RDI)
    inc rbx             ; Incrementa el puntero de origen (RBX)
    inc rdi             ; Incrementa el puntero de destino (RDI)
    cmp al, 0           ; Compara el carácter copiado con el terminador nulo
    jne .copy_loop      ; Si no es el terminador nulo, sigue copiando
    ret                 ; Regresa de la subrutina