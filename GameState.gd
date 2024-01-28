extends Node

var gig_player: GigPlayer = null
var current_gig: Gig = null
@export var max_level: int = 1

var max_set_size: int = 4

@export var joke_set: Array[PackedScene] = []
@export var joke_pool: Array[PackedScene] = []
@export var joke_pool_unlock_one: Array[PackedScene] = []
@export var joke_pool_unlock_two: Array[PackedScene] = []
@export var joke_pool_unlock_three: Array[PackedScene] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	if max_level >= 1:
		joke_pool.append_array(joke_pool_unlock_one)
	if max_level >= 2:
		joke_pool.append_array(joke_pool_unlock_two)
	if max_level >= 3:
		joke_pool.append_array(joke_pool_unlock_three)
