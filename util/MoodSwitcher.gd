@tool
extends Node2D
class_name MoodSwitcher

var current_mood: String:
	set(value):
		current_mood = value
		for child in get_children():
			if child.name == current_mood:
				child.show()
			else:
				child.hide()


func _ready():
	child_entered_tree.connect(_handle_child_added)
	child_exiting_tree.connect(_handle_child_removed)


func _handle_child_added():
	call_deferred("notify_property_list_changed")


func _handle_child_removed():
	call_deferred("notify_property_list_changed")


func _get_modes() -> Array:
	var all_modes = []
	for child in get_children():
		all_modes.append(child.name)
	return all_modes


func _get_property_list() -> Array:
	return [
		{
			name = "current_mood",
			type = TYPE_STRING,
			usage = PROPERTY_USAGE_EDITOR,
			hint = PROPERTY_HINT_ENUM,
			hint_string = ",".join(_get_modes()),
		},
	]
