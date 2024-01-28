extends Node
class_name Joke

@export var joke_name: String
@export_multiline var joke_description: String
@export var joke_type: Types.JokeType = Types.JokeType.VANILLA
@export_range(0.0, 1.0) var accuracy: float = 1.0
@export var miss_damage: float = 0.0

var effects: Array[Effect]:
	get:
		var result: Array[Effect]
		result.assign(N.get_all_children(self, Effect))
		return result


func execute():
	Events.set_debug_message.emit('You use "%s"' % joke_name)
	await get_tree().create_timer(0.5).timeout

	var player: GigPlayer = N.get_ancestor(self, GigPlayer)
	var acc = player.get_modded_accuracy(accuracy)

	if randf() > acc:
		Events.joke_miss.emit()
		Events.set_debug_message.emit("The joke didn't land")
		GameState.current_gig.current_joke_failed = true
		if miss_damage > 0.0:
			Events.apply_laughs.emit(-miss_damage, Types.JokeType.VANILLA)
	else:
		Events.joke_land.emit()
		GameState.current_gig.current_joke_failed = false
		Events.set_debug_message.emit("The joke landed")
		for effect in effects:
			await effect.apply(joke_type)
