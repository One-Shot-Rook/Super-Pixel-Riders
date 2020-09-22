extends "res://Scripts/classCar.gd"

onready var Runway = get_tree().get_root().get_node("Runway")

onready var partDirt = $partDirt
#onready var partTyre = $partTyre
onready var sprBro = $sprBro

var haveFuel = true

func _ready():
	var carData = Globals.getCarVariables()
	slots = Globals.getGunVariables()
	
	for variable in carData:
		set(variable,carData[variable])
	
	$sprCar.texture = load("res://Assets/Cars/img_"+skinName+".png")
	
	for gunName in slots:
		gunNames.append(gunName)
		slots[gunName]["fire"] = false # Set fire to false
		
		 # Create firerate timer
		var timer = Timer.new()
		timer.one_shot = true
		if Globals.rapidFire:
			timer.wait_time = 0.1
		else:
			timer.wait_time = slots[gunName]["firerate"]
		timer.connect("timeout",self,"tryToShoot",[gunName])
		add_child(timer)
		slots[gunName]["timer"] = timer # Store the timer reference
		
		# Create sound
		var audio = AudioStreamPlayer2D.new()
		audio.stream = load("res://Assets/Sounds/snd_"+str(gunName)+".wav")
		audio.volume_db = -10
		add_child(audio)
		slots[gunName]["sound"] = audio # Store the audio reference
	
	health = maxHealth
	mass *= 1 + float(armor)/100
	Globals.resetInputs()
	team = "player"

func _physics_process(delta):
	
	handleMovement(delta)
	
	Runway.get_node("areaMove/sprActual").position = 150 * actVector
	
	get_tree().call_group("gunsUI","updateUI",slots)

func areaMove_changed(vector):
	carVector = vector

func fireGun(gunName):
	slots[gunName]["fire"] = true
	tryToShoot(gunName)

func ceaseGun(gunName):
	slots[gunName]["fire"] = false

var inputKeys = [KEY_1,KEY_2,KEY_3,KEY_4]

func _input(event):
	
	if event is InputEventKey:
		
		for keyIndex in range(inputKeys.size()):
			
			if event.scancode == inputKeys[keyIndex] and keyIndex < gunNames.size():
			
				if event.pressed:
					fireGun(gunNames[keyIndex])
				else:
					ceaseGun(gunNames[keyIndex])
			
			elif event.scancode == KEY_SPACE:
				
				if event.pressed:
					if Globals.input == false:
						Globals.input = true
						Globals.nextTarget()
				else:
					Globals.input = false







