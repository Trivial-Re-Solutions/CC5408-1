extends KinematicBody2D

var parent

onready var state = self

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_parameters(node):
	parent = node

func take_damage(damage):
	parent.take_damage(damage)