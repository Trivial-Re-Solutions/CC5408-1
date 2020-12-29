extends Node2D

var ready_dial = {"scene":"Name","chars":0,"names":{},"dials":1,"texts":{"0":{"P":-1,"D":"Viajero... Has encontrado la llave de esta mazmorra"}}}

# Escenas
var MDemo = preload("res://Scenes/Maps/Procedural0.tscn")

# Mapa
var MDemoNode = MDemo.instance()
var map_scale = MDemoNode.scale
var map_mul = MDemoNode.mapmul

var generation = true

var has_key = false
var dialog

# Temporizador
var timer = Timer.new()

var out1 = preload("res://Scenes/Vortex/Out1.tscn")
var out2 = preload("res://Scenes/Vortex/Out2.tscn")
var out3 = preload("res://Scenes/Vortex/Out3.tscn")
var out4 = preload("res://Scenes/Vortex/Out4.tscn")

var act_out

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$Area2D.connect("body_entered", self, "enter_door")
	
	$Procedural.add_child(MDemoNode)
	var mazm = GameManager.save_data["mazm"]
	if (not mazm["A"]):
		dialog = "res://Dialogs/3/3-0.json"
		act_out = out1.instance()
	elif (not mazm["B"]):
			dialog = "res://Dialogs/6/6-0.json"
			act_out = out2.instance()
	elif (not mazm["C"]):
		dialog = "res://Dialogs/9/9-0.json"
		act_out = out3.instance()
	elif (not mazm["D"]):
		dialog = "res://Dialogs/12/12-0.json"
		act_out = out4.instance()
	$Dialogs.load_file(dialog, self)
	$Dialogs.start_dialog()
	$Out.add_child(act_out)

# ------------------------------------------------------------------------------
# Procesamiento

func _process(delta):
	if (generation):
		generate_map()

# ------------------------------------------------------------------------------
# Control de generación

func open_door():
	$Out.get_child(0).open_door()

func enter_door(body:Node):
	if (body.is_in_group("Player") and has_key):
		LevelManager.next()

func generate_map():
	var pos = Vector2( int($MainCharacter.position.x*1/(1024*map_scale.x*map_mul)),
		int($MainCharacter.position.y*1/(1024*map_scale.y*map_mul)))
	MDemoNode.generate_terrain(pos)

func get_key():
	has_key = true
	open_door()
	$Dialogs.show()
	$Dialogs.dict = ready_dial
	$Dialogs.start_dialog()

func end_dialog():
	$Dialogs.hide()

func is_stop():
	pass
