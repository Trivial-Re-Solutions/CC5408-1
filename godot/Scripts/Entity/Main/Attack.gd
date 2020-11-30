extends Area2D

var damage = 10

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")
	connect("body_entered", self, "on_body_entered")
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()

func set_damage(val:int):
	self.damage = val

# ------------------------------------------------------------------------------
# Manejo de eventos

func on_body_entered(body: Node):
	if (damage == 0):
		return
	if body.is_in_group("Enemy"):
		body.state.take_damage(damage)
