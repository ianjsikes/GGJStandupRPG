extends Node2D

@export var club_scene: PackedScene
@export var club_level: int

var hovered = false

var isEnabled: bool:
	get:
		if club_level == -1:
			return GameState.max_level > 0
		else:
			return GameState.max_level == club_level


# Called when the node enters the scene tree for the first time.
func _ready():
	if !isEnabled:
		self.modulate.a = 0.5
	print("Club %s enabled? %s" % [name, isEnabled])


func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if isEnabled and hovered:
			SceneManager.change_scene(club_scene.resource_path, {"pattern": "curtains"})


func _on_hover_enter():
	hovered = true
	print("Hovering", name)
	if isEnabled:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_hover_exit():
	hovered = false
	print("UNHovering", name)
	if isEnabled:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
