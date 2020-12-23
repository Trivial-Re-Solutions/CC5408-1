tool
extends EditorImportPlugin

func get_importer_name():
	return "trivial.dialog_importer"

func get_visible_name():
	return "Dialog File"

func get_recognized_extensions():
	return ["dials", "zdials"]

func get_save_extension():
	return "res"

func get_resource_type():
	return "TextFile"