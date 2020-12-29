extends Node2D

var skull = preload("res://Scenes/Entity/Enemies/Skull/Skull.tscn")

var stop_bool = false
var stop_state = 0

func _ready():
	$Area0.connect("body_entered", self, "event1")
	$Area1.connect("body_entered", self, "event2")
	$Area2.connect("body_entered", self, "start_record")
	$Area3.connect("body_entered", self, "event3")
	$Area4.connect("body_entered", self, "event4")
	
	$Soldier/AnimationPlayer.play("Idle")
	$MainCharacter.clone_active = false
	$MainCharacter.is_attacking = true
	$MainCharacter.done_move = true
	$Choice.hide()
	$Dialogs.load_file("res://Dialogs/1/1-0.json", self)
	$Dialogs.start_dialog()
	
	$Enemies/Skull.set_max_health(1000)
	$Enemies/Skull1.set_max_health(900)
	$Enemies/Skull2.set_max_health(800)
	$Enemies/Skull3.set_max_health(700)
	$Enemies/Skull4.set_max_health(600)
	$Enemies/Skull5.set_max_health(500)

func event1(body:Node):
	if ((not body.is_in_group("Player")) or stop_state != 1):
		return
	stop_state = 2
	$Dialogs.show()
	$MainCharacter.done_move = true
	$Dialogs.load_file("res://Dialogs/1/1-1.json", self)
	$Dialogs.start_dialog()

func event2(body:Node):
	if ((not body.is_in_group("Player")) or stop_state != 3):
		return
	stop_state = 4
	$Enemies/Skull.keep_position = true
	$Enemies/Skull1.keep_position = true
	$Enemies/Skull2.keep_position = true
	$Enemies/Skull3.keep_position = true
	$Enemies/Skull4.keep_position = true
	$Enemies/Skull5.keep_position = true
	$Dialogs.show()
	$MainCharacter.done_move = true
	$Dialogs.load_file("res://Dialogs/1/1-2.json", self)
	$Dialogs.start_dialog()

func event3(body:Node):
	if ((not body.is_in_group("Player")) or stop_state != 8):
		return
	stop_state = 9
	$Dialogs.show()
	$MainCharacter.done_move = true
	$Dialogs.load_file("res://Dialogs/1/1-4.json", self)
	$Dialogs.start_dialog()

func event4(body:Node):
	if ((not body.is_in_group("Player")) or stop_state != 10):
		return
	stop_state = 11
	$Dialogs.show()
	$MainCharacter.done_move = true
	$Dialogs.load_file("res://Dialogs/1/1-5.json", self)
	$Dialogs.start_dialog()

func start_record(body:Node):
	if ((not body.is_in_group("Player")) or stop_state != 7):
		return
	$MainCharacter.record()
	stop_state = 8

func choice1():
	$Choice.show()
	$Choice.load_file("res://Dialogs/1/1-C-1.json", self)
	$Choice.start_dialog()

func answer1():
	if (GameManager.save_data["elec"]["F1INICIO"] == 1):
		$Dialogs.show()
		$Dialogs.load_file("res://Dialogs/1/1-3.json", self)
		stop_state = 6
	if (GameManager.save_data["elec"]["F1INICIO"] == 2):
		$Dialogs.show()
		$Dialogs.load_file("res://Dialogs/1/1-3-F.json", self)
		stop_state = -1
	$Dialogs.start_dialog()

func cinematic1():
	yield(get_tree().create_timer(1.0), "timeout")
	$Dialogs.show()
	$Dialogs.load_file("res://Dialogs/1/1-6.json", self)
	$Dialogs.start_dialog()
	$CanvasLayer/ColorRect.visible = true
	stop_state = 14

func cinematic2():
	$CanvasLayer/ColorRect.visible = false
	yield(get_tree().create_timer(0.1), "timeout")
	$Dialogs.show()
	$Dialogs.load_file("res://Dialogs/1/1-7.json", self)
	$Dialogs.start_dialog()
	stop_state = 15

func end_dialog():
	if (stop_state == -1):
		LevelManager.reset()
	elif (stop_state == 5):
		choice1()
	elif (stop_state == 10):
		$MainCharacter.clone_active = true
		$MainCharacter.done_move = false
	elif (stop_state == 13):
		cinematic1()
	elif (stop_state == 14):
		cinematic2()
	elif (stop_state == 15):
		GameManager.save_data["tuto"] = true
		GameManager.quick_save_game()
		LevelManager.next()
	else:
		$MainCharacter.done_move = false
	$Dialogs.hide()

func is_stop():
	if (stop_state == -1):
		$CanvasLayer/ColorRect.visible = true
		$Dialogs.resume()
	stop_bool = true

func _input(event):
	if Input.is_action_pressed("action_accept"):
		if (stop_state == 11 and stop_bool):
			stop_bool = false
			stop_state = 12
			$CloneWall/Sprite7.visible = true
			$CloneWall/Sprite7/AnimationPlayer.play("Idle")
			$Dialogs.resume()
	elif Input.is_action_pressed("action_move"):
		if (stop_state == 0 and stop_bool):
			$MainCharacter.done_move = false
			stop_bool = false
			stop_state = 1
			$Dialogs.hide()
	elif Input.is_action_pressed("action_attack"):
		if (stop_state == 2 and stop_bool):
			$MainCharacter.attack()
			stop_bool = false
			stop_state = 3
			yield(get_tree().create_timer(0.2), "timeout")
			$Soldier.queue_free()
			$Dialogs.resume()
		elif (stop_state == 12 and stop_bool):
			$MainCharacter.attack()
			stop_bool = false
			stop_state = 13
			yield(get_tree().create_timer(0.2), "timeout")
			$CloneWall/Sprite7.queue_free()
			$Dialogs.resume()
	elif Input.is_action_pressed("action_record"):
		if (stop_state == 4 and stop_bool):
			$CloneWall/StaticBody2D/CollisionShape2D.disabled = false
			$CloneWall.visible = true
			stop_bool = false
			stop_state = 5
			$Enemies/Skull.keep_position = false
			$Enemies/Skull1.keep_position = false
			$Enemies/Skull2.keep_position = false
			$Enemies/Skull3.keep_position = false
			$Enemies/Skull4.keep_position = false
			$Enemies/Skull5.keep_position = false
			$Dialogs.resume()
		elif (stop_state == 6 and stop_bool):
			$CloneWall/Sprite6.visible = true
			stop_bool = false
			stop_state = 7
			$Dialogs.resume()
		elif (stop_state == 9 and stop_bool):
			$MainCharacter.record()
			stop_bool = false
			stop_state = 10
			yield(get_tree().create_timer(5.0), "timeout")
			$Dialogs.resume()

func end_choise():
	$Choice.hide()
	answer1()
