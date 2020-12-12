extends Control

onready var sndMenu = $sndMenu

var hidden = false

var currentScene
var teams = [
	"toad","virtue","toad","toad","souffle",
	"virtue","toad","viper","toad","tangerine",
	"virtue","toad","toad","virtue","cherry",
	"toad","baron"]

var turn = 0
var rng = RandomNumberGenerator.new()

func _ready():
	spawnCar()

func _on_timerSpawn_timeout():
	spawnCar()

func spawnCar():
	var team = teams[turn]
	turn = (turn + 1)%teams.size()
	
	if get_tree().get_nodes_in_group(team).size() >= 3:
		return
	
	# Spawn car
	var spawnData = Globals.getEnemyCarVariables(team)
	var bodyCar = load("res://Scenes/Cars/bodyCarEnemy.tscn").instance()
	bodyCar.team = team
	bodyCar.configure(spawnData,true)
	
	# Spawn in random position
	var spawnY = rect_size.y/2
	rng.randomize()
	bodyCar.position = Vector2(rng.randf_range(250, 850), spawnY - 1120 + rng.randi_range(0,1)*2240)
	
	# Add to scene
	add_child(bodyCar)

func _on_labPlay_pressed():
	if Globals.getUnlocked():
		currentScene = get_tree().change_scene("res://Scenes/Roadmap.tscn")

func _on_labGarage_pressed():
	currentScene = get_tree().change_scene("res://Scenes/Garage.tscn")

func _on_btnEndless_pressed():
	Globals.endless = true
	get_tree().change_scene("res://Scenes/Runway.tscn")

func _on_labSettings_pressed():
	currentScene = get_tree().change_scene("res://Scenes/Settings.tscn")

func _on_labReset_pressed():
	Globals.resetSaveData()

func _on_btnHide_pressed():
	hidden = not hidden
	# Logo
	$UI/twnLogo.interpolate_property(
		$UI/texLogo, "self_modulate",
		null, Color(1,1,1,1)*int(not hidden), 1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$UI/twnLogo.start()
	# Buttons
	$UI/Buttons/twnButtons.interpolate_property(
		$UI/Buttons, "position",
		null, Vector2(int(hidden)*(-500),0), 1,
		Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	$UI/Buttons/twnButtons.start()
	# Button text
	$UI/btnHide.text = "->  " if hidden else "<-  "

