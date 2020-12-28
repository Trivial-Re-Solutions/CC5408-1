extends ColorRect

signal faded

# ------------------------------------------------------------------------------
# Inicialización

# ------------------------------------------------------------------------------
# Control de fade
	
func fade_in():
	$AnimationPlayer.play("fade_in")
	
func fade_out():
	$AnimationPlayer.play("fade_out")
