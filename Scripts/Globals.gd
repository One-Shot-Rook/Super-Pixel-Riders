extends Node

var roadSpeed = 1000
var carVector = Vector2.ZERO
var fire = false
var target = null
var camPos = Vector2(540,960)

var activeCarIndex:int = 0
var activeGunIndex:int = 0
var currentCribLocation = "Garage"
var currentLevel: int
var input = false

var carNameArray = []
var carUpgrNameArray = []
var gunNameArray = []
var gunUpgrNameArray = []

var money = 0
var levelMoney = 0

var energy = 0
var maxEnergy = 5

# DEV MODE

var autoTarget = true
var autoFire = false
var freeUpgrades = false
var invincible = false
var rapidFire = false

var coinShopData = [
	{"Coins":2000, "Price":0.49},
	{"Coins":5000, "Price":0.99},
	{"Coins":12000, "Price":1.99},
	{"Coins":40000, "Price":4.99},
	{"Coins":100000, "Price":9.99},
	{"Coins":250000, "Price":19.99},
	{"Coins":500000, "Price":29.99},
	{"Coins":1000000, "Price":49.99},
]

var cars = {
	"squid":{
		"displayName": "Squid",
		"maxHealth":500,
		"unlockCost":0,
		"engine":	{"levels":[300, 350, 400, 450, 500, 550], 		"baseCost":100, 	"mod":1.15},
		"handling":	{"levels":[2, 2.2, 2.4, 2.6, 2.8, 3], 			"baseCost":140, 	"mod":1.10},
		"armor":	{"levels":[0, 5, 10, 15, 20, 25], 				"baseCost":160, 	"mod":1.05},
		"turnRatio":1,
		"slots":4,
		"mass":30},
	"vice":{
		"displayName": "Vice",
		"maxHealth":800,
		"unlockCost":5000,
		"engine":	{"levels":[500, 550, 600, 650, 700, 750], 		"baseCost":200, 	"mod":1.15},
		"handling":	{"levels":[3, 3.2, 3.4, 3.6, 3.8, 4], 			"baseCost":225, 	"mod":1.10},
		"armor":	{"levels":[5, 10, 15, 20, 25, 30], 				"baseCost":250, 	"mod":1.10},
		"turnRatio":0.7,
		"slots":4,
		"mass":30},
	"bike":{
		"displayName": "Bike",
		"maxHealth":800,
		"unlockCost":5000,
		"engine":	{"levels":[500, 550, 600, 650, 700, 750], 		"baseCost":200, 	"mod":1.15},
		"handling":	{"levels":[3, 3.2, 3.4, 3.6, 3.8, 4], 			"baseCost":225, 	"mod":1.10},
		"armor":	{"levels":[5, 10, 15, 20, 25, 30], 				"baseCost":250, 	"mod":1.10},
		"turnRatio":0.7,
		"slots":4,
		"mass":30},
	"cherry":{
		"displayName":"Cherry",
		"maxHealth":1200,
		"unlockCost":7000,
		"engine":	{"levels":[650, 700, 750, 800, 850, 900], 	    "baseCost":300, 	"mod":1.15},
		"handling":	{"levels":[3.4, 3.6, 3.8, 4, 4.2, 4.4], 		"baseCost":325, 	"mod":1.10},
		"armor":	{"levels":[6, 11, 15, 19, 24, 29], 				"baseCost":350, 	"mod":1.10},
		"turnRatio":0.75,
		"slots":4,
		"mass":35},
	"dallas":{
		"displayName":"Dallas",
		"maxHealth":1500,
		"unlockCost":9000,
		"engine":	{"levels":[650, 700, 750, 800, 850, 900], 	    "baseCost":300, 	"mod":1.15},
		"handling":	{"levels":[3.4, 3.6, 3.8, 4, 4.2, 4.4], 		"baseCost":325, 	"mod":1.10},
		"armor":	{"levels":[7, 12, 16, 20, 25, 30], 				"baseCost":350, 	"mod":1.10},
		"turnRatio":0.7,
		"slots":4,
		"mass":45},
	"manta":{
		"displayName": "Manta",
		"maxHealth":1000,
		"unlockCost":12000,
		"engine":	{"levels":[800, 850, 900, 950, 1000, 1050], 	"baseCost":400, 	"mod":1.15},
		"handling":	{"levels":[4, 4.2, 4.4, 4.6, 4.8, 5], 			"baseCost":425, 	"mod":1.10},
		"armor":	{"levels":[0, 4, 8, 12, 16, 20], 				"baseCost":450, 	"mod":1.10},
		"turnRatio":0.9,
		"slots":4,
		"mass":25},
	"souffle":{
		"displayName": "Souffle",
		"maxHealth":1000,
		"unlockCost":12000,
		"engine":	{"levels":[800, 850, 900, 950, 1000, 1050], 	"baseCost":400, 	"mod":1.15},
		"handling":	{"levels":[4, 4.2, 4.4, 4.6, 4.8, 5], 			"baseCost":425, 	"mod":1.10},
		"armor":	{"levels":[0, 4, 8, 12, 16, 20], 				"baseCost":450, 	"mod":1.10},
		"turnRatio":0.9,
		"slots":4,
		"mass":25},
	"tangerine":{
		"displayName":"Tangerine",
		"maxHealth":1200,
		"unlockCost":7000,
		"engine":	{"levels":[650, 700, 750, 800, 850, 900], 	    "baseCost":300, 	"mod":1.15},
		"handling":	{"levels":[3.4, 3.6, 3.8, 4, 4.2, 4.4], 		"baseCost":325, 	"mod":1.10},
		"armor":	{"levels":[6, 11, 15, 19, 24, 29], 				"baseCost":350, 	"mod":1.10},
		"turnRatio":0.75,
		"slots":4,
		"mass":35},
	"goliath":{
		"displayName": "Goliath",
		"maxHealth":2000,
		"unlockCost":30000,
		"engine":	{"levels":[500, 550, 600, 650, 700, 750], 		"baseCost":600, 	"mod":1.15},
		"handling":	{"levels":[1, 1.2, 1.4, 1.6, 1.8, 2], 			"baseCost":625, 	"mod":1.10},
		"armor":	{"levels":[25, 30, 35, 40, 45, 50], 			"baseCost":650, 	"mod":1.10},
		"turnRatio":0.3,
		"slots":4,
		"mass":100},
	"raptor":{
		"displayName": "Raptor",
		"maxHealth":800,
		"unlockCost":40000,
		"engine":	{"levels":[900, 1050, 1100, 1150, 1200, 1250], 	"baseCost":600, 	"mod":1.15},
		"handling":	{"levels":[5, 5.2, 5.4, 5.6, 5.8, 6], 			"baseCost":625, 	"mod":1.10},
		"armor":	{"levels":[0, 4, 8, 12, 16, 20], 				"baseCost":650, 	"mod":1.10},
		"turnRatio":1,
		"slots":4,
		"mass":20},
	"barry":{
		"displayName": "Barry",
		"maxHealth":2000,
		"unlockCost":30000,
		"engine":	{"levels":[500, 550, 600, 650, 700, 750], 		"baseCost":600, 	"mod":1.15},
		"handling":	{"levels":[1, 1.2, 1.4, 1.6, 1.8, 2], 			"baseCost":625, 	"mod":1.10},
		"armor":	{"levels":[25, 30, 35, 40, 45, 50], 			"baseCost":650, 	"mod":1.10},
		"turnRatio":0.3,
		"slots":4,
		"mass":100},
}

var skinNameDict = {
	"squid":{
		"squid":{"costIRL":-1,"costCoins":100},
		"skrilla":{"costIRL":1,"costCoins":100}
	},
	"vice":{
		"vice":{"costIRL":-1,"costCoins":100},
		"afterglow":{"costIRL":1,"costCoins":100}
	},
	"bike":{
		"bike":{"costIRL":-1,"costCoins":100},
	},
	"souffle":{
		"souffle":{"costIRL":-1,"costCoins":100},
	},
	"cherry":{
		"cherry":{"costIRL":-1,"costCoins":100},
	},
	"tangerine":{
		"tangerine":{"costIRL":-1,"costCoins":100},
	},
	"manta":{
		"manta":{"costIRL":-1,"costCoins":100},
		"dongle":{"costIRL":1,"costCoins":100},
		"cyclone":{"costIRL":1,"costCoins":100}
	},
	"dallas":{
		"dallas":{"costIRL":-1,"costCoins":100},
		"impostor":{"costIRL":1,"costCoins":100}
	},
	"goliath":{
		"goliath":{"costIRL":-1,"costCoins":100},
		"ballzack":{"costIRL":1,"costCoins":100},
		"dickinson":{"costIRL":1,"costCoins":100}
	},
	"barry":{
		"barry":{"costIRL":-1,"costCoins":100},
	},
	"raptor":{
		"raptor":{"costIRL":-1,"costCoins":100},
		"toxic":{"costIRL":1,"costCoins":100},
		"angel":{"costIRL":1,"costCoins":100},
		"midnight":{"costIRL":1,"costCoins":100},
	},
	"pistol":{
		"pistol":{"costIRL":-1,"costCoins":100},
		"sunset":{"costIRL":1,"costCoins":100}
	},
	"smg":{
		"smg":{"costIRL":-1,"costCoins":100}
	},
	"shotgun":{
		"shotgun":{"costIRL":-1,"costCoins":100}
	},
	"rifle":{
		"rifle":{"costIRL":-1,"costCoins":100}
	},
	"sniper":{
		"sniper":{"costIRL":-1,"costCoins":100}
	},
	"rpg":{
		"rpg":{"costIRL":-1,"costCoins":100}
	},
	"cannon":{
		"cannon":{"costIRL":-1,"costCoins":100}
	},
	"minigun":{
		"minigun":{"costIRL":-1,"costCoins":100}
	},
}

var enemies = {
	"toad":{
		"maxHealth":150,
		"money":50,
		"engine":300,
		"armor":5,
		"handling":2,
		"turnRatio":1,
		"mass":20,
		"pain":1,
		"gunName":"pistol",
	},
	"virtue":{
		"maxHealth":350,
		"money":125,
		"engine":400,
		"armor":10,
		"handling":3,
		"turnRatio":0.7,
		"mass":25,
		"pain":3,
		"gunName":"smg",
	},
	"viper":{
		"maxHealth":800,
		"money":300,
		"engine":600,
		"armor":15,
		"handling":3,
		"turnRatio":0.9,
		"mass":30,
		"pain":6,
		"gunName":"shotgun",
	},
	"baron":{
		"maxHealth":2000,
		"money":500,
		"engine":300,
		"armor":25,
		"handling":2,
		"turnRatio":1,
		"mass":80,
		"pain":8,
		"gunName":"rpg"
	},
	"souffle":{
		"maxHealth":350,
		"money":125,
		"engine":400,
		"armor":10,
		"handling":3,
		"turnRatio":0.7,
		"mass":25,
		"pain":3,
		"gunName":"rifle",
	},
	"tangerine":{
		"maxHealth":350,
		"money":125,
		"engine":400,
		"armor":10,
		"handling":3,
		"turnRatio":0.7,
		"mass":25,
		"pain":3,
		"gunName":"cannon",
	},
	"cherry":{
		"maxHealth":350,
		"money":125,
		"engine":400,
		"armor":10,
		"handling":3,
		"turnRatio":0.7,
		"mass":25,
		"pain":3,
		"gunName":"minigun",
	},
}

var guns = {
	"pistol":{
		"displayName":"Pistol",
		"unlockCost":0,
		"speed":1600,
		"firerate":	{"levels":[1, 0.9, 0.8, 0.7, 0.6, 0.5], 		"baseCost":35, 	"mod":1.15},
		"accuracy":	{"levels":[0.3, 0.25, 0.20, 0.15, 0.1, 0.05],	"baseCost":50, 	"mod":1.15},
		"damage":	{"levels":[15, 20, 25, 30, 35, 40], 			"baseCost":75, "mod":1.15},
		"maxAmmo":	{"levels":[30, 40, 50, 60, 80, 120], 			"baseCost":150, "mod":1.15},
		"misc":		{"levels":[1.05, 1.10, 1.15, 1.20, 1.25, 1.30], "baseCost":100, "mod":1.15} # kill bonus
	},
	"shotgun":{
		"displayName":"Combat Shotgun",
		"unlockCost":500,
		"speed":2000,
		"firerate":	{"levels":[2, 1.8, 1.6, 1.4, 1.2, 1], 			"baseCost":75, 	"mod":1.15},
		"accuracy":	{"levels":[1, 0.9, 0.8, 0.7, 0.6, 0.5],			"baseCost":90, 	"mod":1.15},
		"damage":	{"levels":[100, 120, 140, 160, 180, 200], 		"baseCost":125, "mod":1.15},
		"maxAmmo":	{"levels":[4, 6, 8, 10, 12, 16], 				"baseCost":150, "mod":1.15},
		"misc":		{"levels":[5, 6, 7, 8, 9, 10], 					"baseCost":100, "mod":1.15} # projectiles
	},
	"smg":{
		"displayName":"Uzi",
		"unlockCost":2400,
		"speed":1600,
		"firerate":	{"levels":[0.15, 0.13, 0.11, 0.09, 0.07, 0.05], "baseCost":200, "mod":1.15},
		"accuracy":	{"levels":[0.6, 0.5, 0.4, 0.3, 0.2, 0.1],		"baseCost":150, "mod":1.15},
		"damage":	{"levels":[3, 5, 7, 9, 12, 15], 				"baseCost":250, "mod":1.15},
		"maxAmmo":	{"levels":[24, 36, 48, 60, 90, 120], 			"baseCost":150, "mod":1.15},
		"misc":		{"levels":[1.05,1.10,1.15,1.20,1.25,1.30], 		"baseCost":0, 	"mod":1.15} # ricochet
	},
	"rifle":{
		"displayName":"AK-47",
		"unlockCost":4500,
		"speed":2400,
		"firerate":	{"levels":[1, 0.9, 0.8, 0.7, 0.5, 0.5],			"baseCost":300, "mod":1.15},
		"accuracy":	{"levels":[0.5, 0.4, 0.3, 0.2, 0.1, 0.05],		"baseCost":250, "mod":1.15},
		"damage":	{"levels":[30, 35, 40, 45, 50, 55], 			"baseCost":400, "mod":1.15},
		"maxAmmo":	{"levels":[20, 24, 28, 32, 36, 40], 			"baseCost":150, "mod":1.15},
		"misc":		{"levels":[3,4,5], 								"baseCost":400, "mod":1.5} # burst
	},
#	"sniper":{
#		"displayName":"Barret 50.cal",
#		"unlockCost":7000,
#		"speed":1600,
#		"firerate":	{"levels":[2, 1.7, 1.4, 1.1, 0.8, 0.5], 		"baseCost":500, "mod":1.15},
#		"accuracy":	{"levels":[0.3, 0.25, 0.20, 0.15, 0.1, 0.05],	"baseCost":380, "mod":1.15},
#		"damage":	{"levels":[15, 20, 25, 30, 35, 40], 			"baseCost":600, "mod":1.15},
#		"misc":		{"levels":[1.05,1.10,1.15,1.20,1.25,1.30], 		"baseCost":0, 	"mod":1.15} # armor negation
#	},
	"rpg":{
		"displayName":"Rocket Laucher",
		"unlockCost":10000,
		"speed":1200,
		"firerate":	{"levels":[4, 3.7, 3.4, 3.1, 2.8, 2.5], 		"baseCost":800, "mod":1.15},
		"accuracy":	{"levels":[0.5, 0.4, 0.3, 0.2, 0.1, 0.05],		"baseCost":500, "mod":1.15},
		"damage":	{"levels":[500, 550, 600, 650, 700, 800], 		"baseCost":900, "mod":1.15},
		"maxAmmo":	{"levels":[3, 4, 5, 6, 8, 12], 					"baseCost":150, "mod":1.15},
		"misc":		{"levels":[300,350,400,450,500,550], 			"baseCost":650, "mod":1.15} # radius
	},
#	"flamethrower":{
#		"displayName":"Flamethrower",
#		"unlockCost":25000,
#		"speed":1200,
#		"firerate":	{"levels":[4, 3.5, 3, 2.5, 2, 1.5], 			"baseCost":1200,"mod":1.15},
#		"accuracy":	{"levels":[0.5, 0.4, 0.3, 0.2, 0.1, 0.05],		"baseCost":800, "mod":1.15},
#		"damage":	{"levels":[500, 600, 700, 800, 900, 1000], 		"baseCost":1300,"mod":1.15},
#		"misc":		{"levels":[300,350,400,450,500,550], 			"baseCost":0,	"mod":1.15} # arc
#	},
	"cannon":{
		"displayName":"Gauss Cannon",
		"unlockCost":50000,
		"speed":4000,
		"firerate":	{"levels":[4, 3.5, 3, 2.5, 2, 1.5], 			"baseCost":1500,"mod":1.15},
		"accuracy":	{"levels":[0.5, 0.4, 0.3, 0.2, 0.1, 0.05],		"baseCost":1100,"mod":1.15},
		"damage":	{"levels":[500, 600, 700, 800, 900, 1000], 		"baseCost":1600,"mod":1.15},
		"maxAmmo":	{"levels":[3, 5, 7, 9, 11, 15], 				"baseCost":150, "mod":1.15},
		"misc":		{"levels":[300,350,400,450,500,550], 			"baseCost":0,	"mod":1.15} # arc
	},
	"minigun":{
		"displayName":"Gatling Gun",
		"unlockCost":100000,
		"speed":3000,
		"firerate":	{"levels":[0.05, 0.045, 0.04, 0.035, 0.03, 0.025],	"baseCost":2000,"mod":1.15},
		"accuracy":	{"levels":[0.5, 0.4, 0.3, 0.2, 0.1, 0.05],			"baseCost":1500,"mod":1.15},
		"damage":	{"levels":[10, 13, 16, 20, 24, 30], 				"baseCost":2250,"mod":1.15},
		"maxAmmo":	{"levels":[50, 70, 100, 150, 200, 300], 			"baseCost":150, "mod":1.15},
		"misc":		{"levels":[300,350,400,450,500,550], 				"baseCost":0,	"mod":1.15} # arc
	}
}

var roadmap = [
	{
		"ID": 0,
		"displayName": "Desert Wastes",
		"basePain": 2,
		"enemyList": [
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"toad"},
		],
		"background": "desert",
		"reward": 250
	},
	
	{
		"ID": 1,
		"displayName": "The Heat Abyss",
		"basePain": 2,
		"enemyList": [
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"virtue", "boss":true}
		],
		"background": "desert",
		"reward": 500
	},
	
	{
		"ID": 2,
		"displayName": "Jungle Outskirts",
		"basePain": 3,
		"enemyList": [
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"virtue"},
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"virtue"}
		],
		"background": "forest",
		"reward": 600
	},
	
	{
		"ID": 3,
		"displayName": "The Vine Kingdom",
		"basePain": 4,
		"enemyList": [
			{"carName":"virtue"},
			{"carName":"toad"},
			{"carName":"virtue"},
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"viper", "boss":true}
		],
		"background": "forest",
		"reward": 800
	},
	
	{
		"ID": 4,
		"displayName": "Snowy Hills",
		"basePain": 6,
		"enemyList": [
			{"carName":"toad"},
			{"carName":"toad"},
			{"carName":"virtue"},
			{"carName":"virtue"},
			{"carName":"toad"},
			{"carName":"viper"},
			{"carName":"toad"},
			{"carName":"viper"},
		],
		"background": "snow",
		"reward": 1000
	},
	
	{
		"ID": 5,
		"displayName": "Blizzard",
		"basePain": 8,
		"enemyList": [
			{"carName":"virtue"},
			{"carName":"toad"},
			{"carName":"virtue"},
			{"carName":"virtue"},
			{"carName":"toad"},
			{"carName":"viper"},
			{"carName":"virtue"},
			{"carName":"baron", "boss":true},
		],
		"background": "snow",
		"reward": 1300
	},
	
	{
		"ID": 6,
		"displayName": "Cityscape",
		"basePain": 16,
		"enemyList": [
			{"carName":"virtue"},
			{"carName":"virtue"},
			{"carName":"viper"},
			{"carName":"virtue"},
			{"carName":"baron"},
			{"carName":"virtue"},
			{"carName":"viper"},
			{"carName":"viper"},
			{"carName":"baron"},
		],
		"background": "night",
		"reward": 1500
	},
]

var upgs = {}

var levelUnlocks = []

var teamBits = {
	"survivor":1,
	"merc":3,
	"toad":20,
	"virtue":19,
	"viper":18,
	"baron":17,
	"souffle":16,
	"tangerine":15,
	"cherry":14,
}

var projectileBits = {
	"ballistic":2,
	"rocket":4
}

func _ready():
	#OS.shell_open("https://www.youtube.com/watch?v=dQw4w9WgXcQ") # this is the rick roll line, disable it after you got pranked bro
	initialiseData()
	loadGame()



# INITIALISE

func resetInputs():
	carVector = Vector2.ZERO
	fire = false

func initialiseData():
	activeCarIndex = 0
	activeGunIndex = 0
	carNameArray = []
	for carName in cars:
		initialiseCarUpgrades(carName)
	upgs["squid"]["unlocked"] = true
	gunNameArray = []
	for gunName in guns:
		initialiseGunUpgrades(gunName)
	upgs["pistol"]["unlocked"] = true
	levelUnlocks = []
	for level in roadmap:
		levelUnlocks.append(false)
	levelUnlocks[0] = true
	money = 0
	energy = maxEnergy

func getCarVariables(carName = getCarName()):
	var carData = {}
	
	carData["carName"] = carName
	for property in cars[carName]: # Loop through the car properties
		if property in carUpgrNameArray: # If this property is upgradeable
			# Save the correct upgrade value
			carData[property] = cars[carName][property]["levels"][upgs[carName][property]]
		else:
			carData[property] = cars[carName][property]
	carData["skinName"] = upgs[carName]["equippedSkin"]
	
	roadSpeed = 1000 + carData["engine"]*0.2
	return carData.duplicate(true)

func getEnemyCarVariables(carName):
	var carData = {}
	carData["carName"] = carName
	for property in enemies[carName]:
		carData[property] = enemies[carName][property]
	carData["gunData"] = guns[ carData["gunName"] ]
	return carData.duplicate(true)

func getGunVariables():
	var carName = getCarName()
	var slots = upgs[carName]["slots"]
	var gunData = {}
	for gunName in slots.values():
		if gunName == "empty":
			continue
		gunData[gunName] = {}
		gunData[gunName]["gunName"] = gunName
		gunData[gunName]["speed"] = guns[gunName]["speed"]
		gunData[gunName]["firerate"] = guns[gunName]["firerate"]["levels"][upgs[gunName]["firerate"]]
		gunData[gunName]["accuracy"] = guns[gunName]["accuracy"]["levels"][upgs[gunName]["accuracy"]]
		gunData[gunName]["damage"] = guns[gunName]["damage"]["levels"][upgs[gunName]["damage"]]
		gunData[gunName]["maxAmmo"] = guns[gunName]["maxAmmo"]["levels"][upgs[gunName]["maxAmmo"]]
		gunData[gunName]["misc"] = guns[gunName]["misc"]["levels"][upgs[gunName]["misc"]]
	return gunData.duplicate(true)

func initialiseCarUpgrades(carName):
	carNameArray.append(carName)
	upgs[carName] = {"unlocked":false,"slots":{"0":"pistol"},"equippedSkin":carName,"skinList":{}}
	carUpgrNameArray = []
	# Now we want to look through the car properties
	for upgName in cars[carName]:
		# If a key (property) has a Dictionary value it is an upgradeable
		if cars[carName][upgName] is Dictionary:
			upgs[carName][upgName] = 0 # Init its upgrade index
			carUpgrNameArray.append(upgName)
	# Now we want to initialise the skin data
	for skinName in skinNameDict[carName]:
		upgs[carName]["skinList"][skinName] = 0 # 0 is locked, 1 is unlocked
	upgs[carName]["skinList"][carName] = 1
	# Now we want to initialise the gun slots
	for slot in range(1,cars[carName]["slots"]):
		upgs[carName]["slots"][str(slot)] = "empty"

func initialiseGunUpgrades(gunName):
	gunNameArray.append(gunName)
	upgs[gunName] = {"unlocked":false,"equippedSkin":gunName,"skinList":{}}
	gunUpgrNameArray = []
	# Now we want to look through the gun properties
	for upgName in guns[gunName]:
		# If a key (property) has a Dictionary value it is an upgradeable
		if guns[gunName][upgName] is Dictionary:
			upgs[gunName][upgName] = 0 # Init its upgrade index
			gunUpgrNameArray.append(upgName)
	# Now we want to initialise the skin data
	for skinName in skinNameDict[gunName]:
		upgs[gunName]["skinList"][skinName] = 0 # 0 is locked, 1 is unlocked
	upgs[gunName]["skinList"][gunName] = 1

func getGunInSlotName(slot):
	if slot < getMaxSlots():
		return upgs[getCarName()]["slots"][str(slot)]
	else:
		return "empty"

func setWeaponSlot(slotNo, wpnName):
	upgs[carNameArray[activeCarIndex]]["slots"][str(slotNo)] = wpnName
	saveGame()

func transferFunds():
	money += levelMoney
	levelMoney = 0

func addMoney(mny):
	money += mny
	saveGame()

func nextCar():
	activeCarIndex += 1
	saveGame()

func nextGun():
	activeGunIndex += 1
	saveGame()

func prevCar():
	activeCarIndex -= 1
	saveGame()

func prevGun():
	activeGunIndex -= 1
	saveGame()

func getTarget(exception=null):
	var targets = AI.getEnemies("survivor")
	if exception:
		targets.erase(exception)
	if targets.empty(): # If there are no targets
		return
	if target == null: # If there's no target
		makeTarget(targets[0]) # Grab the first target

func makeTarget(car):
	if target != null:
		target.targetted = false
	target = car
	target.targetted = true

func getCarIndex():
	return activeCarIndex

func getGunIndex():
	return activeGunIndex

func getCarName():
	return carNameArray[activeCarIndex]

func getGunName():
	return gunNameArray[activeGunIndex]

func getMaxSlots():
	return cars[carNameArray[activeCarIndex]]["slots"]

func getNoOfCars():
	return carNameArray.size()

func getNoOfGuns():
	return gunNameArray.size()



# LEVEL

func getCurrentLevel():
	return roadmap[currentLevel].duplicate(true)

func gainLevelReward():
	levelMoney += roadmap[currentLevel]["reward"]

func setLevel(levelID):
	currentLevel = levelID
	saveGame()

func unlockNextLevel():
	if currentLevel + 1 == levelUnlocks.size():
		return
	levelUnlocks[currentLevel+1] = true

func isLevelUnlocked(levelID):
	return levelUnlocks[levelID]



# UNLOCK

func getUnlocked(query = getCarName()):
	return upgs[query]["unlocked"]

func getUnlockCostCar(carName = getCarName()):
	var cost = cars[carName]["unlockCost"]
	return cost

func getUnlockCostGun(gunName = getGunName()):
	var cost = guns[gunName]["unlockCost"]
	return cost

func unlockCar(carName = getCarName()):
	var cost = getUnlockCostCar(carName)
	if money < cost and not freeUpgrades:
		return
	upgs[carName]["unlocked"] = true
	if not freeUpgrades:
		money -= cost
	get_tree().call_group("unlockUI","updateUI")
	saveGame()

func unlockGun(gunName = getGunName()):
	var cost = getUnlockCostGun(gunName)
	if money < cost and not freeUpgrades:
		return
	upgs[gunName]["unlocked"] = true
	if not freeUpgrades:
		money -= cost
	get_tree().call_group("unlockUI","updateUI")
	saveGame()

func unlockAll():
	var prev_freeUpgrades = freeUpgrades
	freeUpgrades = true
	for carName in carNameArray:
		unlockCar(carName)
	for gunName in gunNameArray:
		unlockGun(gunName)
	for levelID in range(levelUnlocks.size()):
		levelUnlocks[levelID] = true
	freeUpgrades = prev_freeUpgrades



# UPGRADES

func upgradeCar(upgName,carName = getCarName()):
	var cost = getUpgradeCost(upgName,carName)
	if money < cost and not freeUpgrades:
		return
	if upgs[carName][upgName] < 5:
		upgs[carName][upgName] += 1
		if not freeUpgrades:
			money -= cost
		get_tree().call_group("moneyUI","updateUI")
		saveGame()

func upgradeGun(upgName,gunName = getGunName()):
	var cost = getGunUpgradeCost(upgName,gunName)
	if money < cost and not freeUpgrades:
		return
	if upgs[gunName][upgName] < 5:
		upgs[gunName][upgName] += 1
		if not freeUpgrades:
			money -= cost
		get_tree().call_group("moneyUI","updateUI")
		saveGame()

func getUpgradeLevel(upgName, query = getCarName()):
	return upgs[query][upgName]

func getUpgradeCost(upgName,carName = getCarName()):
	var baseCost = cars[carName][upgName]["baseCost"]
	var mod = cars[carName][upgName]["mod"]
	var level = getUpgradeLevel(upgName,carName)
	if level < 5:
		return ceil(baseCost * pow(mod,level))
	else:
		return ceil(baseCost * pow(mod,4))

func getGunUpgradeCost(upgName,gunName = getGunName()):
	var baseCost = guns[gunName][upgName]["baseCost"]
	var mod = guns[gunName][upgName]["mod"]
	var level = getUpgradeLevel(upgName, gunName)
	if level < 5:
		return ceil(baseCost * pow(mod,level))
	else:
		return ceil(baseCost * pow(mod,4))

func resetUpgrades():
	if currentCribLocation == "Garage":
		initialiseCarUpgrades(getCarName())
	elif currentCribLocation == "GunShop":
		initialiseGunUpgrades(getGunName())
	saveGame()

func upgradeAll():
	var prev_freeUpgrades = freeUpgrades
	freeUpgrades = true
	for carName in carNameArray:
		for upgName in carUpgrNameArray:
			for upg in cars[carName][upgName]["levels"].size():
				upgradeCar(upgName,carName)
	for gunName in gunNameArray:
		for upgName in gunUpgrNameArray:
			for upg in guns[gunName][upgName]["levels"].size():
				upgradeGun(upgName,gunName)
	freeUpgrades = prev_freeUpgrades



# SKINS

func setSkin(objName, skinName):
	upgs[objName]["equippedSkin"] = skinName

func getItemSkin(objName):
	return upgs[objName]["equippedSkin"]

func getSkinCostCoins(objName, skinName):
	return skinNameDict[objName][skinName]["costCoins"]

func getSkinCostIRL(objName, skinName):
	return skinNameDict[objName][skinName]["costIRL"]



# Energy

func getMaxEnergy():
	return maxEnergy

func getEnergy():
	return energy

func useEnergy(amount):
	if energy < amount:
		return false
	energy -= amount
	return true


# IAPs

func purchaseCoins(cost):
	if money < cost and not freeUpgrades:
		return false # purchase failure
	if not freeUpgrades:
		money -= cost
	return true # purchase success

func getCoinShopData():
	return coinShopData


# MISC

func setCurrentCribLocation(location):
	currentCribLocation = location

func toggle(strVar):
	set(strVar,not get(strVar))
	saveGame()



# SAVE / LOAD

var saveVariables = [
	"upgs",
	"activeCarIndex",
	"money",
	"autoTarget",
	"autoFire",
	"freeUpgrades",
	"invincible",
	"currentLevel",
	"levelUnlocks"
	]

func resetSaveData():
	initialiseData()
	saveGame()

func createSaveData(): # Copy the state of the game to a save dict
	var saveData = {}
	for variable in saveVariables:
		saveData[variable] = get(variable)
	return saveData

func loadSaveData(saveData): # Set the state of the game from a save dict
	for variable in saveData:
		set(variable,saveData[variable])

func saveGame(): # Create save file
	var saveFile = File.new()
	var saveData = createSaveData()
	saveFile.open("user://saveFile.json", File.WRITE)
	saveFile.store_line(to_json(saveData))
	saveFile.close()
	
func loadGame(): # Load save file
	var saveFile = File.new()
	if not saveFile.file_exists("user://saveFile.json"):
		return
	saveFile.open("user://saveFile.json", File.READ)
	var saveData = parse_json(saveFile.get_line())
	saveFile.close()
	loadSaveData(saveData)


