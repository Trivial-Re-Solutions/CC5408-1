extends Node2D

var DemoMap = preload("res://Scenes/DemoMap.tscn")
var MainCharacter = preload("res://Scenes/MainCharacter.tscn")
var CloneCharacter = preload("res://Scenes/CloneCharacter.tscn")

var DemoMapNode = DemoMap.instance()
var MainCharacterNode = MainCharacter.instance()

var CloneStorage = []
var saving = false

func _ready():
	add_child(DemoMapNode)
	add_child(MainCharacterNode)

func _process(delta):
	var record = Input.is_action_just_released("action_record")
	
	if (not record):
		return
		
	if (saving):
		MainCharacterNode.stop_record()
		var CloneCharacterNode = CloneCharacter.instance()
		
		CloneCharacterNode.start_movement("Clone"+str(len(CloneStorage)))
		add_child(CloneCharacterNode)
		CloneStorage.append(CloneCharacterNode)
		saving = false
	
	elif (not saving):
		MainCharacterNode.start_record("Clone"+str(len(CloneStorage)))
		saving = true
