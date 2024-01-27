extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if get_rect().has_point(to_local(event.position)):
			print("Clicked sprite")
			var club_name = self.name
			print("club sprite: ", club_name)
			if club_name == "Sprite2D":
				SceneManager.change_scene("res://gigs/tutorial/TutorialGig.tscn", {"pattern": "curtains"})

