; resta.asm
; Resta de tres números enteros utilizando sólo registros de 16 bits.

section .data   ; En esta sección vamos a colocar los números a operar y el formato de la salida esperada. Es decir, variables inicializadas.
    num1 dw 100  ; Define la variable num1 como un "word" (16 bits) con valor 100
    num2 dw 50   ; Define la variable num2 como un "word" (16 bits) con valor 50
    num3 dw 25   ; Define la variable num3 como un "word" (16 bits) con valor 25

    titulo db "=== Resta de tres números enteros utilizando sólo registros de 16 bits. ===", 10, 0 ; Título del programa
    msg_num1 db "Num1: ", 0             ; Mensaje para mostrar el primer número
    msg_num2 db "Num2: ", 0             ; Mensaje para mostrar el segundo número
    msg_num3 db "Num3: ", 0             ; Mensaje para mostrar el tercer número
    msg_resultado db "Resultado: ", 0   ; Mensaje para mostrar el resultado
    msg_sep1 db " - ", 0                ; Simbolo 'menos' para separar el primer y segundo número
    msg_sep2 db " - ", 0                ; Simbolo 'menos' para separar el segundo y tercer número
    msg_igual db " = ", 0               ; Simbolo 'igual' para separar el resultado
    salto_linea db 10, 0                ; Insertamos una cadena con un salto de línea

section .bss ; Sección para reservar espacio en memoria de las variables no inicializadas 
    buffer_num1 resb 10  ; Reserva 10 bytes para cadena del primer número
    buffer_num2 resb 10  ; Reserva 10 bytes para cadena del segundo número
    buffer_num3 resb 10  ; Reserva 10 bytes para cadena del tercer número
    buffer_res  resb 10  ; Reserva 10 bytes para cadena del resultado
    result resw 1        ; Reserva 2 bytes o 1 word para el resultado de la resta

section .text       ; Sección donde va el código ejecutable
    global _start   ; Punto de entrada del programa

_start:
    ; Realizamos la resta donde AX = num1 - num2 - num3
    mov ax, [num1]   ; Mueve el valor de num1 al registro AX de 16 bits
    sub ax, [num2]   ; Resta el valor de num2 al valor de AX
    sub ax, [num3]   ; Resta el valor de num3 al valor de AX
    mov [result], ax ; Mueve el resultado de AX a la variable 'result' en memoria

    ; Mostramos el título
    mov rsi, titulo ; Mueve la dirección de la cadena 'titulo' al registro RSI como fuente para cadenas
    call imprimir   ; Llama a la subrutina 'imprimir' para mostrar el título

    ; Mostrar Num1
    movzx rax, word [num1]  ; Mueve el valor de num1 a RAX, extendiendo con ceros de word a qword
    mov rdi, buffer_num1    ; Mueve la dirección de 'buffer_num1' a RDI que es el destino para cadenas
    call int_to_string      ; Llama a la subrutina 'int_to_string' para convertir el número a cadena
    mov rsi, msg_num1       ; Mueve la dirección del mensaje "Num1: " a RSI
    call imprimir           ; Imprime "Num1: "
    mov rsi, buffer_num1    ; Mueve la dirección de la cadena de num1 a RSI
    call imprimir           ; Imprime el valor de num1
    call salto              ; Llama a la subrutina 'salto' para imprimir un salto de línea

    ; Mostrar Num2 donde se utilizan los mismos principios que se aplicaron para Num1
    movzx rax, word [num2]
    mov rdi, buffer_num2
    call int_to_string
    mov rsi, msg_num2
    call imprimir
    mov rsi, buffer_num2
    call imprimir
    call salto

    ; Mostrar Num3 donde se utilizan los mismos principios que se aplicaron para Num1 y Num2
    movzx rax, word [num3]
    mov rdi, buffer_num3
    call int_to_string
    mov rsi, msg_num3
    call imprimir
    mov rsi, buffer_num3
    call imprimir
    call salto

    ; Mostrar Resultado
    mov rsi, msg_resultado  ; Mueve la dirección del mensaje "Resultado: " a RSI
    call imprimir           ; Imprime "Resultado: "

    mov rsi, buffer_num1  ; Imprime el primer número
    call imprimir
    mov rsi, msg_sep1     ; Imprime " - "
    call imprimir
    mov rsi, buffer_num2  ; Imprime el segundo número
    call imprimir
    mov rsi, msg_sep2     ; Imprime " - "
    call imprimir
    mov rsi, buffer_num3  ; Imprime el tercer número
    call imprimir
    mov rsi, msg_igual    ; Imprime " = "
    call imprimir

    ; Convierte el resultado a string y lo muestra
    movzx rax, word [result]    ; Mueve el resultado desde la variable 'result' a RAX
    mov rdi, buffer_res         ; Mueve la dirección de 'buffer_res' a RDI
    call int_to_string          ; Convierte el resultado a cadena
    mov rsi, buffer_res         ; Mueve la dirección de la cadena del resultado a RSI
    call imprimir               ; Imprime el resultado
    call salto                  ; Imprime salto de línea

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
