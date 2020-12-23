extends Node2D

var dict

func _ready():
	pass

func load_file(path:String):
	var file = File.new()
	file.open(path, File.READ)
	dict = parse_json(file.get_as_text())
	file.close()

func start_dialog():
	$CanvasLayer/Node.set_parameters(dict["main"], self)

func end_dialog():
	pass
