extends Node
class_name CrowdEvent

@export var weight: float = 1.0
@export_multiline var message: String
# @export var joke_name: String
# @export_multiline var joke_description: String
# @export var joke_type: Types.JokeType = Types.JokeType.VANILLA
# @export_range(0.0, 1.0) var accuracy: float = 1.0
# @export var miss_damage: float = 0.0

var effects: Array[Effect]:
	get:
		var result: Array[Effect]
		result.assign(N.get_all_children(self, Effect))
		return result


func execute():
	Events.set_debug_message.emit(message)

	for effect in effects:
		await effect.apply(Types.JokeType.VANILLA)
