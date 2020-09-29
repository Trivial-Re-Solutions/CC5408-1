extends KinematicBody2D

var load_dict = {"a":Vector2(-1,-1), "b":Vector2(-1,0), "c":Vector2(-1,1),
				"d":Vector2(0,-1), "e":Vector2(0,0), "f":Vector2(0,1),
				"g":Vector2(1,-1), "h":Vector2(1,0), "i":Vector2(1,1)}

var linear_vel = Vector2()
var target_vel = Vector2()
var file = File.new()
var str_len = 512

var file_name:String
var load_string:String
var done_move = true
var ind:int

func start_movement(file_name:String):
	self.file_name = file_name
	file.open_compressed("user://"+file_name+".dat", File.READ, File.COMPRESSION_ZSTD)
	load_string = a_load()
	done_move = false

func _process(delta):
	if done_move:
		return
	
	target_vel = load_dict[String(load_string.substr(ind, 1))]
	ind += 1
	
	if (load_string.length() != str_len):
		if (ind >= load_string.length()):
			done_move = true
	
	elif (ind >= str_len):
		load_string = a_load()
		ind = 0
	
	a_move (target_vel)

func a_move(target_vel):
	linear_vel = lerp(linear_vel, target_vel * 200, 0.5)
	linear_vel = move_and_slide(linear_vel)
	
	# if($CollisionShape2D.call_deferred())

func a_load():
	position = Vector2(file.get_float(), file.get_float())
	return file.get_line()
