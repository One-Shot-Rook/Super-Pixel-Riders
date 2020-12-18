extends Control

var timeStage = 0

onready var tweenStages = [$texONE,$texSHOT,$texROOK]

func _ready():
	$texIcon/Tween.interpolate_property(
		$texIcon,
		"modulate",
		Color(1,1,1,0),
		Color(1,1,1,1),
		0.7,Tween.TRANS_BACK,Tween.EASE_IN)
	$texIcon/Tween.start()

func _on_beforeTimer_timeout():
	$audioOSR.play()
	$audioHit.play()

func _on_stageTimer_timeout():
	if timeStage == 3:
		$stageTimer.stop()
		$afterTimer.start()
		totalFade()
		return
	var dirStage = (2*(timeStage%2))-1
	#print("timeStage = ",timeStage," ",dirStage)
	var texStage = tweenStages[timeStage]
	var tweenStage = texStage.get_node("Tween")
	tweenStage.interpolate_property(
		texStage,
		"rect_position",
		texStage.rect_position+dirStage*Vector2(rect_size[0],0),
		texStage.rect_position,
		0.3,Tween.TRANS_BACK,Tween.EASE_IN)
	tweenStage.interpolate_property(
		texStage,
		"modulate",
		Color(1,1,1,0),
		Color(1,1,1,1),
		0.3,Tween.TRANS_BACK,Tween.EASE_IN)
	tweenStage.start()
	timeStage += 1

func totalFade():
	for icon in tweenStages + [$texIcon]:
		var tweenStage = icon.get_node("Tween")
		tweenStage.interpolate_property(
			icon,
			"modulate",
			Color(1,1,1,1),
			Color(1,1,1,0),
			$afterTimer.wait_time*0.9,Tween.TRANS_BACK,Tween.EASE_IN)
		tweenStage.start()

func _on_afterTimer_timeout():
	get_tree().change_scene("res://Scenes/MenuScene.tscn")

