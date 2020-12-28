extends Node2D

var ready_dial = {"scene":"Name","chars":0,"names":{},"dials":1,"texts":{"0":{"P":-1,"D":"Viajero... Ha aparecido la gema de esta mazmorra"}}}

var general_state = 0
var mary_state = 0
var main_state = 0

func _ready():
	$Mama/Area2D.connect("body_entered", self, "question1")
	$Nino/Area2D.connect("body_entered", self, "question2")
	$Boss.connect("body_entered", self, "final1")
	
	hide_dialog()
	hide_choice()

func question1(body:Node):
	if ((not body.is_in_group("Player")) or mary_state != 0):
		return
	mary_state = 1
	$MainCharacter.done_move = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/10/10-0.json", self)
	$Dialog.start_dialog()

func question2(body:Node):
	if ((not body.is_in_group("Player")) or general_state != 0):
		return
	general_state = 1
	$MainCharacter.done_move = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/10/10-2.json", self)
	$Dialog.start_dialog()

func final1(body:Node):
	if (main_state != 1):
		return
	main_state = 2
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/10/10-4.json", self)
	$Dialog.start_dialog()

func final2():
	main_state = 4
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/10/10-6.json", self)
	$Dialog.start_dialog()

func choice1():
	$Choice.show()
	$Choice.load_file("res://Dialogs/10/10-C-1.json", self)
	$Choice.start_dialog()

func choice2():
	$Choice.show()
	$Choice.load_file("res://Dialogs/10/10-C-2.json", self)
	$Choice.start_dialog()

func choice3():
	$Choice.show()
	$Choice.load_file("res://Dialogs/10/10-C-3.json", self)
	$Choice.start_dialog()

func choice4():
	$Choice.show()
	$Choice.load_file("res://Dialogs/10/10-C-4.json", self)
	$Choice.start_dialog()

func answer1():
	mary_state = 2
	$Dialog.show()
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	if (GameManager.save_data["elec"]["PB3MARY"] == 1):
		$Dialog.load_file("res://Dialogs/10/10-1-1.json", self)
	elif (GameManager.save_data["elec"]["PB3MARY"] == 2):
		$Dialog.load_file("res://Dialogs/10/10-1-2.json", self)
	elif (GameManager.save_data["elec"]["PB3MARY"] == 3):
		$Dialog.load_file("res://Dialogs/10/10-1-3.json", self)
	$Dialog.start_dialog()

func answer2():
	general_state = 2
	$Dialog.show()
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	if (GameManager.save_data["elec"]["PB3GENERAL"] == 1):
		$Dialog.load_file("res://Dialogs/10/10-3-1.json", self)
	elif (GameManager.save_data["elec"]["PB3GENERAL"] == 2):
		$Dialog.load_file("res://Dialogs/10/10-3-2.json", self)
	$Dialog.start_dialog()

func answer3():
	main_state = 3
	$Dialog.show()
	$MainCharacter.done_move = true
	if (GameManager.save_data["elec"]["B3MARY"] == 1):
		$Dialog.load_file("res://Dialogs/10/10-5-1.json", self)
	elif (GameManager.save_data["elec"]["B3MARY"] == 2):
		$Dialog.load_file("res://Dialogs/10/10-5-2.json", self)
	elif (GameManager.save_data["elec"]["B3MARY"] == 3):
		$Dialog.load_file("res://Dialogs/10/10-5-3.json", self)
	$Dialog.start_dialog()

func answer4():
	main_state = 5
	$Dialog.show()
	$MainCharacter.done_move = true
	if (GameManager.save_data["elec"]["B3GENERAL"] == 1):
		$Dialog.load_file("res://Dialogs/10/10-7-1.json", self)
	elif (GameManager.save_data["elec"]["B3GENERAL"] == 2):
		$Dialog.load_file("res://Dialogs/10/10-7-2.json", self)
	$Dialog.start_dialog()

func answer5():
	main_state = 6
	$Dialog.show()
	$MainCharacter.done_move = true
	$Dialog.load_file("res://Dialogs/10/10-8.json", self)
	$Dialog.start_dialog()

func hide_dialog():
	$Dialog.hide()
	
func hide_choice():
	$Choice.hide()

func end_dialog():
	$MainCharacter.done_move = false
	hide_dialog()
	if (mary_state == 1):
		choice1()
	elif (general_state == 1):
		choice2()
	elif (mary_state == 2):
		yield(get_tree().create_timer(1.0), "timeout")
		$CanvasLayer/ColorRect.visible = false
		mary_state = 3
	elif (general_state == 2):
		yield(get_tree().create_timer(1.0), "timeout")
		$CanvasLayer/ColorRect.visible = false
		general_state = 3
	if (mary_state == 3 and general_state == 3 and main_state == 0):
		main_state = 1
		$Dialog.show()
		$Dialog.dict = ready_dial
		$Dialog.start_dialog()
	elif (main_state == 2):
		choice3()
	elif (main_state == 3):
		final2()
	elif (main_state == 4):
		choice4()
	elif (main_state == 5):
		answer5()
	elif (main_state == 6):
		GameManager.save_data["mazm"]["C"] = true
		GameManager.quick_save_game()
		LevelManager.toGame()

func end_choise():
	hide_choice()
	if (mary_state == 1):
		answer1()
	elif (general_state == 1):
		answer2()
	elif (main_state == 2):
		answer3()
	elif (main_state == 4):
		answer4()
