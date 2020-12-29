extends Area2D

var damage = 5

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")
	connect("body_entered", self, "on_body_entered")

func set_damage(val:int):
	self.damage = val

# ------------------------------------------------------------------------------
# Manejo de eventos

func on_body_entered(body: Node):
	if (damage == 0):
		return
	if body.is_in_group("Character"):
		body.state.take_damage(damage)
