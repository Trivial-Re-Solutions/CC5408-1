extends Node

# ------------------------------------------------------------------------------
# Inicialización

onready var Game = get_tree().get_root().get_node("Game")

# ------------------------------------------------------------------------------
# Control de escenas

func next():
	Game.next()  

func change_scene(scene):
	Game.change_scene(scene)

func reset():
	Game.reset()
