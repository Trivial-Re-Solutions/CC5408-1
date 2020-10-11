extends KinematicBody2D

# States
onready var state = $StateMachine
var Defend = preload("res://Scenes/Entity/Main/States/Defend.tscn").instance()
var Damage = preload("res://Scenes/Entity/Main/States/Damage.tscn").instance()
var Death = preload("res://Scenes/Entity/Main/States/Death.tscn").instance()

# Diccionarios
var save_dict = {Vector2(-1,-1):"a", Vector2(-1,0):"b", Vector2(-1,1):"c",
				Vector2(0,-1):"d", Vector2(0,0):"e", Vector2(0,1):"f",
				Vector2(1,-1):"g", Vector2(1,0):"h", Vector2(1,1):"i"}

# Animation
onready var playback = $AnimationTree.get("parameters/playback")
var current_animation = "Idle"

# Ataque
var Attack = preload("res://scenes/Entity/Main/Attack.tscn")

# Archivo
var file = File.new()
var file_name:String
var save_string:String
var str_len = 512
var ind:int

# Controles
var done_move = false
var saving = false

# Vida
var health = 100 setget set_health
func set_health(value):
	health = clamp(value, 0, 100)
	$ControlBar/HealthBar.value = health
	if health == 0:
		pass

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	Defend.set_params(self)
	Damage.set_params(self)
	playback.start("Idle")
	state.change_to(Defend)

# ------------------------------------------------------------------------------
# Control de guardado

func start_record(file_name:String):
	if (saving):
		return
	self.file_name = file_name
	file.open_compressed("user://"+file_name+".dat", File.WRITE, File.COMPRESSION_ZSTD)
	file.store_float(position.x)
	file.store_float(position.y)
	saving = true

func stop_record():
	if (not saving):
		return
	a_save (save_string)
	file.close()
	save_string = ""
	saving = false
	ind = 0

func a_record(target_vel):
	if (not saving):
		return
	save_string += save_dict[target_vel]
	ind += 1
	if (ind < str_len):
		return
	a_save (save_string)
	save_string = ""
	ind = 0

func a_save(text):
	file.store_line(text)
	file.store_float(position.x)
	file.store_float(position.y)

# ------------------------------------------------------------------------------
# Control de ataque

func attack():
	var attack = Attack.instance()
	attack.set_damage(10)
	get_parent().add_child(attack)
	# attack.rotation = 0 if facing_right else PI
	attack.global_position = $Attack.global_position

func get_attack_pos():
	return $Attack.global_position

# ------------------------------------------------------------------------------
# Control de eventos

func _input(event) -> void:
	if Input.is_action_just_pressed("action_menu"):
		attack()

# ------------------------------------------------------------------------------
# Control de animaciones

func travel(animation):
	if (animation == current_animation || not animation in $AnimationPlayer.get_animation_list()):
		return
	self.current_animation = animation
	playback.start(current_animation)
