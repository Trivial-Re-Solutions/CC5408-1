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
	print("State Enemy0: Attack")
	var attack = Entity.AttackNode.instance()
	attack.set_damage(10)
	yield(Entity.get_tree().create_timer(0.2), "timeout")
	Entity.get_parent().add_child(attack)
	# attack.rotation = 0 if facing_right else PI
	attack.global_position = Entity.get_attack_pos()
	Entity.travel("Attack")
	yield(Entity.get_tree().create_timer(0.4), "timeout")
	Entity.travel("Defend")
	exit()

func exit():
	fsm.back()
