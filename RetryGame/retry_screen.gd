extends Control


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()


func _on_try_again_button_pressed():
	get_tree().change_scene_to_file("res://night2/house_night_2.tscn")
