extends KinematicBody2D

# States
onready var state = $StateMachine

var Entity: Node
var Defend = preload("res://Scenes/Entity/Clone/States/Idle.tscn").instance()

var action_dict = {"a":"Move", "b":"Move", "c":"Move", "d":"Move", "e":"Move", "f":"Move",
				"g":"Move", "h":"Move", "i":"Move", "j":"Attack"}

# Diccionarios
var load_dict = {"a":Vector2(-1,-1), "b":Vector2(0,-1), "c":Vector2(1,-1),
				"d":Vector2(-1,0), "e":Vector2(0,0), "f":Vector2(1,0),
				"g":Vector2(-1,1), "h":Vector2(0,1), "i":Vector2(1,1)}

var run_dict = {Vector2(-1,-1):"Keep", Vector2(0,-1):"Run_U", Vector2(1,-1):"Keep",
				Vector2(-1,0):"Run_L", Vector2(0,0):"Last", Vector2(1,0):"Run_R",
				Vector2(-1,1):"Keep", Vector2(0,1):"Run_D", Vector2(1,1):"Keep"}

var attack_dict = {Vector2(0,-1):"Attack_U", Vector2(-1,0):"Attack_L", Vector2(1,0):"Attack_R", Vector2(0,1):"Attack_D"}

var idle_dict = {Vector2(0,-1):"Idle_U", Vector2(-1,0):"Idle_L", Vector2(1,0):"Idle_R", Vector2(0,1):"Idle_D"}

var rotate_dict = {Vector2(0,-1):270, Vector2(-1,0):180, Vector2(1,0):0, Vector2(0,1):90}

# Velocidad
var linear_vel = Vector2()
var target_vel = Vector2()

# Archivo
var file = File.new()
var file_name:String
var load_string:String
var str_len = 512
var ind:int

# Animation
onready var playback = $AnimationTree.get("parameters/playback")
var last_animation = Vector2(0,1)
var current_animation = "Idle"
var is_attacking = false
var invulnerable = false

# Ataque
var Attack = preload("res://scenes/Entity/Main/Attack.tscn")
var Sword = preload("res://scenes/Entity/Main/Sword.tscn")

# Vida
var health = 100 setget set_health
func set_health(value):
	if invulnerable:
		return
	if value < health:
		get_damage()
	health = clamp(value, 0, 100)
	$ControlBar/HealthBar.value = health
	if health == 0:
		killed()

# Controles
var done_move = true

# Temporizadores
var time:int

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$ControlBar/TimeBar.max_value = time
	$ControlBar/TimeBar.value = time
	$Timer.connect("timeout",self,"_on_timer_timeout")
	$Timer.start()
	
	Defend.set_params(self)
	playback.start("Idle")
	state.force_change(Defend)

func start_movement(file_name:String, time:int):
	self.file_name = file_name
	self.time = time
	file.open_compressed("user://"+file_name+".dat", File.READ, File.COMPRESSION_ZSTD)
	load_string = a_load()
	done_move = false

func set_params(entity):
	self.Entity = entity

# ------------------------------------------------------------------------------
# Procesamiento

func _process(delta):
	if !done_move:
		a_move()

# ------------------------------------------------------------------------------
# Control de movimiento

func a_move():
	var load_val = String(load_string.substr(ind, 1))
	if (action_dict[load_val] == "Attack"):
		attack()
		ind += 1
		return
	target_vel = load_dict[load_val]
	animation_vector(target_vel)
	ind += 1
	
	if (load_string.length() != str_len):
		if (ind >= load_string.length()):
			done_move = true
			animation_vector(Vector2(0,0))
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

func attack():
	$Attack.rotation_degrees = rotate_dict [last_animation]
	travel(attack_dict [last_animation])
	
	var attack = Attack.instance()
	var sword = Sword.instance()	
	attack.set_damage(10)
	attack.rotation_degrees = rotate_dict [last_animation]
	yield(get_tree().create_timer(0.2), "timeout")
	attack.add_child(sword)
	get_parent().add_child(attack)
	attack.global_position = $Attack.get_child(0).global_position
	sword.global_position = $Attack.get_child(0).global_position
	yield(get_tree().create_timer(0.3), "timeout")
	attack.global_position = $Attack.get_child(0).global_position
	sword.global_position = $Attack.get_child(0).global_position
	yield(get_tree().create_timer(0.3), "timeout")
	is_attacking = false
	get_parent().remove_child(attack)
	get_parent().remove_child(sword)

func get_damage():
	invulnerable = true
	$Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
	yield(get_tree().create_timer(0.2), "timeout")
	$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	yield(get_tree().create_timer(0.4), "timeout")
	invulnerable = false

func killed():
	queue_free()

# ------------------------------------------------------------------------------
# Control de temporizadores

func _on_timer_timeout():
	time -=1
	$ControlBar/TimeBar.value = time
	
	if (time < 0):
		killed()

# ------------------------------------------------------------------------------
# Control de animaciones

func travel(animation):
	if (animation == current_animation || not animation in $AnimationPlayer.get_animation_list()):
		return
	self.current_animation = animation
	playback.travel(current_animation)

func animation_vector(vector):
	var run_text = run_dict [vector]
	if (run_text == "Last"):
		travel(idle_dict [last_animation])
	elif(run_text == "Keep"):
		travel(run_dict [last_animation])
	else:
		last_animation = vector
		travel(run_text)
