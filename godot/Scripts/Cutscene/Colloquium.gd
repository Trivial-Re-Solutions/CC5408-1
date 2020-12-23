extends Container

var parent

var act_dial = 0
var scene:String
var dials:int
var chars:int
var names
var texts

var text = false
var ready = false
var finish = true
var start = false

func _ready():
	$Timer.connect("timeout",self,"_on_timer_timeout")

func _on_timer_timeout():
	ready = true

func set_parameters(dict, node):
	$Text.text = ""
	parent = node
	act_dial = 0
	scene = dict["scene"]
	dials = dict["dials"]
	chars = dict["chars"]
	names = dict["names"]
	texts = dict["texts"]
	text = false
	ready = false
	finish = false
	start = true

func _process(delta):
	if finish:
		return
	if (!text):
		if (act_dial >= dials):
			finish = true
			parent.end_dialog()
			return
		var act_dialog = texts[String(act_dial)]
		var character = ""
		if (act_dialog["P"] != -1 or act_dialog["P"] >= chars):
			character = names[String(act_dialog["P"])]+" : "
		var dialog:String = act_dialog["D"]
		if (GameManager.save_data["name"] != null):
			character = character.replacen("[player]", GameManager.save_data["name"])
			dialog = dialog.replacen("[player]", GameManager.save_data["name"])
		$Text.text = character+dialog
		$Text.visible_characters = character.length()+3
		act_dial += 1
		text = true
	elif (start and $Text.text.length() >= $Text.visible_characters):
		$Text.visible_characters += 1
	elif (start):
		start = false
		$Timer.start()

func _input(event):
	if Input.is_action_pressed("action_accept"):
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