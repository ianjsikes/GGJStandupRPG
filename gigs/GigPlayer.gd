extends Node
class_name GigPlayer

const ACCURACY_GAIN_PER_STAT_POINT = 0.05
const LAUGH_ATTACK_MULTIPLIER = 0.2
const LAUGH_DEFENSE_MULTIPLIER = 0.2

var defense_stat: int = 10
var attack_stat: int = 10
var accuracy_stat: int = 10

var current_mods = {
	"defense_flat": 0,
	"attack_flat": 0,
	"accuracy_flat": 0,
	"defense_mult": 0.0,
	"attack_mult": 0.0,
	"accuracy_mult": 0.0,
}

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
	var stat = float(attack_stat)
	stat += current_mods["attack_flat"]

	stat = stat * (1 + current_mods["attack_mult"])
	return base_laughs * ((stat * LAUGH_ATTACK_MULTIPLIER) - 1)


func get_modded_defense(base_laughs: float):
	var stat = float(defense_stat)
	stat += current_mods["defense_flat"]

	stat = stat * (1 + current_mods["defense_mult"])
	return base_laughs / ((stat * LAUGH_DEFENSE_MULTIPLIER) - 1)


func get_modded_accuracy(base_accuracy: float):
	var stat = float(accuracy_stat)
	stat += current_mods["accuracy_flat"]

	stat = stat * (1 + current_mods["accuracy_mult"])

	return base_accuracy + (stat - 10.0) * ACCURACY_GAIN_PER_STAT_POINT


func _reduce_buffs():
	var all_mods = {
		"defense_flat": 0,
		"attack_flat": 0,
		"accuracy_flat": 0,
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


func _on_round_start():
	_reduce_buffs()


func _on_buff_new(new_buff: Buff):
	for buff in buffs:
		if buff.name == new_buff.name:
			# TODO: Merge buffs instead of creating duplicate
			return

	$Buffs.add_child(new_buff)
