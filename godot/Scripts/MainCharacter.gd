extends KinematicBody2D

var save_dict = {Vector2(-1,-1):"a", Vector2(-1,0):"b", Vector2(-1,1):"c",
				Vector2(0,-1):"d", Vector2(0,0):"e", Vector2(0,1):"f",
				Vector2(1,-1):"g", Vector2(1,0):"h", Vector2(1,1):"i"}

var linear_vel = Vector2()
var target_vel = Vector2()
var file = File.new()
var str_len = 512

var file_name:String
var save_string:String
var done_move = false
var ind:int

func _init(file_name:String):
	self.file_name = file_name

func _ready():
	file.open_compressed("user://"+file_name, File.WRITE, File.COMPRESSION_ZSTD)
	file.store_float(position.x)
	file.store_float(position.y)

func _process(delta):
	if done_move:
		pass
	
	target_vel = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
		
	save_string += save_dict[target_vel]
	ind += 1
	
	if (ind >= str_len):
		a_save (save_string)
		save_string = ""
		ind = 0
	
	a_move (target_vel)

func done_move():
	a_save (save_string)
	file.close()
	done_move = true

func a_move(target_vel):
	linear_vel = lerp(linear_vel, target_vel * 200, 0.5)
	linear_vel = move_and_slide(linear_vel)
	
func a_save(text):
	file.store_line(text)
	file.store_float(position.x)
	file.store_float(position.y)
