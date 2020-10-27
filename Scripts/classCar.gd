extends KinematicBody2D

var death_load = preload("res://Scenes/death.tscn")
var objLoot_load = preload("res://Scenes/objLoot.tscn")

var rng = RandomNumberGenerator.new()

var carVector = Vector2.ZERO		# Input movement vector
var fireVector = Vector2.ZERO		# Shooting vector

var actVector = Vector2.ZERO		# Trailing movement vector

var velocity = Vector2.ZERO			# Movement vector for move_and_slide
var actVelocity = Vector2.ZERO		# Actual velocity of the car
var prevPos = Vector2.ZERO			# Last car position in _physics_process(delta)
var collidedThisTick = false		# Have we collided with a car this _physics_process(delta)
var appliedForce = Vector2.ZERO		# Any collision force being applied
var lootProb = 0.15
var isDead = false

var team: String
var isPlayer: bool = false

var carName:String
var health:float
var mass:float
var maxHealth:float
var engine:float
var handling:float
var armor:float
var turnRatio:float
var slots:Dictionary
var gunNames:Array
var skinName:String

var money

func _ready():
	add_to_group("car")

func setCollision():
	set_collision_layer_bit(Globals.teamBits[team],true)
	set_collision_mask_bit(9,true)
	if isPlayer:
		set_collision_mask_bit(5,true)
	for otherTeam in Globals.teamBits:
		set_collision_mask_bit(Globals.teamBits[otherTeam],true)

func handleMovement(delta,state=""):
	
	collidedThisTick = false
	
	prevPos = position
	
	$partDirt.initial_velocity = Globals.roadSpeed*delta*17
	
	actVector += (carVector - actVector)*delta*handling
	appliedForce += (Vector2.ZERO - appliedForce)*delta
	
	velocity.y = actVector.y*engine*(1+int(velocity.y > 0)*0.40)
	velocity.x = actVector.x*engine*turnRatio
	velocity += appliedForce
	
	var _returnedVelocity = move_and_slide(velocity )
	actVelocity = (position-prevPos)/delta
	var kinCollisionInfo
	var noOfCollisions = get_slide_count()
	if noOfCollisions > 0:
		kinCollisionInfo = get_slide_collision(noOfCollisions-1)
		if kinCollisionInfo: # If we collided
			var entity = kinCollisionInfo.collider
			var entityName = entity.name
			if "Car" in entityName:
				carCollision(kinCollisionInfo)
			elif "Lose" in entityName and isPlayer:
				var _currentScene = get_tree().change_scene("res://Scenes/GameOver.tscn")
			elif "Loot" in entityName:
				var ammoType = entity.ammoType
				entity.queue_free()
				gainAmmo(ammoType)
	
	$sprBro.rotation = fireVector.angle() # Update bro's aiming position
	$sprCar.rotation = actVector.x/3 # Handle rotation
	
	return kinCollisionInfo

func gainAmmo(gunName):
	rng.randomize()
	var amount = rng.randfn(slots[gunName]["maxAmmo"]/3,slots[gunName]["maxAmmo"]/8)
	print("Gained ",amount," ",gunName," ammo!")
	amount = clamp(ceil(amount),0,slots[gunName]["maxAmmo"]-slots[gunName]["ammo"])
	slots[gunName]["ammo"] += amount

func damage(dmg):
	
	if dmg < 0:
		return
	
	if Globals.invincible and isPlayer:
		dmg = 0
	
	var damage = ( (1-armor/100.0)*dmg )
	health -= damage
	
	$prgHealth.value = 100*(health/maxHealth)
	
	if isPlayer:
			get_tree().call_group("healthUI","updateUI",health,maxHealth)
	else:
		$twnDamage.interpolate_property(
			self,"modulate",Color(1,0,0), Color(1,1,1),
			0.2,Tween.TRANS_LINEAR,Tween.EASE_IN
		)
		$twnDamage.start()
	
	if health > 0 or isDead:
		return
	else:
		isDead = true
	
	if isPlayer:
		var _currentScene = get_tree().change_scene("res://Scenes/GameOver.tscn")
	else:
		Globals.levelMoney += money
		var death = death_load.instance()
		death.position = position
		rng.randomize()
		death.get_node("sprExplosion").rotation_degrees = rng.randi_range(0,360)
		death.configure(mass,$sprCar.texture,actVector.x/3)
		get_parent().add_child(death)
		
		if rng.randf_range(0,1) <= lootProb:
			var objLoot = objLoot_load.instance()
			objLoot.position = position
			get_parent().add_child(objLoot)
		
		if Globals.target == self:
			Globals.target = null
			Globals.getTarget(self)
		
		queue_free()
	
	#print(name," took ",damage," dmg")


func carCollision(info:KinematicCollision2D):
	calculateCollision(info.normal,info.collider.actVelocity,info.collider.mass)
	info.collider.calculateCollision(-info.normal,actVelocity,mass)

func calculateCollision(normal,other_actVelocity,other_mass):
	# Check if we've collided this turn
	if collidedThisTick == true:
		return
	collidedThisTick = true
	
	var colliderSpeed = -other_actVelocity.dot(normal) # Calculate impact
	var ourSpeed = -actVelocity.dot(normal)
	var newSpeed = ( 1*other_mass*(colliderSpeed-ourSpeed) + mass*ourSpeed + other_mass*colliderSpeed )/( mass + other_mass )
	var colliderImpulse = colliderSpeed * other_mass
	if -colliderImpulse > mass*20: # Ignore small collisions
		appliedForce += newSpeed*(-normal)
		#print(name," took ",-colliderImpulse," impact")
		damage(-colliderImpulse/600)
