extends Node

# Estado
var fsm: StateMachine
var Entity: Node

# Movimiento
var linear_vel = Vector2()
var facing_right = true
var backing = false
var target_vel = Vector2()

var periodic = 0

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
	var distance_player = to_player.length()
	if distance_player > 800:
		return
	
	var to_spawn = Vector2(Entity.spawn_point - Entity.global_position)
	var distance_spawn = to_spawn.length()
	if distance_spawn > 600:
		backing = true
		target_vel = to_spawn.normalized()
	elif distance_spawn < 100 and backing:
		backing = false
	elif distance_player > 300 or backing:
		target_vel = to_spawn.normalized()
	else:
		target_vel = to_player.normalized()
	
	periodic +=0.05
	if distance_player > 50:
		target_vel += Vector2(sin(periodic)*1.5, cos(periodic)*1.5)
	else:
		target_vel += Vector2(sin(periodic)*1.2+sin(periodic*4)*0.4, cos(periodic)*1.2+cos(periodic*4)*0.4)
	linear_vel = lerp(linear_vel, target_vel * 100, 0.5)
	linear_vel = Entity.move_and_slide(linear_vel)

func take_damage(value):
	Entity.set_health(Entity.health - value)
	Entity.state.change_to(Entity.Damage)
