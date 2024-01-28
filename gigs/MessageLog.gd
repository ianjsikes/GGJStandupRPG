extends VBoxContainer

@export var fade_step = 0.25
@export var log_message_scene: PackedScene
@export var chars_per_second: float = 10.0

var max_messages: int:
	get:
		return roundi(1.0 / fade_step) + 2


func _ready():
	child_entered_tree.connect(_handle_child_added)
	child_exiting_tree.connect(_handle_child_removed)
	Events.set_debug_message.connect(_on_add_message)
	update_fade()


func _on_add_message(message: String):
	var log_message: RichTextLabel = log_message_scene.instantiate()
	log_message.text = message
	log_message.visible_characters = 0
	add_child(log_message)
	create_tween().tween_property(
		log_message, "visible_characters", message.length(), message.length() / chars_per_second
	)


func _handle_child_added(node):
	while get_child_count() > max_messages:
		var oldest = get_child(0)
		remove_child(oldest)
		oldest.queue_free()
	update_fade()


func _handle_child_removed(node):
	update_fade()


func update_fade():
	var child_count = get_child_count()
	for i in child_count:
		get_child(child_count - i - 1).modulate.a = 1.0 - i * fade_step
