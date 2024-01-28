extends Node
class_name Buff

@export var counter: int = 1
@export var timed: bool = false

@export var is_debuff: bool = false
@export var is_from_crowd: bool = false

@export var defense_mult: float = 0.0
@export var attack_mult: float = 0.0
@export var accuracy_mult: float = 0.0

@export var buff_icon: Texture2D
@export_multiline var buff_tooltip: String


func get_mods():
	return {
		"defense_mult": defense_mult * counter if !timed else defense_mult,
		"attack_mult": attack_mult * counter if !timed else attack_mult,
		"accuracy_mult": accuracy_mult * counter if !timed else accuracy_mult,
		[name]: counter,
	}


func _ready():
	Events.round_end.connect(_buff_tick)
	call_deferred("_setup_buff")


func _setup_buff():
	print("Buff _setup_buff")
	Events.buff_added.emit(self)


func _buff_tick():
	if timed:
		counter -= 1

	if counter == 0:
		queue_free()

	Events.buff_update.emit(self)
