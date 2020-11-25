extends Node2D

var linear_vel = Vector2()
var pos = 0

func _process(delta):
	pos += delta
	var pos_cos = cos(pos *12) * 6 + cos(pos *10) * 4
	$ParallaxBackground/ParallaxLayer/Sprite.position.y += pos_cos
	$ParallaxBackground/ParallaxLayer/Sprite2.position.y += pos_cos
	
	linear_vel = lerp(linear_vel, Vector2(-1, 0) * 200, 0.5)
	linear_vel = $Camera.move_and_slide(linear_vel)
