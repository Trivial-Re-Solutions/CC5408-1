extends Node2D

var parent
var dict

func _ready():
	$CanvasLayer/Key/AnimationPlayer.play("Press")

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

func set_autoscroll():
	$CanvasLayer/Key.visible = false
	$CanvasLayer/Node.auto_scroll = true

func start_dialog():
	$CanvasLayer/Node.set_parameters(dict, self)

func end_dialog():
	parent.end_dialog()

func is_stop():
	$CanvasLayer/Key.visible = false
	parent.is_stop()

func resume():
	$CanvasLayer/Key.visible = true
	$CanvasLayer/Node.resume()
