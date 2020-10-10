extends Area2D

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$VisibilityNotifier2D.connect("screen_exited", self, "queue_free")
	connect("body_entered", self, "on_body_entered")

# ------------------------------------------------------------------------------
# Manejo de eventos

func on_body_entered(body: Node):
	if body.is_in_group("Enemy"):
		body.queue_free()
