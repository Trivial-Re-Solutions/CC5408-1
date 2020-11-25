extends KinematicBody2D

# States
onready var state = $StateMachine
var Move = preload("res://scenes/entity/Cutscenes/States/Auto.tscn").instance()

# Controles
var done_move = false

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	Move.set_params(self)
	state.force_change(Move)

# ------------------------------------------------------------------------------
# Control de eventos

func _input(event) -> void:
	if Input.is_action_just_pressed("action_menu"):
		pass
