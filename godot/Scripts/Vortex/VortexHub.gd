extends Node2D

var vortex1 = preload("res://Scenes/Vortex/Vortex1.tscn")
var vortex2 = preload("res://Scenes/Vortex/Vortex2.tscn")
var vortex3 = preload("res://Scenes/Vortex/Vortex3.tscn")
var vortex4 = preload("res://Scenes/Vortex/Vortex4.tscn")

var act_map

func _ready():
	var mazm = GameManager.save_data["mazm"]
	if (not mazm["A"]):
		act_map = vortex1.instance()
	elif (not mazm["B"]):
		act_map = vortex2.instance()
	elif (not mazm["C"]):
		act_map = vortex3.instance()
	elif (not mazm["D"]):
		act_map = vortex4.instance()
	$Vortex.add_child(act_map)
	

