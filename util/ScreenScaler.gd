extends Node2D

var base_viewport_size: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	base_viewport_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	_on_resize()
	get_tree().get_root().size_changed.connect(_on_resize)


func _on_resize():
	scale = Vector2(get_viewport().size) / base_viewport_size
