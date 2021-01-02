extends Node2D

var state = 0

func _ready():
	$Dialogs.load_file("res://Dialogs/15/15-0-0.json", self)
	$Dialogs.start_dialog()

func end_dialog():
	if state == 0:
		$Dialogs.load_file("res://Dialogs/15/15-0-2.json", self)
		$Dialogs.start_dialog()
		state = 1
	elif state == 1:
		$Dialogs.load_file("res://Dialogs/15/15-0-3.json", self)
		$Dialogs.start_dialog()
		state = 2
	elif state == 2:
		$Dialogs.load_file("res://Dialogs/15/15-0-4.json", self)
		$Dialogs.start_dialog()
		state = 3
	else:
		LevelManager.toCredits()
