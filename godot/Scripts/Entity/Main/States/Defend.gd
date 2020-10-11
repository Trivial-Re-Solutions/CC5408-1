extends Node

# Estado
var fsm: StateMachine
var Entity: Node

# Movimiento
var linear_vel = Vector2()
var facing_right = true

# ------------------------------------------------------------------------------
# Inicialización

func set_params(Entity:Node):
	self.Entity = Entity

func enter():
	print("State Main: Defend")

func exit(next_state):
	fsm.change_to(next_state)

# ------------------------------------------------------------------------------
# Procesamiento

func process(delta):
	if (!Entity.done_move):
		a_move()

# ------------------------------------------------------------------------------
# Control de movimiento

func a_move():
	var target_vel = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
			Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	Entity.a_record(target_vel)
	linear_vel = lerp(linear_vel, target_vel * 200, 0.5)
	linear_vel = Entity.move_and_slide(linear_vel)

func take_damage(value):
	Entity.set_health(Entity.health - value)
	Entity.state.change_to(Entity.Damage)
