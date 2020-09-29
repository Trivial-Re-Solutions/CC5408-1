extends CanvasLayer

func _ready():
	$Panel/VBoxContainer/Demo.connect("pressed", self, "on_Demo_pressed")
	$Panel/VBoxContainer/Exit.connect("pressed", self, "on_Exit_pressed")

func on_Demo_pressed():
	get_tree().change_scene("res://Scenes/DemoMain.tscn")

func on_Exit_pressed():
	get_tree().quit()
