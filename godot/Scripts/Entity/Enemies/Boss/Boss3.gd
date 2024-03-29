extends KinematicBody2D

# Character
onready var CMain = get_tree().get_nodes_in_group("Player")[0]
onready var VMap = get_tree().get_nodes_in_group("Vortex1")[0]

var invulnerable = false

# Vida
var health = 200 setget set_health
func set_health(value):
	health = clamp(value, 0, 100)
	$Control/HealthBar.value = health
	if health == 0:
		VMap.win()
		queue_free()

func _ready():
	$Rotation/Shield/Area2D.connect("body_entered", self, "on_body_entered")
	
	$Rotation/Gems/AnimationPlayer.play("Idle")
	$AnimationPlayer.play("Idle")
	$Rotation/Gems.set_parameters(self)

func _process(delta):
	var vec = Vector2(CMain.global_position - self.global_position)
	$Rotation.rotation = atan(vec.y/vec.x) - (PI if vec.x < 0 else 0)

func on_body_entered(body:Node):
	if (not body.is_in_group("Character")):
		return
	body.state.take_damage(10)

func take_damage(damage):
	if (invulnerable):
		return
	invulnerable = true
	set_health(health - damage)
	$Sprite.modulate = Color(1.0, 0.0, 0.0, 1.0)
	yield(get_tree().create_timer(0.2), "timeout")
	$Sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	yield(get_tree().create_timer(0.4), "timeout")
	invulnerable = false
