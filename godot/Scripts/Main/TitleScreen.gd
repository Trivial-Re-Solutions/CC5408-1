extends CanvasLayer

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$Panel/VBoxContainer/Procedural.connect("pressed", self, "on_Procedural_pressed")
	$Panel/VBoxContainer/Exit.connect("pressed", self, "on_Exit_pressed")

# ------------------------------------------------------------------------------
# Control de escena

func on_Procedural_pressed():
	LevelManager.next()

func on_Exit_pressed():
	get_tree().quit()
