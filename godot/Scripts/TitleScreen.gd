extends CanvasLayer

var DemoMain = preload("res://Scenes/DemoMain.tscn")

func _ready():
	$Panel/VBoxContainer/Demo.connect("pressed", self, "on_Demo_pressed")
	$Panel/VBoxContainer/Exit.connect("pressed", self, "on_Exit_pressed")

func on_Demo_pressed():
	get_tree().change_scene_to(DemoMain)

func on_Exit_pressed():
	get_tree().quit()
