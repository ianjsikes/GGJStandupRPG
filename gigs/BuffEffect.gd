extends Effect
class_name BuffEffect

@export var buff_scene: PackedScene


func apply():
	var new_buff = buff_scene.instantiate()
	Events.buff_new.emit(new_buff)
