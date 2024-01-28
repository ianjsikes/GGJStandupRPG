extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.show_tutorial.connect(_on_show_tutorial)
	Events.hide_tutorial.connect(_on_hide_tutorial)


func _on_show_tutorial(tutorial_name: String):
	if name == tutorial_name and !visible:
		modulate.a = 0.0
		show()
		create_tween().tween_property(self, "modulate:a", 1.0, 0.2)


func _on_hide_tutorial(tutorial_name: String):
	if name == tutorial_name and visible:
		modulate.a = 1.0
		await create_tween().tween_property(self, "modulate:a", 0.0, 0.2).finished
		hide()
