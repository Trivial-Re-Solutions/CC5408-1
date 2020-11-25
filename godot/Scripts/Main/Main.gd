extends Node2D

# Diccionarios
var Levels = [preload("res://scenes/Main/TitleScreen.tscn"),
			#preload("res://scenes/Cutscene/Prelude2.tscn"),
			preload("res://scenes/Main/Demo.tscn")]

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

func next():
	if current_level + 1 >= Levels.size():
		return
	loading = true
	fade.fade_in()

func on_faded():
	if !loading:
		return
	$World.remove_child(current_world)
	current_world.queue_free()
	current_level += 1
	current_world = Levels[current_level].instance()
	$World.add_child(current_world)
	loading = false
	fade.fade_out()
		
func reset():
	current_level = -1
	loading = true
	fade.fade_in()
