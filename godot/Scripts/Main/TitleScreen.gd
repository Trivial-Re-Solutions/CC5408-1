extends CanvasLayer

var main_data

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$AnimationPlayer.play("run")
	
	$Panel/Main0/Game.connect("pressed", self, "on_Game_pressed")
	$Panel/Main0/Settings.connect("pressed", self, "on_Settings_pressed")
	$Panel/Main0/Exit.connect("pressed", self, "on_Exit_pressed")
	
	$Panel/Game/B0.connect("pressed", self, "on_0_pressed")
	$Panel/Game/B1.connect("pressed", self, "on_1_pressed")
	$Panel/Game/B2.connect("pressed", self, "on_2_pressed")
	$Panel/Game/Back.connect("pressed", self, "on_GBack_pressed")
	

# ------------------------------------------------------------------------------
# Control de escena

# Main0
func on_Game_pressed():
	main_data = GameManager.get_preview()
	if (main_data[0]["name"] != null):
		$Panel/Game/B0.text = 	main_data[0]["name"]
	if (main_data[1]["name"] != null):
		$Panel/Game/B1.text = 	main_data[1]["name"]
	if (main_data[2]["name"] != null):
		$Panel/Game/B2.text = 	main_data[2]["name"]
	$Panel/Main0.visible = false
	$Panel/Game.visible = true

func on_Settings_pressed():
	pass

func on_Exit_pressed():
	get_tree().quit()

# Game
func on_0_pressed():
	LevelManager.next()

func on_1_pressed():
	LevelManager.next()

func on_2_pressed():
	LevelManager.next()

func on_GBack_pressed():
	$Panel/Game.visible = false
	$Panel/Main0.visible = true
