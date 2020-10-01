extends CanvasLayer

var DemoMain = preload("res://scenes/DemoMain.tscn")

func _ready():
	$Panel/VBoxContainer/Procedural.connect("pressed", self, "on_Procedural_pressed")
	$Panel/VBoxContainer/Exit.connect("pressed", self, "on_Exit_pressed")

func on_Procedural_pressed():
	get_tree().change_scene_to(DemoMain)

func on_Exit_pressed():
	get_tree().quit()
