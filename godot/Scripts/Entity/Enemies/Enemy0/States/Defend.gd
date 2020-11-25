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
	print("State Enemy0: Defend")

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
	var to_player = Vector2(Entity.CMain.global_position - Entity.global_position)
	var distance = to_player.length()
	if distance > 200:
		Entity.travel("Defend")
		return
	elif distance < 50:
		#Entity.travel("Defend")
		#Entity.state.change_to(Entity.Attack)
		return
	Entity.travel("Run")
	var target_vel = to_player.normalized()
	linear_vel = lerp(linear_vel, target_vel * 100, 0.5)
	linear_vel = Entity.move_and_slide(linear_vel)

func take_damage(value):
	Entity.set_health(Entity.health - value)
	Entity.state.change_to(Entity.Damage)
