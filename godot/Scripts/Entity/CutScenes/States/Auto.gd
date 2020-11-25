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
	print("State Main: Auto")

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
	linear_vel = lerp(linear_vel, Vector2(1, 0) * 200, 0.5)
	linear_vel = Entity.move_and_slide(linear_vel)

func take_damage(value):
	pass
