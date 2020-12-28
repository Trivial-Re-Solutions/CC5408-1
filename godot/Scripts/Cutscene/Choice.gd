extends Node2D

var parent
var dict
var save

func _ready():
	$CanvasLayer/ColorRect/Button.connect("pressed", self, "on_1_pressed")
	$CanvasLayer/ColorRect/Button2.connect("pressed", self, "on_2_pressed")
	$CanvasLayer/ColorRect/Button3.connect("pressed", self, "on_3_pressed")

func on_1_pressed():
	GameManager.save_data["elec"][save] = 1
	GameManager.quick_save_game()
	parent.end_choise()
func on_2_pressed():
	GameManager.save_data["elec"][save] = 2
	GameManager.quick_save_game()
	parent.end_choise()
func on_3_pressed():
	GameManager.save_data["elec"][save] = 3
	GameManager.quick_save_game()
	parent.end_choise()

func load_file(path:String, node):
	parent = node
	var file = File.new()
	file.open(path, File.READ)
	dict = parse_json(file.get_as_text())
	file.close()

func show():
	$CanvasLayer.scale = Vector2(1, 1)

func hide():
	$CanvasLayer.scale = Vector2(0, 0)

func start_dialog():
	save = dict["save"]
	$CanvasLayer/ColorRect/Button.text = dict["text"]["0"]
	$CanvasLayer/ColorRect/Button2.text = dict["text"]["1"]
	if (dict["opts"] == 3):
		$CanvasLayer/ColorRect/Button3.visible = true
		$CanvasLayer/ColorRect/Button3.text = dict["text"]["2"]
	else:
		$CanvasLayer/ColorRect/Button3.visible = false
	$CanvasLayer/Node.set_parameters(dict["main"], self)

func end_dialog():
	pass

func is_stop():
	pass

func resume():
	pass
