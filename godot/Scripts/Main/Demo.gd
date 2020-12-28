extends Node2D

# Escenas
var MDemo = preload("res://Scenes/Maps/Procedural0.tscn")

# Mapa
var MDemoNode = MDemo.instance()
var map_scale = MDemoNode.scale
var map_mul = MDemoNode.mapmul

var generation = true

var has_key = true
var dialog

# Temporizador
var timer = Timer.new()

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	add_child(MDemoNode)
	var mazm = GameManager.save_data["mazm"]
	if (not mazm["A"]):
		dialog = "res://Dialogs/3/3-0.json"
	elif (not mazm["B"]):
			dialog = "res://Dialogs/6/6-0.json"
	elif (not mazm["C"]):
		dialog = "res://Dialogs/9/9-0.json"
	elif (not mazm["D"]):
		dialog = "res://Dialogs/12/12-0.json"
	$Dialogs.load_file(dialog, self)
	$Dialogs.start_dialog()

# ------------------------------------------------------------------------------
# Procesamiento

func _process(delta):
	if (generation):
		generate_map()

# ------------------------------------------------------------------------------
# Control de generación

func generate_map():
	var pos = Vector2( int($MainCharacter.position.x*1/(1024*map_scale.x*map_mul)),
		int($MainCharacter.position.y*1/(1024*map_scale.y*map_mul)))
	MDemoNode.generate_terrain(pos)

func end_dialog():
	LevelManager.next()
	$Dialogs.queue_free()

func is_stop():
	pass

func on_enter(body:Node):
	if (body.is_in_group("Player") and has_key):
		LevelManager.next()
