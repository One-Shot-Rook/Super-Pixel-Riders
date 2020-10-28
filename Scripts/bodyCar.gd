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
		slots[gunName]["ammo"] = slots[gunName]["maxAmmo"]
		
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
	isPlayer = true
	team = "survivor"
	add_to_group("survivor")
	add_to_group("player")
	
	setCollision()

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

func tryToShoot(gunName):
	if slots[gunName]["ammo"] == 0:
		return
	var target = Globals.target
	if target == null:
		return
	if slots[gunName]["fire"] == true and slots[gunName]["timer"].time_left == 0:
		var projectiles = Guns.getGunBehaviour(slots[gunName],self,target)
		for bulletData in projectiles:
			if bulletData["delay"] == 0:
				fireBullet(bulletData["projectile"],slots[gunName]["sound"])
			else:
				var newTimer = Timer.new()
				newTimer.wait_time = bulletData["delay"]
				newTimer.connect("timeout",self,"fireBullet",[bulletData["projectile"],slots[gunName]["sound"]])
				newTimer.connect("timeout",newTimer,"queue_free")
				newTimer.autostart = true
				add_child(newTimer)
				
		slots[gunName]["timer"].start()
		if gunName != "pistol":
			slots[gunName]["ammo"] -= 1

var inputKeys = [KEY_1,KEY_2,KEY_3,KEY_4]

func _input(event):
	
	if event is InputEventKey:
		
		for keyIndex in range(inputKeys.size()):
			
			if event.scancode == inputKeys[keyIndex] and keyIndex < gunNames.size():
			
				if event.pressed:
					fireGun(gunNames[keyIndex])
				else:
					ceaseGun(gunNames[keyIndex])







