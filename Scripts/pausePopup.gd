extends PopupPanel


func _on_btnResume_pressed():
	get_tree().paused = false
	queue_free()


func _on_btnQuit_pressed():
	get_tree().paused = false
	queue_free()
	var _currentScene = get_tree().change_scene("res://Scenes/Garage.tscn")


func _on_pausePopup_about_to_show():
	$vbox/labTotalMoney.text = "$" + str(Globals.money)
