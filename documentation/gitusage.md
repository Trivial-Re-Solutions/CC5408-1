# Instrucciones generales para el uso de Git

## Estado de la nota

En este documento se explica el uso básico de git y las limitaciones al utilizarlo.
Este documento se encuentra terminado pero peude estar sujeto a cambios en el futuro.

## Resumen

El repositorio git del proyecto esta almacenado en github bajo una organización creada
con el fin de permitir el desarrollo conjunto del juego sin mayores complicaciones.
Este repositorio tiene como limitacion que solo dispone de 0.5 GB de almacenamiento.

## Contenido

#### 1. Sobre el uso de git

Para trabajar en el proyecto se hará uso de Git, este programa puede ser descargado desde
link (1) y debe ser instalado por los miembros del equipo para poder bajar y subir cambios.

La instalación puede realizarse con los parámetros por defectos sin mayores consideraciones.
Se recomienda desactivar la opción "git gui" y asociar VSCode como editor de codigo principal.

    (1) Web de Git: https://git-scm.com/

#### 2. Sobre el repositorio

El repositorio del proyecto (CC5408-1) (2) es propiedad de Trivial Re-Solution y sus miembros.
El repositorio esta pensado para las siguientes categorias del materias en sus carpetas:

- documentation
  - Archivos de documentación y de referencia sobre la codificación
- godot
  - Archivos del proyecto godot y los recursos relacionados a este
- resources
  - Recursos gráficos y otros aun no implementados dentro de godot
- sketches
  - Bocetos y todo el material extra para facilitar el desarrollo

**Importante:** *Debido a la limitación de almacenamiento presente, no se deben subir videos o
imagenes en alta calidad, ni archivos no relacionados al proyecto al repositorio.*

    (2) Link del repositorio: https://github.com/Trivial-Re-Solutions/CC5408-1.git

#### 3. Sobre la preparación necesaria con Git

*Aviso: Para esta sección se asume que ya ha finalizada la instalación de git en su equipo.*
    
Solo se debe realizar una vez este proceso una vez, este consiste en descargar el repositorio Git.
Este proceso consiste en abrir el "bash git" desde el menu contextual en la carpeta donde se va a
trabajar y ejecutar el comando (3) para tener los archivos necesarios en el equipo de forma local.
    
    (3) git clone https://github.com/Trivial-Re-Solutions/CC5408-1.git

#### 4. Sobre la preparación

*Aviso: Todos los comandos Git en adelante seran ejecutados desde la carpeta "CC5408-1"*

Cada vez que inicie una sesión de trabajo en el proyecto es muy importante que descargue el
progreso del resto de miembros del equipo y que se coordine al momento de ejecutar cambios.
Para esto, debe ejecutar el comando (4) antes de abrir o trabajar con archivos del proyecto.

    (4) git pull

#### 5. Sobre como subir el progreso realizado

Cuando se termine se llegue a un punto de avance y se quiera guardar el progreso realizado
se deben ejecutar una serie de comandos con el fin de no generar problemas o perder archivos.

Es importante ejecutar nuevamente el comando (4) antes de seguir adelante con estos pasos.
Se debe ejecutar el comando (5) para añadir todos los cambios realizados al registro de Git
Se debe ejecutar el comando (6) para que estos cambios añadidos queden dentro de una versión.
se debe ejecutar el comando (7) para que esta versión local preparada se sincronice con Github.

    (5) git add .
    (6) git commit -m "mensaje"
    (7) git push

#### 6. Aclaraciones finales

Si tiene alguna duda sobre alguno de los contenidos de este documento consulte oportunamente.
Es una buena practica coordinar las sesiones de programación y los cambios entre los miembros
para reducir las probabilidades de que ocurra algun descordinación o problema en el repositorio.