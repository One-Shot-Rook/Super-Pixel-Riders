extends Node

var states = ["shoot","evade","ram"]
#var states = ["evade","shoot"]

var rng = RandomNumberGenerator.new()

var heights = {"top":250, "bottom":1250}
var widths = {"left":100,"right":980}

var distance = 400

func getBehaviour(bodyEntity,state):
	
	var playerEntity = get_tree().get_nodes_in_group("player")[0]
	var player_relVector = playerEntity.position - bodyEntity.position
	
	bodyEntity.fire = false
	var new_fireVector = player_relVector.normalized()
	var new_carVector = Vector2.ZERO
	
	match state:
		
		"shoot":
			bodyEntity.fire = true
		
		"ram":
			var collInfo = bodyEntity.move_and_collide(player_relVector,true,true,true)
			if collInfo:
				if "Enemy" in collInfo.collider.name:
					bodyEntity.state = getNewState(bodyEntity,state)
				else:
					new_carVector = player_relVector.normalized()
		
		"evade":
			var nearEntity = getClosestEntity(bodyEntity)
			var entity_relVector = nearEntity.position - bodyEntity.position
			new_carVector = -entity_relVector.normalized() * sign(distance - entity_relVector.length())
		
		"maintain":
			if bodyEntity.position.y < heights["top"]:
				var collInfo = bodyEntity.move_and_collide(Vector2(0,1)*50,true,true,true)
				if not collInfo:
					new_carVector = Vector2(0,1)
				else:
					new_carVector = Vector2(0,-1)
			elif bodyEntity.position.y > heights["bottom"]:
				var collInfo = bodyEntity.move_and_collide(Vector2(0,-1)*50,true,true,true)
				if not collInfo:
					new_carVector = Vector2(0,-1)
				else:
					new_carVector = Vector2(0,1)
			
			if bodyEntity.position.x < widths["left"]:
				var collInfo = bodyEntity.move_and_collide(Vector2(1,0)*50,true,true,true)
				if not collInfo:
					new_carVector = Vector2(1,0)
				else:
					new_carVector = Vector2(-1,0)
			elif bodyEntity.position.x > widths["right"]:
				var collInfo = bodyEntity.move_and_collide(Vector2(-1,0)*50,true,true,true)
				if not collInfo:
					new_carVector = Vector2(-1,0)
				else:
					new_carVector = Vector2(1,0)
	
	bodyEntity.carVector = new_carVector
	bodyEntity.fireVector = new_fireVector

func getClosestEntity(bodyEntity):
	var entities = ( get_tree().get_nodes_in_group("player") + get_tree().get_nodes_in_group("enemy") ).duplicate()
	entities.erase(bodyEntity)
	var closest = entities[0]
	for entity in entities:
		if entity == bodyEntity:
			continue
		elif bodyEntity.position.distance_to(entity.position) < bodyEntity.position.distance_to(closest.position):
			closest = entity
	return closest

func getNewState(bodyEntity,state=""):
	rng.randomize()
	var newState = ""
	print(inView(bodyEntity))
	if not inView(bodyEntity):
		newState = "maintain"
	else:
		var newStates = states.duplicate()
		newStates.erase(state)
		newState = newStates[rng.randi_range(0,newStates.size()-1)]
	print(bodyEntity.name," is now in ",newState," mode")
	return newState

func inView(bodyEntity):
	
	if heights["bottom"] < bodyEntity.position.y or bodyEntity.position.y < heights["top"]:
		return false
	if widths["right"] < bodyEntity.position.x or bodyEntity.position.x < widths["left"]:
		return false
	
	return true
	


