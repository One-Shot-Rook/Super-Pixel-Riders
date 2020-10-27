extends "res://Scripts/classCar.gd"

var state = "maintain"
var dim = Vector2.ZERO

var fire = false

var targetted = false
var target = null

var pain: int
var gunName: String
var gunData: Dictionary

func _ready():
	rng.randomize()
	$sndShot.pitch_scale = rng.randf_range(0.7,1.6)

func configure(carData,forMenu = false):
	# General Configure
	for variable in carData:
		set(variable,carData[variable])
	# Shape configure
	$sprCar.texture = load("res://Assets/Cars/img_"+carName+".png")
	dim = $sprCar.texture.get_size()
	dim = Vector2(dim[0]*$sprCar.scale[0],dim[1]*$sprCar.scale[1])
	$shapeCar.shape.extents = dim/2
	# Gun configure
	gunData["gunName"] = gunName
	for property in gunData:
		if property in Globals.gunUpgrNameArray:
			rng.randomize()
			var upgradeLevel
			if forMenu:
				upgradeLevel = rng.randi_range(0,5)
			else:
				var chaosInt = rng.randi_range(-1,1)
				upgradeLevel = clamp(0, int(Globals.getCurrentLevel()["ID"]/1.5 + chaosInt - 1), 5)
			if property == "maxAmmo":
				gunData[property] = gunData[property]["levels"][0]/3
				#print(name," has ",property, " level ",str(upgradeLevel), " = ",gunData[property])
			else:
				gunData[property] = gunData[property]["levels"][upgradeLevel]
				#print(name," has ",property, " level ",str(upgradeLevel), " = ",gunData[property])
	reload()
	$timerAttack.wait_time = gunData["firerate"]
	$sndShot.stream = load("res://Assets/Sounds/snd_"+str(gunName)+".wav")
	$sndShot.volume_db = -30
	health = maxHealth
	# Set team
	add_to_group(team)
	# Set collision data
	setCollision()

func _physics_process(delta):
	
	AI.getBehaviour(self,state)
	
	var kinCollisionInfo = handleMovement(delta,state)
	if kinCollisionInfo:
		if kinCollisionInfo.collider == target:
			state = AI.getNewState(self,state)
	
	$sprCar/sprTarget.visible = targetted
	$sprState.texture = load("res://Assets/Icons/img_"+state+".png")
	
	if health/maxHealth < 0.50:
		$partSmoke.emitting = true
		if health/maxHealth < 0.25:
			$partFire.emitting = true
	
	$sprBro/texGradient.visible = fire

func tryToShoot():
	target = AI.getTargetEntity(self,AI.getEnemies(team))
	var projectiles = Guns.getGunBehaviour(gunData,self,target)
	for bulletData in projectiles:
		get_parent().add_child(bulletData["projectile"])
	$sndShot.play()
	$timerAttack.start()
	gunData["ammo"] -= 1


func _on_timerAttack_timeout():
	if fire == true:
		tryToShoot()


func _on_bodyCarEnemy_input_event(_viewport, event, _shape_idx):
	
	if event is InputEventScreenTouch:
		
		Globals.makeTarget(self)

func reload():
	gunData["ammo"] = gunData["maxAmmo"]
