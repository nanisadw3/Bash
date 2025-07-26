# Proyectos Bash

Este repositorio contiene una colección de scripts Bash desarrollados para diversas tareas, desde simulaciones de apuestas y herramientas de red hasta utilidades de descompresión y búsqueda de información.

## Estructura del Repositorio

El repositorio está organizado en los siguientes directorios, cada uno conteniendo scripts relacionados con una temática específica:

-   **Apuestas/**: Scripts relacionados con simulaciones de juegos de azar.
-   **Buscador_Z4/**: Herramientas para buscar información sobre máquinas de Hack The Box.
-   **Calculadora_IP/**: Scripts para cálculos de redes IP y escaneo básico.
-   **Puertos/**: Utilidades para escaneo de hosts y puertos, así como descompresión de archivos.

## Descripción de Proyectos

A continuación, se detalla el contenido y la funcionalidad de cada subdirectorio:

### Apuestas/

Este directorio contiene scripts para simular estrategias de apuestas en la ruleta y ejemplos de manipulación de arrays en Bash.

-   `ruleta.sh`: Un script de simulación de ruleta que implementa las estrategias de Martingala y Labouchere Inversa. Permite al usuario especificar el dinero inicial y la técnica a utilizar.
    -   **Uso:** `bash ruleta.sh -m <dinero_inicial> -t <tecnica>` (ej: `martingala` o `inverseLabrouchere`)
    -   **Listar técnicas:** `bash ruleta.sh -l`
-   `test.sh`: Un script de prueba que demuestra la iteración y manipulación de arrays en Bash, incluyendo la suma de elementos extremos y la eliminación de elementos.
-   `ver`: Archivo de prueba.

### Buscador_Z4/

Este conjunto de scripts y archivos está diseñado para interactuar con la información de máquinas de Hack The Box.

-   `htbmachines.sh`: Un script robusto para buscar y obtener información sobre máquinas de Hack The Box. Permite buscar por nombre de máquina, IP, dificultad, sistema operativo, habilidades requeridas y obtener enlaces a tutoriales de YouTube. También incluye una función para actualizar los archivos de datos.
    -   **Uso:**
        -   `bash htbmachines.sh -u`: Descargar o actualizar archivos necesarios.
        -   `bash htbmachines.sh -m <nombre_maquina>`: Buscar por nombre de máquina.
        -   `bash htbmachines.sh -i <ip_maquina>`: Buscar por IP.
        -   `bash htbmachines.sh -y <nombre_maquina>`: Obtener enlace de YouTube.
        -   `bash htbmachines.sh -d <dificultad>`: Listar máquinas por dificultad.
        -   `bash htbmachines.sh -o <sistema_operativo>`: Listar máquinas por sistema operativo.
        -   `bash htbmachines.sh -s <skill>`: Buscar máquinas por habilidad.
        -   `bash htbmachines.sh -d <dificultad> -o <sistema_operativo>`: Combinar búsqueda por dificultad y SO.
-   `bundle.js`: Archivo JavaScript que contiene los datos de las máquinas de Hack The Box, utilizado por `htbmachines.sh`.
-   `conceptos.txt`: Documento que describe los conceptos de programación Bash aplicados en `htbmachines.sh`.
-   `asdccc`: Archivo de prueba.

### Calculadora_IP/

Contiene un script para realizar cálculos de red y funciones básicas de escaneo.

-   `ipCalc.sh`: Una calculadora de IP que toma una dirección CIDR y calcula la IP binaria, máscara binaria, Network ID (binario y decimal) y Broadcast (binario y decimal). También incluye opciones para escanear hosts activos con `arp-scan` y puertos con `nmap`.
    -   **Uso:**
        -   `bash ipCalc.sh -i <cidr>`: Realizar cálculos de red para el CIDR especificado.
        -   `bash ipCalc.sh -s`: Escanear hosts activos con ARP.
        -   `bash ipCalc.sh -n`: Escanear puertos con Nmap a un host específico (solicita la IP).

### Puertos/

Este directorio alberga scripts para el escaneo de red y una utilidad de descompresión.

-   `decompresor.sh`: Un script diseñado para descomprimir archivos anidados (por ejemplo, `.gz` dentro de `.gz`) hasta llegar al archivo final.
-   `hostScan.sh`: Un escáner de hosts simple que utiliza `ping` para identificar hosts activos en una subred local (192.168.100.x).
-   `portScan.sh`: Un escáner de puertos básico que intenta conectarse a todos los puertos (1-65535) en `localhost` para determinar cuáles están abiertos.
-   `prueva.sh`: Otro script de escaneo de puertos similar a `portScan.sh`, probablemente para pruebas.

## Instalación y Dependencias

Para ejecutar estos scripts, necesitarás tener Bash instalado en tu sistema. Algunos scripts tienen dependencias adicionales:

-   `htbmachines.sh`: Requiere `curl`, `js-beautify` y `md5sum`.
-   `ipCalc.sh`: Requiere `bc`, `arp-scan` y `nmap`. `arp-scan` y `nmap` pueden requerir permisos de superusuario (`sudo`).
-   `decompresor.sh`: Requiere `7z` (p7zip).

Puedes instalar estas dependencias usando el gestor de paquetes de tu distribución (ej: `sudo apt install curl js-beautify md5sum bc arp-scan nmap p7zip` en sistemas basados en Debian/Ubuntu).

## Contribuciones

¡Las contribuciones son bienvenidas! Si tienes mejoras, correcciones de errores o nuevos scripts Bash que te gustaría añadir, no dudes en abrir un "issue" o enviar un "pull request".
