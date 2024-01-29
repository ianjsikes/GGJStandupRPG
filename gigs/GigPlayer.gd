@tool
extends Node
class_name GigPlayer

var defense_stat: int = 10
var attack_stat: int = 10
var accuracy_stat: int = 10

var current_mods = {
	"defense_mult": 0.0,
	"attack_mult": 0.0,
	"accuracy_mult": 0.0,
}

@onready var sprites: MoodSwitcher = $Sprites

var buffs: Array[Buff]:
	get:
		var result: Array[Buff]
		result.assign(N.get_all_children(self, Buff))
		return result

var jokes: Array[Joke]:
	get:
		var result: Array[Joke]
		result.assign(N.get_all_children(self, Joke))
		return result


func execute_joke(joke_name: String):
	for joke in jokes:
		if joke.joke_name == joke_name:
			await joke.execute()
			break
	Events.player_end_turn.emit()


func get_modded_laughs(base_laughs: float):
	var mod = float(attack_stat) / 10.0
	mod *= 1 + current_mods["attack_mult"]
	return base_laughs * mod


func get_modded_defense(base_laughs: float):
	var mod = float(defense_stat) / 10.0
	mod *= 1 + current_mods["defense_mult"]
	return base_laughs / mod


func get_modded_accuracy(base_accuracy: float):
	var mod = float(accuracy_stat) / 10.0
	mod *= 1 + current_mods["accuracy_mult"]
	return base_accuracy * mod


func _reduce_buffs():
	var all_mods = {
		"defense_mult": 0.0,
		"attack_mult": 0.0,
		"accuracy_mult": 0.0,
	}

	for buff in buffs:
		var mods = buff.get_mods()
		for mod in mods:
			if !all_mods.has(mod):
				all_mods[mod] = 0
			all_mods[mod] += mods[mod]

	current_mods = all_mods


func _ready():
	Events.round_start.connect(_on_round_start)
	Events.buff_new.connect(_on_buff_new)
	Events.joke_land.connect(_on_joke_land)
	Events.joke_miss.connect(_on_joke_miss)
	Events.buff_added.connect(_on_buff_added)

	defense_stat = GameState.defense_stat
	attack_stat = GameState.attack_stat
	accuracy_stat = GameState.accuracy_stat

	for joke_scene in GameState.joke_set:
		$Jokes.add_child(joke_scene.instantiate())


func _on_round_start():
	sprites.current_mood = "Neutral"
	_reduce_buffs()


func _on_buff_added(_buff):
	_reduce_buffs()


func _on_joke_land():
	sprites.current_mood = "Happy"


func _on_joke_miss():
	sprites.current_mood = "Sad"


func _on_buff_new(new_buff: Buff):
	for buff in buffs:
		if buff.name == new_buff.name:
			if buff.timed:
				buff.counter = new_buff.counter
			else:
				buff.counter += new_buff.counter
			Events.buff_update.emit(buff)
			return

	$Buffs.add_child(new_buff)
