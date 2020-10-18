extends Button

var load_pausePopup = preload("res://Scenes/pausePopup.tscn")

func _ready():
	pass # Replace with function body.




func _on_btnPause_pressed():
	get_tree().paused = true
	var pausePopup = load_pausePopup.instance()
	add_child(pausePopup)
	pausePopup.popup_centered()
