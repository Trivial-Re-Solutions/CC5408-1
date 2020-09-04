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