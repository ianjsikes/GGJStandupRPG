extends Effect
class_name SelfDeprecateEffect

@export var laughs: float


func apply(type: Types.JokeType):
	print("Did last joke fail?", GameState.current_gig.last_joke_failed)
	if GameState.current_gig.last_joke_failed:
		Events.apply_laughs.emit(laughs, type)
	else:
		Events.apply_laughs.emit(laughs * 0.2, type)
