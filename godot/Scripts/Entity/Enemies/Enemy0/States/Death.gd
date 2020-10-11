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
	print("State Enemy0: Death")
	Entity.travel("Death")
	yield(Entity.get_tree().create_timer(10.0), "timeout")

func exit():
	fsm.back()
