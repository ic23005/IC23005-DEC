**🚀 Portafolio de Ensamblador**

Este repositorio contiene la entrega de la actividad de Portafolio DEC que consiste en tres programas sencillos escritos en lenguaje ensamblador para Linux: resta, multiplicación y división de números enteros.

**✒️ Autor**

Este proyecto ha sido desarrollado por:

* *Nombre:* Erick Israel Iraheta Contreras
* *Carnet:* IC23005
* *Asignatura:* DEC135 - Diseño y Estructura de Computadoras | Grupo Teórico 2 (GT2)
* *Correo electrónico:* ic23005@ues.edu.sv
* *Github:* https://github.com/ic23005/IC23005-DEC

**💻 Entorno de Desarrollo**

Para compilar y ejecutar estos programas, se necesita de un entorno Linux. Para su desarrollo se utilizó Windows 11 con WSL2 o Windows Subsystem Linux version 2, por sus siglas en inglés. Subsistema de Windows para Linux (WSL2) con la distribución de Ubuntu 24.04.

**📝 Requisitos Previos**

Para la correcta compilación y ejecición de los programas es necesario considerar la instalación de los siguientes recursos:

1. *NASM (Netwide Assembler):* Este es el ensamblador que utilizaremos para convertir el código fuente (.asm) en archivos objeto (.o)..

```bash
sudo apt update                     # Actualizamos la lista de paquetes
sudo apt upgrade                    # Instalamos las actualizaciones necesarias
sudo apt install nasm               # Instalamos NASM
```
2. *GCC (GNU Compiler Collection):* Se utilizará para enlazar el archivo objeto y crear el ejecutable.

```bash
sudo apt update                     # Actualizamos la lista de paquetes
sudo apt upgrade                    # Instalamos las actualizaciones necesarias
sudo apt install build-essentia     # Instalamos GCC y otras herramientas de desarrollo
```

**📂 Estructura del Proyecto**

El proyecto dedica una carpeta para cada programa dentro de la cual se encuentar el archivo de código '.asm', el archivo compilado como objeto '.o' y el archivo enlazado ejecutable sin extensión.

```bash
ic23005-dec
├── division/
│   ├── division            # Ejecutable de la división
│   ├── division.asm        # Código fuente de la división
│   └── division.o          # Objeto compilado de la división
├── multiplicacion/
│   ├── multiplicacion      # Ejecutable de la multiplicación
│   ├── multiplicacion.asm  # Código fuente de la multiplicación
│   └── multiplicacion.o    # Objeto compilado de la multiplicación
├── resta/
│   ├── resta               # Ejecutable de la resta
│   ├── resta.asm           # Código fuente de la resta
│   └── resta.o             # Objeto compilado de la resta
└── README.md
```

**🛠️ Compilación y Ejecución**

Para cada programa, el proceso de compilación y ejecución es el mismo. Para su correcto funcionamiento, compilación y ejecución es necesario seguir estos pasos desde la terminal de Linux:

1. Ensamblar el código fuente (.asm) a código objeto (.o)

```bash
nasm -f elf64 <nombre_del_archivo>.asm -o <nombre_del_archivo>.o
```

2. Enlazae el código objeto (.o) a archivo ejecutable (sin extensión)

```bash
ld <nombre_del_archivo>.o -o <nombre_del_ejecutable>
```

3. Ejecutar el programa

```bash
./<nombre_del_ejecutable>
```

**🧮 Descripción de los Programas**

Cada programa realiza una de las operaciones aritmeticas básicas y posee una diferencia en el proceso de impresión ya que se trabaja con registros de 16, 8 y 32 bits respectivamente.

*➖ Resta:* Aunque los cálculos internos se realizan con registros de 16 bits (AX), el proceso de conversión a cadena (int_to_string) y la impresión final son genéricos y muestran el valor numérico resultante. La diferencia fundamental en este caso es que el programa está diseñado para manejar valores dentro del rango representable por un word (16 bits), lo que significa que el resultado de la resta se espera que quepa en ese tamaño. Se muestra explícitamente los tres números involucrados en la resta y luego el resultado de la operación Num1 - Num2 - Num3 = Resultado.

*✖️ Multiplicación:* La diferencia entre resta y multiplicación es que, a pesar de que los operandos (num1 y num2) son de 8 bits, el resultado (result) es manejado y mostrado como un número de 16 bits. Esto asegura que productos mayores a 255 (el valor máximo de 8 bits) puedan ser representados correctamente en la salida. Se muestran los dos números que se multiplican y luego el resultado de la operación Num1 * Num2 = Resultado.

*➗ División:* Con la división tanto los operandos como el cociente y el residuo son tratados como valores de 32 bits. Esto permite manejar números mucho más grandes que en los ejemplos anteriores, con un rango máximo de aproximadamente 4*10^9. La impresión refleja la capacidad de representar y mostrar estos valores más grandes. Además de mostrar el dividendo, el divisor y el cociente (Dividendo / Divisor = Cociente), también muestra el residuo de la división en una línea separada.