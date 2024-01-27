extends Container

@export var joke_card_scene: PackedScene


func _ready():
	Events.gig_begin.connect(_initialize_moves)


func _initialize_moves():
	for joke in GameState.gig_player.jokes:
		var joke_card: JokeCard = joke_card_scene.instantiate()
		add_child(joke_card)
		joke_card.setup(joke)
