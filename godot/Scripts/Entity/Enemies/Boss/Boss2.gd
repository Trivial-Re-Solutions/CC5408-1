extends KinematicBody2D

# Character
onready var CMain = get_tree().get_nodes_in_group("Player")[0]
onready var VMap = get_tree().get_nodes_in_group("Vortex2")[0]

var invulnerable = true
var vulnerated = 0

# Vida
var health = 500 setget set_health
func set_health(value):
	health = clamp(value, 0, 500)
	$Control/HealthBar.value = health
	if health == 0:
		VMap.win()
		queue_free()

func _ready():
	$Rotation/Shield/Area2D.connect("body_entered", self, "on_body_entered")
	$Timer.connect("timeout", self, "timer_off")
	
	$Rotation/Gems/AnimationPlayer.play("Idle")
	$AnimationPlayer.play("Idle")
	$Rotation/Gems.set_parameters(self, 1)
	$Rotation/Gems2.set_parameters(self, 2)

func _process(delta):
	var vec = Vector2(CMain.global_position - self.global_position)
	$Rotation.rotation = atan(vec.y/vec.x) - (PI if vec.x < 0 else 0)

func on_body_entered(body:Node):
	if (not body.is_in_group("Character")):
		return
	body.state.take_damage(10)

func timer_off():
	if (invulnerable):
		invulnerable = false
	else:
		$Rotation/Gems/Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		$Rotation/Gems2/Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	vulnerated = 0

func take_damage(damage, id):
	if (vulnerated == 0):
		vulnerated = id
		if (id == 1):
			$Rotation/Gems/Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
		elif (id == 2):
			$Rotation/Gems2/Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
		$Timer.start()
	elif (vulnerated != id):
		$Rotation/Gems/Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
		$Rotation/Gems2/Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
		invulnerable = false
		$Timer.start()
	if (invulnerable):
		return
	$Timer.start()
	set_health(health - damage)
	$Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
	yield(get_tree().create_timer(0.2), "timeout")
	$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
