extends Node2D

# Constantes
export (int) var mapmul = 1
export (int) var m_len = 32 *mapmul
export (int) var n_len = 8 *mapmul
export (int) var dif_len = int(m_len/n_len)

var minimap_scale:int
var minimap_center = Vector2(150, 100)

var Camp0 = preload("res://scenes/Maps/NCamp0.tscn")

var Instanced_camps = []

# Diccionarios
var terrain_dirt_tiles = { "grass0": 0, "grass1": 1, "grass2": 2, "grass3": 3, "mountain1": 4, "mountain2": 5, "sand0": 6}
var terrain_bush_tiles = { "grass": 0, "flower": 1, "bush": 2, "tree": 3, "ornament": 4, "dead": 5}
var terrain_tree_tiles = { "tree": 0, "dead": 1}
var water_tiles = { "autotile_water": 0, "deep_water": 1}

var minimap_tiles = { "water": 0, "grass": 1, "sand": 2, "castle": 3, "camp": 4}

var around = [Vector2(1,-1), Vector2(1,0), Vector2(1,1),
			Vector2(0,-1), Vector2(0,0), Vector2(0,1),
			Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1)]

# Generación
var noise: OpenSimplexNoise = null
var generated_chunks = []

var terrain_dirt_map: TileMap = null
var terrain_bush_map: TileMap = null
var terrain_tree_map: TileMap = null
var water_map: TileMap = null

var minimap_dirt: TileMap = null
var minimap_tree: TileMap = null

# ------------------------------------------------------------------------------
# Inicialización

func _ready() -> void:
	randomize()
	set_process(false)
	configurate_noise()
	configurate_tilemaps()
	
	minimap_scale = int(16*4*$CanvasLayer/CenterContainer/Node2D.scale.x) #130

# ------------------------------------------------------------------------------
# Configuración

func configurate_noise() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 2		# 3
	noise.period = 25		# 25
	noise.lacunarity = 1.5	# 1.5
	noise.persistence = 2	# 2

func configurate_tilemaps() -> void:
	terrain_dirt_map = $Node2D/Terrain_dirt
	terrain_bush_map = $Node2D/Terrain_bush
	terrain_tree_map = $Node2D/Terrain_tree
	water_map = $Node2D/Water
	
	minimap_dirt = $CanvasLayer/CenterContainer/Node2D/Terrain_dirt
	minimap_tree = $CanvasLayer/CenterContainer/Node2D/Terrain_tree

# ------------------------------------------------------------------------------
# Generación de terreno

func generate_terrain(pos):
	$CanvasLayer/CenterContainer/Node2D.position = minimap_center - pos*minimap_scale
	for arr in around:
		generate_chunk(pos+arr)

func generate_chunk(pos:Vector2)->void:
	if (generated_chunks.has(pos)):
		return
	print("Generando: "+String(pos))
	generated_chunks.append(pos)
	
	var x = m_len*pos.x-m_len/2
	var y = m_len*pos.y-m_len/2
	
	var _x = n_len*pos.x-n_len/2
	var _y = n_len*pos.y-n_len/2
	
	for i in n_len:
		for j in n_len:
			var noise_val = noise.get_noise_2d(float(x + i*dif_len), float(y + j*dif_len))
			minimap_dirt_generator (Vector2(_x + i, _y + j), noise_val)
			minimap_tree_generator (Vector2(_x + i, _y + j), noise_val)
	
	for i in m_len:
		for j in m_len:
			var noise_val = noise.get_noise_2d(float(x + i), float(y + j))
			terrain_dirt_generator (Vector2(x + i, y + j), noise_val)
			terrain_tree_generator (Vector2(x + i, y + j), noise_val)
			water_generator (Vector2(x + i, y + j), noise_val)
			camp_generator (Vector2(x + i, y + j), noise_val)
	
	$Node2D/Terrain_tree.update_bitmask_region(Vector2(x, y), Vector2(x + m_len, y + m_len))
	$Node2D/Terrain_bush.update_bitmask_region(Vector2(x, y), Vector2(x + m_len, y + m_len))
	$Node2D/Water.update_bitmask_region(Vector2(x, y), Vector2(x + m_len, y + m_len))

# ------------------------------------------------------------------------------
# Control de casillas

func toggle_minimap():
	$CanvasLayer/CenterContainer/Node2D.visible = not $CanvasLayer/CenterContainer/Node2D.visible
# ------------------------------------------------------------------------------
# Control de casillas

func minimap_dirt_generator (pos:Vector2, noise: float):
	if (noise < -0.3):
		minimap_dirt.set_cellv(pos, minimap_tiles.water); return
	if (noise < -0.1):
		minimap_dirt.set_cellv(pos, minimap_tiles.sand); return
	minimap_dirt.set_cellv(pos, minimap_tiles.grass); return

func minimap_tree_generator (pos:Vector2, noise: float):
	pass

func water_generator (pos:Vector2, noise: float):
	if (noise < -0.3):
		water_map.set_cellv(pos, water_tiles.autotile_water); return

func terrain_tree_generator (pos:Vector2, noise: float):
	if (noise > 0.0):
		if (randi()%50 < 1):
			terrain_tree_map.set_cellv(pos/2, terrain_tree_tiles.tree); return
	if (noise > -0.2): 
		if (randi()%8 < 1):
			terrain_bush_map.set_cellv(pos, terrain_bush_tiles.grass); return
		if (randi()%20 < 1):
			terrain_bush_map.set_cellv(pos, terrain_bush_tiles.flower); return
		if (randi()%30 < 1):
			terrain_bush_map.set_cellv(pos, terrain_bush_tiles.bush); return
		if (randi()%50 < 1):
			terrain_bush_map.set_cellv(pos, terrain_bush_tiles.ornament); return
	if (noise > -0.3 and noise < 0.1):
		if (randi()%10 < 1):
			terrain_bush_map.set_cellv(pos, terrain_bush_tiles.dead); return
		if (randi()%30 < 1):
				terrain_tree_map.set_cellv(pos/2, terrain_tree_tiles.dead); return

func terrain_dirt_generator (pos:Vector2, noise: float):
	if (noise < -0.2):
		terrain_dirt_map.set_cellv(pos, terrain_dirt_tiles.sand0); return
	
	# Flat
	if (noise < 0.1):
		if (noise < 0.03):
			terrain_dirt_map.set_cellv(pos, terrain_dirt_tiles.grass2); return
		if (noise < 0.05):
			terrain_dirt_map.set_cellv(pos, terrain_dirt_tiles.grass1); return
	
	# Hills
	if (noise < 0.3):
		if (noise < 0.15):
			terrain_dirt_map.set_cellv(pos, terrain_dirt_tiles.grass0); return
		terrain_dirt_map.set_cellv(pos, terrain_dirt_tiles.grass1); return
	
	terrain_dirt_map.set_cellv(pos, terrain_dirt_tiles.grass0); return

func camp_generator (pos:Vector2, noise: float):
	if (noise > 0.3 and randi()%5 < 1):
		if (Instanced_camps.size() == 0):
			pass
		else:
			var last_pos = Instanced_camps.back().position
			if (abs(last_pos.x - pos.x*32) + abs(last_pos.y - pos.y*32) < 2560):
				return
		print("Generando Campamento: "+String(pos))
		var camp_scene = random_camp()
		camp_scene.position = pos*32
		$Node2D/Node_Camp.add_child(camp_scene)
		Instanced_camps.append(camp_scene)

func random_camp():
	var randint = randi()%5
	
	return Camp0.instance()

# ------------------------------------------------------------------------------
# Control de eventos

