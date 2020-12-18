extends Node2D

# Escenas
var MDemo = preload("res://scenes/Maps/Procedural0.tscn")
var Camp0 = preload("res://scenes/Maps/MCamp0.tscn")
var Camp1 = preload("res://scenes/Maps/MCamp1.tscn")
var Camp2 = preload("res://scenes/Maps/MCamp2.tscn")
var Castle0 = preload("res://scenes/Maps/MCastle0.tscn")

# Mapa
var MDemoNode = MDemo.instance()
#var M0 = Camp0.instance()
#var M1 = Camp1.instance()
#var M2 = Camp2.instance()
#var M3 = Castle0.instance()
var map_scale = MDemoNode.scale
var map_mul = MDemoNode.mapmul

var generation = true

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

# ------------------------------------------------------------------------------
# Control de generación

func generate_map():
	var pos = Vector2( int($MainCharacter.position.x*1/(1024*map_scale.x*map_mul)),
		int($MainCharacter.position.y*1/(1024*map_scale.y*map_mul)))
	MDemoNode.generate_terrain(pos)
