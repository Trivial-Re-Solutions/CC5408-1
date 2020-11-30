extends Node

var fsm: StateMachine
var Entity: Node

# ------------------------------------------------------------------------------
# Inicialización

func set_params(Entity:Node):
	self.Entity = Entity

func enter():
	print("State Clone: Defend")

func exit(next_state):
	fsm.change_to(next_state)

func take_damage(value):
	Entity.set_health(Entity.health - value)
	#Entity.state.change_to(Entity.Damage)

