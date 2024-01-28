extends Sprite2D

@export var club_scene: PackedScene
@export var club_name: String
@export var isEnabled: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	print("self", self)
	if isEnabled:
		print("its enabled")
		self
	else:
		print("its not")
		self.modulate = Color(0, 0, 1)
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

	
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if isEnabled and get_rect().has_point(to_local(event.position)):
			SceneManager.change_scene(club_scene.resource_path, {"pattern": "curtains"})


func _on_hover_enter():
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)

func _on_hover_exit():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
