extends ColorRect

signal faded

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

# ------------------------------------------------------------------------------
# Control de fade

func on_animation_finished(anim_name: String):
	emit_signal("faded")
	
func fade_in():
	$AnimationPlayer.play("fade_in")
	
func fade_out():
	$AnimationPlayer.play("fade_out")
