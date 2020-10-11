extends Node2D

# Constantes
export (int) var mapmul = 1
export (int) var m_len = 32 *mapmul

# Diccionarios
var available_tiles0 = { "grass0": 0, "trees0": 1, "trees1": 2, "mountain0": 3,
						"mountain1": 4, "mountain2": 5, "water0": 6}
var around = [Vector2(1,-1), Vector2(1,0), Vector2(1,1),
			Vector2(0,-1), Vector2(0,0), Vector2(0,1),
			Vector2(-1,-1), Vector2(-1,0), Vector2(-1,1)]

# Generación
var generated_chunks = []
var terrain_map: TileMap = null
var noise: OpenSimplexNoise = null

# ------------------------------------------------------------------------------
# Inicialización

func _ready() -> void:
	randomize()
	set_process(false)
	configurate_noise()
	configurate_tilemaps()

# ------------------------------------------------------------------------------
# Configuración

func configurate_noise() -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 2		# 3
	noise.period = 65		# 25
	noise.lacunarity = 2.5	# 1.5
	noise.persistence = 2	# 2

func configurate_tilemaps() -> void:
	if (terrain_map != null):
		return
	terrain_map = $TileMap0

# ------------------------------------------------------------------------------
# Generación de terreno

func generate_terrain(pos):
	if (generated_chunks.has(pos)):
		return
	for arr in around:
		generate_chunk(pos+arr)
	generated_chunks.append(pos)
	print("Generando: "+String(pos))

func generate_chunk(pos:Vector2)->void:
	for i in m_len:
		for j in m_len:
			terrain_map.set_cellv(Vector2(m_len*pos.x-m_len/2+i, m_len*pos.y-m_len/2+j),
				get_tile0(noise.get_noise_2d(float(m_len*pos.x-m_len/2+i), float(m_len*pos.y-m_len/2+j))))

# ------------------------------------------------------------------------------
# Control de casillas

func get_tile0(noise: float):
	if (noise < 0.0):
		if (noise < -0.1):
			return available_tiles0.water0
		return available_tiles0.grass0
	
	if (noise < 0.1):
		if (noise < 0.03):
			return available_tiles0.mountain2
		if (noise < 0.05):
			return available_tiles0.mountain0
	
	if (noise < 0.3):
		if (noise < 0.15):
			return available_tiles0.trees0
		return available_tiles0.trees1
	
	return available_tiles0.grass0

# ------------------------------------------------------------------------------
# Control de eventos

