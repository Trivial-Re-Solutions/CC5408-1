extends Node2D

var first_time = true
var can_exit = false
var dialog

func _ready():
	$Area2D.connect("body_entered", self, "on_body_entered")
	$Salida.connect("body_entered", self, "on_exit")
	var mazm = GameManager.save_data["mazm"]
	$Characters/MainCharacter.clone_active = false
	start_dialog(mazm)

func start_dialog(mazm):
	if (not mazm["A"]):
		dialog = "res://Dialogs/2/2-0.json"
	else:
		$Characters/Time/AnimationPlayer.play("fade_in")
		first_time = false
		if (not mazm["B"]):
			dialog = "res://Dialogs/5/5-0.json"
		elif (not mazm["C"]):
			dialog = "res://Dialogs/8/8-0.json"
		elif (not mazm["D"]):
			dialog = "res://Dialogs/11/11-0.json"
	$Dialogs.load_file(dialog, self)
	$Dialogs.start_dialog()

func end_dialog():
	$Dialogs.queue_free()
	can_exit = true

func is_stop():
	if (not first_time):
		yield(get_tree().create_timer(1.0), "timeout")
		$Dialogs.resume()

func on_body_entered(body:Node):
	if (body.is_in_group("Player") and first_time):
		$Characters/Time/AnimationPlayer.play("fade_in")
		first_time = false
		$Dialogs.resume()

func on_exit(body:Node):
	if (body.is_in_group("Player") and can_exit):
		LevelManager.next()
