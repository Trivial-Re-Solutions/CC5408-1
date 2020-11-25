extends KinematicBody2D

# States
onready var state = $StateMachine
var Defend = preload("res://Scenes/Entity/Enemies/Enemy0/States/Defend.tscn").instance()
var Damage = preload("res://Scenes/Entity/Enemies/Enemy0/States/Damage.tscn").instance()
var Attack = preload("res://Scenes/Entity/Enemies/Enemy0/States/Attack.tscn").instance()
var Death = preload("res://Scenes/Entity/Enemies/Enemy0/States/Death.tscn").instance()

# Animation
onready var playback = $AnimationTree.get("parameters/playback")
var current_animation = "Idle"

# Ataque
var AttackNode = preload("res://scenes/Entity/Enemies/Enemy0/Attack.tscn")

# Character
onready var CMain = get_tree().get_nodes_in_group("Player")[0]

# Controles
var done_move = false

# Vida
var health = 100 setget set_health
func set_health(value):
	health = clamp(value, 0, 100)
	$ControlBar/HealthBar.value = health
	if health <= 0:
		state.change_to(Death)

# ------------------------------------------------------------------------------
# Inicialización

func _ready() -> void:
	Defend.set_params(self)
	Damage.set_params(self)
	Attack.set_params(self)
	Death.set_params(self)
	playback.start("Idle")
	state.change_to(Defend)

# ------------------------------------------------------------------------------
# Control de ataque

func get_attack_pos():
	return $Attack.global_position

# ------------------------------------------------------------------------------
# Control de animaciones

func travel(animation):
	if (animation == current_animation || not animation in $AnimationPlayer.get_animation_list()):
		return
	self.current_animation = animation
	playback.travel(current_animation)
