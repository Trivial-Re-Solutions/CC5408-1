extends KinematicBody2D

var bodies = []

# ------------------------------------------------------------------------------
# Inicialización

func _ready() -> void:
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Area2D.connect("body_exited", self, "on_body_exited")

# ------------------------------------------------------------------------------
# Procesamiento

func _physics_process(delta: float) -> void:
	for body in bodies:
		if body.is_in_group("player"):
			body.take_damage(10)

# ------------------------------------------------------------------------------
# Manejo de eventos

func on_body_entered(body: Node):
	bodies.push_back(body)

func on_body_exited(body: Node):
	bodies.erase(body)
