extends KinematicBody2D

var linear_vel = Vector2()
var file = File.new()
var str_len = 512
var mode = 0

var save_string:String
var load_string:String
var ind:int

var save_dict = {Vector2(-1,-1):"a", Vector2(-1,0):"b", Vector2(-1,1):"c",
				Vector2(0,-1):"d", Vector2(0,0):"e", Vector2(0,1):"f",
				Vector2(1,-1):"g", Vector2(1,0):"h", Vector2(1,1):"i"}

var load_dict = {"a":Vector2(-1,-1), "b":Vector2(-1,0), "c":Vector2(-1,1),
				"d":Vector2(0,-1), "e":Vector2(0,0), "f":Vector2(0,1),
				"g":Vector2(1,-1), "h":Vector2(1,0), "i":Vector2(1,1)}


func _ready():
	file.open_compressed("user://save_mov_1.dat", File.WRITE, File.COMPRESSION_ZSTD)
	file.store_float(position.x)
	file.store_float(position.y)
	
func _process(delta):
	var target_vel = Vector2()
	
	if (mode == 0 and Input.is_action_just_pressed("mode_change")):
		a_save (save_string)
		file.close()
		position = Vector2()
		file.open_compressed("user://save_mov_1.dat", File.READ, File.COMPRESSION_ZSTD)
		mode = 1
		ind = 0
		
	
	elif (mode == 0):
		target_vel = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
		
		save_string += save_dict[target_vel]
		ind += 1

		if (ind >= str_len):
			a_save (save_string)
			save_string = ""
			ind = 0
		
	elif (mode == 2):
		target_vel = load_dict[String(load_string.substr(ind, 1))]
		ind += 1
		
		if (load_string.length() != str_len):
			if (ind >= load_string.length()):
				mode = 3
				print ("Test sucess...")
		
		elif (ind >= str_len):
			load_string = a_load()
			ind = 0
			
	elif (mode == 1):
		load_string = a_load()
		mode = 2
	
	a_move (target_vel)
	

func a_move(target_vel):
	linear_vel = lerp(linear_vel, target_vel * 200, 0.5)
	linear_vel = move_and_slide(linear_vel)
	
func a_save(text):
	print ("Saving...")
	file.store_line(text)
	file.store_float(position.x)
	file.store_float(position.y)

func a_load():
	print ("Loading...")
	position = Vector2(file.get_float(), file.get_float())
	return file.get_line()
