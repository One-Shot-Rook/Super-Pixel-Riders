extends Control

onready var sndMenu = $sndMenu

var currentScene
var teams = [
	"toad","virtue","toad","toad",
	"virtue","toad","viper","toad",
	"virtue","toad","toad","virtue",
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
	bodyCar.configure(spawnData)
	
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

func _on_labSettings_pressed():
	currentScene = get_tree().change_scene("res://Scenes/Settings.tscn")

func _on_labReset_pressed():
	Globals.resetSaveData()
