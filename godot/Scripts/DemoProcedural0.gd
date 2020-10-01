extends Node2D

export (int, 40, 400) var map_width = 100
export (int, 40, 400) var map_height = 100

var available_tiles = { "grass0": 0, "trees0": 1, "trees1": 2, "mountain0": 3,
						"mountain1": 4, "mountain2": 5, "water0": 6}

var terrain_map: TileMap = null
var noise: OpenSimplexNoise = null

func _ready() -> void:
	randomize()
	set_process(false)
	
	configurate_noise()
	configurate_tilemaps()
	generate_terrain()
	
func configurate_noise() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 25
	noise.lacunarity = 1.5
	noise.persistence = 2

func configurate_tilemaps() -> void:
	if (terrain_map != null):
		return
	# terrain_map = load("res://scenes/DemoProcedural0.tscn").instance()
	terrain_map = get_children()[0]
	add_child(terrain_map)

func generate_terrain() -> void:
	terrain_map.clear()
	generate_perimeter()
	
	for x in map_width:
		for y in map_height:
			# yield(get_tree(), "idle_frame")
			terrain_map.set_cellv(Vector2(x, y), get_tile(noise.get_noise_2d(float(x), float(y))))

func generate_perimeter() -> void:
	for x in [-1, map_width]:
		for y in map_height:
			terrain_map.set_cellv(Vector2(x, y), 6)
	
	for x in [-1, map_height]:
		for y in map_width+1:
			terrain_map.set_cellv(Vector2(x, y), 6)

func get_tile(noise: float):
	if (noise < 0.0):
		if (noise < -0.1):
			return available_tiles.water0
		return available_tiles.grass0
	
	if (noise < 0.1):
		if (noise < 0.03):
			return available_tiles.mountain2
		if (noise < 0.05):
			return available_tiles.mountain0
	
	if (noise < 0.3):
		if (noise < 0.15):
			return available_tiles.trees0
		return available_tiles.trees1
	
	return available_tiles.grass0

func _input(event) -> void:
	if Input.is_action_just_pressed("action_menu"):
		configurate_noise()
		generate_terrain()
