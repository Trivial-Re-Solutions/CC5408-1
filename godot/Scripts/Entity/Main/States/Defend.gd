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
	a_move()

# ------------------------------------------------------------------------------
# Control de movimiento

func a_move():
	var target_vel
	var record_vel
	if (!Entity.done_move):
		var x_vel = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		var y_vel = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
		
		target_vel = Vector2(x_vel*0.7 if y_vel != 0 else x_vel, y_vel*0.7 if x_vel != 0 else y_vel)
		record_vel = Vector2(x_vel, y_vel)
	else:
		target_vel = Vector2(0.0, 0.0)
		record_vel = Vector2(0.0, 0.0)
	if(Entity.get_slide_count() > 0):
		if(abs(linear_vel.x) < 0.3):
			record_vel.x = 0
		if(abs(linear_vel.y) < 0.3):
			record_vel.y = 0
		#record_vel = Vector2(0.0, 0.0)
	
	Entity.a_record(record_vel)
	Entity.animation_vector(record_vel)
	linear_vel = lerp(linear_vel, target_vel * 200, 0.5)
	linear_vel = Entity.move_and_slide(linear_vel)

func take_damage(value):
	Entity.set_health(Entity.health - value)
	#Entity.state.change_to(Entity.Damage)
	
