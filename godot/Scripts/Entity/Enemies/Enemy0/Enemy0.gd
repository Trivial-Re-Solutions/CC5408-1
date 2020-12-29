extends KinematicBody2D

# States
onready var state = $StateMachine
var Defend = preload("res://Scenes/Entity/Enemies/Enemy0/States/Defend.tscn").instance()
var Damage = preload("res://Scenes/Entity/Enemies/Enemy0/States/Damage.tscn").instance()
var Death = preload("res://Scenes/Entity/Enemies/Enemy0/States/Death.tscn").instance()

# Animation
onready var playback = $AnimationTree.get("parameters/playback")
var current_animation = "Idle"
var spawn_point = null

# Ataque
var AttackNode = preload("res://Scenes/Entity/Enemies/Enemy0/Attack.tscn")

# Character
onready var CMain = get_tree().get_nodes_in_group("Player")[0]

# Controles
var done_move = false
var keep_position = false
var invulnerable = false
var in_mainmap = false

var max_health = 40

# Vida
var health = 40 setget set_health
func set_health(value):
	if invulnerable:
		return
	if value < health:
		get_damage()
	health = clamp(value, 0, max_health)
	$ControlBar/HealthBar.value = health
	if health <= 0:
		state.change_to(Death)
		if (randi()%1 < 1 and in_mainmap):
			get_tree().get_nodes_in_group("MainMap")[0].get_key()

# ------------------------------------------------------------------------------
# Inicialización

func set_max_health(val):
	$ControlBar/HealthBar.max_value = val
	$ControlBar/HealthBar.value = val
	max_health = val
	health = val

func _ready() -> void:
	randomize()
	$Sprite.texture = load("res://sprites/enemies/Skulls/Skull"+String(randi()%5)+".png")
	
	Defend.set_params(self)
	Damage.set_params(self)
	Death.set_params(self)
	playback.start("Idle")
	state.change_to(Defend)
	spawn_point = self.global_position

# ------------------------------------------------------------------------------
# Control de ataque

func get_attack_pos():
	return $Attack.global_position

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
