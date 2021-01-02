extends Container

var parent

var act_dial = 0
var scene:String
var dials:int
var chars:int
var names
var texts

var auto_scroll = false
var is_stop = false
var text = false
var ready = false
var start = false
var finish = true

func _ready():
	$Timer.connect("timeout",self,"_on_timer_timeout")

func _on_timer_timeout():
	ready = true
	if (auto_scroll):
		yield(get_tree().create_timer(1.5), "timeout")
		text = false
		start = true
		ready = false

func set_parameters(dict, node):
	$Text.text = ""
	parent = node
	act_dial = 0
	parent.resume()
	scene = dict["scene"]
	dials = dict["dials"]
	chars = dict["chars"]
	names = dict["names"]
	texts = dict["texts"]
	is_stop = false
	text = false
	ready = false
	start = true
	finish = false

func stop():
	finish = true
	end_dialog()

func _process(delta):
	if finish:
		return
	elif (!text):
		$Timer.stop()
		if (act_dial >= dials):
			finish = true
			end_dialog()
			return
		var act_dialog = texts[String(act_dial)]
		var character = ""
		if (act_dialog["P"] != -1 and act_dialog["P"] < chars):
			var char_name = names[String(act_dialog["P"])]
			character = char_name + " : "
			if (char_name != "¿¿¿???"):
				$Sprite.texture = load("res://sprites/Dialogs/"+char_name+".png")
			else:
				$Sprite.texture = null
		else:
			$Sprite.texture = null
		var dialog:String = act_dialog["D"]
		var text_stop = dialog.replacen("[stop]", "")
		if (dialog != text_stop):
			dialog = text_stop
			is_stop = true
			parent.is_stop()
		if (GameManager.save_data["name"] != null):
			character = character.replacen("[player]", GameManager.save_data["name"])
			dialog = dialog.replacen("[player]", GameManager.save_data["name"])
		$Text.text = character+dialog
		$Text.visible_characters = character.length()+3
		act_dial = act_dial + 1
		text = true
	elif (start and $Text.text.length() >= $Text.visible_characters):
		$Text.visible_characters += 1
	elif (start):
		start = false
		$Timer.start()

func resume():
	is_stop = false

func _input(event):
	if (finish or is_stop or auto_scroll):
		return
	elif Input.is_action_pressed("action_accept"):
		if ready:
			text = false
			start = true
			ready = false
		elif start:
			$Text.visible_characters = -1
			start = false
			$Timer.start()

func end_dialog():
	print ("Text: End dialogs on Scene "+String(scene))
	parent.end_dialog()
