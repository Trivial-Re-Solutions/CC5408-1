extends CanvasLayer

var animation = 0
var enemies = false

var name_dial = {"scene":"Name","chars":0,"names":{},"dials":1,"texts":{"0":{"P":-1,"D":"Viajero... ¿Cual es tu nombre?"}}}
var dict

onready var fade = $CanvasLayer/SimpleFade

func _ready():
	$Prelude1.main_color = Color(0.0, 0.0, 0.0, 0.3)
	$Main/AnimationPlayer.play("run")
	$CanvasLayer/Dialogs.hide()
	$CanvasLayer/ColorRect/Button.connect("pressed", self, "_on_button")
	if (GameManager.save_data["name"] != null):
		start_intro()
	else:
		$CanvasLayer/Node.set_parameters(name_dial, self)

func _process(delta):
	if (enemies):
		$Enemy.position += Vector2(1.0, 0.0)

func _on_button():
	var text = $CanvasLayer/ColorRect/TextEdit.get_line(0).substr(0,20)
	GameManager.new_save(GameManager.save_data["slot"], text)
	start_intro()

func start_intro():
	$CanvasLayer/ColorRect.visible = false
	load_file("res://Dialogs/0/0-0.json")
	$CanvasLayer/Node.set_parameters(dict, self)
	$CanvasLayer/Node.auto_scroll = true
	animation = 1

func on_finish():
	$CanvasLayer/ColorRect2.visible = true
	$CanvasLayer/SimpleFade.visible = false
	$Main/Sprite.visible = false
	$CanvasLayer/Dialogs.show()
	$CanvasLayer/Node.queue_free()
	$CanvasLayer/Dialogs.load_file("res://Dialogs/0/0-1.json", self)
	$CanvasLayer/Dialogs.start_dialog()
	animation = 2

func load_file(path:String):
	var file = File.new()
	file.open(path, File.READ)
	dict = parse_json(file.get_as_text())
	file.close()

func resume():
	pass

func end_dialog():
	if (animation == 1):
		$CanvasLayer/SimpleFade.fade_in()
		yield(get_tree().create_timer(1.0), "timeout")
		on_finish()
	elif (animation == 2):
		$CanvasLayer/SimpleFade.visible = true
		$Main/Sprite.visible = true
		$CanvasLayer/ColorRect2.visible = false
		$CanvasLayer/Dialogs.hide()
		$Prelude1.main_color = Color(0.0, 0.0, 0.0, 0.0)
		enemies = true
		$CanvasLayer/SimpleFade.fade_out()
		$Enemy/AnimationPlayer.play("Run")
		yield(get_tree().create_timer(0.4), "timeout")
		$Enemy/AnimationPlayer2.play("Run")
		yield(get_tree().create_timer(0.4), "timeout")
		$Enemy/AnimationPlayer3.play("Run")
		yield(get_tree().create_timer(0.4), "timeout")
		$Enemy/AnimationPlayer4.play("Run")
		yield(get_tree().create_timer(0.4), "timeout")
		$Enemy/AnimationPlayer5.play("Run")
		yield(get_tree().create_timer(8.0), "timeout")
		$CanvasLayer/ColorRect2.color = Color(1.0, 1.0, 1.0, 1.0)
		$CanvasLayer/ColorRect2.visible = true
		yield(get_tree().create_timer(1.0), "timeout")
		LevelManager.next()
