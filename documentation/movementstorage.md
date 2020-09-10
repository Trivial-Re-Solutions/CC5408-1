# Implementación de la mecánica del juego

## Estado de la nota

En este documento se especifica la estructura de guardado de movimientos de un
personaje y su implementación básica para las funciones requeridas en el juego.

## Resumen

La mecanica principal del juego consiste en almacenar y repetir gameplays anteriores
del personaje en el juego para generar interacciones y permitir resolver puzzles.
Esto requiere alguna estructura simple para poder organizar estos datos que cumpla
con los requerimientos de almacenamiento y rendimiento pertinentes al proyecto.

## Contenido

#### 1. Sobre la base de la idea

La mecánica principal del juego consiste almacenar las acciones realizadas por el
jugador con su personaje y poder replicarlas en algun momento del juego posterior. 
Para almacenar el movimiento del personajes son necesarios los siguientes requisitos:

- El movimiento guardado debe ser preciso
- El guardado debe permanecer tras partidas
- Debe utilizar un espacio razonable y ser rapido

Estos problemas se pueden solucionar utilizando un archivo de guardado comprimido.

#### 2. Apertura de archivos

Godot dispone de un sistema para manejar archivos de forma simple para lo que haremos,
estos archivos se guardan en una carpeta propia del proyecto en la que trabajaremos.
Los archivos se pueden cargar usando la clase "File" con el comando (1) y abrir luego
en modo escritura usando el comando (2) o en modo lectura usando el comando (3).
Por defecto, usaremos una compresión del tipo "zstandard" para optimizar espacio.

    (1) var file = File.new()
    (2) file.open_compressed("user://archivo", File.WRITE, File.COMPRESSION_ZSTD)
    (3) file.open_compressed("user://archivo", File.READ, File.COMPRESSION_ZSTD)

**Importante:** *Abrir el archivo en modo escritura sobrescribe el archivo existente.*

#### 3. Estructura al guardar los datos

Los datos guardados para almacenar los movimientos se componen por los siguientes datos:

- Posición absoluta del personaje
  - Esta se utiliza evitar acumular errores en el movimiento
- String de 512 Byts con instrucciones de movimiento
  - Cada Char representa la acción realizada en un flame

Para la traducción de las instrucciones de movimiento a caracteres para almacenar se
utilizan 2 diccionarios segun el sentido de la interpretación, estos permiten pasar
de vector de target_vel a char de forma eficiente y sin problemas mayores.

**Importante:** *Este metodo actual no sirve para gamepads ya que asume vectores de
movimiento discretos con valores de -1, 0 ó 1 y no continuos según la inclinación.*

#### 4. Guardado de los datos

Para almacenar los datos se usaran los metodos provistos por la clase File, estos son:
- file.store_line(string)
  - Para almacenar Strings con interucciones de movimiento
- file.store_float(float)
  - Para almacenar la coordenada del personaje

Para cargar los datos desde el archivo se utilizan metodos similares a los anteriores:
- file.get_line()
- file.get_float()

#### 5. Sobre el rendimiento de la solución

Se ha comprobado despues de probar esta solución en la demo de movimiento que guardar
de esta forma los datos y con un apropiado largo de string no genera lag spikes.
El tamaño de archivo promedio final varía entre 2 a 5 minutos guardados por KiloByte.
No se ha encontrado ninguna inconsistencia en los movimientos usando esta opción por
lo que actualmente se considera suficientemente buena para los resultados esperados.

#### 6. Aclaraciones finales

Como se utiliza un Char dentro de la cadena de string para almacenar las instrucciones,
se pueden añadir instrucciones extra ademas de las 9 existentes para el movimiento.
Se puede cambiar el tamaño del string almacenado cada ciclo facilmente ante problemas.