extends Effect
class_name LaughEffect

@export var laughs: float


func apply():
	Events.apply_laughs.emit(laughs)
