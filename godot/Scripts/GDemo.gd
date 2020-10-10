extends Node2D

# Escenas
var MDemo = preload("res://scenes/MProcedural0.tscn")
var CClone = preload("res://scenes/CClone.tscn")

# Mapa
var MDemoNode = MDemo.instance()
var map_scale = MDemoNode.scale
var map_mul = MDemoNode.mapmul

# Clones
var CloneStorage = []

# Controles
var generation = true
var recording = true
var saving = false

# Temporizador
var timer = Timer.new()

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	add_child(MDemoNode)

# ------------------------------------------------------------------------------
# Procesamiento

func _process(delta):
	if (generation):
		generate_map()
	if (recording):
		record()

# ------------------------------------------------------------------------------
# Control de guardado

func record():
	var record = Input.is_action_just_released("action_record")
	
	if (not record):
		return
		
	if (saving):
		$MainCharacter.stop_record()
		var CCloneNode = CClone.instance()
		
		CCloneNode.start_movement("Clone"+str(len(CloneStorage)), 10)
		add_child(CCloneNode)
		CloneStorage.append(CCloneNode)
		saving = false
	
	elif (not saving):
		$MainCharacter.start_record("Clone"+str(len(CloneStorage)))
		saving = true

# ------------------------------------------------------------------------------
# Control de generación

func generate_map():
	var pos = Vector2( int($MainCharacter.position.x*1/(1024*map_scale.x*map_mul)),
		int($MainCharacter.position.y*1/(1024*map_scale.y*map_mul)))
	MDemoNode.generate_terrain(pos)
