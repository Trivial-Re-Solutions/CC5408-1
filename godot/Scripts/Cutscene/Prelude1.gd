extends Node2D

var rand = RandomNumberGenerator.new()

func _ready():
	$Explotion.connect("timeout",self,"_on_Explotion_timeout")
	rand.randomize()

func _process(delta):
	$ParallaxBackground/ColorRect.color = lerp($ParallaxBackground/ColorRect.color, Color(0, 0, 0, 0.5), 0.025)
	
func _on_Explotion_timeout():
	$ParallaxBackground/ColorRect.color = Color(0.8, 0, 0, 0.5)
	$Explotion.start(rand.randi_range(2, 5))
