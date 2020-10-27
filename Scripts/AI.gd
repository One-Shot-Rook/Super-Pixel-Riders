extends Node

var states = ["shoot","evade","ram","trail"]

var newStates = {
	"shoot":{"timer":false},
	"evade":{"timer":2},
	"ram":{"timer":3},
	}

#var states = ["evade","shoot"]

var stateTable = {
	"maintain":	{"maintain":0,	"shoot":0.7,	"evade":0,		"ram":0.3},
	"shoot":	{"maintain":0,	"shoot":0,		"evade":0.3,	"ram":0.7},
	"evade":	{"maintain":0,	"shoot":0.5,	"evade":0,		"ram":0.5},
	"ram":		{"maintain":0,	"shoot":0.2,	"evade":0.8,	"ram":0},
}

var rng = RandomNumberGenerator.new()

var heights = {"top":-600, "bottom":600}
var widths = {"left":-300,"right":300}

var distance = 400

func getEnemies(team):
	var entities = get_tree().get_nodes_in_group("car")
	var allies = get_tree().get_nodes_in_group(team)
	var enemies = []
	for entity in entities:
		if not entity in allies:
			enemies.append(entity)
	return enemies

func getBehaviour(bodyEntity,state):
	
	var _allAllies = get_tree().get_nodes_in_group(bodyEntity.team).duplicate()
	var allEnemies = getEnemies(bodyEntity.team).duplicate()
	
	var targetEntity = null
	var target_relVector = Vector2(0,-1)
	
	if not allEnemies.empty():
		targetEntity = getTargetEntity(bodyEntity,allEnemies)
		target_relVector = targetEntity.position - bodyEntity.position
	else:
		bodyEntity.state = "maintain"
		state = "maintain"
	
	bodyEntity.fire = false
	bodyEntity.target = null
	var new_fireVector = target_relVector.normalized()
	var new_carVector = Vector2.ZERO
	
	match state:
		
		"shoot":
			bodyEntity.target = targetEntity
			bodyEntity.fire = true
			
			# If we're out of ammo
			if bodyEntity.gunData["ammo"] == 0:
				bodyEntity.state = getNewState(bodyEntity,"shoot")
				bodyEntity.reload()
			
			if not inView(bodyEntity):
				bodyEntity.state = "maintain"
				bodyEntity.reload()
		
		"ram":
			bodyEntity.target = targetEntity
			var collInfo = bodyEntity.move_and_collide(target_relVector,true,true,true)
			if collInfo:
				if "Car" in collInfo.collider.name:
					# If we've got a teammate in the way OR we are about to ram our target
					if bodyEntity.team == collInfo.collider.team:
						bodyEntity.state = getNewState(bodyEntity,"ram")
				new_carVector = target_relVector.normalized()
		
		"evade":
			var nearEntity = getClosestEntity(bodyEntity)
			if not nearEntity:
				return
			var entity_relVector = nearEntity.position - bodyEntity.position
			new_carVector = -entity_relVector.normalized() * clamp(distance - entity_relVector.length(),-1,1)
			# If we've evaded
			if new_carVector == Vector2.ZERO:
				bodyEntity.state = getNewState(bodyEntity,"evade")
		
		"maintain":
			if bodyEntity.position.y - Globals.camPos.y < heights["top"]:
				new_carVector += Vector2(0,1)
			elif bodyEntity.position.y - Globals.camPos.y > heights["bottom"]:
				new_carVector += Vector2(0,-1)
			
			if bodyEntity.position.x - Globals.camPos.x < widths["left"]:
				new_carVector += Vector2(1,0)
			elif bodyEntity.position.x - Globals.camPos.x > widths["right"]:
				new_carVector += Vector2(-1,0)
			
			new_carVector = new_carVector.normalized()
			
			# If we're in view
			if inView(bodyEntity):
				bodyEntity.state = getNewState(bodyEntity,"maintain")
		
		"trail":
			var nearEntity = getClosestEntity(bodyEntity)
			if not nearEntity:
				return
			var entity_relVector = nearEntity.position - bodyEntity.position
			new_carVector = -entity_relVector.normalized() * clamp(distance - entity_relVector.length(),0,1)
			# If we've evaded
			if new_carVector == Vector2.ZERO:
				bodyEntity.state = getNewState(bodyEntity,"evade")
	
	bodyEntity.carVector = new_carVector
	bodyEntity.fireVector = new_fireVector

func getTargetEntity(bodyEntity,enemyEntities):
	if enemyEntities.empty():
		return
	var target = enemyEntities[0]
	for entity in enemyEntities:
		if bodyEntity.position.distance_to(entity.position) < bodyEntity.position.distance_to(target.position):
			target = entity
	return target

func getClosestEntity(bodyEntity):
	var entities = get_tree().get_nodes_in_group("car").duplicate()
	entities.erase(bodyEntity)
	if entities.empty():
		return
	var closest = entities[0]
	for entity in entities:
		if entity == bodyEntity:
			continue
		elif bodyEntity.position.distance_to(entity.position) < bodyEntity.position.distance_to(closest.position):
			closest = entity
	return closest

func inView(bodyEntity):
	
	if bodyEntity.position.y - Globals.camPos.y < heights["top"] or bodyEntity.position.y - Globals.camPos.y > heights["bottom"]:
		return false
	if bodyEntity.position.x - Globals.camPos.x < widths["left"] or bodyEntity.position.x - Globals.camPos.x > widths["right"]:
		return false
	
	return true

func getNewState(bodyEntity,state=""):
	rng.randomize()
	var newState = "maintain" # Default to maintain
	if inView(bodyEntity):
		rng.randomize()
		var prob = rng.randf_range(0,1)
		for potState in states:
			prob -= stateTable[state][potState]
			if prob < 0:
				newState = potState
				break
		
	#print(bodyEntity.name," is now in ",newState," mode")
	return newState


