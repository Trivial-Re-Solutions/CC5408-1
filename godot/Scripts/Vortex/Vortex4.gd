extends Node2D

var ready_dial = {"scene":"Name","chars":0,"names":{},"dials":1,"texts":{"0":{"P":-1,"D":"Viajero... Ha aparecido la gema de esta mazmorra"}}}

var nino_state = 0
var mama_state = 0
var main_state = 0

func _ready():
	$Node2D/Piso1.connect("body_entered", self, "tp1")
	$Node2D/Piso2.connect("body_entered", self, "tp2")
	$Node2D/Piso3.connect("body_entered", self, "tp3")
	$Node2D/Piso4.connect("body_entered", self, "tp4")
	
	$Mama/Area2D.connect("body_entered", self, "question1")
	$Nino/Area2D.connect("body_entered", self, "question2")
	$Boss.connect("body_entered", self, "final1")
	
	hide_dialog()
	hide_choice()

func tp1(body:Node):
	if (not body.is_in_group("Player")):
		return
	$MainCharacter.position = Vector2(-530, -1500)

func tp2(body:Node):
	if (not body.is_in_group("Player")):
		return
	$MainCharacter.position = Vector2(1000, -1300)

func tp3(body:Node):
	if (not body.is_in_group("Player")):
		return
	$MainCharacter.position = Vector2(2000, -1500)

func tp4(body:Node):
	if (not body.is_in_group("Player")):
		return
	$MainCharacter.position = Vector2(3200, -900)

func question1(body:Node):
	if ((not body.is_in_group("Player")) or mama_state != 0):
		return
	mama_state = 1
	$MainCharacter.done_move = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/13/13-0.json", self)
	$Dialog.start_dialog()

func question2(body:Node):
	if ((not body.is_in_group("Player")) or nino_state != 0):
		return
	nino_state = 1
	$MainCharacter.done_move = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/13/13-2.json", self)
	$Dialog.start_dialog()

func final1(body:Node):
	if (main_state != 1):
		return
	main_state = 2
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	$Dialog.show()
	$Dialog.load_file("res://Dialogs/13/13-6.json", self)
	$Dialog.start_dialog()

func choice1():
	$Choice.show()
	$Choice.load_file("res://Dialogs/13/13-C-1.json", self)
	$Choice.start_dialog()

func choice2():
	$Choice.show()
	$Choice.load_file("res://Dialogs/13/13-C-2.json", self)
	$Choice.start_dialog()

func choice3():
	$Choice.show()
	$Choice.load_file("res://Dialogs/13/13-C-4.json", self)
	$Choice.start_dialog()

func choice4():
	$Choice.show()
	$Choice.load_file("res://Dialogs/13/13-C-5.json", self)
	$Choice.start_dialog()

func choiceF():
	$Choice.show()
	$Choice.load_file("res://Dialogs/13/13-C-3.json", self)
	$Choice.start_dialog()

func answer1():
	mama_state = 2
	$Dialog.show()
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	if (GameManager.save_data["elec"]["PB4GIORNO"] == 1):
		$Dialog.load_file("res://Dialogs/13/13-1-1.json", self)
	elif (GameManager.save_data["elec"]["PB4GIORNO"] == 2):
		$Dialog.load_file("res://Dialogs/13/13-1-2.json", self)
	elif (GameManager.save_data["elec"]["PB4GIORNO"] == 3):
		$Dialog.load_file("res://Dialogs/13/13-1-3.json", self)
	$Dialog.start_dialog()

func answer2():
	nino_state = 2
	$Dialog.show()
	$MainCharacter.done_move = true
	$CanvasLayer/ColorRect.visible = true
	if (GameManager.save_data["elec"]["PB4GENERAL"] == 1):
		$Dialog.load_file("res://Dialogs/13/13-3-1.json", self)
	elif (GameManager.save_data["elec"]["PB4GENERAL"] == 2):
		$Dialog.load_file("res://Dialogs/13/13-3-2.json", self)
	elif (GameManager.save_data["elec"]["PB4GENERAL"] == 3):
		$Dialog.load_file("res://Dialogs/13/13-3-3.json", self)
	$Dialog.start_dialog()

func answer3():
	main_state = 3
	$Dialog.show()
	$MainCharacter.done_move = true
	if (GameManager.save_data["elec"]["B4OSCURO"] == 1):
		$Dialog.load_file("res://Dialogs/13/13-7-1.json", self)
	elif (GameManager.save_data["elec"]["B4OSCURO"] == 2):
		$Dialog.load_file("res://Dialogs/13/13-7-2.json", self)
	$Dialog.start_dialog()

func answer4():
	main_state = 4
	$Dialog.show()
	$MainCharacter.done_move = true
	if (GameManager.save_data["elec"]["B4GENERAL"] == 1):
		$Dialog.load_file("res://Dialogs/13/13-8-1.json", self)
	elif (GameManager.save_data["elec"]["B4GENERAL"] == 2):
		$Dialog.load_file("res://Dialogs/13/13-8-2.json", self)
	elif (GameManager.save_data["elec"]["B4GENERAL"] == 2):
		$Dialog.load_file("res://Dialogs/13/13-8-2.json", self)
	$Dialog.start_dialog()

func answer5():
	main_state = 5
	$Dialog.show()
	$MainCharacter.done_move = true
	$Dialog.load_file("res://Dialogs/13/13-9.json", self)
	$Dialog.start_dialog()

func answerF():
	main_state = 3
	$Dialog.show()
	$MainCharacter.done_move = true
	if (GameManager.save_data["elec"]["PB4OSCURO"] == 1):
		$Dialog.load_file("res://Dialogs/13/13-7-1.json", self)
	elif (GameManager.save_data["elec"]["PB4OSCURO"] == 2):
		$Dialog.load_file("res://Dialogs/13/13-7-2.json", self)
	$Dialog.start_dialog()

func hide_dialog():
	$Dialog.hide()
	
func hide_choice():
	$Choice.hide()

func end_dialog():
	$MainCharacter.done_move = false
	hide_dialog()
	if (mama_state == 1):
		choice1()
	elif (nino_state == 1):
		choice2()
	elif (mama_state == 2):
		yield(get_tree().create_timer(1.0), "timeout")
		$CanvasLayer/ColorRect.visible = false
		mama_state = 3
	elif (nino_state == 2):
		yield(get_tree().create_timer(1.0), "timeout")
		$CanvasLayer/ColorRect.visible = false
		nino_state = 3
	if (mama_state == 3 and nino_state == 3 and main_state == 0):
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
		GameManager.save_data["mazm"]["D"] = true
		GameManager.quick_save_game()
		LevelManager.toGame()

func end_choise():
	hide_choice()
	if (mama_state == 1):
		answer1()
	elif (nino_state == 1):
		answer2()
	elif (main_state == 2):
		answer3()
	elif (main_state == 3):
		answer4()