extends Node

var edit_save = true

var main_data
var save_data = {
		"slot": "-1",
		"name": "LtFabin",
		"tuto": true,
		"mazm": {"A": false, "B": false, "C": false, "D": false},
		"levl": {"A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F":0, "G":0, "H":0},
		"elec": {"F1INICIO": 0, "FDIM1":0, "FDIM2":0,
				"PB1MAMA": 0, "PB1NINO": 0, "B1MAMA": 0, "B1NINO":0,
				"PB2MAX":0, "PB2ASESINO":0, "B2MAX":0, "B2ASESINO":0,
				"PB3MARY":0, "PB3GENERAL":0, "B3MARY":0, "B3GENERAL":0,
				"PB4GIORNO":0, "PB4GENERAL":0, "PB4OSCURO":0, "B4OSCURO":0, "B4GENERAL":0 },
		"item": {"A": true, "B": false, "C": false, "D": false, "E": false },
		"integrity": true
	}

func _ready():
	var main_save = File.new()
	if main_save.file_exists("user://savedata.bin"):
		main_save.open_encrypted_with_pass("user://savedata.bin", File.READ, "c629695bba3cbb3a0fb0eab3a7746c72836fecb938073f483627bb144ebbfeb6")
		main_data = parse_json(main_save.get_as_text())
		main_save.close()
	else:
		main_save.open_encrypted_with_pass("user://savedata.bin", File.WRITE, "c629695bba3cbb3a0fb0eab3a7746c72836fecb938073f483627bb144ebbfeb6")
		main_data = get_default_main_save()
		main_save.store_string(to_json(main_data))
		main_save.close()
	for i in range(3):
		if (main_data[String(i)]["hash"] == null):
			main_data[String(i)]["name"] = null

func get_preview():
	return main_data
	
func get_save():
	return save_data

func new_game(num:int):
	save_data = get_default_game_save(num)

func new_save(num:String, name:String):
	main_data[num]["name"] = name
	save_data["name"] = name
	save_game(save_data)

func load_game(num:int):
	var save_dict = main_data[String(num)]
	var save = File.new()
	#save.open_encrypted_with_pass("user://save_slot_"+String(num)+"/main_save.bin", File.READ, main_data["pass"])
	save.open("user://savedata_"+String(num)+".bin", File.READ)
	var save_text = save.get_as_text()
	save_data = parse_json(save_text)
	save.close()
	
	if (typeof(save_data) != TYPE_DICTIONARY):
		pass
	elif(save_text.sha256_text() != save_dict["hash"] and not edit_save):
		save_data = get_default_game_save(num)
		main_data[String(num)]["name"] = "Tramposo"
		save_data["name"] = "Tramposo"
		save_game(save_data)

func save_game(data):
	if (save_data["slot"] == "-1"):
		return
	var num = save_data["slot"]
	var save = File.new()
	#save.open_encrypted_with_pass("user://save_slot_"+String(num)+"/main_save.bin", File.WRITE, main_data["pass"])
	save.open("user://savedata_"+String(num)+".bin", File.WRITE)
	var save_text = to_json(data)
	save.store_string(save_text)
	save.close()
	
	var main_save = File.new()
	main_save.open_encrypted_with_pass("user://savedata.bin", File.WRITE, "c629695bba3cbb3a0fb0eab3a7746c72836fecb938073f483627bb144ebbfeb6")
	main_data[String(num)]["hash"] = save_text.sha256_text()
	main_data[String(num)]["last"] = OS.get_datetime()
	main_save.store_string(to_json(main_data))
	main_save.close()

func quick_save_game():
	save_game(save_data)

func delete_save(num:int):
	main_data[String(num)] = {"name": null, "last": null, "hash": null}
	var main_save = File.new()
	main_save.open_encrypted_with_pass("user://savedata.bin", File.WRITE, "c629695bba3cbb3a0fb0eab3a7746c72836fecb938073f483627bb144ebbfeb6")
	main_save.store_string(to_json(main_data))
	main_save.close()
	
	var dir = Directory.new()
	dir.remove("user://savedata_"+String(num)+".bin")

func get_default_main_save():
	randomize()
	var save_dict = {
		"pass": String(randi()).sha256_text(),
		"0": {"name": null, "last": null, "hash": null},
		"1": {"name": null, "last": null, "hash": null},
		"2": {"name": null, "last": null, "hash": null}
	}
	return save_dict

func get_default_game_save(num:int):
	var save_dict = {
		"ver": "1.0",
		"slot": String(num),
		"name": null,
		"tuto": false,
		"mazm": {"A": false, "B": false, "C": false, "D": false},
		"levl": {"A": 0, "B": 0, "C": 0, "D": 0, "E": 0, "F":0, "G":0, "H":0},
		"elec": {"F1INICIO": 0, "FDIM1":0, "FDIM2":0,
				"PB1MAMA": 0, "PB1NINO": 0, "B1MAMA": 0, "B1NINO":0,
				"PB2MAX":0, "PB2ASESINO":0, "B2MAX":0, "B2ASESINO":0,
				"PB3MARY":0, "PB3GENERAL":0, "B3MARY":0,
				"PB4GIORNO":0, "PB4GENERAL":0, "PB4OSCURO":0, "B4GENERAL":0 },
		"item": {"A": true, "B": false, "C": false, "D": false, "E": false },
		"integrity": true
	}
	return save_dict
