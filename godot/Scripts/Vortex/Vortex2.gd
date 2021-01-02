extends Node2D

var ready_dial = {"scene":"Name","chars":0,"names":{},"dials":1,"texts":{"0":{"P":-1,"D":"Viajero... Ha aparecido la gema de esta mazmorra"}}}
var boss = preload("res://Scenes/Entity/Enemies/Bosses/Boss2.tscn")

var asesino_state = 0
var max_state = 0
var main_state = 0

func _ready():
	$Mama/Area2D.connect("body_entered", self, "question1")
	$Nino/Area2D.connect("body_entered", self, "question2")
	$Boss.connect("body_entered", self, "final_boss")
	
	hide_dialog()
	hide_choice()

func question1(body:Node):
	if ((not body.is_in_group("Player")) or max_state != 0):
		return
	max_state = 1
	$MainCharacter.done_move = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/7/7-0.json", self)
	$Dialog.start_dialog()

func question2(body:Node):
	if ((not body.is_in_group("Player")) or asesino_state != 0):
		return
	asesino_state = 1
	$MainCharacter.done_move = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/7/7-2.json", self)
	$Dialog.start_dialog()

func final_boss(body:Node):
	if (main_state != 1):
		return
	$Boss2.add_child(boss.instance())

func win():
	yield(get_tree().create_timer(3.0), "timeout")
	final1()

func final1():
	if (main_state != 1):
		return
	main_state = 2
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/7/7-4.json", self)
	$Dialog.start_dialog()

func choice1():
	$Choice.show()
	$Choice.load_file("res://Dialogs/7/7-C-1.json", self)
	$Choice.start_dialog()

func choice2():
	$Choice.show()
	$Choice.load_file("res://Dialogs/7/7-C-2.json", self)
	$Choice.start_dialog()

func choice3():
	$Choice.show()
	$Choice.load_file("res://Dialogs/7/7-C-3.json", self)
	$Choice.start_dialog()

func choice4():
	$Choice.show()
	$Choice.load_file("res://Dialogs/7/7-C-4.json", self)
	$Choice.start_dialog()

func answer1():
	max_state = 2
	$Dialog.show()
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	if (GameManager.save_data["elec"]["PB2MAX"] == 1):
		$Dialog.load_file("res://Dialogs/7/7-1-1.json", self)
	elif (GameManager.save_data["elec"]["PB2MAX"] == 2):
		$Dialog.load_file("res://Dialogs/7/7-1-2.json", self)
	$Dialog.start_dialog()

func answer2():
	asesino_state = 2
	$Dialog.show()
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	if (GameManager.save_data["elec"]["PB2ASESINO"] == 1):
		$Dialog.load_file("res://Dialogs/7/7-3-1.json", self)
	elif (GameManager.save_data["elec"]["PB2ASESINO"] == 2):
		$Dialog.load_file("res://Dialogs/7/7-3-2.json", self)
	elif (GameManager.save_data["elec"]["PB2ASESINO"] == 3):
		$Dialog.load_file("res://Dialogs/7/7-3-3.json", self)
	$Dialog.start_dialog()

func answer3():
	main_state = 3
	$Dialog.show()
	$MainCharacter.done_move = true
	if (GameManager.save_data["elec"]["B2MAX"] == 1):
		$Dialog.load_file("res://Dialogs/7/7-5-1.json", self)
	elif (GameManager.save_data["elec"]["B2MAX"] == 2):
		$Dialog.load_file("res://Dialogs/7/7-5-2.json", self)
	$Dialog.start_dialog()

func answer4():
	main_state = 4
	$Dialog.show()
	$MainCharacter.done_move = true
	if (GameManager.save_data["elec"]["PB2MAX"] == 1):
		if (GameManager.save_data["elec"]["B2ASESINO"] == 1):
			$Dialog.load_file("res://Dialogs/7/7-6-1.json", self)
		elif (GameManager.save_data["elec"]["B2ASESINO"] == 2):
			$Dialog.load_file("res://Dialogs/7/7-6-2.json", self)
	elif (GameManager.save_data["elec"]["PB2MAX"] == 2):
		if (GameManager.save_data["elec"]["B2ASESINO"] == 1):
			$Dialog.load_file("res://Dialogs/7/7-6-3.json", self)
		elif (GameManager.save_data["elec"]["B2ASESINO"] == 2):
			$Dialog.load_file("res://Dialogs/7/7-6-4.json", self)
	$Dialog.start_dialog()

func answer5():
	main_state = 5
	$Dialog.show()
	$MainCharacter.done_move = true
	$Dialog.load_file("res://Dialogs/7/7-7.json", self)
	$Dialog.start_dialog()

func hide_dialog():
	$Dialog.hide()
	
func hide_choice():
	$Choice.hide()

func end_dialog():
	$MainCharacter.done_move = false
	hide_dialog()
	if (max_state == 1):
		choice1()
	elif (asesino_state == 1):
		choice2()
	elif (max_state == 2):
		yield(get_tree().create_timer(1.0), "timeout")
		$CanvasLayer/ColorRect.visible = false
		max_state = 3
	elif (asesino_state == 2):
		yield(get_tree().create_timer(1.0), "timeout")
		$CanvasLayer/ColorRect.visible = false
		asesino_state = 3
	if (max_state == 3 and asesino_state == 3 and main_state == 0):
		main_state = 1
		$Dialog.show()
		$Dialog.dict = ready_dial
		$Dialog.start_dialog()
	elif (main_state == 2):
		choice3()
	elif (main_state == 3):
		choice4()
	elif (main_state == 4):
		answer5()
	elif (main_state == 5):
		GameManager.save_data["mazm"]["B"] = true
		GameManager.quick_save_game()
		LevelManager.toGame()

func end_choise():
	hide_choice()
	if (max_state == 1):
		answer1()
	elif (asesino_state == 1):
		answer2()
	elif (main_state == 2):
		answer3()
	elif (main_state == 3):
		answer4()
