extends Node
class_name Buff

@export var timer: int = -1
@export var counter: int = 1

@export var is_debuff: bool = false
@export var is_from_crowd: bool = false

@export var defense_flat: int = 0
@export var attack_flat: int = 0
@export var accuracy_flat: int = 0

@export var defense_mult: float = 0.0
@export var attack_mult: float = 0.0
@export var accuracy_mult: float = 0.0

@export var buff_indicator_scene: PackedScene


func get_mods():
	return {
		"defense_flat": defense_flat * counter,
		"attack_flat": attack_flat * counter,
		"accuracy_flat": accuracy_flat * counter,
		"defense_mult": defense_mult * counter,
		"attack_mult": attack_mult * counter,
		"accuracy_mult": accuracy_mult * counter,
		[name]: counter,
	}


func _ready():
	Events.round_end.connect(_buff_tick)
	call_deferred("_setup_buff")


func _setup_buff():
	print("Buff _setup_buff")
	Events.buff_added.emit(self)


func _buff_tick():
	if timer > -1:
		timer -= 1

	if timer == 0:
		queue_free()

	Events.buff_update.emit(self)
