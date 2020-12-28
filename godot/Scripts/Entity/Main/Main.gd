extends KinematicBody2D

# States
onready var state = $StateMachine
var Defend = preload("res://Scenes/Entity/Main/States/Defend.tscn").instance()
var Damage = preload("res://Scenes/Entity/Main/States/Damage.tscn").instance()
var Death = preload("res://Scenes/Entity/Main/States/Death.tscn").instance()

var CClone = preload("res://Scenes/Entity/Clone/Clone.tscn")

# Clones
var CloneStorage = []
var CloneNum = 0

# Control de Clones
var recording = false
var saving_clone = false
var clone_active = true

# Diccionarios
var save_dict = {Vector2(-1,-1):"a", Vector2(0,-1):"b", Vector2(1,-1):"c",
				Vector2(-1,0):"d", Vector2(0,0):"e", Vector2(1,0):"f",
				Vector2(-1,1):"g", Vector2(0,1):"h", Vector2(1,1):"i"}

var run_dict = {Vector2(-1,-1):"Keep", Vector2(0,-1):"Run_U", Vector2(1,-1):"Keep",
				Vector2(-1,0):"Run_L", Vector2(0,0):"Last", Vector2(1,0):"Run_R",
				Vector2(-1,1):"Keep", Vector2(0,1):"Run_D", Vector2(1,1):"Keep"}

var attack_dict = {Vector2(0,-1):"Attack_U", Vector2(-1,0):"Attack_L", Vector2(1,0):"Attack_R", Vector2(0,1):"Attack_D"}

var idle_dict = {Vector2(0,-1):"Idle_U", Vector2(-1,0):"Idle_L", Vector2(1,0):"Idle_R", Vector2(0,1):"Idle_D"}

var rotate_dict = {Vector2(0,-1):270, Vector2(-1,0):180, Vector2(1,0):0, Vector2(0,1):90}
var scale_dict = {Vector2(0,-1):270, Vector2(-1,0):180, Vector2(1,0):0, Vector2(0,1):90}

# Animation
onready var playback = $AnimationTree.get("parameters/playback")
var last_animation = Vector2(0,1)
var current_animation = "Idle"
var is_attacking = false
var invulnerable = false

# Ataque
var Attack = preload("res://Scenes/Entity/Main/Attack.tscn")
var Sword = preload("res://Scenes/Entity/Main/Sword.tscn")

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
	if invulnerable:
		return
	if value < health:
		get_damage()
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
	state.force_change(Defend)

# ------------------------------------------------------------------------------
# Procesamiento

func _process(delta):
	if (recording):
		record()

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

func a_action(action:String):
	if (not saving):
		return
	save_string += action
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
	a_action("j")
	$Attack.rotation_degrees = rotate_dict [last_animation]
	travel(attack_dict [last_animation])
	
	var attack = Attack.instance()
	var sword = Sword.instance()	
	attack.set_damage(10)
	#attack.rotation_degrees = rotate_dict [last_animation]
	yield(get_tree().create_timer(0.2), "timeout")
	attack.add_child(sword)
	$Attack/Pos.add_child(attack)
	yield(get_tree().create_timer(0.6), "timeout")
	is_attacking = false
	get_parent().remove_child(attack)
	get_parent().remove_child(sword)

# ------------------------------------------------------------------------------
# Control de eventos

func zoom_camera(scale:Vector2):
	$Camera2D.zoom = scale

func _input(event) -> void:
	if (Input.is_action_just_pressed("action_attack") and not is_attacking):
		is_attacking = true
		attack()
	
	if (Input.is_action_just_pressed("action_record") and clone_active):
		record()

func get_damage():
	invulnerable = true
	$Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
	yield(get_tree().create_timer(0.2), "timeout")
	$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	yield(get_tree().create_timer(0.4), "timeout")
	invulnerable = false

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

# ------------------------------------------------------------------------------
# Control de Clones

func record():
	# Para que solo empiece a grabar una vez
	var record = Input.is_action_just_released("action_record")
	
	#if (not record):
	#	return
		
	if (saving_clone):
		stop_record()
		var CCloneNode = CClone.instance()
		CCloneNode.set_params(self)
		
		CCloneNode.start_movement("Clone"+str(CloneNum), 10)
		$Clone.add_child(CCloneNode)
		CloneNum += 1
		saving_clone = false
	
	elif (not saving_clone):
		start_record("Clone"+str(CloneNum))
		saving_clone = true

