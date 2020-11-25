extends CanvasLayer

# ------------------------------------------------------------------------------
# Inicialización

func _ready():
	$AnimationPlayer.play("run")
	
	$Panel/Main0/Game.connect("pressed", self, "on_Game_pressed")
	$Panel/Main0/Settings.connect("pressed", self, "on_Settings_pressed")
	$Panel/Main0/Exit.connect("pressed", self, "on_Exit_pressed")
	
	$Panel/Game/New.connect("pressed", self, "on_New_pressed")
	$Panel/Game/Load.connect("pressed", self, "on_Load_pressed")
	$Panel/Game/Back.connect("pressed", self, "on_GBack_pressed")
	
	$Panel/Load/Last.connect("pressed", self, "on_Last_pressed")
	$Panel/Load/List.connect("pressed", self, "on_List_pressed")
	$Panel/Load/Back.connect("pressed", self, "on_LBack_pressed")
	
	$Panel/Settings/Video.connect("pressed", self, "on_Video_pressed")
	$Panel/Settings/Controls.connect("pressed", self, "on_Controls_pressed")
	$Panel/Settings/Back.connect("pressed", self, "on_SBack_pressed")

# ------------------------------------------------------------------------------
# Control de escena

# Main0
func on_Game_pressed():
	$Panel/Main0.visible = false
	$Panel/Game.visible = true

func on_Settings_pressed():
	$Panel/Main0.visible = false
	$Panel/Settings.visible = true

func on_Exit_pressed():
	get_tree().quit()

# Game
func on_New_pressed():
	LevelManager.next()

func on_Load_pressed():
	$Panel/Game.visible = false
	$Panel/Load.visible = true

func on_GBack_pressed():
	$Panel/Game.visible = false
	$Panel/Main0.visible = true

# Load
func on_Last_pressed():
	pass

func on_List_pressed():
	pass

func on_LBack_pressed():
	$Panel/Load.visible = false
	$Panel/Game.visible = true

# Settings
func on_Video_pressed():
	pass

func on_Controls_pressed():
	pass

func on_SBack_pressed():
	$Panel/Settings.visible = false
	$Panel/Main0.visible = true
