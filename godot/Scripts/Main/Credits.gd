extends Node2D

const section_time := 1.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.blueviolet

var scroll_speed := base_speed
var speed_up := false

onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"",
		"Cross Life: Apocalypse",
		"Trivial Re-Solutions"
	],[
		"",
		"Taller de Diseño y Desarrollo de Videojuegos",
		"Universidad de Chile, FCFM",
		"Profesor: Elías Zelada"
	],[
		""
	],[
		""
	],[
		"Equipo princial",
		"Fabián Díaz",
		"Manuel Díaz",
		"Enzo Nahamias"
	],[
		"Programación",
		"Fabián Díaz"
	],[
		"Ilustración",
		"David Cavieres",
		"Manuel Díaz"
	],[
		"Guión",
		"Manuel Díaz",
		"Enzo Nahamias"
	],[
		"Testers",
		"David Cavieres",
		"Hector Romo"
	],[
		"Software",
		"",
		"Desarrolado en Godot Engine",
		"https://godotengine.org/license",
		"",
		"Mapas creador en Tiled",
		"https://www.mapeditor.org/",
		"",
		"Tiled Importer",
		"https://github.com/vnen/godot-tiled-importer"
	],[
		"Planillas",
		"",
		"Código de Clases CC5408-1",
		"Profesor: Elías Zelada",
		"",
		"Godot Credits",
		"https://github.com/benbishopnz/godot-credits"
	],[
		"Tileset",
		"",
		"Pipoya RPG Tileset",
		"https://pipoya.itch.io/pipoya-rpg-tileset-32x32",
		"",
		"Mighty Pack",
		"https://themightypalm.itch.io/the-mighty-pack",
		"",
		"Modern Interiors",
		"https://limezu.itch.io/moderninteriors",
		"",
		"Dungeon Tileset",
		"https://0x72.itch.io/16x16-dungeon-tileset",
		"",
		"Dungeon Tileset 2",
		"https://0x72.itch.io/dungeontileset-ii",
		"",
		"Mini World",
		"https://merchant-shade.itch.io/16x16-mini-world-sprites",
		"",
		"Rouge Fantasy Catacombs",
		"https://szadiart.itch.io/rogue-fantasy-catacombs",
		"",
		"Pixelhole´s Overworld",
		"https://pixelhole.itch.io/pixelholes-overworld-tileset",
		"",
		"RPG Tileset",
		"https://v-ktor.itch.io/32x32-rpg-tilesets",
		"",
		"Toen´s Mediaval Stategy",
		"https://toen.itch.io/toens-medieval-strategy",
	],[
		"Parallax Background",
		"",
		"Cyberpunk Street Enviroment",
		"https://ansimuz.itch.io/cyberpunk-street-environment",
		"",
		"Warped City",
		"https://ansimuz.itch.io/warped-city",
		"",
		"Glacial Mountains",
		"https://vnitti.itch.io/glacial-mountains-parallax-background",
		"",
		"Mountain Dusk",
		"https://ansimuz.itch.io/mountain-dusk-parallax-background",
		"",
		"Pixel Art Forest",
		"https://edermunizz.itch.io/free-pixel-art-forest",
		"",
		"Pixel Art Hill",
		"https://edermunizz.itch.io/free-pixel-art-hill",
		"",
		"Stringstar Fields",
		"https://trixelized.itch.io/starstring-fields",
		"",
		"Sunny Land",
		"https://ansimuz.itch.io/sunny-land-pixel-game-art"
	],[
		"Characters & Enemies Sprites",
		"",
		"Samurai",
		"https://hugoss-visual-design.itch.io/samurai-asset",
		"",
		"Floating Skull",
		"https://untiedgames.itch.io/floating-skull-enemy",
		"",
		"Evil Wizard 2",
		"https://luizmelo.itch.io/evil-wizard-2",
		"",
		"Gunner Animated Character",
		"https://secrethideout.itch.io/team-wars-platformer-battle",
		"",
		"Knight Sprite",
		"https://lionheart963.itch.io/knight-sprite",
		"",
		"Bandits",
		"https://sventhole.itch.io/bandits"
	],[
		"Music",
		"",
		"Abstraction Music Loop Bundle",
		"https://tallbeard.itch.io/music-loop-bundle",
		"",
		"Dystopian ",
		"https://timbeek.itch.io/dystopian",
		"",
		"CC BGM Collection",
		"https://lunalucid.itch.io/free-creative-commons-bgm-collection",
		"",
		"Fantasy RPG Music Pack",
		"https://muhammadriza.itch.io/free-fantasy-rpg-music-pack",
	],[
		"Other",
		"",
		"PX UI Basic",
		"https://karwisch.itch.io/pxui-basic",
		"",
		"Swordtember 2020",
		"https://thewisehedgehog.itch.io/hs2020",
		"",
		"Shield 2D Items Pack",
		"https://free-game-assets.itch.io/free-shield-2d-items-pack",
		"",
		"Gems Coins",
		"https://laredgames.itch.io/gems-coins-free",
		"",
		"Gerald´s Key",
		"https://gerald-burke.itch.io/geralds-keys",
		"",
		"SpaceShips",
		"https://free-game-assets.itch.io/free-enemy-spaceship-2d-sprites-pixel-art"
	],[
		""
	],[
		""
	],[
		"",
		"Agradecimientos especiales a",
		"",
		""
	]
]


func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.rect_position.y -= scroll_speed
			if l.rect_position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
	get_tree().quit()


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.add_color_override("font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
