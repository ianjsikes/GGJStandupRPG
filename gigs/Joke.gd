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
	print("JOKE: Executing %s" % joke_name)
	var player: GigPlayer = N.get_ancestor(self, GigPlayer)
	var acc = player.get_modded_accuracy(accuracy)

	if randf() > acc:
		# You missed!
		Events.joke_miss.emit()
		print("you missed!")
		Events.set_debug_message.emit("Joke %s missed!" % joke_name)
		if miss_damage > 0.0:
			Events.apply_laughs.emit(-miss_damage)
	else:
		Events.joke_land.emit()
		print("you hit!")
		Events.set_debug_message.emit("Joke %s hit!" % joke_name)
		for effect in effects:
			await effect.apply()
