extends Node2D


func _on_quit_button_pressed():
	get_tree().quit()


func _on_start_button_pressed():
	SceneManager.change_scene("res://gigs/tutorial/TutorialGig.tscn", {"pattern": "curtains"})
