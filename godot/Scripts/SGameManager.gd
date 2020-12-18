extends Node

var main_data
var save_data

func _ready():
	var main_save = File.new()
	if main_save.file_exists("user://main_save.bin"):
		main_save.open_encrypted_with_pass("user://main_save.bin", File.READ, "c629695bba3cbb3a0fb0eab3a7746c72836fecb938073f483627bb144ebbfeb6")
		main_data = parse_json(main_save.get_as_text())
		main_save.close()
	else:
		main_save.open_encrypted_with_pass("user://savedata.bin", File.WRITE, "c629695bba3cbb3a0fb0eab3a7746c72836fecb938073f483627bb144ebbfeb6")
		main_data = get_default_main_save()
		main_save.store_string(to_json(main_data))
		main_save.close()
	for i in range(3):
		if (main_data[i]["hash"] == null):
			main_data[i]["name"] = null

func get_preview():
	return main_data
	
func get_save():
	return save_data

func new_game(num:int):
	save_data = get_default_game_save(num)

func new_save(num:int, name:String):
	main_data[num]["name"] = name
	save_data["name"] = name
	save_game(save_data)

func load_game(num:int):
	var save_dict = main_data[num]
	var save = File.new()
	#save.open_encrypted_with_pass("user://save_slot_"+String(num)+"/main_save.bin", File.READ, main_data["pass"])
	save.open("user://save_slot_"+String(num)+"/main_save.bin", File.READ)
	var save_text = save.get_as_text()
	save_data = parse_json(save_text)
	save.close()
	
	if (typeof(save_data) != TYPE_DICTIONARY or save_text.sha256_text() != save_dict["hash"]):
		return {"integrity": false}
	else:
		return save_data

func save_game(data):
	var num = save_data["slot"]
	var save = File.new()
	#save.open_encrypted_with_pass("user://save_slot_"+String(num)+"/main_save.bin", File.WRITE, main_data["pass"])
	save.open("user://save_slot_"+String(num)+"/main_save.bin", File.WRITE)
	var save_text = to_json(data)
	save.store_string(save_text)
	save.close()
	
	var main_save = File.new()
	main_save.open_encrypted_with_pass("user://savedata.bin", File.WRITE, "c629695bba3cbb3a0fb0eab3a7746c72836fecb938073f483627bb144ebbfeb6")
	main_data[num]["hash"] = save_text.sha256_text()
	main_data[num]["last"] = OS.get_datetime()
	main_save.store_string(to_json(main_data))
	main_save.close()
	

func get_default_main_save():
	randomize()
	var save_dict = {
		"pass": String(randi()).sha256_text(),
		0: {"name": null, "last": null, "hash": null},
		1: {"name": null, "last": null, "hash": null},
		2: {"name": null, "last": null, "hash": null}
	}
	return save_dict

func get_default_game_save(num:int):
	var save_dict = {
		"slot": num,
		"name": null,
		"tuto": false,
		"mazm": {"A": false, "B": false, "C": false, "D": false},
		"levl": {"A": 1, "B": 1, "C": 1, "D": 1, "E": 0, "F":0, "G":0, "H":0},
		"elec": {"A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F":0, "G":0, "H":0, "I":0, "J":0, "K":0, "L":0},
		"item": {"A": false, "B": false, "C": false, "D": false, "E": false, "F":false, "G":false, "H":false},
		"integrity": true
	}
	return save_dict
