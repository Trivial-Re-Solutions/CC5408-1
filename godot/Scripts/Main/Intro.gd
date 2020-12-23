extends Node2D

var animation = true

var name_dial = {"scene":"Name","chars":0,"names":{},"dials":1,"texts":{"0":{"P":-1,"D":"Viajero... ¿Cual es tu nombre?"}}}
var dict

func _ready():
	$CanvasLayer/ColorRect/Button.connect("pressed", self, "_on_button")
	if (GameManager.save_data["tuto"]):
		LevelManager.next()
	elif (GameManager.save_data["name"] != null):
		start_intro()
	else:
		$CanvasLayer/Node.set_parameters(name_dial, self)

func _on_button():
	var text = $CanvasLayer/ColorRect/TextEdit.get_line(0).substr(0,20)
	GameManager.new_save(GameManager.save_data["slot"], text)
	
	start_intro()

func start_intro():
	$CanvasLayer/ColorRect.visible = false
	load_file("res://Dialogs/Intro_0.dials")
	$CanvasLayer/Node.set_parameters(dict, self)
	animation = false

func load_file(path:String):
	var file = File.new()
	file.open(path, File.READ)
	dict = parse_json(file.get_as_text())
	file.close()

func end_dialog():
	if !animation:
		LevelManager.next()
