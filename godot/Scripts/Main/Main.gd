extends Node2D

# Diccionarios
var Levels = [preload("res://Scenes/Main/TitleScreen.tscn"),
			preload("res://Scenes/Main/Intro.tscn"),
			preload("res://Scenes/Main/Tutorial.tscn"),
			preload("res://Scenes/Main/TimeHall.tscn"),
			preload("res://Scenes/Main/Demo.tscn"),
			preload("res://Scenes/Vortex/VortexHub.tscn")]

# Niveles
var current_level = 0
var current_world: Node = null

# Controles
var loading = false

# ------------------------------------------------------------------------------
# Inicialización

onready var fade = $CanvasLayer/Fade

func _ready():
	fade.connect("faded", self, "on_faded")
	current_world = Levels[0].instance()
	$World.add_child(current_world)

# ------------------------------------------------------------------------------
# Control de escenas

func change_scene(scene):
	var s = load(scene).instance()
	$World.remove_child(current_world)
	current_world.queue_free()
	current_world = s
	$World.add_child(current_world)

func restart():
	loading = true
	fade.fade_in()

func next():
	current_level += 1
	loading = true
	fade.fade_in()

func back():
	current_level -= 1
	loading = true
	fade.fade_in()

func toGame():
	current_level = 3
	loading = true
	fade.fade_in()

func toDemo():
	current_level = 4
	loading = true
	fade.fade_in()

func toVortex():
	current_level = 5
	loading = true
	fade.fade_in()

func on_faded():
	if !loading:
		return
	$World.remove_child(current_world)
	current_world.queue_free()
	current_world = Levels[current_level].instance()
	$World.add_child(current_world)
	loading = false
	fade.fade_out()
		
func reset():
	current_level = 0
	loading = true
	fade.fade_in()
