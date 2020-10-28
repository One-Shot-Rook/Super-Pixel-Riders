extends Node

var bodyBullet_load = preload("res://Scenes/Projectiles/bodyBullet.tscn")
var bodyRocket_load = preload("res://Scenes/Projectiles/bodyRocket.tscn")

var rng = RandomNumberGenerator.new()

func getGunBehaviour(gunData,bodyEntity,targetEntity):
	
	#print(bodyEntity.name," fired ",gunData["gunName"])
	var projectiles = []
	
	match gunData["gunName"]:
		
		"pistol":
			
			var relVector = getTargetVector(bodyEntity,targetEntity)
			var bodyBullet = bodyBullet_load.instance()
			bodyBullet.position = bodyEntity.position
			bodyBullet.fireVector = applySpread(relVector,gunData["accuracy"])
			bodyBullet.rotation = bodyBullet.fireVector.angle()
			bodyBullet.speed = gunData["speed"]
			bodyBullet.mass = float(gunData["damage"])/float(gunData["speed"])
			bodyBullet.get_node("texBullet").texture = load("res://Assets/Guns/img_pistol_ammo.png")
			bodyBullet.setCollision(bodyEntity.team)
			projectiles.append({"projectile":bodyBullet,"delay":0})
		
		"shotgun":
			
			for _bullet in range(gunData["misc"]):
				var relVector = getTargetVector(bodyEntity,targetEntity)
				var bodyBullet = bodyBullet_load.instance()
				bodyBullet.position = bodyEntity.position
				bodyBullet.fireVector = applySpread(relVector,gunData["accuracy"])
				bodyBullet.rotation = bodyBullet.fireVector.angle()
				bodyBullet.speed = gunData["speed"]
				bodyBullet.mass = ( float(gunData["damage"])/float(gunData["speed"]) )/float(gunData["misc"])
				bodyBullet.get_node("texBullet").texture = load("res://Assets/Guns/img_shotgun_ammo.png")
				bodyBullet.setCollision(bodyEntity.team)
				projectiles.append({"projectile":bodyBullet,"delay":0})
		
		"smg":
			var relVector = getTargetVector(bodyEntity,targetEntity)
			var bodyBullet = bodyBullet_load.instance()
			bodyBullet.position = bodyEntity.position
			bodyBullet.fireVector = applySpread(relVector,gunData["accuracy"])
			bodyBullet.rotation = bodyBullet.fireVector.angle()
			bodyBullet.speed = gunData["speed"]
			bodyBullet.mass = float(gunData["damage"])/float(gunData["speed"])
			bodyBullet.get_node("texBullet").texture = load("res://Assets/Guns/img_smg_ammo.png")
			bodyBullet.setCollision(bodyEntity.team)
			projectiles.append({"projectile":bodyBullet,"delay":0})
		
		"rifle":
			for bullet in range(gunData["misc"]):
				var relVector = getTargetVector(bodyEntity,targetEntity)
				var bodyBullet = bodyBullet_load.instance()
				bodyBullet.position = bodyEntity.position
				bodyBullet.fireVector = applySpread(relVector,gunData["accuracy"])
				bodyBullet.rotation = bodyBullet.fireVector.angle()
				bodyBullet.speed = gunData["speed"]
				bodyBullet.mass = ( float(gunData["damage"])/float(gunData["speed"]) )/float(gunData["misc"])
				bodyBullet.get_node("texBullet").texture = load("res://Assets/Guns/img_shotgun_ammo.png")
				bodyBullet.setCollision(bodyEntity.team)
				projectiles.append({"projectile":bodyBullet,"delay":bullet*0.08})
		
		"sniper":
			pass
		
		"rpg":
			
			var relVector = getTargetVector(bodyEntity,targetEntity)
			var bodyRocket = bodyRocket_load.instance()
			bodyRocket.position = bodyEntity.position
			bodyRocket.fireVector = applySpread(relVector,gunData["accuracy"])
			bodyRocket.rotation = bodyRocket.fireVector.angle()
			bodyRocket.speed = gunData["speed"]
			bodyRocket.aoe = gunData["misc"]
			bodyRocket.mass = float(gunData["damage"])/float(gunData["speed"])
			bodyRocket.setCollision(bodyEntity.team)
			projectiles.append({"projectile":bodyRocket,"delay":0})
		
		"flamethrower":
			pass
		
		"cannon":
			var relVector = getTargetVector(bodyEntity,targetEntity)
			var bodyBullet = bodyBullet_load.instance()
			bodyBullet.position = bodyEntity.position
			bodyBullet.fireVector = applySpread(relVector,gunData["accuracy"])
			bodyBullet.rotation = bodyBullet.fireVector.angle()
			bodyBullet.speed = gunData["speed"]
			bodyBullet.mass = float(gunData["damage"])/float(gunData["speed"])
			bodyBullet.setCollision(bodyEntity.team)
			projectiles.append({"projectile":bodyBullet,"delay":0})
			bodyEntity.appliedForce += -bodyBullet.fireVector*500
		
		"minigun":
			var relVector = getTargetVector(bodyEntity,targetEntity)
			var bodyBullet = bodyBullet_load.instance()
			bodyBullet.position = bodyEntity.position
			bodyBullet.fireVector = applySpread(relVector,gunData["accuracy"])
			bodyBullet.rotation = bodyBullet.fireVector.angle()
			bodyBullet.speed = gunData["speed"]
			bodyBullet.mass = float(gunData["damage"])/float(gunData["speed"])
			bodyBullet.setCollision(bodyEntity.team)
			projectiles.append({"projectile":bodyBullet,"delay":0})
	
	return projectiles

func getTargetVector(bodyEntity,targetEntity):
	var target = null
	if bodyEntity.isPlayer:
		target = Globals.target
	else:
		target = bodyEntity.target
	if target == null:
		return Vector2(0,-1) # Looking up
		
	var relVector = targetEntity.position - bodyEntity.position
	return relVector.normalized()

func applySpread(vector,arc):
	rng.randomize()
	var newAngle = rng.randfn(vector.angle(),arc/4.0)
	return Vector2( cos(newAngle) , sin(newAngle) )
	
