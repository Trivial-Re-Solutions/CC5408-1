extends KinematicBody2D

# States
onready var state = $StateMachine

var Entity: Node

# Diccionarios
var load_dict = {"a":Vector2(-1,-1), "b":Vector2(-1,0), "c":Vector2(-1,1),
				"d":Vector2(0,-1), "e":Vector2(0,0), "f":Vector2(0,1),
				"g":Vector2(1,-1), "h":Vector2(1,0), "i":Vector2(1,1)}

# Velocidad
var linear_vel = Vector2()
var target_vel = Vector2()

# Archivo
var file = File.new()
var file_name:String
var load_string:String
var str_len = 512
var ind:int

# Vida
var health = 100 setget set_health
func set_health(value):
	health = clamp(value, 0, 100)
	$ControlBar/HealthBar.value = health
	if health == 0:
		killed()

# Controles
var done_move = true

# Temporizadores
var time:int

func set_params(Entity:Node):
	self.Entity = Entity

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$ControlBar/TimeBar.max_value = time
	$ControlBar/TimeBar.value = time
	$Timer.connect("timeout",self,"_on_timer_timeout")
	$Timer.start()

func start_movement(file_name:String, time:int):
	self.file_name = file_name
	self.time = time
	file.open_compressed("user://"+file_name+".dat", File.READ, File.COMPRESSION_ZSTD)
	load_string = a_load()
	done_move = false

# ------------------------------------------------------------------------------
# Procesamiento

func _process(delta):
	if !done_move:
		a_move()

# ------------------------------------------------------------------------------
# Control de movimiento

func a_move():
	target_vel = load_dict[String(load_string.substr(ind, 1))]
	ind += 1
	
	if (load_string.length() != str_len):
		if (ind >= load_string.length()):
			done_move = true
	elif (ind >= str_len):
		load_string = a_load()
		ind = 0
	linear_vel = lerp(linear_vel, target_vel * 200, 0.5)
	linear_vel = move_and_slide(linear_vel)

func a_load():
	position = Vector2(file.get_float(), file.get_float())
	return file.get_line()

# ------------------------------------------------------------------------------
# Control de daño

func killed():
	pass
	#Entity.del_clone(self)
	#queue_free()

# ------------------------------------------------------------------------------
# Control de temporizadores

func _on_timer_timeout():
	time -=1
	$ControlBar/TimeBar.value = time
	
	if (time <= 0):
		killed()
