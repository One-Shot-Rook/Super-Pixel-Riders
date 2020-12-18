extends KinematicBody2D

var timeStage = false
var rng = RandomNumberGenerator.new()
var ammoType

func _ready():
	
	var gunData = Globals.getGunVariables()
	var gunNames = []
	for gunName in gunData:
		if gunName != "pistol":
			gunNames.append(gunName)
	if gunNames.empty(): # If there are no non-pistol weapons equipped
		queue_free()
		return
	rng.randomize()
	var gunIndex = rng.randi_range(0,gunNames.size()-1)
	ammoType = gunNames[gunIndex]
	$texLoot.texture = load("res://Assets/Guns/img_"+ammoType+".png")

func _on_timerLoot_timeout():
	if timeStage:
		queue_free()
	else:
		timeStage = true
		$twnFlash.interpolate_property(
			self, "modulate",
			Color(1,1,1,1), Color(1,1,1,0), 0.5,
			Tween.TRANS_LINEAR, Tween.EASE_IN
		)
		$twnFlash.start()
