extends Node

# Estado
var fsm: StateMachine
var Entity: Node

# Movimiento
var linear_vel = Vector2()
var facing_right = true


func set_params(Entity:Node):
	self.Entity = Entity

func enter():
	print("State Main: Damage")
	exit()

func exit():
	fsm.back()
