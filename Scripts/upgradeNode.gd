extends Panel

var upgName: String
var cribLocation: int
var levels

func configure(location,upgName_pass):
	upgName = upgName_pass
	cribLocation = location
	$labName.text = upgName + ":"
	updateUI()

func _on_btnUpg_pressed():
	
	match cribLocation:
		0:
			Globals.upgradeCar(upgName)
		1:
			Globals.upgradeGun(upgName)
		2:
			print("you just pressed a nonexistent button.... how?")
		3:
			print("you just pressed a nonexistent button.... how?")
		_:
			print("invalid crib location")
	updateUI()

func updateUI():
	
	visible = not (Globals.getGunName() == "pistol" and upgName == "maxAmmo")
	
	var level
	var cost
	var unlocked
	match cribLocation:
		0:
			levels = Globals.cars[Globals.getCarName()][upgName]["levels"].size()
			level = Globals.getUpgradeLevel(upgName)
			cost = Globals.getUpgradeCost(upgName)
			unlocked = Globals.getUnlocked()
		1:
			levels = Globals.guns[Globals.getGunName()][upgName]["levels"].size()
			level = Globals.getUpgradeLevel(upgName, Globals.getGunName())
			cost = Globals.getGunUpgradeCost(upgName)
			unlocked = Globals.getUnlocked(Globals.getGunName())
		2:
			print("you just pressed a nonexistent button.... how?")
		3:
			print("you just pressed a nonexistent button.... how?")
		_:
			print("invalid crib location")
	
	for i in range (1,7):
		var node = get_node("ctnLevel/upgbar" + str(i))
		if levels > i:
			node.visible = true
		else:
			node.visible = false
		if level >= i:
			node.texture = load("res://Assets/img_upg_bar_green.png")
		else:
			node.texture = load("res://Assets/img_upg_bar_red.png")
	
	if not unlocked:
		$btnUpg.disabled = true
		$btnUpg.text = ""
		return
	if level == levels:
		$btnUpg.disabled = true
		$btnUpg.text = "MAX"
	else:
		$btnUpg.disabled = false
		$btnUpg.text = str(cost)+"$"
