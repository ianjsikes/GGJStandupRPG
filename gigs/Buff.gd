extends Node
class_name Buff

@export var timer: int = -1
@export var counter: int = 0

@export var is_debuff: bool = false
@export var is_from_crowd: bool = false

@export var defense_flat: int = 0
@export var attack_flat: int = 0
@export var accuracy_flat: int = 0

@export var defense_mult: float = 0.0
@export var attack_mult: float = 0.0
@export var accuracy_mult: float = 0.0


func get_mods():
	return {
		"defense_flat": defense_flat,
		"attack_flat": attack_flat,
		"accuracy_flat": accuracy_flat,
		"defense_mult": defense_mult,
		"attack_mult": attack_mult,
		"accuracy_mult": accuracy_mult,
		[name]: counter,
	}


func _ready():
	Events.round_end.connect(_buff_tick)


func _buff_tick():
	if timer > -1:
		timer -= 1

	if timer == 0:
		# TODO: Remove buff
		queue_free()
