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
	
	$Panel/Del/B0.connect("pressed", self, "on_0_del")
	$Panel/Del/B1.connect("pressed", self, "on_1_del")
	$Panel/Del/B2.connect("pressed", self, "on_2_del")
	

# ------------------------------------------------------------------------------
# Control de escena

# Main0
func on_Game_pressed():
	main_data = GameManager.get_preview()
	if (main_data["0"]["name"] != null):
		$Panel/Game/B0.text = 	main_data["0"]["name"]
	else:
		$Panel/Game/B0.text = 	"Nueva partida"
	if (main_data["1"]["name"] != null):
		$Panel/Game/B1.text = 	main_data["1"]["name"]
	else:
		$Panel/Game/B1.text = 	"Nueva partida"
	if (main_data["2"]["name"] != null):
		$Panel/Game/B2.text = 	main_data["2"]["name"]
	else:
		$Panel/Game/B2.text = 	"Nueva partida"
	$Panel/Main0.visible = false
	$Panel/Game.visible = true
	$Panel/Del.visible = true

func on_Settings_pressed():
	pass

func on_Exit_pressed():
	LevelManager.toCredits()

# Game
func on_0_pressed():
	if (main_data["0"]["name"] == null):
		GameManager.new_game(0)
	else:
		GameManager.load_game(0)
	load_game()

func on_1_pressed():
	if (main_data["1"]["name"] == null):
		GameManager.new_game(1)
	else:
		GameManager.load_game(1)
	load_game()

func on_2_pressed():
	if (main_data["2"]["name"] == null):
		GameManager.new_game(2)
	else:
		GameManager.load_game(2)
	load_game()

func load_game():
	if (GameManager.save_data["mazm"]["D"]):
		LevelManager.toVortex()
	elif (GameManager.save_data["tuto"]):
		LevelManager.toGame()
	else:
		LevelManager.next()

func on_GBack_pressed():
	$Panel/Game.visible = false
	$Panel/Del.visible = false
	$Panel/Main0.visible = true

func on_0_del():
	GameManager.delete_save(0)
	on_Game_pressed()

func on_1_del():
	GameManager.delete_save(1)
	on_Game_pressed()

func on_2_del():
	GameManager.delete_save(2)
	on_Game_pressed()

