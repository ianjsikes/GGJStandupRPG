extends Effect
class_name LaughEffect

@export var laughs: float


func apply(type: Types.JokeType):
	Events.apply_laughs.emit(laughs, type)
