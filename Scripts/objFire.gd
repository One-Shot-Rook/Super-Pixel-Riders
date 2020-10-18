extends Button

var gunName

export(int) var slot

func _ready():
	gunName = Globals.getGunInSlotName(slot)
	if gunName != "empty":
		var skinName = Globals.upgs[gunName]["equippedSkin"]
		$sprWeapon.texture = load("res://Assets/Guns/img_"+skinName+".png")
	else:
		visible = false

func updateUI(slots):
	if gunName == "empty":
		return
	#$sprWeapon.modulate = Color(1,1,1) * (1-slots[gunName]["timer"].time_left/slots[gunName]["timer"].wait_time)
	$reloadPrg.max_value = 360
	$reloadPrg.value = (slots[gunName]["timer"].time_left/slots[gunName]["timer"].wait_time)*360
	$labAmmo.text = str(slots[gunName]["ammo"])

func _on_btnFire_input_event(_viewport, event, _shape_idx):
	
	if event is InputEventScreenTouch:
		if event.pressed:
			get_tree().call_group("player","fireGun",Globals.getGunInSlotName(slot))
			modulate = Color(1,0,0)
		else:
			get_tree().call_group("player","ceaseGun",Globals.getGunInSlotName(slot))
			modulate = Color(1,1,1)
