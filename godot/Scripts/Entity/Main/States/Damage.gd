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
	Entity.travel("Damage")
	yield(Entity.get_tree().create_timer(0.3), "timeout")
	exit()

func exit():
	fsm.back()
